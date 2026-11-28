"""Independent (Python) justification of a removed polygon by Lemma 3* (+ certificates) or Lemma F2.
Injectivity along a general direction v = (a, b, c) (c > 0 along the plane normal into the side) is tested by exact
segment intersection of the projected polyline (extended by the two half-edges to the plane)."""
from fractions import Fraction
from collections import deque
from l3lib import VEC, verts, l1, twice_crossed, geodesic, f2_kill

def gen_dirs(K):
    from math import gcd
    D = [(0, 0, 1)]
    for c in range(1, K + 1):
        for a in range(-K, K + 1):
            for b in range(-K, K + 1):
                if (a, b, c) == (0, 0, 1): continue
                if gcd(gcd(abs(a), abs(b)), c) != 1: continue
                D.append((a, b, c))
    return D
D9 = [(a, b, 1) for a in (-1, 0, 1) for b in (-1, 0, 1)]
DX = gen_dirs(3)

def to_local(arc, A, p):
    """coordinates (s, t, h): h = distance from the plane (> 0 on the arc), s, t the two other axes"""
    B, C = [q for q in range(3) if q != A]
    sigma = 1 if arc[0][A] > p else -1
    return [(q[B], q[C], (q[A] - p - Fraction(1, 2)) * sigma) for q in arc]

def proj_inj(loc, v):
    a, b, c = v
    if a == 0 and b == 0:
        cols = []
        for (s, t, h) in loc:
            if not cols or cols[-1] != (s, t): cols.append((s, t))
        return len(cols) == len(set(cols))
    pts = [(loc[0][0], loc[0][1], Fraction(0))] + list(loc) + [(loc[-1][0], loc[-1][1], Fraction(0))]
    P = [(s - h * Fraction(a, c), t - h * Fraction(b, c)) for (s, t, h) in pts]
    segs = list(zip(P, P[1:]))
    def cr(o, p, q): return (p[0] - o[0]) * (q[1] - o[1]) - (p[1] - o[1]) * (q[0] - o[0])
    def onseg(p, q, r): return min(p[0], q[0]) <= r[0] <= max(p[0], q[0]) and min(p[1], q[1]) <= r[1] <= max(p[1], q[1])
    def inter(s1, s2):
        p1, p2 = s1; q1, q2 = s2
        d1, d2, d3, d4 = cr(p1, p2, q1), cr(p1, p2, q2), cr(q1, q2, p1), cr(q1, q2, p2)
        if ((d1 > 0) != (d2 > 0)) and d1 != 0 and d2 != 0 and ((d3 > 0) != (d4 > 0)) and d3 != 0 and d4 != 0: return True
        return (d1 == 0 and onseg(p1, p2, q1)) or (d2 == 0 and onseg(p1, p2, q2)) or (d3 == 0 and onseg(q1, q2, p1)) or (d4 == 0 and onseg(q1, q2, p2))
    for i in range(len(segs)):
        for j in range(i + 1, len(segs)):
            if j == i + 1:
                (p1, p2), (q1, q2) = segs[i], segs[j]
                if cr(p1, p2, q2) == 0 and ((p2[0] - p1[0]) * (q2[0] - q1[0]) + (p2[1] - p1[1]) * (q2[1] - q1[1])) < 0: return False
                continue
            if inter(segs[i], segs[j]): return False
    return True

def inj_any(arc, A, p, dirs):
    loc = to_local(arc, A, p)
    for v in dirs:
        if proj_inj(loc, v): return v
    return None

def certificate(arc, A, p, dirs, lim=20000, ext=4):
    """breadth-first search over moves of the arc inside its half-space (end vertices fixed): corner flips, +2, -2.
    returns the number of moves to an arc injective along a direction of dirs, or None"""
    side = 1 if arc[0][A] > p else -1
    def inside(q): return (q[A] > p) if side > 0 else (q[A] <= p)
    start = tuple(arc); seen = {start}; Q = deque([(start, 0)]); maxlen = len(arc) + ext
    if inj_any(arc, A, p, dirs): return 0
    while Q:
        a, d = Q.popleft(); m = len(a); S = set(a); nb = []
        for i in range(1, m - 1):
            d1 = tuple(a[i][k] - a[i - 1][k] for k in range(3)); d2 = tuple(a[i + 1][k] - a[i][k] for k in range(3))
            if d1 == d2: continue
            w = tuple(a[i - 1][k] + a[i + 1][k] - a[i][k] for k in range(3))
            if w in S or not inside(w): continue
            nb.append(a[:i] + (w,) + a[i + 1:])
        if m + 2 <= maxlen:
            for i in range(m - 1):
                e = tuple(a[i + 1][k] - a[i][k] for k in range(3))
                for dl in VEC.values():
                    if sum(dl[k] * e[k] for k in range(3)) != 0: continue
                    u1 = tuple(a[i][k] + dl[k] for k in range(3)); u2 = tuple(a[i + 1][k] + dl[k] for k in range(3))
                    if u1 in S or u2 in S or not inside(u1) or not inside(u2): continue
                    nb.append(a[:i + 1] + (u1, u2) + a[i + 1:])
        for i in range(m - 3):
            if l1(a[i], a[i + 3]) == 1: nb.append(a[:i + 1] + a[i + 3:])
        for b in nb:
            if b in seen: continue
            if inj_any(list(b), A, p, dirs): return d + 1
            if len(seen) >= lim: return None
            seen.add(b); Q.append((b, d + 1))
    return None

def one_max(arc, A, p):
    """Lemma M: the height along the normal (into the side) never descends and then ascends again"""
    sigma = 1 if arc[0][A] > p else -1
    h = [sigma * q[A] for q in arc]; down = False
    for k in range(1, len(h)):
        if h[k] < h[k - 1]: down = True
        elif h[k] > h[k - 1] and down: return False
    return True

def justify(word, M, use_f2, use_m=False):
    """reason string if the polygon violates Lemma 3* (direct, D9 or DX), Lemma 5* (side < M edges with a certificate), or F2"""
    for A, p, sides in twice_crossed(word):
        for sigma, arc in sides:
            if geodesic(arc): continue
            if use_m and one_max(arc, A, p): return f'LM axis{A} plane{p}+1/2 side{sigma:+d} len{len(arc)-1}'
            v = inj_any(arc, A, p, D9)
            if v: return f'L3* axis{A} plane{p}+1/2 side{sigma:+d} len{len(arc)-1} dir{v}'
            if len(arc) - 1 < M:
                k = certificate(arc, A, p, D9 + DX)
                if k is not None: return f'L5* axis{A} plane{p}+1/2 side{sigma:+d} len{len(arc)-1} moves{k}'
    if use_f2 and f2_kill(word): return 'F2'
    return None
