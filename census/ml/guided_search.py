"""Best-first search over Reidemeister moves, ordered by a learned value, BFS, or randomly.

    python ml/guided_search.py ml/value_net.pt ml/starts_test.txt --starts 160 --budget 400

Every state is reached by Regina-checked moves, so a success (a diagram with
fewer crossings) is a proof the start diagram is reducible, whatever the model says.
Reports success within E state expansions and the wall time per expansion."""
import sys, time, heapq, argparse, itertools, random
import numpy as np
import regina
sys.path.insert(0, __file__.rsplit("/", 1)[0])


def children(L, n0, rng, adds_cap=40):
    out, m = [], L.size()
    for c in range(m):
        cc = L.crossing(c)
        if L.hasR1(cc): M = regina.Link(L); M.r1(M.crossing(c)); out.append(M)
        if L.hasR2(cc): M = regina.Link(L); M.r2(M.crossing(c)); out.append(M)
        for side in (0, 1):
            if L.hasR3(cc, side): M = regina.Link(L); M.r3(M.crossing(c), side); out.append(M)
    if m + 2 <= n0 + 2:
        adds = []
        for c1 in range(m):
            for t1 in (0, 1):
                a = regina.StrandRef(L.crossing(c1), t1)
                for c2 in range(m):
                    for t2 in (0, 1):
                        b = regina.StrandRef(L.crossing(c2), t2)
                        for s1 in (0, 1):
                            for s2 in (0, 1):
                                if L.hasR2(a, s1, b, s2): adds.append((c1, t1, s1, c2, t2, s2))
        rng.shuffle(adds)
        for c1, t1, s1, c2, t2, s2 in adds[:adds_cap]:
            M = regina.Link(L)
            M.r2(regina.StrandRef(M.crossing(c1), t1), s1, regina.StrandRef(M.crossing(c2), t2), s2)
            out.append(M)
    return out


def search(pd, method, budget, net=None, seed=0):
    import torch
    from model import batch_from_pds
    rng = random.Random(seed)
    L0 = regina.Link.fromPD([tuple(t) for t in pd]); n0 = L0.size()
    seen = {L0.knotSig()}; cnt = itertools.count()
    heap = [(0.0, next(cnt), L0, 0)]; expansions = 0
    while heap and expansions < budget:
        _, _, L, depth = heapq.heappop(heap); expansions += 1
        kids = children(L, n0, rng)
        new = []
        for M in kids:
            if M.size() < n0:
                return True, expansions
            s = M.knotSig()
            if s not in seen:
                seen.add(s); new.append(M)
        if not new: continue
        if method == "value":
            pds = [M.pdData() for M in new]
            with torch.no_grad():
                v = net(*batch_from_pds(pds, [n0] * len(pds))).numpy()
        for i, M in enumerate(new):
            key = {"bfs": depth + 1, "random": rng.random(), "value": float(v[i]) if method == "value" else 0}[method]
            heapq.heappush(heap, (key, next(cnt), M, depth + 1))
    return False, expansions


def _work(args):
    import torch
    torch.set_num_threads(1)
    pd, method, budget, ckpt, seed = args
    net = None
    if method == "value":
        from model import ValueNet
        c = torch.load(ckpt, map_location="cpu"); net = ValueNet(c["hidden"]); net.load_state_dict(c["state"]); net.eval()
    t0 = time.time(); ok, e = search(pd, method, budget, net, seed)
    return method, ok, e, time.time() - t0


def main():
    import multiprocessing as mp
    ap = argparse.ArgumentParser(); ap.add_argument("ckpt"); ap.add_argument("starts")
    ap.add_argument("--starts", dest="k", type=int, default=160); ap.add_argument("--budget", type=int, default=400)
    ap.add_argument("--methods", default="bfs,random,value"); ap.add_argument("--procs", type=int, default=4)
    a = ap.parse_args()
    pds = []
    for line in open(a.starts):
        t = line.split(); n = int(t[1]); v = list(map(int, t[2:2 + 4 * n]))
        pds.append([tuple(v[4 * i:4 * i + 4]) for i in range(n)])
    pds = pds[:a.k]
    budgets = [b for b in (10, 25, 50, 100, 200, 400, 800, 1600) if b <= a.budget]
    print(f"{len(pds)} held-out hard starts (level {len(pds[0])}), budget {a.budget} expansions")
    print(f"{'method':8s} " + " ".join(f"@{b:<5d}" for b in budgets) + "  mean ms/expansion")
    for m in a.methods.split(","):
        jobs = [(p, m, a.budget, a.ckpt, i) for i, p in enumerate(pds)]
        with mp.get_context("fork").Pool(a.procs) as pool:
            res = pool.map(_work, jobs, chunksize=2)
        succ = lambda B: np.mean([r[1] and r[2] <= B for r in res])
        ms = 1000 * sum(r[3] for r in res) / max(1, sum(r[2] for r in res))
        print(f"{m:8s} " + " ".join(f"{100*succ(B):5.1f}%" for B in budgets) + f"  {ms:.2f}", flush=True)


if __name__ == "__main__":
    main()
