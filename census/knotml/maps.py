"""Enumeration of knot shadows (planar 4-regular maps) without plantri.

Every connected 4-regular plane map is the medial graph of a plane graph M
with n edges (M and its dual give the same medial graph).  A knot diagram
is "prime and reduced" only if M is non-separable (2-connected, loopless),
so we enumerate non-separable plane maps edge by edge and take medials.

Non-separable maps with m edges arise from those with m-1 edges by
(a) adding an edge inside a face, or (b) splitting a vertex in two joined by
a new edge (inverse of deletion / contraction; Tutte: one of the two always
leaves a non-separable map).  Maps are rotation systems:
    darts 2i, 2i+1 form edge i; sigma[d] = next dart counter-clockwise
    around the origin vertex of d.
"""
from __future__ import annotations


def vertices(sigma):
    """Return (vid, cycles): vertex id per dart and list of dart cycles."""
    vid = [-1] * len(sigma)
    cycles = []
    for d in range(len(sigma)):
        if vid[d] >= 0:
            continue
        cyc, x = [], d
        while vid[x] < 0:
            vid[x] = len(cycles)
            cyc.append(x)
            x = sigma[x]
        cycles.append(cyc)
    return vid, cycles


def face_cycles(sigma, alpha=None):
    """Faces as cycles of phi(d) = sigma(alpha(d))."""
    n = len(sigma)
    seen = [False] * n
    out = []
    for d in range(n):
        if seen[d]:
            continue
        cyc, x = [], d
        while not seen[x]:
            seen[x] = True
            cyc.append(x)
            x = sigma[x ^ 1] if alpha is None else sigma[alpha[x]]
        out.append(cyc)
    return out


def is_nonseparable(sigma):
    """Loopless, connected, no cut vertex (K2 counts as non-separable)."""
    m = len(sigma) // 2
    vid, cycles = vertices(sigma)
    nv = len(cycles)
    adj = [[] for _ in range(nv)]
    for e in range(m):
        a, b = vid[2 * e], vid[2 * e + 1]
        if a == b:
            return False
        adj[a].append(b)
        adj[b].append(a)
    if nv == 2:
        return True
    # connectivity + articulation points (iterative Tarjan)
    disc = [-1] * nv
    low = [0] * nv
    t = 0
    root = 0
    disc[0] = low[0] = 0
    t = 1
    stack = [(0, -1, iter(adj[0]))]
    root_children = 0
    while stack:
        v, parent, it = stack[-1]
        advanced = False
        for w in it:
            if disc[w] < 0:
                disc[w] = low[w] = t
                t += 1
                stack.append((w, v, iter(adj[w])))
                if v == root:
                    root_children += 1
                advanced = True
                break
            elif w != parent:
                if disc[w] < low[v]:
                    low[v] = disc[w]
        if advanced:
            continue
        stack.pop()
        if stack:
            p = stack[-1][0]
            if low[v] < low[p]:
                low[p] = low[v]
            if p != root and low[v] >= disc[p]:
                return False
    if t != nv:
        return False
    if root_children > 1:
        return False
    return True


def canon(sigma, alpha=None):
    """Canonical code of a connected map up to isomorphism and reflection.

    Only darts with the minimal local signature are used as BFS roots.  The
    signature (sizes of the two faces on the edge of d, degree of its vertex)
    is invariant under isomorphism and reflection, so the set of roots is
    too, and the canonical code is unchanged but far cheaper to compute."""
    nd = len(sigma)
    if alpha is None:
        alpha = [d ^ 1 for d in range(nd)]
    sinv = [0] * nd
    for d, s in enumerate(sigma):
        sinv[s] = d
    face_size = [0] * nd
    for cyc in face_cycles(sigma, alpha):
        for d in cyc:
            face_size[d] = len(cyc)
    deg = [0] * nd
    seen = [False] * nd
    for d in range(nd):
        if not seen[d]:
            cyc, x = [], d
            while not seen[x]:
                seen[x] = True; cyc.append(x); x = sigma[x]
            for y in cyc:
                deg[y] = len(cyc)
    # face of dart d = cycle of phi containing d; the other face on its edge contains alpha(d)
    sig = [(deg[d],) + tuple(sorted((face_size[d], face_size[alpha[d]]))) for d in range(nd)]
    m = min(sig)
    roots = [d for d in range(nd) if sig[d] == m]
    best = None
    for rot in (sigma, sinv):
        for s in roots:
            lab = [-1] * nd
            order = [s]
            lab[s] = 0
            i = 0
            while i < len(order):
                d = order[i]
                i += 1
                for x in (alpha[d], rot[d]):
                    if lab[x] < 0:
                        lab[x] = len(order)
                        order.append(x)
            code = tuple(v for d in order for v in (lab[alpha[d]], lab[rot[d]]))
            if best is None or code < best:
                best = code
    return best


