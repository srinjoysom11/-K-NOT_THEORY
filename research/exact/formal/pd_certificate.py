#!/usr/bin/env python3
"""Upper-bound certificate: the regular projection of a lattice polygon along D, as a PD code, compared
with a target PD code up to relabelling of the edges by rotation/reversal of the orientation and up to
mirror image (over/under exchanged).  Exact arithmetic (fractions) throughout."""
import sys
from fractions import Fraction as Fr
sys.path.insert(0, __file__.rsplit('/',1)[0])
from projections import diagram, verts, proj

def pd_code(w, D):
    cr = diagram(w, D)
    assert cr is not None, "projection not regular"
    V = verts(w); n = len(V); P = [proj(D, v) for v in V]
    ev = []                                  # passages along the orientation
    for k, (i, t, j, u) in enumerate(cr):
        ev.append(((i, t), k, 'U')); ev.append(((j, u), k, 'O'))
    ev.sort()
    m = len(ev)                              # 2c passages -> 2c edges; edge e runs from passage e-1 to e
    lab_in = {}; lab_out = {}
    for e, (_, k, o) in enumerate(ev):
        lab_in[(k, o)] = (e - 1) % m + 1     # edge arriving at this passage (labels 1..m)
        lab_out[(k, o)] = e % m + 1          # edge leaving it
    def d2(i):
        a, b = P[i], P[(i + 1) % n]; return (b[0] - a[0], b[1] - a[1])
    X = []
    for k, (i, t, j, u) in enumerate(cr):
        du, do = d2(i), d2(j)
        a, c = lab_in[(k, 'U')], lab_out[(k, 'U')]
        b, d = lab_in[(k, 'O')], lab_out[(k, 'O')]
        # half-edges around the crossing at directions -du (a), +du (c), -do (b), +do (d);
        # counter-clockwise from -du the next one is +do if cross(-du, do) > 0
        crs = (-du[0]) * do[1] - (-du[1]) * do[0]
        X.append([a, d, c, b] if crs > 0 else [a, b, c, d])
    return X

def variants(pd):
    """all PD codes of the same unoriented diagram under relabelling by rotation (and reversal) of the
    edge numbering, each as a sorted tuple of crossing 4-tuples normalised to start anywhere is not allowed
    (PD starts at the incoming under-strand), so only relabellings are applied"""
    m = 2 * len(pd); out = set()
    for s in range(m):
        for rev in (False, True):
            f = (lambda x: (x - 1 + s) % m + 1) if not rev else (lambda x: (-(x - 1) + s) % m + 1)
            Y = []
            for a, b, c, d in pd:
                if not rev:
                    Y.append((f(a), f(b), f(c), f(d)))
                else:
                    # reversing the orientation: the incoming under-strand becomes c, and counter-clockwise
                    # order from it is c, d, a, b
                    Y.append((f(c), f(d), f(a), f(b)))
            out.add(tuple(sorted(Y)))
    return out

def mirror(pd):
    """mirror image (all crossings switched): the incoming under-strand of the new crossing is the
    over-strand of the old one; for X[a,b,c,d] the old over-strand is b->d or d->b."""
    out = []
    m = 2 * len(pd)
    for a, b, c, d in pd:
        # over strand runs from the smaller-by-one label to the next one (labels are consecutive along it)
        if (d - b) % m == 1:   # b incoming, d outgoing; ccw from b: c, d, a  -> new X[b, c, d, a]
            out.append([b, c, d, a])
        else:                  # d incoming, b outgoing; ccw from d: a, b, c -> new X[d, a, b, c]
            out.append([d, a, b, c])
    return out

def same_diagram(pd1, pd2):
    v2 = variants(pd2)
    return bool(variants(pd1) & v2) or bool(variants(mirror(pd1)) & v2)

if __name__ == "__main__":
    w, D = sys.argv[1], tuple(int(x) for x in sys.argv[2].split(','))
    target = eval(sys.argv[3])
    pd = pd_code(w, D)
    print("PD of the projection:", pd)
    print("matches target (up to relabelling, reversal, mirror):", same_diagram(pd, target))
