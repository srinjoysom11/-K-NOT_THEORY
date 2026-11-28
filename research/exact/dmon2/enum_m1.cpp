/* enum_v.cpp: enum_w.cpp + the GW3 walk bound of enum_g.cpp.  New flags: -walk LO HI (for LO <= R1 <= HI missing steps,
 * after the tour test: reject the node if no walk of <= R1 steps from the head end to the tail end through free allowed
 * cells, obeying the no-reversal / no-U-turn letter rules also at both junctions, visits a site of each of the (at most 6,
 * fewest-site) pending obligations; the ray obligation of -tau counts as an ordinary obligation), and its tuning
 * parameters -gwlim S (state limit, default 100000), -gwgap G, -gw3let L, -gw3h 0|1 (Held-Karp-like bound, on with -walk
 * when given after it).  stderr: "walk calls/with_ray/dead/sitefull/sitefull_by_ray/limit/limit_with_ray/skip/states".
 * enum_w.cpp: enum_z.cpp + the tau rule of enum_i.cpp.  enum_z.cpp: merge of enum_y.cpp (adaptive end choice) with two independent optimisations: version A (per-node engineering,
 * identical test results) and version D (new tour-bound options).  Flags added to enum_y.cpp:
 *   A: -adapt 6 (fixed: a child that passed the full probe is re-run without re-testing, its probe witness tour restored),
 *      -adapt 7 / -adapt 8 (experimental probe schedules with inherited candidate masks), -adaptmaxr R (no probes above R
 *      missing steps), -aflags F (bit options of -adapt 7/8), -qb Q (-adapt 8: probe the other end only if it has <= Q
 *      candidates); stderr reports fulltests= (number of full update2 test runs).
 *   D: -mstonly (tour test = spanning tree over head end, tail end and single sites only, with early exit; no insertion or
 *      tour() search), -hk K (Held-Karp exact path over the single sites when there are at most K), -hkw (with -mstonly:
 *      first a witness from the parent's order plus cheapest insertion, then the MST, before Held-Karp), -ax1d (exact per-axis
 *      1-D travel bound over the choice of one site per multi-site obligation, used in -aot and in the tour span bound),
 *      -joint K / -jcap C / -jonly / -jmin M (joint order bound with plane-crossing counts for <= K pending obligations,
 *      C calls cap, -jonly: no tour() search after a joint give-up, M: least pending count for the tour test),
 *      -oracle C (re-run given-up tours with cap C and count the outcome), -tstat (tour test statistics).
 *   I (tau rule, from enum_i.cpp): -tau 1 (x -> -x symmetry breaking: once the prefix shows w(P) > w(tau P), a ray
 *      obligation asks for a later vertex on the ray x > k, y = z = 0, else P is pruned; the finished word is cut exactly),
 *      -tau 2 (UNSOUND diagnostic oracle: prune every P with w(P) > w(tau P), ignoring the ray condition),
 *      -tauz 0|1 (default 1: with -stair the ray obligation forces 4 crossings of z = 1/2), -tauax 0|1 (default 1: the ray
 *      counts as a single site in y and z in the travel bounds), -tauord 0|1 (comparison order of the letter pairs),
 *      -cycleaf (apply -face/-plane4/-crank cyclically to the finished polygon).  Note -tauz and -tauax take a value.
 * Engineering from A (same tests, same node counts): one-pass three-axis travel bound need3() with per-obligation
 * coordinate bitmasks (coordinates must lie in -32..31), span bound cached from aot_ok for the first tour() call,
 * insertion distances computed once, one-loop plane_route_need, early-exit reach test, occ cleared once per Search
 * (every step is undone).  Under -ax1d the bitmask path computes D's exact 1-D bound, so the cache stays exact.
 * The ray obligation gets its coordinate bitmasks (ob_masks) and is treated by need3() exactly as by axis_need under -tauax.
 */
/* enum_y.cpp: enum_x.cpp + adaptive end choice (fail-first). -adapt 1: per node, extend the end with fewer letters passing the cheap filters (sound: any rule that depends only on the current two-ended prefix visits every word once). -adapt 3: same with full tests on both ends (also prunes when either end has no legal letter). -adapt 4/5/6: experimental. PROTOTYPE. */
/*
 * enum_bidir.cpp -- E9: the same exhaustive normal-form search as enum.cpp (with -prime / -stair as in enum.cpp; no -bridge),
 * but the polygon is built from BOTH ends of the root.
 *
 * The polygon is v_0 = root, v_1, ..., v_n = v_0 with word w_0 ... w_{n-1}.  The search grows a "head" forward from the
 * root (steps w_0, w_1, ...) and a "tail" backward from the root (steps w_{n-1}, w_{n-2}, ...), alternately, for the
 * first ALT steps (head, tail, head, tail, ...), then the head only.  What is left in the middle is a walk of
 * R = n - (#head + #tail) steps from the head end to the tail end.  Every polygon (word) is visited exactly once
 * (the word fixes the head and tail parts for a fixed schedule).  With -alt 0 the tail never moves: the single-ended search.
 *
 * Tests on a prefix (all of them only prune; every one is implied by DMON1-DMON7 for the polygon being built):
 *   self-avoidance, DMON3 (all vertices lexicographically above the root), no U-turn, DMON4 as soon as both first steps exist,
 *   DMON5 (axis counts), DMON6 (curtain obligations, for windows that end at the new head step or start at the new tail step),
 *   DMON7 (corner obligations at every vertex except the root, as soon as both neighbours exist),
 *   reach and "two free neighbours" for every pending obligation, the axis-ordered travel test (-aot, -aotm),
 *   the tour / spanning tree tests, all with the head end and the tail end as the two end points of the missing middle walk.
 * At a closed polygon the complete cyclic tests (U-turns, every curtain window including those through the join and
 * through the root, every corner, DMON4, DMON5) are applied again from the finished word, and the flip search of enum.cpp.
 * So the output is the same set of words as enum's, whatever the pruning does, as long as the prefix tests are sound.
 *
 * usage: enum_bidir N [-alt K] [-prime|-stair] [-aot] [-aotc] [-aotm] [-tourcap C] [-nomst] [-noreduce] [-nopsi] [-split D] [-part R M] [-threads T] [-out FILE] [-rejstats]
 * build: g++ -O3 -march=native -std=c++17 -pthread -o enum_bidir enum_bidir.cpp
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

static const int S = 64, S2 = S * S, NS = S * S * 32;
static const int OX = 32, OY = 32, OZ = 3;
static const int ORG = OX + S * OY + S2 * OZ;
static const int DELTA[6] = {1, -1, S, -S, S2, -S2};        /* e w n s u d */
static const char DC[7] = "ewnsud";
static const int MAXN = 56;

static int SLAB = -1;     /* -slab L: only points with 0 <= z <= L, axis rule only y-steps <= x-steps (as slab.cpp, PROOF_SLAB.md) */
static int N = 0, ALT = 12, SPLIT = 9, PART_R = 0, PART_M = 1, TOUR_CAP = 3, BFS_LIMIT = 2000;
static bool AXES = true, REDUCE = true, PSI = true, NOMST = false, AOT = false, AOTM = false, REJSTATS = false;
static bool FACE = false, PLANE4 = false, AOTP = false, CRANK = false; static int STIFFX = 1000; static bool BALZ = false; static int ADAPT = 0, ADAPT_MINR = 0, ADAPT_MAXR = 1000, AFLAGS = 7, QB = 6; static thread_local bool LIGHT = false;
static int ORACLE = 0; static bool TSTAT = false; static bool AX1D = false; static int JK = 0, JCAP = 50, JMIN = 2; static bool JONLY = false, MSTONLY = false; static int HKK = 0; static bool HKW = false;
static bool CYCLEAF = false;   /* -cycleaf: apply -face/-plane4/-crank to the finished polygon cyclically (also through the closing letter) */
static int TAUORD = 0; static std::vector<int> TORD[MAXN];   /* order of the pairs j (k >= 1): 0 = j ascending; 1 = j = 0, 1, then by max(k+j, N-1-j) */
static bool WALK = false; static int WALK_LO = 0, WALK_HI = -1, GWGAP = 99, GW3LET = 99; static unsigned long long GWLIM = 100000; static bool W3HDP = false;   /* -walk LO HI: GW3 walk bound for LO <= R1 <= HI */
static int TAU = 0; static bool TAUZ = true, TAUAX = true;   /* -tau 1: x->-x symmetry breaking with ray obligation; -tau 2: UNSOUND oracle (ignores rho) */
static bool PRIME = false, STAIR = false, AOTC = false;   /* -prime / -stair: plane-crossing lemma (prime knots, PROOF.md Lemma 3); -aotc: per-axis plane debt in -aot */

static signed char CX[NS], CY[NS], CZ[NS];
static unsigned long long G_NODES[80], G_USEFUL[80];
static unsigned long long A_BAND=0, A_PLAINDEAD=0, A_NOSINGLE=0, A_SINGLE=0, A_PAIRS_LOC=0, A_PAIRS_ALIVE=0, A_ALLDEAD=0, A_GIVEUP=0, A_ANCHOR_NOPAIR=0, A_BYR[80][4]; static bool ANCHOR_PROBE=false; static unsigned long long A_VIOL=0, A_VIOL1=0;
static unsigned char ALLOWED[NS];

static inline int mdist(int a, int b) { return abs(CX[a] - CX[b]) + abs(CY[a] - CY[b]) + abs(CZ[a] - CZ[b]); }

struct Stats {
    unsigned long long ntest = 0, nodes = 0, closed = 0, cand = 0, surv = 0, bfs_over = 0, giveup = 0, taudec = 0, tauob = 0, tauleaf = 0;
    unsigned long long w3calls = 0, w3dead = 0, w3full = 0, w3fullray = 0, w3over = 0, w3overray = 0, w3skip = 0, w3states = 0, w3ray = 0;
    unsigned long long rej[4][MAXN + 1]; unsigned long long dep[MAXN + 1]; unsigned long long slk[MAXN + 1][MAXN + 1];   /* 0 no site (curtain/corner) 1 site unreachable 2 aot 3 tour/mst, by remaining steps */
    Stats() { memset(rej, 0, sizeof rej); memset(dep, 0, sizeof dep); memset(slk, 0, sizeof slk); }
    void add(const Stats &o) { ntest += o.ntest; nodes += o.nodes; taudec += o.taudec; tauob += o.tauob; tauleaf += o.tauleaf; w3calls += o.w3calls; w3dead += o.w3dead; w3full += o.w3full; w3fullray += o.w3fullray; w3over += o.w3over; w3overray += o.w3overray; w3skip += o.w3skip; w3states += o.w3states; w3ray += o.w3ray; closed += o.closed; cand += o.cand; surv += o.surv; bfs_over += o.bfs_over; giveup += o.giveup;
        for (int q = 0; q < 4; q++) for (int r = 0; r <= MAXN; r++) rej[q][r] += o.rej[q][r]; for (int r = 0; r <= MAXN; r++) { dep[r] += o.dep[r]; for (int q = 0; q <= MAXN; q++) slk[r][q] += o.slk[r][q]; } }
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
struct Ob { int cnt; signed char c1[4]; uint64_t cm[3]; int site[MAXN]; };   /* c1: coordinates of site[0]; cm[q]: bit c+32 set iff some site has q-coordinate c */
static inline void ob_masks(Ob &ob) {
    ob.cm[0] = ob.cm[1] = ob.cm[2] = 0;
    ob.c1[0] = CX[ob.site[0]]; ob.c1[1] = CY[ob.site[0]]; ob.c1[2] = CZ[ob.site[0]];
    for (int u = 0; u < ob.cnt; u++) { const int s = ob.site[u]; ob.cm[0] |= 1ull << (CX[s] + 32); ob.cm[1] |= 1ull << (CY[s] + 32); ob.cm[2] |= 1ull << (CZ[s] + 32); }
}

struct Search {
    static const int OFS = MAXN + 4;
    unsigned char occ[NS];
    int Pb[2 * MAXN + 10], Lb[2 * MAXN + 10];
    int H = 0, T = 0;                 /* head steps, tail steps */
    int cnt[3];
    int fa[3], la[3];                 /* leftmost / rightmost letter index on each axis (NONE if none) */
    static const int NONE = 1 << 20;
    inline int &P(int k) { return Pb[OFS + k]; }       /* vertex k, -T <= k <= H */
    inline int &Lt(int k) { return Lb[OFS + k]; }      /* letter k from vertex k to k+1, -T <= k < H */
    Ob obs[4 * MAXN]; int nobs = 0;
    int pend[MAXN + 2][4 * MAXN], npend[MAXN + 2];
    int wO[MAXN + 2][4 * MAXN], wS[MAXN + 2][4 * MAXN], nwit[MAXN + 2];
    unsigned long long tour_calls = 0, tour_giveup = 0; unsigned long long tcap = 3;
    unsigned long long ts_ins=0, ts_mst=0, ts_ok=0, ts_fail=0, ts_gu=0, or_fail=0, or_ok=0, or_unk=0, gu_nn[64]={0}, gu_multi[64]={0}, gu_fail_nn[64]={0}, tr_nn[64]={0};
    Stats st;
    Reducer red;
    std::vector<std::string> out;
    int Hd = 0, Tl = 0;               /* the two end points of the missing middle walk */
    int tst[MAXN + 2]; int zr4 = 0, rayidx = -1, tk = 0;   /* tau state by depth (-1 undecided), z=1/2 needs 4 crossings, index of the ray obligation */
    /* plane-crossing lemma (order independent) and the stair rule (one stretch state per side) */
    int crs[3][64];
    int cmn[3], cmx[3], cdef[3];
    int nlo[3], nhi[3];
    int sumz = 0;
    unsigned char badl[3][64];
    int runm[2][3];
    struct StairSave { int rm[3]; int cd[3]; int lev[3]; };
    static inline bool nonmono(int m) { return (m & (m >> 1) & 0x15) != 0; }
    int owed(int A) const {
        int t = 0, mn = cmn[A] < nlo[A] ? cmn[A] : nlo[A], mx = cmx[A] > nhi[A] ? cmx[A] : nhi[A];
        for (int p = mn; p < mx; p++) {
            int c = crs[A][p + 32], req = (p > mn && p < mx - 1) ? 4 : 2;
            if (STAIR && req == 2) {
                if (mx - mn == 1) { if (badl[A][mn + 32] && badl[A][mx + 32]) req = 4; }
                else if (p == mn) { if (badl[A][mn + 32]) req = 4; }
                else { if (badl[A][mx + 32]) req = 4; }
            }
            if (A == 2 && zr4 && p == 0) req = 4;
            t += c >= req ? (c & 1) : req - c;
        }
        return t;
    }
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
    inline void stair_step(int sd, int A, int d, int from, StairSave &sv) {
        int *rm = runm[sd];
        for (int B = 0; B < 3; B++) { sv.rm[B] = rm[B]; sv.cd[B] = cdef[B]; sv.lev[B] = -1; }
        rm[A] = 0;
        for (int B = 0; B < 3; B++) {
            if (B == A) continue;
            int old = rm[B], nw = old | (1 << d);
            rm[B] = nw;
            if (!nonmono(old) && nonmono(nw)) {
                int c = (B == 0 ? CX[from] : B == 1 ? CY[from] : CZ[from]) + 32;
                badl[B][c]++; sv.lev[B] = c; cdef[B] = owed(B);
            }
        }
    }
    inline void stair_undo(int sd, int A, const StairSave &sv) {
        int *rm = runm[sd];
        for (int B = 0; B < 3; B++) {
            rm[B] = sv.rm[B];
            if (sv.lev[B] >= 0) badl[B][sv.lev[B]]--;
            if (B != A) cdef[B] = sv.cd[B];
        }
    }


