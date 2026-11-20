#!/usr/bin/env python3
"""
crossings3.py -- D4 of DMON_IDEAS.md, leaf experiment.  For every word of a survivor file, the number of crossings of the
regular diagram obtained by projecting along each of the three axes with a generic small tilt:
(u, v, w) -> (u + eps*w, v + eps^2*w), eps = 1/1000, exact integer arithmetic (coordinates scaled by 10^6).
c(K) <= the number of crossings of every regular diagram, so a polygon of a knot with crossing number >= c0 has >= c0
crossings in each of the three projections.  Reports, for thresholds c0 = 5, 6, 7, how many words have >= c0 crossings in all three.

usage: python3 check/crossings3.py WORDS_FILE [--limit N]
"""
import sys, collections
VEC = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
M = 1000


def verts(word):
    p = (0, 0, 0); v = [p]
    for c in word[:-1]:
        d = VEC[c]; p = (p[0] + d[0], p[1] + d[1], p[2] + d[2]); v.append(p)
    return v


def cross(o, a, b):
    return (a[0] - o[0]) * (b[1] - o[1]) - (a[1] - o[1]) * (b[0] - o[0])


def crossings(vs, axis):
    i1, i2 = [q for q in range(3) if q != axis]
    P = [(M * M * p[i1] + M * p[axis], M * M * p[i2] + p[axis]) for p in vs]
    n = len(P); c = 0; degenerate = 0
    for i in range(n):
        a, b = P[i], P[(i + 1) % n]
        for j in range(i + 2, n):
            if i == 0 and j == n - 1: continue
            cc, d = P[j], P[(j + 1) % n]
            d1, d2, d3, d4 = cross(a, b, cc), cross(a, b, d), cross(cc, d, a), cross(cc, d, b)
            if d1 == 0 or d2 == 0 or d3 == 0 or d4 == 0: degenerate += 1
            if ((d1 > 0) != (d2 > 0)) and ((d3 > 0) != (d4 > 0)): c += 1
    return c, degenerate


def main():
    path = sys.argv[1]
    lim = int(sys.argv[sys.argv.index('--limit') + 1]) if '--limit' in sys.argv else 10 ** 9
    words = [l.split()[-1] for l in open(path) if l.strip() and not l.startswith('#')][:lim]
    hist = collections.Counter(); deg = 0
    ge = {5: 0, 6: 0, 7: 0, 8: 0}
    for w in words:
        vs = verts(w)
        cs = []
        for ax in range(3):
            c, d = crossings(vs, ax); cs.append(c); deg += d
        m = min(cs); hist[m] += 1
        for t in ge:
            if m >= t: ge[t] += 1
    print(f'{path}: {len(words)} words; degenerate pair tests: {deg}')
    print('  distribution of the smallest crossing number over the three projections:', dict(sorted(hist.items())))
    for t, k in ge.items():
        print(f'  >= {t} crossings in all three projections: {k} ({100.0 * k / max(1, len(words)):.1f} %)')


if __name__ == '__main__':
    main()
