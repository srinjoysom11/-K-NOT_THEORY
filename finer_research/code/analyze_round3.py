"""
analyze_round3.py -- merge the third search (finer goals F1, F2) with table v2, verify, summarise.

  python finer_research/code/analyze_round3.py

Inputs
  finer_research/out/table_11_crossings_v2.csv      table after the second search
  finer_research/out/c11_round3_targeted_raw.txt    F2: knots with residual > +1, 5 rounds x 40 runs
  finer_research/out/c11_round3_rest_raw.txt        F1: all other knots, 2 rounds x 20 runs
Outputs
  finer_research/out/table_11_crossings_v3.csv
  finer_research/out/round3_summary.md
Every word that changed is re-verified from scratch with research/code/run_search.verify.
Works on partial raw files (reports how many knots are done).
"""
import collections
import csv
import os
import sys
import warnings

warnings.filterwarnings('ignore')
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..', '..')
sys.path.insert(0, os.path.join(ROOT, 'code'))
sys.path.insert(0, os.path.join(ROOT, 'research', 'code'))
import run_search as rs  # noqa: E402

OUT = os.path.join(ROOT, 'finer_research', 'out')
COEF = (2.795, 2.545, 2.214)  # literature-only fit, see round2_summary.md


def corners(w):
    return sum(w[i] != w[i - 1] for i in range(len(w)))


def read_raw(name, group):
    out = {}
    p = os.path.join(OUT, name)
    if os.path.exists(p):
        for line in open(p):
            q = line.split()
            if len(q) == 5:
                out[q[0]] = (group, int(q[1]), int(q[2]), q[3], q[4])
    return out


def main():
    v2 = list(csv.DictReader(open(os.path.join(OUT, 'table_11_crossings_v2.csv'))))
    raw = read_raw('c11_round3_targeted_raw.txt', 'targeted')
    raw.update(read_raw('c11_round3_rest_raw.txt', 'rest'))
    targeted = {l.split()[0] for l in open(os.path.join(OUT, 'c11_round3_targeted_in.txt'))}
    rows, bad = [], []
    for r in v2:
        k = r['knot']
        L2 = int(r['len_round2'])
        group = 'targeted' if k in targeted else 'rest'
        if k in raw:
            _, start, best, chain, word = raw[k]
            assert start == L2 and len(word) == best, k
            runs = 200 if group == 'targeted' else 40
        else:
            best, chain, word, runs = L2, '-', r['word'], 0
        if best < L2:
            ok, how = rs.verify(word, k)
            if not ok:
                bad.append((k, how))
        else:
            ok, how, word = True, r['check'], r['word']
        a = int(r['arc_index'])
        pred = COEF[0] * a + COEF[1] * 11 + COEF[2]
        rows.append(dict(knot=k, alternating=r['alternating'], arc_index=a, len_round1=int(r['len_round1']),
                         len_round2=L2, len_round3=best, drop3=L2 - best, group=group, runs_round3=runs,
                         residual=round(best - pred, 2), lattice_sticks=corners(word), verified=ok, check=how,
                         chain1=r['chain1'], chain2=r['chain2'], chain3=chain, word=word))
    with open(os.path.join(OUT, 'table_11_crossings_v3.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)

    S = ['# Third search on the 11-crossing table (finer goals F1 and F2): summary\n']
    done = [r for r in rows if r['runs_round3']]
    S.append(f'knots processed: {len(done)} of 552; verification failures: {len(bad)} {bad}\n')
    S.append('| group | runs per knot | knots done | dropped | fraction | by 2 | by 4+ |\n|---|---|---|---|---|---|---|')
    for g, n in (('targeted', 200), ('rest', 40)):
        sub = [r for r in done if r['group'] == g]
        d = [r for r in sub if r['drop3'] > 0]
        if sub:
            S.append(f'| {g} | {n} | {len(sub)} | {len(d)} | {len(d) / len(sub):.3f} | '
                     f'{sum(r["drop3"] == 2 for r in d)} | {sum(r["drop3"] >= 4 for r in d)} |')
    # in which round of the targeted search (40 runs each) did the improvement come
    rd = collections.Counter()
    for r in done:
        if r['group'] == 'targeted' and r['drop3'] > 0:
            rd[r['chain3'].split(',')[0].split(':')[0]] += 1
    S.append(f'\nTargeted knots: round (of 5, 40 runs each) of the first improvement: {dict(sorted(rd.items()))}\n')
    S.append('## Convergence curve (fraction of entries lowered per search)\n')
    n = len(rows)
    d2 = sum(int(r['len_round1']) > int(r['len_round2']) for r in rows)
    d3 = sum(r['drop3'] > 0 for r in rows)
    S.append(f'- search 2 (40 runs, all 552): {d2} / {n} = {d2 / n:.3f}')
    S.append(f'- search 3 (200 runs on targeted, 40 on the rest): {d3} / {len(done)} = {d3 / max(1, len(done)):.3f}\n')
    S.append('## Lengths\n')
    for alt, nm in (('Y', 'alternating'), ('N', 'non-alternating')):
        sub = [r for r in rows if r['alternating'] == alt]
        c1 = collections.Counter(r['len_round1'] for r in sub)
        c2 = collections.Counter(r['len_round2'] for r in sub)
        c3 = collections.Counter(r['len_round3'] for r in sub)
        S.append(f'\n{nm} ({len(sub)} knots)\n\n| length | first table | v2 | v3 |\n|---|---|---|---|')
        for L in sorted(set(c1) | set(c3)):
            S.append(f'| {L} | {c1.get(L, 0)} | {c2.get(L, 0)} | {c3.get(L, 0)} |')
    S.append('\n## Mean residual against the literature-only fit\n')
    for nm, key in (('first table', 'len_round1'), ('v2', 'len_round2'), ('v3', 'len_round3')):
        m = sum(r[key] - (COEF[0] * r['arc_index'] + COEF[1] * 11 + COEF[2]) for r in rows) / n
        S.append(f'- {nm}: {m:+.3f}')
    S.append('\n## Knots lowered in this search\n')
    S.append(', '.join(f'{r["knot"]} {r["len_round2"]}->{r["len_round3"]}' for r in rows if r['drop3'] > 0) or 'none')
    open(os.path.join(OUT, 'round3_summary.md'), 'w').write('\n'.join(S) + '\n')
    print('\n'.join(S))


if __name__ == '__main__':
    main()
