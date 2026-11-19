/*
 * enum.cpp -- exhaustive enumeration of candidate minimal lattice polygons in Z^3.
 *
 * Purpose: prove lower bounds on Len(K).  For a given even n the program visits every
 * n-step self-avoiding polygon in Z^3 (up to translation, direction, and permutation of
 * the axes) that passes the "curtain test" below, and prints those it cannot shorten.
 * Every polygon that is a shortest representative of its knot type passes the test and
 * cannot be shortened, so it is printed (in at least one of its symmetric copies).
 *
 * Curtain lemma (proved in research/exact/PROOF.md).  Let a polygon contain consecutive
 * vertices v0, v1 = v0+a, ..., v_{k+1}, v_{k+2} = v_{k+1}-a, where a is a unit vector and
 * all k >= 1 steps from v1 to v_{k+1} are perpendicular to a.  If none of the k-1 lattice
 * points v_j - a (2 <= j <= k) is a vertex of the polygon, then replacing the sub-path by
 * its translate by -a gives a polygon of the same knot type with 2 fewer edges.
 * (k = 1 is the BFACF -2 move.)  Hence in a shortest polygon every such sub-path has an
 * occupied point below its interior.
 *
 * Pushed-down normal form (proved in PROOF.md; switch off with -nopsi).  Among all shortest
 * polygons of a knot type with (#z-steps) <= (#y-steps) <= (#x-steps), take one that minimises
 * first Psi = sum over vertices of (z - least z) and then Psi2 = sum of (y - least y).  In it no
 * corner flip (neutral BFACF move) lowers a vertex in z, or keeps z and lowers y.  So for
 * consecutive steps (u,h), (h,d) with h horizontal, and (n,x), (x,s) with x in {e,w}, the
 * fourth point of the unit square spanned by the corner must be a vertex of the polygon.
 * With -nopsi every shortest polygon is listed; without it at least one per knot type.
 *
 * Canonical choices (each polygon is reached at least once):
 *   root      = the vertex that is least in (z, y, x) order, placed at the origin;
 *   direction = the first step is smaller than the reverse of the last step (e < n < u);
 *   axes      = (#z-steps) <= (#y-steps) <= (#x-steps)          [switch off with -noaxes]
 *
 * usage: enum N [options]
 *   -plain        no curtain test, no reduction: counts all polygons (validation)
 *   -noaxes       do not use the axis-permutation reduction
 *   -nopsi        do not use the pushed-down normal form
 *   -prime        use the plane-crossing lemma: every lattice plane with at least two occupied
 *                 levels on each side is crossed by >= 4 edges.  Proved for shortest polygons of
 *                 PRIME knots only, so the output is complete for prime knot types only
 *                 (and for all knot types up to N = 36, PROOF.md section 2b)
 *   -stair        -prime, and also: if a level is the outermost one on its axis, at least two
 *                 levels lie on the other side of the plane next to it, and the walk has a
 *                 stretch inside that level that uses two opposite directions, then that plane
 *                 is crossed by >= 4 edges (the other half of the plane-crossing lemma)
 *   -bridge B     only polygons with >= B local maxima along each axis (every polygon of a knot
 *                 with bridge number >= B is of this kind); used for bounds on such knots
 *   -noreduce     skip the neutral-move reduction at the leaves
 *   -nomst        no spanning-tree bound; with -tourcap 0 -noreduce this is exactly the algorithm of
 *                 lean/Len52/Search.lean (same node counts and output: the cross-check mode)
 *   -bfs L        state limit for the leaf reduction (default 2000)
 *   -split D      depth at which the search tree is cut into independent tasks (default 9)
 *   -part R M     do only tasks with index = R mod M (for running on several machines)
 *   -threads T    worker threads (default: hardware concurrency)
 *   -out FILE     write surviving words to FILE (default: stdout)
 *
 * build: g++ -O3 -march=native -std=c++17 -pthread -o enum enum.cpp
 */
#include <algorithm>
#include <atomic>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <mutex>
#include <string>
#include <thread>
#include <unordered_set>
#include <vector>

static const int S = 64, S2 = S * S, NS = S * S * 32;      /* search grid: 64 x 64 x 32 */
static const int OX = 32, OY = 32, OZ = 3;
static const int ORG = OX + S * OY + S2 * OZ;
static const int DELTA[6] = {1, -1, S, -S, S2, -S2};        /* e w n s u d */
static const char DC[7] = "ewnsud";
static const int MAXN = 48;

static int N = 0;
static bool PLAIN = false, AXES = true, REDUCE = true, PSI = true;
static bool NOMST = false;  /* -nomst: no spanning-tree bound in the visiting-order test (cross-check mode for the Lean search) */
static bool STAIR = false; /* -stair: outer levels behind a twice-crossed plane are monotone paths (PROOF.md Lemma 3) */
static bool PRIME = false; /* -prime: use the plane-crossing lemma (valid for prime knots only, PROOF.md Lemma 3) */
static int BRIDGE = 0;   /* -bridge B: keep only polygons with at least B local maxima along every axis */
static int BFS_LIMIT = 2000, SPLIT = 9, PART_R = 0, PART_M = 1, TOUR_CAP = 3000;
/* ---- experimental DMONs (research/exact/DMON_IDEAS.md); all OFF by default ---- */
static bool AOT = false;   /* -aot : D2, axis-ordered travel (pure bound) */
static bool GCLEAF = false; /* -gcleaf: D1 at the leaves only (generalized curtain, cyclic windows) */
static int GCTOUR = 0;      /* -gctour K: generalized-curtain obligations enter the exact tour only if they have <= K sites (default 0 = never) */
static bool PLAINDUMP = false; /* -plaindump: with -plain, list every closed polygon (that passes -gcleaf if given): test of gc_leaf_ok against check/gc_check */
static int BFSDIST = -1;    /* -bfsdist S: D3a, BFS distance through free cells when the slack is <= S (pure bound; -1 = off) */
static bool GMST = false;   /* -gmst: D3b, group spanning tree over every pending obligation (pure bound) */
static bool REJSTATS = false; /* -rejstats: count the prefixes killed by each test inside update() */
static bool GC = false;     /* -gc    : D1 on prefixes (obligations for every earlier opposite step) + leaves */
static bool AOTC = false;  /* -aotc: D2 plus the plane-crossing debt per axis (needs -prime) */

