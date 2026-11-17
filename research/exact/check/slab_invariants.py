#!/usr/bin/env python3
"""slab_invariants.py WORD... -- writhe and rotation number of the projection (x + a z, y + b z)
of a lattice polygon (a, b small, generic), for studying BFACF classes in a slab."""
import math, sys
D = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
A, B = 0.31, 0.17


def proj(w):
    p = [(0, 0, 0)]
    for c in w[:-1]:
        d = D[c]; q = p[-1]; p.append((q[0] + d[0], q[1] + d[1], q[2] + d[2]))
    return p


def inv(w):
    P = proj(w); n = len(P)
    Q = [(x + A * z, y + B * z, z) for x, y, z in P]
    # rotation number: total turning of the projected polygon / 2 pi
    tot = 0.0
    for i in range(n):
        a, b, c = Q[i - 1], Q[i], Q[(i + 1) % n]
        u = (b[0] - a[0], b[1] - a[1]); v = (c[0] - b[0], c[1] - b[1])
        tot += math.atan2(u[0] * v[1] - u[1] * v[0], u[0] * v[0] + u[1] * v[1])
    rot = round(tot / (2 * math.pi))
    # writhe: signed crossings of non-adjacent edges
    wr = 0
    for i in range(n):
        p1, p2 = Q[i], Q[(i + 1) % n]
        for j in range(i + 2, n):
            if i == 0 and j == n - 1:
                continue
            q1, q2 = Q[j], Q[(j + 1) % n]
            r = (p2[0] - p1[0], p2[1] - p1[1]); s = (q2[0] - q1[0], q2[1] - q1[1])
            den = r[0] * s[1] - r[1] * s[0]
            if abs(den) < 1e-12:
                continue
            t = ((q1[0] - p1[0]) * s[1] - (q1[1] - p1[1]) * s[0]) / den
            u = ((q1[0] - p1[0]) * r[1] - (q1[1] - p1[1]) * r[0]) / den
            if 0 < t < 1 and 0 < u < 1:
                zi = p1[2] + t * (p2[2] - p1[2]); zj = q1[2] + u * (q2[2] - q1[2])
                sign = 1 if den > 0 else -1          # orientation of (edge i, edge j)
                wr += sign if zi > zj else -sign
    return wr, rot


if __name__ == '__main__':
    for w in sys.argv[1:]:
        wr, rot = inv(w)
        print(len(w), 'writhe', wr, 'rot', rot, 'wr+rot', wr + rot, 'wr-rot', wr - rot, w)
