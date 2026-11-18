#!/usr/bin/env python3
"""Computed figures for the paper.  Every figure is drawn from exact data: the words, the projection
code of research/exact/formal (the same definitions as Len52/Diagram.lean), and the proof-run logs.

  polygon36.pdf   the 36-step polygon in space and its diagram along (1,-1,4), arcs coloured
  pdcompare.pdf   the diagram of w36 with PD edge labels next to the KnotInfo diagram of 5_2
  std52.pdf       the standard diagram of 5_2: edges, crossings, arcs and a non-constant 7-colouring
  trefoil3.pdf    a Fox 3-colouring of the trefoil
  certex.pdf      the worked certificate example (a 24-step trefoil polygon)
  growth.pdf      search nodes and words per length, with fitted exponential laws
  growth_table.tex, numbers.tex, certex.tex   numbers quoted in the text
"""
import os, sys, re, glob, math, itertools
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Line3DCollection
HERE = os.path.dirname(os.path.abspath(__file__))
EX = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, os.path.join(EX, "formal")); sys.path.insert(0, HERE)
from projections import diagram, verts, proj, height
from pd_certificate import pd_code, variants, mirror
from knotdraw import Diagram, draw, point, tangent

plt.rcParams.update({"font.family": "serif", "font.size": 9, "mathtext.fontset": "cm",
                     "pdf.fonttype": 42})
W36 = "eeennuwwwwssseennwuueedddnnuuswsswdd"
DFIG = (1, -1, 4)            # Lean: Len52.Figure (same crossings and PD code as D52 = (1,-19,40))
STD = [[1, 5, 2, 4], [3, 9, 4, 8], [5, 1, 6, 10], [7, 3, 8, 2], [9, 7, 10, 6]]
# Okabe-Ito colours, one per colour value 0..6 (colour-blind safe)
COL = {0: "#0072B2", 1: "#D55E00", 2: "#009E73", 3: "#CC79A7", 4: "#7A5230", 5: "#56B4E9", 6: "#7f7f7f"}
X52 = [0, 1, 3, 4, 2]        # Lean x52: the colouring of arcs 0..4 of the w36 diagram


class Placer:
    """choose label positions far from the drawn curves and from earlier labels"""
    def __init__(self, curve_pts):
        self.C = np.asarray(curve_pts, float); self.L = []
    def best(self, cands):
        def score(p):
            d = np.min(np.linalg.norm(self.C - p, axis=1))
            if self.L: d = min(d, 0.8 * np.min(np.linalg.norm(np.array(self.L) - p, axis=1)))
            return d
        p = max(cands, key=score); self.L.append(p); return p


def dense(polys, k=12):
    out = []
    for poly in polys:
        poly = np.asarray(poly, float)
        for a, b in zip(poly, poly[1:]):
            for f in np.linspace(0, 1, k, endpoint=False): out.append(a + f * (b - a))
    return np.array(out)


def save(fig, name):
    fig.savefig(os.path.join(HERE, name), bbox_inches="tight", pad_inches=0.02)
    plt.close(fig)


# ------------------------------------------------------------------------------------------ w36
def w36_pieces(D):
    """the polygon cut at its under-passages: list of (edge i, t0, t1, arc index)"""
    V = verts(W36); n = len(V)
    cr = diagram(W36, D)
    ev = sorted((i, float(t)) for (i, t, j, u) in cr)
    c = len(ev)
    def arc_of(i, t):
        return (sum(1 for e in ev if e < (i, t)) - 1) % c
    pieces = []
    for i in range(n):
        cuts = [t for (k, t) in ev if k == i]
        pts = [0.0] + cuts + [1.0]
        for a, b in zip(pts, pts[1:]):
            pieces.append((i, a, b, arc_of(i, (a + b) / 2)))
    return V, cr, ev, pieces


