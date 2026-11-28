s = open('enum_s3.cpp').read()
def rep(old, new, cnt=1):
    global s
    assert s.count(old) == cnt, (old[:80], s.count(old))
    s = s.replace(old, new)
rep('static int STAIRG = -1;', 'static int STAIRG = -1, ARCMIN = 0;')
# S4 in owed / owed_plane: both occurrences of the STAIRG block
old = '''                if ((p == mn && badl[A][mn + 32]) || (p == mx - 1 && badl[A][mx + 32]) || g4[A][p + 32]) req = 4;
            } else if'''
new = '''                if ((p == mn && badl[A][mn + 32]) || (p == mx - 1 && badl[A][mx + 32]) || g4[A][p + 32]) req = 4;
                else if (ARCMIN && arcmin_req4(A, p, mn, mx)) req = 4;
            } else if'''
rep(old, new)
old = '''            if ((p == mn && badl[A][mn + 32]) || (p == mx - 1 && badl[A][mx + 32]) || g4[A][p + 32]) req = 4;
        } else if'''
new = '''            if ((p == mn && badl[A][mn + 32]) || (p == mx - 1 && badl[A][mx + 32]) || g4[A][p + 32]) req = 4;
            else if (ARCMIN && arcmin_req4(A, p, mn, mx)) req = 4;
        } else if'''
rep(old, new)
rep('    unsigned char badl[3][64]; unsigned char g4[3][64];', '''    unsigned char badl[3][64]; unsigned char g4[3][64]; int levc[3][64];
    /* S4 (-arcmin M): every non-geodesic side of a twice-crossed plane has >= M edges (Lemma 3* + the certificate
       enumeration).  Side lo of the plane p + 1/2 is surely non-geodesic if the final polygon has a level < p (mn < p: an
       A-step inside the side) or a level <= p holds a non-monotone stretch; same for side hi.  With exactly two crossings,
       |lo| + |hi| = N - 2 and |hi| >= (vertices placed on side hi) - 1.  So the plane needs 4 crossings if both sides are
       non-geodesic and N - 2 < 2M, or a non-geodesic side is left fewer than M edges by the vertices placed on the other. */
    bool arcmin_req4(int A, int p, int mn, int mx) const {
        bool nglo = p > mn, nghi = p + 1 < mx;
        int vlo = 0, vhi = 0;
        for (int c = mn; c <= mx; c++) {
            if (c <= p) { vlo += levc[A][c + 32]; if (badl[A][c + 32]) nglo = true; }
            else { vhi += levc[A][c + 32]; if (badl[A][c + 32]) nghi = true; }
        }
        if (nglo && nghi && N - 2 < 2 * ARCMIN) return true;
        if (nglo && N - 1 - vhi < ARCMIN) return true;
        if (nghi && N - 1 - vlo < ARCMIN) return true;
        return false;
    }''')
rep('memset(badl, 0, sizeof badl); memset(g4, 0, sizeof g4);', 'memset(badl, 0, sizeof badl); memset(g4, 0, sizeof g4); memset(levc, 0, sizeof levc); levc[0][CX[ORG] + 32]++; levc[1][CY[ORG] + 32]++; levc[2][CZ[ORG] + 32]++;')
# level counts on placement / undo
rep('            cnt[A]++; occ[nx] = 1; code[t] = d;', '            cnt[A]++; occ[nx] = 1; code[t] = d; levc[0][CX[nx] + 32]++; levc[1][CY[nx] + 32]++; levc[2][CZ[nx] + 32]++;')
rep('            sumz -= CZ[nx] - CZ[ORG]; occ[nx] = 0;', '            levc[0][CX[nx] + 32]--; levc[1][CY[nx] + 32]--; levc[2][CZ[nx] + 32]--; sumz -= CZ[nx] - CZ[ORG]; occ[nx] = 0;')
# recompute after placement (after svcd saved): put into the g4 block
rep('''            int g4p = -1;
            if (ok && STAIRG >= 1''', '''            int g4p = -1; bool amchg = false;
            if (ok && ARCMIN) {
                for (int B = 0; B < 3; B++) cdef[B] = owed(B);
                amchg = true;
                if (cdef[0] + cdef[1] + cdef[2] > R - 1) { ok = false; st.amkill++; st.rej[2][R - 1]++; }
            }
            if (ok && STAIRG >= 1''')
rep('if (fchg || zr4 != szr4 || g4p >= 0) for', 'if (fchg || zr4 != szr4 || g4p >= 0 || amchg) for')
# S2 and S3 with the length rule
rep('''        if (m - 1 == mdist(av[0], av[m - 1])) return false;          /* geodesic */''',
'''        if (m - 1 == mdist(av[0], av[m - 1])) return false;          /* geodesic */
        if (m - 1 < ARCMIN) return true;                              /* short non-geodesic side: certificate (Lemma 5*) */''')
rep('unsigned long long g4set = 0, g4kill = 0, s3leaf = 0;', 'unsigned long long g4set = 0, g4kill = 0, s3leaf = 0, amkill = 0;')
rep('g4set += o.g4set;', 'g4set += o.g4set; amkill += o.amkill;')
rep('''        else if (a == "-nos3leaf") S3LEAF = false;''', '''        else if (a == "-nos3leaf") S3LEAF = false;
        else if (a == "-arcmin") ARCMIN = atoi(argv[++i]);''')
rep('''fprintf(stderr, "stairg=%d g4set=%llu g4kill=%llu s3leaf=%llu\\n", STAIRG, total.g4set, total.g4kill, total.s3leaf);''',
    '''fprintf(stderr, "stairg=%d arcmin=%d g4set=%llu g4kill=%llu amkill=%llu s3leaf=%llu\\n", STAIRG, ARCMIN, total.g4set, total.g4kill, total.amkill, total.s3leaf);''')
open('enum_s3.cpp','w').write(s)
