"""Lemma 3 / Lemma 3* tests on finished lattice polygons (words over e w n s u d).
Written from the definitions in the task; independent of enum_v.cpp."""
VEC = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0), 'u': (0, 0, 1), 'd': (0, 0, -1)}

def verts(word):
    p = (0, 0, 0); out = [p]
    for c in word[:-1]:
        v = VEC[c]; p = (p[0] + v[0], p[1] + v[1], p[2] + v[2]); out.append(p)
    return out

def l1(a, b): return sum(abs(a[i] - b[i]) for i in range(3))

def twice_crossed(word):
    """yield (A, p, sides) for every mid-plane x_A = p + 1/2 crossed by exactly two edges.
    sides = [(sigma, arc)] with arc the list of vertices on that side, in polygon order from A to B
    (sigma = +1: x_A >= p+1, -1: x_A <= p)."""
    V = verts(word); n = len(V)
    for A in range(3):
        cs = [v[A] for v in V]
        for p in range(min(cs), max(cs)):
            cr = [i for i in range(n) if (cs[i] <= p) != (cs[(i + 1) % n] <= p)]
            if len(cr) != 2: continue
            i, j = cr
            arc1 = [V[k % n] for k in range(i + 1, j + 1)]        # vertices i+1..j
            arc2 = [V[k % n] for k in range(j + 1, i + n + 1)]    # vertices j+1..i+n
            s1 = 1 if arc1[0][A] > p else -1
            yield A, p, [(s1, arc1), (-s1, arc2)]

def geodesic(arc): return len(arc) - 1 == l1(arc[0], arc[-1])

def dirs_for(A, sigma, which):
    """directions v (pointing into the half-space sigma along axis A). which: 'axis' or 'all'."""
    B, C = [q for q in range(3) if q != A]
    out = []
    for a in (-1, 0, 1):
        for b in (-1, 0, 1):
            if which == 'axis' and (a, b) != (0, 0): continue
            v = [0, 0, 0]; v[A] = sigma; v[B] = a; v[C] = b
            out.append(tuple(v))
    return out

def injective(arc, A, p, sigma, v):
    """projection along v of the extended arc (half-edge from the plane to arc[0], arc, half-edge to the plane)
    onto the plane x_A = p + 1/2 is injective (for v = axis: each column one contiguous run, column path simple)."""
    B, C = [q for q in range(3) if q != A]
    h2 = 2 * p + 1   # doubled plane coordinate
    if v[B] == 0 and v[C] == 0:
        cols = []
        for q in arc:
            c = (q[B], q[C])
            if not cols or cols[-1] != c: cols.append(c)
        return len(cols) == len(set(cols))
    # doubled image of a doubled point P2: P2 - t v, t = (P2[A] - h2) / sigma
    def img2(P2):
        t = (P2[A] - h2) * sigma
        return (P2[B] - t * v[B], P2[C] - t * v[C])
    pts2 = [tuple(2 * x for x in q) for q in arc]
    a0 = list(pts2[0]); a0[A] = h2; b0 = list(pts2[-1]); b0[A] = h2
    samples = [img2(a0)]
    samples.append(img2(pts2[0]))
    for k in range(1, len(pts2)):
        m = tuple((pts2[k - 1][i] + pts2[k][i]) // 2 for i in range(3))
        samples.append(img2(m)); samples.append(img2(pts2[k]))
    samples.append(img2(b0))
    return len(samples) == len(set(samples))

def side_injective(arc, A, p, sigma, which):
    return [v for v in dirs_for(A, sigma, which) if injective(arc, A, p, sigma, v)]

def analyse(word):
    """returns dict: L3 (Lemma 3 kills), L3ax, L3all (Lemma 3* kills), and per-plane info"""
    res = {'L3': False, 'L3ax': False, 'L3all': False, 'planes': []}
    for A, p, sides in twice_crossed(word):
        info = []
        for sigma, arc in sides:
            g = geodesic(arc)
            ax = bool(side_injective(arc, A, p, sigma, 'axis'))
            al = bool(side_injective(arc, A, p, sigma, 'all'))
            info.append((sigma, len(arc) - 1, g, ax, al))
        both_ng = not info[0][2] and not info[1][2]
        if both_ng: res['L3'] = True
        if any((not g) and ax for (_, _, g, ax, _) in info): res['L3ax'] = True
        if any((not g) and al for (_, _, g, _, al) in info): res['L3all'] = True
        res['planes'].append((A, p, info))
    return res

def f2_kill(word):
    """Lemma F2 / F1 on the finished polygon (as cyc_ok with -face -plane4): a sub-arc of excess >= 4 inside a plane
    x_A = c that is an extreme level."""
    V = verts(word); n = len(V)
    for A in range(3):
        cs = [v[A] for v in V]; lo, hi = min(cs), max(cs)
        for i in range(n):
            c = cs[i]
            for L in range(1, n):
                q = V[(i + L) % n]
                if q[A] != c: break
                if L - l1(V[i], q) >= 4:
                    if c == lo or c == hi: return True
                    break
    return False
