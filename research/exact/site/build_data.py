#!/usr/bin/env python3
"""Write data.js for the interactive edition.  Every number and every piece of geometry on the page
comes from here, computed with the same code as the paper's figures (paper/figs/make_figs.py, which
uses formal/projections.py, i.e. the definitions of Len52/Diagram.lean) and from the proof-run logs.

Run from anywhere:  python3 research/exact/site/build_data.py
"""
import os, sys, json, math
HERE = os.path.dirname(os.path.abspath(__file__))
EX = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(EX, "paper", "figs")); sys.path.insert(0, os.path.join(EX, "formal"))
import make_figs as MF
from projections import diagram, verts, proj, height
from pd_certificate import pd_code, mirror
import numpy as np

U = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}
REV = {'e': 'w', 'w': 'e', 'n': 's', 's': 'n', 'u': 'd', 'd': 'u'}
AX = {'e': 0, 'w': 0, 'n': 1, 's': 1, 'u': 2, 'd': 2}
R = lambda x: round(float(x), 4)


def polygon_block(word, D, colouring=None):
    """vertices, the pieces between under-passages with their arc, crossings, and the 2D projection"""
    V = verts(word); n = len(V)
    cr = diagram(word, D)
    ev = sorted((i, float(t)) for (i, t, j, u) in cr)
    c = len(ev)
    def arc_of(i, t):
        return (sum(1 for e in ev if e < (i, t)) - 1) % c if c else 0
    pieces = []
    for i in range(n):
        cuts = [t for (k, t) in ev if k == i]
        pts = [0.0] + cuts + [1.0]
        for a, b in zip(pts, pts[1:]):
            pieces.append([i, R(a), R(b), arc_of(i, (a + b) / 2)])
    P = [proj(D, v) for v in V]
    crossings = []
    for k, (i, t, j, u) in enumerate(cr):
        a, b = np.array(V[i], float), np.array(V[(i + 1) % n], float)
        p3u = a + float(t) * (b - a)
        a2, b2 = np.array(V[j], float), np.array(V[(j + 1) % n], float)
        p3o = a2 + float(u) * (b2 - a2)
        e = ev.index((i, float(t)))
        crossings.append({"under": [i, R(t)], "over": [j, R(u)], "u3": [R(x) for x in p3u],
                          "o3": [R(x) for x in p3o], "e": e, "overArc": arc_of(j, float(u)),
                          "p2": [R(P[i][0] + float(t) * (P[(i + 1) % n][0] - P[i][0])),
                                 R(P[i][1] + float(t) * (P[(i + 1) % n][1] - P[i][1]))]})
    out = {"word": word, "D": list(D), "verts": [list(v) for v in V], "proj": [list(p) for p in P],
           "pieces": pieces, "crossings": crossings, "arcs": c}
    if colouring is not None: out["colouring"] = colouring
    return out


def smooth_block(D, f=None, names=None, colouring=None, step=4, gap=0.1):
    """a smooth Diagram (knotdraw) as polylines per arc and per edge, crossings and label anchors"""
    P = D.P; N = D.N
    gp = gap / np.linalg.norm(np.roll(P, -1, axis=0) - P, axis=1).mean()
    def seg(a, b, trim=0.0):
        if b <= a: b += N
        a += trim; b -= trim
        ss = np.linspace(a, b, max(3, int((b - a) / step)))
        return [[R(x) for x in MF.point(P, s % N)] for s in ss]
    arcs = []
    for e in range(D.c):
        a = D.unders[e]; b = D.unders[(e + 1) % D.c]
        arcs.append(seg(a, b, gp))
    cross = []
    for k, (u, o) in enumerate(D.cr):
        e = D.unders.index(u)
        cross.append({"p": [R(x) for x in MF.point(P, u)], "e": e, "overArc": D.arc_of(o),
                      "du": [R(x) for x in MF.tangent(P, u) / np.linalg.norm(MF.tangent(P, u))],
                      "do": [R(x) for x in MF.tangent(P, o) / np.linalg.norm(MF.tangent(P, o))]})
    out = {"arcs": arcs, "crossings": cross}
    if f is not None:
        D.pd()
        edges = []
        m = 2 * D.c
        for e in range(1, m + 1):
            a = D.edge_starts[(e - 1) % m]; b = D.edge_starts[e % m]
            edges.append({"label": f(e), "pts": seg(a, b)})
        out["edges"] = edges
    return out


