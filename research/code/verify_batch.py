"""
verify_batch.py -- verify the output of bfacf_batch.exe and write the usual CSV.

  py -3.12 research/code/seeds.py                      (once: research/data/seeds.json)
  py -3.12 research/code/verify_batch.py export 11 research/out/in11.txt
  research/code/bfacf_batch.exe research/out/in11.txt research/out/raw11.txt 3 8 100 100000 60000 0.2 0.02 0 10
  py -3.12 research/code/verify_batch.py check research/out/raw11.txt c11_cpp

The search itself is C++; Python is used only where SnapPy is needed (diagram
seeds and knot identification of the final words).
"""
import csv
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
sys.path.insert(0, HERE)
import run_search as rs  # noqa: E402
import seeds as sd  # noqa: E402


def main():
    mode = sys.argv[1]
    if mode == 'export':
        seeds = json.load(open(os.path.join(ROOT, 'data', 'seeds.json')))
        with open(sys.argv[3], 'w') as f:
            for name, _ in sd.knot_list(int(sys.argv[2])):
                f.write(f'{name} {seeds[name]}\n')
        return
    raw, tag = sys.argv[2], sys.argv[3]
    known = {r['knot']: r['best_known_length'] for r in
             csv.DictReader(open(os.path.join(ROOT, '..', 'data', 'rechnitzer_SC_minimal.csv')))}
    sname = {n: s for c in range(3, 12) for n, s in sd.knot_list(c)}
    with open(os.path.join(ROOT, 'out', tag + '.csv'), 'w', newline='') as f:
        wr = csv.writer(f)
        wr.writerow(['knot', 'start_length', 'best_length', 'literature_bound', 'verified', 'check', 'chain', 'word'])
        for line in open(raw):
            name, sl, bl, chain, word = line.split()
            assert len(word) == int(bl)
            ok, how = rs.verify(word, sname[name])
            wr.writerow([name, sl, bl, known.get(name, ''), ok, how, '' if chain == '-' else chain.replace(',', ' '), word])


if __name__ == '__main__':
    main()
