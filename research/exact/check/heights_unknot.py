#!/usr/bin/env python3
"""
heights_unknot.py -- E3 of the parent's list: how many unknotted survivors are recognised by a generic height function with a single
local maximum (then the polygon is unknotted), and does any knotted word get flagged (it must not)?
Direction sets: the 3 axes; the 13 directions (3 axes, 6 face diagonals, 4 body diagonals); the 13 directions each with
several generic tilts; random directions.  A height function h(v) = <D, v> with D = M*dir + tilt (integers, M large, tilt generic),
local maxima counted on the cyclic vertex sequence (no ties because D has no zero component along a lattice step).

usage: python3 check/heights_unknot.py out/n38_stair.rigorous.txt
"""
import itertools, random, sys, collections
VEC = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}


def verts(word):
    p = (0, 0, 0); v = [p]
    for c in word[:-1]:
        d = VEC[c]; p = (p[0] + d[0], p[1] + d[1], p[2] + d[2]); v.append(p)
    return v


def maxima(h):
    n = len(h)
    return sum(1 for i in range(n) if h[i] > h[i - 1] and h[i] > h[(i + 1) % n])


def dirs13():
    out = [(1, 0, 0), (0, 1, 0), (0, 0, 1)]
    for a, b in itertools.combinations(range(3), 2):
        for s in (1, -1):
            d = [0, 0, 0]; d[a] = 1; d[b] = s; out.append(tuple(d))
    for s1 in (1, -1):
        for s2 in (1, -1):
            out.append((1, s1, s2))
    return out


def main():
    rows = []
    for line in open(sys.argv[1]):
        f = line.split('\t')
        if len(f) >= 5 and f[0].isdigit():
            rows.append((f[3], f[4].strip()))
    print('words:', len(rows), dict(collections.Counter(t for t, _ in rows)))
    rng = random.Random(1)
    M = 1000
    tilts = [(1, 7, 31), (3, 1, 11), (13, 5, 2), (2, 17, 5), (7, 3, 19)]
    sets = {}
    sets['3 axes (-bridge 2 as in enum.cpp, one tilt)'] = [tuple(M * c + t for c, t in zip(d, tilts[0])) for d in dirs13()[:3]]
    sets['13 directions, one tilt'] = [tuple(M * c + t for c, t in zip(d, tilts[0])) for d in dirs13()]
    sets['13 directions x 5 tilts'] = [tuple(M * c + t for c, t in zip(d, tl)) for d in dirs13() for tl in tilts]
    sets['200 random directions'] = [tuple(rng.randint(-1000, 1000) for _ in range(3)) for _ in range(200)]
    res = {k: collections.Counter() for k in sets}
    flagged_nontrivial = {k: 0 for k in sets}
    for typ, w in rows:
        vs = verts(w)
        for k, ds in sets.items():
            hit = False
            for D in ds:
                if maxima([D[0] * p[0] + D[1] * p[1] + D[2] * p[2] for p in vs]) <= 1:
                    hit = True; break
            if hit:
                res[k][typ] += 1
                if typ != '0_1': flagged_nontrivial[k] += 1
    tot0 = sum(1 for t, _ in rows if t == '0_1')
    for k in sets:
        print(f'{k}: unknots recognised {res[k]["0_1"]} of {tot0}; knotted words flagged (must be 0): {flagged_nontrivial[k]}')


if __name__ == '__main__':
    main()