def fig_polygon():
    V, cr, ev, pieces = w36_pieces(DFIG)
    n = len(V)
    fig = plt.figure(figsize=(6.6, 3.2))
    ax = fig.add_subplot(1, 2, 1, projection="3d")
    for (i, a, b, arc) in pieces:
        p, q = np.array(V[i], float), np.array(V[(i + 1) % n], float)
        s0, s1 = p + a * (q - p), p + b * (q - p)
        ax.plot(*zip(s0, s1), color=COL[X52[arc]], lw=2.6, solid_capstyle="round")
    xs, ys, zs = zip(*V)
    ax.scatter(xs, ys, zs, s=5, c="k", depthshade=False)
    ax.scatter([0], [0], [0], s=30, c="k", marker="o", depthshade=False)
    ax.text(0, 0, -0.55, "origin", fontsize=7, ha="center")
    for a, (l, h) in zip("xyz", [(min(xs), max(xs)), (min(ys), max(ys)), (min(zs), max(zs))]):
        getattr(ax, f"set_{a}lim")(l - 0.3, h + 0.3)
        getattr(ax, f"set_{a}ticks")(range(l, h + 1))
    ax.set_box_aspect((max(xs) - min(xs) + 0.6, max(ys) - min(ys) + 0.6, max(zs) - min(zs) + 0.6))
    ax.view_init(elev=28, azim=-62)
    ax.tick_params(labelsize=6, pad=-2)
    ax.set_xlabel("$x$", labelpad=-9); ax.set_ylabel("$y$", labelpad=-9); ax.set_zlabel("$z$", labelpad=-9)
    ax.set_title("(a)", loc="left", fontsize=9)
    # projection
    ax2 = fig.add_subplot(1, 2, 2)
    P = [proj(DFIG, v) for v in V]
    gap = 0.32
    under = {}
    for (i, t, j, u) in cr:
        under.setdefault(i, []).append(float(t))
    for (i, a, b, arc) in pieces:
        p, q = np.array(P[i], float), np.array(P[(i + 1) % n], float)
        L = np.linalg.norm(q - p)
        a2 = a + (gap / L if a > 0 else 0); b2 = b - (gap / L if b < 1 else 0)
        s0, s1 = p + a2 * (q - p), p + b2 * (q - p)
        ax2.plot(*zip(s0, s1), color=COL[X52[arc]], lw=2.4, solid_capstyle="round")
    ax2.plot(*P[0], "ko", ms=4)
    ax2.annotate("$v_0$", P[0], xytext=(-12, -9), textcoords="offset points", fontsize=7)
    # crossings numbered in the order of the Lean list
    for k, (i, t, j, u) in enumerate(cr):
        p, q = np.array(P[i], float), np.array(P[(i + 1) % n], float)
        x = p + float(t) * (q - p)
        ax2.add_patch(plt.Circle(x, 0.55, fill=False, lw=0.6, ls=(0, (2, 1.5)), color="0.35"))
    # colour values on the arcs
    lab = {}
    for (i, a, b, arc) in pieces:
        if b - a < 0.99 or arc in lab: continue
        p, q = np.array(P[i], float), np.array(P[(i + 1) % n], float)
        if np.linalg.norm(q - p) < 2.5: continue
        lab[arc] = (p + q) / 2
    for arc, x in lab.items():
        ax2.text(x[0], x[1], str(X52[arc]), fontsize=7, ha="center", va="center", color="white",
                 bbox=dict(boxstyle="circle,pad=0.18", fc=COL[X52[arc]], ec="none"))
    ax2.set_aspect("equal"); ax2.axis("off")
    ax2.set_title("(b)", loc="left", fontsize=9)
    fig.subplots_adjust(wspace=0.05)
    save(fig, "polygon36.pdf")


