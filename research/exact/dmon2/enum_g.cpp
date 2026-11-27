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
#include <chrono>
#include <deque>
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
static bool FACE = false, PLANE4 = false, AOTP = false, CRANK = false; static int STIFFX = 1000; static bool BALZ = false; static int ADAPT = 0, ADAPT_MINR = 0; static thread_local bool LIGHT = false, TRUSTED = false;
static bool PRIME = false, STAIR = false, AOTC = false;
/* G autopsy */
static int GGAPV = 2; static unsigned long long GWLIM = 100000; static thread_local unsigned long long GWST = 0, GWOVER = 0, GWSKIP = 0, GWDEAD = 0, GWSTD = 0; static int GWGAP = 99; static int GW3LET = 99; static bool GW3BFS = true; static bool W3HDP = false; static thread_local bool W3MODE = false; static unsigned GLEV = 0; static unsigned GPRUNE = 0; static int GRMIN = 0, GRMAX = -1, GDPMAX = 10, GDPM = 40;
static FILE *GREC = nullptr, *GEX = nullptr; static int GEXN = 0, GEXMAX = 40;
static thread_local unsigned long long GK[16];
static thread_local double GTIME = 0; static thread_local unsigned long long GEVALS = 0; static bool GTIMEON = false;
#pragma pack(push, 1)
struct GRec { uint8_t R1, nn, slack, dpskip; uint32_t bits; uint32_t sub, surv, cand, closed, adj; uint32_t kill[14]; uint16_t dHT, dpM, dpB, dpBB, v1, blk; };
#pragma pack(pop)
   /* -prime / -stair: plane-crossing lemma (prime knots, PROOF.md Lemma 3); -aotc: per-axis plane debt in -aot */

static signed char CX[NS], CY[NS], CZ[NS];
static unsigned char ALLOWED[NS];

static inline int mdist(int a, int b) { return abs(CX[a] - CX[b]) + abs(CY[a] - CY[b]) + abs(CZ[a] - CZ[b]); }

