#!/usr/bin/env python3
"""
slab_witnesses.py FILE L -- check explicit polygons claimed for a slab.

FILE has lines "name length word" (as written by anneal_soft.sh). For each line: the word is a
closed self-avoiding lattice polygon of the stated length, its height (z-extent) is <= L, and
its knot type is the named one: identify_rigorous.best_diagram gives a diagram with c <= 6
crossings, so the knot has crossing number <= 6 and is determined by the Alexander polynomial
among such knots, except granny/square, which are separated by the Kauffman bracket polynomial
f(A) (palindromic for the square knot only). Prints the shortest checked polygon of each type.
"""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..')); sys.path.insert(0, HERE)
import identify6 as i6                      # noqa: E402
import identify_rigorous as ir              # noqa: E402

NAMES = {'3_1': '3_1', '4_1': '4_1', '5_1': '5_1', '5_2': '5_2', '6_1': '6_1', '6_2': '6_2', '6_3': '6_3',
         'granny': '3_1#3_1', 'square': '3_1#-3_1'}


def main():
    path, L = sys.argv[1], int(sys.argv[2])
    best = {}
    bad = 0
    for line in open(path):
        f = line.split()
        if len(f) != 3 or line.startswith('#'):
            continue
        name, n, w = f[0], int(f[1]), f[2]
        ok, why = ir.is_self_avoiding_polygon(w)
        P = [(0, 0, 0)]
        D = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
        for c in w:
            d = D[c]; q = P[-1]; P.append((q[0] + d[0], q[1] + d[1], q[2] + d[2]))
        h = max(p[2] for p in P) - min(p[2] for p in P)
        c, _poly, verdict = i6.classify(w, True)
        v = verdict.rstrip('+-') if not verdict.startswith('3_1#') else verdict.rstrip('+')
        good = ok and len(w) == n and h <= L and c <= 6 and v == NAMES.get(name)
        if not good:
            bad += 1
            print(f'REJECTED {name} {n}: saw={ok} {why} height={h} crossings={c} verdict={verdict}')
            continue
        if name not in best or n < best[name][0]:
            best[name] = (n, w)
    for name in sorted(best, key=lambda k: list(NAMES).index(k)):
        n, w = best[name]
        print(f'{name}\t{n}\theight<={L}\t{w}')
    print(f'{bad} rejected')


if __name__ == '__main__':
    main()
