"""RL fine-tuning of the value net as a search policy (REINFORCE with baseline).

    python ml/rl_finetune.py ml/value_net.pt ml/expert_train.txt ml/value_net_rl.pt \
        [--iters 30] [--episodes 16] [--steps 40] [--tau 1.0]

Policy: at each step the agent picks one child diagram (all legal Regina moves,
sampled R2-adds) with probability softmax(-V(child)/tau).  Reward 1 when a
diagram with fewer crossings is reached (a proof of reducibility); discounted
back along the trajectory.  A supervised distance loss on the expert data is
mixed in so the value scale does not drift.
"""
import sys, argparse, random, time
import numpy as np, torch, regina
sys.path.insert(0, __file__.rsplit("/", 1)[0])
from model import ValueNet, batch_from_pds, DMAX
from guided_search import children
from train_il import load


def rollout(net, pd, steps, tau, rng, device):
    L = regina.Link.fromPD([tuple(t) for t in pd]); n0 = L.size()
    traj, ok = [], False
    for _ in range(steps):
        kids = children(L, n0, rng)
        if not kids: break
        red = [i for i, M in enumerate(kids) if M.size() < n0]
        if red:
            ok = True; break
        s, A, g = batch_from_pds([M.pdData() for M in kids], [n0] * len(kids), device)
        logits = -net(s, A, g) / tau
        dist = torch.distributions.Categorical(logits=logits)
        a = dist.sample()
        traj.append(dist.log_prob(a))
        L = kids[int(a)]
    return traj, ok


def main():
    ap = argparse.ArgumentParser(); ap.add_argument("ckpt"); ap.add_argument("data"); ap.add_argument("out")
    ap.add_argument("--iters", type=int, default=30); ap.add_argument("--episodes", type=int, default=16)
    ap.add_argument("--steps", type=int, default=40); ap.add_argument("--tau", type=float, default=1.0)
    ap.add_argument("--gamma", type=float, default=0.95); ap.add_argument("--il_weight", type=float, default=0.5)
    ap.add_argument("--device", default="cpu"); ap.add_argument("--starts", type=int, default=400)
    a = ap.parse_args()
    torch.manual_seed(0); rng = random.Random(0)
    c = torch.load(a.ckpt, map_location=a.device)
    net = ValueNet(c["hidden"]).to(a.device); net.load_state_dict(c["state"]); net.train()
    opt = torch.optim.AdamW(net.parameters(), lr=3e-4, weight_decay=1e-4)
    pds, n0s, dist, sid = load(a.data)
    first = {}
    for i, s in enumerate(sid):                      # one start state (dist at max) per start id
        if s not in first or dist[i] > dist[first[s]]: first[s] = i
    starts = [pds[i] for i in list(first.values())[:a.starts]]
    y = torch.tensor(np.minimum(dist, DMAX), dtype=torch.float32)
    succ_hist = []
    for it in range(a.iters):
        t0 = time.time(); losses, wins, eps = [], 0, 0
        batch = rng.sample(starts, a.episodes)
        results = [rollout(net, p, a.steps, a.tau, rng, a.device) for p in batch]
        wins = sum(ok for _, ok in results)
        returns = []
        for traj, ok in results:
            T = len(traj)
            returns.append([(a.gamma ** (T - t)) * float(ok) for t in range(T)])
        base = np.mean([r for rs in returns for r in rs]) if any(returns) else 0.0
        pg = 0.0
        for (traj, ok), rs in zip(results, returns):
            for lp, r in zip(traj, rs):
                pg = pg - lp * (r - base)
        pg = pg / max(1, sum(len(t) for t, _ in results))
        idx = np.random.randint(0, len(pds), 256)       # keep the value scale anchored
        s, A, g = batch_from_pds([pds[i] for i in idx], n0s[idx], a.device)
        il = torch.nn.functional.smooth_l1_loss(net(s, A, g), y[idx].to(a.device))
        loss = pg + a.il_weight * il
        opt.zero_grad(); loss.backward(); opt.step()
        succ_hist.append(wins / a.episodes)
        print(f"iter {it+1:3d}  success {wins}/{a.episodes} (tau={a.tau}, <= {a.steps} steps)  pg {float(pg):+.3f}  il {float(il):.3f}  {time.time()-t0:.0f}s", flush=True)
    torch.save({"state": net.state_dict(), "hidden": c["hidden"]}, a.out)
    print("success rate first 5 iters %.2f -> last 5 iters %.2f" % (np.mean(succ_hist[:5]), np.mean(succ_hist[-5:])))


if __name__ == "__main__":
    main()
