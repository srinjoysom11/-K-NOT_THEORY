#!/usr/bin/env python3
"""
arcslab_glue.py W L1 L2 [--out FILE] -- all polygons in the W-slab made of a knotted L1-edge arc
and a knotted L2-edge arc on the two sides of a twice-crossed wall.

Input: out/arcslab/w<W>_L<L>.left (closures that unknot_cert could not shrink; the first L
letters are the arc). Coordinates of arcslab.cpp: wall between the levels z = 0 and z = -1,
slab direction y (0 <= y <= W), x free. The enumeration lists one arc of each x-mirror pair,
so the x-mirror of every arc is added here.

For each pair (a, c) of knotted arcs with the same end points in the wall (after a translation
in x), the polygon is a, the edge from B down to B - e_z, the reflection of c in the wall
(z -> -1 - z) from B - e_z back to A - e_z, and the edge up to A. It has L1 + L2 + 2 edges and
knot type [C(a)] # [C(c)]^mirror... computed directly by identify6 rather than by the rule.
The polygons are rewritten in slab coordinates (x_slab = z, y_slab = x, z_slab = y), closed
under the 16 symmetries of the slab and counted up to translation, by knot type.
(The pair rule of arcslab_pairs.py is thus checked as well.)
"""
import argparse
import collections
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, '..'))
import identify6 as i6                                              # noqa: E402
from crosscheck import canon, group, apply_g, word_to_verts, verts_to_word, is_closed_saw  # noqa: E402

STEP = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
LET = {v: k for k, v in STEP.items()}


def arcs_of(W, L):
    """Knotted arcs with L edges as vertex lists (absolute y, x of start = 0), with x-mirrors."""
    path = os.path.join(HERE, '..', 'out', 'arcslab', f'w{W}_L{L}.left')
    out = []
    for line in open(path):
        f = line.split()
        if len(f) != 2:
            continue
        word = f[1]
        if i6.classify(word, True)[2] == '0_1':
            continue
        v = [(0, 0, 0)]
        for ch in word[:L]:
            d = STEP[ch]; q = v[-1]; v.append((q[0] + d[0], q[1] + d[1], q[2] + d[2]))
        assert v[-1][2] == 0
        # arcslab starts at y0 in 0..W; the word does not carry y0, so place the arc at every
        # admissible height (the enumeration contains all of them)
        ys = [p[1] for p in v]
        for y0 in range(-min(ys), W - max(ys) + 1):
            a = [(x, y + y0, z) for x, y, z in v]
            out.append(a)
            out.append([(-x, y, z) for x, y, z in a])
    return out


def key(a):
    A, B = a[0], a[-1]
    return (A[1], B[0] - A[0], B[1])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('W', type=int)
    ap.add_argument('L1', type=int)
    ap.add_argument('L2', type=int)
    ap.add_argument('--out', default=None)
    a = ap.parse_args()
    A1 = arcs_of(a.W, a.L1)
    A2 = arcs_of(a.W, a.L2) if a.L2 != a.L1 else A1
    by = collections.defaultdict(list)
    for c in A2:
        by[key(c)].append(c)
        r = c[::-1]                                   # the same arc traversed backwards
        by[key(r)].append(r)
    print(f'knotted arcs (with mirrors and heights): L={a.L1}: {len(A1)}, L={a.L2}: {len(A2)}')
    polys = set()
    for p in A1:
        for c in by.get(key(p), []):
            dx = p[0][0] - c[0][0]
            cc = [(x + dx, y, -1 - z) for x, y, z in c]          # reflected, translated
            verts = p + cc[::-1]                                  # A..B, then B-e_z .. A-e_z
            if len(set(verts)) != len(verts):
                continue
            w = ''.join(LET[tuple(verts[(i + 1) % len(verts)][k] - verts[i][k] for k in range(3))]
                        for i in range(len(verts)))
            polys.add(canon(w))
    print(f'glued polygons (arcslab coordinates, up to translation): {len(polys)}')
    G16 = [g for g in group() if g[0][2] == 2]
    allp = {}
    for w in polys:
        vs = [(z, x, y) for x, y, z in word_to_verts(w)]          # to slab coordinates
        for g in G16:
            allp[canon(verts_to_word(apply_g(g, vs)))] = 1
    tally = collections.Counter()
    types = {}
    for w in allp:
        assert is_closed_saw(w)
        v = i6.classify(w, True)[2]
        types[w] = v
        tally[v] += 1
    print(f'polygons in the {a.W}-slab with length {a.L1 + a.L2 + 2} (16 symmetries, up to translation): {len(allp)}')
    for v, c in sorted(tally.items()):
        print(f'  {v}: {c}')
    if a.out:
        with open(a.out, 'w') as f:
            for w in sorted(allp):
                f.write(f'{types[w]} {w}\n')


if __name__ == '__main__':
    main()
