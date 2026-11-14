import warnings; warnings.filterwarnings('ignore')
import sys, csv, collections
sys.path.insert(0, '/home/user/-K-NOT_THEORY/research/code')
sys.path.insert(0, '/home/user/-K-NOT_THEORY/research/exact')
sys.path.insert(0, '/home/user/-K-NOT_THEORY/code')
from build_pretzels import KNOTS, build, alex
import latticeknot as lk
from identify_words import alexander_of
meta = {l.split('\t')[0]: l.split('\t') for l in open('order.tsv').read().splitlines()}
runs = collections.Counter(); best = {}
for fn in ['runs/raw.tsv', 'runs/raw2.tsv']:
    for name, r, cr, s, out in (l.rstrip('\n').split('\t') for l in open(fn)):
        p = out.split(' ')
        assert p[0] == 'BEST'
        runs[name] += 1
        L, w = int(p[1]), p[2]
        assert len(w) == L, (name, L, len(w))
        if name not in best or L < best[name][0]: best[name] = (L, w)
rows = []
for name, r, ps in KNOTS:
    r = int(r)
    L0 = build(ps)
    L_, w = best[name]
    verts = lk.word_to_vertices(w)
    closed_sa = lk.is_lattice_polygon([verts]) and len(verts) == len(w)
    a_seed = alex(L0); a_best = alexander_of(w)
    alex_ok = (a_seed == a_best) or (a_seed == list(reversed(a_best)))
    vol0 = round(L0.exterior().volume(), 6)
    Lp = lk.to_spherogram([verts])
    volp = round(Lp.exterior().volume(), 6)
    vol_ok = 'yes' if abs(vol0 - volp) < 1e-6 else 'no'
    rows.append(dict(knot=name, r=r, bound=16*r-8, crossings=len(L0.crossings), seed_length=len(seeds_w[name]) if False else None,
                     best_length=L_, slack=L_-(16*r-8), runs=runs[name],
                     alexander_matches='yes' if alex_ok else 'no', volume_matches=vol_ok, best_word=w,
                     _closed=closed_sa, _vol=(vol0, volp), _alex=(a_seed, a_best)))
seedlen = {l.split('\t')[0]: int(l.split('\t')[3]) for l in open('seeds.tsv').read().splitlines()}
with open('results.csv', 'w', newline='') as f:
    cols = ['knot','r','bound','crossings','seed_length','best_length','slack','runs','alexander_matches','volume_matches','best_word']
    wr = csv.writer(f); wr.writerow(cols)
    for d in rows:
        d['seed_length'] = seedlen[d['knot']]
        wr.writerow([d[c] for c in cols])
for d in rows:
    print(d['knot'], d['r'], d['bound'], d['crossings'], d['seed_length'], d['best_length'], d['slack'], d['runs'],
          'closed_sa=%s' % d['_closed'], 'alex=%s %s' % (d['alexander_matches'], d['_alex'][0] if d['alexander_matches']=='yes' else (d['_alex'])),
          'vol=%s %s' % (d['volume_matches'], d['_vol']), flush=True)