# ------------------------------------------------------------------------------- standard 5_2
def smooth52():
    """a twist-knot drawing of 5_2: a band bent into a ring, three half-twists at the bottom and a
    clasp at the top.  Returns the closed polyline."""
    def sm(x):
        x = min(1, max(0, x)); return x * x * (3 - 2 * x)
    A, B, Mid = (1.25, 2.05), (1.65, 2.45), (1.55, 2.15)
    def radii(th):
        if th <= 120: return A
        if th <= 180:
            f = sm((th - 120) / 60); return tuple(a * (1 - f) + m * f for a, m in zip(A, Mid))
        if th <= 360: return Mid
        if th <= 420:
            f = sm((th - 360) / 60); return tuple(m * (1 - f) + b * f for m, b in zip(Mid, B))
        return B
    def s(th):
        if th <= 207: return -1
        if th >= 333: return 1
        return -math.cos(math.pi * (th - 207) / 42)
    def lane(th, sign):
        i, o = radii(th); return (i + o) / 2 + sign * (o - i) / 2 * s(th)
    def pol(r, th):
        return (r * math.cos(math.radians(th)), r * math.sin(math.radians(th)))
    pts = [pol(lane(th, 1), th) for th in np.linspace(60, 480, 1400, endpoint=False)]
    for end, sgn, a, b in ((480, 1, 1, -1), ):
        pass
    r0, r1 = lane(480, 1), lane(480, -1)
    for ph in np.linspace(0, math.pi, 50, endpoint=False):
        r = (r0 + r1) / 2 + (r0 - r1) / 2 * math.cos(ph)
        pts.append(pol(r, 480 + math.degrees(0.5 * abs(r0 - r1) * math.sin(ph) / ((r0 + r1) / 2))))
    pts += [pol(lane(th, -1), th) for th in np.linspace(480, 60, 1400, endpoint=False)]
    r0, r1 = lane(60, -1), lane(60, 1)
    for ph in np.linspace(0, math.pi, 50, endpoint=False):
        r = (r0 + r1) / 2 + (r0 - r1) / 2 * math.cos(ph)
        pts.append(pol(r, 60 - math.degrees(0.5 * abs(r0 - r1) * math.sin(ph) / ((r0 + r1) / 2))))
    return np.array(pts)


def relabel_to(pd, target):
    """a relabelling f (rotation/reversal of the labels) with f(pd) = target as multisets, and the
    permutation of crossings; None if none exists"""
    m = 2 * len(pd)
    for s in range(m):
        for rev in (False, True):
            f = (lambda x, s=s: (x - 1 + s) % m + 1) if not rev else (lambda x, s=s: (s - (x - 1)) % m + 1)
            Y = [[f(c), f(d), f(a), f(b)] if rev else [f(a), f(b), f(c), f(d)] for a, b, c, d in pd]
            if sorted(Y) == sorted(target):
                return f, rev, [target.index(y) for y in Y]
    return None


def std_diagram():
    D = Diagram(smooth52(), over_first=False)
    pd = D.pd()
    f, rev, perm = relabel_to(pd, STD)
    return D, pd, f, rev, perm


def label_edges(ax, D, f, off=0.2, fs=7, color="0.15", placer=None):
    P = D.P
    pl = placer or Placer(dense([np.vstack([P, P[:1]])], 2))
    for e in range(1, 2 * D.c + 1):
        a = D.edge_starts[(e - 1) % (2 * D.c)]; b = D.edge_starts[e % (2 * D.c)]
        if b <= a: b += D.N
        cands = []
        for fr in np.linspace(0.2, 0.8, 13):
            s = (a + fr * (b - a)) % D.N
            x = point(P, s); t = tangent(P, s); t = t / np.linalg.norm(t)
            nrm = np.array([-t[1], t[0]])
            for sg in (1, -1):
                for o in (off, 1.35 * off):
                    cands.append(x + sg * o * nrm)
        y = pl.best(cands)
        ax.text(y[0], y[1], str(f(e)), fontsize=fs, ha="center", va="center", color=color)
    return pl


def arrow_on(ax, D, f, rev, label=1):
    """an arrow showing the orientation (direction of increasing labels) on edge `label`"""
    e = [k for k in range(1, 2 * D.c + 1) if f(k) == label][0]
    s = D.edge_mid(e)
    x = point(D.P, s); t = tangent(D.P, s); t = t / np.linalg.norm(t)
    if rev: t = -t
    ax.annotate("", xy=x + 0.13 * t, xytext=x - 0.13 * t,
                arrowprops=dict(arrowstyle="-|>", color="0.15", lw=1.2, mutation_scale=10))