    static inline int coord(int A, int p) { return A == 0 ? CX[p] : A == 1 ? CY[p] : CZ[p]; }
    /* new vertex at index kn (head: kn = H, walk back; tail: kn = -T, walk forward). For each axis A, the
       maximal run of consecutive placed vertices ending at kn with the same A-coordinate lies in the plane
       A = c. If a sub-arc of that run has excess >= 4: z = root level -> kill (returns false);
       otherwise (PLANE4) the polygon must reach A <= c-1 and A >= c+1. */
    bool face_check(int kn, int dir, int sv_lo[3], int sv_hi[3], bool &changed) {
        int nx = P(kn); changed = false;
        for (int A = 0; A < 3; A++) {
            int c = coord(A, nx); int L = 0; bool ex = false;
            for (int k = kn - dir; k >= -T && k <= H; k -= dir) {
                int q = P(k);
                if (coord(A, q) != c) break;
                L++;
                if (L - mdist(q, nx) >= 4) { ex = true; break; }
            }
            if (!ex) continue;
            if (A == 2 && c == CZ[ORG]) return false;
            if (PLANE4) {
                if (c - 1 < nlo[A]) { nlo[A] = c - 1; changed = true; }
                if (c + 1 > nhi[A]) { nhi[A] = c + 1; changed = true; }
            }
        }
        return true;
    }

    bool occ_clean = false;
    Search() { memset(occ, 0, sizeof occ); }

    int curtain2(int j, int i, int back, Ob &ob) {
        ob.cnt = 0;
        for (int k = j + 2; k <= i - 1; k++) {
            int s = P(k) + back;
            if (occ[s]) return 1;
            if (ALLOWED[s]) ob.site[ob.cnt++] = s;
        }
        if (ob.cnt) ob_masks(ob);
        return ob.cnt ? 0 : -1;
    }

    /* crank row obligation: sites base + c, base + b + c, ..., base + k b + c */
    int crank_row(int base, int b, int k, int c, Ob &ob) {
        ob.cnt = 0;
        for (int t = 0; t <= k; t++) {
            int s = base + t * DELTA[b] + DELTA[c];
            if (occ[s]) return 1;
            if (ALLOWED[s]) ob.site[ob.cnt++] = s;
        }
        if (ob.cnt) ob_masks(ob);
        return ob.cnt ? 0 : -1;
    }

    /* EXPERIMENT (unsound): shortest completion from the head end to the tail end in which every
       DMON7 pattern corner is supported by an already placed vertex (no self-support). */
    std::vector<unsigned> stampv; unsigned stampc = 0; std::vector<int> bq;
    int stiff_dist(int R1) {
        if (H < 1) return 0;
        if (stampv.empty()) stampv.assign((size_t)NS * 6, 0);
        if (++stampc == 0) { std::fill(stampv.begin(), stampv.end(), 0); stampc = 1; }
        bq.clear();
        int a0 = Lt(H - 1);
        bq.push_back(Hd * 6 + a0); stampv[(size_t)Hd * 6 + a0] = stampc;
        size_t head = 0; int depth = 0;
        while (head < bq.size() && depth < R1) {
            size_t end = bq.size(); depth++;
            for (; head < end; head++) {
                int st_ = bq[head], p = st_ / 6, a = st_ % 6;
                for (int b = 0; b < 6; b++) {
                    if (b == (a ^ 1)) continue;
                    int q = p + DELTA[b];
                    if (q == Tl) return depth;
                    if (occ[q] || !ALLOWED[q]) continue;
                    if (mdist(q, Tl) > R1 - depth) continue;
                    if (b != a) { int sp = psi_site(p - DELTA[a], a, b, q); if (sp >= 0 && !occ[sp]) continue; }
                    size_t k = (size_t)q * 6 + b;
                    if (stampv[k] == stampc) continue;
                    stampv[k] = stampc; bq.push_back(q * 6 + b);
                }
            }
        }
        return 1 << 20;
    }

    /* z-balance (psi_Z minimal => psi_Z(w) <= psi_Z(z-flip w) = N*Hmax - psi_Z(w)): for every possible final top level
       Hf, the least possible total height of the R1-1 missing vertices, by DP over heights. */
    bool balz_ok(int R1) {
        int z0 = CZ[ORG], h1 = CZ[Hd] - z0, h2 = CZ[Tl] - z0, Hc = cmx[2] - z0;
        if (R1 < 1) return true;
        const int INF = 1 << 28; static thread_local int dp[2][64][2];
        for (int Hf = Hc; Hf <= 30; Hf++) {
            int need = (Hf > h1 ? Hf - h1 : 0) + (Hf > h2 ? Hf - h2 : 0);
            if (Hf > Hc && need > R1) break;
            /* path z_0 = h1 .. z_R1 = h2, all z in [0, Hf], max reaches Hf (flag), minimise sum of z_1..z_{R1-1} */
            for (int z = 0; z <= Hf; z++) for (int f = 0; f < 2; f++) dp[0][z][f] = INF;
            if (h1 > Hf || h2 > Hf) continue;
            dp[0][h1][(h1 == Hf || Hc == Hf) ? 1 : 0] = 0;
            int cur = 0;
            for (int i = 1; i <= R1; i++) {
                int nx = cur ^ 1;
                for (int z = 0; z <= Hf; z++) for (int f = 0; f < 2; f++) dp[nx][z][f] = INF;
                for (int z = 0; z <= Hf; z++) for (int f = 0; f < 2; f++) {
                    int v = dp[cur][z][f]; if (v >= INF) continue;
                    for (int dz = -1; dz <= 1; dz++) {
                        int z2 = z + dz; if (z2 < 0 || z2 > Hf) continue;
                        int f2 = f | (z2 == Hf);
                        int add = (i < R1) ? z2 : 0;
                        if (v + add < dp[nx][z2][f2]) dp[nx][z2][f2] = v + add;
                    }
                }
                cur = nx;
            }
            int best = dp[cur][h2][1];
            if (best >= INF) continue;
            if (2 * (sumz + best) <= N * Hf) return true;
        }
        return false;
    }
    int single(int s, Ob &ob) {
        if (occ[s]) return 1;
        if (!ALLOWED[s]) return -1;
        ob.cnt = 1; ob.site[0] = s; ob_masks(ob);
        return 0;
    }
    static inline int psi_site(int prev, int p, int d, int next) {
        if (p == 4 && d < 4) return prev + DELTA[d];
        if (d == 5 && p < 4) return next - DELTA[p];
        if (p == 2 && d < 2) return prev + DELTA[d];
        if (d == 3 && p < 2) return next - DELTA[p];
        return -1;
    }

    /* travel bounds: per axis, the walk from the head end over single sites to the tail end */
    inline int axis_need(int q, int c0, int ct, const int *pl, int np) const {
        int lo = ct, hi = ct;
        for (int a = 0; a < np; a++) {
            const Ob &ob = obs[pl[a]];
            if (ob.cnt != 1 && !(TAUAX && q > 0 && pl[a] == rayidx)) continue;
            int s = ob.site[0], cs = q == 0 ? CX[s] : q == 1 ? CY[s] : CZ[s];
            if (cs < lo) lo = cs; if (cs > hi) hi = cs;
        }
        int l = lo < c0 ? lo : c0, h = hi > c0 ? hi : c0;
        int a1 = (c0 - l) + (h - l) + (h - ct), a2 = (h - c0) + (h - l) + (ct - l);
        int t = a1 < a2 ? a1 : a2;
        if (AOTM && AX1D) {
            /* exact 1-D minimum over the choice of one site per multi-site obligation */
            const int BIG = 1 << 20;
            int bb[4 * MAXN], aa[4 * MAXN], k = 0;
            for (int a = 0; a < np; a++) {
                const Ob &ob = obs[pl[a]];
                if (ob.cnt <= 1) continue;
                int b = -BIG, c = BIG; bool in = false;
                for (int u = 0; u < ob.cnt; u++) {
                    int s = ob.site[u], sc = q == 0 ? CX[s] : q == 1 ? CY[s] : CZ[s];
                    if (sc >= l && sc <= h) { in = true; break; }
                    if (sc < l) { if (sc > b) b = sc; } else { if (sc < c) c = sc; }
                }
                if (in) continue;
                /* insert sorted by b descending */
                int j = k++;
                while (j > 0 && bb[j - 1] < b) { bb[j] = bb[j - 1]; aa[j] = aa[j - 1]; j--; }
                bb[j] = b; aa[j] = c;
            }
            if (k == 0) return t;
            int suf[4 * MAXN + 1]; suf[k] = -BIG;
            for (int j = k - 1; j >= 0; j--) suf[j] = aa[j] > suf[j + 1] ? aa[j] : suf[j + 1];
            int best = BIG;
            for (int i = 0; i <= k; i++) {
                int l2 = i == 0 ? l : bb[i - 1];
                if (l2 <= -BIG) break;
                if (suf[i] >= BIG) continue;
                int h2 = suf[i] > h ? suf[i] : h;
                int b1 = (c0 - l2) + (h2 - l2) + (h2 - ct), b2 = (h2 - c0) + (h2 - l2) + (ct - l2);
                int b = b1 < b2 ? b1 : b2;
                if (b < best) best = b;
            }
            return best > t ? best : t;
        }
        if (AOTM) {
            for (int a = 0; a < np; a++) {
                const Ob &ob = obs[pl[a]];
                if (ob.cnt <= 1) continue;
                int best = 1 << 20;
                for (int u = 0; u < ob.cnt; u++) {
                    int s = ob.site[u], sc = q == 0 ? CX[s] : q == 1 ? CY[s] : CZ[s];
                    int l2 = sc < l ? sc : l, h2 = sc > h ? sc : h;
                    int b1 = (c0 - l2) + (h2 - l2) + (h2 - ct), b2 = (h2 - c0) + (h2 - l2) + (ct - l2);
                    int b = b1 < b2 ? b1 : b2;
                    if (b < best) best = b;
                }
                if (best > t) t = best;
            }
        }
        return t;
    }
    /* axis_need for the three axes in one pass over the obligations (same values as axis_need(q, ...), q = 0, 1, 2).
       lo/hi (optional) return the range of the tail end and the single sites, as used by plane_route_need. */
    static inline int trav(int c0, int ct, int l, int h) { int a1 = (c0 - l) + (h - l) + (h - ct), a2 = (h - c0) + (h - l) + (ct - l); return a1 < a2 ? a1 : a2; }
    inline void need3(int from, const int *pl, int np, int *tq, int *lo_out = nullptr, int *hi_out = nullptr) const {
        const int c0[3] = {CX[from], CY[from], CZ[from]}, ct[3] = {CX[Tl], CY[Tl], CZ[Tl]};
        int lo[3] = {ct[0], ct[1], ct[2]}, hi[3] = {ct[0], ct[1], ct[2]};
        bool multi = false;
        for (int a = 0; a < np; a++) {
            const Ob &ob = obs[pl[a]];
            if (ob.cnt != 1) {
                multi = true;
                /* -tauax: every site of the ray obligation has y = z = 0, so for q = 1, 2 it counts as a single site
                   (same as axis_need / plane_route_need); it still enters the multi-site bound below */
                if (TAUAX && pl[a] == rayidx) for (int q = 1; q < 3; q++) { const int cq = ob.c1[q]; if (cq < lo[q]) lo[q] = cq; if (cq > hi[q]) hi[q] = cq; }
                continue;
            }
            const int cs[3] = {ob.c1[0], ob.c1[1], ob.c1[2]};
            for (int q = 0; q < 3; q++) { if (cs[q] < lo[q]) lo[q] = cs[q]; if (cs[q] > hi[q]) hi[q] = cs[q]; }
        }
        if (lo_out) for (int q = 0; q < 3; q++) { lo_out[q] = lo[q]; hi_out[q] = hi[q]; }
        int l[3], h[3];
        for (int q = 0; q < 3; q++) { l[q] = lo[q] < c0[q] ? lo[q] : c0[q]; h[q] = hi[q] > c0[q] ? hi[q] : c0[q]; tq[q] = trav(c0[q], ct[q], l[q], h[q]); }
        if (AOTM && multi && AX1D) {
            /* -ax1d: the same exact 1-D minimum as axis_need, with the nearest site below / above [l, h] of each
               multi-site obligation read from its coordinate bitmask */
            const int BIG = 1 << 20;
            for (int q = 0; q < 3; q++) {
                int bb[4 * MAXN], aa[4 * MAXN], k = 0;
                const int lb = l[q] + 32, hb = h[q] + 32;
                for (int a = 0; a < np; a++) {
                    const Ob &ob = obs[pl[a]];
                    if (ob.cnt <= 1) continue;
                    const uint64_t m = ob.cm[q];
                    const uint64_t inside = (m >> lb) & (hb - lb >= 63 ? ~0ull : ((1ull << (hb - lb + 1)) - 1));
                    if (inside) continue;
                    const uint64_t below = m & ((1ull << lb) - 1), above = hb >= 63 ? 0 : m >> (hb + 1);
                    const int b = below ? 63 - __builtin_clzll(below) - 32 : -BIG, c = above ? hb + 1 + __builtin_ctzll(above) - 32 : BIG;
                    int j = k++;
                    while (j > 0 && bb[j - 1] < b) { bb[j] = bb[j - 1]; aa[j] = aa[j - 1]; j--; }
                    bb[j] = b; aa[j] = c;
                }
                if (k == 0) continue;
                int suf[4 * MAXN + 1]; suf[k] = -BIG;
                for (int j = k - 1; j >= 0; j--) suf[j] = aa[j] > suf[j + 1] ? aa[j] : suf[j + 1];
                int best = BIG;
                for (int i = 0; i <= k; i++) {
                    const int l2 = i == 0 ? l[q] : bb[i - 1];
                    if (l2 <= -BIG) break;
                    if (suf[i] >= BIG) continue;
                    const int h2 = suf[i] > h[q] ? suf[i] : h[q];
                    const int b = trav(c0[q], ct[q], l2, h2);
                    if (b < best) best = b;
                }
                if (best > tq[q]) tq[q] = best;
            }
        } else if (AOTM && multi) {
            int t0[3] = {tq[0], tq[1], tq[2]};
            for (int a = 0; a < np; a++) {
                const Ob &ob = obs[pl[a]];
                if (ob.cnt <= 1) continue;
                /* the travel bound of a site depends only on its q-coordinate and grows with its distance from [l, h]:
                   the minimum over the sites is taken at a site inside [l, h] (bound t0) or at the nearest one below / above */
                for (int q = 0; q < 3; q++) {
                    const uint64_t m = ob.cm[q];
                    const int lb = l[q] + 32, hb = h[q] + 32;
                    const uint64_t below = m & ((1ull << lb) - 1), above = hb >= 63 ? 0 : m >> (hb + 1);
                    const uint64_t inside = (m >> lb) & (hb - lb >= 63 ? ~0ull : ((1ull << (hb - lb + 1)) - 1));
                    int best;
                    if (inside) best = t0[q];
                    else {
                        best = 1 << 20;
                        if (below) { int sc = 63 - __builtin_clzll(below) - 32; int b = trav(c0[q], ct[q], sc, h[q]); if (b < best) best = b; }
                        if (above) { int sc = hb + 1 + __builtin_ctzll(above) - 32; int b = trav(c0[q], ct[q], l[q], sc); if (b < best) best = b; }
                    }
                    if (best > tq[q]) tq[q] = best;
                }
            }
        }
    }
    inline int span_need(int from, const int *pl, int np) const {
        int tq[3]; need3(from, pl, np, tq);
        return tq[0] + tq[1] + tq[2];
    }

