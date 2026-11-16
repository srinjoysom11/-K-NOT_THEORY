#!/usr/bin/env python3
"""Figures for the paper.  Exact data come from the repository (words, projection code, logs)."""
import os, sys, re, glob, math
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Line3DCollection
HERE = os.path.dirname(os.path.abspath(__file__))
EX = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, os.path.join(EX, "formal"))
from projections import diagram, verts, proj, height

plt.rcParams.update({"font.family": "serif", "font.size": 9})
W36 = "eeennuwwwwssseennwuueedddnnuuswsswdd"
D52 = (1, -19, 40)        # the direction of the Lean certificate
DFIG = (5, -5, 11)         # same PD code as D52 and as the standard 5_2 diagram; easier to draw
COL = ["#1f5fa8", "#c0392b", "#27864a", "#d68910", "#7d3c98", "#566573", "#17a589"]   # one per colour value 0..6

def fig_polygon():
    V = verts(W36); n = len(V)
    fig = plt.figure(figsize=(6.4, 3.0))
    # --- 3D view, looking along -D (the projection direction), slightly tilted
    ax = fig.add_subplot(1, 2, 1, projection="3d")
    P = V + [V[0]]
    segs = [[P[i], P[i + 1]] for i in range(n)]
    hs = [height(DFIG, ((P[i][0] + P[i+1][0]) / 2, (P[i][1] + P[i+1][1]) / 2, (P[i][2] + P[i+1][2]) / 2)) for i in range(n)]
    lo, hi = min(hs), max(hs)
    cols = [plt.cm.Blues(0.45 + 0.5 * (h - lo) / (hi - lo)) for h in hs]
    ax.add_collection3d(Line3DCollection(segs, colors=cols, linewidths=3.2, capstyle="round"))
    xs, ys, zs = zip(*V)
    ax.scatter(xs, ys, zs, s=6, c="k", depthshade=False)
    ax.scatter([0], [0], [0], s=28, c="#c0392b", depthshade=False, zorder=10)
    for a, (l, h) in zip("xyz", [(min(xs), max(xs)), (min(ys), max(ys)), (min(zs), max(zs))]):
        getattr(ax, f"set_{a}lim")(l - 0.5, h + 0.5)
    ax.set_box_aspect((max(xs) - min(xs) + 1, max(ys) - min(ys) + 1, max(zs) - min(zs) + 1))
    ax.view_init(elev=50, azim=-45)
    ax.set_xticks(range(min(xs), max(xs) + 1)); ax.set_yticks(range(min(ys), max(ys) + 1)); ax.set_zticks(range(min(zs), max(zs) + 1))
    ax.tick_params(labelsize=6, pad=0)
    ax.set_xlabel("x", labelpad=-8); ax.set_ylabel("y", labelpad=-8); ax.set_zlabel("z", labelpad=-8)
    ax.set_title("the 36-step polygon $w_{36}$", fontsize=9)
    # --- the regular projection along D, under-strands broken, arcs coloured by a Fox 7-colouring
    ax2 = fig.add_subplot(1, 2, 2)
    cr = diagram(W36, DFIG)
    Pp = [proj(DFIG, v) for v in V]
    under = {}
    for (i, t, j, u) in cr: under.setdefault(i, []).append(t)
    ev = sorted((i, t) for (i, t, j, u) in cr)          # under-passages along the walk
    c = len(ev); xcol = [0, 1, 3, 4, 2]                    # the colouring of Lemma 6.2 / w52_coloring
    def arc_of(i, t):
        k = sum(1 for e in ev if e < (i, t))
        return (k - 1) % c
    gap = 0.2 * 11
    for i in range(n):
        a, b = Pp[i], Pp[(i + 1) % n]
        L = math.hypot(b[0] - a[0], b[1] - a[1])
        cuts = sorted(float(t) for t in under.get(i, []))
        pts = [0.0]
        for t in cuts: pts += [t - gap / L, t + gap / L]
        pts.append(1.0)
        for k in range(0, len(pts), 2):
            t0, t1 = max(pts[k], 0.0), min(pts[k + 1], 1.0)
            if t1 <= t0: continue
            mid = (t0 + t1) / 2
            arc = arc_of(i, mid)
            ax2.plot([a[0] + t0 * (b[0] - a[0]), a[0] + t1 * (b[0] - a[0])],
                     [a[1] + t0 * (b[1] - a[1]), a[1] + t1 * (b[1] - a[1])],
                     color=COL[xcol[arc]], lw=2.0, solid_capstyle="round")
    ax2.set_aspect("equal"); ax2.axis("off")
    ax2.set_title("its diagram along $D=(5,-5,11)$: 5 crossings,\narcs coloured by the Fox colouring $(0,1,3,4,2)$", fontsize=9)
    handles = [plt.Line2D([0], [0], color=COL[v], lw=2) for v in sorted(set(xcol))]
    ax2.legend(handles, [f"colour {v}" for v in sorted(set(xcol))], loc="lower left", fontsize=6, frameon=False,
               ncol=3, bbox_to_anchor=(0.0, -0.12))
    fig.tight_layout()
    fig.savefig(os.path.join(HERE, "polygon36.pdf"), bbox_inches="tight")

