"""
alexander.py -- Alexander polynomial of a knot from a PD code, first-course version.

Each crossing (a, b, c, d) of a PD code has under-strand a -> c and over-strand {b, d}.
Arcs of the diagram = runs of edge labels joined through over-passes. Every crossing
gives the relation  (1 - t) * over + t * under_in - under_out = 0  if the over-strand
runs d -> b, and  (1 - t) * over + t * under_out - under_in = 0  if it runs b -> d
(the two crossing signs; this is the Wirtinger relation after Fox calculus). Delete one row and
one column of the crossing-by-arc matrix; the determinant is the Alexander polynomial
up to a unit +-t^k. We compute it exactly: evaluate the integer determinant at
t = 2, 3, ..., and interpolate. Pure Python, no dependencies.

alexander(pd) returns the coefficient list, lowest degree first, normalised to have
nonzero constant term and positive leading coefficient, e.g. trefoil -> [1, -1, 1].
"""
from fractions import Fraction


def _det(M):
    """Bareiss fraction-free determinant of an integer matrix."""
    M = [r[:] for r in M]
    n, sign, prev = len(M), 1, 1
    for k in range(n - 1):
        if M[k][k] == 0:
            for i in range(k + 1, n):
                if M[i][k]:
                    M[k], M[i] = M[i], M[k]
                    sign = -sign
                    break
            else:
                return 0
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                M[i][j] = (M[i][j] * M[k][k] - M[i][k] * M[k][j]) // prev
        prev = M[k][k]
    return sign * M[-1][-1] if n else 1


def alexander(pd):
    n = len(pd)
    if n == 0:
        return [1]
    parent = {}

    def find(x):
        parent.setdefault(x, x)
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    for a, b, c, d in pd:
        find(a), find(c)
        parent[find(b)] = find(d)
    arcs = sorted({find(x) for X in pd for x in X})
    idx = {r: i for i, r in enumerate(arcs)}
    assert len(arcs) == n, 'PD code is not a knot diagram with n arcs'

    def value(t):
        M = [[0] * n for _ in range(n)]
        for r, (a, b, c, d) in enumerate(pd):
            M[r][idx[find(b)]] += 1 - t
            if (d + 1) % (2 * n) == b:   # over-strand runs d -> b
                a, c = c, a
            M[r][idx[find(a)]] += t
            M[r][idx[find(c)]] -= 1
        return _det([row[:-1] for row in M[:-1]])

    xs = list(range(2, n + 2))            # degree <= n - 1, so n points suffice
    ys = [value(t) for t in xs]
    coef = [Fraction(0)] * n
    for i, xi in enumerate(xs):           # Lagrange interpolation
        num, den = [Fraction(1)], Fraction(1)
        for j, xj in enumerate(xs):
            if j != i:
                num = [Fraction(0)] + num
                for k in range(len(num) - 1):
                    num[k] -= xj * num[k + 1]
                den *= xi - xj
        for k in range(len(num)):
            coef[k] += ys[i] * num[k] / den
    c = [int(x) for x in coef]
    assert all(Fraction(a) == b for a, b in zip(c, coef))
    while c and c[0] == 0:
        c.pop(0)
    while c and c[-1] == 0:
        c.pop()
    if c and c[-1] < 0:
        c = [-x for x in c]
    return c


if __name__ == '__main__':
    import spherogram
    for name, want in [('3_1', [1, -1, 1]), ('4_1', [1, -3, 1]), ('5_1', [1, -1, 1, -1, 1]),
                       ('5_2', [2, -3, 2]), ('6_1', [2, -5, 2]), ('8_19', [1, -1, 0, 1, 0, -1, 1]),
                       ('6_3', [1, -3, 5, -3, 1]), ('7_7', [1, -5, 9, -5, 1]), ('10_124', [1, -1, 0, 1, -1, 1, 0, -1, 1])]:
        got = alexander(spherogram.Link(name).PD_code())
        g = got if got[-1] * want[-1] > 0 else [-x for x in got]
        print(name, got, 'OK' if g == want else 'WRONG')