static signed char CX[NS], CY[NS], CZ[NS];
static unsigned char ALLOWED[NS];
static unsigned char DIST0[NS];

static inline int mdist(int a, int b) {
    return abs(CX[a] - CX[b]) + abs(CY[a] - CY[b]) + abs(CZ[a] - CZ[b]);
}

struct Stats {
    unsigned long long nodes = 0, closed = 0, cand = 0, surv = 0, bfs_over = 0, giveup = 0, gcdrop = 0;
    unsigned long long rej[10] = {0};   /* 0 bfsdist 1 curtain-impossible 2 gc-impossible 3 psi-impossible 4 site-unreachable (curtain/psi) 5 site-unreachable (gc) 6 aot 7 tour/mst */
    void add(const Stats &o) { nodes += o.nodes; closed += o.closed; cand += o.cand; surv += o.surv; bfs_over += o.bfs_over; giveup += o.giveup; gcdrop += o.gcdrop; for (int q = 0; q < 10; q++) rej[q] += o.rej[q]; }
};

/* ---------- leaf reduction: breadth-first search over neutral BFACF moves ---------- */
struct Reducer {
    static const int R = 64, R3 = R * R * R;
    std::vector<unsigned char> g;
    std::vector<int> queue_store;
    Reducer() : g(R3, 0) {}
    static inline int rx(int p) { return p % R; }
    static inline int ry(int p) { return (p / R) % R; }
    static inline int rz(int p) { return p / (R * R); }
    static inline bool adjacent(int a, int b) {
        int d = a > b ? a - b : b - a;
        if (d == 1) return ry(a) == ry(b) && rz(a) == rz(b);
        if (d == R) return rz(a) == rz(b);
        return d == R * R;
    }
    static inline bool interior(int p) {
        int x = rx(p), y = ry(p), z = rz(p);
        return x > 1 && y > 1 && z > 1 && x < R - 2 && y < R - 2 && z < R - 2;
    }
    static uint64_t hash(const int *v, int n) {
        uint64_t h = 1469598103934665603ULL;
        for (int i = 0; i < n; i++) { h ^= (uint64_t)v[i] + 0x9e3779b97f4a7c15ULL + (h << 6) + (h >> 2); h *= 1099511628211ULL; }
        return h;
    }
    /* 1 = a shorter polygon of the same type exists, 0 = none found, -1 = limit hit */
    int reducible(const int *v0, int n, int limit) {
        std::unordered_set<uint64_t> seen;
        std::vector<int> &q = queue_store;
        q.assign(v0, v0 + n);
        seen.insert(hash(v0, n));
        size_t head = 0;
        int cur[MAXN];
        while (head * n < q.size()) {
            memcpy(cur, &q[head * n], n * sizeof(int));
            head++;
            for (int i = 0; i < n; i++) g[cur[i]] = 1;
            for (int i = 0; i < n; i++) {
                int p = cur[(i + n - 1) % n], c = cur[i], nx = cur[(i + 1) % n];
                if (nx - c == c - p) continue;                      /* straight: no corner */
                int w = p + nx - c;
                if (g[w] || !interior(w)) continue;
                cur[i] = w;
                /* a U-turn (four consecutive vertices on a unit square) means a -2 move */
                bool red = false;
                for (int s = i - 3; s <= i && !red; s++) {
                    int a = cur[((s % n) + n) % n], b = cur[(((s + 3) % n) + n) % n];
                    if (adjacent(a, b)) red = true;
                }
                if (red) { for (int k = 0; k < n; k++) g[cur[k]] = 0; g[c] = 0; return 1; }
                uint64_t h = hash(cur, n);
                if (seen.insert(h).second) {
                    if ((int)seen.size() > limit) { cur[i] = c; for (int k = 0; k < n; k++) g[cur[k]] = 0; return -1; }
                    q.insert(q.end(), cur, cur + n);
                }
                cur[i] = c;
            }
            for (int i = 0; i < n; i++) g[cur[i]] = 0;
        }
        return 0;
    }
};

/* ---------- the search ---------- */
struct Ob { int cnt; int gc; int site[MAXN]; };   /* gc = 1: created by the generalized curtain (D1) */

