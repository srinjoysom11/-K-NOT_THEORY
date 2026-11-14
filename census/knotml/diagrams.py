"""From shadows + crossing choices to Regina diagrams, keys and features."""
from __future__ import annotations
import numpy as np
import regina
from .maps import Shadow

N_BUCKETS = 96


def pd_code(sh: Shadow, bits: int):
    """KnotTheory-style PD code.  Crossing c has its under strand on the
    position parity s_c = (bits >> c) & 1."""
    n, lab, arr = sh.n, sh.lab, sh.arr
    pd = []
    for c in range(n):
        s = (bits >> c) & 1
        q = arr[c][s]                     # arrival (incoming) under position
        pd.append([lab[4 * c + (q + t) % 4] for t in range(4)])
    return pd


def make_link(sh: Shadow, bits: int) -> regina.Link:
    return regina.Link.fromPD(pd_code(sh, bits))


def homfly_key(link: regina.Link) -> str:
    """Mirror-invariant HOMFLY-PT key (lexicographically smaller of the two)."""
    a = str(link.homfly())
    m = regina.Link(link)
    m.changeAll()
    b = str(m.homfly())
    return a if a <= b else b


def sig_key(link: regina.Link) -> str:
    return link.knotSig(True, True, True)


def edge_status(sh: Shadow, bits: int):
    """For each edge label: 0 = alternating, 1 = over-over, 2 = under-under."""
    n = sh.n
    ends = {}
    for h in range(4 * n):
        c, p = h >> 2, h & 3
        under = ((p & 1) == ((bits >> c) & 1))
        ends.setdefault(sh.lab[h], []).append(under)
    st = []
    for lbl, (u1, u2) in ends.items():
        st.append(0 if u1 != u2 else (2 if u1 else 1))
    return st, ends


def is_alternating(sh: Shadow, bits: int) -> bool:
    st, _ = edge_status(sh, bits)
    return all(s == 0 for s in st)


def _h(x) -> int:
    return hash(x) & 0x7FFFFFFF


def features(sh: Shadow, bits: int) -> np.ndarray:
    """Cheap, size-normalised features of a diagram (no simplification)."""
    n = sh.n
    f = []
    # --- edge statuses
    st, _ = edge_status(sh, bits)
    st = np.array(st)
    f += [np.mean(st == 0), np.mean(st == 1), np.mean(st == 2)]
    # --- pass sequence: over/under run lengths along the knot
    seq = []
    for c, q in sh.passes:
        seq.append(0 if (q & 1) == ((bits >> c) & 1) else 1)  # 0 = under pass
    seq = np.array(seq)
    runs = []
    L = len(seq)
    start = 0
    while start < L and seq[start] == seq[(start - 1) % L]:
        start += 1
        if start == L:
            break
    if start == L:
        runs = [(seq[0], L)]
    else:
        i, cnt, cur = start, 0, seq[start]
        for k in range(L):
            v = seq[(start + k) % L]
            if v == cur:
                cnt += 1
            else:
                runs.append((cur, cnt))
                cur, cnt = v, 1
        runs.append((cur, cnt))
    rh = np.zeros((2, 6))
    mx = [0, 0]
    for v, ln in runs:
        rh[v, min(ln, 6) - 1] += 1
        mx[v] = max(mx[v], ln)
    f += list(rh.sum(axis=0) / n) + list(np.sort(np.array(mx)) / n) + [len(runs) / n]
    # --- crossing signs
    pos = 0
    sign = [0] * n
    for c in range(n):
        s = (bits >> c) & 1
        q = sh.arr[c][s]
        j, l = sh.lab[4 * c + (q + 1) % 4], sh.lab[4 * c + (q + 3) % 4]
        sign[c] = 1 if (l - j) % (2 * n) == 1 else -1
    sg = np.array(sign)
    f += [min((sg > 0).sum(), (sg < 0).sum()) / n, abs(sg.sum()) / n]
    # --- faces
    fsize = {}
    fk = {}
    corner_face = {}
    for fi, cyc in enumerate(sh.faces):
        k = 0
        for h in cyc:
            c, p = h >> 2, h & 3
            lbl = sh.lab[h]
            k += st[lbl - 1] != 0
            # corner after the next dart: identify corner by arriving dart
            a = sh.alp[h]
            corner_face[a] = fi
        fsize[fi] = len(cyc)
        fk[fi] = k
    hs = np.zeros(8)
    hk = np.zeros((4, 4))
    for fi in fsize:
        hs[min(fsize[fi], 8) - 1] += 1
        if fsize[fi] <= 4:
            hk[fsize[fi] - 1, min(fk[fi], 3)] += 1
    f += list(hs / n) + list(hk.ravel() / n)
    f += [n]
    base = np.array(f, dtype=np.float32)
    # --- hashed local-neighbourhood bags (WL radius 1 and 2)
    lab0 = []
    for c in range(n):
        s = (bits >> c) & 1
        q = sh.arr[c][s]
        # faces around the crossing starting at incoming-under position,
        # corner after dart (c, p) is the face of the dart arriving there
        fs = []
        for t in range(4):
            p = (q + t) % 4
            h = 4 * c + p
            fs.append((fsize[corner_face[h]], int(fk[corner_face[h]])))
        lab0.append(_h((sign[c], tuple(fs))))
    nb = []
    for c in range(n):
        nb.append([lab0[sh.alp[4 * c + p] >> 2] for p in range(4)])
    # rotate neighbour lists to start at the under-incoming position
    lab1 = []
    for c in range(n):
        s = (bits >> c) & 1
        q = sh.arr[c][s]
        lab1.append(_h((lab0[c], tuple(nb[c][(q + t) % 4] for t in range(4)))))
    bag = np.zeros(2 * N_BUCKETS, dtype=np.float32)
    for c in range(n):
        bag[lab0[c] % N_BUCKETS] += 1
        bag[N_BUCKETS + lab1[c] % N_BUCKETS] += 1
    bag /= n
    return np.concatenate([base, bag])


def knot_id(sh: Shadow, bits: int) -> str:
    """Rigorous-as-possible identity of the knot in a diagram.

    Hyperbolic knots: SnapPy isometry signature of the exterior (a canonical
    string; equal signatures => homeomorphic complements => same knot by
    Gordon-Luecke).  Non-hyperbolic knots (torus, composite, unknot): the
    mirror-invariant HOMFLY-PT key (these are rare and handled separately).
    """
    import snappy
    pd = pd_code(sh, bits)
    M = snappy.Link(pd).exterior()
    for _ in range(25):
        if M.solution_type() == "all tetrahedra positively oriented":
            try:
                return "H:" + M.isometry_signature()
            except RuntimeError:
                pass
        M.randomize()
    return "N:" + homfly_key(regina.Link.fromPD(pd))


def alt_bits(sh: Shadow) -> int:
    """Crossing bits of the alternating diagram on this shadow (crossing 0 fixed to bit 0)."""
    n = sh.n
    bit = [None] * n
    for j, (c, q) in enumerate(sh.passes):
        want = (q & 1) if j % 2 == 0 else (q & 1) ^ 1        # even passes go under
        assert bit[c] is None or bit[c] == want, "shadow is not alternating-resolvable"
        bit[c] = want
    if bit[0] == 1:
        bit = [1 - b for b in bit]
    bits = sum(b << c for c, b in enumerate(bit))
    assert is_alternating(sh, bits)
    return bits
