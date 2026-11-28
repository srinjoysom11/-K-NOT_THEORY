/* arcinj L: enumerate lattice arcs b in the half-space z >= 1 with |b| = L edges, from A = (0,0,1) (entered by u from
   (0,0,0)) to some B with z = 1 (left by d), self-avoiding, no reversal and no U-turn (a, c, -a) also across the two
   crossing letters u (first) and d (last).  Symmetry: the first horizontal letter is e, the first n/s letter (if any) is n.
   Count the non-geodesic ones and those that are non-injective (Lemma 3*) along: the axis z; all 9 directions
   (0|+-1, 0|+-1, 1); and an extended set of 25 directions (a, b, 1) and (a, b, 2) with |a|,|b| <= 2 (see -ext). */
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <algorithm>
#include <vector>
#include <unordered_set>
#include <deque>
#include <array>
static int L;
static const int DX[6] = {1, -1, 0, 0, 0, 0}, DY[6] = {0, 0, 1, -1, 0, 0}, DZ[6] = {0, 0, 0, 0, 1, -1};
static int px[64], py[64], pz[64], let[64]; static int *PX = px, *PY = py, *PZ = pz;
static unsigned char occ[64][64][40];
static unsigned long long cnt_end = 0, cnt_ng = 0, cnt_ax = 0, cnt_9 = 0, cnt_ext = 0;
static std::vector<std::pair<int,int>> dirs9, dirsx;   /* (a,b) for v = (a, b, 1) scaled; ext uses (a,b,c) */
struct D3 { int a, b, c; };
static std::vector<D3> E;
static int best9 = -1;
static bool inj(int m, int a, int b, int c) {   /* vertices 0..m-1; plane z = 1/2 -> doubled h2 = 1; v = (a, b, c) with c > 0 */
    static long long key[256]; int nk = 0;
    if (a == 0 && b == 0) {
        long long last = -1;
        for (int k = 0; k < m; k++) { long long q = (px[k] + 64) * 256 + py[k] + 64; if (q != last) { key[nk++] = q; last = q; } }
    } else {
        /* image of doubled point (X, Y, Z): t = (Z - 1) / c (in units where v has z-component c): image = (X c - (Z-1) a, Y c - (Z-1) b) */
        auto put = [&](int X, int Y, int Z) { long long u = (long long)X * c - (long long)(Z - 1) * a, w = (long long)Y * c - (long long)(Z - 1) * b; key[nk++] = (u + 100000) * 300000 + (w + 100000); };
        put(2 * px[0], 2 * py[0], 1);
        put(2 * px[0], 2 * py[0], 2 * pz[0]);
        for (int k = 1; k < m; k++) { put(px[k-1] + px[k], py[k-1] + py[k], pz[k-1] + pz[k]); put(2 * px[k], 2 * py[k], 2 * pz[k]); }
        put(2 * px[m-1], 2 * py[m-1], 1);
    }
    std::sort(key, key + nk);
    for (int k = 1; k < nk; k++) if (key[k] == key[k-1]) return false;
    /* for non-unit tilts the segments are no longer on one lattice: check segment intersections exactly */
    return true;
}
/* exact simple-curve test of the projected polyline (for general directions): segments in the plane, rational coords scaled by c */
static bool inj_exact(int m, int a, int b, int c) {
    if (a == 0 && b == 0) return inj(m, 0, 0, 1);
    std::vector<long long> X, Y;   /* image points scaled by 2c */
    auto img = [&](int X2, int Y2, int Z2) { X.push_back((long long)X2 * c - (long long)(Z2 - 1) * a); Y.push_back((long long)Y2 * c - (long long)(Z2 - 1) * b); };
    img(2 * px[0], 2 * py[0], 1);
    for (int k = 0; k < m; k++) img(2 * px[k], 2 * py[k], 2 * pz[k]);
    img(2 * px[m-1], 2 * py[m-1], 1);
    int ns = (int)X.size() - 1;
    auto cross = [](long long ax, long long ay, long long bx, long long by) { return ax * by - ay * bx; };
    for (int i = 0; i < ns; i++) for (int j = i + 1; j < ns; j++) {
        long long p1x = X[i], p1y = Y[i], p2x = X[i+1], p2y = Y[i+1], q1x = X[j], q1y = Y[j], q2x = X[j+1], q2y = Y[j+1];
        long long d1 = cross(p2x - p1x, p2y - p1y, q1x - p1x, q1y - p1y), d2 = cross(p2x - p1x, p2y - p1y, q2x - p1x, q2y - p1y);
        long long d3 = cross(q2x - q1x, q2y - q1y, p1x - q1x, p1y - q1y), d4 = cross(q2x - q1x, q2y - q1y, p2x - q1x, p2y - q1y);
        bool inter;
        auto onseg = [](long long ax, long long ay, long long bx, long long by, long long cx, long long cy) { return std::min(ax, bx) <= cx && cx <= std::max(ax, bx) && std::min(ay, by) <= cy && cy <= std::max(ay, by); };
        if (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) && ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) inter = true;
        else inter = (d1 == 0 && onseg(p1x, p1y, p2x, p2y, q1x, q1y)) || (d2 == 0 && onseg(p1x, p1y, p2x, p2y, q2x, q2y)) ||
                     (d3 == 0 && onseg(q1x, q1y, q2x, q2y, p1x, p1y)) || (d4 == 0 && onseg(q1x, q1y, q2x, q2y, p2x, p2y));
        if (j == i + 1) {   /* consecutive segments share an end point: they must not overlap otherwise */
            if (d1 == 0 && d2 == 0) {   /* collinear: overlap iff the far end of segment j lies inside segment i (direction reversal) */
                long long dx1 = p2x - p1x, dy1 = p2y - p1y, dx2 = q2x - q1x, dy2 = q2y - q1y;
                if (dx1 * dx2 + dy1 * dy2 < 0) return false;
            }
            continue;
        }
        if (inter) return false;
    }
    return true;
}

