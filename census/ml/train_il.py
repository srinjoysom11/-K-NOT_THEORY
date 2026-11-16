"""Imitation learning: regress the exact move-distance-to-reducible produced by the
exhaustive-BFS expert (kernel/expert).

    python ml/train_il.py ml/expert_train.txt ml/value_net.pt [--epochs 6] [--device cuda]
"""
import sys, time, argparse
import numpy as np, torch
sys.path.insert(0, __file__.rsplit("/", 1)[0])
from model import ValueNet, batch_from_pds, DMAX


def load(path):
    pds, n0s, dist, sid = [], [], [], []
    for line in open(path):
        t = line.split()
        sid.append(int(t[0])); n0s.append(int(t[1])); dist.append(int(t[2])); sz = int(t[3])
        v = list(map(int, t[4:4 + 4 * sz]))
        pds.append([tuple(v[4 * i:4 * i + 4]) for i in range(sz)])
    return pds, np.array(n0s), np.array(dist), np.array(sid)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("data"); ap.add_argument("out")
    ap.add_argument("--epochs", type=int, default=6); ap.add_argument("--bs", type=int, default=256)
    ap.add_argument("--device", default="cpu"); ap.add_argument("--hidden", type=int, default=64)
    ap.add_argument("--max", type=int, default=0, help="use at most this many samples")
    a = ap.parse_args()
    torch.manual_seed(0); np.random.seed(0)
    pds, n0s, dist, sid = load(a.data)
    if a.max: pds, n0s, dist, sid = pds[:a.max], n0s[:a.max], dist[:a.max], sid[:a.max]
    starts = np.unique(sid); rng = np.random.default_rng(0); rng.shuffle(starts)
    val_starts = set(starts[: max(1, len(starts) // 10)].tolist())
    isval = np.array([s in val_starts for s in sid])
    tr, va = np.where(~isval)[0], np.where(isval)[0]
    print(f"{len(pds)} states from {len(starts)} starts; train {len(tr)}, val {len(va)} (held-out starts)")
    torch.set_num_threads(max(1, __import__("os").cpu_count() or 1))
    t0 = time.time()
    from model import pd_to_arrays
    arrs = [pd_to_arrays(p) for p in pds]
    SIGN = torch.from_numpy(np.stack([x[0] for x in arrs]))                       # [S,N] int64
    AA = torch.from_numpy(np.stack([x[1] for x in arrs]))                          # [S,T,N,N] uint8
    GLOB = torch.tensor([[(len(p) - n0) / 2.0, n0 / 10.0] for p, n0 in zip(pds, n0s)], dtype=torch.float32)
    del arrs
    print(f"tensorized {len(pds)} states in {time.time()-t0:.0f}s ({AA.numel()/1e6:.0f} MB)", flush=True)
    net = ValueNet(a.hidden).to(a.device)
    opt = torch.optim.AdamW(net.parameters(), lr=2e-3, weight_decay=1e-4)
    sched = torch.optim.lr_scheduler.OneCycleLR(opt, max_lr=2e-3, total_steps=a.epochs * (len(tr) // a.bs + 1))
    y_all = torch.tensor(np.minimum(dist, DMAX), dtype=torch.float32)

    def run(idx, train):
        net.train(train); tot, cnt, preds = 0.0, 0, []
        order = np.random.permutation(idx) if train else idx
        for i in range(0, len(order), a.bs):
            b = order[i:i + a.bs]
            bt = torch.from_numpy(b)
            s, A, g = SIGN[bt].to(a.device), AA[bt].float().to(a.device), GLOB[bt].to(a.device)
            y = y_all[b].to(a.device)
            with torch.set_grad_enabled(train):
                p = net(s, A, g)
                loss = torch.nn.functional.smooth_l1_loss(p, y)
            if train:
                opt.zero_grad(); loss.backward(); opt.step(); sched.step()
            tot += loss.item() * len(b); cnt += len(b); preds.append(p.detach().cpu())
        return tot / cnt, torch.cat(preds).numpy()

    for ep in range(a.epochs):
        t0 = time.time()
        trl, _ = run(tr, True)
        vl, vp = run(va, False)
        yv = y_all[va].numpy()
        from scipy.stats import spearmanr
        print(f"epoch {ep+1}/{a.epochs}  train {trl:.3f}  val {vl:.3f}  val MAE {np.abs(vp-yv).mean():.2f}  "
              f"Spearman {spearmanr(vp, yv)[0]:.3f}  ({time.time()-t0:.0f}s)", flush=True)
    torch.save({"state": net.state_dict(), "hidden": a.hidden}, a.out)
    print("saved", a.out)


if __name__ == "__main__":
    main()
