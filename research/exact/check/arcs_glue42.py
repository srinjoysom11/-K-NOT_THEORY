#!/usr/bin/env python3
"""
arcs_glue42.py -- n = 42 version of check/arc19_glue.py (D5, DMON_RESULTS.md): knotted half-space arcs with 19, 20, 21 edges, glued
across a twice-crossed plane in the splits (19, 21), (20, 20), (21, 19): 19 + 21 + 2 = 20 + 20 + 2 = 42 edges.

Input: out/dmon/arc19/part*_64.left, arc20/part*_128.left, arc21/part*_256.left (closures that unknot_cert could not shrink to the square;
the first L letters of a word are the arc).  Steps: (1) the knot type of every listed closure (identify6.classify, chirality included; in
parallel, cached in out/dmon/arcL/types.txt); (2) the 8 horizontal symmetries of every arc (a reflection mirrors the type); (3) group by displacement;
(4) for each split and each pair (type of b, type of c) that occurs: count the ordered pairs from the displacement classes and identify the knot type of
SAMPLE glued polygons directly (they must all agree: the rule is then a function of the two closure types); (5) tally the glued types.

usage: python3 check/arcs_glue42.py [--sample 25] [--procs 4]
"""
import argparse, collections, glob, itertools, os, random, sys
from multiprocessing import Pool
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, '..'))
import warnings; warnings.filterwarnings('ignore')
import identify6 as i6
from crosscheck import is_closed_saw

STEP = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
LET = {v: k for k, v in STEP.items()}
SYMS = [(sx, sy, sw) for sx in (1, -1) for sy in (1, -1) for sw in (0, 1)]


def sym(v, g):
    sx, sy, sw = g
    x, y, z = v
    if sw: x, y = y, x
    return (sx * x, sy * y, z)


def det(g): return g[0] * g[1] * (-1 if g[2] else 1)


def mirror(t):
    return t[:-1] + ('-' if t.endswith('+') else '+') if t.endswith(('+', '-')) and '#' not in t else t


def arc_of(word, L):
    v = [(0, 0, 0)]
    for ch in word[:L]:
        d = STEP[ch]; q = v[-1]; v.append((q[0] + d[0], q[1] + d[1], q[2] + d[2]))
    assert v[-1][2] == 0 and all(p[2] >= 0 for p in v)
    return tuple(v)


def classify_word(w):
    try:
        return i6.classify(w, True)[2]
    except Exception as e:  # noqa
        return 'ERROR'


def load(L):
    rows = {}
    for f in sorted(glob.glob(os.path.join(HERE, '..', 'out', 'dmon', f'arc{L}', 'part*.left'))):
        for line in open(f):
            fl = line.split()
            if len(fl) == 2 and fl[0].isdigit():
                rows[fl[1]] = int(fl[0])
    return rows


def types_for(L, rows, procs):
    cache = os.path.join(HERE, '..', 'out', 'dmon', f'arc{L}', 'types.txt')
    known = {}
    if os.path.exists(cache):
        for line in open(cache):
            fl = line.split()
            if len(fl) == 2: known[fl[0]] = fl[1]
    todo = [w for w in rows if w not in known]
    if todo:
        with Pool(procs) as p:
            for w, t in zip(todo, p.imap(classify_word, todo, chunksize=50)):
                known[w] = t
        with open(cache, 'w') as f:
            for w, t in known.items(): f.write(f'{w} {t}\n')
    return {w: known[w] for w in rows}


def glue(b, c, L1, L2):
    cc = [(x, y, -1 - z) for (x, y, z) in c]
    verts = list(b) + cc[::-1]
    assert len(verts) == len(set(verts)) == L1 + L2 + 2
    return ''.join(LET[tuple(verts[(i + 1) % len(verts)][k] - verts[i][k] for k in range(3))] for i in range(len(verts)))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--sample', type=int, default=25); ap.add_argument('--procs', type=int, default=4); ap.add_argument('--seed', type=int, default=1)
    a = ap.parse_args()
    rng = random.Random(a.seed)
    data = {}
    for L in (19, 20, 21):
        rows = load(L)
        ty = types_for(L, rows, a.procs)
        arcs = {}
        for w in rows:
            v = arc_of(w, L); arcs.setdefault(v, ty[w])
        full = {}
        for v, t in arcs.items():
            for g in SYMS:
                full[tuple(sym(p, g) for p in v)] = t if det(g) > 0 else mirror(t)
        by = collections.defaultdict(list)
        for v, t in full.items(): by[(v[-1][0], v[-1][1])].append(v)
        data[L] = (full, by)
        print(f'L={L}: closures listed {len(rows)}, closure types {dict(collections.Counter(ty.values()))}, arcs with symmetries {len(full)}, displacement classes {len(by)}', flush=True)
    for (L1, L2) in ((19, 21), (20, 20), (21, 19)):
        f1, by1 = data[L1]; f2, by2 = data[L2]
        cnt = collections.Counter(); pairs = 0
        for d, l1 in by1.items():
            l2 = by2.get(d, [])
            if not l2: continue
            c1 = collections.Counter(f1[v] for v in l1); c2 = collections.Counter(f2[v] for v in l2)
            for (t1, n1), (t2, n2) in itertools.product(c1.items(), c2.items()):
                cnt[(t1, t2)] += n1 * n2; pairs += n1 * n2
        print(f'split ({L1},{L2}): ordered pairs with equal displacement {pairs}; pairs by (type b, type c): {dict(cnt)}', flush=True)
        if split_is_trivial := (pairs == 0): continue
        rule = {}
        ok = True
        for (t1, t2) in cnt:
            cand = [(b, c) for d, l1 in by1.items() for b in l1 if f1[b] == t1 for c in by2.get(d, []) if f2[c] == t2][:5000]
            picks = rng.sample(cand, min(a.sample, len(cand)))
            res = collections.Counter(i6.classify(glue(b, c, L1, L2), True)[2] for b, c in picks)
            rule[(t1, t2)] = res
            if len(res) != 1: ok = False
        tally = collections.Counter()
        for k, n in cnt.items():
            r = rule[k]
            tally[next(iter(r)) if len(r) == 1 else 'AMBIGUOUS:' + str(dict(r))] += n
        print(f'  rule from {a.sample} directly identified glued polygons per type pair (a function of the pair: {ok}):', flush=True)
        for k, r in rule.items(): print('    ', k, '->', dict(r))
        print(f'  glued polygons (ordered pairs) by knot type, split ({L1},{L2}): {dict(tally)}', flush=True)


if __name__ == '__main__':
    main()