/* certificate search: moves of the arc inside z >= 1 with fixed end vertices (corner flips, +2 and -2 moves), breadth
   first, at most CLIM states and length <= L + CEXT; success when some state is injective along a direction of D. */
static int CLIM = 20000, CEXT = 4; static unsigned long long cert_fail = 0, cert_states = 0, cert_maxdepth = 0;
typedef std::vector<signed char> Arc;   /* x,y,z triples */
static bool arc_inj_any(const Arc &a) {
    int m = (int)a.size() / 3; static int qx[200], qy[200], qz[200];
    for (int k = 0; k < m; k++) { qx[k] = a[3*k]; qy[k] = a[3*k+1]; qz[k] = a[3*k+2]; }
    int *sx = PX, *sy = PY, *sz = PZ; int bx[64], by[64], bz[64];
    for (int k = 0; k < m; k++) { bx[k] = px[k]; by[k] = py[k]; bz[k] = pz[k]; px[k] = qx[k]; py[k] = qy[k]; pz[k] = qz[k]; }
    bool ok = inj(m, 0, 0, 1);
    for (int aa = -1; aa <= 1 && !ok; aa++) for (int bb = -1; bb <= 1 && !ok; bb++) if ((aa || bb) && inj(m, aa, bb, 1)) ok = true;
    for (size_t t = 0; t < E.size() && !ok; t++) if (inj_exact(m, E[t].a, E[t].b, E[t].c)) ok = true;
    for (int k = 0; k < m; k++) { px[k] = bx[k]; py[k] = by[k]; pz[k] = bz[k]; }
    (void)sx; (void)sy; (void)sz;
    return ok;
}
struct AH { size_t operator()(const Arc &a) const { size_t h = 1469598103934665603ULL; for (signed char c : a) { h ^= (unsigned char)c; h *= 1099511628211ULL; } return h; } };
static bool certify(int m0) {
    Arc a0; for (int k = 0; k < m0; k++) { a0.push_back(px[k]); a0.push_back(py[k]); a0.push_back(pz[k]); }
    std::unordered_set<Arc, AH> seen; std::deque<std::pair<Arc,int>> q; seen.insert(a0); q.push_back({a0, 0});
    const int maxv = m0 + CEXT;
    while (!q.empty()) {
        Arc a = q.front().first; int dep = q.front().second; q.pop_front();
        int m = (int)a.size() / 3;
        auto V = [&](int k, int c) { return (int)a[3*k+c]; };
        auto occupied = [&](int x, int y, int z) { for (int k = 0; k < m; k++) if (V(k,0) == x && V(k,1) == y && V(k,2) == z) return true; return false; };
        std::vector<Arc> nb;
        for (int i = 1; i + 1 < m; i++) {   /* corner flip */
            int d1[3], d2[3]; for (int c = 0; c < 3; c++) { d1[c] = V(i,c) - V(i-1,c); d2[c] = V(i+1,c) - V(i,c); }
            if (d1[0] == d2[0] && d1[1] == d2[1] && d1[2] == d2[2]) continue;
            int w[3]; for (int c = 0; c < 3; c++) w[c] = V(i-1,c) + V(i+1,c) - V(i,c);
            if (w[2] < 1 || occupied(w[0], w[1], w[2])) continue;
            Arc b = a; for (int c = 0; c < 3; c++) b[3*i+c] = w[c]; nb.push_back(b);
        }
        if (m + 2 <= maxv) for (int i = 0; i + 1 < m; i++) {   /* +2: edge (i, i+1) pushed out by delta */
            for (int dd = 0; dd < 6; dd++) {
                int dl[3] = {DX[dd], DY[dd], DZ[dd]}; int e[3]; for (int c = 0; c < 3; c++) e[c] = V(i+1,c) - V(i,c);
                if (dl[0]*e[0] + dl[1]*e[1] + dl[2]*e[2] != 0) continue;
                int u1[3], u2[3]; for (int c = 0; c < 3; c++) { u1[c] = V(i,c) + dl[c]; u2[c] = V(i+1,c) + dl[c]; }
                if (u1[2] < 1 || u2[2] < 1 || occupied(u1[0],u1[1],u1[2]) || occupied(u2[0],u2[1],u2[2])) continue;
                Arc b(a.begin(), a.begin() + 3*(i+1)); for (int c = 0; c < 3; c++) b.push_back(u1[c]); for (int c = 0; c < 3; c++) b.push_back(u2[c]);
                b.insert(b.end(), a.begin() + 3*(i+1), a.end()); nb.push_back(b);
            }
        }
        for (int i = 0; i + 3 < m; i++) {   /* -2: U = (i, i+1, i+2, i+3) with |v_{i+3} - v_i| = 1 */
            int s = 0; for (int c = 0; c < 3; c++) s += abs(V(i+3,c) - V(i,c));
            if (s != 1) continue;
            Arc b(a.begin(), a.begin() + 3*(i+1)); b.insert(b.end(), a.begin() + 3*(i+3), a.end()); nb.push_back(b);
        }
        for (auto &b : nb) {
            if (seen.count(b)) continue;
            if (arc_inj_any(b)) { cert_states += seen.size(); if ((unsigned)dep + 1 > cert_maxdepth) cert_maxdepth = dep + 1; return true; }
            if ((int)seen.size() >= CLIM) { cert_states += seen.size(); return false; }
            seen.insert(b); q.push_back({b, dep + 1});
        }
    }
    cert_states += seen.size();
    return false;
}

