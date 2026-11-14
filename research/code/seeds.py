"""
seeds.py -- build a (long, non-minimal) lattice polygon for a knot from its diagram.

Construction (elementary, checkable by hand on small examples):
  1. spherogram's orthogonal layout draws the diagram with axis-parallel segments
     whose corners and crossings lie on a grid.
  2. Scale the grid by 2 and put the whole diagram in the plane z = 0.
  3. At each crossing point p of the diagram, one of the two strands is lifted to
     z = 1 on the three lattice points p-1, p, p+1 along that strand (odd
     coordinates are never used by any other strand, so nothing collides).
The result is a self-avoiding lattice polygon whose projection to z = 0 is the
diagram (or its mirror image: mirror images have the same minimal length).

Run with the Python that has SnapPy:  py -3.12 research/code/seeds.py
"""
import json
import os
import sys

import spherogram
from spherogram.links.orthogonal import OrthogonalLinkDiagram

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', '..', 'code'))
import latticeknot as lk  # noqa: E402

STEP = {(1, 0, 0): 'e', (-1, 0, 0): 'w', (0, 1, 0): 'n', (0, -1, 0): 's', (0, 0, 1): 'u', (0, 0, -1): 'd'}


def link_to_word(link):
    verts, arrows, crossings = OrthogonalLinkDiagram(link).plink_data()
    xs = sorted({v[0] for v in verts})
    ys = sorted({v[1] for v in verts})
    # compress to consecutive integers, then scale by 2
    V = [(2 * xs.index(x), 2 * ys.index(y)) for x, y in verts]
    lifted = {}
    for c in crossings:
        lifted.setdefault(c[1], []).append(c[0])  # arrow c[1] is lifted where it meets arrow c[0]

    def pts(i):
        (x0, y0), (x1, y1) = V[arrows[i][0]], V[arrows[i][1]]
        dx, dy = (x1 > x0) - (x1 < x0), (y1 > y0) - (y1 < y0)
        assert (dx == 0) != (dy == 0)
        out = [(x0, y0)]
        while out[-1] != (x1, y1):
            out.append((out[-1][0] + dx, out[-1][1] + dy))
        return out

    P = {i: pts(i) for i in range(len(arrows))}
    # order arrows along the knot
    nxt = {a[0]: i for i, a in enumerate(arrows)}
    order, i = [], 0
    while True:
        order.append(i)
        i = nxt[arrows[i][1]]
        if i == 0:
            break
    assert len(order) == len(arrows)
    path = []
    for i in order:
        up = set()
        for j in lifted.get(i, []):
            common = set(P[i]) & set(P[j])
            assert len(common) == 1
            p = common.pop()
            k = P[i].index(p)
            assert 0 < k < len(P[i]) - 1
            up.update((k - 1, k, k + 1))
        for k, (x, y) in enumerate(P[i][:-1]):
            path.append((x, y, 1 if k in up else 0))
    # insert vertical steps where z changes
    full = []
    n = len(path)
    for k in range(n):
        a, b = path[k], path[(k + 1) % n]
        full.append(a)
        if a[2] != b[2]:
            # the vertical step sits at the lifted end (an odd point p-1 or p+1, used by no other strand)
            full.append((b[0], b[1], 0) if a[2] == 0 else (a[0], a[1], 0))
    assert lk.is_lattice_polygon([full]), 'seed is not a self-avoiding polygon'
    m = len(full)
    return ''.join(STEP[tuple(full[(k + 1) % m][t] - full[k][t] for t in range(3))] for k in range(m))


def knot_list(crossings):
    """HT census names K11a1.. via SnapPy; Rolfsen names (KnotInfo numbering) for <= 10."""
    import snappy
    if crossings >= 11:
        names = [M.name() for M in snappy.HTLinkExteriors(knots_vs_links='knots', crossings=crossings)]
        return [(n, n) for n in names]  # (our name, spherogram name)
    out = []
    counts = {3: 1, 4: 1, 5: 2, 6: 3, 7: 7, 8: 21, 9: 49, 10: 165}
    for i in range(1, counts[crossings] + 1):
        # SnapPy's Rolfsen table still has the Perko duplicate: its 10_163..10_166 are KnotInfo 10_162..10_165
        sn = f'{crossings}_{i + 1}' if (crossings == 10 and i >= 162) else f'{crossings}_{i}'
        out.append((f'{crossings}_{i}', sn))
    return out


if __name__ == '__main__':
    out_path = os.path.join(HERE, '..', 'data', 'seeds.json')
    seeds = {}
    for c in range(3, 12):
        for name, sn in knot_list(c):
            w = link_to_word(spherogram.Link(sn))
            seeds[name] = w
        print(c, 'crossings done; total', len(seeds), flush=True)
    json.dump(seeds, open(out_path, 'w'), indent=0)
    L = [len(w) for w in seeds.values()]
    print('seeds:', len(seeds), 'length min/max', min(L), max(L))