def fig_std52():
    D, pd, f, rev, perm = std_diagram()
    # arcs: arc e of the drawing runs from under-passage e to e+1; find its STD name by its edges
    names = {frozenset({2, 3}): "A", frozenset({4, 5}): "B", frozenset({6, 7}): "C",
             frozenset({8, 9}): "D", frozenset({10, 1}): "E"}
    val = {"A": 0, "B": 1, "C": 3, "D": 4, "E": 2}
    arcname = []
    for e in range(D.c):
        a = D.unders[e]; b = D.unders[(e + 1) % D.c]
        if b <= a: b += D.N
        es = {f(k) for k in range(1, 2 * D.c + 1)
              if a < (D.edge_mid(k) if D.edge_mid(k) > a else D.edge_mid(k) + D.N) < b}
        arcname.append(names[frozenset(es)])
    fig, axs = plt.subplots(1, 2, figsize=(6.4, 3.25))
    for ax, coloured in zip(axs, (False, True)):
        cols = [COL[val[nm]] for nm in arcname] if coloured else None
        draw(ax, D, colors=cols, gap=0.11, lw=2.3)
        ax.set_aspect("equal"); ax.axis("off")
    # left: edges and crossings
    pl = Placer(dense([np.vstack([D.P, D.P[:1]])], 2))
    for k, (u, o) in enumerate(D.cr):
        x = point(D.P, u)
        cands = [x + 0.3 * np.array([math.cos(a), math.sin(a)]) for a in np.linspace(0, 2 * math.pi, 16, endpoint=False)]
        y = pl.best(cands)
        axs[0].text(y[0], y[1], f"$X_{perm[k] + 1}$", fontsize=8, ha="center", va="center", color="#8a1c1c")
        axs[0].plot(*x, "o", ms=2.5, color="#8a1c1c")
    label_edges(axs[0], D, f, off=0.17, placer=pl)
    arrow_on(axs[0], D, f, rev)
    axs[0].set_title("(a)", loc="left", fontsize=9)
    # right: arcs and colours
    pl = Placer(dense([np.vstack([D.P, D.P[:1]])], 2))
    for e in range(D.c):
        a = D.unders[e]; b = D.unders[(e + 1) % D.c]
        if b <= a: b += D.N
        cands = []
        for fr in np.linspace(0.25, 0.75, 11):
            s = (a + fr * (b - a)) % D.N
            x = point(D.P, s); t = tangent(D.P, s); t = t / np.linalg.norm(t)
            for sg in (1, -1): cands.append(x + sg * 0.27 * np.array([-t[1], t[0]]))
        y = pl.best(cands)
        nm = arcname[e]
        axs[1].text(y[0], y[1], f"{nm}$={val[nm]}$", fontsize=7.5, ha="center", va="center",
                    color=COL[val[nm]], fontweight="bold")
    axs[1].set_title("(b)", loc="left", fontsize=9)
    fig.subplots_adjust(wspace=0.08)
    save(fig, "std52.pdf")
    return D, pd


def fig_pdcompare():
    """left: the diagram of w36 with its PD edge labels after the relabelling x -> x+6; right: the
    standard diagram with KnotInfo labels"""
    V = verts(W36); n = len(V)
    P = [np.array(proj(DFIG, v), float) for v in V]
    cr = diagram(W36, DFIG)
    pas = sorted([((i, float(t)), k, 0) for k, (i, t, j, u) in enumerate(cr)] +
                 [((j, float(u)), k, 1) for k, (i, t, j, u) in enumerate(cr)])
    m = len(pas)
    shift = lambda x: (x - 1 + 6) % m + 1
    fig, axs = plt.subplots(1, 2, figsize=(6.5, 3.3), gridspec_kw=dict(width_ratios=[1.12, 1]))
    ax = axs[0]
    gap = 0.32
    for i in range(n):
        p, q = P[i], P[(i + 1) % n]; L = np.linalg.norm(q - p)
        cuts = sorted(float(t) for (ii, t, j, u) in cr if ii == i)
        pts = [0.0] + cuts + [1.0]
        for a, b in zip(pts, pts[1:]):
            a2 = a + (gap / L if a > 0 else 0); b2 = b - (gap / L if b < 1 else 0)
            ax.plot(*zip(p + a2 * (q - p), p + b2 * (q - p)), color="0.15", lw=1.9, solid_capstyle="round")
    # edge labels: the edge with label e+1 runs from passage e to passage e+1 (curve parameter i + t)
    polys = [np.array(P + [P[0]])]
    pl = Placer(dense(polys, 20))
    def at(sv):
        i = int(math.floor(sv)) % n; fr = sv - math.floor(sv)
        return P[i] + fr * (P[(i + 1) % n] - P[i]), P[(i + 1) % n] - P[i]
    for e in range(m):
        (i0, t0), (i1, t1) = pas[e][0], pas[(e + 1) % m][0]
        a, b = i0 + t0, i1 + t1
        if b <= a: b += n
        cands = []
        for sv in np.linspace(a + 0.25, b - 0.25, max(3, int((b - a) * 6))):
            x, d = at(sv); d = d / np.linalg.norm(d); nr = np.array([-d[1], d[0]])
            for sg in (1, -1): cands.append(x + sg * 0.55 * nr)
        y = pl.best(cands)
        ax.text(y[0], y[1], str(shift(e + 1)), fontsize=7.5, ha="center", va="center", color="#1f3b73")
    for k, (i, t, j, u) in enumerate(cr):
        x = P[i] + float(t) * (P[(i + 1) % n] - P[i])
        ax.plot(*x, "o", ms=2.5, color="#8a1c1c")
    # orientation arrow on edge 0
    d = P[1] - P[0]
    ax.annotate("", xy=P[0] + 0.75 * d, xytext=P[0] + 0.45 * d,
                arrowprops=dict(arrowstyle="-|>", color="0.15", lw=1.2, mutation_scale=9))
    ax.set_aspect("equal"); ax.axis("off")
    ax.set_title("(a)", loc="left", fontsize=9)
    D, pd, f, rev, perm = std_diagram()
    draw(axs[1], D, gap=0.11, lw=1.9, base="0.15")
    label_edges(axs[1], D, f, off=0.17, color="#1f3b73")
    for k, (u, o) in enumerate(D.cr):
        axs[1].plot(*point(D.P, u), "o", ms=2.5, color="#8a1c1c")
    arrow_on(axs[1], D, f, rev)
    axs[1].set_aspect("equal"); axs[1].axis("off")
    axs[1].set_title("(b)", loc="left", fontsize=9)
    save(fig, "pdcompare.pdf")
    return [[shift(x) for x in X] for X in pd_code(W36, DFIG)]