    inline int owed_plane(int A, int p, int mn, int mx) const {
        if (p < mn || p >= mx) return 0;
        int c = crs[A][p + 32], req = (p > mn && p < mx - 1) ? 4 : 2;
        if (STAIR && req == 2) {
            if (mx - mn == 1) { if (badl[A][mn + 32] && badl[A][mx + 32]) req = 4; }
            else if (p == mn) { if (badl[A][mn + 32]) req = 4; }
            else { if (badl[A][mx + 32]) req = 4; }
        }
        if (A == 2 && zr4 && p == 0) req = 4;
        return c >= req ? (c & 1) : req - c;
    }
    /* per-plane max of plane debt and route crossings, minimised over the two visiting orders */
    inline int plane_route_need(int q, int c0, int ct, int lo, int hi) const {
        int l = lo < c0 ? lo : c0, h = hi > c0 ? hi : c0;
        int mn = cmn[q] < nlo[q] ? cmn[q] : nlo[q], mx = cmx[q] > nhi[q] ? cmx[q] : nhi[q];
        int a = l < mn ? l : mn, b = h > mx ? h : mx;
        /* the two visiting orders c0 -> l -> h -> ct and c0 -> h -> l -> ct; a route segment u -> v crosses the plane
           between p and p+1 iff exactly one of u, v is <= p. The plane debt is the same for both orders. */
        int tot0 = 0, tot1 = 0;
        for (int p = a; p < b; p++) {
            const int ow = owed_plane(q, p, mn, mx);
            const bool s0 = c0 <= p, sl = l <= p, sh = h <= p, st_ = ct <= p;
            const int r0 = (s0 != sl) + (sl != sh) + (sh != st_), r1 = (s0 != sh) + (sh != sl) + (sl != st_);
            tot0 += r0 > ow ? r0 : ow; tot1 += r1 > ow ? r1 : ow;
        }
        return tot0 < tot1 ? tot0 : tot1;
    }
    mutable int span_cache = -1;
    inline bool aot_ok(const int *nw, int nn) const {
        int L[3], tq[3], lo[3], hi[3];
        need3(Hd, nw, nn, tq, lo, hi);
        span_cache = tq[0] + tq[1] + tq[2];   /* = span_need(Hd, nw, nn), reused by the first call of tour() */
        for (int q = 0; q < 3; q++) {
            int c0 = q == 0 ? CX[Hd] : q == 1 ? CY[Hd] : CZ[Hd], ct = q == 0 ? CX[Tl] : q == 1 ? CY[Tl] : CZ[Tl];
            int t = tq[q];
            if (AOTC && cdef[q] > t) t = cdef[q];
            if (AOTP && PRIME) { int t2 = plane_route_need(q, c0, ct, lo[q], hi[q]); if (t2 > t) t = t2; }
            L[q] = (cnt[q] + t + 1) & ~1;
        }
        if (SLAB >= 0) { int y = L[1], x = L[0] > y ? L[0] : y; return x + y + L[2] <= N; }
        int z = L[2], y = L[1] > z ? L[1] : z, x = L[0] > y ? L[0] : y;
        return x + y + z <= N;
    }

