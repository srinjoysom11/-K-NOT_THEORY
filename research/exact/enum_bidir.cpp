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
static const int MAXN = 48;

static int N = 0, ALT = 12, SPLIT = 9, PART_R = 0, PART_M = 1, TOUR_CAP = 3, BFS_LIMIT = 2000;
static bool AXES = true, REDUCE = true, PSI = true, NOMST = false, AOT = false, AOTM = false, REJSTATS = false;
static bool PRIME = false, STAIR = false, AOTC = false;   /* -prime / -stair: plane-crossing lemma (prime knots, PROOF.md Lemma 3); -aotc: per-axis plane debt in -aot */

static signed char CX[NS], CY[NS], CZ[NS];
static unsigned char ALLOWED[NS];

static inline int mdist(int a, int b) { return abs(CX[a] - CX[b]) + abs(CY[a] - CY[b]) + abs(CZ[a] - CZ[b]); }

struct Stats {
    unsigned long long nodes = 0, closed = 0, cand = 0, surv = 0, bfs_over = 0, giveup = 0;
    unsigned long long rej[4][MAXN + 1];   /* 0 no site (curtain/corner) 1 site unreachable 2 aot 3 tour/mst, by remaining steps */
    Stats() { memset(rej, 0, sizeof rej); }
    void add(const Stats &o) { nodes += o.nodes; closed += o.closed; cand += o.cand; surv += o.surv; bfs_over += o.bfs_over; giveup += o.giveup;
        for (int q = 0; q < 4; q++) for (int r = 0; r <= MAXN; r++) rej[q][r] += o.rej[q][r]; }
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
    unsigned char badl[3][64];
    int runm[2][3];
    struct StairSave { int rm[3]; int cd[3]; int lev[3]; };
    static inline bool nonmono(int m) { return (m & (m >> 1) & 0x15) != 0; }
    int owed(int A) const {
        int t = 0, mn = cmn[A], mx = cmx[A];
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
    inline bool aot_ok(const int *nw, int nn) const {
        int L[3];
        for (int q = 0; q < 3; q++) {
            int c0 = q == 0 ? CX[Hd] : q == 1 ? CY[Hd] : CZ[Hd], ct = q == 0 ? CX[Tl] : q == 1 ? CY[Tl] : CZ[Tl];
            int t = axis_need(q, c0, ct, nw, nn);
            if (AOTC && cdef[q] > t) t = cdef[q];
            L[q] = (cnt[q] + t + 1) & ~1;
        }
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

#define REJ(q, r) do { st.rej[q][r]++; } while (0)
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
        npend[t] = nn;
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
        nwit[t] = 0;
        if (nn >= 2 && !tour_ok(t, Hd, nw, nn, R1)) { REJ(3, R1); return false; }
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
        if (AXES && !(c[2] <= c[1] && c[1] <= c[0])) return false;                                  /* DMON5 */
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
        st.cand++;
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

    int split_depth = -1, replay_len = 0;
    const std::vector<int> *replay = nullptr;
    std::vector<std::vector<int>> *collect = nullptr;
    int code[MAXN + 1];
    void dfs() {
        int t = H + T, R = N - t;
        if (R == 1) { closing(); return; }
        const int side = (t < ALT && (t & 1)) ? 1 : 0;
        const int from = side ? P(-T) : P(H), other = side ? P(H) : P(-T);
        for (int d = 0; d < 6; d++) {
            if (t < replay_len && d != (*replay)[t]) continue;
            const int e = side ? (d ^ 1) : d;
            if (t >= 1) { if (!side) { if (d == (Lt(H - 1) ^ 1)) continue; } else { if (e == (Lt(-T) ^ 1)) continue; } }
            if (t >= 2) { if (!side) { if (d == (Lt(H - 2) ^ 1)) continue; } else { if (e == (Lt(-T + 1) ^ 1)) continue; } }
            const int nx = from + DELTA[d];
            if (occ[nx] || !ALLOWED[nx]) continue;
            if (mdist(nx, other) > R - 1) continue;
            if (t == 0 && d == 4) continue;
            if (!side && H == 0 && T >= 1 && !((Lt(-1) ^ 1) > d)) continue;      /* DMON4: reverse of the last letter must exceed the first letter */
            if (side && T == 0 && H >= 1 && !(d > Lt(0))) continue;
            const int A = d >> 1;
            if (AXES) {
                int cx = cnt[0], cy = cnt[1], cz = cnt[2];
                if (A == 0) cx++; else if (A == 1) cy++; else cz++;
                int m = cy > cz ? cy : cz;
                if (2 * m + cz > N) continue;
                if (cz > cy + (R - 1) || cy > cx + (R - 1)) continue;
            }
            int smn = 0, smx = 0, sdef = 0, pl = 0; StairSave ss;
            if (PRIME) {
                plane_step(A, d, from, smn, smx, sdef, pl);
                if (STAIR) stair_step(side, A, d, from, ss);
                if (cdef[0] + cdef[1] + cdef[2] > R - 1) { if (STAIR) stair_undo(side, A, ss); plane_undo(A, smn, smx, sdef, pl); continue; }
            }
            if (t >= replay_len) st.nodes++;
            const int ofa = fa[A], ola = la[A], save = nobs;
            int li;
            if (!side) { li = H; Lt(li) = e; P(H + 1) = nx; H++; la[A] = li; if (ofa == NONE) fa[A] = li; }
            else { T++; li = -T; Lt(li) = e; P(-T) = nx; fa[A] = li; if (ola == NONE) la[A] = li; }
            cnt[A]++; occ[nx] = 1; code[t] = d;
            Hd = P(H); Tl = P(-T);
            bool ok = update2(side, li, nx, ofa, ola, R - 1);
            if (ok) {
                if (t + 1 == split_depth && collect) collect->emplace_back(code, code + t + 1);
                else dfs();
            }
            occ[nx] = 0; cnt[A]--; nobs = save; fa[A] = ofa; la[A] = ola;
            if (!side) H--; else T--;
            if (PRIME && STAIR) stair_undo(side, A, ss);
            if (PRIME) plane_undo(A, smn, smx, sdef, pl);
        }
    }
    void start() {
        memset(occ, 0, sizeof occ);
        H = T = 0; nobs = 0; npend[0] = 0; nwit[0] = 0;
        for (int A = 0; A < 3; A++) { cnt[A] = 0; fa[A] = la[A] = NONE; }
        memset(crs, 0, sizeof crs); memset(badl, 0, sizeof badl); memset(runm, 0, sizeof runm);
        for (int A = 0; A < 3; A++) cmn[A] = cmx[A] = cdef[A] = 0;
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
        else if (a == "-noaxes") AXES = false;
        else if (a == "-noreduce") REDUCE = false;
        else if (a == "-nopsi") PSI = false;
        else if (a == "-nomst") NOMST = true;
        else if (a == "-bfs") BFS_LIMIT = atoi(argv[++i]);
        else if (a == "-tourcap") TOUR_CAP = atoi(argv[++i]);
        else if (a == "-split") SPLIT = atoi(argv[++i]);
        else if (a == "-part") { PART_R = atoi(argv[++i]); PART_M = atoi(argv[++i]); }
        else if (a == "-threads") threads = atoi(argv[++i]);
        else if (a == "-out") outfile = argv[++i];
        else if (a == "-rejstats") REJSTATS = true;
        else { fprintf(stderr, "unknown option %s (enum_bidir has no -bridge)\n", a.c_str()); return 1; }
    }
    if (N < 4 || N > 40 || (N & 1)) { fprintf(stderr, "N must be even, 4..40\n"); return 1; }
    if (SPLIT > N - 2) SPLIT = N - 2;
    if (SPLIT < 1) SPLIT = 1;
    for (int p = 0; p < NS; p++) {
        int x = p % S - OX, y = (p / S) % S - OY, z = p / S2 - OZ;
        CX[p] = (signed char)x; CY[p] = (signed char)y; CZ[p] = (signed char)z;
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
    fprintf(stderr, "N=%d alt=%d tasks=%zu part=%d/%d nodes=%llu closed=%llu candidates=%llu survivors=%llu bfs_limit_hits=%llu tour_giveups=%llu\n",
            N, ALT, tasks.size(), PART_R, PART_M, total.nodes, total.closed, total.cand, total.surv, total.bfs_over, total.giveup);
    if (REJSTATS) {
        fprintf(stderr, "kills by remaining steps R1: R1 no_site unreachable_or_one_free_neighbour aot tour_mst\n");
        for (int r = 0; r <= MAXN; r++) {
            unsigned long long sum = 0; for (int q = 0; q < 4; q++) sum += total.rej[q][r];
            if (!sum) continue;
            fprintf(stderr, "R1=%d %llu %llu %llu %llu\n", r, total.rej[0][r], total.rej[1][r], total.rej[2][r], total.rej[3][r]);
        }
    }
    return 0;
}