def fig_growth():
    """search size per length, from the accepted proof-run logs"""
    rows = {}
    for f in glob.glob(os.path.join(EX, "out/lean/parts/n*_check.part*_*.txt")):
        g = re.search(r"n(\d+)_check\.part(\d+)_(\d+)\.txt$", f)
        n = int(g.group(1))
        last = open(f).read().strip().splitlines()[-1]
        m = re.search(r"nodes=(\d+) words=(\d+) ok=true", last)
        if not m: continue
        r = rows.setdefault(n, [0, set(), 0, int(g.group(3))])
        r[0] += int(m.group(1)); r[2] += 1
        r[1] |= set(open(f).read().strip().splitlines()[:-1])
    ns = sorted(n for n in rows if rows[n][2] == rows[n][3] and n >= 6)
    fig, ax = plt.subplots(figsize=(4.6, 2.6))
    ax.semilogy(ns, [rows[n][0] for n in ns], "o-", color=COL[0], label="search nodes")
    ax.semilogy([n for n in ns if rows[n][1]], [len(rows[n][1]) for n in ns if rows[n][1]], "s-", color=COL[1], label="words returned")
    ax.set_xlabel("length $n$"); ax.set_xticks(ns); ax.tick_params(labelsize=7)
    ax.grid(alpha=0.3, which="both"); ax.legend(fontsize=7, frameon=False)
    fig.tight_layout(); fig.savefig(os.path.join(HERE, "growth.pdf"), bbox_inches="tight")
    with open(os.path.join(HERE, "growth_table.tex"), "w") as fo:
        fo.write("\\begin{tabular}{rrrrr}\n\\toprule\n$n$ & parts & accepted & nodes & words \\\\\n\\midrule\n")
        for n in sorted(rows):
            r = rows[n]
            fo.write(f"{n} & {r[3]} & {r[2]} & \\num{{{r[0]}}} & \\num{{{len(r[1])}}} \\\\\n")
        fo.write("\\bottomrule\n\\end{tabular}\n")
    tw = sum(len(rows[n][1]) for n in rows); tn = sum(rows[n][0] for n in rows)
    done = all(rows.get(n, [0, 0, 0, -1])[2] == rows.get(n, [0, 0, 0, -1])[3] for n in range(4, 35, 2))
    ratio = (rows[30][0] / rows[26][0]) ** 0.5 if 30 in rows and 26 in rows else 0
    with open(os.path.join(HERE, "numbers.tex"), "w") as fo:
        fo.write(f"\\newcommand{{\\NWords}}{{\\num{{{tw}}}}}\n")
        fo.write(f"\\newcommand{{\\NNodes}}{{\\num{{{tn:.2e}}}}}\n".replace("e+", "e"))
        fo.write(f"\\newcommand{{\\NGrowth}}{{{ratio:.1f}}}\n")
        fo.write(f"\\newcommand{{\\RunsComplete}}{{{'yes' if done else 'no'}}}\n")
    return rows

if __name__ == "__main__":
    fig_polygon()
    rows = fig_growth()
    print({n: (rows[n][0], len(rows[n][1]), rows[n][2], rows[n][3]) for n in sorted(rows)})
