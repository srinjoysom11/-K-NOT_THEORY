"""Evaluate pruning strategies on the survivors of Regina simplify().

    python -m knotml.evaluate

Protocol (no peeking at the test level):
  round A: train on levels 8-9, choose threshold on level 10, test on 11
  round B: train on levels 8-10, choose threshold on 11,      test on 12
A strategy is judged on (i) how many diagrams still need the expensive
SnapPy identity check, and (ii) coverage: does every knot of the exact census
still have at least one surviving diagram?  Coverage must be 100%.
"""
from __future__ import annotations
import json, os, sys, time
import numpy as np
from sklearn.ensemble import HistGradientBoostingClassifier
from sklearn.metrics import roc_auc_score
from . import maps, pipeline as P
from .diagrams import make_link, homfly_key

DATA = P.DATA
EXPECT = {10: 165, 11: 552, 12: 2176}


FEATSET = "diag"


def load(n):
    d = np.load(os.path.join(DATA, f"level_{n}.npz"))
    L = {k: d[k] for k in d.files}
    diag = np.delete(L["X"], 38, axis=1)               # drop raw n: constant per level
    inv = np.load(os.path.join(DATA, f"inv_{n}.npy")) if os.path.exists(os.path.join(DATA, f"inv_{n}.npy")) else None
    L["X"] = {"diag": diag, "inv": inv, "both": None if inv is None else np.hstack([diag, inv])}[FEATSET]
    return L


def needed_ids(L):
    """distinct ids of new prime knots among the survivors"""
    return set(L["ids"][~L["label"]].tolist())


def coverage(L, kept):
    truth = needed_ids(L)
    found = set(L["ids"][kept & ~L["label"]].tolist())
    return len(found), len(truth)


def fit(train_levels):
    Xs, ys = [], []
    for n in train_levels:
        L = load(n)
        m = ~L["alt"]
        Xs.append(L["X"][m]); ys.append(~L["label"][m])          # 1 = needed
    X, y = np.vstack(Xs), np.concatenate(ys)
    clf = HistGradientBoostingClassifier(max_iter=300, learning_rate=0.05, max_depth=6,
                                         l2_regularization=1.0, random_state=0)
    clf.fit(X, y)
    return clf


def p_needed(clf, L):
    p = np.ones(len(L["alt"]))                 # alternating diagrams are always kept
    m = ~L["alt"]
    p[m] = clf.predict_proba(L["X"][m])[:, 1]
    return p


def choose_threshold(p, L, margin=0.5):
    """Largest threshold that keeps every needed knot of the validation level,
    shrunk by `margin` for safety."""
    best = {}
    for pi, i, lab in zip(p, L["ids"], L["label"]):
        if not lab:
            best[i] = max(best.get(i, 0.0), pi)
    return margin * min(best.values())


def homfly_keys_for(level, shadows):
    L = load(level)
    P.set_shadows(shadows)
    return P.pmap(_hk, [tuple(c) for c in L["cands"]], chunk=128)


def _hk(item):
    si, bits = item
    return homfly_key(make_link(P._SHADOWS[si], int(bits)))


def run_round(train, val, test, levels_maps):
    rows = {}
    clf = fit(train)
    Lv, Lt = load(val), load(test)
    pv, pt = p_needed(clf, Lv), p_needed(clf, Lt)
    theta = choose_threshold(pv, Lv)
    nonalt = ~Lt["alt"]
    auc = roc_auc_score(~Lt["label"][nonalt], pt[nonalt])
    n_all = len(Lt["alt"])
    out = dict(test_level=test, train=train, val=val, theta=round(float(theta), 5), auc_test=round(float(auc), 4),
               survivors=n_all, survivors_nonalt=int(nonalt.sum()),
               prunable_nonalt=int(Lt["label"][nonalt].sum()))

    def row(name, kept):
        f, t = coverage(Lt, kept)
        return dict(strategy=name, snappy_calls=int(kept.sum()), saved_pct=round(100 * (1 - kept.mean()), 1),
                    knots_found=f, knots_needed=t, complete=(f == t))
    res = [row("none (identify every survivor)", np.ones(n_all, bool))]
    res.append(row("oracle (prune exactly the prunable)", ~Lt["label"] | Lt["alt"]))
    kept_ml = pt >= theta
    res.append(row("ML (gradient boosting)", kept_ml))
    # random pruning with the same budget
    rng = np.random.default_rng(0)
    q = kept_ml[nonalt].mean()
    fs = []
    for _ in range(100):
        k = Lt["alt"] | (rng.random(n_all) < q)
        fs.append(coverage(Lt, k)[0])
    r = row("random, same budget", Lt["alt"] | (rng.random(n_all) < q))
    r["knots_found"] = float(np.mean(fs)); r["complete"] = bool(np.min(fs) == r["knots_needed"])
    res.append(r)
    # HOMFLY lookup against every diagram seen at lower levels (cheap, non-ML)
    known_keys = {str(__import__("regina").Link(1).homfly())}
    for m in range(3, test):
        sh = maps.knot_shadows(m, levels_maps)
        known_keys |= set(homfly_keys_for(m, sh))
    sh = maps.knot_shadows(test, levels_maps)
    t0 = time.time()
    keys = homfly_keys_for(test, sh)
    t_hom = time.time() - t0
    hom_hit = np.array([k in known_keys for k in keys])
    res.append(row("HOMFLY lookup vs lower levels", ~hom_hit | Lt["alt"]))
    res.append(row("ML AND HOMFLY (both say reducible)", kept_ml | ~hom_hit))
    out["strategies"] = res
    out["cpu_ms_per_diagram"] = dict(
        features=round(1000 * float(Lt["t_feat"]) * P.NPROC / n_all, 3),
        snappy_identity=round(1000 * float(Lt["t_id"]) * P.NPROC / n_all, 3),
        homfly=round(1000 * t_hom * P.NPROC / n_all, 3))
    return out


def main():
    levels = maps.nonseparable_maps(12)
    results = []
    for train, val, test in (([8, 9], 10, 11), ([8, 9, 10], 11, 12)):
        if not os.path.exists(os.path.join(DATA, f"level_{test}.npz")):
            continue
        r = run_round(train, val, test, levels)
        results.append(r)
        print(json.dumps(r, indent=1), flush=True)
    json.dump(results, open(os.path.join(DATA, "evaluation.json"), "w"), indent=1)


if __name__ == "__main__" and len(sys.argv) == 1:
    main()


def compact(feat):
    global FEATSET
    FEATSET = feat
    levels = maps.nonseparable_maps(12)
    lines = []
    for train, val, test in (([8, 9], 10, 11), ([8, 9, 10], 11, 12), ([8, 9, 11], 10, 12)):
        r = run_round(train, val, test, levels)
        ml = [x for x in r["strategies"] if x["strategy"].startswith("ML (")][0]
        hom = [x for x in r["strategies"] if x["strategy"].startswith("HOMFLY")][0]
        lines.append(f"{feat:5s} train={train} val={val} test={test}: AUC={r['auc_test']:.3f} "
                     f"ML saves {ml['saved_pct']:5.1f}% found {ml['knots_found']}/{ml['knots_needed']}"
                     f" | HOMFLY-lookup saves {hom['saved_pct']:5.1f}% found {hom['knots_found']}/{hom['knots_needed']}"
                     f" | oracle saves {[x for x in r['strategies'] if x['strategy'].startswith('oracle')][0]['saved_pct']}%")
        print(lines[-1], flush=True)
    return lines


if __name__ == "__main__" and len(sys.argv) > 1:
    for f in sys.argv[1:]:
        compact(f)