# ------------------------------------------------------------------------------------- trefoil
def fig_trefoil():
    t = np.linspace(0, 2 * np.pi, 1500, endpoint=False)
    P = np.c_[np.sin(t) + 2 * np.sin(2 * t), np.cos(t) - 2 * np.cos(2 * t)]
    Z = -np.sin(3 * t)
    N = len(P)
    def zat(s):
        i = int(s) % N; fr = s - int(s); return Z[i] * (1 - fr) + Z[(i + 1) % N] * fr
    D = Diagram(P, overs=lambda s, u: zat(s) > zat(u))
    cols = D.colorings(3)
    x = [c for c in cols if len(set(c)) == 3][0]
    fig, axs = plt.subplots(1, 2, figsize=(5.6, 2.6), gridspec_kw=dict(width_ratios=[1, 1.25]))
    # crossing rule
    ax = axs[0]
    ax.plot([-1, 1], [-1, 1], color=COL[0], lw=2.6, solid_capstyle="round")
    ax.plot([1, 0.17], [-1, -0.17], color=COL[1], lw=2.6, solid_capstyle="round")
    ax.plot([-0.17, -1], [0.17, 1], color=COL[2], lw=2.6, solid_capstyle="round")
    ax.annotate("", xy=(-0.8, 0.8), xytext=(-0.55, 0.55), arrowprops=dict(arrowstyle="-|>", color=COL[2], lw=1.4))
    ax.text(0.78, 1.0, "over-arc $a$", fontsize=8, color=COL[0], ha="left")
    ax.text(1.05, -1.05, "$b$ (in)", fontsize=8, color=COL[1], ha="left")
    ax.text(-1.05, 1.08, "$c$ (out)", fontsize=8, color=COL[2], ha="right")
    ax.text(0, -1.55, "$2a\\equiv b+c$  (mod $p$)", fontsize=9, ha="center")
    ax.set_xlim(-1.9, 2.1); ax.set_ylim(-1.8, 1.4); ax.set_aspect("equal"); ax.axis("off")
    ax.set_title("(a)", loc="left", fontsize=9)
    ax = axs[1]
    tc = {0: COL[0], 1: COL[1], 2: COL[2]}
    draw(ax, D, colors=[tc[v] for v in x], gap=0.17, lw=2.6)
    for e in range(D.c):
        a = D.unders[e]; b = D.unders[(e + 1) % D.c]
        if b <= a: b += D.N
        s = ((a + b) / 2) % D.N; p = point(D.P, s); c = p / np.linalg.norm(p)
        y = p + 0.45 * c
        ax.text(y[0], y[1], str(x[e]), fontsize=8.5, color="white", ha="center", va="center",
                bbox=dict(boxstyle="circle,pad=0.2", fc=tc[x[e]], ec="none"))
    ax.set_aspect("equal"); ax.axis("off")
    ax.set_title("(b)", loc="left", fontsize=9)
    save(fig, "trefoil3.pdf")
    return len(cols)