    int capO[4 * MAXN], capS[4 * MAXN], capTotal;
    bool gave_up;
    bool tour(int from, int *pl, int np, int used, int budget) {
        if (np == 0) return used + mdist(from, Tl) <= budget;
        if (used + (span_cache >= 0 ? span_cache : span_need(from, pl, np)) > budget) return false;
        span_cache = -1;
        if (++tour_calls > tcap) { gave_up = true; return true; }
        int key[4 * MAXN];
        for (int a = 0; a < np; a++) {
            const Ob &ob = obs[pl[a]];
            int best = 1 << 20, bestd = 1 << 20, bests = -1;
            for (int t = 0; t < ob.cnt; t++) {
                int s = ob.site[t], dd = mdist(from, s), ds = dd + mdist(s, Tl);
                if (ds < best) { best = ds; bests = s; }
                if (dd < bestd) bestd = dd;
            }
            if (used + best > budget) return false;
            if (np == 1) { capO[capTotal - 1] = pl[0]; capS[capTotal - 1] = bests; return true; }
            key[a] = bestd;
        }
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
                if (c + mdist(s, Tl) <= budget && tour(s, rest, nr, c, budget)) { capO[capTotal - np] = o; capS[capTotal - np] = s; return true; }
            }
        }
        return false;
    }
    /* joint order bound: per axis, prefix route crossings per plane + least crossings of the rest, max with plane debt */
    int jrc[3][64]; int jlo[3], jhi[3], jmn[3], jmx[3]; unsigned long long jcalls; bool jgave;
    int jO[4 * MAXN], jS[4 * MAXN], jtot;
    unsigned long long j_ok = 0, j_fail = 0, j_gu = 0;
    inline int jbound(int cur, const int *pl, int np) const {
        int L[3];
        for (int A = 0; A < 3; A++) {
            int cc = coord(A, cur), ct = coord(A, Tl);
            int FR = -1000, FL = 1000;   /* some remaining obligation lies entirely at >= FR / <= FL */
            for (int a = 0; a < np; a++) {
                const Ob &ob = obs[pl[a]];
                int mn = 1000, mx = -1000;
                for (int u = 0; u < ob.cnt; u++) { int c = coord(A, ob.site[u]); if (c < mn) mn = c; if (c > mx) mx = c; }
                if (mn > FR) FR = mn; if (mx < FL) FL = mx;
            }
            int t = 0;
            for (int p = jlo[A]; p < jhi[A]; p++) {
                bool sc = cc <= p, st_ = ct <= p;
                int r = jrc[A][p + 32];
                if (sc != st_) r += 1;
                else if (sc) { if (p < FR) r += 2; }
                else { if (p >= FL) r += 2; }
                int ow = owed_plane(A, p, jmn[A], jmx[A]);
                t += r > ow ? r : ow;
            }
            L[A] = (cnt[A] + t + 1) & ~1;
        }
        if (SLAB >= 0) { int y = L[1], x = L[0] > y ? L[0] : y; return x + y + L[2]; }
        int z = L[2], y = L[1] > z ? L[1] : z, x = L[0] > y ? L[0] : y;
        return x + y + z;
    }
    inline void jmove(int a, int b, int sg) {
        for (int A = 0; A < 3; A++) {
            int u = coord(A, a), v = coord(A, b);
            if (u > v) { int w = u; u = v; v = w; }
            for (int p = u; p < v; p++) jrc[A][p + 32] += sg;
        }
    }
    bool jtour(int from, int *pl, int np) {
        if (jbound(from, pl, np) > N) return false;
        if (np == 0) return true;
        if (++jcalls > (unsigned long long)JCAP) { jgave = true; return true; }
        int key[4 * MAXN];
        for (int a = 0; a < np; a++) {
            const Ob &ob = obs[pl[a]]; int bestd = 1 << 20;
            for (int t = 0; t < ob.cnt; t++) { int dd = mdist(from, ob.site[t]); if (dd < bestd) bestd = dd; }
            key[a] = bestd;
        }
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
                jmove(from, s, 1);
                bool ok = jtour(s, rest, nr);
                jmove(from, s, -1);
                if (ok) { jO[jtot - np] = o; jS[jtot - np] = s; return true; }
                if (jgave) return true;
            }
        }
        return false;
    }
    /* 1 alive (witness in jO/jS if !jgave), 0 dead */
    bool joint_ok(int nx, const int *nw, int nn) {
        for (int A = 0; A < 3; A++) {
            int lo = coord(A, nx), hi = lo, ct = coord(A, Tl);
            if (ct < lo) lo = ct; if (ct > hi) hi = ct;
            for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; for (int u = 0; u < ob.cnt; u++) { int c = coord(A, ob.site[u]); if (c < lo) lo = c; if (c > hi) hi = c; } }
            jmn[A] = cmn[A] < nlo[A] ? cmn[A] : nlo[A]; jmx[A] = cmx[A] > nhi[A] ? cmx[A] : nhi[A];
            jlo[A] = lo < jmn[A] ? lo : jmn[A]; jhi[A] = hi > jmx[A] ? hi : jmx[A];
            for (int p = jlo[A]; p <= jhi[A]; p++) jrc[A][p + 32] = 0;
        }
        int pl[4 * MAXN]; memcpy(pl, nw, nn * sizeof(int));
        jcalls = 0; jgave = false; jtot = nn;
        bool r = jtour(nx, pl, nn);
        if (!r) j_fail++; else if (jgave) j_gu++; else j_ok++;
        return r;
    }
    unsigned long long hk_calls = 0;
    int hk_len(int from, const int *q, int k) {
        /* exact shortest path from -> all k points (any order) -> Tl, Held-Karp over subsets */
        hk_calls++;
        int dp[1 << 8][8]; int full = (1 << k) - 1; int dq[8][8];
        for (int i = 0; i < k; i++) for (int j = 0; j < k; j++) dq[i][j] = mdist(q[i], q[j]);
        for (int i = 0; i < k; i++) dp[1 << i][i] = mdist(from, q[i]);
        for (int M = 1; M <= full; M++) {
            if ((M & (M - 1)) == 0) continue;
            for (int i = 0; i < k; i++) {
                if (!(M >> i & 1)) continue;
                int M0 = M ^ (1 << i), b = 1 << 20;
                for (int j = 0; j < k; j++) if (M0 >> j & 1) { int v = dp[M0][j] + dq[j][i]; if (v < b) b = v; }
                dp[M][i] = b;
            }
        }
        int best = 1 << 20;
        for (int i = 0; i < k; i++) { int v = dp[full][i] + mdist(q[i], Tl); if (v < best) best = v; }
        return best;
    }
    bool tour_ok(int i1, int nx, const int *nw, int nn, int R1) {
        int *o = wO[i1], *sv = wS[i1]; int m = 0;
        if (MSTONLY) {
            nwit[i1] = 0;
            int pts[4 * MAXN + 2], np2 = 0;
            pts[np2++] = nx; pts[np2++] = Tl;
            for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; if (ob.cnt != 1) continue; pts[np2++] = ob.site[0]; }
            if (np2 <= 3) { tour_giveup++; return true; }   /* one single site: the reach test already covers it */
            int k = np2 - 2;
            if (HKW) {
                /* witness: the parent's order of single sites (those still pending), new ones by cheapest insertion */
                unsigned char used[4 * MAXN + 2]; for (int i = 0; i < k; i++) used[i] = 0;
                int m2 = 0;
                for (int a = 0; a < nwit[i1 - 1]; a++) { int sp = wS[i1 - 1][a]; for (int i = 0; i < k; i++) if (!used[i] && pts[2 + i] == sp) { used[i] = 1; sv[m2++] = sp; break; } }
                for (int i = 0; i < k; i++) {
                    if (used[i]) continue;
                    int s2 = pts[2 + i], bc = 1 << 20, bp = 0;
                    for (int qq = 0; qq <= m2; qq++) {
                        int prev = qq == 0 ? nx : sv[qq - 1], nxt = qq == m2 ? Tl : sv[qq];
                        int c = mdist(prev, s2) + mdist(s2, nxt) - mdist(prev, nxt);
                        if (c < bc) { bc = c; bp = qq; }
                    }
                    for (int qq = m2; qq > bp; qq--) sv[qq] = sv[qq - 1];
                    sv[bp] = s2; m2++;
                }
                int cost = 0, at = nx;
                for (int qq = 0; qq < m2; qq++) { cost += mdist(at, sv[qq]); at = sv[qq]; }
                cost += mdist(at, Tl);
                nwit[i1] = m2;
                if (cost <= R1) { ts_ins++; tour_giveup++; return true; }
            }
            if (HKW && k <= HKK) {
                int key[4 * MAXN + 2]; bool in[4 * MAXN + 2];
                for (int a = 0; a < np2; a++) { key[a] = mdist(pts[0], pts[a]); in[a] = false; }
                in[0] = true; int total = 0;
                for (int r = 1; r < np2; r++) {
                    int b = -1;
                    for (int a = 0; a < np2; a++) if (!in[a] && (b < 0 || key[a] < key[b])) b = a;
                    in[b] = true; total += key[b];
                    if (total > R1) { ts_mst++; return false; }
                    for (int a = 0; a < np2; a++) if (!in[a]) { int dd = mdist(pts[b], pts[a]); if (dd < key[a]) key[a] = dd; }
                }
            }
            if (k <= HKK) {
                if (hk_len(nx, pts + 2, k) > R1) { ts_mst++; return false; }
                tour_giveup++; return true;
            }
            int key[4 * MAXN + 2]; bool in[4 * MAXN + 2];
            for (int a = 0; a < np2; a++) { key[a] = mdist(pts[0], pts[a]); in[a] = false; }
            in[0] = true; int total = 0;
            for (int r = 1; r < np2; r++) {
                int b = -1;
                for (int a = 0; a < np2; a++) if (!in[a] && (b < 0 || key[a] < key[b])) b = a;
                in[b] = true; total += key[b];
                if (total > R1) { ts_mst++; return false; }
                for (int a = 0; a < np2; a++) if (!in[a]) { int dd = mdist(pts[b], pts[a]); if (dd < key[a]) key[a] = dd; }
            }
            tour_giveup++; return true;
        }
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
            /* route points rp[0] = nx, rp[1..m] = sv, rp[m+1] = Tl; gap q is rp[q] -> rp[q+1] (same costs and
               the same first minimum as inserting into each gap in turn) */
            int rp[4 * MAXN + 2], dg[4 * MAXN + 1], ds[4 * MAXN + 2];
            rp[0] = nx; for (int q = 0; q < m; q++) rp[q + 1] = sv[q]; rp[m + 1] = Tl;
            for (int q = 0; q <= m; q++) dg[q] = mdist(rp[q], rp[q + 1]);
            for (int t = 0; t < ob.cnt; t++) {
                int s = ob.site[t];
                for (int q = 0; q <= m + 1; q++) ds[q] = mdist(rp[q], s);
                for (int q = 0; q <= m; q++) {
                    int c = ds[q] + ds[q + 1] - dg[q];
                    if (c < bestc) { bestc = c; bestp = q; bests = s; }
                }
            }
            for (int q = m; q > bestp; q--) { o[q] = o[q - 1]; sv[q] = sv[q - 1]; }
            o[bestp] = ob_i; sv[bestp] = bests; m++;
        }
        int cost = 0, at = nx;
        for (int q = 0; q < m; q++) { cost += mdist(at, sv[q]); at = sv[q]; }
        cost += mdist(at, Tl);
        if (cost <= R1) { nwit[i1] = m; ts_ins++; return true; }
        if (!NOMST) {
            int pts[4 * MAXN + 2], np2 = 0;
            pts[np2++] = nx; pts[np2++] = Tl;
            for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; if (ob.cnt != 1) continue; pts[np2++] = ob.site[0]; }
            int key[4 * MAXN + 2]; bool in[4 * MAXN + 2];
            for (int a = 0; a < np2; a++) { key[a] = mdist(pts[0], pts[a]); in[a] = false; }
            in[0] = true; int total = 0;
            for (int r = 1; r < np2; r++) {
                int b = -1;
                for (int a = 0; a < np2; a++) if (!in[a] && (b < 0 || key[a] < key[b])) b = a;
                in[b] = true; total += key[b];
                for (int a = 0; a < np2; a++) if (!in[a]) { int dd = mdist(pts[b], pts[a]); if (dd < key[a]) key[a] = dd; }
            }
            if (total > R1) { ts_mst++; return false; }
            if (HKK && np2 - 2 >= 2 && np2 - 2 <= HKK && hk_len(nx, pts + 2, np2 - 2) > R1) { ts_mst++; return false; }
        }
        if (JK && nn <= JK) {
            if (!joint_ok(nx, nw, nn)) { ts_fail++; return false; }
            if (!jgave) { for (int q = 0; q < nn; q++) { o[q] = jO[q]; sv[q] = jS[q]; } nwit[i1] = nn; ts_ok++; return true; }
            if (JONLY) { tour_giveup++; nwit[i1] = m; ts_gu++; return true; }
        }
        int pl[4 * MAXN];
        memcpy(pl, nw, nn * sizeof(int));
        tour_calls = 0; gave_up = false; capTotal = nn; tcap = TOUR_CAP; if (nn < 64) tr_nn[nn]++;
        if (!tour(nx, pl, nn, 0, R1)) { ts_fail++; return false; }
        if (gave_up) {
            tour_giveup++; nwit[i1] = m; ts_gu++;
            if (TSTAT) { int mu = 0; for (int a = 0; a < nn; a++) if (obs[nw[a]].cnt > 1) mu++; gu_nn[nn < 63 ? nn : 63]++; gu_multi[mu < 63 ? mu : 63]++; }
            if (ORACLE) { memcpy(pl, nw, nn * sizeof(int)); tour_calls = 0; gave_up = false; tcap = ORACLE;
                bool r = tour(nx, pl, nn, 0, R1);
                if (gave_up) or_unk++; else if (r) or_ok++; else { or_fail++; gu_fail_nn[nn < 63 ? nn : 63]++; } }
            return true; }
        ts_ok++;
        for (int q = 0; q < nn; q++) { o[q] = capO[q]; sv[q] = capS[q]; }
        nwit[i1] = nn;
        return true;
    }

    static inline int tauL(int c) { return c < 2 ? c ^ 1 : c; }
    /* the comparison of w(P) with w(tau P) on the current prefix, assuming rho: -1 undecided, 1 P > tau P, 0 P < tau P */
    int tau_dec() {
        if (H < 1 || T < 1) return -1;
        int k = 0; while (k < H && Lt(k) == 0) k++;
        if (k == H) return -1;
        tk = k;
        if (k == 0) {   /* tau P = tau(w) letter by letter; positions in the order T'_0, T'_1, H_0, ..., H_{N-3}; the first x-letter decides */
            for (int j = 0; j < 2; j++) { if (j >= T) return -1; int c = Lt(-1 - j) ^ 1; if (c < 2) return c == 1; }
            for (int i = 0; i < N - 2; i++) { if (i >= H) return -1; int c = Lt(i); if (c < 2) return c == 1; }
            return 0;
        }
        for (int j : TORD[k]) {   /* H_{k+j} = w_{k+j} versus tau T'_j = tau(-w_{N-1-j}) */
            int p1 = k + j, p2 = N - 1 - j;
            if (!(p1 < H || p1 >= N - T) || !(p2 < H || p2 >= N - T)) return -1;
            int h = p1 < H ? Lt(p1) : Lt(p1 - N), t2 = p2 < H ? Lt(p2) : Lt(p2 - N);
            int tt = tauL(t2 ^ 1);
            if (h != tt) return h > tt;
        }
        return 0;
    }
    bool tau_leaf_cut() {   /* exact rule on the finished word: rho(P) and w(P) > w(tau P) */
        int k = 0; while (dirs[k] == 0) k++;
        if (TAU == 1) for (int i = 0; i < N; i++) if (CZ[pos[i]] == CZ[ORG] && CY[pos[i]] == CY[ORG] && CX[pos[i]] - CX[ORG] > k) return false;
        if (k == 0) {
            for (int j = 0; j < 2; j++) { int c = dirs[N - 1 - j] ^ 1; if (c < 2) return c == 1; }
            for (int i = 0; i < N - 2; i++) { int c = dirs[i]; if (c < 2) return c == 1; }
            return false;
        }
        for (int j : TORD[k]) { int h = dirs[k + j], tt = tauL(dirs[N - 1 - j] ^ 1); if (h != tt) return h > tt; }
        return false;
    }
    /* ================= GW3 walk bound (-walk LO HI, from enum_g.cpp) =================
       Problem it solves: the tour tests measure distances in the Manhattan metric and ignore the occupied cells and the
       letter rules. GW3 asks whether there is a walk of at most R1 steps from Hd to Tl through free allowed cells that
       visits a site of every pending obligation (at most GWK = 6 of them, those with the fewest sites: dropping an
       obligation only weakens the test) and obeys the letter rules of DMON (no reversal, no U-turn), also at the junction
       with the head's last two letters and the tail's first two letters. A polygon completing the prefix gives such a walk
       (its middle part), so "no walk" is a sound rejection. State = (cell, last two letters, obligations visited);
       depth-first search with the admissible bound w_h (Held-Karp-like table w_B over the Manhattan metric) and a
       memo of the least depth per state. Give-ups (keep the node): more than 64 distinct sites, GWLIM states, memo full. */
    static const int GWK = 6;
    std::vector<unsigned> gcS; std::vector<unsigned char> gcM; unsigned gcep = 0;
    static const int GHC = 1 << 15;
    std::vector<unsigned long long> ghT; unsigned gh_ep = 0;
    int w_m = 0, w_k = 0, w_R = 0, w_tx = 0, w_ty = 0, w_tz = 0; unsigned w_full = 0;
    int w_sx[64], w_sy[64], w_sz[64], w_st[64]; unsigned long long w_ob[GWK]; unsigned char w_cov[64];
    unsigned long long w_states = 0; int w_ins = 0, w_hins = 0;
    int w_B[64][64]; bool w_hdp = false;   /* w_B[S][j]: least Manhattan length from site j to Tl through a site of every obligation in S */
    void w_prepB() {
        unsigned full = w_full;
        for (unsigned S = 0; S <= full; S++) for (int i = 0; i < w_m; i++) {
            if (S == 0) { w_B[0][i] = w_st[i]; continue; }
            int b = 1 << 20;
            for (int j = 0; j < w_m; j++) { unsigned cj = w_cov[j]; if (!(cj & S)) continue; int v = abs(w_sx[i] - w_sx[j]) + abs(w_sy[i] - w_sy[j]) + abs(w_sz[i] - w_sz[j]) + w_B[S & ~cj][j]; if (v < b) b = v; }
            w_B[S][i] = b;
        }
    }
    inline int w_h(int q, unsigned mask) const {
        int x = CX[q], y = CY[q], z = CZ[q];
        int h = abs(x - w_tx) + abs(y - w_ty) + abs(z - w_tz);
        if (mask == w_full) return h;
        if (w_hdp) {
            unsigned rem = w_full & ~mask; int b = 1 << 20;
            for (int j = 0; j < w_m; j++) { unsigned cj = w_cov[j]; if (!(cj & rem)) continue; int v = abs(x - w_sx[j]) + abs(y - w_sy[j]) + abs(z - w_sz[j]) + w_B[rem & ~cj][j]; if (v < b) b = v; }
            return b > h ? b : h;
        }
        int v[64];
        for (int i = 0; i < w_m; i++) v[i] = abs(x - w_sx[i]) + abs(y - w_sy[i]) + abs(z - w_sz[i]) + w_st[i];
        for (int o = 0; o < w_k; o++) {
            if (mask >> o & 1) continue;
            unsigned long long b = w_ob[o]; int mn = 1 << 20;
            while (b) { int i = __builtin_ctzll(b); b &= b - 1; if (v[i] < mn) mn = v[i]; }
            if (mn > h) h = mn;
        }
        return h;
    }
    /* returns true if the state is new or improved, and records depth d */
    int w3_t0 = -1, w3_t1 = -1; int anc_A = -1, anc_B = -1, anc_C = -1, anc_a = 0, anc_b = 0; unsigned anc_bit = 0;
    inline bool w3_memo(unsigned key, int d) {
        unsigned hsh = (key * 2654435761u) >> 17;
        for (;;) {
            unsigned long long &e = ghT[hsh];
            if ((unsigned)(e >> 40) != (gh_ep & 0xffffff)) { e = ((unsigned long long)(gh_ep & 0xffffff) << 40) | ((unsigned long long)key << 8) | (unsigned)d; w_ins++; return true; }
            if (((e >> 8) & 0xffffffffull) == key) { if ((int)(e & 0xff) <= d) return false; e = (e & ~0xffull) | (unsigned)d; return true; }
            hsh = (hsh + 1) & (GHC - 1);
        }
    }
    int w3_dfs(int q, unsigned mask, int d, int l1, int l2) {
        if (++w_states > (unsigned long long)GWLIM || w_ins > (GHC * 3 >> 2) - 8) return -1;
        int nb[6], hv[6], kd[6]; unsigned nm[6]; int c = 0;
        for (int k = 0; k < 6; k++) {
            if (k == (l1 ^ 1) || k == (l2 ^ 1)) continue;
            int r = q + DELTA[k];
            if (r == Tl) {
                if (mask != w_full) continue;
                if (w3_t0 >= 0 && (k == (w3_t0 ^ 1) || l1 == (w3_t0 ^ 1))) continue;
                if (w3_t1 >= 0 && k == (w3_t1 ^ 1)) continue;
                return 1;
            }
            if (occ[r] || !ALLOWED[r]) continue;
            unsigned m2 = mask | (gcS[r] == gcep ? gcM[r] : 0);
            int h = w_hc(r, m2);
            if (d + 1 + h > w_R) continue;
            { unsigned lk = (d + 1 < GW3LET) ? (unsigned)((l1 < 6 ? l1 : 0) * 6 + k) : 35u + 0 * k; if (d + 1 >= GW3LET) lk = 0; if (!w3_memo((((unsigned)r * 37 + (d + 1 < GW3LET ? lk + 1 : 0)) << 6) | m2, d + 1)) continue; }
            int b = c - 1; while (b >= 0 && hv[b] > h) { nb[b + 1] = nb[b]; hv[b + 1] = hv[b]; nm[b + 1] = nm[b]; kd[b + 1] = kd[b]; b--; }
            nb[b + 1] = r; hv[b + 1] = h; nm[b + 1] = m2; kd[b + 1] = k; c++;
        }
        for (int a = 0; a < c; a++) {
            if (anc_A >= 0 && nb[a] == anc_A && !(mask & anc_bit)) {   /* entering A: the macro A -> C -> B is forced */
                const int k1 = kd[a];
                if (anc_a == (k1 ^ 1) || anc_a == (l1 ^ 1) || anc_b == (anc_a ^ 1) || anc_b == (k1 ^ 1)) continue;
                unsigned m2 = nm[a] | (gcS[anc_B] == gcep ? gcM[anc_B] : 0);
                if (anc_B == Tl) {
                    if (m2 != w_full) continue;
                    if (w3_t0 >= 0 && (anc_b == (w3_t0 ^ 1) || anc_a == (w3_t0 ^ 1))) continue;
                    if (w3_t1 >= 0 && anc_b == (w3_t1 ^ 1)) continue;
                    return 1;
                }
                if (d + 3 + w_hc(anc_B, m2) > w_R) continue;
                int v = w3_dfs(anc_B, m2, d + 3, anc_b, anc_a); if (v) return v;
                continue;
            }
            int v = (d + 1 < GW3LET) ? w3_dfs(nb[a], nm[a], d + 1, kd[a], l1) : w3_dfs(nb[a], nm[a], d + 1, 6, 6); if (v) return v;
        }
        return 0;
    }
    std::vector<unsigned long long> ghH;
    inline int w_hc(int r, unsigned m2) {
        unsigned key = (unsigned)r * 64 + m2, hsh = (key * 2654435761u) >> 18;
        for (;;) {
            unsigned long long &e = ghH[hsh];
            if ((unsigned)(e >> 40) != (gh_ep & 0xffffff)) { int h = w_h(r, m2); if (++w_hins > (GHC >> 2)) return h; e = ((unsigned long long)(gh_ep & 0xffffff) << 40) | ((unsigned long long)key << 8) | (unsigned)(h > 255 ? 255 : h); return h; }
            if (((e >> 8) & 0xffffffffull) == key) return (int)(e & 0xff);
            hsh = (hsh + 1) & ((GHC >> 1) - 1);
        }
    }
    bool gwalk3(int R1, const int *nw, int nn) {   /* true = dead (enum_g's gwalk2 in W3 mode, depth-first) */
        if (ghT.empty()) { ghT.assign(GHC, 0); ghH.assign(GHC >> 1, 0); gcS.assign(NS, 0); gcM.assign(NS, 0); }
        st.w3calls++;
        int cell[64]; unsigned long long msk[4 * MAXN]; int m = 0, k = 0;
        bool raypend = false;
        for (int a = 0; a < nn; a++) if (nw[a] == rayidx) { raypend = true; st.w3ray++; break; }
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]]; unsigned long long b = 0;
            for (int u = 0; u < ob.cnt; u++) {
                int s = ob.site[u]; if (mdist(Hd, s) + mdist(s, Tl) > R1) continue;
                int f = -1; for (int i = 0; i < m; i++) if (cell[i] == s) { f = i; break; }
                if (f < 0) {
                    if (m >= 64) {   /* site table full: give up (keep); count whether the ray obligation caused it */
                        st.w3full++;
                        if (raypend) {
                            int c2[64], m2 = 0; bool full2 = false;
                            for (int a2 = 0; a2 < nn && !full2; a2++) {
                                if (nw[a2] == rayidx) continue;
                                const Ob &o2 = obs[nw[a2]];
                                for (int u2 = 0; u2 < o2.cnt && !full2; u2++) {
                                    int s2 = o2.site[u2]; if (mdist(Hd, s2) + mdist(s2, Tl) > R1) continue;
                                    bool seen = false; for (int i = 0; i < m2; i++) if (c2[i] == s2) { seen = true; break; }
                                    if (!seen) { if (m2 >= 64) full2 = true; else c2[m2++] = s2; }
                                }
                            }
                            if (!full2) st.w3fullray++;
                        }
                        return false;
                    }
                    cell[m] = s; f = m++;
                }
                b |= 1ull << f;
            }
            if (!b) { st.w3dead++; return true; }
            msk[k++] = b;
        }
        unsigned long long keep[4 * MAXN]; int ksz[4 * MAXN], kk = 0;
        for (int j = 0; j < k; j++) {
            bool dom = false; unsigned long long b = msk[j];
            for (int i = 0; i < k && !dom; i++) { if (i == j) continue; unsigned long long a = msk[i]; if ((a & ~b) == 0 && (a != b || i < j)) dom = true; }
            if (!dom) { keep[kk] = b; ksz[kk] = __builtin_popcountll(b); kk++; }
        }
        if (kk > GWK) {
            for (int a = 1; a < kk; a++) { unsigned long long x = keep[a]; int y = ksz[a], b = a - 1; while (b >= 0 && ksz[b] > y) { keep[b + 1] = keep[b]; ksz[b + 1] = ksz[b]; b--; } keep[b + 1] = x; ksz[b + 1] = y; }
            kk = GWK;
        }
        if (++gcep == 0) { std::fill(gcS.begin(), gcS.end(), 0); gcep = 1; }
        if ((++gh_ep & 0xffffff) == 0) { std::fill(ghT.begin(), ghT.end(), 0); gh_ep++; }
        w_k = kk; w_full = (1u << kk) - 1; w_R = R1; w_tx = CX[Tl]; w_ty = CY[Tl]; w_tz = CZ[Tl];
        unsigned long long used = 0; for (int j = 0; j < kk; j++) used |= keep[j];
        int map[64]; w_m = 0;
        for (int i = 0; i < m; i++) if (used >> i & 1) {
            unsigned c = 0; for (int j = 0; j < kk; j++) if (keep[j] >> i & 1) c |= 1u << j;
            int s = cell[i]; map[i] = w_m; w_sx[w_m] = CX[s]; w_sy[w_m] = CY[s]; w_sz[w_m] = CZ[s]; w_st[w_m] = mdist(s, Tl); w_cov[w_m] = (unsigned char)c; w_m++;
            gcS[s] = gcep; gcM[s] = (unsigned char)c;
        }
        for (int j = 0; j < kk; j++) { unsigned long long b = 0, x = keep[j]; while (x) { int i = __builtin_ctzll(x); x &= x - 1; b |= 1ull << map[i]; } w_ob[j] = b; }
        w_states = 0; w_ins = 0; w_hins = 0;
        w_hdp = W3HDP && kk >= 2; if (w_hdp) w_prepB();
        { int h0 = w_h(Hd, 0); if (h0 > R1) { st.w3dead++; return true; } if (R1 - h0 > GWGAP) { st.w3skip++; return false; } }
        w3_t0 = T >= 1 ? Lt(-T) : -1; w3_t1 = T >= 2 ? Lt(-T + 1) : -1;
        int l1 = H >= 1 ? Lt(H - 1) : 7, l2 = H >= 2 ? Lt(H - 2) : 7;   /* 7: no letter (7^1 = 6 matches no direction) */
        const int v = w3_dfs(Hd, 0, 0, l1, l2);
        st.w3states += w_states;
        if (v < 0) { st.w3over++; if (raypend) st.w3overray++; }
        if (v == 0) st.w3dead++;
        return v == 0;
    }

    bool gwalk3a(int R1, const int *nw, int nn, int cC, int aL, int bL) {   /* true = dead (enum_g's gwalk2 in W3 mode, depth-first) */
        if (ghT.empty()) { ghT.assign(GHC, 0); ghH.assign(GHC >> 1, 0); gcS.assign(NS, 0); gcM.assign(NS, 0); }
        st.w3calls++;
        int cell[64]; unsigned long long msk[4 * MAXN]; int m = 0, k = 0;
        bool raypend = false;
        for (int a = 0; a < nn; a++) if (nw[a] == rayidx) { raypend = true; st.w3ray++; break; }
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]]; unsigned long long b = 0;
            { bool hasC = false; for (int u = 0; u < ob.cnt; u++) if (ob.site[u] == cC) { hasC = true; break; } if (hasC) continue; }
            for (int u = 0; u < ob.cnt; u++) {
                int s = ob.site[u]; if (mdist(Hd, s) + mdist(s, Tl) > R1) continue;
                int f = -1; for (int i = 0; i < m; i++) if (cell[i] == s) { f = i; break; }
                if (f < 0) {
                    if (m >= 64) {   /* site table full: give up (keep); count whether the ray obligation caused it */
                        st.w3full++;
                        if (raypend) {
                            int c2[64], m2 = 0; bool full2 = false;
                            for (int a2 = 0; a2 < nn && !full2; a2++) {
                                if (nw[a2] == rayidx) continue;
                                const Ob &o2 = obs[nw[a2]];
                                for (int u2 = 0; u2 < o2.cnt && !full2; u2++) {
                                    int s2 = o2.site[u2]; if (mdist(Hd, s2) + mdist(s2, Tl) > R1) continue;
                                    bool seen = false; for (int i = 0; i < m2; i++) if (c2[i] == s2) { seen = true; break; }
                                    if (!seen) { if (m2 >= 64) full2 = true; else c2[m2++] = s2; }
                                }
                            }
                            if (!full2) st.w3fullray++;
                        }
                        return false;
                    }
                    cell[m] = s; f = m++;
                }
                b |= 1ull << f;
            }
            if (!b) { st.w3dead++; return true; }
            msk[k++] = b;
        }
        unsigned long long keep[4 * MAXN]; int ksz[4 * MAXN], kk = 0;
        for (int j = 0; j < k; j++) {
            bool dom = false; unsigned long long b = msk[j];
            for (int i = 0; i < k && !dom; i++) { if (i == j) continue; unsigned long long a = msk[i]; if ((a & ~b) == 0 && (a != b || i < j)) dom = true; }
            if (!dom) { keep[kk] = b; ksz[kk] = __builtin_popcountll(b); kk++; }
        }
        if (kk > 5) {
            for (int a = 1; a < kk; a++) { unsigned long long x = keep[a]; int y = ksz[a], b = a - 1; while (b >= 0 && ksz[b] > y) { keep[b + 1] = keep[b]; ksz[b + 1] = ksz[b]; b--; } keep[b + 1] = x; ksz[b + 1] = y; }
            kk = 5;
        }
        int AA = cC - DELTA[aL], BB = cC + DELTA[bL];
        { int fA = -1; for (int i = 0; i < m; i++) if (cell[i] == AA) { fA = i; break; }
          if (fA < 0) { if (m >= 64) { return false; } cell[m] = AA; fA = m++; }
          keep[kk] = 1ull << fA; kk++; }
        anc_bit = 1u << (kk - 1); anc_A = AA; anc_B = BB; anc_C = cC; anc_a = aL; anc_b = bL;
        unsigned char sOccC = occ[cC], sOccB = occ[BB]; occ[cC] = 1; if (BB != Tl) occ[BB] = 1;
        if (++gcep == 0) { std::fill(gcS.begin(), gcS.end(), 0); gcep = 1; }
        if ((++gh_ep & 0xffffff) == 0) { std::fill(ghT.begin(), ghT.end(), 0); gh_ep++; }
        w_k = kk; w_full = (1u << kk) - 1; w_R = R1; w_tx = CX[Tl]; w_ty = CY[Tl]; w_tz = CZ[Tl];
        unsigned long long used = 0; for (int j = 0; j < kk; j++) used |= keep[j];
        int map[64]; w_m = 0;
        for (int i = 0; i < m; i++) if (used >> i & 1) {
            unsigned c = 0; for (int j = 0; j < kk; j++) if (keep[j] >> i & 1) c |= 1u << j;
            int s = cell[i]; map[i] = w_m; w_sx[w_m] = CX[s]; w_sy[w_m] = CY[s]; w_sz[w_m] = CZ[s]; w_st[w_m] = mdist(s, Tl); w_cov[w_m] = (unsigned char)c; w_m++;
            gcS[s] = gcep; gcM[s] = (unsigned char)c;
        }
        for (int j = 0; j < kk; j++) { unsigned long long b = 0, x = keep[j]; while (x) { int i = __builtin_ctzll(x); x &= x - 1; b |= 1ull << map[i]; } w_ob[j] = b; }
        w_states = 0; w_ins = 0; w_hins = 0;
        w_hdp = W3HDP && kk >= 2; if (w_hdp) w_prepB();
        { int h0 = w_h(Hd, 0); if (h0 > R1) { st.w3dead++; occ[cC] = sOccC; occ[BB] = sOccB; anc_A = -1; return true; } if (R1 - h0 > GWGAP) { st.w3skip++; occ[cC] = sOccC; occ[BB] = sOccB; anc_A = -1; return false; } }
        w3_t0 = T >= 1 ? Lt(-T) : -1; w3_t1 = T >= 2 ? Lt(-T + 1) : -1;
        int l1 = H >= 1 ? Lt(H - 1) : 7, l2 = H >= 2 ? Lt(H - 2) : 7;   /* 7: no letter (7^1 = 6 matches no direction) */
        int v;
        if (AA == Hd) {   /* the macro starts at the head end */
            bool ok = true;
            if (l1 < 6 && aL == (l1 ^ 1)) ok = false; if (l2 < 6 && aL == (l2 ^ 1)) ok = false;
            if (bL == (aL ^ 1)) ok = false; if (l1 < 6 && bL == (l1 ^ 1)) ok = false;
            if (!ok) v = 0;
            else {
                unsigned m2 = anc_bit | (gcS[BB] == gcep ? gcM[BB] : 0);
                if (BB == Tl) v = (m2 == w_full) ? 1 : 0;
                else v = (2 + w_hc(BB, m2) <= R1) ? w3_dfs(BB, m2, 2, bL, aL) : 0;
            }
        } else v = w3_dfs(Hd, 0, 0, l1, l2);
        occ[cC] = sOccC; occ[BB] = sOccB;
        anc_A = -1;
        st.w3states += w_states;
        if (v < 0) { st.w3over++; if (raypend) st.w3overray++; }
        if (v == 0) st.w3dead++;
        return v == 0;
    }