def basis(D):
    """orthonormal screen basis for a viewer far out along +D with z up: e1 x e2 = D/|D|"""
    d = np.array(D, float); d /= np.linalg.norm(d)
    z = np.array([0, 0, 1.0]) if abs(d[2]) < 0.8 else np.array([0, 1.0, 0])   # y up when looking nearly down
    e2 = z - z.dot(d) * d; e2 /= np.linalg.norm(e2)
    e1 = np.cross(e2, d)
    return e1, e2


def orth(D, pts):
    e1, e2 = basis(D)
    return [[R(np.dot(p, e1)), R(np.dot(p, e2))] for p in np.asarray(pts, float)]


def pd_label_positions(word, D, shift=0):
    """positions (orthographic view along D) of the PD edge labels of the diagram, label + shift"""
    V = verts(word); n = len(V); cr = diagram(word, D)
    P = [np.array(x) for x in orth(D, V)]
    pas = sorted([((i, float(t)), k, 0) for k, (i, t, j, u) in enumerate(cr)] +
                 [((j, float(u)), k, 1) for k, (i, t, j, u) in enumerate(cr)])
    m = len(pas)
    pl = MF.Placer(MF.dense([np.array(P + [P[0]])], 24))
    def at(sv):
        i = int(math.floor(sv)) % n; fr = sv - math.floor(sv)
        return P[i] + fr * (P[(i + 1) % n] - P[i]), P[(i + 1) % n] - P[i]
    out = []
    for e in range(m):
        (i0, t0), (i1, t1) = pas[e][0], pas[(e + 1) % m][0]
        a, b = i0 + t0, i1 + t1
        if b <= a: b += n
        cands = []
        for sv in np.linspace(a + 0.25, b - 0.25, max(3, int((b - a) * 6))):
            x, d = at(sv); d = d / np.linalg.norm(d); nr = np.array([-d[1], d[0]])
            for sg in (1, -1): cands.append(x + sg * 0.45 * nr)
        y = pl.best(cands)
        out.append({"label": (e + shift) % m + 1, "p": [R(y[0]), R(y[1])]})
    return out