# --------------------------------------------------------------------------- certificate example
CW = "eeeuuswwdnneeesswwnuwwdd"
CD = (7, 13, 31)


def solve_cert(F, p=7):
    """L with c-1 rows, row k of L F = e_{k+1} - e_0 (k = 0..c-2), by elimination mod p"""
    c = len(F)
    # we want rows L_k with L_k F = e_{k+1} - e_0, i.e. F^T L_k^T = (e_{k+1}-e_0)^T
    FT = [[F[r][q] % p for r in range(c)] for q in range(c)]
    sols = []
    for k in range(1, c):
        rhs = [(1 if q == k else 0) - (1 if q == 0 else 0) for q in range(c)]
        M = [FT[q][:] + [rhs[q] % p] for q in range(c)]
        piv = []; r = 0
        for col in range(c):
            pr = next((i for i in range(r, c) if M[i][col] % p), None)
            if pr is None: continue
            M[r], M[pr] = M[pr], M[r]
            inv = pow(M[r][col], p - 2, p); M[r] = [v * inv % p for v in M[r]]
            for i in range(c):
                if i != r and M[i][col]:
                    fct = M[i][col]; M[i] = [(a - fct * b) % p for a, b in zip(M[i], M[r])]
            piv.append(col); r += 1
        assert all(M[i][c] == 0 for i in range(r, c))
        x = [0] * c
        for i, col in enumerate(piv): x[col] = M[i][c]
        sols.append(x)
    return sols


