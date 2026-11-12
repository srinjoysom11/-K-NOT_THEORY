"""
summarize.py -- tabulate the search outputs in research/out.

  py -3.12 research/code/summarize.py

Reads calib_le10.csv (knots <= 10 crossings, compared with the literature column)
and c11.csv (11-crossing knots, no literature value) and writes
research/out/summary.md and research/out/table_11_crossings.csv.
Also re-checks from scratch that every stored word is a closed self-avoiding polygon.
"""
import collections
import csv
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..', 'out')
sys.path.insert(0, os.path.join(HERE, '..', '..', 'code'))
import latticeknot as lk  # noqa: E402


def load(tag):
    p = os.path.join(OUT, tag + '.csv')
    return list(csv.DictReader(open(p))) if os.path.exists(p) else []


def main():
    lines = []
    cal = load('calib_le10')
    if cal:
        for r in cal:
            assert lk.is_lattice_polygon([lk.word_to_vertices(r['word'])]) and len(r['word']) == int(r['best_length'])
        d = [(r['knot'], int(r['best_length']), int(r['literature_bound']), r['verified']) for r in cal]
        eq = [x for x in d if x[1] == x[2]]
        worse = [x for x in d if x[1] > x[2]]
        better = [x for x in d if x[1] < x[2]]
        bad = [x for x in d if x[3] != 'True']
        lines += ['## Calibration: prime knots with at most 10 crossings', '',
                  f'knots run: {len(d)} of 249', f'- equal to literature bound: {len(eq)}',
                  f'- longer than literature bound (search fell short): {len(worse)}',
                  f'- shorter than literature bound (would be an improvement): {len(better)}',
                  f'- failed verification: {len(bad)}', '']
        if worse:
            lines += ['Fell short: ' + ', '.join(f'{k} ({a} vs {b})' for k, a, b, _ in worse), '']
        if better:
            lines += ['**Shorter than literature:** ' + ', '.join(f'{k} ({a} vs {b})' for k, a, b, _ in better), '']
        if bad:
            lines += ['Failed verification: ' + ', '.join(x[0] for x in bad), '']
    c11 = load('c11')
    if c11:
        for r in c11:
            assert lk.is_lattice_polygon([lk.word_to_vertices(r['word'])]) and len(r['word']) == int(r['best_length'])
        ok = [r for r in c11 if r['verified'] == 'True']
        bad = [r for r in c11 if r['verified'] != 'True']
        lines += ['## 11-crossing prime knots', '', f'knots run: {len(c11)} of 552; verified: {len(ok)}; failed verification: {len(bad)}', '']
        for label, pref in (('alternating (K11a)', 'K11a'), ('non-alternating (K11n)', 'K11n')):
            h = collections.Counter(int(r['best_length']) for r in ok if r['knot'].startswith(pref))
            if h:
                lines += [f'{label}: ' + ', '.join(f'{L}: {h[L]} knots' for L in sorted(h)), '']
        if bad:
            lines += ['Failed verification: ' + ', '.join(f"{r['knot']} ({r['check']})" for r in bad), '']
        with open(os.path.join(OUT, 'table_11_crossings.csv'), 'w', newline='') as f:
            w = csv.writer(f)
            w.writerow(['knot', 'upper_bound_on_Len', 'check', 'word'])
            for r in ok:
                w.writerow([r['knot'], r['best_length'], r['check'], r['word']])
    open(os.path.join(OUT, 'summary.md'), 'w').write('\n'.join(lines) + '\n')
    print('\n'.join(lines))


if __name__ == '__main__':
    main()