def search_trace(word):
    """Replay the obligation bookkeeping of the search (Len52/Search.lean, `update`) along one word."""
    n = len(word)
    V = [(0, 0, 0)]
    for ch in word:
        a = U[ch]; p = V[-1]; V.append((p[0] + a[0], p[1] + a[1], p[2] + a[2]))
    def add(p, q, s=1): return (p[0] + s * q[0], p[1] + s * q[1], p[2] + s * q[2])
    def lexpos(p): return p[2] > 0 or (p[2] == 0 and (p[1] > 0 or (p[1] == 0 and p[0] > 0)))
    def allowed(p): return lexpos(p) and abs(p[0]) <= 24 and abs(p[1]) <= 24 and p[2] <= 24
    def l1(p, q=(0, 0, 0)): return sum(abs(a - b) for a, b in zip(p, q))
    pend = []; last = {}; steps = []
    for i in range(n):
        d = word[i]; nx = V[i + 1]; R1 = n - i - 1
        occ = set(V[:i + 2])
        discharged = [ob for ob in pend if nx in ob]
        pend = [ob for ob in pend if nx not in ob]
        events = []
        A = AX[d]
        if A in last:
            j, a = last[A]
            if a == REV[d]:
                k = i - j - 1
                sites = [add(V[j + t], U[a], -1) for t in range(2, k + 1)]
                if any(s in occ for s in sites):
                    events.append({"kind": "curtain", "j": j, "k": k, "sites": sites, "result": "satisfied"})
                else:
                    al = [s for s in sites if allowed(s)]
                    events.append({"kind": "curtain", "j": j, "k": k, "sites": sites,
                                   "result": "new" if al else "dead"})
                    if al: pend.append(al)
        if i >= 1:
            p = word[i - 1]; s = None
            if p == 'u' and d in 'ewns': s = add(V[i - 1], U[d])
            elif d == 'd' and p in 'ewns': s = add(V[i + 1], U[p], -1)
            elif p == 'n' and d in 'ew': s = add(V[i - 1], U[d])
            elif d == 's' and p in 'ew': s = add(V[i + 1], U[p], -1)
            if s is not None:
                if s in occ: events.append({"kind": "corner", "site": s, "result": "satisfied"})
                else:
                    events.append({"kind": "corner", "site": s, "result": "new" if allowed(s) else "dead"})
                    if allowed(s): pend.append([s])
        last[A] = (i, d)
        reach = []
        for ob in pend:
            best = min(l1(nx, s) + l1(s) for s in ob)
            reach.append(best)
        # span need (computed when >= 2 obligations, as in the program)
        span = None
        if len(pend) >= 2:
            sing = [ob[0] for ob in pend if len(ob) == 1]
            tot = 0
            for q in range(3):
                c = nx[q]; lo = min([0, c] + [s[q] for s in sing]); hi = max([0, c] + [s[q] for s in sing])
                tot += min((c - lo) + (hi - lo) + hi, (hi - c) + (hi - lo) - lo)
            span = tot
        steps.append({"i": i, "letter": d, "head": nx, "R1": R1, "events": events,
                      "discharged": [list(map(list, ob)) for ob in discharged],
                      "pending": [list(map(list, ob)) for ob in pend], "reach": reach, "span": span})
    return {"word": word, "verts": [list(v) for v in V[:-1]], "steps": steps}