def _add_edge_children(sigma):
    m = len(sigma) // 2
    vid, _ = vertices(sigma)
    x, y = 2 * m, 2 * m + 1
    for face in face_cycles(sigma):
        corners = [d ^ 1 for d in face]          # corner = gap after dart a
        for i in range(len(corners)):
            a1 = corners[i]
            for j in range(i + 1, len(corners)):
                a2 = corners[j]
                if vid[a1] == vid[a2]:
                    continue
                s2 = list(sigma) + [0, 0]
                s2[x] = sigma[a1]; s2[a1] = x
                s2[y] = sigma[a2]; s2[a2] = y
                yield s2


def _split_children(sigma):
    m = len(sigma) // 2
    _, cycles = vertices(sigma)
    x, y = 2 * m, 2 * m + 1
    for cyc in cycles:
        k = len(cyc)
        if k < 2:
            continue
        for l in range(1, k // 2 + 1):
            for i in range(k):
                if 2 * l == k and i >= l:
                    continue
                A = [cyc[(i + t) % k] for t in range(l)]
                B = [cyc[(i + l + t) % k] for t in range(k - l)]
                s2 = list(sigma) + [0, 0]
                for arc, new in ((A, x), (B, y)):
                    for t in range(len(arc) - 1):
                        s2[arc[t]] = arc[t + 1]
                    s2[arc[-1]] = new
                    s2[new] = arc[0]
                yield s2


def nonseparable_maps(max_edges):
    """dict m -> list of sigma (one per iso class up to reflection)."""
    k2 = [1, 0]            # one edge, two degree-1 vertices
    levels = {1: [k2]}
    for m in range(2, max_edges + 1):
        seen = {}
        for s in levels[m - 1]:
            for child in list(_add_edge_children(s)) + list(_split_children(s)):
                if not is_nonseparable(child):
                    continue
                c = canon(child)
                if c not in seen:
                    seen[c] = child
        levels[m] = list(seen.values())
    return levels


def medial(sigma):
    """Medial map of M: returns (sigma_m, alpha_m) on 4n darts, n = edges of M."""
    n = len(sigma) // 2
    sinv = [0] * len(sigma)
    for d, s in enumerate(sigma):
        sinv[s] = d

    def after(x):
        return 4 * (x >> 1) + (1 if x % 2 == 0 else 3)

    def before(x):
        return 4 * (x >> 1) + (2 if x % 2 == 0 else 0)

    sig_m = [0] * (4 * n)
    alp_m = [0] * (4 * n)
    for i in range(n):
        d, dp = 2 * i, 2 * i + 1
        for p in range(4):
            h = 4 * i + p
            sig_m[h] = 4 * i + (p + 1) % 4
        alp_m[4 * i + 1] = before(sigma[d])
        alp_m[4 * i + 3] = before(sigma[dp])
        alp_m[4 * i + 2] = after(sinv[d])
        alp_m[4 * i + 0] = after(sinv[dp])
    return sig_m, alp_m


def knot_shadows(n, levels=None):
    """All single-component prime reduced shadows with n crossings,
    as (sigma_m, alpha_m, passes) with the knot traversal precomputed."""
    if levels is None:
        levels = nonseparable_maps(n)
    seen = {}
    for s in levels[n]:
        sm, am = medial(s)
        c = canon(sm, am)
        if c in seen:
            continue
        if len(face_cycles(sm, am)) != n + 2:
            raise AssertionError("medial map is not planar: construction bug")
        seen[c] = (sm, am)
    out = []
    for sm, am in seen.values():
        sh = Shadow(sm, am)
        if sh.single_component:
            out.append(sh)
    return out


class Shadow:
    """A planar 4-regular map with knot traversal and edge labels."""

    def __init__(self, sig_m, alp_m):
        self.sig, self.alp = sig_m, alp_m
        self.n = len(sig_m) // 4
        n = self.n
        # traverse straight through crossings starting from half-edge 0
        lab = [0] * (4 * n)
        passes = []                       # (crossing, arrival position)
        h = 0
        k = 0
        while True:
            k += 1
            a = self.alp[h]
            lab[h] = lab[a] = k
            c, q = a >> 2, a & 3
            passes.append((c, q))
            h = 4 * c + (q + 2) % 4
            if h == 0 or k > 2 * n:
                break
        self.single_component = (h == 0 and k == 2 * n)
        self.lab, self.passes = lab, passes
        if self.single_component:
            self.faces = face_cycles(sig_m, alp_m)
            self.arr = [[None, None] for _ in range(n)]  # arrival pos by parity
            for c, q in passes:
                self.arr[c][q & 1] = q