def fig_certex():
    V = verts(CW); n = len(V)
    cr = diagram(CW, CD)
    ev = sorted((i, t) for (i, t, j, u) in cr); idx = {e: k for k, e in enumerate(ev)}
    c = len(ev)
    def arc_at(j, u): return (sum(1 for e in ev if e < (j, u)) - 1) % c
    F = []
    for (i, t, j, u) in cr:
        e = idx[(i, t)]; o = arc_at(j, u); row = [0] * c
        row[o] += 2; row[(e - 1) % c] -= 1; row[e] -= 1; F.append(row)
    # order the rows by under-passage (crossing e has under-passage u_e)
    order = sorted(range(c), key=lambda k: idx[(cr[k][0], cr[k][1])])
    F = [F[k] for k in order]
    L = solve_cert(F)
    LF = [[sum(L[r][q] * F[q][col] for q in range(c)) % 7 for col in range(c)] for r in range(c - 1)]
    # figure: 3D and diagram
    fig = plt.figure(figsize=(6.2, 2.7))
    ax = fig.add_subplot(1, 2, 1, projection="3d")
    P3 = V + [V[0]]
    pieces = []
    for i in range(n):
        cuts = [float(t) for (k, t) in ev if k == i]
        pts = [0.0] + cuts + [1.0]
        for a, b in zip(pts, pts[1:]):
            pieces.append((i, a, b, arc_at(i, (a + b) / 2)))
    ac = [COL[0], COL[1], COL[2]]
    for (i, a, b, arc) in pieces:
        p, q = np.array(P3[i], float), np.array(P3[i + 1], float)
        ax.plot(*zip(p + a * (q - p), p + b * (q - p)), color=ac[arc], lw=2.6, solid_capstyle="round")
    xs, ys, zs = zip(*V)
    ax.scatter(xs, ys, zs, s=5, c="k", depthshade=False)
    ax.scatter([0], [0], [0], s=26, c="k", depthshade=False)
    for a, (l, h) in zip("xyz", [(min(xs), max(xs)), (min(ys), max(ys)), (min(zs), max(zs))]):
        getattr(ax, f"set_{a}lim")(l - 0.3, h + 0.3); getattr(ax, f"set_{a}ticks")(range(l, h + 1))
    ax.set_box_aspect((max(xs) - min(xs) + 0.6, max(ys) - min(ys) + 0.6, max(zs) - min(zs) + 0.6))
    ax.view_init(elev=30, azim=-58); ax.tick_params(labelsize=6, pad=-2)
    ax.set_xlabel("$x$", labelpad=-9); ax.set_ylabel("$y$", labelpad=-9); ax.set_zlabel("$z$", labelpad=-9)
    ax.set_title("(a)", loc="left", fontsize=9)
    ax2 = fig.add_subplot(1, 2, 2)
    P = [np.array(proj(CD, v), float) for v in V]
    gap = 4.5
    for (i, a, b, arc) in pieces:
        p, q = P[i], P[(i + 1) % n]; L_ = np.linalg.norm(q - p)
        a2 = a + (gap / L_ if a > 0 else 0); b2 = b - (gap / L_ if b < 1 else 0)
        ax2.plot(*zip(p + a2 * (q - p), p + b2 * (q - p)), color=ac[arc], lw=2.4, solid_capstyle="round")
    for e, (i, t) in enumerate(ev):
        x = P[i] + float(t) * (P[(i + 1) % n] - P[i])
        ax2.text(x[0] + 6, x[1] + 6, f"$u_{e}$", fontsize=7.5, color="0.2")
    lab = {}
    for (i, a, b, arc) in pieces:
        Lseg = np.linalg.norm(P[(i + 1) % n] - P[i]) * (b - a)
        if arc not in lab or Lseg > lab[arc][0]:
            lab[arc] = (Lseg, P[i] + (a + b) / 2 * (P[(i + 1) % n] - P[i]))
    for arc, (_, x) in lab.items():
        ax2.text(x[0], x[1], f"{arc}", fontsize=7, color="white", ha="center", va="center",
                 bbox=dict(boxstyle="circle,pad=0.18", fc=ac[arc], ec="none"))
    ax2.plot(*P[0], "ko", ms=3.5)
    ax2.set_aspect("equal"); ax2.axis("off")
    ax2.set_title("(b)", loc="left", fontsize=9)
    save(fig, "certex.pdf")
    def mat(M):
        return "\\begin{pmatrix}" + "\\\\".join("&".join(str(v) for v in r) for r in M) + "\\end{pmatrix}"
    Fm = [[v % 7 for v in r] for r in F]
    with open(os.path.join(HERE, "certex.tex"), "w") as fo:
        fo.write("\\newcommand{\\CertF}{%s}\n" % mat(F))
        fo.write("\\newcommand{\\CertFmod}{%s}\n" % mat(Fm))
        fo.write("\\newcommand{\\CertL}{%s}\n" % mat(L))
        fo.write("\\newcommand{\\CertLF}{%s}\n" % mat(LF))
    return F, L, LF


# ------------------------------------------------------------------------------------------ growth
def read_rows():
    rows = {}
    for f in glob.glob(os.path.join(EX, "out/lean/parts/n*_check.part*_*.txt")):
        g = re.search(r"n(\d+)_check\.part(\d+)_(\d+)\.txt$", f)
        n = int(g.group(1))
        lines = open(f).read().strip().splitlines()
        m = re.search(r"nodes=(\d+) words=(\d+) ok=true", lines[-1])
        if not m: continue
        r = rows.setdefault(n, [0, set(), 0, int(g.group(3))])
        r[0] += int(m.group(1)); r[2] += 1
        r[1] |= set(lines[:-1])
    return rows


def fit(ns, ys):
    a, b = np.polyfit(ns, np.log(ys), 1)
    return math.exp(b), math.exp(a)     # y ~ C * q^n


