# Builds manifest.tsv: knot list for tasks A, B, C with seed words.
# Adapted from ../pretzel/build_pretzels.py and make_seeds.py (same build/alex code).
import warnings; warnings.filterwarnings('ignore')
import sys, json, itertools, csv
sys.path.insert(0, '/home/user/-K-NOT_THEORY/research/code')
sys.path.insert(0, '/home/user/-K-NOT_THEORY/research/exact')
sys.path.insert(0, '/home/user/-K-NOT_THEORY/code')
import spherogram, seeds, latticeknot as lk
from alexander import alexander

def build(tangles):
    T = spherogram.RationalTangle(*tangles[0])
    for a, b in tangles[1:]:
        T = T + spherogram.RationalTangle(a, b)
    return T.numerator_closure()

def pretzel_tangles(ps):
    return [(1, p) for p in ps]

def alex(L):
    L2 = spherogram.Link(L.PD_code()); L2.simplify('global')
    return alexander([tuple(x) for x in L2.PD_code()])

A = [('P(3,3,-3,-3,2)', [3,3,-3,-3,2]), ('P(3,-3,3,-3,2)', [3,-3,3,-3,2]),
     ('P(3,-3,3,-3,3,-2)', [3,-3,3,-3,3,-2]), ('P(-3,-3,3,2)', [-3,-3,3,2])]
B = [('P(3,-3,3,-3,3,-3,3)', [3,-3,3,-3,3,-3,3]), ('P(3,-3,3,-3,3,-3,2)', [3,-3,3,-3,3,-3,2]),
     ('P(3,-3,3,-3,3,-3,3,-2)', [3,-3,3,-3,3,-3,3,-2]), ('P(3,3,-3,-3,3,3,-3,-2)', [3,3,-3,-3,3,3,-3,-2])]

# Task C: Montesinos sums of r non-integer rational tangles
FR = [(1,2),(1,3),(2,3),(2,5),(3,5),(1,4),(3,4)]
TANG = [(s*a, b) for a, b in FR for s in (1, -1)]
SIMPLE = {(1,2),(-1,2),(1,3),(-1,3)}   # pretzel columns 2 or 3 (signed)

def tname(t):
    return f'{t[0]}/{t[1]}'

def pick_montesinos(r, n_keep=6):
    nc = {t: len(build([t]).crossings) for t in TANG}
    combos = []
    for c in itertools.combinations_with_replacement(range(len(TANG)), r):
        ts = [TANG[i] for i in c]
        if all(t in SIMPLE for t in ts):
            continue
        combos.append((sum(nc[t] for t in ts), c))
    combos.sort()
    out = []
    for tot, c in combos:
        ts = [TANG[i] for i in c]
        L = build(ts)
        if len(L.link_components) != 1:
            continue
        if len(L.crossings) != tot:
            print('WARNING crossing mismatch', ts, len(L.crossings), tot, flush=True)
        name = 'M[' + ','.join(tname(t) for t in ts) + ']'
        out.append((name, ts, tot))
        if len(out) == n_keep:
            break
    return out

if __name__ == '__main__':
    rows = []
    for name, ps in A:
        rows.append((name, 'A', len(ps), pretzel_tangles(ps)))
    for name, ps in B:
        rows.append((name, 'B', len(ps), pretzel_tangles(ps)))
    for r in (4, 5):
        for name, ts, tot in pick_montesinos(r):
            print('C-pick', r, name, 'crossings', tot, flush=True)
            rows.append((name, 'C', r, ts))
    with open('manifest.tsv', 'w') as f:
        f.write('name\tgroup\tr\tbound\tcrossings\tcomponents\ttangles\tseedlen\tseedword\n')
        for name, grp, r, ts in rows:
            L = build(ts)
            ncomp = len(L.link_components)
            w = seeds.link_to_word(L)
            verts = lk.word_to_vertices(w)
            ok = lk.is_lattice_polygon([verts]) and len(verts) == len(w)
            print(name, grp, 'r', r, 'comps', ncomp, 'cross', len(L.crossings),
                  'expected', sum(abs(p) for p in [t[1] for t in ts]) if all(t[0]==1 for t in ts) else 'na',
                  'seedlen', len(w), 'selfavoid_closed', ok, flush=True)
            assert ok
            f.write(f'{name}\t{grp}\t{r}\t{16*r-8}\t{len(L.crossings)}\t{ncomp}\t{json.dumps(ts)}\t{len(w)}\t{w}\n')
