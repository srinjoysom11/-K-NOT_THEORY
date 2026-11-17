#!/usr/bin/env python3
"""
slab_witnesses8.py FILE L -- check explicit polygons for knots with crossing number <= 8.

FILE has lines "name length word" (anneal_soft.sh); names are Rolfsen names (3_1 ... 8_21) or
composites written like 3_1#4_1, 3_1#-5_1 (granny = 3_1#3_1, square = 3_1#-3_1 also accepted).
For each line: closed self-avoiding polygon of the stated length and height <= L; a diagram
from identify_rigorous.best_diagram, simplified by SnapPy (any simplification is a sequence of
Reidemeister moves, so the knot type is unchanged); at most 8 crossings remain, so the crossing
number is <= 8; and the fingerprint (Alexander polynomial, Jones polynomial up to mirror image,
research/code/fingerprint.py) equals that of the named knot. The fingerprints of all knots with
crossing number <= 8 (the 35 prime knots 3_1 ... 8_21 and the composites 3_1#3_1, 3_1#-3_1,
3_1#4_1, 3_1#5_1, 3_1#-5_1, 3_1#5_2, 3_1#-5_2, 4_1#4_1) are checked to be pairwise different, so
a match identifies the knot up to mirror image. Polygons are filed under the knot they are
identified as (names in SnapPy's conventions), which for a composite started from a braid
word may be the other chirality combination than the name in FILE.
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..'))
sys.path.insert(0, os.path.join(HERE, '..', '..', 'code'))
import identify_rigorous as ir                 # noqa: E402
import fingerprint as fp                       # noqa: E402
import snappy                                  # noqa: E402

PRIMES = ['3_1', '4_1', '5_1', '5_2', '6_1', '6_2', '6_3'] + [f'7_{i}' for i in range(1, 8)] + \
         [f'8_{i}' for i in range(1, 22)]
COMPOSITES = ['3_1#3_1', '3_1#-3_1', '3_1#4_1', '3_1#5_1', '3_1#-5_1', '3_1#5_2', '3_1#-5_2', '4_1#4_1']
ALIAS = {'granny': '3_1#3_1', 'square': '3_1#-3_1'}


def fprint(pd):
    return fp.fingerprint(pd) if hasattr(fp, 'fingerprint') else (tuple(fp.alexander(pd)),)


def link_of(name):
    parts = name.split('#')
    L = None
    for p in parts:
        m = p.startswith('-')
        K = snappy.Link(p.lstrip('-'))
        if m:
            K = K.mirror()
        L = K if L is None else L.connected_sum(K)
    return L


def table():
    T = {}
    for name in PRIMES + COMPOSITES:
        T[name] = fprint(link_of(name).PD_code())
    vals = list(T.values())
    assert len(set(map(repr, vals))) == len(vals), 'fingerprints of knots to 8 crossings collide'
    return T


def main():
    path, Lmax = sys.argv[1], int(sys.argv[2])
    T = table()
    D = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
    best, bad = {}, 0
    for line in open(path):
        f = line.split()
        if len(f) != 3 or line.startswith('#'):
            continue
        name, n, w = ALIAS.get(f[0], f[0]), int(f[1]), f[2]
        ok, why = ir.is_self_avoiding_polygon(w)
        z = [0]
        for ch in w:
            z.append(z[-1] + D[ch][2])
        h = max(z) - min(z)
        c, verdict = -1, '?'
        if ok:
            _n, pd = ir.best_diagram(w)
            if len(pd) == 0:
                c, verdict = 0, '0_1'
            else:
                K = snappy.Link(pd)
                K.simplify('global')
                c = len(K.crossings)
                if c <= 8:
                    fpk = fprint(K.PD_code()) if c > 0 else None
                    hits = [k for k, v in T.items() if repr(v) == repr(fpk)]
                    verdict = hits[0] if len(hits) == 1 else ('0_1' if c == 0 else '?')
        # the requested name only says which run produced the polygon; it is filed under the knot
        # it is identified as (SnapPy's chirality conventions; the composites 3_1#5_2 and
        # 3_1#-5_2 of a braid start may come out as each other)
        good = ok and len(w) == n and h <= Lmax and verdict in T and (verdict == name or '#' in name)
        name = verdict
        if not good:
            bad += 1
            print(f'REJECTED {f[0]} {n}: saw={ok} {why} height={h} crossings={c} verdict={verdict}')
            continue
        if name not in best or n < best[name][0]:
            best[name] = (n, w)
    order = PRIMES + COMPOSITES
    for name in sorted(best, key=order.index):
        n, w = best[name]
        print(f'{name}\t{n}\theight<={Lmax}\t{w}')
    print(f'{bad} rejected')


if __name__ == '__main__':
    main()
