"""Census pipeline pieces: candidate generation, classification, pruning."""
from __future__ import annotations
import json, os, time, pickle
import multiprocessing as mp
import numpy as np
import regina
from . import maps
from .diagrams import (make_link, sig_key, homfly_key, features, is_alternating, knot_id)

DATA = os.environ.get("KNOT_DATA") or os.path.join(os.path.dirname(os.path.dirname(__file__)), "data")
os.makedirs(DATA, exist_ok=True)
NPROC = max(1, os.cpu_count() or 1)

_SHADOWS = []          # filled before forking workers
_MODEL = None


def set_shadows(shadows):
    global _SHADOWS
    _SHADOWS = shadows


def pmap(func, items, chunk=64):
    if NPROC == 1 or len(items) < 2 * chunk:
        return [func(x) for x in items]
    with mp.get_context("fork").Pool(NPROC) as pool:
        return pool.map(func, items, chunksize=chunk)


# ---------------------------------------------------------------- candidates
def _cand_worker(si):
    """All distinct diagrams of one shadow, then Regina simplify() on each.
    Returns survivors plus counts and CPU seconds per sub-stage."""
    sh = _SHADOWS[si]
    n = sh.n
    seen, surv = set(), []
    n_c = n_s = 0
    t_gen = t_simp = 0.0
    for bits in range(0, 1 << n, 2):             # crossing 0 fixed: mirror symmetry
        t0 = time.perf_counter()
        L = make_link(sh, bits)
        k = sig_key(L)
        t1 = time.perf_counter()
        t_gen += t1 - t0
        if k in seen:
            continue
        seen.add(k)
        n_c += 1
        L.simplify()
        t_simp += time.perf_counter() - t1
        if L.size() < n:
            n_s += 1
        else:
            surv.append((si, bits))
    return surv, n_c, n_s, t_gen, t_simp


def candidates(n, shadows):
    """-> survivors of simplify(), n_candidates, n_simplified, cpu_gen, cpu_simp"""
    set_shadows(shadows)
    parts = pmap(_cand_worker, list(range(len(shadows))), chunk=1)
    surv = [c for p in parts for c in p[0]]
    return (surv, sum(p[1] for p in parts), sum(p[2] for p in parts),
            sum(p[3] for p in parts), sum(p[4] for p in parts))


# ------------------------------------------------------------ classification
def _key_worker(item):
    si, bits = item
    return homfly_key(make_link(_SHADOWS[si], bits))


def classify(cands):
    return pmap(_key_worker, cands, chunk=256)


def _feat_worker(item):
    si, bits = item
    sh = _SHADOWS[si]
    return features(sh, bits), is_alternating(sh, bits)


def featurize(cands):
    res = pmap(_feat_worker, cands, chunk=256)
    X = np.stack([r[0] for r in res])
    alt = np.array([r[1] for r in res])
    return X, alt


def _simplify_worker(item):
    si, bits = item
    L = make_link(_SHADOWS[si], bits)
    n0 = L.size()
    L.simplify()
    return L.size() < n0


def simplify_flags(cands):
    return np.array(pmap(_simplify_worker, cands, chunk=256))


def _id_worker(item):
    si, bits = item
    return knot_id(_SHADOWS[si], int(bits))


def identify_all(cands):
    return pmap(_id_worker, cands, chunk=64)


# ----------------------------------------------------------------- bookkeeping
def unknot_id():
    return "N:" + str(regina.Link(1).homfly())


def load_known():
    p = os.path.join(DATA, "known.json")
    if os.path.exists(p):
        return json.load(open(p))
    return {"ids": {unknot_id(): 0}, "levels": {}}


def save_known(k):
    json.dump(k, open(os.path.join(DATA, "known.json"), "w"))
