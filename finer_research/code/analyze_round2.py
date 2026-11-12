"""
analyze_round2.py -- merge the deeper 11-crossing search with the first table, verify, summarise.

  python finer_research/code/analyze_round2.py

Inputs
  research/out/c11.csv                        first table (24 runs per knot from diagram seeds)
  finer_research/out/c11_round2_raw.txt       bfacf_batch output started from the words of c11.csv
  finer_research/out/len_vs_invariants.csv    (for arc index)
Outputs
  finer_research/out/table_11_crossings_v2.csv
  finer_research/out/round2_summary.md
Every word that changed is re-verified from scratch (closed self-avoiding polygon, SnapPy
identification, Alexander polynomial) with research/code/run_search.verify.
Certificate of a round-2 word: the chain of c11.csv (from the diagram seed) followed by
  bfacf_batch IN OUT 2 20 100 100000 60000 0.2 0.02 500000 THREADS
whose per-knot chain "round:rngseed" is stored in column chain2 (rngseed = 500000 + 1000*round + i).
"""
import collections, csv, math, os, sys, warnings
warnings.filterwarnings('ignore')
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..', '..')
sys.path.insert(0, os.path.join(ROOT, 'code'))
sys.path.insert(0, os.path.join(ROOT, 'research', 'code'))
import run_search as rs  # noqa: E402

OUT = os.path.join(ROOT, 'finer_research', 'out')


def corners(w):
    return sum(w[i] != w[i - 1] for i in range(len(w)))


def main():
    first = {r['knot']: r for r in csv.DictReader(open(os.path.join(ROOT, 'research', 'out', 'c11.csv')))}
    inv = {r['knot']: r for r in csv.DictReader(open(os.path.join(OUT, 'len_vs_invariants.csv')))}
    raw = {}
    for line in open(os.path.join(OUT, 'c11_round2_raw.txt')):
        p = line.split()
        if len(p) == 5:
            raw[p[0]] = p
    rows, bad = [], []
    for k, r in first.items():
        if k not in raw:
            continue
        _, start, best, chain, word = raw[k]
        start, best = int(start), int(best)
        assert start == int(r['best_length']) and len(word) == best
        if best < start:
            ok, how = rs.verify(word, k)
            if not ok:
                bad.append((k, how))
        else:
            ok, how, word = True, r['check'] + ' (unchanged word)', r['word']
        rows.append(dict(knot=k, alternating=inv[k]['alternating'], arc_index=int(float(inv[k]['arc_index'])),
                         len_round1=start, len_round2=best, drop=start - best, lattice_sticks=corners(word),
                         verified=ok, check=how, chain1=r['chain'], chain2=chain, word=word))
    with open(os.path.join(OUT, 'table_11_crossings_v2.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)

    # --- does the invariant fit predict which knots were improvable? ---
    # fit Len ~ A*arc + B*c + C on the 249 literature values only, then residual of round-1 values
    import numpy as np
    lit = [r for r in inv.values() if r['source'] == 'literature']
    X = np.array([[float(r['arc_index']), float(r['crossings']), 1.0] for r in lit])
    y = np.array([float(r['len']) for r in lit])
    coef = np.linalg.lstsq(X, y, rcond=None)[0]
    for r in rows:
        r['pred'] = coef[0] * r['arc_index'] + coef[1] * 11 + coef[2]
        r['res1'] = r['len_round1'] - r['pred']
        r['res2'] = r['len_round2'] - r['pred']

    S = []
    n = len(rows)
    dropped = [r for r in rows if r['drop'] > 0]
    S.append(f'# Deeper search on the 11-crossing table: summary\n')
    S.append(f'knots processed: {n} of 552; verification failures: {len(bad)} {bad}\n')
    S.append(f'knots whose bound dropped: {len(dropped)} ({100 * len(dropped) / n:.1f}%); '
             f'by 2: {sum(r["drop"] == 2 for r in rows)}, by 4: {sum(r["drop"] == 4 for r in rows)}, '
             f'more: {sum(r["drop"] > 4 for r in rows)}\n')
    for alt, nm in (('Y', 'alternating (K11a)'), ('N', 'non-alternating (K11n)')):
        sub = [r for r in rows if r['alternating'] == alt]
        if not sub:
            continue
        d1 = collections.Counter(r['len_round1'] for r in sub)
        d2 = collections.Counter(r['len_round2'] for r in sub)
        S.append(f'\n## {nm}: {len(sub)} knots, {sum(r["drop"] > 0 for r in sub)} dropped\n')
        S.append('| length | first table | after deeper search |\n|---|---|---|')
        for L in sorted(set(d1) | set(d2)):
            S.append(f'| {L} | {d1.get(L, 0)} | {d2.get(L, 0)} |')
    S.append('\n## By arc index\n\n| arc index | knots | dropped | lengths after |\n|---|---|---|---|')
    for a in sorted({r['arc_index'] for r in rows}):
        sub = [r for r in rows if r['arc_index'] == a]
        S.append(f'| {a} | {len(sub)} | {sum(r["drop"] > 0 for r in sub)} | '
                 f'{dict(sorted(collections.Counter(r["len_round2"] for r in sub).items()))} |')
    S.append(f'\n## Does the invariant fit flag improvable knots?\n')
    S.append(f'Fit on the 249 literature values only: Len ~ {coef[0]:.3f}*arc + {coef[1]:.3f}*c + {coef[2]:.3f}.\n')
    S.append('| round-1 residual (value minus prediction) | knots | dropped | fraction |\n|---|---|---|---|')
    edges = [-99, -1, 1, 3, 5, 99]
    for lo, hi in zip(edges, edges[1:]):
        sub = [r for r in rows if lo <= r['res1'] < hi]
        if sub:
            S.append(f'| [{lo}, {hi}) | {len(sub)} | {sum(r["drop"] > 0 for r in sub)} | '
                     f'{sum(r["drop"] > 0 for r in sub) / len(sub):.2f} |')
    r1 = math.sqrt(sum(r['res1'] ** 2 for r in rows) / n)
    r2 = math.sqrt(sum(r['res2'] ** 2 for r in rows) / n)
    S.append(f'\nRMS residual of the 11-crossing values against the literature-only fit: '
             f'{r1:.2f} before, {r2:.2f} after; mean residual {sum(r["res1"] for r in rows) / n:+.2f} before, '
             f'{sum(r["res2"] for r in rows) / n:+.2f} after.\n')
    open(os.path.join(OUT, 'round2_summary.md'), 'w').write('\n'.join(S) + '\n')
    print('\n'.join(S))


if __name__ == '__main__':
    main()
