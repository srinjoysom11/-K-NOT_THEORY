import sys
s = open('enum_v.cpp').read()
def rep(old, new, cnt=1):
    global s
    assert s.count(old) == cnt, (old, s.count(old))
    s = s.replace(old, new)

hdr = '''/* enum_s3.cpp: enum_v.cpp + -stairg K, a plane rule that needs no primeness (Lemma 3*): if a mid-plane is crossed by
 * exactly two edges of a shortest polygon (any knot type) and the arc alpha on one side has an injective projection onto
 * the plane along some direction v pointing into its half-space, alpha is a Manhattan geodesic.  -stairg K turns on the
 * plane-crossing debt with requirements valid for every knot type:
 *   (S0) every mid-plane between the final extreme levels: 2 crossings (interior planes need NOT 4 here);
 *   (S1) outer stair: plane mn+1/2 needs 4 if level mn holds a non-monotone stretch (same for mx-1/2 with level mx),
 *        also when mx - mn = 1 (OR, not AND as -stair);
 *   (S2) K >= 1: complete side: when a step makes the count of plane p equal to 2, the arc between the two crossing edges
 *        is the whole far side in every completion with exactly two crossings; if it is non-geodesic and injective in a
 *        tested direction (K = 1: the axis only, K = 9: the axis and the 8 tilts (+-1|0, +-1|0, 1)), p needs 4;
 *   (S3) the exact Lemma 3* test on the finished polygon (every twice-crossed plane, both sides, tested directions).
 *   -tauz 1 with -stairg is sound (the bottom side of z = 1/2 is flat, hence injective along z).
 *   -dumpcand FILE: write every candidate leaf (after all leaf tests, before the flip reduction).  -nos3leaf: skip S3.
 */
'''
s = hdr + s
rep('static bool PRIME = false, STAIR = false, AOTC = false;',
    'static bool PRIME = false, STAIR = false, AOTC = false; static int STAIRG = -1; static bool S3LEAF = true; static const char *DUMPCAND = nullptr;')
# owed / owed_plane
old1 = '''            if (STAIR && req == 2) {
                if (mx - mn == 1) { if (badl[A][mn + 32] && badl[A][mx + 32]) req = 4; }
                else if (p == mn) { if (badl[A][mn + 32]) req = 4; }
                else { if (badl[A][mx + 32]) req = 4; }
            }'''
new1 = '''            if (STAIRG >= 0) {
                req = 2;
                if ((p == mn && badl[A][mn + 32]) || (p == mx - 1 && badl[A][mx + 32]) || g4[A][p + 32]) req = 4;
            } else if (STAIR && req == 2) {
                if (mx - mn == 1) { if (badl[A][mn + 32] && badl[A][mx + 32]) req = 4; }
                else if (p == mn) { if (badl[A][mn + 32]) req = 4; }
                else { if (badl[A][mx + 32]) req = 4; }
            }'''
rep(old1, new1)
old2 = '''        if (STAIR && req == 2) {
            if (mx - mn == 1) { if (badl[A][mn + 32] && badl[A][mx + 32]) req = 4; }
            else if (p == mn) { if (badl[A][mn + 32]) req = 4; }
            else { if (badl[A][mx + 32]) req = 4; }
        }'''
new2 = '''        if (STAIRG >= 0) {
            req = 2;
            if ((p == mn && badl[A][mn + 32]) || (p == mx - 1 && badl[A][mx + 32]) || g4[A][p + 32]) req = 4;
        } else if (STAIR && req == 2) {
            if (mx - mn == 1) { if (badl[A][mn + 32] && badl[A][mx + 32]) req = 4; }
            else if (p == mn) { if (badl[A][mn + 32]) req = 4; }
            else { if (badl[A][mx + 32]) req = 4; }
        }'''
rep(old2, new2)
rep('    unsigned char badl[3][64];', '    unsigned char badl[3][64]; unsigned char g4[3][64];')
rep('memset(badl, 0, sizeof badl);', 'memset(badl, 0, sizeof badl); memset(g4, 0, sizeof g4);')
rep('if (TAUZ && STAIR) {', 'if (TAUZ && (STAIR || STAIRG >= 0)) {')
rep('''                if (STAIR) stair_step(side, A, d, from, ss);
                if (cdef[0] + cdef[1] + cdef[2] > R - 1) { if (STAIR) stair_undo(side, A, ss); plane_undo(A, smn, smx, sdef, pl); return false; }''',
'''                if (STAIR || STAIRG >= 0) stair_step(side, A, d, from, ss);
                if (cdef[0] + cdef[1] + cdef[2] > R - 1) { if (STAIR || STAIRG >= 0) stair_undo(side, A, ss); plane_undo(A, smn, smx, sdef, pl); return false; }''')
