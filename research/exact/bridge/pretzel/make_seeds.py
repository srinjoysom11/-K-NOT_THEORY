import warnings; warnings.filterwarnings('ignore')
import sys
sys.path.insert(0, '/home/user/-K-NOT_THEORY/research/code')
sys.path.insert(0, '/home/user/-K-NOT_THEORY/code')
from build_pretzels import KNOTS, build, alex
import seeds, latticeknot as lk
out = open('seeds.tsv', 'w')
for name, r, ps in KNOTS:
    L = build(ps)
    w = seeds.link_to_word(L)
    verts = lk.word_to_vertices(w)
    ok = lk.is_lattice_polygon([verts])
    print(name, 'seed_len', len(w), 'selfavoid_closed', ok, flush=True)
    out.write(f'{name}\t{r}\t{len(L.crossings)}\t{len(w)}\t{w}\n')
out.close()
