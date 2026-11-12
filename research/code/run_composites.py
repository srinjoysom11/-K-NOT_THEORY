"""
run_composites.py -- BFACF annealing for connected sums of trefoils (3_1)^n.

  py -3.12 research/code/run_composites.py --n 2 3 4 5 6 7 8 9 10 --tag trefoil_sums

Seed: spherogram connected sum of n copies of the diagram 3_1 (same chirality),
embedded by seeds.link_to_word. Certificate of knot type: the seed is a connected
sum by construction and BFACF moves preserve knot type. SnapPy cannot name composite
knots (they are not hyperbolic), so the only independent check on the final word is
elementary and necessary-but-not-sufficient: Alexander polynomial = (t^2 - t + 1)^n.
"""
import argparse
import csv
import os
import sys
from concurrent.futures import ThreadPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', '..', 'code'))
sys.path.insert(0, HERE)
import spherogram  # noqa: E402
import latticeknot as lk  # noqa: E402
import seeds as sd  # noqa: E402
import run_search as rs  # noqa: E402
from alexander import alexander  # noqa: E402

LIT = {1: (24, 'Diao93 (proved)'), 2: (40, 'JvRR11'), 3: (56, 'JvRR11'), 4: (72, 'JvRR11'), 5: (88, 'JvRR11'),
       6: (104, 'JvRR11'), 7: (124, 'JvRP95'), 8: (140, 'JvRP95'), 9: (158, 'JvRP95'), 10: (174, 'JvRP95')}


def polymul(a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--n', type=int, nargs='+', required=True)
    p.add_argument('--rounds', type=int, default=3)
    p.add_argument('--runs', type=int, default=8)
    p.add_argument('--cycles', type=int, default=100)
    p.add_argument('--nhigh', type=int, default=100000)
    p.add_argument('--nlow', type=int, default=60000)
    p.add_argument('--zmax', type=float, default=0.2)
    p.add_argument('--zlow', type=float, default=0.02)
    p.add_argument('--base', type=int, default=0)
    p.add_argument('--workers', type=int, default=9)
    p.add_argument('--tag', required=True)
    a = p.parse_args()

    seed_of = {}
    for n in a.n:                      # SnapPy's database is not thread-safe: build seeds here
        L = spherogram.Link('3_1')
        for _ in range(n - 1):
            L = L.connected_sum(spherogram.Link('3_1'))
        seed_of[n] = sd.link_to_word(L)

    def work(n):
        seed = seed_of[n]
        best, chain = seed, []
        for rd in range(1, a.rounds + 1):
            res = [(rs.anneal(best, a.base + rd * 1000 + i, a), a.base + rd * 1000 + i) for i in range(1, a.runs + 1)]
            w, r = min(res, key=lambda t: (len(t[0]), t[1]))
            if len(w) < len(best):
                best = w
                chain.append(f'{rd}:{r}')
        return n, seed, best, chain

    def check(n, seed, best):
        want = [1]
        for _ in range(n):
            want = polymul(want, [1, -1, 1])
        v = lk.word_to_vertices(best)
        return (lk.is_lattice_polygon([v]) and alexander(lk.pd_code([v])) == want
                and alexander(lk.pd_code([lk.word_to_vertices(seed)])) == want)

    out = os.path.join(HERE, '..', 'out', f'{a.tag}.csv')
    with open(out, 'w', newline='') as f, ThreadPoolExecutor(a.workers) as ex:
        wr = csv.writer(f)
        wr.writerow(['n', 'seed_length', 'best_length', 'pattern_24+16(n-1)', 'literature_bound', 'literature_source',
                     'polygon_and_alexander_ok', 'chain', 'seed_word', 'word'])
        for n, seed, best, chain in ex.map(work, a.n):
            ok = check(n, seed, best)
            wr.writerow([n, len(seed), len(best), 24 + 16 * (n - 1), LIT[n][0], LIT[n][1], ok, ' '.join(chain), seed, best])
            f.flush()
            print(n, len(seed), len(best), 24 + 16 * (n - 1), LIT[n], ok, flush=True)


if __name__ == '__main__':
    main()
