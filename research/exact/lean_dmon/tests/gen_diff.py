#!/usr/bin/env python3
"""Differential test of Dmon.AotOk (Lean) against a literal Python port of aot_ok / axis_need of
enum_bidir.cpp.  Writes tests/Diff.lean (a Lean file that #evals AotOk on random inputs) and
tests/diff_expected.txt (the answers of the port).  Compare with:  lake env lean tests/Diff.lean | diff - tests/diff_expected.txt"""
import random, sys
random.seed(int(sys.argv[1]) if len(sys.argv) > 1 else 1)
UNIT = [(1,0,0),(-1,0,0),(0,1,0),(0,-1,0),(0,0,1),(0,0,-1)]
def walk(w):
    x = [0,0,0]
    for d in w:
        for q in range(3): x[q] += UNIT[d][q]
    return tuple(x)
def cnt(w):
    c = [0,0,0]
    for d in w: c[d//2] += 1
    return c

def axis_need(q, c0, ct, singles, multis, AOTM):         # port of enum_bidir.cpp axis_need
    lo = hi = ct
    for s in singles:
        cs = s[q]
        if cs < lo: lo = cs
        if cs > hi: hi = cs
    l = min(lo, c0); h = max(hi, c0)
    a1 = (c0 - l) + (h - l) + (h - ct); a2 = (h - c0) + (h - l) + (ct - l)
    t = min(a1, a2)
    if AOTM:
        for ob in multis:
            best = 1 << 20
            for s in ob:
                sc = s[q]
                l2 = min(sc, l); h2 = max(sc, h)
                b1 = (c0 - l2) + (h2 - l2) + (h2 - ct); b2 = (h2 - c0) + (h2 - l2) + (ct - l2)
                best = min(best, min(b1, b2))
            if best > t: t = best
    return t

def aot_ok(p, tl, e, N, singles, multis, cdef, AOTM, AOTC):
    head = walk(p); c = [a + b for a, b in zip(cnt(p), cnt(tl))]
    L = [0,0,0]
    for q in range(3):
        t = axis_need(q, head[q], e[q], singles, multis, AOTM)
        if AOTC and cdef[q] > t: t = cdef[q]
        L[q] = (c[q] + t + 1) & ~1
    z = L[2]; y = max(L[1], z); x = max(L[0], y)
    return x + y + z <= N

def v3(s): return "⟨%d, %d, %d⟩" % s
def lst(xs, f): return "[" + ", ".join(f(x) for x in xs) + "]"
out = ["import Dmon", "open Dmon Len52", ""]
exp = []
for i in range(400):
    p = [random.randrange(6) for _ in range(random.randrange(0, 9))]
    tl = [random.randrange(6) for _ in range(random.randrange(0, 4))]
    e = tuple(random.randrange(-3, 4) for _ in range(3))
    head = walk(p)
    def pt(): return tuple(random.randrange(-5, 6) for _ in range(3))
    singles = [pt() for _ in range(random.randrange(0, 4))]
    multis = [[pt() for _ in range(random.randrange(2, 5))] for _ in range(random.randrange(0, 3))]
    cdef = [random.randrange(0, 6) for _ in range(3)]
    N = random.randrange(10, 34)
    AOTM = random.random() < 0.7; AOTC = random.random() < 0.7
    exp.append("true" if aot_ok(p, tl, e, N, singles, multis, cdef, AOTM, AOTC) else "false")
    out.append("#eval (decide (AotOk %s %s %s %d %s %s (fun A => if A = 0 then %d else if A = 1 then %d else %d) %s %s) : Bool)" % (
        lst(p, str), lst(tl, str), v3(e), N, lst(singles, v3), lst(multis, lambda m: lst(m, v3)),
        cdef[0], cdef[1], cdef[2], "true" if AOTM else "false", "true" if AOTC else "false"))
open("tests/Diff.lean", "w").write("\n".join(out) + "\n")
open("tests/diff_expected.txt", "w").write("\n".join(exp) + "\n")
print(exp.count("true"), "true,", exp.count("false"), "false")
