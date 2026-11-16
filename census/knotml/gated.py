"""ML-gated rigorous search: economics on one level.

    python -m knotml.gated 11 data_cpp 8,9,10 tag1 tag2 ...
Pipeline per survivor of simplify():  [ML score]  ->  search (if score high)
->  SnapPy identity if the search did not prove the diagram reducible.
Correctness never depends on the model: a diagram is dropped only with a
Regina-checked certificate."""
import sys, os
import numpy as np
from sklearn.ensemble import HistGradientBoostingClassifier
from sklearn.metrics import roc_auc_score
n, d, train, tags = int(sys.argv[1]), sys.argv[2], [int(x) for x in sys.argv[3].split(",")], sys.argv[4:]

def load(m):
    L = np.load(os.path.join(d, f"level_{m}.npz"))
    diag = np.delete(L["X"], 38, axis=1)
    inv = np.load(os.path.join(d, f"inv_{m}.npy"))
    return np.hstack([diag, inv]), L["alt"], L["label"], L

Xs, ys = [], []
for m in train:
    X, alt, lab, _ = load(m); Xs.append(X[~alt]); ys.append(lab[~alt])      # 1 = reducible
clf = HistGradientBoostingClassifier(max_iter=300, learning_rate=0.05, max_depth=6, l2_regularization=1.0, random_state=0).fit(np.vstack(Xs), np.concatenate(ys))
X, alt, lab, L = load(n)
p = np.zeros(len(alt)); p[~alt] = clf.predict_proba(X[~alt])[:, 1]
print(f"level {n}: survivors {len(alt)}, non-alt {int((~alt).sum())}, reducible {int(lab[~alt].sum())}, AUC(reducible) {roc_auc_score(lab[~alt], p[~alt]):.3f}")
NP = os.cpu_count() or 1
c_snap = float(L["t_id"]) * NP / len(alt) * 1000          # ms CPU per identity call
c_feat = float(L["t_feat"]) * NP / len(alt) * 1000 + 0.12 + 0.02   # diagram feats + invariants + predict
print(f"SnapPy identity {c_snap:.2f} ms/diagram, model features {c_feat:.2f} ms/diagram, baseline total {c_snap*len(alt)/1000:.1f} CPU-s")
base = c_snap * len(alt)
for tag in tags:
    S = np.load(os.path.join(d, f"search_{n}_{tag}.npz"))
    reduced = S["best"] < n; ms = S["us"] / 1000
    assert not reduced[~lab].any(), "false reduction: impossible"
    print(f"\n[{tag}] search alone on every non-alt survivor: proves {int(reduced.sum())}/{int(lab[~alt].sum())} reducible, mean {ms[~alt].mean():.2f} ms")
    print(f"{'gate q':>7s} {'searched%':>10s} {'snappy calls':>13s} {'total cpu-s':>12s} {'saving vs all-SnapPy':>22s}")
    for q in [0.0, 0.3, 0.5, 0.6, 0.7, 0.8, 0.9]:
        g = (~alt) & (p >= q)
        cost = np.where(g, ms + np.where(reduced, 0.0, c_snap), c_snap)
        total = cost.sum() + (c_feat * (~alt).sum() if q > 0 else 0.0)
        calls = int((~(g & reduced)).sum())
        print(f"{q:7.1f} {100*g[~alt].mean():9.1f}% {calls:13d} {total/1000:12.2f} {100*(1-total/base):21.1f}%")