rep('            if (PRIME && STAIR) stair_undo(side, A, ss);', '            if (PRIME && (STAIR || STAIRG >= 0)) stair_undo(side, A, ss);')
# S2 in step_body after face check
old3 = '''            if (ok) { if (!trust) st.ntest++; trust_step = trust; ok = update2(side, li, nx, ofa, ola, R - 1); trust_step = false; }'''
new3 = '''            int g4p = -1;
            if (ok && STAIRG >= 1 && crs[A][pl] == 2 && !g4[A][pl]) {
                if (complete_side_kills(A, pl - 32)) {
                    g4[A][pl] = 1; g4p = pl; st.g4set++;
                    cdef[A] = owed(A);
                    if (cdef[0] + cdef[1] + cdef[2] > R - 1) { ok = false; st.g4kill++; st.rej[2][R - 1]++; }
                }
            }
            if (ok) { if (!trust) st.ntest++; trust_step = trust; ok = update2(side, li, nx, ofa, ola, R - 1); trust_step = false; }'''
rep(old3, new3)
rep('''            if (fchg || zr4 != szr4) for (int B = 0; B < 3; B++) cdef[B] = svcd[B];''',
'''            if (g4p >= 0) g4[A][g4p] = 0;
            if (fchg || zr4 != szr4 || g4p >= 0) for (int B = 0; B < 3; B++) cdef[B] = svcd[B];''')
# stats
rep('unsigned long long ntest = 0, nodes = 0,', 'unsigned long long g4set = 0, g4kill = 0, s3leaf = 0; unsigned long long ntest = 0, nodes = 0,')
rep('void add(const Stats &o) { ntest += o.ntest;', 'void add(const Stats &o) { g4set += o.g4set; g4kill += o.g4kill; s3leaf += o.s3leaf; ntest += o.ntest;')
# helper functions, inserted before face_check
helpers = r'''
    /* ---------- Lemma 3* (-stairg) ---------- */
    /* arc = vertex cells av[0..m-1] (m >= 2), all on side sigma of the plane x_A = p + 1/2, end vertices in the level next
       to the plane.  Injective projection along v = sigma e_A + a e_B + b e_C onto the plane, of the extended arc (half-edge
       from the plane to av[0], the arc, half-edge from av[m-1] to the plane).  a = b = 0: the axis projection, which collapses
       A-edges: injective means every column (B, C) is visited in one contiguous run and the path of columns is simple.
       Otherwise: doubled coordinates; the images of the vertices, of the edge midpoints and of the two points on the plane
       must be pairwise distinct (all segments are unit axis or diagonal steps between points of one lattice, so two of them
       meet only at such sample points). */
    static bool inj_dir(const int *av, int m, int A, int p, int sigma, int a, int b) {
        const int B = A == 0 ? 1 : 0, C = A == 2 ? 1 : 2;
        int key[2 * MAXN + 8]; int nk = 0;
        if (a == 0 && b == 0) {
            int last = -1;
            for (int k = 0; k < m; k++) { int c = (coord(B, av[k]) + 32) * 64 + coord(C, av[k]) + 32; if (c != last) { key[nk++] = c; last = c; } }
        } else {
            const int h2 = 2 * p + 1;
            auto put = [&](int x2a, int x2b, int x2c) { int t = (x2a - h2) * sigma; int u = x2b - t * a, w = x2c - t * b; key[nk++] = (u + 256) * 1024 + (w + 256); };
            put(h2, 2 * coord(B, av[0]), 2 * coord(C, av[0]));
            put(2 * coord(A, av[0]), 2 * coord(B, av[0]), 2 * coord(C, av[0]));
            for (int k = 1; k < m; k++) {
                put(coord(A, av[k - 1]) + coord(A, av[k]), coord(B, av[k - 1]) + coord(B, av[k]), coord(C, av[k - 1]) + coord(C, av[k]));
                put(2 * coord(A, av[k]), 2 * coord(B, av[k]), 2 * coord(C, av[k]));
            }
            put(h2, 2 * coord(B, av[m - 1]), 2 * coord(C, av[m - 1]));
        }
        std::sort(key, key + nk);
        for (int k = 1; k < nk; k++) if (key[k] == key[k - 1]) return false;
        return true;
    }
    /* Lemma 3* applies to the arc: it is non-geodesic and injective along one of the tested directions */
    static bool l3s_arc(const int *av, int m, int A, int p) {
        if (m - 1 == mdist(av[0], av[m - 1])) return false;          /* geodesic */
        const int sigma = coord(A, av[0]) > p ? 1 : -1;
        if (inj_dir(av, m, A, p, sigma, 0, 0)) return true;
        if (STAIRG >= 9) for (int a = -1; a <= 1; a++) for (int b = -1; b <= 1; b++) if ((a || b) && inj_dir(av, m, A, p, sigma, a, b)) return true;
        return false;
    }
    /* S2: the placed path from P(-T) to P(H) crosses x_A = p + 1/2 exactly twice; the arc between the two crossing edges */
    bool complete_side_kills(int A, int p) {
        int i = NONE, j = NONE;
        for (int k = -T; k < H; k++) if ((coord(A, P(k)) <= p) != (coord(A, P(k + 1)) <= p)) { if (i == NONE) i = k; else { j = k; break; } }
        if (j == NONE) return false;
        int av[MAXN + 2], m = 0;
        for (int k = i + 1; k <= j; k++) av[m++] = P(k);
        return l3s_arc(av, m, A, p);
    }
    /* S3: exact test on the finished polygon pos[0..N-1] */
    bool l3s_leaf_kills() {
        for (int A = 0; A < 3; A++) {
            int lo = 1000, hi = -1000;
            for (int i = 0; i < N; i++) { int c = coord(A, pos[i]); if (c < lo) lo = c; if (c > hi) hi = c; }
            for (int p = lo; p < hi; p++) {
                int cr[2], nc = 0;
                for (int i = 0; i < N && nc <= 2; i++) if ((coord(A, pos[i]) <= p) != (coord(A, pos[(i + 1) % N]) <= p)) { if (nc < 2) cr[nc] = i; nc++; }
                if (nc != 2) continue;
                int av[MAXN + 2], m = 0;
                for (int k = cr[0] + 1; k <= cr[1]; k++) av[m++] = pos[k % N];
                if (l3s_arc(av, m, A, p)) return true;
                m = 0;
                for (int k = cr[1] + 1; k <= cr[0] + N; k++) av[m++] = pos[k % N];
                if (l3s_arc(av, m, A, p)) return true;
            }
        }
        return false;
    }
'''
rep('    static inline int coord(int A, int p) { return A == 0 ? CX[p] : A == 1 ? CY[p] : CZ[p]; }',
    '    static inline int coord(int A, int p) { return A == 0 ? CX[p] : A == 1 ? CY[p] : CZ[p]; }' + helpers)