static bool EXT = false, SELF = false; static unsigned long long selfbad = 0;
static void leaf(int m) {   /* m vertices, L = m - 1 edges */
    cnt_end++;
    int d = abs(px[m-1]) + abs(py[m-1]);
    if (L == d) return;
    cnt_ng++;
    if (SELF) for (int a = -1; a <= 1; a++) for (int b = -1; b <= 1; b++) if ((a || b) && inj(m, a, b, 1) != inj_exact(m, a, b, 1)) selfbad++;
    if (inj(m, 0, 0, 1)) return;
    cnt_ax++;
    for (int a = -1; a <= 1; a++) for (int b = -1; b <= 1; b++) if ((a || b) && inj(m, a, b, 1)) return;
    cnt_9++;
    if (EXT) { for (auto &v : E) if (inj_exact(m, v.a, v.b, v.c)) return; cnt_ext++; if (!certify(m)) { cert_fail++; printf("NO CERTIFICATE L=%d: u", L); for (int k = 0; k < m - 1; k++) printf("%c", "ewnsud"[let[k]]); printf("d\n"); } if (cnt_ext <= 0) { printf("ext-example L=%d: u", L); for (int k = 0; k < m - 1; k++) printf("%c", "ewnsud"[let[k]]); printf("d\n"); } }
    if (cnt_9 <= 5) { printf("example (9 dirs non-injective) L=%d: u", L); for (int k = 0; k < m - 1; k++) printf("%c", "ewnsud"[let[k]]); printf("d\n"); }
}
static void dfs(int k, bool seenH, bool seenNS) {   /* k = index of current vertex; letters let[0..k-1] */
    if (k == L) { if (pz[k] == 1) { int l2 = let[k-1], l1 = k >= 2 ? let[k-2] : 4; /* next letter d: no U-turn (l1, l2, d): l1 != u; reversal: l2 != u */
            if (l2 == 4 || l1 == 4) return; leaf(k + 1); } return; }
    int rem = L - k;
    for (int dd = 0; dd < 6; dd++) {
        int prev = k >= 1 ? let[k-1] : 4, prev2 = k >= 2 ? let[k-2] : (k == 1 ? 4 : -1);
        if (dd == (prev ^ 1)) continue;
        if (prev2 >= 0 && dd == (prev2 ^ 1)) continue;
        if (!seenH && (dd == 1)) continue;
        if (!seenH && dd == 2) continue; if (!seenH && dd == 3) continue;   /* first horizontal letter is e */
        if (!seenNS && dd == 3) continue;                                   /* first n/s letter is n */
        int x = px[k] + DX[dd], y = py[k] + DY[dd], z = pz[k] + DZ[dd];
        if (z < 1) continue;
        if (z - 1 > rem - 1) continue;
        if (occ[x + 32][y + 32][z]) continue;
        occ[x + 32][y + 32][z] = 1; px[k+1] = x; py[k+1] = y; pz[k+1] = z; let[k] = dd;
        dfs(k + 1, seenH || dd < 4, seenNS || dd == 2 || dd == 3);
        occ[x + 32][y + 32][z] = 0;
    }
}
int main(int argc, char **argv) {
    L = atoi(argv[1]); EXT = argc > 2;
    int K = EXT ? atoi(argv[2]) : 0;
    auto gcd = [](int x, int y) { x = abs(x); y = abs(y); while (y) { int t = x % y; x = y; y = t; } return x; };
    for (int c = 1; c <= K; c++) for (int a = -K; a <= K; a++) for (int b = -K; b <= K; b++) { if (c == 1 && abs(a) <= 1 && abs(b) <= 1) continue; if (gcd(gcd(a, b), c) != 1) continue; E.push_back({a, b, c}); }
    if (argc > 3) SELF = true;
    fprintf(stderr, "extra directions: %zu\n", E.size());
    if (getenv("CERTFILE")) {   /* re-certify listed arcs (words u...d) with CLIM / CEXT from the environment */
        CLIM = atoi(getenv("CLIM")); CEXT = atoi(getenv("CEXT"));
        FILE *f = fopen(getenv("CERTFILE"), "r"); char w[256]; int bad = 0, tot = 0;
        while (fscanf(f, "%255s", w) == 1) {
            int n = (int)strlen(w); px[0] = py[0] = 0; pz[0] = 1;
            for (int k = 1; k < n - 1; k++) { int dd = (int)(strchr("ewnsud", w[k]) - "ewnsud"); px[k] = px[k-1] + DX[dd]; py[k] = py[k-1] + DY[dd]; pz[k] = pz[k-1] + DZ[dd]; }
            unsigned long long s0 = cert_states, d0 = cert_maxdepth; cert_maxdepth = 0;
            bool ok = certify(n - 1); tot++; if (!ok) bad++;
            printf("%s %s states=%llu depth=%llu\n", w, ok ? "CERTIFIED" : "NO-CERT", cert_states - s0, cert_maxdepth); (void)d0;
        }
        printf("total=%d uncertified=%d\n", tot, bad); return 0;
    }
    px[0] = py[0] = 0; pz[0] = 1; occ[32][32][1] = 1;
    dfs(0, false, false);
    if (SELF) printf("selfcheck mismatches=%llu\n", selfbad);
    printf("cert_fail=%llu cert_states=%llu cert_maxdepth=%llu\n", cert_fail, cert_states, cert_maxdepth);
    printf("L=%d arcs=%llu nongeodesic=%llu nonInj_axis=%llu nonInj_9=%llu nonInj_9+ext=%llu\n", L, cnt_end, cnt_ng, cnt_ax, cnt_9, cnt_ext);
}
