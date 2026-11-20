#!/usr/bin/env python3
"""
arc19_witness.py -- cross-check of the glued 40-edge polygons (check/arc19_glue.py --out FILE) against out/witness40.txt.

For every composite witness (3_1#3_1, 3_1#-3_1, ... any witness) and each of its 3 axes: count the edges across every
mid-plane.  If some mid-plane is crossed exactly twice and has at least two occupied levels on each side, the polygon is
of the kind that `-stair` may drop, and then it must appear (up to translation, reading, and the 48 symmetries) among
the glued polygons.  Reports for each witness: such planes, and whether the polygon is in the glued set.

usage: python3 check/arc19_witness.py GLUED_FILE
"""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, '..'))
from crosscheck import canon, group, apply_g, word_to_verts, verts_to_word


def twice_planes(vs):
    n = len(vs); out = []
    for ax in range(3):
        lv = sorted({v[ax] for v in vs})
        for k in range(lv[0], lv[-1]):
            cr = sum(1 for i in range(n) if min(vs[i][ax], vs[(i + 1) % n][ax]) == k and vs[i][ax] != vs[(i + 1) % n][ax])
            below = sum(1 for l in lv if l <= k); above = sum(1 for l in lv if l > k)
            if cr == 2 and below >= 2 and above >= 2:
                out.append((ax, k))
    return out


def main():
    glued = {}
    for line in open(sys.argv[1]):
        f = line.split()
        if len(f) == 2: glued[f[1]] = f[0]
    print('glued polygons:', len(glued))
    G = group()
    for line in open(os.path.join(HERE, '..', 'out', 'witness40.txt')):
        if line.startswith('#') or not line.strip(): continue
        name, w = line.split()
        vs = word_to_verts(w)
        pl = twice_planes(vs)
        found = []
        for g in G:
            c = canon(verts_to_word(apply_g(g, vs)))
            if c in glued: found.append(glued[c]); break
        print(f'{name:10s} twice-crossed planes with two levels on each side: {pl if pl else "none"}; in the glued set: {bool(found)}')


if __name__ == '__main__':
    main()
