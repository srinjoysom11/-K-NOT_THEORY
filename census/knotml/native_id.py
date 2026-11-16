"""Canonical knot identity with the extracted SnapPea kernel (kernel/snapcanon): no Python in the loop.

Hyperbolic knots get 'H:' + Regina isomorphism signature of the canonical retriangulation
(byte-identical to SnapPy's isometry_signature on 10,880 test diagrams).  Anything the kernel
reports as non-hyperbolic falls back to 'N:' + mirror-invariant HOMFLY key, as before."""
import os, subprocess, tempfile
import regina
from . import pipeline as P
from .diagrams import homfly_key

CLI = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "kernel", "snapcanon", "snapcanon_cli")


def native_ids(pds, retri=25, nproc=None):
    nproc = nproc or P.NPROC
    ids = [None] * len(pds)
    with tempfile.TemporaryDirectory() as tmp:
        path = os.path.join(tmp, "in.txt")
        with open(path, "w") as f:
            for i, pd in enumerate(pds):
                f.write(f"{i} {len(pd)} " + " ".join(str(v) for t in pd for v in t) + "\n")
        procs = [subprocess.Popen([CLI, "--retriangulations", str(retri), "--shard", str(s), str(nproc), path],
                                  stdout=open(os.path.join(tmp, f"o{s}.txt"), "w"), stderr=subprocess.DEVNULL) for s in range(nproc)]
        for p in procs:
            p.wait()
        for s in range(nproc):
            for line in open(os.path.join(tmp, f"o{s}.txt")):
                t = line.split()
                i, status = int(t[0]), int(t[1])
                ids[i] = "H:" + t[2] if status == 0 else None
    for i, v in enumerate(ids):                       # non-hyperbolic / failures: HOMFLY fallback
        if v is None:
            ids[i] = "N:" + homfly_key(regina.Link.fromPD([tuple(t) for t in pds[i]]))
    return ids
