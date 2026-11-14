# Exact verification of best words (adapted from ../pretzel/verify.py).
import warnings; warnings.filterwarnings('ignore')
import sys, json, collections
sys.path.insert(0, '/home/user/-K-NOT_THEORY/research/code')
sys.path.insert(0, '/home/user/-K-NOT_THEORY/research/exact')
sys.path.insert(0, '/home/user/-K-NOT_THEORY/code')
import latticeknot as lk
from identify_words import alexander_of
from knotlist import build, alex
import csv as csvmod

man = [l.rstrip('\n').split('\t') for l in open('manifest.tsv')][1:]
prior = {}
for row in csvmod.DictReader(open('/home/user/-K-NOT_THEORY/research/exact/bridge/pretzel/results.csv')):
    prior[row['knot']] = (int(row['best_length']), row['best_word'])
runs = collections.Counter(); best = {}
for line in open('runs/all_runs.tsv'):
    stage, name, seed, sl, L, w = line.rstrip('\n').split('\t')
    runs[name] += 1
    assert len(w) == int(L)
    if name not in best or int(L) < best[name][0]: best[name] = (int(L), w)
rows = []
for m in man:
    name, grp, r, bound, cr, ncomp, ts, seedlen, seedw = m
    r, bound = int(r), int(bound)
    cands = [(len(seedw), seedw)]
    if name in prior: cands.append((prior[name][0], prior[name][1]))
    if name in best: cands.append((best[name][0], best[name][1]))
    L_, w = min(cands, key=lambda x: (x[0], 0))
    verts = lk.word_to_vertices(w)
    closed_sa = bool(lk.is_lattice_polygon([verts]) and len(verts) == len(w))
    L0 = build(json.loads(ts))
    a_seed = alex(L0); a_best = alexander_of(w)
    alex_ok = 'yes' if (a_seed == a_best or a_seed == list(reversed(a_best))) else 'no'
    vol0 = None
    try:
        vol0 = round(L0.exterior().volume(), 6)
        volp = round(lk.to_spherogram([verts]).exterior().volume(), 6)
        vol_ok = 'yes' if abs(vol0 - volp) < 1e-6 else 'no'
    except Exception as e:
        vol_ok = 'na'
    rows.append(dict(knot=name, r=r, bound=bound, crossings=cr, best_length=L_, slack=L_-bound,
                     runs=runs[name], alexander_matches=alex_ok, volume_matches=vol_ok,
                     best_word=w, group=grp, closed_sa=closed_sa))
    print(name, grp, 'r', r, 'bound', bound, 'best', L_, 'slack', L_-bound, 'runs', runs[name],
          'closed_sa', closed_sa, 'alex', alex_ok, 'vol', vol_ok, flush=True)
cols = ['knot','r','bound','crossings','best_length','slack','runs','alexander_matches','volume_matches','best_word']
with open('results.csv', 'w', newline='') as f:
    wr = csvmod.writer(f); wr.writerow(cols)
    for d in rows: wr.writerow([d[c] for c in cols])
