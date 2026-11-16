"""Cheap knot-invariant features (HOMFLY-PT and Jones) for pruning models."""
from __future__ import annotations
import os, re
import numpy as np
from . import pipeline as P
from .diagrams import make_link

_VAR = re.compile(r"^(-?)([xy])(?:\^(-?\d+))?$")


def parse_terms(s: str, nvars: int):
    """'-x^4 + x^2 y^2 + 2 x^2' -> list of (coef, [exp_x, exp_y])"""
    s = s.replace(" - ", " + -").strip()
    out = []
    for term in s.split(" + "):
        coef, exps = 1, [0, 0]
        for tok in term.split():
            if re.fullmatch(r"-?\d+", tok):
                coef *= int(tok)
            else:
                m = _VAR.match(tok)
                if m is None:
                    raise ValueError(f"cannot parse {tok!r} in {s!r}")
                if m.group(1):
                    coef *= -1
                exps[0 if m.group(2) == "x" else 1] += int(m.group(3)) if m.group(3) else 1
        out.append((coef, exps))
    return out


def inv_features(L, n: int) -> np.ndarray:
    h = parse_terms(str(L.homfly()), 2)
    j = parse_terms(str(L.jones()), 1)
    hx = np.array([e[0] for _, e in h]); hy = np.array([e[1] for _, e in h])
    hc = np.abs(np.array([c for c, _ in h]))
    jx = np.array([e[0] for _, e in j]); jc = np.array([c for c, _ in j])
    jspan = (jx.max() - jx.min()) / 2.0               # span in t
    det = abs(sum(c * (1j) ** int(e) for c, e in zip(jc, jx)))
    f = [jspan, n - jspan, (hx.max() - hx.min()) / 2.0, n - (hx.max() - hx.min()) / 2.0,
         hy.max(), hy.max() - hy.min(), len(h) / n, hc.sum() / n, hc.max(), len(j) / n,
         np.abs(jc).sum() / n, np.log2(max(det, 1.0)), np.log2(max(det, 1.0)) / n]
    return np.array(f, dtype=np.float32)


def _worker(item):
    si, bits = item
    sh = P._SHADOWS[si]
    return inv_features(make_link(sh, int(bits)), sh.n)


def inv_for_level(n, shadows, cands):
    P.set_shadows(shadows)
    return np.stack(P.pmap(_worker, [tuple(c) for c in cands], chunk=128))


def main():
    import sys
    from . import maps
    hi = int(sys.argv[1])
    levels = maps.nonseparable_maps(hi)
    for n in range(8, hi + 1):
        d = np.load(os.path.join(P.DATA, f"level_{n}.npz"))
        sh = maps.knot_shadows(n, levels)
        np.save(os.path.join(P.DATA, f"inv_{n}.npy"), inv_for_level(n, sh, d["cands"]))
        print("inv features", n, flush=True)


if __name__ == "__main__":
    main()
