#!/usr/bin/env python3
"""
arc_check.py L -- independent enumeration of the arc-closure census, written from the definition.

Walk b: L steps on Z^3 from A=(0,0,0), first step e or u, self-avoiding, all z>=0,
no immediate reversal, no triple (a,c,-a). Last vertex B has z=0 and B != A.
Condition 5: L + |Bx|+|By| >= 22.

Closure C: vertices of b (A..B), then (Bx,By,-1), x-moves at z=-1 to x=0, y-moves to y=0
(ends at (0,0,-1)), then back to A (cyclic). Local maxima per coordinate on the cyclic
vertex sequence, counted per maximal run as defined in the task.
One-bridge: some coordinate has <= 1 local maxima. Printed: all three have >= 2.

Pruning: only "z must still be able to return to 0 in the steps left" (cannot change the
set of walks counted before condition 5). Condition 5 is applied at the leaves.

Usage: python3 arc_check.py L
"""
import collections
import sys
import time

DIRS = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0),
        's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
OPP = {'e': 'w', 'w': 'e', 'n': 's', 's': 'n', 'u': 'd', 'd': 'u'}
ALL = 'ewnsud'
LETTER_OF = {v: k for k, v in DIRS.items()}


def count_local_maxima(vals):
    """Local maxima on a cyclic sequence, runs of equal values as one vertex."""
    n = len(vals)
    if all(v == vals[0] for v in vals):
        return 0
    start = next(i for i in range(n) if vals[i] != vals[i - 1])
    runs = []                          # list of [value, length] in cyclic order
    for j in range(n):
        v = vals[(start + j) % n]
        if runs and runs[-1][0] == v:
            runs[-1][1] += 1
        else:
            runs.append([v, 1])
    m = len(runs)
    cnt = 0
    for t in range(m):
        v = runs[t][0]
        if runs[t - 1][0] < v and runs[(t + 1) % m][0] < v:
            cnt += 1
    return cnt


def closure_vertices(steps, B):
    verts = [(0, 0, 0)]
    x, y, z = 0, 0, 0
    for s in steps:
        dx, dy, dz = DIRS[s]
        x, y, z = x + dx, y + dy, z + dz
        verts.append((x, y, z))
    bx, by, _ = B
    verts.append((bx, by, -1))
    x = bx
    while x != 0:
        x += 1 if x < 0 else -1
        verts.append((x, by, -1))
    y = by
    while y != 0:
        y += 1 if y < 0 else -1
        verts.append((0, y, -1))
    return verts          # cyclic: last vertex (0,0,-1) is followed by A=(0,0,0)


def closure_word(verts):
    n = len(verts)
    out = []
    for i in range(n):
        a, b = verts[i], verts[(i + 1) % n]
        out.append(LETTER_OF[(b[0] - a[0], b[1] - a[1], b[2] - a[2])])
    return ''.join(out)


def main():
    if len(sys.argv) != 2:
        sys.exit('usage: arc_check.py L')
    L = int(sys.argv[1])
    t0 = time.time()

    walks_ending_on_level0 = 0      # conditions 1-4 with z=0 end and B != A
    b_equals_a = 0                  # z=0 closed walks (B == A), excluded by condition 2
    tested = 0
    one_bridge = 0
    printed = 0
    polygon_not_simple = 0
    hist = {'x': collections.Counter(), 'y': collections.Counter(), 'z': collections.Counter()}
    printed_words = []

    visited = {(0, 0, 0)}
    steps = []

    def leaf(x, y, z):
        nonlocal walks_ending_on_level0, b_equals_a, tested, one_bridge, printed, polygon_not_simple
        if (x, y, z) == (0, 0, 0):
            b_equals_a += 1
            return
        walks_ending_on_level0 += 1
        d = abs(x) + abs(y)
        if L + d < 22:
            return
        tested += 1
        B = (x, y, z)
        verts = closure_vertices(steps, B)
        if len(set(verts)) != len(verts):
            polygon_not_simple += 1
        counts = {}
        for ax, name in enumerate('xyz'):
            counts[name] = count_local_maxima([v[ax] for v in verts])
            hist[name][counts[name]] += 1
        if min(counts.values()) <= 1:
            one_bridge += 1
        else:
            printed += 1
            printed_words.append(closure_word(verts))

    def rec(x, y, z, used):
        if used == L:
            if z == 0:
                leaf(x, y, z)
            return
        rem_after = L - used - 1
        letters = 'eu' if used == 0 else ALL
        for s in letters:
            if used >= 1 and s == OPP[steps[-1]]:
                continue                      # immediate reversal
            if used >= 2 and s == OPP[steps[-2]]:
                continue                      # U-turn (a, c, -a)
            dx, dy, dz = DIRS[s]
            nx, ny, nz = x + dx, y + dy, z + dz
            if nz < 0 or nz > rem_after:      # must be able to return to z=0
                continue
            p = (nx, ny, nz)
            if p in visited:
                continue
            visited.add(p)
            steps.append(s)
            rec(nx, ny, nz, used + 1)
            steps.pop()
            visited.discard(p)

    rec(0, 0, 0, 0)
    elapsed = time.time() - t0

    print(f'L={L} walks_ending_on_level0={walks_ending_on_level0} tested={tested} '
          f'one_bridge={one_bridge} printed={printed}')
    print(f'  B==A closed walks excluded by condition 2: {b_equals_a}')
    print(f'  polygons with repeated vertex: {polygon_not_simple}')
    for name in 'xyz':
        h = ' '.join(f'{k}:{v}' for k, v in sorted(hist[name].items()))
        print(f'  maxima {name}: {h}')
    for w in printed_words[:20]:
        print(f'  printed word: {w}')
    print(f'  time {elapsed:.1f}s')


if __name__ == '__main__':
    main()
