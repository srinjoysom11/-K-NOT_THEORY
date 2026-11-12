"""
grid_seeds.py -- lattice seed polygons from minimal grid diagrams (arc presentations).

  python finer_research/code/grid_seeds.py            # all 801 prime knots, 3..11 crossings

KnotInfo's `grid_notation` lists the marks (column, row) of a grid diagram with
a = arc index columns and rows: two marks per column, two per row.
Construction (cf. [HNO14len] Lemma 4, without the stick-saving step):
  * the vertical segment of column i joins its two marks, placed at height z = 1;
  * the horizontal segment of row j joins its two marks, placed at height z = 0;
  * at every mark a unit z-edge joins the two.
Vertical segments lie in distinct columns and horizontal ones in distinct rows, so the
polygon is self-avoiding, and verticals cross over horizontals as in a grid diagram.
Length = sum of the 2a segment lengths + 2a.

Each seed is verified exactly as the diagram seeds are (research/code/run_search.verify:
SnapPy identification + Alexander polynomial; HFK for torus knots). Mirror images are
accepted, as everywhere in this project (same minimal length).
Output: finer_research/out/grid_seeds.json  {knot: word}
        finer_research/out/grid_seeds.csv   knot, arc_index, grid_seed_length, diagram_seed_length, verified, check
"""
import ast, csv, json, os, sys, warnings
warnings.filterwarnings('ignore')
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..', '..')
sys.path.insert(0, os.path.join(ROOT, 'code'))
sys.path.insert(0, os.path.join(ROOT, 'research', 'code'))
import latticeknot as lk          # noqa: E402
import run_search as rs           # noqa: E402
import seeds as sd                # noqa: E402
from database_knotinfo import link_list  # noqa: E402

KI = {r['name']: r for r in link_list()}
STEP = {v: k for k, v in lk.DIRS.items()}


def ki_name(k):
    return k[1:4] + '_' + k[4:] if k.startswith('K') else k


def grid_to_word(marks):
    cols, rows = {}, {}
    for c, r in marks:
        cols.setdefault(c, []).append(r)
        rows.setdefault(r, []).append(c)
    assert all(len(v) == 2 for v in cols.values()) and all(len(v) == 2 for v in rows.values())
    # walk: mark (c, r) at z=1 --vertical in column c--> other mark of c, drop to z=0,
    #       --horizontal in row--> other mark of that row, rise to z=1, repeat.
    start = tuple(marks[0])
    cur, verts = start, []
    while True:
        c, r = cur
        r2 = [x for x in cols[c] if x != r][0]
        s = 1 if r2 > r else -1
        verts += [(c, y, 1) for y in range(r, r2, s)]
        verts.append((c, r2, 1))
        c2 = [x for x in rows[r2] if x != c][0]
        s = 1 if c2 > c else -1
        verts += [(x, r2, 0) for x in range(c, c2, s)]
        verts.append((c2, r2, 0))
        cur = (c2, r2)
        if cur == start:
            break
    assert lk.is_lattice_polygon([verts]), 'grid seed is not a self-avoiding polygon'
    n = len(verts)
    return ''.join(STEP[tuple(verts[(k + 1) % n][t] - verts[k][t] for t in range(3))] for k in range(n))


def main():
    diag = json.load(open(os.path.join(ROOT, 'research', 'data', 'seeds.json')))
    out, rows = {}, []
    for c in range(3, 12):
        for name, sn in sd.knot_list(c):
            d = KI[ki_name(name)]
            w = grid_to_word(ast.literal_eval(d['grid_notation']))
            ok, how = rs.verify(w, sn)
            out[name] = w
            rows.append([name, d['arc_index'], len(w), len(diag[name]), ok, how])
        print(c, 'crossings done', flush=True)
    json.dump(out, open(os.path.join(ROOT, 'finer_research', 'out', 'grid_seeds.json'), 'w'), indent=0)
    with open(os.path.join(ROOT, 'finer_research', 'out', 'grid_seeds.csv'), 'w', newline='') as f:
        csv.writer(f).writerows([['knot', 'arc_index', 'grid_seed_length', 'diagram_seed_length', 'verified', 'check']] + rows)
    bad = [r for r in rows if not r[4]]
    print('seeds', len(rows), 'verified', len(rows) - len(bad), 'failed', [(r[0], r[5]) for r in bad][:20])
    print('mean length grid', sum(r[2] for r in rows) / len(rows), 'diagram', sum(r[3] for r in rows) / len(rows))


if __name__ == '__main__':
    main()