struct Stats {
    unsigned long long nodes = 0, closed = 0, cand = 0, surv = 0, bfs_over = 0, giveup = 0;
    unsigned long long rej[4][MAXN + 1]; unsigned long long dep[MAXN + 1]; unsigned long long slk[MAXN + 1][MAXN + 1];   /* 0 no site (curtain/corner) 1 site unreachable 2 aot 3 tour/mst, by remaining steps */
    Stats() { memset(rej, 0, sizeof rej); memset(dep, 0, sizeof dep); memset(slk, 0, sizeof slk); }
    void add(const Stats &o) { nodes += o.nodes; closed += o.closed; cand += o.cand; surv += o.surv; bfs_over += o.bfs_over; giveup += o.giveup;
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
struct Ob { int cnt; int site[MAXN]; };
struct GRes { int dummy = 0; };

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
    unsigned long long tour_calls = 0, tour_giveup = 0;
    Stats st;
    Reducer red;
    std::vector<std::string> out;
    int Hd = 0, Tl = 0;               /* the two end points of the missing middle walk */
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

    Search() { memset(occ, 0, sizeof occ); }

    int curtain2(int j, int i, int back, Ob &ob) {
        ob.cnt = 0;
        for (int k = j + 2; k <= i - 1; k++) {
            int s = P(k) + back;
            if (occ[s]) return 1;
            if (ALLOWED[s]) ob.site[ob.cnt++] = s;
        }
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
        ob.cnt = 1; ob.site[0] = s;
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
            if (ob.cnt != 1) continue;
            int s = ob.site[0], cs = q == 0 ? CX[s] : q == 1 ? CY[s] : CZ[s];
            if (cs < lo) lo = cs; if (cs > hi) hi = cs;
        }
        int l = lo < c0 ? lo : c0, h = hi > c0 ? hi : c0;
        int a1 = (c0 - l) + (h - l) + (h - ct), a2 = (h - c0) + (h - l) + (ct - l);
        int t = a1 < a2 ? a1 : a2;
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
    inline int span_need(int from, const int *pl, int np) const {
        int need = 0;
        need += axis_need(0, CX[from], CX[Tl], pl, np);
        need += axis_need(1, CY[from], CY[Tl], pl, np);
        need += axis_need(2, CZ[from], CZ[Tl], pl, np);
        return need;
    }

    inline int owed_plane(int A, int p, int mn, int mx) const {
        if (p < mn || p >= mx) return 0;
        int c = crs[A][p + 32], req = (p > mn && p < mx - 1) ? 4 : 2;
        if (STAIR && req == 2) {
            if (mx - mn == 1) { if (badl[A][mn + 32] && badl[A][mx + 32]) req = 4; }
            else if (p == mn) { if (badl[A][mn + 32]) req = 4; }
            else { if (badl[A][mx + 32]) req = 4; }
        }
        return c >= req ? (c & 1) : req - c;
    }
    /* per-plane max of plane debt and route crossings, minimised over the two visiting orders */
    inline int plane_route_need(int q, int c0, int ct, const int *pl, int np) const {
        int lo = ct, hi = ct;
        for (int a = 0; a < np; a++) {
            const Ob &ob = obs[pl[a]];
            if (ob.cnt != 1) continue;
            int s = ob.site[0], cs = q == 0 ? CX[s] : q == 1 ? CY[s] : CZ[s];
            if (cs < lo) lo = cs; if (cs > hi) hi = cs;
        }
        int l = lo < c0 ? lo : c0, h = hi > c0 ? hi : c0;
        int mn = cmn[q] < nlo[q] ? cmn[q] : nlo[q], mx = cmx[q] > nhi[q] ? cmx[q] : nhi[q];
        int a = l < mn ? l : mn, b = h > mx ? h : mx;
        int best = 1 << 20;
        for (int o = 0; o < 2; o++) {
            int seq[4] = {c0, o ? h : l, o ? l : h, ct};
            int tot = 0;
            for (int p = a; p < b; p++) {
                int r = 0;
                for (int k = 0; k < 3; k++) { int u = seq[k], v = seq[k + 1]; if ((u <= p) != (v <= p)) r++; }
                int ow = owed_plane(q, p, mn, mx);
                tot += r > ow ? r : ow;
            }
            if (tot < best) best = tot;
        }
        return best;
    }
    inline bool aot_ok(const int *nw, int nn, const int *extra = nullptr) const {
        int L[3];
        for (int q = 0; q < 3; q++) {
            int c0 = q == 0 ? CX[Hd] : q == 1 ? CY[Hd] : CZ[Hd], ct = q == 0 ? CX[Tl] : q == 1 ? CY[Tl] : CZ[Tl];
            int t = axis_need(q, c0, ct, nw, nn);
            if (extra && extra[q] > t) t = extra[q];
            if (AOTC && cdef[q] > t) t = cdef[q];
            if (AOTP && PRIME) { int t2 = plane_route_need(q, c0, ct, nw, nn); if (t2 > t) t = t2; }
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
        if (used + span_need(from, pl, np) > budget) return false;
        if (++tour_calls > (unsigned long long)TOUR_CAP) { gave_up = true; return true; }
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
                    int c = q == m ? mdist(prev, s) + mdist(s, Tl) - mdist(prev, Tl)
                                   : mdist(prev, s) + mdist(s, sv[q]) - mdist(prev, sv[q]);
                    if (c < bestc) { bestc = c; bestp = q; bests = s; }
                }
            }
            for (int q = m; q > bestp; q--) { o[q] = o[q - 1]; sv[q] = sv[q - 1]; }
            o[bestp] = ob_i; sv[bestp] = bests; m++;
        }
        int cost = 0, at = nx;
        for (int q = 0; q < m; q++) { cost += mdist(at, sv[q]); at = sv[q]; }
        cost += mdist(at, Tl);
        if (cost <= R1) { nwit[i1] = m; return true; }
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
            if (total > R1) return false;
        }
        int pl[4 * MAXN];
        memcpy(pl, nw, nn * sizeof(int));
        tour_calls = 0; gave_up = false; capTotal = nn;
        if (!tour(nx, pl, nn, 0, R1)) return false;
        if (gave_up) { tour_giveup++; nwit[i1] = m; return true; }
        for (int q = 0; q < nn; q++) { o[q] = capO[q]; sv[q] = capS[q]; }
        nwit[i1] = nn;
        return true;
    }

    /* ================= G autopsy: obstacle-aware relaxations =================
       bits: 0 B1 bfs distance Hd->Tl in free cells > R1
             1 B2a an obligation has no site s with dH(s)+dT(s) <= R1 (free-cell via-point)
             2 DPM exact tour DP, Manhattan metric
             3 DPB exact tour DP, free-cell BFS metric
             4 BLK an obligation has no site in the Hd-Tl block (block-cut tree)
             5 CNT the Hd-Tl block has fewer free cells (per colour) than the R1-1 interior vertices need
             6 DPBB exact tour DP, BFS metric, sites restricted to the block
             7 PEEL an obligation has all sites peeled (iterated degree <= 1 removal in V1)
             8 AOT01 aot with per-axis 0-1 BFS lower bound Hd->Tl
             9 AOT01V aot with per-axis 0-1 BFS lower bound via each obligation */
    std::vector<unsigned> gsH, gsT, gsS, gsB, gsP, gsD, gsZ; std::vector<short> gdH, gdT, gdS, gdeg, gzH, gzT;
    std::vector<int> gq, glow, gdisc, gf; unsigned gep = 0, gepS = 0, gepZ = 0;
    inline bool gfree(int c) const { return !occ[c] && ALLOWED[c]; }
    void ginit() {
        if (!gsH.empty()) return;
        gsH.assign(NS, 0); gsT.assign(NS, 0); gsS.assign(NS, 0); gsB.assign(NS, 0); gsP.assign(NS, 0); gsD.assign(NS, 0); gsZ.assign(NS, 0);
        gdH.assign(NS, 0); gdT.assign(NS, 0); gdS.assign(NS, 0); gdeg.assign(NS, 0); gzH.assign(NS, 0); gzT.assign(NS, 0);
        gq.assign(NS + 16, 0); glow.assign(NS, 0); gdisc.assign(NS, 0);
    }
    inline bool inV1(int c) const { return gsT[c] == gep; }
    /* exact tour DP: m distinct site cells, cover[i] = obligations (local bits) containing cell i */
    int gdp(int k, int m, const unsigned *cover, const int *d0, const int *dt, const int *dm, int R1) {
        if (k == 0) return -2;
        unsigned full = (1u << k) - 1, any = 0;
        for (int i = 0; i < m; i++) any |= cover[i];
        if (any != full) return 1 << 20;
        const int INF = 1 << 20;
        gf.assign((size_t)(full + 1) * m, INF);
        for (int i = 0; i < m; i++) if (d0[i] + dt[i] <= R1 && d0[i] < gf[(size_t)cover[i] * m + i]) gf[(size_t)cover[i] * m + i] = d0[i];
        int best = INF;
        for (unsigned mask = 1; mask <= full; mask++)
            for (int i = 0; i < m; i++) {
                int v = gf[(size_t)mask * m + i]; if (v >= INF) continue;
                if (mask == full) { if (v + dt[i] < best) best = v + dt[i]; continue; }
                for (int j = 0; j < m; j++) {
                    if (!(cover[j] & ~mask)) continue;
                    int w = v + dm[i * m + j]; if (w + dt[j] > R1) continue;
                    unsigned nm = mask | cover[j];
                    if (w < gf[(size_t)nm * m + j]) gf[(size_t)nm * m + j] = w;
                }
            }
        return best;
    }
    struct GSite { int cell; unsigned cover; };
    int gsites(const int *nw, int nn, int mode, GSite *out, int R1) {  /* mode 0: Manhattan reach, 1: V1, 2: block */
        int m = 0;
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]];
            for (int u = 0; u < ob.cnt; u++) {
                int s = ob.site[u];
                bool okc = mode == 0 ? (mdist(Hd, s) + mdist(s, Tl) <= R1) : mode == 1 ? inV1(s) : (gsB[s] == gep);
                if (!okc) continue;
                int f = -1; for (int i = 0; i < m; i++) if (out[i].cell == s) { f = i; break; }
                if (f < 0) { if (m >= GDPM) return -1; out[m].cell = s; out[m].cover = 0; f = m++; }
                out[f].cover |= 1u << a;
            }
        }
        return m;
    }
    /* bfs from a site within V1, distances to the given cells (INF if > lim) */
    void gbfs_site(int s, int R1, const GSite *si, int m, int *row) {
        if (++gepS == 0) { std::fill(gsS.begin(), gsS.end(), 0); gepS = 1; }
        int lim = R1 - gdH[s];
        int qh = 0, qt = 0; gq[qt++] = s; gsS[s] = gepS; gdS[s] = 0;
        while (qh < qt) {
            int p = gq[qh++], d = gdS[p];
            for (int k = 0; k < 6; k++) {
                int q = p + DELTA[k];
                if (!inV1(q) || gsS[q] == gepS) continue;
                if (d + 1 + gdT[q] > lim) continue;
                gsS[q] = gepS; gdS[q] = d + 1; gq[qt++] = q;
            }
        }
        for (int j = 0; j < m; j++) row[j] = gsS[si[j].cell] == gepS ? gdS[si[j].cell] : (1 << 20);
    }
    void gzbfs(int src, int q, std::vector<short> &z) {   /* 0-1 BFS: cost 1 per step on axis q, over V1 cells, src and Hd/Tl as end points */
        if (++gepZ == 0) { std::fill(gsZ.begin(), gsZ.end(), 0); gepZ = 1; }
        std::deque<int> dq; dq.push_back(src); gsZ[src] = gepZ; z[src] = 0;
        static thread_local std::vector<unsigned char> done; if (done.empty()) done.assign(NS, 0);
        std::vector<int> touched;
        while (!dq.empty()) {
            int p = dq.front(); dq.pop_front();
            if (done[p]) continue; done[p] = 1; touched.push_back(p);
            if (p != src && (p == Hd || p == Tl)) continue;   /* end points are not passed through */
            for (int k = 0; k < 6; k++) {
                int r = p + DELTA[k];
                if (!(inV1(r) || r == Hd || r == Tl)) continue;
                int w = z[p] + ((k >> 1) == q ? 1 : 0);
                if (gsZ[r] == gepZ && z[r] <= w) continue;
                gsZ[r] = gepZ; z[r] = w;
                if ((k >> 1) == q) dq.push_back(r); else dq.push_front(r);
            }
        }
        for (int p : touched) done[p] = 0;
    }
    struct GOut { int dHT = 0, dpM = -1, dpB = -1, dpBB = -1, v1 = 0, blk = 0; bool dpskip = false; };
    GOut gout;
    unsigned geval(int R1, const int *nw, int nn, unsigned need, GRes &) {
        ginit();
        GOut &o = gout; o = GOut();
        if (need & 0x80000) { if (gwalk3(R1, nw, nn)) return 0xfffff; if (!(need & 0x7ffff)) return 0; }
        if (need & 0x40000) { if (gwalk2(R1, nw, nn)) return 0xfffff; if (!(need & 0x3ffff)) return 0; }
        if (need & 0x20000) { if (gwalk(R1, nw, nn)) return 0x7ffff; if (!(need & 0x1ffff)) return 0; }
        if (need & 0x10000) {
            int g = gmanh(R1, nw, nn);
            if (g > R1) return 0x7ffff;
            if (g >= 0 && R1 - g > GGAP) return 0;
            need |= 0x8000;
        }
        if (++gep == 0) { for (auto *v : {&gsH, &gsT, &gsB, &gsP, &gsD}) std::fill(v->begin(), v->end(), 0); gep = 1; }
        const unsigned ALL = 0xfffff;
        /* B1: bfs from Hd */
        int qh = 0, qt = 0, dHT = 1 << 20;
        gq[qt++] = Hd; gsH[Hd] = gep; gdH[Hd] = 0;
        while (qh < qt) {
            int p = gq[qh++], d = gdH[p];
            for (int k = 0; k < 6; k++) {
                int q = p + DELTA[k];
                if (q == Tl) { if (d + 1 < dHT) dHT = d + 1; continue; }
                if (!gfree(q) || gsH[q] == gep) continue;
                if (d + 1 + mdist(q, Tl) > R1) continue;
                gsH[q] = gep; gdH[q] = d + 1; gq[qt++] = q;
            }
        }
        o.dHT = dHT;
        if (dHT > R1) return ALL;
        unsigned bits = 0;
        if (!(need & ~1u)) return bits;
        /* bfs from Tl within the Hd field: V1 = cells with dH + dT <= R1 */
        qh = qt = 0; gq[qt++] = Tl; gsT[Tl] = gep; gdT[Tl] = 0; gdH[Tl] = dHT;
        int v1 = 0;
        while (qh < qt) {
            int p = gq[qh++], d = gdT[p];
            for (int k = 0; k < 6; k++) {
                int q = p + DELTA[k];
                if (q == Hd || gsH[q] != gep || gsT[q] == gep) continue;
                if (d + 1 + gdH[q] > R1) continue;
                gsT[q] = gep; gdT[q] = d + 1; gq[qt++] = q; v1++;
            }
        }
        gsT[Tl] = 0;   /* Tl is not a V1 cell */
        o.v1 = v1;
        gdT[Hd] = dHT; gdH[Tl] = dHT;
        if (need & 0x8000) { if (gfast(R1, nw, nn)) bits |= 0x18000; if (!(need & 0x7fff & ~1u)) return bits; }
        bits |= gtail(R1, nw, nn, need);
        return bits;
    }
    /* GT (bit 15): exact tour DP in the free-cell metric after reduction of the obligations.
       1. drop sites outside V1; an obligation left empty kills.
       2. drop an obligation whose site set contains the site set of another (it is satisfied whenever the other is).
       3. bfs from each remaining distinct site within V1, then DP over (obligations visited, last site). */
    int gt_k = 0, gt_m = 0;
    bool gfast(int R1, const int *nw, int nn) {
        static thread_local unsigned long long msk[4 * MAXN][1];   /* site set as bitmask over distinct cells (<= 64) */
        static thread_local int cell[64]; int m = 0;
        static thread_local int obl[4 * MAXN]; int k = 0;
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]]; unsigned long long b = 0;
            for (int u = 0; u < ob.cnt; u++) {
                int s = ob.site[u]; if (!inV1(s)) continue;
                int f = -1; for (int i = 0; i < m; i++) if (cell[i] == s) { f = i; break; }
                if (f < 0) { if (m >= 64) return false; cell[m] = s; f = m++; }
                b |= 1ull << f;
            }
            if (!b) return true;
            msk[k][0] = b; obl[k] = a; k++;
        }
        /* domination: keep j unless some other i has msk_i subset of msk_j (ties: keep the first) */
        static thread_local unsigned long long keep[4 * MAXN]; int kk = 0;
        for (int j = 0; j < k; j++) {
            bool dom = false;
            for (int i = 0; i < k && !dom; i++) {
                if (i == j) continue;
                unsigned long long a = msk[i][0], b = msk[j][0];
                if ((a & ~b) == 0 && (a != b || i < j)) dom = true;
            }
            if (!dom) keep[kk++] = msk[j][0];
        }
        gt_k = kk;
        if (kk == 0) return false;
        if (kk > 12) return false;                 /* give up (sound) */
        /* compact the cells actually used */
        unsigned long long used = 0; for (int j = 0; j < kk; j++) used |= keep[j];
        static thread_local GSite si[64]; static thread_local unsigned cov[64]; static thread_local int d0[64], dt[64], dm[64 * 64];
        int mm = 0;
        for (int i = 0; i < m; i++) if (used >> i & 1) {
            unsigned c = 0; for (int j = 0; j < kk; j++) if (keep[j] >> i & 1) c |= 1u << j;
            si[mm].cell = cell[i]; si[mm].cover = c; cov[mm] = c; d0[mm] = gdH[cell[i]]; dt[mm] = gdT[cell[i]]; mm++;
        }
        gt_m = mm;
        if (kk == 1) { for (int i = 0; i < mm; i++) if (d0[i] + dt[i] <= R1) return false; return true; }
        for (int i = 0; i < mm; i++) gbfs_site(si[i].cell, R1, si, mm, dm + i * mm);
        int v = gdp(kk, mm, cov, d0, dt, dm, R1);
        return v > R1;
    }
    /* Manhattan exact tour after reduction (no bfs). Returns the least tour length (> R1 means dead). */
    int GGAP = GGAPV;
    int gmanh(int R1, const int *nw, int nn) {
        static thread_local unsigned long long msk[4 * MAXN]; static thread_local int cell[64]; int m = 0, k = 0;
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]]; unsigned long long b = 0;
            for (int u = 0; u < ob.cnt; u++) {
                int s = ob.site[u]; if (mdist(Hd, s) + mdist(s, Tl) > R1) continue;
                int f = -1; for (int i = 0; i < m; i++) if (cell[i] == s) { f = i; break; }
                if (f < 0) { if (m >= 64) return -1; cell[m] = s; f = m++; }
                b |= 1ull << f;
            }
            if (!b) return 1 << 20;
            msk[k++] = b;
        }
        static thread_local unsigned long long keep[4 * MAXN]; int kk = 0;
        for (int j = 0; j < k; j++) {
            bool dom = false;
            for (int i = 0; i < k && !dom; i++) { if (i == j) continue; unsigned long long a = msk[i], b = msk[j]; if ((a & ~b) == 0 && (a != b || i < j)) dom = true; }
            if (!dom) keep[kk++] = msk[j];
        }
        if (kk == 0) return mdist(Hd, Tl);
        if (kk > 12) return -1;
        unsigned long long used = 0; for (int j = 0; j < kk; j++) used |= keep[j];
        static thread_local unsigned cov[64]; static thread_local int d0[64], dt[64], dm[64 * 64], cl[64]; int mm = 0;
        for (int i = 0; i < m; i++) if (used >> i & 1) { unsigned c = 0; for (int j = 0; j < kk; j++) if (keep[j] >> i & 1) c |= 1u << j; cov[mm] = c; cl[mm] = cell[i]; d0[mm] = mdist(Hd, cell[i]); dt[mm] = mdist(cell[i], Tl); mm++; }
        for (int i = 0; i < mm; i++) for (int j = 0; j < mm; j++) dm[i * mm + j] = mdist(cl[i], cl[j]);
        return gdp(kk, mm, cov, d0, dt, dm, R1);
    }
    /* GW (bit 17): is there a walk of at most R1 steps from Hd to Tl through free cells that visits a site of every
       pending obligation?  Depth-first search over states (cell, set of obligations visited), with the admissible
       Manhattan bound h and a memo of the least depth at which each state was reached. Exact for walks (= DPB). */
    std::vector<unsigned> gwS; std::vector<unsigned char> gwD; unsigned gwep = 0;
    std::vector<unsigned> gcS; std::vector<unsigned char> gcM; unsigned gcep = 0;
    int gw_k = 0, gw_m = 0, gw_R = 0; unsigned gw_full = 0; int gw_cell[64]; unsigned gw_cov[64];
    unsigned long long gw_states = 0, gw_limit = 0; bool gw_over = false;
    static const int GWK = 6;
    inline int gw_h(int q, unsigned mask) const {
        int h = mdist(q, Tl);
        for (int o = 0; o < gw_k; o++) {
            if (mask >> o & 1) continue;
            int b = 1 << 20;
            for (int i = 0; i < gw_m; i++) if (gw_cov[i] >> o & 1) { int v = mdist(q, gw_cell[i]) + mdist(gw_cell[i], Tl); if (v < b) b = v; }
            if (b > h) h = b;
        }
        return h;
    }
    bool gw_dfs(int q, unsigned mask, int d) {
        if (++gw_states > gw_limit) { gw_over = true; return true; }
        int nb[6], hv[6], nm[6], c = 0;
        for (int k = 0; k < 6; k++) {
            int r = q + DELTA[k];
            if (r == Tl) { if (mask == gw_full) return true; continue; }
            if (occ[r] || !ALLOWED[r]) continue;
            unsigned m2 = mask | (gcS[r] == gcep ? gcM[r] : 0);
            int h = gw_h(r, m2);
            if (d + 1 + h > gw_R) continue;
            size_t id = (size_t)r * 64 + m2;
            if (gwS[id] == gwep && gwD[id] <= d + 1) continue;
            gwS[id] = gwep; gwD[id] = (unsigned char)(d + 1);
            nb[c] = r; hv[c] = h; nm[c] = m2; c++;
        }
        for (int a = 1; a < c; a++) { int x = nb[a], y = hv[a], z = nm[a], b = a - 1; while (b >= 0 && hv[b] > y) { nb[b + 1] = nb[b]; hv[b + 1] = hv[b]; nm[b + 1] = nm[b]; b--; } nb[b + 1] = x; hv[b + 1] = y; nm[b + 1] = z; }
        for (int a = 0; a < c; a++) if (gw_dfs(nb[a], nm[a], d + 1)) return true;
        return false;
    }
    bool gwalk(int R1, const int *nw, int nn) {   /* true = dead */
        if (gwS.empty()) { gwS.assign((size_t)NS * 64, 0); gwD.assign((size_t)NS * 64, 0); gcS.assign(NS, 0); gcM.assign(NS, 0); }
        static thread_local unsigned long long msk[4 * MAXN]; static thread_local int cell[64]; int m = 0, k = 0;
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]]; unsigned long long b = 0;
            for (int u = 0; u < ob.cnt; u++) {
                int s = ob.site[u]; if (mdist(Hd, s) + mdist(s, Tl) > R1) continue;
                int f = -1; for (int i = 0; i < m; i++) if (cell[i] == s) { f = i; break; }
                if (f < 0) { if (m >= 64) return false; cell[m] = s; f = m++; }
                b |= 1ull << f;
            }
            if (!b) return true;
            msk[k++] = b;
        }
        static thread_local unsigned long long keep[4 * MAXN]; static thread_local int ksz[4 * MAXN]; int kk = 0;
        for (int j = 0; j < k; j++) {
            bool dom = false;
            for (int i = 0; i < k && !dom; i++) { if (i == j) continue; unsigned long long a = msk[i], b = msk[j]; if ((a & ~b) == 0 && (a != b || i < j)) dom = true; }
            if (!dom) { keep[kk] = msk[j]; ksz[kk] = __builtin_popcountll(msk[j]); kk++; }
        }
        if (kk > GWK) {   /* keep the GWK obligations with the fewest sites (dropping obligations is a relaxation) */
            for (int a = 1; a < kk; a++) { unsigned long long x = keep[a]; int y = ksz[a], b = a - 1; while (b >= 0 && ksz[b] > y) { keep[b + 1] = keep[b]; ksz[b + 1] = ksz[b]; b--; } keep[b + 1] = x; ksz[b + 1] = y; }
            kk = GWK;
        }
        if (++gcep == 0) { std::fill(gcS.begin(), gcS.end(), 0); gcep = 1; }
        if (++gwep == 0) { std::fill(gwS.begin(), gwS.end(), 0); gwep = 1; }
        gw_k = kk; gw_full = (1u << kk) - 1; gw_m = 0; gw_R = R1;
        unsigned long long used = 0; for (int j = 0; j < kk; j++) used |= keep[j];
        for (int i = 0; i < m; i++) if (used >> i & 1) {
            unsigned c = 0; for (int j = 0; j < kk; j++) if (keep[j] >> i & 1) c |= 1u << j;
            gw_cell[gw_m] = cell[i]; gw_cov[gw_m] = c; gw_m++; gcS[cell[i]] = gcep; gcM[cell[i]] = (unsigned char)c;
        }
        gw_states = 0; gw_over = false; gw_limit = GWLIM;
        if (gw_h(Hd, 0) > R1) return true;
        gwS[(size_t)Hd * 64] = gwep; gwD[(size_t)Hd * 64] = 0;
        bool ok = gw_dfs(Hd, 0, 0);
        GWST += gw_states; if (gw_over) GWOVER++;
        return !ok;
    }
    /* GW2 (bit 18): the same walk search as GW, engineered: site coordinates in registers, hash memo. */
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
    inline bool w_memo(unsigned key, int d) {
        unsigned hsh = (key * 2654435761u) >> 17;
        for (;;) {
            unsigned long long &e = ghT[hsh];
            if ((unsigned)(e >> 32) != gh_ep) { e = ((unsigned long long)gh_ep << 32) | ((unsigned long long)key << 8) | (unsigned)d; w_ins++; return true; }
            if (((e >> 8) & 0xffffff) == key) { if ((int)(e & 0xff) <= d) return false; e = (e & ~0xffull) | (unsigned)d; return true; }
            hsh = (hsh + 1) & (GHC - 1);
        }
    }
    int w_dfs(int q, unsigned mask, int d) {   /* 1 found, 0 none, -1 limit */
        if (++w_states > (unsigned long long)GWLIM || w_ins > (GHC * 3 >> 2) - 8) return -1;
        int nb[6], hv[6]; unsigned nm[6]; int c = 0;
        for (int k = 0; k < 6; k++) {
            int r = q + DELTA[k];
            if (r == Tl) { if (mask == w_full) return 1; continue; }
            if (occ[r] || !ALLOWED[r]) continue;
            unsigned m2 = mask | (gcS[r] == gcep ? gcM[r] : 0);
            int h = w_h(r, m2);
            if (d + 1 + h > w_R) continue;
            if (!w_memo((unsigned)r * 64 + m2, d + 1)) continue;
            int b = c - 1; while (b >= 0 && hv[b] > h) { nb[b + 1] = nb[b]; hv[b + 1] = hv[b]; nm[b + 1] = nm[b]; b--; }
            nb[b + 1] = r; hv[b + 1] = h; nm[b + 1] = m2; c++;
        }
        for (int a = 0; a < c; a++) { int v = w_dfs(nb[a], nm[a], d + 1); if (v) return v; }
        return 0;
    }
    bool gwalk2(int R1, const int *nw, int nn) {   /* true = dead */
        if (ghT.empty()) { ghT.assign(GHC, 0); gcS.assign(NS, 0); gcM.assign(NS, 0); }
        int cell[64]; unsigned long long msk[4 * MAXN]; int m = 0, k = 0;
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]]; unsigned long long b = 0;
            for (int u = 0; u < ob.cnt; u++) {
                int s = ob.site[u]; if (mdist(Hd, s) + mdist(s, Tl) > R1) continue;
                int f = -1; for (int i = 0; i < m; i++) if (cell[i] == s) { f = i; break; }
                if (f < 0) { if (m >= 64) return false; cell[m] = s; f = m++; }
                b |= 1ull << f;
            }
            if (!b) return true;
            msk[k++] = b;
        }
        unsigned long long keep[4 * MAXN]; int ksz[4 * MAXN], kk = 0;
        for (int j = 0; j < k; j++) {
            bool dom = false; unsigned long long b = msk[j];
            for (int i = 0; i < k && !dom; i++) { if (i == j) continue; unsigned long long a = msk[i]; if ((a & ~b) == 0 && (a != b || i < j)) dom = true; }
            if (!dom) { keep[kk] = b; ksz[kk] = __builtin_popcountll(b); kk++; }
        }
        if (kk == 0 && !W3MODE) return false;     /* the bfs distance alone: not tested here */
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
        { int h0 = w_h(Hd, 0); if (h0 > R1) return true; if (R1 - h0 > GWGAP) { GWSKIP++; return false; } }
        int v;
        if (W3MODE) {
            w3_t0 = T >= 1 ? Lt(-T) : -1; w3_t1 = T >= 2 ? Lt(-T + 1) : -1;
            int l1 = H >= 1 ? Lt(H - 1) : 7, l2 = H >= 2 ? Lt(H - 2) : 7;   /* 7: no letter (7^1 = 6 matches no direction) */
            v = GW3BFS ? w3_bfs(l1, l2) : w3_dfs(Hd, 0, 0, l1, l2);
        } else { w_memo((unsigned)Hd * 64, 0); v = w_dfs(Hd, 0, 0); }
        GWST += w_states; if (v < 0) GWOVER++; if (v == 0) { GWDEAD++; GWSTD += w_states; }
        return v == 0;
    }
    /* GW3 (bit 19): GW2 plus the letter rules of DMON (no reversal, no U-turn: letter i+2 is not the reverse of
       letter i), at the junction with the head's last two letters, inside the walk, and at the junction with the
       tail's first two letters. State = (cell, last two letters, obligations visited). */
    int w3_t0 = -1, w3_t1 = -1;
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
        if (ghH.empty()) { ghH.assign(GHC >> 1, 0); w3q.resize(1 << 20); }
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
        for (int a = 0; a < c; a++) { int v = (d + 1 < GW3LET) ? w3_dfs(nb[a], nm[a], d + 1, kd[a], l1) : w3_dfs(nb[a], nm[a], d + 1, 6, 6); if (v) return v; }
        return 0;
    }
    bool gwalk3(int R1, const int *nw, int nn) {
        W3MODE = true; bool r = gwalk2(R1, nw, nn); W3MODE = false; return r;
    }
    /* GW3 by breadth-first layers: every state (cell, last two letters, obligations visited) is expanded once.
       h(cell, mask) is cached (it does not depend on the letters). */
    std::vector<unsigned long long> ghH; std::vector<unsigned> w3q;
    inline int w_hc(int r, unsigned m2) {
        unsigned key = (unsigned)r * 64 + m2, hsh = (key * 2654435761u) >> 18;
        for (;;) {
            unsigned long long &e = ghH[hsh];
            if ((unsigned)(e >> 40) != (gh_ep & 0xffffff)) { int h = w_h(r, m2); if (++w_hins > (GHC >> 2)) return h; e = ((unsigned long long)(gh_ep & 0xffffff) << 40) | ((unsigned long long)key << 8) | (unsigned)(h > 255 ? 255 : h); return h; }
            if (((e >> 8) & 0xffffffffull) == key) return (int)(e & 0xff);
            hsh = (hsh + 1) & ((GHC >> 1) - 1);
        }
    }
    int w3_bfs(int l1s, int l2s) {   /* 1 found, 0 none, -1 limit */
        if (ghH.empty()) { ghH.assign(GHC >> 1, 0); w3q.resize(1 << 20); }
        /* state word: cell (17 bits) | l1 (3) | l2 (3) | mask (6) -> 29 bits */
        auto pack = [](int c, int a, int b, unsigned m) { return ((unsigned)c << 12) | ((unsigned)a << 9) | ((unsigned)b << 6) | m; };
        size_t qh = 0, qt = 0; w3q[qt++] = pack(Hd, l1s & 7, l2s & 7, 0);
        for (int d = 0; qh < qt; d++) {
            size_t end = qt;
            for (; qh < end; qh++) {
                unsigned s = w3q[qh]; int q = s >> 12, l1 = (s >> 9) & 7, l2 = (s >> 6) & 7; unsigned mask = s & 63;
                if (++w_states > (unsigned long long)GWLIM || w_ins > (GHC * 3 >> 2) - 8) return -1;
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
                    unsigned ns = pack(r, k, l1, m2);
                    if (!w3_memo(ns, d + 1)) continue;
                    if (d + 1 + w_hc(r, m2) > w_R) continue;
                    if (qt >= w3q.size()) return -1;
                    w3q[qt++] = ns;
                }
            }
        }
        return 0;
    }
    unsigned gtail(int R1, const int *nw, int nn, unsigned need) {
        GOut &o = gout; unsigned bits = 0;
        bool inf_b2a = false;
        for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; bool f = false; for (int u = 0; u < ob.cnt && !f; u++) f = inV1(ob.site[u]); if (!f) inf_b2a = true; }
        if (inf_b2a) bits |= 0x2 | 0x8 | 0x10 | 0x40 | 0x80;
        /* PEEL */
        if ((need & 0x80) && !inf_b2a) {
            int qh = 0, qt = 0;
            /* V1 cells are those with gsT == gep; recover them by scanning the Hd field queue is gone: rescan via BFS from Tl again */
            /* collect V1 cells */
            static thread_local std::vector<int> cells; cells.clear();
            {   int h = 0; std::vector<int> &Q = gq; int t2 = 0; Q[t2++] = Tl; gsP[Tl] = gep;
                while (h < t2) { int p = Q[h++]; for (int k = 0; k < 6; k++) { int q = p + DELTA[k]; if (inV1(q) && gsP[q] != gep) { gsP[q] = gep; Q[t2++] = q; cells.push_back(q); } } } }
            /* gsP == gep now marks V1 cells reachable (all of V1); reuse gdeg for degree, peeled := gdeg = -1 */
            for (int c : cells) { int dg = 0; for (int k = 0; k < 6; k++) { int q = c + DELTA[k]; if (inV1(q) || q == Hd || q == Tl) dg++; } gdeg[c] = dg; }
            for (int c : cells) if (gdeg[c] <= 1) { gq[qt++] = c; gdeg[c] = -1; }
            while (qh < qt) { int c = gq[qh++]; for (int k = 0; k < 6; k++) { int q = c + DELTA[k]; if (inV1(q) && gdeg[q] >= 0) { if (--gdeg[q] <= 1) { gdeg[q] = -1; gq[qt++] = q; } } } }
            for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; bool f = false; for (int u = 0; u < ob.cnt && !f; u++) f = inV1(ob.site[u]) && gdeg[ob.site[u]] >= 0; if (!f) { bits |= 0x80; break; } }
        }
        /* BLOCK of G + (Hd,Tl) containing the edge (Hd,Tl) */
        bool haveB = false;
        if (need & 0x70) {
            haveB = true;
            struct Fr { int u, p, i; };
            static thread_local std::vector<Fr> fr; static thread_local std::vector<int> vs;
            fr.clear(); vs.clear(); int tm = 0;
            auto isv = [&](int v) { return v == Hd || v == Tl || inV1(v); };
            gsD[Hd] = gep; gdisc[Hd] = glow[Hd] = ++tm; vs.push_back(Hd); fr.push_back({Hd, -1, 0});
            int blk = 0, bc0 = 0, bc1 = 0; bool found = false;
            while (!fr.empty() && !found) {
                Fr &f = fr.back(); int u = f.u;
                if (f.i <= 6) {
                    int v;
                    if (f.i == 0) v = (u == Hd) ? Tl : (u == Tl ? Hd : -1); else v = u + DELTA[f.i - 1];
                    f.i++;
                    if (v < 0 || !isv(v)) continue;
                    if (u == Hd && f.i > 1) continue;     /* only the virtual edge out of the root matters */
                    if (gsD[v] != gep) { gsD[v] = gep; gdisc[v] = glow[v] = ++tm; vs.push_back(v); fr.push_back({v, u, 0}); }
                    else if (v != f.p) { if (gdisc[v] < glow[u]) glow[u] = gdisc[v]; }
                } else {
                    fr.pop_back();
                    if (fr.empty()) break;
                    int p = fr.back().u;
                    if (glow[u] < glow[p]) glow[p] = glow[u];
                    if (glow[u] >= gdisc[p]) {
                        bool ours = (p == Hd && u == Tl);
                        for (;;) { int x = vs.back(); vs.pop_back(); if (ours) { gsB[x] = gep; if (x != Tl) { blk++; if ((CX[x] + CY[x] + CZ[x]) & 1) bc1++; else bc0++; } } if (x == u) break; }
                        if (ours) { gsB[Hd] = gep; found = true; }
                    }
                }
            }
            o.blk = blk;
            /* BLK */
            for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; bool f = false; for (int u = 0; u < ob.cnt && !f; u++) f = gsB[ob.site[u]] == gep && ob.site[u] != Hd && ob.site[u] != Tl; if (!f) { bits |= 0x10; break; } }
            /* CNT: interior vertices 1..R1-1, vertex i has colour col(Hd) ^ (i & 1) */
            int ch = (CX[Hd] + CY[Hd] + CZ[Hd]) & 1, need0 = 0, need1 = 0;
            for (int i = 1; i <= R1 - 1; i++) { int c = ch ^ (i & 1); if (c) need1++; else need0++; }
            if (blk < R1 - 1 || bc0 < need0 || bc1 < need1) bits |= 0x20;
        }
        /* DPs */
        if ((need & 0x4c) && nn > 0) {
            if (nn > GDPMAX) o.dpskip = true;
            else {
                static thread_local GSite si[64]; static thread_local int d0[64], dt[64], dm[64 * 64];
                if (need & 0x4) {
                    int m = gsites(nw, nn, 0, si, R1);
                    if (m < 0) o.dpskip = true; else {
                        for (int i = 0; i < m; i++) { d0[i] = mdist(Hd, si[i].cell); dt[i] = mdist(si[i].cell, Tl); for (int j = 0; j < m; j++) dm[i * m + j] = mdist(si[i].cell, si[j].cell); }
                        static thread_local unsigned cov[64]; for (int i = 0; i < m; i++) cov[i] = si[i].cover;
                        int v = gdp(nn, m, cov, d0, dt, dm, R1); o.dpM = v > 60000 ? 65535 : v;
                        if (v > R1) bits |= 0x4;
                    }
                }
                if ((need & 0x48) && !inf_b2a) {
                    int m = gsites(nw, nn, 1, si, R1);
                    if (m < 0) o.dpskip = true; else {
                        static thread_local unsigned cov[64];
                        for (int i = 0; i < m; i++) { cov[i] = si[i].cover; d0[i] = gdH[si[i].cell]; dt[i] = gdT[si[i].cell]; gbfs_site(si[i].cell, R1, si, m, dm + i * m); }
                        if (need & 0x8) { int v = gdp(nn, m, cov, d0, dt, dm, R1); o.dpB = v > 60000 ? 65535 : v; if (v > R1) bits |= 0x8; }
                        if ((need & 0x40) && haveB) {
                            /* restrict to block cells */
                            int m2 = 0; static thread_local int idx[64]; static thread_local unsigned cov2[64]; static thread_local int e0[64], et[64], em[64 * 64];
                            for (int i = 0; i < m; i++) if (gsB[si[i].cell] == gep) { idx[m2] = i; cov2[m2] = cov[i]; e0[m2] = d0[i]; et[m2] = dt[i]; m2++; }
                            for (int i = 0; i < m2; i++) for (int j = 0; j < m2; j++) em[i * m2 + j] = dm[idx[i] * m + idx[j]];
                            int v = gdp(nn, m2, cov2, e0, et, em, R1); o.dpBB = v > 60000 ? 65535 : v; if (v > R1) bits |= 0x40;
                        }
                    }
                }
            }
        }
        /* landmark metric and pair / triple bounds */
        if ((need & 0x7c00) && nn > 0 && !inf_b2a) {
            static thread_local GSite sj[64]; static thread_local unsigned cv[64]; static thread_local int f0[64], ft[64], fL[64 * 64], fB[64 * 64];
            int m = gsites(nw, nn, 1, sj, R1);
            if (m >= 0) {
                for (int i = 0; i < m; i++) { cv[i] = sj[i].cover; f0[i] = gdH[sj[i].cell]; ft[i] = gdT[sj[i].cell]; }
                for (int i = 0; i < m; i++) for (int j = 0; j < m; j++) {
                    int a = sj[i].cell, b = sj[j].cell, v = mdist(a, b);
                    int u = abs(gdH[a] - gdH[b]); if (u > v) v = u; u = abs(gdT[a] - gdT[b]); if (u > v) v = u;
                    fL[i * m + j] = v;
                }
                if (need & 0x4800) for (int i = 0; i < m; i++) gbfs_site(sj[i].cell, R1, sj, m, fB + i * m);
                if ((need & 0x400) && nn <= GDPMAX) { int v = gdp(nn, m, cv, f0, ft, fL, R1); if (v > R1) bits |= 0x400; }
                auto pairb = [&](const int *dm) {
                    for (int a = 0; a < nn; a++) for (int b = a + 1; b < nn; b++) {
                        int best = 1 << 20;
                        for (int i = 0; i < m && best > R1; i++) if (cv[i] >> a & 1) for (int j = 0; j < m; j++) if (cv[j] >> b & 1) {
                            int c = i == j ? f0[i] + ft[i] : std::min(f0[i] + dm[i * m + j] + ft[j], f0[j] + dm[j * m + i] + ft[i]);
                            if (c < best) best = c;
                        }
                        if (best > R1) return true;
                    }
                    return false;
                };
                auto tripb = [&](const int *dm) {
                    static thread_local int g1[64], g2[64];
                    for (int a = 0; a < nn; a++) for (int b = 0; b < nn; b++) for (int c = 0; c < nn; c++) {
                        if (a == b || a == c || b == c) continue;
                        if (!(a < b && b < c)) continue;
                        int best = 1 << 20;
                        int ord[6][3] = {{a, b, c}, {a, c, b}, {b, a, c}, {b, c, a}, {c, a, b}, {c, b, a}};
                        for (int o2 = 0; o2 < 6 && best > R1; o2++) {
                            int x = ord[o2][0], y = ord[o2][1], z = ord[o2][2];
                            for (int j = 0; j < m; j++) { g1[j] = 1 << 20; if (!(cv[j] >> y & 1)) continue; for (int i = 0; i < m; i++) if (cv[i] >> x & 1) { int v = f0[i] + (i == j ? 0 : dm[i * m + j]); if (v < g1[j]) g1[j] = v; } }
                            for (int k = 0; k < m; k++) { g2[k] = 1 << 20; if (!(cv[k] >> z & 1)) continue; for (int j = 0; j < m; j++) if (g1[j] < (1 << 20)) { int v = g1[j] + (j == k ? 0 : dm[j * m + k]); if (v < g2[k]) g2[k] = v; } if (g2[k] + ft[k] < best) best = g2[k] + ft[k]; }
                        }
                        if (best > R1) return true;
                    }
                    return false;
                };
                if ((need & 0x800) && pairb(fB)) bits |= 0x800;
                if ((need & 0x1000) && pairb(fL)) bits |= 0x1000;
                if ((need & 0x2000) && tripb(fL)) bits |= 0x2000;
                if ((need & 0x4000) && tripb(fB)) bits |= 0x4000;
            }
        }
        if (inf_b2a) bits |= 0x7c00;
        /* AOT01 */
        if (need & 0x300) {
            int ex[3], exv[3];
            for (int q = 0; q < 3; q++) {
                gzbfs(Hd, q, gzH);
                unsigned sH = gepZ;
                ex[q] = gsZ[Tl] == sH ? gzH[Tl] : (1 << 20);
                exv[q] = ex[q];
                if ((need & 0x200) && nn > 0) {
                    /* copy Hd field values for sites, then BFS from Tl */
                    static thread_local int zs[4 * MAXN * MAXN]; int nz = 0;
                    for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; for (int u = 0; u < ob.cnt; u++) { int s = ob.site[u]; zs[nz++] = gsZ[s] == sH ? gzH[s] : (1 << 20); } }
                    gzbfs(Tl, q, gzT); unsigned sT = gepZ; nz = 0;
                    for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; int bst = 1 << 20; for (int u = 0; u < ob.cnt; u++) { int s = ob.site[u]; int v = zs[nz++]; int w = gsZ[s] == sT ? gzT[s] : (1 << 20); if (v + w < bst) bst = v + w; } if (bst > exv[q]) exv[q] = bst; }
                }
            }
            if ((need & 0x100) && !aot_ok(pend[H + T], npend[H + T], ex)) bits |= 0x100;
            if ((need & 0x200) && !aot_ok(pend[H + T], npend[H + T], exv)) bits |= 0x200;
        }
        return bits;
    }
    /* run the subtree, record its fate and the candidate verdicts */
    void ginstrument(int R1) {
        const int *nw = pend[H + T]; int nn = npend[H + T];
        GRes gr; unsigned bits = geval(R1, nw, nn, 0x7fff, gr); GOut o0 = gout; if (gwalk2(R1, nw, nn)) bits |= 0x40000; if (gwalk3(R1, nw, nn)) bits |= 0x80000; gout = o0;
        GOut o = gout;
        unsigned long long n0 = st.nodes, s0 = st.surv, c0 = st.cand, cl0 = st.closed, k0[16]; memcpy(k0, GK, sizeof k0);
        int sv_H = H, sv_T = T; (void)sv_H; (void)sv_T;
        /* save the prefix for the examples before descending */
        char hw[MAXN + 1], tw[MAXN + 1]; for (int i = 0; i < H; i++) hw[i] = DC[Lt(i)]; hw[H] = 0; for (int k = 0; k < T; k++) tw[k] = DC[Lt(-T + k)]; tw[T] = 0;
        const int sHd = Hd, sTl = Tl; int sl = R1 - mdist(Hd, Tl);
        dfs();
        Hd = sHd; Tl = sTl;
        GRec r; memset(&r, 0, sizeof r);
        r.R1 = R1; r.nn = nn; r.slack = sl; r.dpskip = o.dpskip; r.bits = bits;
        r.sub = (uint32_t)(st.nodes - n0 + 1); r.surv = st.surv - s0; r.cand = st.cand - c0; r.closed = st.closed - cl0; r.adj = GK[9] - k0[9];
        for (int q = 0; q < 14; q++) r.kill[q] = GK[q] - k0[q];
        auto c16 = [](int v) { return (uint16_t)(v < 0 ? 65534 : v > 65535 ? 65535 : v); };
        r.dHT = c16(o.dHT); r.dpM = c16(o.dpM); r.dpB = c16(o.dpB); r.dpBB = c16(o.dpBB); r.v1 = c16(o.v1); r.blk = c16(o.blk);
        fwrite(&r, sizeof r, 1, GREC);
        if (GEX && R1 == 8 && r.surv == 0 && GEXN < GEXMAX && r.sub <= 60 && (st.nodes % 7 == 0)) {
            GEXN++;
            fprintf(GEX, "=== example %d: R1=%d sub=%u closed=%u adj=%u cand=%u bits=0x%x dHT=%d dpM=%d dpB=%d v1=%d blk=%d slack=%d\n", GEXN, R1, r.sub, r.closed, r.adj, r.cand, bits, o.dHT, o.dpM, o.dpB, o.v1, o.blk, sl);
            fprintf(GEX, "head=%s tail=%s  Hd=(%d,%d,%d) Tl=(%d,%d,%d) cnt=(%d,%d,%d) cdef=(%d,%d,%d)\n", hw, tw,
                    CX[Hd], CY[Hd], CZ[Hd], CX[Tl], CY[Tl], CZ[Tl], cnt[0], cnt[1], cnt[2], cdef[0], cdef[1], cdef[2]);
            for (int a = 0; a < nn; a++) { const Ob &ob = obs[nw[a]]; fprintf(GEX, "  ob%d:", a); for (int u = 0; u < ob.cnt; u++) fprintf(GEX, " (%d,%d,%d)", CX[ob.site[u]], CY[ob.site[u]], CZ[ob.site[u]]); fprintf(GEX, "\n"); }
            fprintf(GEX, "  kills:"); for (int q = 0; q < 14; q++) fprintf(GEX, " %u", r.kill[q]); fprintf(GEX, "\n");
        }
    }