rep('''        if (TAU && tau_leaf_cut()) { st.tauleaf++; return; }
        st.cand++;''', '''        if (TAU && tau_leaf_cut()) { st.tauleaf++; return; }
        if (STAIRG >= 0 && S3LEAF && l3s_leaf_kills()) { st.s3leaf++; return; }
        st.cand++;
        if (DUMPCAND) { std::string w(N, ' '); for (int i = 0; i < N; i++) w[i] = DC[dirs[i]]; cands.push_back(w); }''')
rep('    std::vector<std::string> out;', '    std::vector<std::string> out, cands;')
rep('''        else if (a == "-plane4") PLANE4 = true;''', '''        else if (a == "-plane4") PLANE4 = true;
        else if (a == "-stairg") { STAIRG = atoi(argv[++i]); PRIME = true; }
        else if (a == "-nos3leaf") S3LEAF = false;
        else if (a == "-dumpcand") DUMPCAND = argv[++i];''')
rep('''        words.insert(words.end(), s->out.begin(), s->out.end());''', '''        words.insert(words.end(), s->out.begin(), s->out.end());
        candw.insert(candw.end(), s->cands.begin(), s->cands.end());''')
rep('    std::vector<std::string> words;\n', '    std::vector<std::string> words, candw;\n')
rep('''    if (SLAB >= 0) fprintf(stderr, "slab=%d ", SLAB);''', '''    if (DUMPCAND) { std::sort(candw.begin(), candw.end()); FILE *fc = fopen(DUMPCAND, "w"); for (auto &w : candw) fprintf(fc, "%s\\n", w.c_str()); fclose(fc); }
    if (STAIRG >= 0) fprintf(stderr, "stairg=%d g4set=%llu g4kill=%llu s3leaf=%llu\\n", STAIRG, total.g4set, total.g4kill, total.s3leaf);
    if (SLAB >= 0) fprintf(stderr, "slab=%d ", SLAB);''')
open('enum_s3.cpp', 'w').write(s)
