"""Benchmark Reidemeister-search pruners on simplify()-survivors.

    python -m knotml.search_bench 11 data_cpp 600 method:budget ...
Runs on a stratified sample (k reducible + k minimal non-alternating diagrams).
Reports success on reducible diagrams, FALSE reductions on minimal ones (must be
0: every move is checked by Regina), and CPU cost per diagram."""
import sys, os, subprocess, time, tempfile
import numpy as np

n, d, k = int(sys.argv[1]), sys.argv[2], int(sys.argv[3])
specs = sys.argv[4:]
BIN = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "kernel", "search")
meta = np.load(os.path.join(d, f"search_meta_{n}.npz"))
alt, label = meta["alt"], meta["label"]
rng = np.random.default_rng(1)
red = rng.choice(np.where(~alt & label)[0], k, replace=False)
mini = rng.choice(np.where(~alt & ~label)[0], k, replace=False)
sel = set(red.tolist()) | set(mini.tolist())
lines = [l for l in open(os.path.join(d, f"search_in_{n}.txt")) if int(l.split()[0]) in sel]
NP = os.cpu_count() or 1
with tempfile.TemporaryDirectory() as tmp:
    inp = os.path.join(tmp, "in.txt"); open(inp, "w").writelines(lines)
    print(f"n={n}: {len(red)} reducible + {len(mini)} minimal diagrams, {NP} processes")
    print(f"{'method':14s} {'reduced%':>9s} {'false':>6s} {'cpu ms/diag':>12s} {'ms/diag on reducible':>21s} {'on minimal':>9s} {'net ms':>9s}")
    for spec in specs:
        m, _, b = spec.partition(":")
        procs = []
        t0 = time.time()
        for s in range(NP):
            out = os.path.join(tmp, f"o_{m}_{s}.txt")
            procs.append((out, subprocess.Popen([BIN, inp, m, b or "0", "7", out, str(s), str(NP)])))
        rows = []
        for out, p in procs:
            p.wait()
            rows += [l.split() for l in open(out)]
        wall = time.time() - t0
        best = {int(r[0]): int(r[1]) for r in rows}; us = {int(r[0]): float(r[2]) for r in rows}
        rr = np.mean([best[i] < n for i in red]); fp = sum(best[i] < n for i in mini)
        cpu = np.mean(list(us.values())) / 1000; cpur = np.mean([us[i] for i in red]) / 1000
        cpum = np.mean([us[i] for i in mini]) / 1000
        # net CPU gain per non-alt survivor if SnapPy costs C ms and a fraction f_red is reducible
        C, f = float(os.environ.get("SNAPPY_MS", 2.0)), float(os.environ.get("F_RED", 0.607))
        net = f * rr * C - (f * cpur + (1 - f) * cpum)
        print(f"{spec:14s} {100*rr:8.1f}% {fp:6d} {cpu:12.3f} {cpur:21.3f} {cpum:9.3f} {net:+9.3f}   (wall {wall:.0f}s)", flush=True)
