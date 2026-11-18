"""Draw smooth knot diagrams: a closed polyline in the plane, crossings found numerically, over/under
chosen by a rule, arcs coloured, PD code computed with the convention of Len52/PD.lean."""
import math, itertools
import numpy as np

def crossings(P):
    """P: (N,2) closed polyline.  Returns list of (s, t) with s<t curve parameters (segment index +
    fraction) of the self-intersections."""
    N = len(P); A = P; B = np.roll(P, -1, axis=0)
    out = []
    for i in range(N):
        a, b = A[i], B[i]
        j = np.arange(i + 2, N)
        if i == 0: j = j[j != N - 1]
        if len(j) == 0: continue
        c, d = A[j], B[j]
        r = b - a; s = d - c
        den = r[0] * s[:, 1] - r[1] * s[:, 0]
        qp = c - a
        with np.errstate(divide='ignore', invalid='ignore'):
            t = (qp[:, 0] * s[:, 1] - qp[:, 1] * s[:, 0]) / den
            u = (qp[:, 0] * r[1] - qp[:, 1] * r[0]) / den
        ok = (den != 0) & (t >= 0) & (t < 1) & (u >= 0) & (u < 1)
        for k in np.nonzero(ok)[0]:
            out.append((i + t[k], j[k] + u[k]))
    return out

def point(P, s):
    N = len(P); i = int(math.floor(s)) % N; f = s - math.floor(s)
    return P[i] * (1 - f) + P[(i + 1) % N] * f

def tangent(P, s):
    N = len(P); i = int(math.floor(s)) % N
    return P[(i + 1) % N] - P[i]

class Diagram:
    def __init__(self, P, over_first=True, overs=None):
        """overs: optional function (s_a, s_b) -> True if the strand at s_a is over.
        Default: alternating along the curve, starting with an over-passage if over_first."""
        self.P = np.asarray(P, float); self.N = len(self.P)
        cr = crossings(self.P)
        pas = sorted([(s, k) for k, (s, t) in enumerate(cr)] + [(t, k) for k, (s, t) in enumerate(cr)])
        self.cr = []
        if overs is None:
            ov = {}
            for idx, (s, k) in enumerate(pas):
                ov[(k, s)] = (idx % 2 == 0) == over_first
            for k, (s, t) in enumerate(cr):
                assert ov[(k, s)] != ov[(k, t)], "not alternating-consistent"
                self.cr.append((t, s) if ov[(k, s)] else (s, t))   # (under, over)
        else:
            for (s, t) in cr:
                self.cr.append((t, s) if overs(s, t) else (s, t))
        self.c = len(self.cr)
        self.unders = sorted(u for u, o in self.cr)

    def arc_of(self, s):
        """arc index of curve parameter s (not an under-passage): arc e runs from under e to under e+1"""
        k = sum(1 for u in self.unders if u < s)
        return (k - 1) % self.c

    def fox_rows(self, p=7):
        rows = []
        for (u, o) in self.cr:
            e = self.unders.index(u); row = [0] * self.c
            row[self.arc_of(o)] += 2; row[(e - 1) % self.c] -= 1; row[e] -= 1
            rows.append(row)
        return rows

    def colorings(self, p=7):
        rows = self.fox_rows(p)
        return [x for x in itertools.product(range(p), repeat=self.c)
                if all(sum(a * b for a, b in zip(r, x)) % p == 0 for r in rows)]

    def pd(self):
        """PD code, crossings in the order of self.cr; edge labels 1..2c along the curve from s=0"""
        pas = sorted([(u, k, 0) for k, (u, o) in enumerate(self.cr)] + [(o, k, 1) for k, (u, o) in enumerate(self.cr)])
        m = len(pas); lin = {}; lout = {}
        for e, (s, k, o) in enumerate(pas):
            lin[(k, o)] = (e - 1) % m + 1; lout[(k, o)] = e % m + 1
        X = []
        for k, (u, o) in enumerate(self.cr):
            du = tangent(self.P, u); do = tangent(self.P, o)
            a, c, b, d = lin[(k, 0)], lout[(k, 0)], lin[(k, 1)], lout[(k, 1)]
            crs = (-du[0]) * do[1] - (-du[1]) * do[0]
            X.append([a, d, c, b] if crs > 0 else [a, b, c, d])
        self.edge_starts = [s for s, k, o in pas]      # edge e+1 starts at passage e
        return X

    def edge_mid(self, e):
        """curve parameter of the middle of edge label e (1..2c)"""
        st = self.edge_starts; m = len(st)
        a = st[(e - 1) % m]; b = st[e % m]
        if b <= a: b += self.N
        return ((a + b) / 2) % self.N

def draw(ax, D, colors=None, gap=0.09, lw=2.4, base="#222222", labels=None, label_fn=None):
    """draw the diagram with breaks at under-passages; colors: per-arc colour list"""
    P = D.P; N = D.N
    seglen = np.linalg.norm(np.roll(P, -1, axis=0) - P, axis=1); ds = seglen.mean()
    gp = gap / ds
    cuts = sorted(D.unders)
    # pieces between under-passages
    for e in range(D.c):
        a = cuts[e] + gp; b = cuts[(e + 1) % D.c] - gp
        if b <= a: b += N
        ss = np.linspace(a, b, max(4, int((b - a) * 3)))
        pts = np.array([point(P, s % N) for s in ss])
        ax.plot(pts[:, 0], pts[:, 1], color=(colors[e] if colors else base), lw=lw,
                solid_capstyle="round", zorder=2)
