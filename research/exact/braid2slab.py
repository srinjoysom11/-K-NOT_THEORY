#!/usr/bin/env python3
"""
braid2slab.py -- a lattice polygon in the 1-slab (levels z = 0, 1) for the closure of a braid.

    python3 braid2slab.py "1,1,2,-1,-3,2,-3"      -> prints one closed word

Strand j runs east along the row y = 2j in level 0. A generator +i or -i (strands i and i+1,
counted from 1) is a block of width 4: the strand going from row 2(i-1) to row 2i and the one
going back exchange rows; the strand that passes over climbs to level 1 for the block
(+i: the one moving north is over; -i: the one moving south is over). The closure is a family of
nested loops in level 0 around the east, north and west sides. The word is checked to be closed
and self-avoiding. The result is a starting point for bfacf_slab (it is long, not short).
"""
import sys


def build(braid):
    k = max(abs(g) for g in braid) + 1
    paths = {j: [(0, 2 * j, 0)] for j in range(k)}   # path of the strand currently in row j
    owner = list(range(k))                            # owner[row] = strand index
    strands = {j: [(0, 2 * j, 0)] for j in range(k)}
    x = 0
    for g in braid:
        i = abs(g)                                   # rows i-1 and i (0-based) exchange
        lo, hi = i - 1, i
        a, b = owner[lo], owner[hi]                  # a moves north, b moves south
        y0, y1 = 2 * lo, 2 * hi
        north_over = g > 0
        over_n = [(x + 1, y0, 0), (x + 1, y0, 1), (x + 2, y0, 1), (x + 2, y0 + 1, 1), (x + 2, y1, 1),
                  (x + 3, y1, 1), (x + 3, y1, 0), (x + 4, y1, 0)]
        under_s = [(x + 1, y1, 0), (x + 2, y1, 0), (x + 2, y1 - 1, 0), (x + 2, y0, 0), (x + 3, y0, 0), (x + 4, y0, 0)]
        over_s = [(x + 1, y1, 0), (x + 1, y1, 1), (x + 2, y1, 1), (x + 2, y1 - 1, 1), (x + 2, y0, 1),
                  (x + 3, y0, 1), (x + 3, y0, 0), (x + 4, y0, 0)]
        under_n = [(x + 1, y0, 0), (x + 2, y0, 0), (x + 2, y0 + 1, 0), (x + 2, y1, 0), (x + 3, y1, 0), (x + 4, y1, 0)]
        pa, pb = (over_n, under_s) if north_over else (under_n, over_s)
        strands[a] += pa
        strands[b] += pb
        for r in range(k):
            if r != lo and r != hi:
                s = owner[r]
                strands[s] += [(x + t, 2 * r, 0) for t in (1, 2, 3, 4)]
        owner[lo], owner[hi] = b, a
        x += 4
    X = x
    # closure: the strand now in row r goes east to X + (k - r), north to Y_r, west to -(k - r),
    # south to row r, east to 0, where it must meet the start of the strand that started in row r.
    for r in range(k):
        s = owner[r]
        p = strands[s]
        cx, cy = X, 2 * r
        e = k - r
        Y = 2 * k - 2 + 2 * (k - r)
        while cx < X + e: cx += 1; p.append((cx, cy, 0))
        while cy < Y: cy += 1; p.append((cx, cy, 0))
        while cx > -e: cx -= 1; p.append((cx, cy, 0))
        while cy > 2 * r: cy -= 1; p.append((cx, cy, 0))
        while cx < 0: cx += 1; p.append((cx, cy, 0))
        strands[s] = p
    # chain the strands: strand s ends at (0, 2r, 0) = start of strand r
    end_row = {s: owner.index(s) for s in range(k)}
    verts = []
    s = 0
    for _ in range(k):
        verts += strands[s][:-1]
        s = end_row[s]
    if s != 0:
        sys.exit('closure has more than one component')
    if len(set(verts)) != len(verts):
        sys.exit('not self-avoiding')
    L = {(1, 0, 0): 'e', (-1, 0, 0): 'w', (0, 1, 0): 'n', (0, -1, 0): 's', (0, 0, 1): 'u', (0, 0, -1): 'd'}
    w = ''
    for t in range(len(verts)):
        p, q = verts[t], verts[(t + 1) % len(verts)]
        d = (q[0] - p[0], q[1] - p[1], q[2] - p[2])
        if d not in L:
            sys.exit(f'not a lattice step at {t}: {p} -> {q}')
        w += L[d]
    return w


if __name__ == '__main__':
    print(build([int(t) for t in sys.argv[1].split(',')]))
