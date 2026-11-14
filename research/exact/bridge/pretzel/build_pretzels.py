import warnings; warnings.filterwarnings('ignore')
import sys, os
sys.path.insert(0, '/home/user/-K-NOT_THEORY/research/code')
sys.path.insert(0, '/home/user/-K-NOT_THEORY/code')
import spherogram
from alexander import alexander
# (name, r, columns)
KNOTS = [
 ('P(3,3,3,3,3)',5,[3,3,3,3,3]), ('P(3,3,3,-3,-3)',5,[3,3,3,-3,-3]), ('P(3,-3,3,-3,3)',5,[3,-3,3,-3,3]),
 ('P(3,3,3,3,2)',5,[3,3,3,3,2]), ('P(3,3,-3,-3,2)',5,[3,3,-3,-3,2]), ('P(3,-3,3,-3,2)',5,[3,-3,3,-3,2]),
 ('P(3,3,3,3,-2)',5,[3,3,3,3,-2]),
 ('P(3,3,3,3,3,2)',6,[3,3,3,3,3,2]), ('P(3,3,3,-3,-3,2)',6,[3,3,3,-3,-3,2]), ('P(3,-3,3,-3,3,-2)',6,[3,-3,3,-3,3,-2]),
 ('P(3,3,3,2)',4,[3,3,3,2]), ('P(3,3,-3,2)',4,[3,3,-3,2]), ('P(3,-3,3,2)',4,[3,-3,3,2]),
 ('P(3,3,3,-2)',4,[3,3,3,-2]), ('P(-3,-3,3,2)',4,[-3,-3,3,2]),
]
def build(ps):
    T = spherogram.RationalTangle(1, ps[0])
    for p in ps[1:]:
        T = T + spherogram.RationalTangle(1, p)
    return T.numerator_closure()
def alex(L):
    L2 = spherogram.Link(L.PD_code())
    L2.simplify('global')
    return alexander([tuple(x) for x in L2.PD_code()])
if __name__ == '__main__':
    for name, r, ps in KNOTS:
        L = build(ps)
        print(name, 'comps', len(L.link_components), 'crossings', len(L.crossings),
              'expected', sum(abs(p) for p in ps), 'alex', alex(L), flush=True)
