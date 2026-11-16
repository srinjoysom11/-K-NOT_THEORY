"""Run a search method over ALL survivors of a level; save per-diagram results.
    python -m knotml.search_full 11 data_cpp tag method budget   (env CAP, SA_*, PT_* respected)"""
import sys, os, subprocess, tempfile, time
import numpy as np
n, d, tag, method, budget = int(sys.argv[1]), sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]
BIN = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "kernel", "search")
NP = os.cpu_count() or 1
inp = os.path.join(d, f"search_in_{n}.txt")
N = sum(1 for _ in open(inp))
best = np.full(N, -1); us = np.zeros(N)
with tempfile.TemporaryDirectory() as tmp:
    ps = [(os.path.join(tmp, f"o{s}.txt"), None) for s in range(NP)]
    procs = [subprocess.Popen([BIN, inp, method, budget, "11", ps[s][0], str(s), str(NP)]) for s in range(NP)]
    for p in procs: p.wait()
    for out, _ in ps:
        for l in open(out):
            i, b, t, _p = l.split(); best[int(i)] = int(b); us[int(i)] = float(t)
np.savez(os.path.join(d, f"search_{n}_{tag}.npz"), best=best, us=us)
print(tag, "done: reduced", int((best < n).sum()), "of", N, "mean ms %.3f" % (us.mean() / 1000))
