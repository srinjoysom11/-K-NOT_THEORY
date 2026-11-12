"""
seed_compare.py -- summarise the diagram-seed vs grid-seed benchmark.

  python finer_research/code/seed_compare.py

Reads finer_research/out/bench/seed_compare_raw.txt (lines: label knot seed hit_attempts best trace)
written by research/code/bench.cpp, and prints / writes a per-knot table of solved runs with
95% Wilson intervals on the pooled counts. Same method, budget and RNG seeds for both labels;
only the starting polygon differs.
"""
import collections, math, os
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..', 'out', 'bench')


def wilson(k, n, z=1.96):
    p = k / n
    d = 1 + z * z / n
    c = p + z * z / (2 * n)
    h = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n))
    return (c - h) / d, (c + h) / d


def main():
    runs = collections.defaultdict(list)
    for line in open(os.path.join(OUT, 'seed_compare_raw.txt')):
        p = line.split()
        runs[(p[0], p[1])].append(int(p[3]))
    labels = sorted({k[0] for k in runs})
    knots = []
    for k in runs:
        if k[1] not in knots:
            knots.append(k[1])
    S = ['| knot | ' + ' | '.join(f'{l}: solved / runs (median attempts when solved)' for l in labels) + ' |',
         '|---|' + '---|' * len(labels)]
    tot = collections.Counter()
    cnt = collections.Counter()
    for kn in knots:
        cells = []
        for l in labels:
            h = runs.get((l, kn), [])
            ok = sorted(x for x in h if x >= 0)
            tot[l] += len(ok)
            cnt[l] += len(h)
            med = f'{ok[len(ok) // 2] / 1e6:.1f}M' if ok else '-'
            cells.append(f'{len(ok)} / {len(h)} ({med})')
        S.append(f'| {kn} | ' + ' | '.join(cells) + ' |')
    S.append('| **pooled** | ' + ' | '.join(
        f'**{tot[l]} / {cnt[l]}** = {tot[l] / cnt[l]:.3f}, 95% CI [{wilson(tot[l], cnt[l])[0]:.3f}, {wilson(tot[l], cnt[l])[1]:.3f}]'
        for l in labels) + ' |')
    text = '\n'.join(S) + '\n'
    open(os.path.join(OUT, 'seed_compare.md'), 'w').write(text)
    print(text)


if __name__ == '__main__':
    main()