struct Search {
    unsigned char occ[NS];
    unsigned char vidx[NS];     /* index of the vertex sitting on a point (valid where occ != 0) */
    int pos[MAXN + 1];
    int dirs[MAXN];
    int last[3], first[3], cnt[3];
    int rev[3];                 /* sign changes so far among the steps along each axis */
    int runm[3];                /* directions used since the last step along axis A (bit d) */
    unsigned char badl[3][64];  /* badl[A][c+32] = number of non-monotone runs inside level c of axis A */
    struct StairSave { int rm[3]; int cd[3]; int lev[3]; };
    static inline bool nonmono(int m) { return (m & (m >> 1) & 0x15) != 0; }
    inline void stair_step(int A, int d, int from, StairSave &s) {
        for (int B = 0; B < 3; B++) { s.rm[B] = runm[B]; s.cd[B] = cdef[B]; s.lev[B] = -1; }
        runm[A] = 0;
        for (int B = 0; B < 3; B++) {
            if (B == A) continue;
            int old = runm[B], nw = old | (1 << d);
            runm[B] = nw;
            if (!nonmono(old) && nonmono(nw)) {
                int c = (B == 0 ? CX[from] : B == 1 ? CY[from] : CZ[from]) + 32;
                badl[B][c]++; s.lev[B] = c; cdef[B] = owed(B);
            }
        }
    }
    inline void stair_undo(int A, const StairSave &s) {
        for (int B = 0; B < 3; B++) {
            runm[B] = s.rm[B];
            if (s.lev[B] >= 0) badl[B][s.lev[B]]--;
            if (B != A) cdef[B] = s.cd[B];
        }
    }
    int crs[3][64];             /* crs[A][p+32] = edges so far between levels p and p+1 on axis A */
    int cmn[3], cmx[3], cdef[3];/* extent so far on each axis and the crossings still owed */
    /* crossings still owed on axis A: interior planes need 4, the two outer ones 2, and every count must end even */
    int owed(int A) const {
        int t = 0;
        for (int p = cmn[A]; p < cmx[A]; p++) {
            int c = crs[A][p + 32], req = (p > cmn[A] && p < cmx[A] - 1) ? 4 : 2;
            if (STAIR && req == 2) {
                if (cmx[A] - cmn[A] == 1) { if (badl[A][cmn[A] + 32] && badl[A][cmx[A] + 32]) req = 4; }
                else if (p == cmn[A]) { if (badl[A][cmn[A] + 32]) req = 4; }
                else { if (badl[A][cmx[A] + 32]) req = 4; }
            }
            t += c >= req ? (c & 1) : req - c;
        }
        return t;
    }
    Ob obs[4 * MAXN];            /* pool; obligations created on the current path */
    int nobs = 0;
    int pend[MAXN + 1][4 * MAXN];  /* pend[i] = unsatisfied obligations after i steps */
    int npend[MAXN + 1];
    unsigned long long tour_calls, tour_giveup = 0;
    Stats st;
    Reducer red;
    std::vector<std::string> out;

    int bstamp[NS], bq[NS], bcur = 0;
    unsigned long long bfs_calls = 0, bfs_prunes = 0;
    Search() { memset(occ, 0, sizeof occ); memset(vidx, 0, sizeof vidx); memset(bstamp, 0, sizeof bstamp); }
    /* D3a.  The remaining R1 steps are a self-avoiding walk from the head to the origin through free,
       allowed points, so R1 >= the BFS distance through such points (the Manhattan distance is the same
       bound without the obstacles).  Points that cannot reach the origin within the budget are not expanded. */
    bool bfs_ok(int nx, int R1) {
        bfs_calls++;
        ++bcur;
        int qh = 0, qt = 0;
        bq[qt++] = nx; bstamp[nx] = bcur;
        int d = 0;
        while (qh < qt) {
            int layer_end = qt;
            if (d + 1 > R1) break;
            for (; qh < layer_end; qh++) {
                int c = bq[qh];
                for (int q = 0; q < 6; q++) {
                    int w = c + DELTA[q];
                    if (w == ORG) return true;                    /* d + 1 <= R1 */
                    if (occ[w] || !ALLOWED[w] || bstamp[w] == bcur) continue;
                    if (d + 1 + DIST0[w] > R1) continue;
                    bstamp[w] = bcur; bq[qt++] = w;
                }
            }
            d++;
        }
        bfs_prunes++;
        return false;
    }

    /* build the curtain obligation for the sub-path from step j to step i (i exclusive of wrap);
       returns 1 satisfied now, 0 pending (stored in ob), -1 impossible */
    int curtain(int j, int k, Ob &ob) {
        /* step j has direction a; the k perpendicular steps follow; interior vertices are
           pos[j+2 .. j+k] (indices mod N); the sites are those vertices shifted by -a */
        int back = DELTA[dirs[j] ^ 1];
        ob.cnt = 0; ob.gc = 0;
        for (int t = 2; t <= k; t++) {
            int s = pos[(j + t) % N] + back;
            if (occ[s]) return 1;
            if (ALLOWED[s]) ob.site[ob.cnt++] = s;
        }
        return ob.cnt ? 0 : -1;
    }

    /* D1 (generalized curtain).  Window: v_0 = pos[i0], v_1..v_m = pos[i0+1..i] (= Q), v_{m+1} = pos[i+1],
       step i0 along a, step i along -a (back = -a), interior steps arbitrary.  Obligation: one of the
       points v_j - a (2 <= j <= m-1) must be a vertex outside Q.  Returns 1 satisfied now (the point is
       a vertex with index <= i0), 0 pending (sites = free allowed points), -1 impossible. */
    int gcob(int i0, int i, int back, Ob &ob) {
        ob.cnt = 0; ob.gc = 1;
        for (int j = 2; j <= i - i0 - 1; j++) {
            int s = pos[i0 + j] + back;
            if (occ[s]) { if (vidx[s] <= i0) return 1; continue; }
            if (ALLOWED[s]) ob.site[ob.cnt++] = s;
        }
        return ob.cnt ? 0 : -1;
    }