#define REJ(q, r) do { st.rej[q][r]++; GK[5 + (q)]++; } while (0)
    /* obligations and tests after the step that created letter li (side 0: head, 1: tail) and the vertex nx; R1 = steps still missing */
    bool update2(int side, int li, int nx, int ofa, int ola, int R1) {
        int t = H + T;
        const int *old = pend[t - 1]; int no = npend[t - 1];
        int *nw = pend[t]; int nn = 0;
        for (int a = 0; a < no; a++) {
            const Ob &ob = obs[old[a]];
            bool sat = false;
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
        npend[t] = nn;
        if (TRUSTED) { nwit[t] = 0; return true; }
        for (int a = 0; a < nn; a++) {
            const Ob &ob = obs[nw[a]];
            bool fine = false;
            for (int u = 0; u < ob.cnt && !fine; u++) {
                int s = ob.site[u];
                if (mdist(Hd, s) + mdist(s, Tl) > R1) continue;
                int av = 0;
                for (int q = 0; q < 6; q++) { int w = s + DELTA[q]; av += (w == Hd || w == Tl || (!occ[w] && ALLOWED[w])); }
                fine = av >= 2;
            }
            if (!fine) { REJ(1, R1); return false; }
        }
        if (AOT && AXES && !aot_ok(nw, nn)) { REJ(2, R1); return false; }
        if (R1 >= STIFFX && stiff_dist(R1) > R1) { REJ(1, R1); return false; }
        if (BALZ && SLAB < 0 && R1 <= 16 && !balz_ok(R1)) { REJ(2, R1); return false; }
        nwit[t] = 0;
        if (LIGHT) return true;
        if (nn >= 2 && !tour_ok(t, Hd, nw, nn, R1)) { REJ(3, R1); return false; }
        if (GPRUNE && R1 >= GRMIN && R1 <= GRMAX) {
            GRes gr; std::chrono::steady_clock::time_point t0; if (GTIMEON) t0 = std::chrono::steady_clock::now();
            unsigned b = geval(R1, nw, nn, GPRUNE, gr);
            if (GTIMEON) { GTIME += std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count(); GEVALS++; }
            if (b & GPRUNE) { REJ(3, R1); return false; }
        }
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
    void leaf(int c) {
        st.closed++;
        for (int i = 0; i < H; i++) dirs[i] = Lt(i);
        dirs[H] = c;
        for (int k = 0; k < T; k++) dirs[H + 1 + k] = Lt(-T + k);
        pos[0] = ORG;
        for (int i = 1; i <= H; i++) pos[i] = P(i);
        for (int k = 0; k < T; k++) pos[H + 1 + k] = P(-T + k);
        pos[N] = ORG;
        if (!full_ok()) { GK[12]++; return; }
        st.cand++;
        if (REDUCE) {
            int v[MAXN];
            const int shift = (32 - OZ) * S2;
            for (int i = 0; i < N; i++) v[i] = pos[i] + shift;
            int r = red.reducible(v, N, BFS_LIMIT);
            if (r == 1) { GK[13]++; return; }
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
        GK[9]++;
        int c = -1;
        for (int d = 0; d < 6; d++) if (hp + DELTA[d] == tp) c = d;
        if (H + T >= 1 && c == (Lt(H - 1) ^ 1)) { GK[10]++; return; }                /* no reversal / no U-turn at the closing letter (as in enum.cpp's loop) */
        if (H + T >= 2 && c == (Lt(H - 2) ^ 1)) { GK[10]++; return; }
        if (T == 0 && (c ^ 1) <= Lt(0)) { GK[10]++; return; }        /* DMON4 at the closing letter, as enum.cpp, before counting the node */
        st.nodes++;
        int smn = 0, smx = 0, sdef = 0, pl = 0;
        if (PRIME) { plane_step(c >> 1, c, hp, smn, smx, sdef, pl); if (cdef[0] + cdef[1] + cdef[2] > 0) { GK[11]++; plane_undo(c >> 1, smn, smx, sdef, pl); return; } }
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
    int split_depth = -1, replay_len = 0;
    const std::vector<int> *replay = nullptr;
    std::vector<std::vector<int>> *collect = nullptr;
    int code[MAXN + 1];
    bool step_body(int side, int d, int t, int R, bool probe) {
        const int from = side ? P(-T) : P(H), other = side ? P(H) : P(-T);
            const int e = side ? (d ^ 1) : d;
            if (t >= 1) { if (!side) { if (d == (Lt(H - 1) ^ 1)) { GK[2]++; return false; } } else { if (e == (Lt(-T) ^ 1)) { GK[2]++; return false; } } }
            if (t >= 2) { if (!side) { if (d == (Lt(H - 2) ^ 1)) { GK[2]++; return false; } } else { if (e == (Lt(-T + 1) ^ 1)) { GK[2]++; return false; } } }
            const int nx = from + DELTA[d];
            if (occ[nx] || !ALLOWED[nx]) { GK[0]++; return false; }
            if (mdist(nx, other) > R - 1) { GK[1]++; return false; }
            if (t == 0 && d == 4) return false;
            if (!side && H == 0 && T >= 1 && !((Lt(-1) ^ 1) > d)) return false;      /* DMON4: reverse of the last letter must exceed the first letter */
            if (side && T == 0 && H >= 1 && !(d > Lt(0))) return false;
            const int A = d >> 1;
            if (AXES) {
                int cx = cnt[0], cy = cnt[1], cz = cnt[2];
                if (A == 0) cx++; else if (A == 1) cy++; else cz++;
                if (SLAB >= 0) {
                    if (2 * cy + cz > N) { GK[3]++; return false; }
                    if (cy > cx + (R - 1)) { GK[3]++; return false; }
                } else {
                    int m = cy > cz ? cy : cz;
                    if (2 * m + cz > N) { GK[3]++; return false; }
                    if (cz > cy + (R - 1) || cy > cx + (R - 1)) { GK[3]++; return false; }
                }
            }
            int smn = 0, smx = 0, sdef = 0, pl = 0; StairSave ss;
            if (PRIME) {
                plane_step(A, d, from, smn, smx, sdef, pl);
                if (STAIR) stair_step(side, A, d, from, ss);
                if (cdef[0] + cdef[1] + cdef[2] > R - 1) { GK[4]++; if (STAIR) stair_undo(side, A, ss); plane_undo(A, smn, smx, sdef, pl); return false; }
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
            bool fchg = false;
            if ((FACE || PLANE4) && SLAB < 0) {
                ok = face_check(side ? -T : H, side ? -1 : 1, svlo, svhi, fchg);
                if (!ok) st.rej[0][R - 1]++;
                if (ok && fchg && PRIME) {
                    for (int B = 0; B < 3; B++) cdef[B] = owed(B);
                    if (cdef[0] + cdef[1] + cdef[2] > R - 1) { ok = false; st.rej[2][R - 1]++; }
                }
            }
            if (ok) ok = update2(side, li, nx, ofa, ola, R - 1);
            if (ok && !probe) { int sl = (R - 1) - mdist(Hd, Tl); if (sl >= 0 && sl <= MAXN) st.slk[R - 1][sl]++; }
            if (ok && !probe) {
                if (t + 1 == split_depth && collect) collect->emplace_back(code, code + t + 1);
                else if (GREC && (GLEV >> (R - 1) & 1) && t >= replay_len) ginstrument(R - 1);
                else dfs();
            }
            for (int B = 0; B < 3; B++) { nlo[B] = svlo[B]; nhi[B] = svhi[B]; }
            if (fchg) for (int B = 0; B < 3; B++) cdef[B] = svcd[B];
            sumz -= CZ[nx] - CZ[ORG]; occ[nx] = 0; cnt[A]--; nobs = save; fa[A] = ofa; la[A] = ola;
            if (!side) H--; else T--;
            if (PRIME && STAIR) stair_undo(side, A, ss);
            if (PRIME) plane_undo(A, smn, smx, sdef, pl);
            return ok;
    }
    void dfs() {
        int t = H + T, R = N - t;
        if (R == 1) { closing(); return; }
        int side = (t < ALT && (t & 1)) ? 1 : 0;
        if (ADAPT == 1 && t >= ALT && t >= 2) {
            int c0 = count_children(0, t, R), c1 = count_children(1, t, R);
            if (c0 == 0 || c1 == 0) return;
            side = (c1 < c0) ? 1 : 0;
        }
        unsigned mask = 63;
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
            TRUSTED = (ADAPT == 6 && mask != 63);
            step_body(side, d, t, R, false);
            TRUSTED = false;
        }
    }
    void start() {
        memset(occ, 0, sizeof occ);
        H = T = 0; nobs = 0; npend[0] = 0; nwit[0] = 0; sumz = 0;
        for (int A = 0; A < 3; A++) { cnt[A] = 0; fa[A] = la[A] = NONE; }
        memset(crs, 0, sizeof crs); memset(badl, 0, sizeof badl); memset(runm, 0, sizeof runm);
        for (int A = 0; A < 3; A++) { cmn[A] = cmx[A] = cdef[A] = 0; nlo[A] = 1000; nhi[A] = -1000; }
        P(0) = ORG; occ[ORG] = 1;
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
        else if (a == "-balz") BALZ = true;
        else if (a == "-stiffx") STIFFX = atoi(argv[++i]);
        else if (a == "-crank") CRANK = true;
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
        else if (a == "-grec") GREC = fopen(argv[++i], "wb");
        else if (a == "-gex") GEX = fopen(argv[++i], "w");
        else if (a == "-glev") { GLEV = 0; const char *p = argv[++i]; while (*p) { GLEV |= 1u << atoi(p); while (*p && *p != ',') p++; if (*p) p++; } }
        else if (a == "-gprune") GPRUNE = (unsigned)strtoul(argv[++i], nullptr, 0);
        else if (a == "-grange") { GRMIN = atoi(argv[++i]); GRMAX = atoi(argv[++i]); }
        else if (a == "-gdpmax") GDPMAX = atoi(argv[++i]);
        else if (a == "-gtime") GTIMEON = true;
        else if (a == "-gwlim") GWLIM = strtoull(argv[++i], nullptr, 10);
        else if (a == "-gwgap") GWGAP = atoi(argv[++i]);
        else if (a == "-gw3let") GW3LET = atoi(argv[++i]);
        else if (a == "-gw3dfs") GW3BFS = false;
        else if (a == "-gw3h") W3HDP = atoi(argv[++i]) != 0;
        else if (a == "-walk") { GPRUNE |= 0x80000; GRMIN = atoi(argv[++i]); GRMAX = atoi(argv[++i]); W3HDP = true; GW3BFS = false; }
        else if (a == "-ggap") GGAPV = atoi(argv[++i]);
        else { fprintf(stderr, "unknown option %s (enum_bidir has no -bridge)\n", a.c_str()); return 1; }
    }
    if (N < 4 || N > 52 || (N & 1) || (SLAB < 0 && N > 48)) { fprintf(stderr, "N must be even, 4..48 (4..52 with -slab)\n"); return 1; }
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
        if (GTIMEON && GEVALS) fprintf(stderr, "gevals=%llu gtime=%.3f s per_eval=%.3f us walk_states=%llu walk_over=%llu skip=%llu dead=%llu dead_states=%llu\n", GEVALS, GTIME, 1e6 * GTIME / GEVALS, GWST, GWOVER, GWSKIP, GWDEAD, GWSTD);
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
    if (SLAB >= 0) fprintf(stderr, "slab=%d ", SLAB);
    fprintf(stderr, "N=%d alt=%d tasks=%zu part=%d/%d nodes=%llu closed=%llu candidates=%llu survivors=%llu bfs_limit_hits=%llu tour_giveups=%llu\n",
            N, ALT, tasks.size(), PART_R, PART_M, total.nodes, total.closed, total.cand, total.surv, total.bfs_over, total.giveup);
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