def fig_growth(rows):
    ns = sorted(n for n in rows if rows[n][2] == rows[n][3] and n >= 6)
    nodes = [rows[n][0] for n in ns]
    wn = [n for n in ns if rows[n][1]]; words = [len(rows[n][1]) for n in wn]
    fn = [n for n in ns if n >= 20]
    Cn, qn = fit(fn, [rows[n][0] for n in fn])
    Cw, qw = fit(wn, words)
    fig, axs = plt.subplots(1, 2, figsize=(6.4, 2.6), gridspec_kw=dict(width_ratios=[1.5, 1]))
    ax = axs[0]
    ax.semilogy(ns, nodes, "o", color=COL[0], ms=4, label="search nodes")
    xx = np.linspace(20, 34, 50)
    ax.semilogy(xx, Cn * qn ** xx, "-", color=COL[0], lw=0.9, alpha=0.8,
                label="fit $%.2g\\cdot %.3f^{\\,n}$" % (Cn, qn))
    ax.semilogy(wn, words, "s", color=COL[1], ms=4, label="words returned")
    xw = np.linspace(24, 34, 50)
    ax.semilogy(xw, Cw * qw ** xw, "-", color=COL[1], lw=0.9, alpha=0.8,
                label="fit $%.2g\\cdot %.3f^{\\,n}$" % (Cw, qw))
    ax.set_xlabel("length $n$"); ax.set_xticks(ns); ax.tick_params(labelsize=7)
    ax.grid(alpha=0.3, which="major"); ax.legend(fontsize=6.5, frameon=False, loc="upper left")
    ax.set_title("(a)", loc="left", fontsize=9)
    ax = axs[1]
    rn = [(n, (rows[n][0] / rows[n - 2][0])) for n in ns if n - 2 in ns and n >= 8]
    ax.plot([a for a, b in rn], [b for a, b in rn], "o-", color=COL[0], ms=3.5, lw=1)
    ax.axhline(qn ** 2, color=COL[0], lw=0.8, ls="--")
    ax.text(9, qn ** 2 + 0.06, "fit: $%.2f$" % (qn ** 2), fontsize=7, color=COL[0])
    ax.set_xlabel("length $n$"); ax.set_ylabel("nodes$(n)$ / nodes$(n-2)$", fontsize=8)
    ax.set_xticks([8, 14, 20, 26, 32]); ax.tick_params(labelsize=7); ax.grid(alpha=0.3)
    ax.set_title("(b)", loc="left", fontsize=9)
    fig.tight_layout(); save(fig, "growth.pdf")
    return Cn, qn, Cw, qw, rn


def write_numbers(rows, g):
    Cn, qn, Cw, qw, rn = g
    with open(os.path.join(HERE, "growth_table.tex"), "w") as fo:
        fo.write("\\begin{tabular}{rrrr}\n\\toprule\n$n$ & parts & nodes & words \\\\\n\\midrule\n")
        for n in sorted(rows):
            r = rows[n]
            fo.write(f"{n} & {r[3]} & \\num{{{r[0]}}} & \\num{{{len(r[1])}}} \\\\\n")
        fo.write("\\bottomrule\n\\end{tabular}\n")
    tw = sum(len(rows[n][1]) for n in rows); tn = sum(rows[n][0] for n in rows)
    def tex_num(x, d=2):
        m, e = f"{x:.{d}e}".split("e"); return f"{m}\\times 10^{{{int(e)}}}"
    with open(os.path.join(HERE, "numbers.tex"), "w") as fo:
        fo.write(f"\\newcommand{{\\NWords}}{{\\num{{{tw}}}}}\n")
        fo.write(f"\\newcommand{{\\NNodes}}{{\\num{{{tn:.2e}}}}}\n".replace("e+", "e"))
        fo.write(f"\\newcommand{{\\NodeBase}}{{{qn:.3f}}}\n\\newcommand{{\\NodeConst}}{{{tex_num(Cn)}}}\n")
        fo.write(f"\\newcommand{{\\NodeRatio}}{{{qn**2:.2f}}}\n")
        fo.write(f"\\newcommand{{\\WordBase}}{{{qw:.3f}}}\n\\newcommand{{\\WordConst}}{{{tex_num(Cw)}}}\n")
        fo.write(f"\\newcommand{{\\RatioFirst}}{{{rn[0][1]:.1f}}}\n\\newcommand{{\\RatioLast}}{{{rn[-1][1]:.1f}}}\n")


if __name__ == "__main__":
    fig_polygon()
    D, pd = fig_std52()
    print("standard drawing PD:", pd)
    print("w36 PD relabelled x->x+6:", fig_pdcompare())
    print("trefoil 3-colourings:", fig_trefoil())
    print("certificate:", fig_certex())
    rows = read_rows()
    g = fig_growth(rows)
    write_numbers(rows, g)
    print("growth fits:", g[:4], "ratios:", [(a, round(b, 2)) for a, b in g[4]])