    /* lower bound on a walk from `from` to the origin that visits every single-site set in pl:
       on each axis it must cover the span of those sites */
    inline int span_need(int from, const int *pl, int np) const {
        int lo[3] = {0, 0, 0}, hi[3] = {0, 0, 0};
        const int c0[3] = {CX[from], CY[from], CZ[from]};
        for (int a = 0; a < np; a++) {
            const Ob &ob = obs[pl[a]];
            if (ob.cnt != 1) continue;
            int s = ob.site[0];
            const int cs[3] = {CX[s], CY[s], CZ[s]};
            for (int q = 0; q < 3; q++) { if (cs[q] < lo[q]) lo[q] = cs[q]; if (cs[q] > hi[q]) hi[q] = cs[q]; }
        }
        int need = 0;
        for (int q = 0; q < 3; q++) {
            int l = lo[q] < c0[q] ? lo[q] : c0[q], h = hi[q] > c0[q] ? hi[q] : c0[q];
            int a1 = (c0[q] - l) + (h - l) + h;        /* to l, then h, then the origin (l <= 0 <= h) */
            int a2 = (h - c0[q]) + (h - l) + (0 - l);  /* to h, then l, then the origin */
            need += a1 < a2 ? a1 : a2;
        }
        return need;
    }
    /* is there an order of visiting one site of each pending set, then the origin, within budget?
       Manhattan distances, so "no" is a proof that the prefix is dead; gives up (returns true,
       sets gave_up) after TOUR_CAP calls.  On success without giving up, capO/capS hold the order. */
    int capO[4 * MAXN], capS[4 * MAXN], capTotal;
    bool gave_up;
    bool tour(int from, int *pl, int np, int used, int budget) {
        if (np == 0) return used + DIST0[from] <= budget;
        if (used + span_need(from, pl, np) > budget) return false;
        if (++tour_calls > (unsigned long long)TOUR_CAP) { gave_up = true; return true; }
        /* every remaining set must be reachable on its own; remember the nearest site of each */
        int key[4 * MAXN];
        for (int a = 0; a < np; a++) {
            const Ob &ob = obs[pl[a]];
            int best = 1 << 20, bestd = 1 << 20, bests = -1;
            for (int t = 0; t < ob.cnt; t++) {
                int s = ob.site[t], dd = mdist(from, s);
                if (dd + DIST0[s] < best) { best = dd + DIST0[s]; bests = s; }
                if (dd < bestd) bestd = dd;
            }
            if (used + best > budget) return false;
            if (np == 1) { capO[capTotal - 1] = pl[0]; capS[capTotal - 1] = bests; return true; }
            key[a] = bestd;
        }
        /* branch on the next set to visit, nearest first */
        bool done[4 * MAXN];
        for (int a = 0; a < np; a++) done[a] = false;
        for (int r = 0; r < np; r++) {
            int a = -1;
            for (int b = 0; b < np; b++) if (!done[b] && (a < 0 || key[b] < key[a])) a = b;
            done[a] = true;
            int o = pl[a];
            int rest[4 * MAXN], nr = 0;
            for (int b = 0; b < np; b++) if (b != a) rest[nr++] = pl[b];
            const Ob &ob = obs[o];
            for (int t = 0; t < ob.cnt; t++) {
                int s = ob.site[t];
                int c = used + mdist(from, s);
                if (c + DIST0[s] <= budget && tour(s, rest, nr, c, budget)) { capO[capTotal - np] = o; capS[capTotal - np] = s; return true; }
            }
        }
        return false;
    }
    /* witness tours: wO/wS[i][0..nwit[i]) is an order of sites, one per pending set after i steps,
       whose length was within budget; nwit[i] = -1 when none is known */
    int wO[MAXN + 1][4 * MAXN], wS[MAXN + 1][4 * MAXN], nwit[MAXN + 1];
    bool tour_ok(int i1, int nx, const int *nw, int nn, int R1) {
        int *o = wO[i1], *sv = wS[i1]; int m = 0;
        unsigned char pres[4 * MAXN];
        memset(pres, 0, nobs);
        for (int a = 0; a < nn; a++) pres[nw[a]] = 1;
        if (nwit[i1 - 1] > 0) {
            const int *po = wO[i1 - 1], *ps = wS[i1 - 1];
            for (int a = 0; a < nwit[i1 - 1]; a++) if (pres[po[a]] == 1) { o[m] = po[a]; sv[m] = ps[a]; m++; pres[po[a]] = 2; }
        }
        for (int a = 0; a < nn; a++) {
            int ob_i = nw[a];
            if (pres[ob_i] != 1) continue;
            const Ob &ob = obs[ob_i];
            int bestc = 1 << 20, bestp = 0, bests = ob.site[0];
            for (int t = 0; t < ob.cnt; t++) {
                int s = ob.site[t];
                for (int q = 0; q <= m; q++) {
                    int prev = q == 0 ? nx : sv[q - 1];
                    int c = q == m ? mdist(prev, s) + DIST0[s] - DIST0[prev]
                                   : mdist(prev, s) + mdist(s, sv[q]) - mdist(prev, sv[q]);
                    if (c < bestc) { bestc = c; bestp = q; bests = s; }
                }
            }
            for (int q = m; q > bestp; q--) { o[q] = o[q - 1]; sv[q] = sv[q - 1]; }
            o[bestp] = ob_i; sv[bestp] = bests; m++;
        }
        int cost = 0, at = nx;
        for (int q = 0; q < m; q++) { cost += mdist(at, sv[q]); at = sv[q]; }
        cost += DIST0[at];
        if (cost <= R1) { nwit[i1] = m; return true; }
        /* the cheap witness failed.  Minimum spanning tree over {head, origin, one nearest site per
           set}: with only single-site sets this is a lower bound for any walk through all of them */
        if (!NOMST) {
            if (GMST) {
                /* group MST: nodes = head, origin, and every pending obligation; the weight between two groups is
                   the least Manhattan distance between their members.  Any tour that visits one site of every group
                   gives a spanning tree on the chosen sites, whose weight is >= the group-MST weight. */
                int ng = nn + 2;
                int key[4 * MAXN + 2]; bool in[4 * MAXN + 2];
                int gd[4 * MAXN + 2][4 * MAXN + 2];
                const int *gs[4 * MAXN + 2]; int gc[4 * MAXN + 2]; int one[2][1] = {{nx}, {ORG}};
                gs[0] = one[0]; gc[0] = 1; gs[1] = one[1]; gc[1] = 1;
                for (int a = 0; a < nn; a++) { gs[a + 2] = obs[nw[a]].site; gc[a + 2] = obs[nw[a]].cnt; }
                for (int a = 0; a < ng; a++) for (int b = a + 1; b < ng; b++) {
                    int best = 1 << 20;
                    for (int x = 0; x < gc[a]; x++) for (int y = 0; y < gc[b]; y++) { int dd = mdist(gs[a][x], gs[b][y]); if (dd < best) best = dd; }
                    gd[a][b] = gd[b][a] = best;
                }
                for (int a = 0; a < ng; a++) { key[a] = gd[0][a]; in[a] = false; }
                in[0] = true; int total = 0;
                for (int r = 1; r < ng; r++) {
                    int b = -1;
                    for (int a = 0; a < ng; a++) if (!in[a] && (b < 0 || key[a] < key[b])) b = a;
                    in[b] = true; total += key[b];
                    for (int a = 0; a < ng; a++) if (!in[a] && gd[b][a] < key[a]) key[a] = gd[b][a];
                }
                if (total > R1) return false;
            }
            int pts[4 * MAXN + 2], np2 = 0; bool all_single = true;
            pts[np2++] = nx; pts[np2++] = ORG;
            for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; if (ob.cnt != 1) { all_single = false; continue; } pts[np2++] = ob.site[0]; }
            (void)all_single;
            int key[4 * MAXN + 2]; bool in[4 * MAXN + 2];
            for (int a = 0; a < np2; a++) { key[a] = mdist(pts[0], pts[a]); in[a] = false; }
            in[0] = true; int total = 0;
            for (int r = 1; r < np2; r++) {
                int b = -1;
                for (int a = 0; a < np2; a++) if (!in[a] && (b < 0 || key[a] < key[b])) b = a;
                in[b] = true; total += key[b];
                for (int a = 0; a < np2; a++) if (!in[a]) { int dd = mdist(pts[b], pts[a]); if (dd < key[a]) key[a] = dd; }
            }
            if (total > R1) return false;
        }
        /* decide exactly */
        int pl[4 * MAXN];
        memcpy(pl, nw, nn * sizeof(int));
        tour_calls = 0; gave_up = false; capTotal = nn;
        if (!tour(nx, pl, nn, 0, R1)) return false;
        if (gave_up) { tour_giveup++; nwit[i1] = m; return true; }   /* o, sv keep the insertion order as a seed for the children */
        for (int q = 0; q < nn; q++) { o[q] = capO[q]; sv[q] = capS[q]; }
        nwit[i1] = nn;
        return true;
    }
    /* a single point that must become a vertex; 1 satisfied, 0 pending (stored), -1 impossible */
    int single(int s, Ob &ob) {
        if (occ[s]) return 1;
        if (!ALLOWED[s]) return -1;
        ob.cnt = 1; ob.gc = 0; ob.site[0] = s;
        return 0;
    }
    /* D2 (axis-ordered travel).  Remaining steps along axis A are >= the per-axis travel of the
       walk head -> (one site of every single-site obligation) -> origin, and, with -aotc, >= the
       plane crossings owed on A.  Final counts are even, and ordered cz <= cy <= cx (AXES), so the
       smallest admissible total is z' + y' + x' with z' = Lz, y' = max(Ly, z'), x' = max(Lx, y'). */
    inline bool aot_ok(int nx, const int *nw, int nn) const {
        int lo[3] = {0, 0, 0}, hi[3] = {0, 0, 0};
        const int c0[3] = {CX[nx], CY[nx], CZ[nx]};
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]];
            if (ob.cnt != 1) continue;
            int s = ob.site[0];
            const int cs[3] = {CX[s], CY[s], CZ[s]};
            for (int q = 0; q < 3; q++) { if (cs[q] < lo[q]) lo[q] = cs[q]; if (cs[q] > hi[q]) hi[q] = cs[q]; }
        }
        int L[3];
        for (int q = 0; q < 3; q++) {
            int l = lo[q] < c0[q] ? lo[q] : c0[q], h = hi[q] > c0[q] ? hi[q] : c0[q];
            int a1 = (c0[q] - l) + (h - l) + h, a2 = (h - c0[q]) + (h - l) + (0 - l);
            int t = a1 < a2 ? a1 : a2;
            if (AOTC && cdef[q] > t) t = cdef[q];
            int f = cnt[q] + t;
            L[q] = (f + 1) & ~1;
        }
        int z = L[2], y = L[1] > z ? L[1] : z, x = L[0] > y ? L[0] : y;
        return x + y + z <= N;
    }
    /* obligations created by step i (direction d, from pos[i] to nx); occ[nx] is already set.
       Fills pend[i+1]; returns false if the prefix is dead. */
    bool update(int i, int d, int nx, int sl, int R1) {
        if (BFSDIST >= 0 && R1 - (int)DIST0[nx] <= BFSDIST && R1 > 0 && !bfs_ok(nx, R1)) { st.rej[0]++; return false; }
        const int *old = pend[i]; int no = npend[i];
        int *nw = pend[i + 1]; int nn = 0;
        for (int a = 0; a < no; a++) {
            const Ob &ob = obs[old[a]];
            bool sat = false;
            for (int t = 0; t < ob.cnt; t++) if (ob.site[t] == nx) { sat = true; break; }
            if (!sat) nw[nn++] = old[a];
        }
        if (sl >= 0 && dirs[sl] == (d ^ 1)) {
            int r = curtain(sl, i - sl - 1, obs[nobs]);
            if (r == -1) { st.rej[1]++; return false; }
            if (r == 0) nw[nn++] = nobs++;
        }
        if (GC) {
            const int back = DELTA[d];                    /* step i is along -a, so back = -a */
            for (int i0 = i - 2; i0 >= 0; i0--) {
                if (dirs[i0] != (d ^ 1) || i0 == sl) continue;   /* i0 == sl: the ordinary curtain, built above */
                if (nobs >= 4 * MAXN - 2) break;               /* pool full: drop (never wrong, only weaker) */
                int r = gcob(i0, i, back, obs[nobs]);
                if (r == -1) { st.rej[2]++; return false; }
                if (r == 0) nw[nn++] = nobs++;
            }
        }
        if (PSI && i >= 1) {
            int p = dirs[i - 1], s = -1;
            if (p == 4 && d < 4) s = pos[i - 1] + DELTA[d];            /* (u,h) */
            else if (d == 5 && p < 4) s = nx - DELTA[p];               /* (h,d) */
            else if (p == 2 && d < 2) s = pos[i - 1] + DELTA[d];       /* (n,x) */
            else if (d == 3 && p < 2) s = nx - DELTA[p];               /* (x,s) */
            if (s >= 0) {
                int r = single(s, obs[nobs]);
                if (r == -1) { st.rej[3]++; return false; }
                if (r == 0) nw[nn++] = nobs++;
            }
        }
        npend[i + 1] = nn;
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]];
            bool fine = false;
            for (int t = 0; t < ob.cnt && !fine; t++) {
                int s = ob.site[t];
                if (mdist(nx, s) + DIST0[s] > R1) continue;
                /* the walk must enter and leave s: two neighbours that are free, the head, or the origin */
                int av = 0;
                for (int q = 0; q < 6; q++) { int w = s + DELTA[q]; av += (w == nx || w == ORG || (!occ[w] && ALLOWED[w])); }
                fine = av >= 2;
            }
            if (!fine) { st.rej[ob.gc ? 5 : 4]++; return false; }
        }
        if ((AOT || AOTC) && AXES && !aot_ok(nx, nw, nn)) { st.rej[6]++; return false; }
        nwit[i + 1] = 0;
        if (GC) {
            int nt[4 * MAXN], k = 0;
            for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; if (!ob.gc || ob.cnt <= GCTOUR) nt[k++] = nw[a]; }
            if (k >= 2 && !tour_ok(i + 1, nx, nt, k, R1)) { st.rej[7]++; return false; }
        } else
        if (nn >= 2 && !tour_ok(i + 1, nx, nw, nn, R1)) { st.rej[7]++; return false; }
        return true;
    }
    /* plane counters for a step in direction d from a vertex with coordinate c on axis A */
    inline void plane_step(int A, int d, int from, int &smn, int &smx, int &sdef, int &pl) {
        int c = (A == 0 ? CX[from] : A == 1 ? CY[from] : CZ[from]);
        int c2 = c + ((d & 1) ? -1 : 1);
        pl = (c < c2 ? c : c2) + 32;
        smn = cmn[A]; smx = cmx[A]; sdef = cdef[A];
        crs[A][pl]++;
        if (c2 < cmn[A]) cmn[A] = c2;
        if (c2 > cmx[A]) cmx[A] = c2;
        cdef[A] = owed(A);
    }
    inline void plane_undo(int A, int smn, int smx, int sdef, int pl) { crs[A][pl]--; cmn[A] = smn; cmx[A] = smx; cdef[A] = sdef; }
    /* D1 at a closed polygon: every cyclic window (i0, m) with step i0 along a and step i0+m along -a. */
    bool gc_leaf_ok() const {
        for (int i0 = 0; i0 < N; i0++) {
            const int back = DELTA[dirs[i0] ^ 1];
            for (int m = 2; m <= N - 2; m++) {
                if (dirs[(i0 + m) % N] != (dirs[i0] ^ 1)) continue;
                bool found = false;
                for (int j = 2; j <= m - 1 && !found; j++) {
                    int s = pos[(i0 + j) % N] + back;
                    if (!occ[s]) continue;
                    int k = ((int)vidx[s] - i0 + N) % N;
                    if (k < 1 || k > m) found = true;           /* a vertex outside Q */
                }
                if (!found) return false;
            }
        }
        return true;
    }
    void leaf() {
        st.closed++;
        if (!PLAIN) {
            /* cyclic U-turns across the root */
            if (dirs[0] == (dirs[N - 2] ^ 1) || dirs[1] == (dirs[N - 1] ^ 1)) return;
            /* nothing may be left pending */
            if (npend[N]) return;
            /* curtains that pass through the root */
            for (int A = 0; A < 3; A++) {
                if (first[A] < 0) continue;
                int jl = last[A], jf = first[A];
                if (dirs[jl] != (dirs[jf] ^ 1)) continue;
                int k = (N - jl - 1) + jf;
                Ob ob;
                if (curtain(jl, k, ob) != 1) return;
            }
        }
        if ((GC || GCLEAF) && !gc_leaf_ok()) { st.gcdrop++; return; }
        if (AXES && !(cnt[2] <= cnt[1] && cnt[1] <= cnt[0])) return;
        if (BRIDGE) {
            for (int A = 0; A < 3; A++) {
                if (first[A] < 0) return;
                int cyc = rev[A] + (dirs[last[A]] != dirs[first[A]]);
                if (cyc < 2 * BRIDGE) return;
            }
        }
        st.cand++;
        if (!PLAIN && REDUCE) {
            int v[MAXN];
            const int shift = (32 - OZ) * S2;          /* same x,y; z moved to the middle of the 64^3 grid */
            for (int i = 0; i < N; i++) v[i] = pos[i] + shift;
            int r = red.reducible(v, N, BFS_LIMIT);
            if (r == 1) return;
            if (r == -1) st.bfs_over++;
        }
        st.surv++;
        if (!PLAIN || PLAINDUMP) {
            std::string w(N, ' ');
            for (int i = 0; i < N; i++) w[i] = DC[dirs[i]];
            out.push_back(w);
        }
    }

    void dfs(int i) {
        int cur = pos[i], R = N - i;
        int p1 = dirs[i - 1] ^ 1, p2 = i >= 2 ? (dirs[i - 2] ^ 1) : -1;
        for (int d = 0; d < 6; d++) {
            if (d == p1) continue;
            if (!PLAIN && d == p2) continue;
            int nx = cur + DELTA[d];
            int A = d >> 1;
            if (R == 1) {
                if (nx != ORG) continue;
                if ((d ^ 1) <= dirs[0]) continue;               /* direction rule */
                st.nodes++;
                int sl = last[A], sf = first[A];
                int isrev = (sl >= 0 && dirs[sl] == (d ^ 1));
                dirs[i] = d; pos[i + 1] = nx; cnt[A]++; last[A] = i; if (sf < 0) first[A] = i; rev[A] += isrev;
                int save = nobs; bool ok = true;
                int smn = 0, smx = 0, sdef = 0, pl = 0;
                if (PRIME) { plane_step(A, d, cur, smn, smx, sdef, pl); if (cdef[0] + cdef[1] + cdef[2] > 0) ok = false; }
                if (ok && !PLAIN) ok = update(i, d, nx, sl, 0);
                if (ok) leaf();
                if (PRIME) plane_undo(A, smn, smx, sdef, pl);
                nobs = save; cnt[A]--; last[A] = sl; first[A] = sf; rev[A] -= isrev;
                continue;
            }
            if (occ[nx] || !ALLOWED[nx] || DIST0[nx] > R - 1) continue;
            if (AXES) {
                int cx = cnt[0], cy = cnt[1], cz = cnt[2];
                if (A == 0) cx++; else if (A == 1) cy++; else cz++;
                int m = cy > cz ? cy : cz;
                if (2 * m + cz > N) continue;
                if (cz > cy + (R - 1) || cy > cx + (R - 1)) continue;
            }
            int isrev = (last[A] >= 0 && dirs[last[A]] == (d ^ 1));
            if (BRIDGE) {
                /* cyclic sign changes on an axis <= changes so far + future steps on it + 1 */
                int need = 0;
                for (int q = 0; q < 3; q++) { int m = 2 * BRIDGE - 1 - rev[q] - (q == A ? isrev : 0); if (m > 0) need += m; }
                if (need > R - 1) continue;
            }
            int smn = 0, smx = 0, sdef = 0, pl = 0; StairSave ss;
            if (PRIME) {
                plane_step(A, d, cur, smn, smx, sdef, pl);
                if (STAIR) stair_step(A, d, cur, ss);
                if (cdef[0] + cdef[1] + cdef[2] > R - 1) { if (STAIR) stair_undo(A, ss); plane_undo(A, smn, smx, sdef, pl); continue; }
            }
            st.nodes++;
            int sl = last[A], sf = first[A], save = nobs;
            dirs[i] = d; pos[i + 1] = nx; occ[nx] = 1; vidx[nx] = (unsigned char)(i + 1); cnt[A]++; last[A] = i; if (sf < 0) first[A] = i; rev[A] += isrev;
            bool ok = true;
            if (!PLAIN) ok = update(i, d, nx, sl, R - 1);
            if (ok) {
                if (i + 1 == split_depth) task(i + 1); else dfs(i + 1);
            }
            occ[nx] = 0; nobs = save; cnt[A]--; last[A] = sl; first[A] = sf; rev[A] -= isrev;
            if (PRIME && STAIR) stair_undo(A, ss);
            if (PRIME) plane_undo(A, smn, smx, sdef, pl);
        }
    }

    /* task splitting */
    int split_depth = -1;
    long long task_counter = 0;
    std::vector<std::vector<int>> *collect = nullptr;
    void task(int depth) {
        if (collect) { collect->emplace_back(dirs, dirs + depth); return; }
        dfs(depth);
    }
    void start() {
        memset(occ, 0, sizeof occ);
        nobs = 0; npend[0] = 0; npend[1] = 0; nwit[0] = 0; nwit[1] = 0;
        for (int A = 0; A < 3; A++) last[A] = first[A] = -1, cnt[A] = 0, rev[A] = 0, cmn[A] = cmx[A] = 0, cdef[A] = 0;
        memset(crs, 0, sizeof crs); memset(badl, 0, sizeof badl); runm[0] = runm[1] = runm[2] = 0;
        pos[0] = ORG; occ[ORG] = 1; vidx[ORG] = 0;
    }
    /* replay a prefix, then search below it */
    void run_prefix(const std::vector<int> &pre) {
        start();
        split_depth = -1;
        int L = (int)pre.size();
        for (int i = 0; i < L; i++) {
            int d = pre[i], A = d >> 1, nx = pos[i] + DELTA[d];
            int sl = last[A];
            rev[A] += (sl >= 0 && dirs[sl] == (d ^ 1));
            if (PRIME) { int a1, a2, a3, a4; plane_step(A, d, pos[i], a1, a2, a3, a4); if (STAIR) { StairSave ss; stair_step(A, d, pos[i], ss); } }
            dirs[i] = d; pos[i + 1] = nx; occ[nx] = 1; vidx[nx] = (unsigned char)(i + 1); cnt[A]++; last[A] = i; if (first[A] < 0) first[A] = i;
            if (!PLAIN) update(i, d, nx, sl, N - i - 1); else npend[i + 1] = 0;
        }
        dfs(L);
    }
    void collect_prefixes(int depth, std::vector<std::vector<int>> &v) {
        start();
        split_depth = depth; collect = &v;
        /* first step: e or n (u can never be smaller than the reverse of the last step) */
        for (int d = 0; d < 6; d++) {
            int nx = ORG + DELTA[d];
            if (!ALLOWED[nx]) continue;
            if (d == 4) continue;      /* the direction rule needs first step < reverse of last step, so never u */
            int A = d >> 1;
            dirs[0] = d; pos[1] = nx; occ[nx] = 1; vidx[nx] = 1; cnt[A] = 1; last[A] = first[A] = 0;
            int smn = 0, smx = 0, sdef = 0, pl = 0;
            StairSave ss;
            if (PRIME) plane_step(A, d, ORG, smn, smx, sdef, pl);
            if (PRIME && STAIR) stair_step(A, d, ORG, ss);
            st.nodes++;
            if (depth == 1) task(1); else dfs(1);
            if (PRIME && STAIR) stair_undo(A, ss);
            if (PRIME) plane_undo(A, smn, smx, sdef, pl);
            occ[nx] = 0; cnt[A] = 0; last[A] = first[A] = -1;
        }
        collect = nullptr; split_depth = -1;
    }
};

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: enum N [options]\n"); return 1; }
    N = atoi(argv[1]);
    int threads = (int)std::thread::hardware_concurrency();
    const char *outfile = nullptr;
    for (int i = 2; i < argc; i++) {
        std::string a = argv[i];
        if (a == "-plain") PLAIN = true;
        else if (a == "-noaxes") AXES = false;
        else if (a == "-noreduce") REDUCE = false;
        else if (a == "-nopsi") PSI = false;
        else if (a == "-bridge") BRIDGE = atoi(argv[++i]);
        else if (a == "-prime") PRIME = true;
        else if (a == "-nomst") NOMST = true;
        else if (a == "-aot") AOT = true;
        else if (a == "-gcleaf") GCLEAF = true;
        else if (a == "-gc") GC = true;
        else if (a == "-rejstats") REJSTATS = true;
        else if (a == "-bfsdist") BFSDIST = atoi(argv[++i]);
        else if (a == "-gmst") GMST = true;
        else if (a == "-plaindump") PLAINDUMP = true;
        else if (a == "-gctour") GCTOUR = atoi(argv[++i]);
        else if (a == "-aotc") AOTC = true;
        else if (a == "-stair") STAIR = PRIME = true;
        else if (a == "-bfs") BFS_LIMIT = atoi(argv[++i]);
        else if (a == "-tourcap") TOUR_CAP = atoi(argv[++i]);
        else if (a == "-split") SPLIT = atoi(argv[++i]);
        else if (a == "-part") { PART_R = atoi(argv[++i]); PART_M = atoi(argv[++i]); }
        else if (a == "-threads") threads = atoi(argv[++i]);
        else if (a == "-out") outfile = argv[++i];
        else { fprintf(stderr, "unknown option %s\n", a.c_str()); return 1; }
    }
    if (N < 4 || N > 40 || (N & 1)) { fprintf(stderr, "N must be even, 4..40\n"); return 1; }
    if (SPLIT > N - 2) SPLIT = N - 2;
    if (SPLIT < 1) SPLIT = 1;

    for (int p = 0; p < NS; p++) {
        int x = p % S - OX, y = (p / S) % S - OY, z = p / S2 - OZ;
        CX[p] = (signed char)x; CY[p] = (signed char)y; CZ[p] = (signed char)z;
        int d = abs(x) + abs(y) + abs(z);
        DIST0[p] = (unsigned char)(d > 255 ? 255 : d);
        bool lexgt = z > 0 || (z == 0 && (y > 0 || (y == 0 && x > 0)));
        bool inbox = abs(x) <= 24 && abs(y) <= 24 && z <= 24;
        ALLOWED[p] = lexgt && inbox;
    }

    std::vector<std::vector<int>> tasks;
    Stats total;
    {
        Search *s0 = new Search();
        s0->collect_prefixes(SPLIT, tasks);
        total.add(s0->st);
        delete s0;
    }
    std::atomic<size_t> next(0);
    std::mutex mu;
    std::vector<std::string> words;
    auto worker = [&]() {
        Search *s = new Search();
        for (;;) {
            size_t t = next++;
            if (t >= tasks.size()) break;
            if ((long long)(t % PART_M) != PART_R) continue;
            s->run_prefix(tasks[t]);
        }
        std::lock_guard<std::mutex> lk(mu);
        s->st.giveup = s->tour_giveup;
        total.add(s->st);
        words.insert(words.end(), s->out.begin(), s->out.end());
        delete s;
    };
    std::vector<std::thread> pool;
    for (int i = 0; i < threads; i++) pool.emplace_back(worker);
    for (auto &th : pool) th.join();

    std::sort(words.begin(), words.end());
    FILE *fo = outfile ? fopen(outfile, "w") : stdout;
    for (auto &w : words) fprintf(fo, "%s\n", w.c_str());
    if (outfile) fclose(fo);
    fprintf(stderr, "N=%d tasks=%zu part=%d/%d nodes=%llu closed=%llu candidates=%llu survivors=%llu bfs_limit_hits=%llu tour_giveups=%llu",
            N, tasks.size(), PART_R, PART_M, total.nodes, total.closed, total.cand, total.surv, total.bfs_over, total.giveup);
    if (GC || GCLEAF) fprintf(stderr, " gc_leaf_drops=%llu", total.gcdrop);
    fprintf(stderr, "\n");
    if (REJSTATS) fprintf(stderr, "rejections: bfsdist=%llu curtain=%llu gc_no_site=%llu psi_no_site=%llu unreachable_site(curtain,psi)=%llu unreachable_site(gc)=%llu aot=%llu tour_mst=%llu\n",
                          total.rej[0], total.rej[1], total.rej[2], total.rej[3], total.rej[4], total.rej[5], total.rej[6], total.rej[7]);
    return 0;
}