#define REJ(q, r) do { st.rej[q][r]++; } while (0)
    /* obligations and tests after the step that created letter li (side 0: head, 1: tail) and the vertex nx; R1 = steps still missing */
    bool update2(int side, int li, int nx, int ofa, int ola, int R1) {
        int t = H + T;
        const int *old = pend[t - 1]; int no = npend[t - 1];
        int *nw = pend[t]; int nn = 0;
        const uint64_t nxb = 1ull << (CX[nx] + 32), nyb = 1ull << (CY[nx] + 32), nzb = 1ull << (CZ[nx] + 32);
        for (int a = 0; a < no; a++) {
            const Ob &ob = obs[old[a]];
            bool sat = false;
            if ((ob.cm[0] & nxb) && (ob.cm[1] & nyb) && (ob.cm[2] & nzb))
                for (int u = 0; u < ob.cnt; u++) if (ob.site[u] == nx) { sat = true; break; }
            if (!sat) nw[nn++] = old[a];
        }
        const int e = Lt(li);
        if (!side) {
            int j = ola;
            if (j != NONE && Lt(j) == (e ^ 1)) {
                int r = curtain2(j, li, DELTA[Lt(j) ^ 1], obs[nobs]);
                if (r == -1) { REJ(0, R1); return false; }
                if (r == 0) nw[nn++] = nobs++;
            }
        } else {
            int i = ofa;
            if (i != NONE && Lt(i) == (e ^ 1)) {
                int r = curtain2(li, i, DELTA[e ^ 1], obs[nobs]);
                if (r == -1) { REJ(0, R1); return false; }
                if (r == 0) nw[nn++] = nobs++;
            }
        }
        if (PSI) {
            int s = -1;
            if (!side) { if (li >= 1) s = psi_site(P(li - 1), Lt(li - 1), e, nx); }
            else { if (T >= 2) s = psi_site(nx, e, Lt(li + 1), P(li + 2)); }
            if (s >= 0) {
                int r = single(s, obs[nobs]);
                if (r == -1) { REJ(0, R1); return false; }
                if (r == 0) nw[nn++] = nobs++;
            }
        }
        if (CRANK) {
            /* hat u b^k d (k >= 1, b horizontal) just completed: the new letter is its d (head) or its u (tail) */
            int st0 = 0, k = 0, b = -1; bool hat = false;
            if (!side && e == 5) {
                int j = li - 1;
                if (j >= -T && Lt(j) < 4) { b = Lt(j); while (j >= -T && Lt(j) == b) { j--; k++; } if (j >= -T && Lt(j) == 4) { hat = true; st0 = j; } }
            } else if (side && e == 4) {
                int j = li + 1;
                if (j <= H - 1 && Lt(j) < 4) { b = Lt(j); while (j <= H - 1 && Lt(j) == b) { j++; k++; } if (j <= H - 1 && Lt(j) == 5) { hat = true; st0 = li; } }
            }
            if (hat) {
                int base = P(st0);
                for (int c = 0; c < 4; c++) {
                    if ((c >> 1) == (b >> 1)) continue;
                    int r = crank_row(base, b, k, c, obs[nobs]);
                    if (r == -1) { REJ(0, R1); return false; }
                    if (r == 0) nw[nn++] = nobs++;
                }
            }
        }
        if (TAU) {
            tst[t] = tst[t - 1];
            if (tst[t] == -1) {
                int d = tau_dec();
                if (d != -1) {
                    tst[t] = 0;
                    if (d == 1) {
                        st.taudec++;
                        if (TAU == 2) { REJ(0, R1); return false; }
                        bool hit = false;
                        for (int x = tk + 1; x <= 27; x++) if (occ[ORG + x]) { hit = true; break; }
                        if (!hit) {   /* rho still possible: some later vertex must lie on the ray (x > k, y = z = 0), else P is pruned */
                            Ob &ob = obs[nobs]; ob.cnt = 0;
                            for (int x = tk + 1; x <= 27; x++) { int s = ORG + x; if (ALLOWED[s] && mdist(Hd, s) + mdist(s, Tl) <= R1) ob.site[ob.cnt++] = s; }
                            if (ob.cnt == 0) { REJ(1, R1); return false; }
                            st.tauob++;
                            ob_masks(ob); rayidx = nobs; nw[nn++] = nobs++;
                            if (TAUZ && STAIR) {   /* Lemma 3: with two crossings of z = 1/2 the bottom arc is a geodesic and cannot reach the ray */
                                zr4 = 1; if (nhi[2] < 1) nhi[2] = 1;
                                cdef[2] = owed(2);
                                if (cdef[0] + cdef[1] + cdef[2] > R1) { REJ(2, R1); return false; }
                            }
                        }
                    }
                }
            }
        }
        npend[t] = nn; span_cache = -1;
        if (trust_step) {   /* this child passed the full tests in a probe of the same state: restore its witness tour */
            const int d0 = code[t - 1]; const int m = pwn[t - 1][side][d0];
            nwit[t] = m; if (m) { memcpy(wO[t], pwO[t - 1][side][d0], m * sizeof(int)); memcpy(wS[t], pwS[t - 1][side][d0], m * sizeof(int)); }
            return true;
        }
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]];
            bool fine = false;
            for (int u = 0; u < ob.cnt && !fine; u++) {
                int s = ob.site[u];
                if (mdist(Hd, s) + mdist(s, Tl) > R1) continue;
                int av = 0;
                for (int q = 0; q < 6 && av < 2; q++) { int w = s + DELTA[q]; av += (w == Hd || w == Tl || (!occ[w] && ALLOWED[w])); }
                fine = av >= 2;
            }
            if (!fine) { REJ(1, R1); return false; }
        }
        if (AOT && AXES && !aot_ok(nw, nn)) { REJ(2, R1); return false; }
        if (R1 >= STIFFX && stiff_dist(R1) > R1) { REJ(1, R1); return false; }
        if (BALZ && SLAB < 0 && R1 <= 16 && !balz_ok(R1)) { REJ(2, R1); return false; }
        nwit[t] = 0;
        if (LIGHT) return true;
        if (nn >= JMIN && !(nn < 2 ? joint_ok(Hd, nw, nn) : tour_ok(t, Hd, nw, nn, R1))) { REJ(3, R1); return false; }
        if (WALK && R1 >= WALK_LO && R1 <= WALK_HI && gwalk3(R1, nw, nn)) { REJ(3, R1); return false; }   /* GW3, after the tour test */
        return true;
    }

    /* ----- the complete test of a finished polygon, from its word ----- */
    int dirs[MAXN + 1], pos[MAXN + 2];
    bool full_ok() {
        for (int i = 0; i < N; i++) if (dirs[i] == (dirs[(i + 2) % N] ^ 1)) return false;          /* U-turns, also across the join and the root */
        if ((dirs[N - 1] ^ 1) <= dirs[0]) return false;                                              /* DMON4 */
        for (int A = 0; A < 3; A++) {                                                                /* DMON6: every curtain window */
            int ia[MAXN], m = 0;
            for (int i = 0; i < N; i++) if ((dirs[i] >> 1) == A) ia[m++] = i;
            for (int q = 0; q < m; q++) {
                int j = ia[q], j2 = ia[(q + 1) % m];
                if (dirs[j2] != (dirs[j] ^ 1)) continue;
                int k = (((j2 - j - 1) % N) + N) % N;
                int back = DELTA[dirs[j] ^ 1];
                bool sat = false;
                for (int u = 2; u <= k && !sat; u++) if (occ[pos[(j + u) % N] + back]) sat = true;
                if (!sat) return false;
            }
        }
        if (PSI)                                                                                      /* DMON7: every corner except at the root */
            for (int i = 1; i < N; i++) {
                int s = psi_site(pos[i - 1], dirs[i - 1], dirs[i], pos[i + 1]);
                if (s >= 0 && !occ[s]) return false;
            }
        int c[3] = {0, 0, 0};
        for (int i = 0; i < N; i++) c[dirs[i] >> 1]++;
        if (AXES && !((SLAB >= 0 || c[2] <= c[1]) && c[1] <= c[0])) return false;                  /* DMON5 */
        return true;
    }
    bool cyc_ok() {
        if ((FACE || PLANE4) && SLAB < 0) {
            int lo[3], hi[3];
            for (int A = 0; A < 3; A++) { lo[A] = 1000; hi[A] = -1000; for (int i = 0; i < N; i++) { int c = coord(A, pos[i]); if (c < lo[A]) lo[A] = c; if (c > hi[A]) hi[A] = c; } }
            for (int A = 0; A < 3; A++) for (int i = 0; i < N; i++) {
                int c = coord(A, pos[i]);
                for (int L = 1; L < N; L++) {
                    int q = pos[(i + L) % N];
                    if (coord(A, q) != c) break;
                    if (L - mdist(pos[i], q) >= 4) {
                        if (A == 2 && c == CZ[ORG]) return false;
                        if (PLANE4 && !(lo[A] <= c - 1 && hi[A] >= c + 1)) return false;
                        break;
                    }
                }
            }
        }
        if (CRANK) for (int i = 0; i < N; i++) {
            if (dirs[i] != 4) continue;
            int b = dirs[(i + 1) % N]; if (b >= 4) continue;
            int k = 0; while (dirs[(i + 1 + k) % N] == b) k++;
            if (dirs[(i + 1 + k) % N] != 5) continue;
            for (int c = 0; c < 4; c++) {
                if ((c >> 1) == (b >> 1)) continue;
                bool hit = false;
                for (int t = 0; t <= k && !hit; t++) if (occ[pos[i] + t * DELTA[b] + DELTA[c]]) hit = true;
                if (!hit) return false;
            }
        }
        return true;
    }
    void leaf(int c) {
        st.closed++;
        for (int i = 0; i < H; i++) dirs[i] = Lt(i);
        dirs[H] = c;
        for (int k = 0; k < T; k++) dirs[H + 1 + k] = Lt(-T + k);
        pos[0] = ORG;
        for (int i = 1; i <= H; i++) pos[i] = P(i);
        for (int k = 0; k < T; k++) pos[H + 1 + k] = P(-T + k);
        pos[N] = ORG;
        if (!full_ok()) return;
        if (CYCLEAF && !cyc_ok()) return;
        if (TAU && tau_leaf_cut()) { st.tauleaf++; return; }
        st.cand++; hitf = true;
        if (REDUCE) {
            int v[MAXN];
            const int shift = (32 - OZ) * S2;
            for (int i = 0; i < N; i++) v[i] = pos[i] + shift;
            int r = red.reducible(v, N, BFS_LIMIT);
            if (r == 1) return;
            if (r == -1) st.bfs_over++;
        }
        st.surv++;
        std::string w(N, ' ');
        for (int i = 0; i < N; i++) w[i] = DC[dirs[i]];
        out.push_back(w);
    }
    void closing() {
        int hp = P(H), tp = P(-T);
        if (mdist(hp, tp) != 1) return;
        int c = -1;
        for (int d = 0; d < 6; d++) if (hp + DELTA[d] == tp) c = d;
        if (H + T >= 1 && c == (Lt(H - 1) ^ 1)) return;                /* no reversal / no U-turn at the closing letter (as in enum.cpp's loop) */
        if (H + T >= 2 && c == (Lt(H - 2) ^ 1)) return;
        if (T == 0 && (c ^ 1) <= Lt(0)) return;        /* DMON4 at the closing letter, as enum.cpp, before counting the node */
        st.nodes++;
        int smn = 0, smx = 0, sdef = 0, pl = 0;
        if (PRIME) { plane_step(c >> 1, c, hp, smn, smx, sdef, pl); if (cdef[0] + cdef[1] + cdef[2] > 0) { plane_undo(c >> 1, smn, smx, sdef, pl); return; } }
        leaf(c);
        if (PRIME) plane_undo(c >> 1, smn, smx, sdef, pl);
    }


    /* number of letters that pass the cheap filters of dfs() at the given end (no obligation update) */
    int count_children(int side, int t, int R) {
        const int from = side ? P(-T) : P(H), other = side ? P(H) : P(-T);
        int c = 0;
        for (int d = 0; d < 6; d++) {
            const int e = side ? (d ^ 1) : d;
            if (!side) { if (d == (Lt(H - 1) ^ 1)) continue; } else { if (e == (Lt(-T) ^ 1)) continue; }
            if (!side) { if (d == (Lt(H - 2) ^ 1)) continue; } else { if (e == (Lt(-T + 1) ^ 1)) continue; }
            const int nx = from + DELTA[d];
            if (R == 1) { c++; continue; }
            if (occ[nx] || !ALLOWED[nx]) continue;
            if (mdist(nx, other) > R - 1) continue;
            if (!side && H == 0 && T >= 1 && !((Lt(-1) ^ 1) > d)) continue;
            if (side && T == 0 && H >= 1 && !(d > Lt(0))) continue;
            const int A = d >> 1;
            if (AXES) {
                int cx = cnt[0], cy = cnt[1], cz = cnt[2];
                if (A == 0) cx++; else if (A == 1) cy++; else cz++;
                int m = cy > cz ? cy : cz;
                if (2 * m + cz > N) continue;
                if (cz > cy + (R - 1) || cy > cx + (R - 1)) continue;
            }
            if (ADAPT >= 2 && (A == 0 || A == 1 || A == 2)) {
                /* also the corner obligation site must not be forbidden (DMON7) */
                int prev = side ? P(-T + 1) : P(H - 1), pl = side ? Lt(-T) : Lt(H - 1);
                int sp = !side ? psi_site(prev, pl, e, nx) : (T >= 1 ? psi_site(nx, e, Lt(-T), P(-T + 1)) : -1);
                if (sp >= 0 && !occ[sp] && !ALLOWED[sp]) continue;
            }
            c++;
        }
        return c;
    }
    /* -adapt 7 state: witness tours saved by probes (per depth, side, letter), inherited candidate masks per depth and side */
    bool trust_step = false;
    int pwn[MAXN + 2][2][6], pwO[MAXN + 2][2][6][4 * MAXN], pwS[MAXN + 2][2][6][4 * MAXN];
    unsigned inh[MAXN + 2][2];
    unsigned long long probes = 0;
    /* letters at the given end that pass the cheap filters (a superset of the letters that pass the full tests) */
    unsigned cheap_mask(int side, int R) {
        const int from = side ? P(-T) : P(H), other = side ? P(H) : P(-T);
        unsigned msk = 0;
        for (int d = 0; d < 6; d++) {
            const int e = side ? (d ^ 1) : d;
            if (!side) { if (d == (Lt(H - 1) ^ 1)) continue; } else { if (e == (Lt(-T) ^ 1)) continue; }
            if (!side) { if (d == (Lt(H - 2) ^ 1)) continue; } else { if (e == (Lt(-T + 1) ^ 1)) continue; }
            const int nx = from + DELTA[d];
            if (occ[nx] || !ALLOWED[nx]) continue;
            if (mdist(nx, other) > R - 1) continue;
            if (!side && H == 0 && T >= 1 && !((Lt(-1) ^ 1) > d)) continue;
            if (side && T == 0 && H >= 1 && !(d > Lt(0))) continue;
            const int A = d >> 1;
            if (AXES) {
                int cx = cnt[0], cy = cnt[1], cz = cnt[2];
                if (A == 0) cx++; else if (A == 1) cy++; else cz++;
                if (SLAB >= 0) {
                    if (2 * cy + cz > N) continue;
                    if (cy > cx + (R - 1)) continue;
                } else {
                    int m = cy > cz ? cy : cz;
                    if (2 * m + cz > N) continue;
                    if (cz > cy + (R - 1) || cy > cx + (R - 1)) continue;
                }
            }
            int prev = side ? P(-T + 1) : P(H - 1), pl = side ? Lt(-T) : Lt(H - 1);
            int sp = (side ? T >= 1 : H >= 1) ? (!side ? psi_site(prev, pl, e, nx) : psi_site(nx, e, pl, prev)) : -1;
            if (sp >= 0 && !occ[sp] && !ALLOWED[sp]) continue;
            msk |= 1u << d;
        }
        return msk;
    }
    unsigned probe_mask(int side, unsigned cand, int t, int R) {
        unsigned m = 0;
        for (int d = 0; d < 6; d++) if ((cand >> d & 1) && step_body(side, d, t, R, true)) m |= 1u << d;
        return m;
    }
    int split_depth = -1, replay_len = 0;
    const std::vector<int> *replay = nullptr;
    std::vector<std::vector<int>> *collect = nullptr;
    int code[MAXN + 1];
    bool step_body(int side, int d, int t, int R, bool probe, bool trust = false) {
        const int from = side ? P(-T) : P(H), other = side ? P(H) : P(-T);
            const int e = side ? (d ^ 1) : d;
            if (t >= 1) { if (!side) { if (d == (Lt(H - 1) ^ 1)) return false; } else { if (e == (Lt(-T) ^ 1)) return false; } }
            if (t >= 2) { if (!side) { if (d == (Lt(H - 2) ^ 1)) return false; } else { if (e == (Lt(-T + 1) ^ 1)) return false; } }
            const int nx = from + DELTA[d];
            if (occ[nx] || !ALLOWED[nx]) return false;
            if (mdist(nx, other) > R - 1) return false;
            if (t == 0 && d == 4) return false;
            if (!side && H == 0 && T >= 1 && !((Lt(-1) ^ 1) > d)) return false;      /* DMON4: reverse of the last letter must exceed the first letter */
            if (side && T == 0 && H >= 1 && !(d > Lt(0))) return false;
            const int A = d >> 1;
            if (AXES) {
                int cx = cnt[0], cy = cnt[1], cz = cnt[2];
                if (A == 0) cx++; else if (A == 1) cy++; else cz++;
                if (SLAB >= 0) {
                    if (2 * cy + cz > N) return false;
                    if (cy > cx + (R - 1)) return false;
                } else {
                    int m = cy > cz ? cy : cz;
                    if (2 * m + cz > N) return false;
                    if (cz > cy + (R - 1) || cy > cx + (R - 1)) return false;
                }
            }
            int smn = 0, smx = 0, sdef = 0, pl = 0; StairSave ss;
            if (PRIME) {
                plane_step(A, d, from, smn, smx, sdef, pl);
                if (STAIR) stair_step(side, A, d, from, ss);
                if (cdef[0] + cdef[1] + cdef[2] > R - 1) { if (STAIR) stair_undo(side, A, ss); plane_undo(A, smn, smx, sdef, pl); return false; }
            }
            if (t >= replay_len && !probe) { st.nodes++; st.dep[t + 1]++; }
            const int ofa = fa[A], ola = la[A], save = nobs;
            int li;
            if (!side) { li = H; Lt(li) = e; P(H + 1) = nx; H++; la[A] = li; if (ofa == NONE) fa[A] = li; }
            else { T++; li = -T; Lt(li) = e; P(-T) = nx; fa[A] = li; if (ola == NONE) la[A] = li; }
            cnt[A]++; occ[nx] = 1; code[t] = d; sumz += CZ[nx] - CZ[ORG];
            Hd = P(H); Tl = P(-T);
            bool ok = true;
            int svlo[3] = {nlo[0], nlo[1], nlo[2]}, svhi[3] = {nhi[0], nhi[1], nhi[2]}, svcd[3] = {cdef[0], cdef[1], cdef[2]};
            bool fchg = false; const int szr4 = zr4, sray = rayidx;
            if ((FACE || PLANE4) && SLAB < 0) {
                ok = face_check(side ? -T : H, side ? -1 : 1, svlo, svhi, fchg);
                if (!ok) st.rej[0][R - 1]++;
                if (ok && fchg && PRIME) {
                    for (int B = 0; B < 3; B++) cdef[B] = owed(B);
                    if (cdef[0] + cdef[1] + cdef[2] > R - 1) { ok = false; st.rej[2][R - 1]++; }
                }
            }
            if (ok) { if (!trust) st.ntest++; trust_step = trust; ok = update2(side, li, nx, ofa, ola, R - 1); trust_step = false; }
            if (ok && probe && (AFLAGS & 4)) { const int m = nwit[t + 1]; pwn[t][side][d] = m;
                if (m) { memcpy(pwO[t][side][d], wO[t + 1], m * sizeof(int)); memcpy(pwS[t][side][d], wS[t + 1], m * sizeof(int)); } }
            if (ok && !probe) { int sl = (R - 1) - mdist(Hd, Tl); if (sl >= 0 && sl <= MAXN) st.slk[R - 1][sl]++; }
            if (ok && !probe) {
                if (t + 1 == split_depth && collect) collect->emplace_back(code, code + t + 1);
                else dfs();
            }
            for (int B = 0; B < 3; B++) { nlo[B] = svlo[B]; nhi[B] = svhi[B]; }
            if (fchg || zr4 != szr4) for (int B = 0; B < 3; B++) cdef[B] = svcd[B];
            zr4 = szr4; rayidx = sray;
            sumz -= CZ[nx] - CZ[ORG]; occ[nx] = 0; cnt[A]--; nobs = save; fa[A] = ofa; la[A] = ola;
            if (!side) H--; else T--;
            if (PRIME && STAIR) stair_undo(side, A, ss);
            if (PRIME) plane_undo(A, smn, smx, sdef, pl);
            return ok;
    }

    int anchor_probe(int R) {
        const int t = H + T; const int *pl = pend[t]; const int nn = npend[t];
        A_BAND++; A_BYR[R][0]++;
        Hd = P(H); Tl = P(-T);
        if (WALK && gwalk3(R, pl, nn)) { A_PLAINDEAD++; A_BYR[R][1]++; return 2; }
        /* first obligation with exactly one reachable site */
        int c = -1;
        for (int a = 0; a < nn && c < 0; a++) {
            const Ob &ob = obs[pl[a]]; int cntr = 0, sc = -1;
            for (int u = 0; u < ob.cnt; u++) { int s = ob.site[u]; if (mdist(Hd, s) + mdist(s, Tl) <= R) { cntr++; sc = s; } }
            if (cntr == 1) c = sc;
        }
        if (c < 0) { A_NOSINGLE++; return 0; }
        A_SINGLE++; A_BYR[R][2]++;
        const int l1 = H >= 1 ? Lt(H - 1) : 7, l2 = H >= 2 ? Lt(H - 2) : 7;
        const int t0 = T >= 1 ? Lt(-T) : -1, t1 = T >= 2 ? Lt(-T + 1) : -1;
        int loc = 0, alive = 0; bool gaveup = false;
        for (int a = 0; a < 6; a++) for (int b = 0; b < 6; b++) {
            if (b == (a ^ 1)) continue;
            const int A = c - DELTA[a], B = c + DELTA[b];
            if (!ALLOWED[A] || !ALLOWED[B] || A == B) continue;
            if (occ[c] || !ALLOWED[c]) continue;
            if (occ[A] && A != Hd) continue;
            if (occ[B] && B != Tl) continue;
            if (A == Tl) continue;
            if (mdist(Hd, A) + mdist(B, Tl) > R - 2) continue;
            if (((R - 2) - (mdist(Hd, A) + mdist(B, Tl))) & 1) continue;
            if (A == Hd) {
                if (l1 < 6 && (a == (l1 ^ 1) || b == (l1 ^ 1))) continue;
                if (l2 < 6 && a == (l2 ^ 1)) continue;
            }
            if (B == Tl) {
                if (t0 >= 0 && (b == (t0 ^ 1) || a == (t0 ^ 1))) continue;
                if (t1 >= 0 && b == (t1 ^ 1)) continue;
            }
            loc++;
            bool dead = gwalk3a(R, pl, nn, c, a, b);
            if (!dead) alive++;
        }
        A_PAIRS_LOC += loc; A_PAIRS_ALIVE += alive;
        if (loc == 0) { A_ANCHOR_NOPAIR++; A_ALLDEAD++; A_BYR[R][3]++; }
        else if (alive == 0) { A_ALLDEAD++; A_BYR[R][3]++; }
        (void)gaveup;
        return (alive == 0) ? 1 : 0;
    }
    bool hitf = false;
    void dfs() {
        const int R0 = N - (H + T);
        __atomic_fetch_add(&G_NODES[R0], 1ull, __ATOMIC_RELAXED);
        int pcode = 0;
        if (ANCHOR_PROBE && R0 >= N / 2 && R0 <= N / 2 + 2 && R0 >= 3) pcode = anchor_probe(R0);
        bool saved = hitf; hitf = false;
        dfs_inner();
        if (hitf) __atomic_fetch_add(&G_USEFUL[R0], 1ull, __ATOMIC_RELAXED);
        if (hitf && pcode) { __atomic_fetch_add(&A_VIOL, 1ull, __ATOMIC_RELAXED); }
        if (hitf && pcode == 1) { __atomic_fetch_add(&A_VIOL1, 1ull, __ATOMIC_RELAXED); }
        hitf = saved || hitf;
    }
    void dfs_inner() {
        int t = H + T, R = N - t;
        if (R == 1) { closing(); return; }
        int side = (t < ALT && (t & 1)) ? 1 : 0;
        if (ADAPT == 1 && t >= ALT && t >= 2) {
            int c0 = count_children(0, t, R), c1 = count_children(1, t, R);
            if (c0 == 0 || c1 == 0) return;
            side = (c1 < c0) ? 1 : 0;
        }
        unsigned mask = 63;
        if (ADAPT == 7) { dfs7(t, R, side); return; }
        if (ADAPT == 8) { dfs8(t, R, side); return; }
        if (ADAPT >= 4 && t >= ALT && t >= 2 && R >= ADAPT_MINR) {
            /* light probes (no tour test); tail first, a forced or dead tail end is taken at once */
            unsigned m0 = 0, m1 = 0; int c0 = 0, c1 = 0;
            LIGHT = (ADAPT == 4);
            for (int d = 0; d < 6; d++) if (step_body(1, d, t, R, true)) { m1 |= 1u << d; c1++; }
            if (c1 == 0) { LIGHT = false; return; }
            if (c1 == 1) { side = 1; mask = m1; }
            else {
                for (int d = 0; d < 6; d++) if (step_body(0, d, t, R, true)) { m0 |= 1u << d; c0++; }
                if (c0 == 0) { LIGHT = false; return; }
                if (c1 < c0) { side = 1; mask = m1; } else { side = 0; mask = m0; }
            }
            LIGHT = false;
            if (ADAPT == 4) mask = 63;   /* light probe passed may still fail the tour: re-test all, cheap filters prune */
        } else if (ADAPT >= 3 && t >= ALT && t >= 2 && R >= ADAPT_MINR) {
            unsigned m0 = 0, m1 = 0; int c0 = 0, c1 = 0;
            for (int d = 0; d < 6; d++) if (step_body(0, d, t, R, true)) { m0 |= 1u << d; c0++; }
            if (c0 == 0) return;
            for (int d = 0; d < 6; d++) if (step_body(1, d, t, R, true)) { m1 |= 1u << d; c1++; }
            if (c1 == 0) return;
            if (c1 < c0) { side = 1; mask = m1; } else { side = 0; mask = m0; }
        } else if (ADAPT >= 3 && t >= ALT && t >= 2) {
            int c0 = count_children(0, t, R), c1 = count_children(1, t, R);
            if (c0 == 0 || c1 == 0) return;
            side = (c1 < c0) ? 1 : 0;
        }
        for (int d = 0; d < 6; d++) {
            if (t < replay_len && d != (*replay)[t]) continue;
            if (!(mask >> d & 1)) continue;
            /* -adapt 6: a child that passed the full probe is re-run without its tests (trust is consumed by update2 of this
               one step only, so the descendants are tested as usual; the probe's witness tour is restored) */
            step_body(side, d, t, R, false, ADAPT == 6 && mask != 63 && (AFLAGS & 4));
        }
    }
    /* -adapt 8: inh[t][s] bits 0..5 = superset of the letters passing at end s, bit 6 = that superset came from a full probe
       of the same end at an ancestor ("known"). The end with fewer candidates is tested (as a probe, then trusted re-run);
       the other end is probed only if it is not known (and QB / the R band allow it). */
    void dfs8(int t, int R, int side) {
        unsigned nk[2] = {63, 63};
        unsigned mask = 63; bool trust = false;
        if (t >= ALT && t >= 2) {
            const bool known[2] = {(inh[t][0] >> 6 & 1) != 0, (inh[t][1] >> 6 & 1) != 0};
            unsigned cand[2] = {inh[t][0] & cheap_mask(0, R), inh[t][1] & cheap_mask(1, R)};
            if (!cand[0] || !cand[1]) return;
            const int p0 = __builtin_popcount(cand[0]), p1 = __builtin_popcount(cand[1]);
            int a = (p1 < p0) ? 1 : 0;
            if ((AFLAGS & 8) && p1 == p0 && known[0] != known[1]) a = known[1] ? 0 : 1;   /* tie: test the unknown end */
            const int b = 1 - a;
            unsigned ma = probe_mask(a, cand[a], t, R);
            if (!ma) return;
            unsigned mb = cand[b]; bool kb = known[b], pb_here = false;
            if (!kb && R >= ADAPT_MINR && R <= ADAPT_MAXR && __builtin_popcount(cand[b]) <= QB &&
                !((AFLAGS & 16) && __builtin_popcount(ma) <= 1)) {
                if (AFLAGS & 32) { LIGHT = true; mb = probe_mask(b, cand[b], t, R); LIGHT = false; kb = true; }
                else { mb = probe_mask(b, cand[b], t, R); kb = true; pb_here = true; }
                if (!mb) return;
            }
            if (__builtin_popcount(mb) < __builtin_popcount(ma)) {
                side = b; mask = mb; trust = pb_here && (AFLAGS & 4);   /* trusted only if b was probed at this node */
                nk[a] = ma | 64u;
            } else {
                side = a; mask = ma; trust = (AFLAGS & 4) != 0;
                nk[b] = mb | (kb ? 64u : 0u);
            }
        }
        for (int d = 0; d < 6; d++) {
            if (t < replay_len && d != (*replay)[t]) continue;
            if (!(mask >> d & 1)) continue;
            inh[t + 1][0] = nk[0]; inh[t + 1][1] = nk[1];
            step_body(side, d, t, R, false, trust);
        }
    }
    void dfs7(int t, int R, int side) {
        unsigned nk[2] = {63, 63};      /* masks inherited by the children for the end that does not move */
        unsigned mask = 63; bool trust = false;
        if (t >= ALT && t >= 2) {
            unsigned cand[2] = {inh[t][0] & cheap_mask(0, R), inh[t][1] & cheap_mask(1, R)};
            if (!cand[0] || !cand[1]) return;
            if (R >= ADAPT_MINR && R <= ADAPT_MAXR) {
                unsigned m[2]; bool got[2] = {false, false};
                int a = (AFLAGS & 1) ? (__builtin_popcount(cand[1]) < __builtin_popcount(cand[0]) ? 1 : 0) : 0, b = 1 - a;
                m[a] = probe_mask(a, cand[a], t, R); got[a] = true; probes++;
                if (!m[a]) return;
                if ((AFLAGS & 1) && __builtin_popcount(m[a]) == 1) side = a;
                else {
                    m[b] = probe_mask(b, cand[b], t, R); got[b] = true;
                    if (!m[b]) return;
                    side = (__builtin_popcount(m[1]) < __builtin_popcount(m[0])) ? 1 : 0;
                }
                mask = m[side]; trust = (AFLAGS & 4) != 0;
                int o = 1 - side;
                nk[o] = got[o] ? m[o] : cand[o];
            } else {
                side = (__builtin_popcount(cand[1]) < __builtin_popcount(cand[0])) ? 1 : 0;
                mask = cand[side]; nk[1 - side] = cand[1 - side];
            }
            if (!(AFLAGS & 2)) { nk[0] = nk[1] = 63; }
        }
        for (int d = 0; d < 6; d++) {
            if (t < replay_len && d != (*replay)[t]) continue;
            if (!(mask >> d & 1)) continue;
            inh[t + 1][0] = nk[0]; inh[t + 1][1] = nk[1];
            step_body(side, d, t, R, false, trust);
        }
    }
    void start() {
        if (!occ_clean) { memset(occ, 0, sizeof occ); occ_clean = true; } else occ[ORG] = 0;
        H = T = 0; nobs = 0; npend[0] = 0; nwit[0] = 0; sumz = 0; tst[0] = -1; zr4 = 0; rayidx = -1;
        for (int A = 0; A < 3; A++) { cnt[A] = 0; fa[A] = la[A] = NONE; }
        memset(crs, 0, sizeof crs); memset(badl, 0, sizeof badl); memset(runm, 0, sizeof runm);
        for (int A = 0; A < 3; A++) { cmn[A] = cmx[A] = cdef[A] = 0; nlo[A] = 1000; nhi[A] = -1000; }
        P(0) = ORG; occ[ORG] = 1;
        for (int k = 0; k <= MAXN + 1; k++) inh[k][0] = inh[k][1] = 63;
        replay_len = 0; replay = nullptr; collect = nullptr; split_depth = -1;
    }
    void run_prefix(const std::vector<int> &pre) {
        start();
        replay = &pre; replay_len = (int)pre.size();
        dfs();
    }
    void collect_prefixes(int depth, std::vector<std::vector<int>> &v) {
        start();
        split_depth = depth; collect = &v;
        dfs();
        collect = nullptr; split_depth = -1;
    }
};

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: enum_bidir N [options]\n"); return 1; }
    N = atoi(argv[1]);
    int threads = (int)std::thread::hardware_concurrency();
    const char *outfile = nullptr;
    for (int i = 2; i < argc; i++) {
        std::string a = argv[i];
        if (a == "-alt") ALT = atoi(argv[++i]);
        else if (a == "-aot") AOT = true;
        else if (a == "-aotm") { AOT = true; AOTM = true; }
        else if (a == "-prime") PRIME = true;
        else if (a == "-stair") STAIR = PRIME = true;
        else if (a == "-aotc") { AOT = true; AOTC = true; }
        else if (a == "-slab") SLAB = atoi(argv[++i]);
        else if (a == "-noaxes") AXES = false;
        else if (a == "-noreduce") REDUCE = false;
        else if (a == "-nopsi") PSI = false;
        else if (a == "-face") FACE = true;
        else if (a == "-adapt") ADAPT = atoi(argv[++i]);
        else if (a == "-adaptr") ADAPT_MINR = atoi(argv[++i]);
        else if (a == "-adaptmaxr") ADAPT_MAXR = atoi(argv[++i]);
        else if (a == "-aflags") AFLAGS = atoi(argv[++i]);
        else if (a == "-qb") QB = atoi(argv[++i]);
        else if (a == "-balz") BALZ = true;
        else if (a == "-stiffx") STIFFX = atoi(argv[++i]);
        else if (a == "-crank") CRANK = true;
        else if (a == "-cycleaf") CYCLEAF = true;
        else if (a == "-tauord") TAUORD = atoi(argv[++i]);
        else if (a == "-tau") TAU = atoi(argv[++i]);
        else if (a == "-tauz") TAUZ = atoi(argv[++i]) != 0;
        else if (a == "-tauax") TAUAX = atoi(argv[++i]) != 0;
        else if (a == "-aotp") AOTP = true;
        else if (a == "-plane4") PLANE4 = true;
        else if (a == "-nomst") NOMST = true;
        else if (a == "-bfs") BFS_LIMIT = atoi(argv[++i]);
        else if (a == "-tourcap") TOUR_CAP = atoi(argv[++i]);
        else if (a == "-split") SPLIT = atoi(argv[++i]);
        else if (a == "-part") { PART_R = atoi(argv[++i]); PART_M = atoi(argv[++i]); }
        else if (a == "-threads") threads = atoi(argv[++i]);
        else if (a == "-out") outfile = argv[++i];
        else if (a == "-rejstats") REJSTATS = true;
        else if (a == "-oracle") ORACLE = atoi(argv[++i]);
        else if (a == "-tstat") TSTAT = true;
        else if (a == "-ax1d") AX1D = true;
        else if (a == "-joint") JK = atoi(argv[++i]);
        else if (a == "-jcap") JCAP = atoi(argv[++i]);
        else if (a == "-jmin") JMIN = atoi(argv[++i]);
        else if (a == "-jonly") JONLY = true;
        else if (a == "-mstonly") MSTONLY = true;
        else if (a == "-hk") HKK = atoi(argv[++i]);
        else if (a == "-hkw") HKW = true;
        else if (a == "-walk") { WALK = true; WALK_LO = atoi(argv[++i]); WALK_HI = atoi(argv[++i]); W3HDP = true; }
        else if (a == "-gwlim") GWLIM = strtoull(argv[++i], nullptr, 10);
        else if (a == "-anchorprobe") ANCHOR_PROBE = true;
        else if (a == "-gwgap") GWGAP = atoi(argv[++i]);
        else if (a == "-gw3let") GW3LET = atoi(argv[++i]);
        else if (a == "-gw3h") W3HDP = atoi(argv[++i]) != 0;
        else { fprintf(stderr, "unknown option %s (enum_bidir has no -bridge)\n", a.c_str()); return 1; }
    }
    if (N < 4 || N > 52 || (N & 1) || (SLAB < 0 && N > 48)) { fprintf(stderr, "N must be even, 4..48 (4..52 with -slab)\n"); return 1; }
    for (int k = 1; k < N; k++) {
        std::vector<int> &o = TORD[k]; o.clear();
        for (int j = 0; j < N - k; j++) o.push_back(j);
        if (TAUORD == 1) std::stable_sort(o.begin() + (N - k > 2 ? 2 : N - k), o.end(), [&](int a, int b) { int ka = std::max(k + a, N - 1 - a), kb = std::max(k + b, N - 1 - b); return ka < kb; });
    }
    if (SPLIT > N - 2) SPLIT = N - 2;
    if (SPLIT < 1) SPLIT = 1;
    for (int p = 0; p < NS; p++) {
        int x = p % S - OX, y = (p / S) % S - OY, z = p / S2 - OZ;
        CX[p] = (signed char)x; CY[p] = (signed char)y; CZ[p] = (signed char)z;
        bool lexgt = z > 0 || (z == 0 && (y > 0 || (y == 0 && x > 0)));
        bool inbox = abs(x) <= 27 && abs(y) <= 27 && z <= 24 && (SLAB < 0 || z <= SLAB);
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
        if (TSTAT || ORACLE) {
            fprintf(stderr, "tourstat ins_pass=%llu mst_kill=%llu tour_ok=%llu tour_fail=%llu giveup=%llu oracle_ok=%llu oracle_fail=%llu oracle_unknown=%llu joint ok/fail/giveup=%llu/%llu/%llu\n", s->ts_ins, s->ts_mst, s->ts_ok, s->ts_fail, s->ts_gu, s->or_ok, s->or_fail, s->or_unk, s->j_ok, s->j_fail, s->j_gu);
            fprintf(stderr, "nn: tour_calls / giveups / oracle_fail:"); for (int k = 0; k < 64; k++) if (s->tr_nn[k]) fprintf(stderr, " %d:%llu/%llu/%llu", k, s->tr_nn[k], s->gu_nn[k], s->gu_fail_nn[k]); fprintf(stderr, "\n");
            fprintf(stderr, "giveups by #multi-site obligations:"); for (int k = 0; k < 64; k++) if (s->gu_multi[k]) fprintf(stderr, " %d:%llu", k, s->gu_multi[k]); fprintf(stderr, "\n");
        }
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
    { unsigned long long tn = 0, tu = 0; fprintf(stderr, "HEADROOM by R (remaining steps): nodes / nodes with a surviving-candidate descendant\n");
      for (int r = 1; r < 80; r++) if (G_NODES[r]) { fprintf(stderr, "  R=%d %llu %llu %.3f\n", r, G_NODES[r], G_USEFUL[r], (double)G_USEFUL[r] / G_NODES[r]); tn += G_NODES[r]; tu += G_USEFUL[r]; }
      fprintf(stderr, "HEADROOM total nodes %llu useful %llu ratio %.4f\n", tn, tu, (double)tu / tn); }
    if (ANCHOR_PROBE) { fprintf(stderr, "ANCHOR band nodes=%llu plain_walk_dead=%llu no_single=%llu single=%llu pairs_after_local=%llu pairs_alive=%llu all_pairs_dead=%llu (of which no local pair=%llu) VIOLATIONS(useful node pruned): any=%llu anchor=%llu\n", A_BAND, A_PLAINDEAD, A_NOSINGLE, A_SINGLE, A_PAIRS_LOC, A_PAIRS_ALIVE, A_ALLDEAD, A_ANCHOR_NOPAIR, A_VIOL, A_VIOL1);
      for (int r = 0; r < 80; r++) if (A_BYR[r][0]) fprintf(stderr, "ANCHOR R=%d nodes=%llu plain_dead=%llu single=%llu anchor_all_dead=%llu\n", r, A_BYR[r][0], A_BYR[r][1], A_BYR[r][2], A_BYR[r][3]); }
    if (SLAB >= 0) fprintf(stderr, "slab=%d ", SLAB);
    if (WALK) fprintf(stderr, "walk calls=%llu with_ray=%llu dead=%llu sitefull=%llu sitefull_by_ray=%llu limit=%llu limit_with_ray=%llu skip=%llu states=%llu\n",
                      total.w3calls, total.w3ray, total.w3dead, total.w3full, total.w3fullray, total.w3over, total.w3overray, total.w3skip, total.w3states);
    fprintf(stderr, "fulltests=%llu ", total.ntest);
    fprintf(stderr, "N=%d alt=%d tasks=%zu part=%d/%d nodes=%llu closed=%llu candidates=%llu survivors=%llu bfs_limit_hits=%llu tour_giveups=%llu tau_decided=%llu tau_rayobs=%llu tau_leafcuts=%llu\n",
            N, ALT, tasks.size(), PART_R, PART_M, total.nodes, total.closed, total.cand, total.surv, total.bfs_over, total.giveup, total.taudec, total.tauob, total.tauleaf);
    if (REJSTATS) {
        fprintf(stderr, "nodes by depth t (steps placed):");
        for (int r = 0; r <= MAXN; r++) if (total.dep[r]) fprintf(stderr, " %d:%llu", r, total.dep[r]);
        fprintf(stderr, "\n");
        for (int r = 1; r <= MAXN; r++) { unsigned long long tot = 0; for (int q = 0; q <= MAXN; q++) tot += total.slk[r][q]; if (!tot) continue;
            fprintf(stderr, "alive R=%d total=%llu slack0=%.3f slack2=%.3f slack4=%.3f slack6+=%.3f\n", r, tot, total.slk[r][0]/(double)tot, total.slk[r][2]/(double)tot, total.slk[r][4]/(double)tot, 1.0 - (total.slk[r][0]+total.slk[r][2]+total.slk[r][4])/(double)tot); }
        fprintf(stderr, "kills by remaining steps R1: R1 no_site unreachable_or_one_free_neighbour aot tour_mst\n");
        for (int r = 0; r <= MAXN; r++) {
            unsigned long long sum = 0; for (int q = 0; q < 4; q++) sum += total.rej[q][r];
            if (!sum) continue;
            fprintf(stderr, "R1=%d %llu %llu %llu %llu\n", r, total.rej[0][r], total.rej[1][r], total.rej[2][r], total.rej[3][r]);
        }
    }
    return 0;
}
