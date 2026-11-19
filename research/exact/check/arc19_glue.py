#!/usr/bin/env python3
"""
arc19_glue.py -- D5 of DMON_IDEAS.md: all 40-edge polygons made of two knotted 19-edge half-space arcs
glued across a twice-crossed plane.

Input: out/dmon/arc19/part*_64.left (closures of the 19-edge arcs that unknot_cert could not shrink to
the square; the first 19 letters of a word are the arc; arcknot lists the arcs whose first step is e or u).
Half-space z >= 0, start A = origin, end B on the level z = 0.  The closure goes from B down one level, along a
monotone path at z = -1 and up to A.  For two arcs b, c with the same displacement B - A the polygon is
b, the edge B -> B - e_z, the reflection of c in the plane (z -> -1 - z) traversed from B - e_z back to A - e_z,
and the edge up to A: 19 + 19 + 2 = 40 edges.  Its knot type is the connected sum of the two closures, one of
them mirrored; Alexander polynomials multiply.  The arcs are closed under the 8 symmetries of the horizontal plane.

usage: python3 check/arc19_glue.py [--sample 300] [--out FILE]
"""
import argparse, collections, glob, os, random, sys, itertools
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, '..'))
import warnings; warnings.filterwarnings('ignore')
import identify6 as i6
from identify_words import alexander_of
from crosscheck import canon, group, apply_g, word_to_verts, verts_to_word, is_closed_saw

STEP = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
LET = {v: k for k, v in STEP.items()}
L = 19
SYMS = [(sx, sy, sw) for sx in (1, -1) for sy in (1, -1) for sw in (0, 1)]       # signs, swap of x and y


def sym(v, g):
    sx, sy, sw = g
    x, y, z = v
    if sw: x, y = y, x
    return (sx * x, sy * y, z)


def load(parts):
    rows = []
    for f in parts:
        for line in open(f):
            fl = line.split()
            if len(fl) == 2 and fl[0].isdigit():
                rows.append((int(fl[0]), fl[1]))
    return rows


def arc_of(word):
    v = [(0, 0, 0)]
    for ch in word[:L]:
        d = STEP[ch]; q = v[-1]; v.append((q[0] + d[0], q[1] + d[1], q[2] + d[2]))
    assert v[-1][2] == 0 and all(p[2] >= 0 for p in v)
    return v


def poly_key(p):
    p = list(p)
    if p and p[-1] < 0: p = [-c for c in p]
    return min(tuple(p), tuple(p[::-1]))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--sample', type=int, default=300)
    ap.add_argument('--out', default=None)
    ap.add_argument('--seed', type=int, default=1)
    a = ap.parse_args()
    parts = sorted(glob.glob(os.path.join(HERE, '..', 'out', 'dmon', 'arc19', 'part*_64.left')))
    rows = load(parts)
    print(f'parts read: {len(parts)}; unresolved closures: {len(rows)}; lengths reached: {dict(collections.Counter(r[0] for r in rows))}')
    # one entry per arc, with the knot type of its closure
    arcs = {}
    for ln, w in rows:
        v = tuple(arc_of(w))
        arcs[v] = w
    types = {}
    for v, w in arcs.items():
        types[v] = i6.classify(w, True)[2]
    print('closure types of the distinct listed arcs:', dict(collections.Counter(types.values())))
    # all 8 symmetric images (a reflection of the plane mirrors the knot type of the closure)
    def mirror(t):
        return t[:-1] + ('-' if t.endswith('+') else '+') if t.endswith(('+', '-')) and t.startswith('3_1') and '#' not in t else t
    allarcs = {}
    for v, w in arcs.items():
        for g in SYMS:
            det = g[0] * g[1] * (-1 if g[2] else 1)
            img = tuple(sym(p, g) for p in v)
            allarcs[img] = types[v] if det > 0 else mirror(types[v])
    print(f'distinct arcs with the 8 horizontal symmetries: {len(allarcs)}')
    by = collections.defaultdict(list)
    for v in allarcs:
        by[(v[-1][0], v[-1][1])].append(v)
    print('displacement classes:', len(by), ' largest sizes:', sorted((len(x) for x in by.values()), reverse=True)[:10])
    allpairs = [(b, c) for g in by.values() for b in g for c in g]
    print('ordered pairs (glued polygons before identifying equal ones):', len(allpairs))

    def glue(b, c):
        cc = [(x, y, -1 - z) for (x, y, z) in c]
        verts = list(b) + cc[::-1]
        assert len(verts) == 2 * (L + 1) == len(set(verts))
        return ''.join(LET[tuple(verts[(i + 1) % len(verts)][k] - verts[i][k] for k in range(3))] for i in range(len(verts)))

    # the knot type of a glued polygon from the types of the two closures: found from a sample by direct identification,
    # checked to be a function of the pair of closure types
    rng = random.Random(a.seed)
    sample = rng.sample(allpairs, min(a.sample, len(allpairs)))
    rule = collections.defaultdict(collections.Counter)
    for b, c in sample:
        w = glue(b, c)
        assert is_closed_saw(w)
        rule[(allarcs[b], allarcs[c])][i6.classify(w, True)[2]] += 1
    print('rule found from', len(sample), 'directly identified glued polygons: (type of b, type of c) -> type of the glued polygon')
    ok = True
    for k, cn in sorted(rule.items()):
        print('  ', k, '->', dict(cn))
        if len(cn) != 1: ok = False
    print('rule is a function of the two closure types:', ok)
    tally = collections.Counter()
    for b, c in allpairs:
        r = rule.get((allarcs[b], allarcs[c]))
        tally[next(iter(r)) if r and len(r) == 1 else 'UNKNOWN'] += 1
    print('all ordered pairs by knot type:', dict(tally))
    if a.out:
        with open(a.out, 'w') as f:
            seen = {}
            for b, c in allpairs:
                w = glue(b, c)
                k = canon(w)
                if k not in seen:
                    r = rule.get((allarcs[b], allarcs[c]))
                    seen[k] = next(iter(r)) if r and len(r) == 1 else 'UNKNOWN'
            for k, t in sorted(seen.items()):
                f.write(f'{t} {k}\n')
        print('wrote', len(seen), 'distinct glued polygons (up to translation and reading) to', a.out)


if __name__ == '__main__':
    main()
