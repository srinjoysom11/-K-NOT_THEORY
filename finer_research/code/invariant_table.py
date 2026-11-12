"""
invariant_table.py -- join best-known Len(K) with KnotInfo invariants.

  python finer_research/code/invariant_table.py

Reads data/rechnitzer_SC_minimal.csv (249 knots, <= 10 crossings, literature values)
and an 11-crossing table (default research/out/c11.csv; pass another CSV with columns
knot,best_length as argv[1]) and writes finer_research/out/len_vs_invariants.csv with
crossing number, alternating flag, arc index, braid index, bridge index, genus,
hyperbolic volume and (for our words) the number of corners = lattice sticks.
Needs: pip install database_knotinfo
"""
import csv, os, sys
from database_knotinfo import link_list

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
KI = {r['name']: r for r in link_list()}


def ki_name(k):                     # K11a12 -> 11a_12 ; 3_1 stays
    if k.startswith('K'):
        return k[1:4] + '_' + k[4:]
    return k


def num(x):
    try:
        return float(x)
    except Exception:
        return None


def corners(w):
    return sum(w[i] != w[i - 1] for i in range(len(w)))


def rows():
    for r in csv.DictReader(open(os.path.join(ROOT, 'data', 'rechnitzer_SC_minimal.csv'))):
        yield r['knot'], int(r['best_known_length']), r['direction_word'], 'literature'
    c11 = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'research', 'out', 'c11.csv')
    for r in csv.DictReader(open(c11)):
        yield r['knot'], int(r['best_length']), r['word'], 'this project'


def main():
    out = os.path.join(ROOT, 'finer_research', 'out', 'len_vs_invariants.csv')
    with open(out, 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['knot', 'crossings', 'alternating', 'len', 'source', 'arc_index', 'braid_index',
                    'bridge_index', 'genus', 'volume', 'corners', 'len_minus_4arc'])
        for k, L, word, src in rows():
            d = KI[ki_name(k)]
            a = num(d['arc_index'])
            w.writerow([k, d['crossing_number'], d['alternating'], L, src, d['arc_index'], d['braid_index'],
                        d['bridge_index'], d['three_genus'], d['volume'], corners(word),
                        '' if a is None else int(L - 4 * a)])
    print('wrote', out)


if __name__ == '__main__':
    main()
