# Runs tasks A, B, C annealing stages with 2 worker processes (nice -n 10).
# Output: runs/all_runs.tsv  columns: stage, name, seed, startlen, bestlen, word
import subprocess, csv, os, sys, time
from concurrent.futures import ThreadPoolExecutor
BF = '/home/user/-K-NOT_THEORY/research/exact/bridge/pretzel/bfacf'
SCHED = ['100', '100000', '60000', '0.2', '0.02']
OUT = 'runs/all_runs.tsv'

def run_one(word, seed):
    p = subprocess.run(['nice', '-n', '10', BF, word, str(seed)] + SCHED,
                       capture_output=True, text=True, timeout=1800)
    if p.returncode != 0:
        raise RuntimeError(f'bfacf rc={p.returncode} seed={seed} err={p.stderr[:300]}')
    bl = [l for l in p.stdout.splitlines() if l.startswith('BEST ')]
    q = bl[-1].split(' ')
    L, w = int(q[1]), q[2]
    assert len(w) == L, (L, len(w))
    return L, w

def run_stage(stage, jobs, log):
    # jobs: list of (name, seed, word, startlen)
    t0 = time.time()
    with ThreadPoolExecutor(max_workers=2) as ex:
        futs = [ex.submit(run_one, w, s) for (_, s, w, _) in jobs]
        res = [f.result() for f in futs]
    out = []
    with open(OUT, 'a') as f:
        for (name, s, w, sl), (L, bw) in zip(jobs, res):
            f.write(f'{stage}\t{name}\t{s}\t{sl}\t{L}\t{bw}\n')
            out.append((name, L, bw))
    print(f'stage {stage}: {len(jobs)} runs in {time.time()-t0:.0f}s', file=log, flush=True)
    return out

def best_of(rows):
    b = {}
    for name, L, w in rows:
        if name not in b or L < b[name][0]:
            b[name] = (L, w)
    return b

if __name__ == '__main__':

    man = [l.rstrip('\n').split('\t') for l in open('manifest.tsv')][1:]
    seedw = {m[0]: m[8] for m in man}
    grp = {m[0]: m[1] for m in man}
    # prior pretzel bests for task A (from ../pretzel/results.csv)
    prior = {}
    for row in csv.DictReader(open('/home/user/-K-NOT_THEORY/research/exact/bridge/pretzel/results.csv')):
        prior[row['knot']] = (int(row['best_length']), row['best_word'])
    if os.path.exists(OUT): os.remove(OUT)
    log = open('runs/orchestrate.log', 'w')
    summary = {}
    # ---- Task A: start from prior best, seeds 201..320; restart from new best with 321..440 if improved
    A_names = ['P(3,3,-3,-3,2)', 'P(3,-3,3,-3,2)', 'P(3,-3,3,-3,3,-2)', 'P(-3,-3,3,2)']
    jobs = [(n, s, prior[n][1], prior[n][0]) for n in A_names for s in range(201, 321)]
    rowsA1 = run_stage('A1', jobs, log)
    bA1 = best_of(rowsA1)
    jobs2 = []
    for n in A_names:
        if bA1[n][0] < prior[n][0]:
            jobs2 += [(n, s, bA1[n][1], bA1[n][0]) for s in range(321, 441)]
            print('A restart for', n, 'from', bA1[n][0], file=log, flush=True)
        else:
            print('A no restart for', n, file=log, flush=True)
    rowsA2 = run_stage('A2', jobs2, log) if jobs2 else []
    # ---- Task B: seeds 1..48 from seed word, then seeds 101..148 from best of stage 1
    B_names = [m[0] for m in man if m[1] == 'B']
    rowsB1 = run_stage('B1', [(n, s, seedw[n], len(seedw[n])) for n in B_names for s in range(1, 49)], log)
    bB1 = best_of(rowsB1)
    rowsB2 = run_stage('B2', [(n, s, bB1[n][1], bB1[n][0]) for n in B_names for s in range(101, 149)], log)
    # ---- Task C: 48 runs from seed word
    C_names = [m[0] for m in man if m[1] == 'C']
    rowsC1 = run_stage('C1', [(n, s, seedw[n], len(seedw[n])) for n in C_names for s in range(1, 49)], log)
    print('ALL DONE', file=log, flush=True)
