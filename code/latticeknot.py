"""
latticeknot.py -- minimal toolkit for knots/links as polygons in the simple cubic lattice Z^3.

Representation: a component is a list of integer 3-tuples (vertices, closed implicitly:
last vertex is adjacent to the first). A link is a list of components.
Also supports the NSEWUD direction-word format used in BTP/knotmaker.cpp.

Main entry points
    word_to_vertices(word)          'nnes...' -> vertex list
    is_lattice_polygon(comps)       checks unit steps, closure, self/mutual avoidance
    pd_code(comps)                  generic projection -> PD code (KnotTheory convention)
    identify(comps)                 SnapPy/spherogram based identification
Only dependency beyond numpy: snappy (which bundles spherogram).
"""
import numpy as np

DIRS = {'e': (1, 0, 0), 'w': (-1, 0, 0), 'n': (0, 1, 0), 's': (0, -1, 0),
        'u': (0, 0, 1), 'd': (0, 0, -1)}


def word_to_vertices(word):
    x = np.zeros(3, dtype=int)
    verts = [tuple(x)]
    for ch in word:
        x = x + DIRS[ch]
        verts.append(tuple(x))
    assert verts[-1] == verts[0], "word does not close"
    return verts[:-1]


def vertices_to_word(verts):
    inv = {v: k for k, v in DIRS.items()}
    n = len(verts)
    return ''.join(inv[tuple(np.subtract(verts[(i + 1) % n], verts[i]))] for i in range(n))


def is_lattice_polygon(comps):
    seen = set()
    for c in comps:
        n = len(c)
        if n < 4:
            return False
        for i in range(n):
            d = np.abs(np.subtract(c[(i + 1) % n], c[i])).sum()
            if d != 1:
                return False
        for v in c:
            if v in seen:
                return False
            seen.add(v)
    return True


def length(comps):
    return sum(len(c) for c in comps)


# ---------- generic projection -> PD code ----------
_ROT = None


def _rotation(seed=12345):
    rng = np.random.default_rng(seed)
    q, _ = np.linalg.qr(rng.normal(size=(3, 3)))
    return q


def pd_code(comps, seed=12345):
    """PD code via a generic orthogonal projection. Works for knots and links."""
    R = _rotation(seed)
    segs = []  # (comp, idx, p0(2), p1(2), z0, z1)
    P = [np.asarray(c, dtype=float) @ R.T for c in comps]
    for ci, p in enumerate(P):
        n = len(p)
        for i in range(n):
            segs.append((ci, i, p[i], p[(i + 1) % n]))
    events = []  # (comp, idx, t, crossing_id, is_over)
    crossings = []
    m = len(segs)
    for a in range(m):
        ca, ia, A0, A1 = segs[a]
        for b in range(a + 1, m):
            cb, ib, B0, B1 = segs[b]
            if ca == cb:
                n = len(comps[ca])
                if abs(ia - ib) in (0, 1, n - 1):
                    continue  # adjacent edges share a vertex
            d1 = A1[:2] - A0[:2]
            d2 = B1[:2] - B0[:2]
            den = d1[0] * d2[1] - d1[1] * d2[0]
            if abs(den) < 1e-12:
                continue
            r = B0[:2] - A0[:2]
            t = (r[0] * d2[1] - r[1] * d2[0]) / den
            s = (r[0] * d1[1] - r[1] * d1[0]) / den
            if 0 < t < 1 and 0 < s < 1:
                za = A0[2] + t * (A1[2] - A0[2])
                zb = B0[2] + s * (B1[2] - B0[2])
                k = len(crossings)
                a_over = za > zb
                crossings.append({'dirA': d1, 'dirB': d2, 'a_over': a_over})
                events.append((ca, ia, t, k, a_over, 'A'))
                events.append((cb, ib, s, k, not a_over, 'B'))
    if not crossings:
        return []
    # order events along each component, assign edge labels
    label = 0
    inc = {}  # (crossing, 'A'/'B') -> (in_label, out_label)
    for ci in range(len(comps)):
        ev = sorted([e for e in events if e[0] == ci], key=lambda e: (e[1], e[2]))
        if not ev:
            continue  # split unknotted component with no crossings: dropped
        start = label
        L = len(ev)
        for j, e in enumerate(ev):
            in_l = start + (j - 1) % L
            out_l = start + j
            inc[(e[3], e[5])] = (in_l, out_l)
        label += L
    pd = []
    for k, X in enumerate(crossings):
        if X['a_over']:
            u, v, us, os_ = X['dirB'], X['dirA'], 'B', 'A'
        else:
            u, v, us, os_ = X['dirA'], X['dirB'], 'A', 'B'
        ui, uo = inc[(k, us)]
        oi, oo = inc[(k, os_)]
        cr = u[0] * v[1] - u[1] * v[0]
        if cr < 0:
            pd.append((ui, oo, uo, oi))
        else:
            pd.append((ui, oi, uo, oo))
    return pd


def to_spherogram(comps):
    import snappy  # noqa: F401  (needed for Link.exterior())
    import spherogram
    pd = pd_code(comps)
    if not pd:
        return None
    return spherogram.Link(pd)


def identify(comps):
    """Return a dict with simplified crossing count, HFK data and SnapPy identification."""
    L = to_spherogram(comps)
    out = {'length': length(comps), 'components': len(comps)}
    if L is None:
        out.update(crossings=0, name='unknot/unlink')
        return out
    L.simplify('global')
    out['crossings'] = len(L.crossings)
    if len(L.crossings) == 0:
        out['name'] = 'unknot/unlink'
        return out
    try:
        names = L.exterior().identify()
        out['snappy_identify'] = [str(x) for x in names]
    except Exception as e:
        out['snappy_identify'] = []
        out['identify_error'] = repr(e)
    if len(comps) == 1:
        try:
            h = L.knot_floer_homology()
            out['genus'] = h['seifert_genus']
            out['fibered'] = h['fibered']
            out['HFK_ranks'] = h['ranks']
        except Exception as e:
            out['hfk_error'] = repr(e)
    return out


# ---------- utility: snap a smooth closed curve onto the lattice ----------
def curve_to_lattice(points):
    """points: (N,3) float array, densely sampled closed curve, already scaled.
    Rounds to Z^3 and joins consecutive points with axis-parallel steps.
    Returns vertex list or None if result is not self-avoiding."""
    pts = np.rint(points).astype(int)
    path = [tuple(pts[0])]
    for q in list(pts[1:]) + [pts[0]]:
        cur = np.array(path[-1])
        q = np.asarray(q)
        for ax in range(3):
            while cur[ax] != q[ax]:
                cur = cur.copy()
                cur[ax] += np.sign(q[ax] - cur[ax])
                path.append(tuple(cur))
    path = path[:-1]
    # remove immediate backtracks
    st = []
    for v in path:
        if len(st) >= 2 and st[-2] == v:
            st.pop()
        elif st and st[-1] == v:
            continue
        else:
            st.append(v)
    while len(st) > 2 and st[0] == st[-2]:
        st = st[1:-1] if False else st
        break
    if len(set(st)) != len(st):
        return None
    return st if is_lattice_polygon([st]) else None


def torus_knot_curve(p, q, R=10.0, r=4.0, N=4000):
    t = np.linspace(0, 2 * np.pi, N, endpoint=False)
    x = (R + r * np.cos(q * t)) * np.cos(p * t)
    y = (R + r * np.cos(q * t)) * np.sin(p * t)
    z = r * np.sin(q * t)
    return np.stack([x, y, z], 1)