def main():
    data = {}
    # Figure 1
    data["w36"] = polygon_block(MF.W36, MF.DFIG, MF.X52)
    data["w36"]["Dcert"] = [1, -19, 40]
    data["w36"]["orth"] = orth(MF.DFIG, verts(MF.W36))
    data["w36"]["pdLabels"] = pd_label_positions(MF.W36, MF.DFIG, 6)
    # standard 5_2 with KnotInfo labels
    D, pd, f, rev, perm = MF.std_diagram()
    names = {frozenset({2, 3}): "A", frozenset({4, 5}): "B", frozenset({6, 7}): "C",
             frozenset({8, 9}): "D", frozenset({10, 1}): "E"}
    blk = smooth_block(D, f)
    arcname = []
    for e in range(D.c):
        a = D.unders[e]; b = D.unders[(e + 1) % D.c]
        if b <= a: b += D.N
        es = {f(k) for k in range(1, 11) if a < (D.edge_mid(k) if D.edge_mid(k) > a else D.edge_mid(k) + D.N) < b}
        arcname.append(names[frozenset(es)])
    blk["arcNames"] = arcname
    blk["crossNames"] = [perm[k] + 1 for k in range(len(D.cr))]
    blk["reversed"] = rev
    blk["pd"] = MF.STD
    pl = MF.Placer(MF.dense([np.vstack([D.P, D.P[:1]])], 2))
    cl = []
    for k, (u, o) in enumerate(D.cr):
        x = MF.point(D.P, u)
        cands = [x + 0.3 * np.array([math.cos(a), math.sin(a)]) for a in np.linspace(0, 2 * math.pi, 16, endpoint=False)]
        y = pl.best(cands); cl.append([R(y[0]), R(y[1])])
    blk["crossLabels"] = cl
    el = []
    for e in range(1, 11):
        a = D.edge_starts[(e - 1) % 10]; b = D.edge_starts[e % 10]
        if b <= a: b += D.N
        cands = []
        for fr in np.linspace(0.2, 0.8, 13):
            sv = (a + fr * (b - a)) % D.N
            x = MF.point(D.P, sv); t = MF.tangent(D.P, sv); t = t / np.linalg.norm(t)
            nrm = np.array([-t[1], t[0]])
            for sg in (1, -1):
                for o in (0.17, 0.23): cands.append(x + sg * o * nrm)
        y = pl.best(cands); el.append({"label": f(e), "p": [R(y[0]), R(y[1])]})
    blk["edgeLabels"] = el
    al = []
    pl2 = MF.Placer(MF.dense([np.vstack([D.P, D.P[:1]])], 2))
    for e in range(D.c):
        a = D.unders[e]; b = D.unders[(e + 1) % D.c]
        if b <= a: b += D.N
        cands = []
        for fr in np.linspace(0.25, 0.75, 11):
            sv = (a + fr * (b - a)) % D.N
            x = MF.point(D.P, sv); t = MF.tangent(D.P, sv); t = t / np.linalg.norm(t)
            for sg in (1, -1): cands.append(x + sg * 0.27 * np.array([-t[1], t[0]]))
        y = pl2.best(cands); al.append([R(y[0]), R(y[1])])
    blk["arcLabels"] = al
    data["std52"] = blk
    # trefoil
    t = np.linspace(0, 2 * np.pi, 900, endpoint=False)
    P = np.c_[np.sin(t) + 2 * np.sin(2 * t), np.cos(t) - 2 * np.cos(2 * t)]
    Z = -np.sin(3 * t); N = len(P)
    def zat(s):
        i = int(s) % N; fr = s - int(s); return Z[i] * (1 - fr) + Z[(i + 1) % N] * fr
    TD = MF.Diagram(P, overs=lambda s, u: zat(s) > zat(u))
    data["trefoil"] = smooth_block(TD, step=3, gap=0.22)
    # certificate example
    F, L, LF = MF.fig_certex()
    data["cert"] = polygon_block(MF.CW, MF.CD)
    data["cert"].update({"F": F, "L": L, "LF": LF, "orth": orth(MF.CD, verts(MF.CW))})
    # PD comparison
    pyPD = pd_code(MF.W36, MF.DFIG)
    mir = mirror(pyPD)
    sh = lambda x: (x - 1 + 6) % 10 + 1
    data["pd"] = {"w36": pyPD, "switched": mir, "shifted": [[sh(x) for x in X] for X in mir], "std": MF.STD}
    # labels of the w36 diagram edges (PD numbering) for the comparison figure
    V = verts(MF.W36); n = len(V); cr = diagram(MF.W36, MF.DFIG)
    pas = sorted([((i, float(tt)), k, 0) for k, (i, tt, j, u) in enumerate(cr)] +
                 [((j, float(u)), k, 1) for k, (i, tt, j, u) in enumerate(cr)])
    data["w36"]["passages"] = [[p[0][0], R(p[0][1]), p[1], p[2]] for p in pas]
    # growth
    rows = MF.read_rows()
    data["runs"] = [{"n": nn, "parts": rows[nn][3], "nodes": rows[nn][0], "words": len(rows[nn][1])} for nn in sorted(rows)]
    data["totals"] = {"words": sum(len(rows[nn][1]) for nn in rows), "nodes": sum(rows[nn][0] for nn in rows),
                      "parts": sum(rows[nn][3] for nn in rows)}
    Cn, qn, Cw, qw, rn = MF.fig_growth(rows)
    data["fits"] = {"nodes": [Cn, qn, 20, 34], "words": [Cw, qw, 24, 34]}
    # search replay
    data["trace"] = search_trace(MF.CW)
    with open(os.path.join(HERE, "data.js"), "w") as fo:
        fo.write("// generated by build_data.py; do not edit\nexport const DATA = ")
        json.dump(data, fo, separators=(",", ":"))
        fo.write(";\n")
    print("data.js:", os.path.getsize(os.path.join(HERE, "data.js")), "bytes;",
          "trace steps with events:", sum(1 for s in data["trace"]["steps"] if s["events"]))


if __name__ == "__main__":
    main()
