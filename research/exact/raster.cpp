/*
 * raster.cpp -- exhaustive enumeration of candidate minimal lattice polygons, site by site.
 *
 * Same output as enum.cpp (same conditions, see the header there and PROOF.md), but the
 * polygon is built by sweeping the lattice in (z, y, x) order instead of walking along it.
 * At each site the edges to the three earlier neighbours (west, south, down) are already
 * decided and the program chooses the edges to the three later ones (east, north, up).
 * In this order the "pushed-down" conditions and the U-turn test refer only to sites that
 * are already decided, so they are checked the moment a corner is made.
 *
 * Conditions (every one is necessary for the chosen shortest polygon of a knot type):
 *   root   : the least vertex in (z, y, x) order is the first occupied site of the sweep;
 *   axes   : (#z-edges) <= (#y-edges) <= (#x-edges);
 *   U-turn : no unit square carries exactly 3 edges;
 *   Psi    : a corner whose flip would lower it in (z, then y) has its flip point occupied;
 *   curtain: checked on the finished polygon (all three axes, cyclically);
 *   leaf   : breadth-first search over neutral moves finds no shortening (-noreduce skips).
 *
 * usage: raster N [-nopsi] [-noreduce] [-bfs L] [-split D] [-part R M] [-threads T] [-out FILE]
 * build: g++ -O3 -march=native -std=c++17 -pthread -o raster raster.cpp
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

static int N = 0;
static bool PSI = true, REDUCE = true;
static int BFS_LIMIT = 2000, SPLIT = 10, PART_R = 0, PART_M = 1;

/* padded box: x in [0,W), y in [0,D), z in [0,H); root at (HX, HY, 0) */
static int HX, HY, W, D, H, PW, PD, PH, NPAD, SX, SY, SZ, ROOT;
static std::vector<int> ORDER;                 /* sites from the root onward, raster order */
static std::vector<signed char> CX, CY, CZ;
static std::vector<unsigned char> INBOX;       /* site may be used (in the box, not before the root) */

static inline int mdist(int a, int b) { return abs(CX[a] - CX[b]) + abs(CY[a] - CY[b]) + abs(CZ[a] - CZ[b]); }

struct Stats {
    unsigned long long nodes = 0, closed = 0, cand = 0, surv = 0, bfs_over = 0;
    void add(const Stats &o) { nodes += o.nodes; closed += o.closed; cand += o.cand; surv += o.surv; bfs_over += o.bfs_over; }
};

/* ---------- leaf reduction: breadth-first search over neutral BFACF moves ---------- */
struct Reducer {
    static const int R = 64, R3 = R * R * R;
    std::vector<unsigned char> g;
    std::vector<int> q;
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
        q.assign(v0, v0 + n);
        seen.insert(hash(v0, n));
        size_t head = 0;
        int cur[64];
        while (head * n < q.size()) {
            memcpy(cur, &q[head * n], n * sizeof(int));
            head++;
            for (int i = 0; i < n; i++) g[cur[i]] = 1;
            for (int i = 0; i < n; i++) {
                int p = cur[(i + n - 1) % n], c = cur[i], nx = cur[(i + 1) % n];
                if (nx - c == c - p) continue;
                int w = p + nx - c;
                if (g[w] || !interior(w)) continue;
                cur[i] = w;
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

struct Choice { int pos, outs; };

struct Search {
    std::vector<unsigned char> occ, indeg, inmask, outmask;   /* inmask: 1 from west, 2 from south, 4 from below; outmask: 1 east, 2 north, 4 up */
    std::vector<int> mate;                                     /* slot = 3*site + (0 west, 1 south, 2 below) */
    int ends[64], ne = 0;
    int cE = 0, cN = 0, cU = 0;
    Stats st;
    Reducer red;
    std::vector<std::string> out;
    std::vector<Choice> path;                                  /* choices made so far (for task splitting) */
    int split_nodes = -1;                                      /* collect tasks at this many choices */
    std::vector<std::vector<Choice>> *collect = nullptr;

    Search() : occ(NPAD, 0), indeg(NPAD, 0), inmask(NPAD, 0), outmask(NPAD, 0), mate(3 * NPAD, -1) {}

    int lower_bound_future() const {
        if (ne == 2) return mdist(ends[0] / 3, ends[1] / 3);
        int sum = 0;
        for (int a = 0; a < ne; a++) {
            int sa = ends[a] / 3, ma = mate[ends[a]], best = 1 << 20;
            for (int b = 0; b < ne; b++) {
                if (b == a || ends[b] == ma) continue;
                int dd = mdist(sa, ends[b] / 3);
                if (dd < best) best = dd;
            }
            sum += best;
        }
        return (sum + 1) / 2;
    }

    void leaf() {
        st.closed++;
        int pos[64], dirs[64];                 /* dirs: 0 e, 1 w, 2 n, 3 s, 4 u, 5 d */
        static const int STEP_OUT[3] = {0, 2, 4};
        const int strides[6] = {SX, -SX, SY, -SY, SZ, -SZ};
        int v = ROOT, prev = -1;
        /* leave the root along its smaller out-edge (e < n < u) */
        for (int i = 0; i < N; i++) {
            pos[i] = v;
            int nxt = -1, dir = -1;
            for (int b = 0; b < 3 && nxt < 0; b++) if (outmask[v] & (1 << b)) { int w = v + strides[STEP_OUT[b]]; if (w != prev) { nxt = w; dir = STEP_OUT[b]; } }
            for (int b = 0; b < 3 && nxt < 0; b++) if (inmask[v] & (1 << b)) { int w = v - strides[STEP_OUT[b]]; if (w != prev) { nxt = w; dir = STEP_OUT[b] + 1; } }
            dirs[i] = dir; prev = v; v = nxt;
        }
        if (v != ROOT) { fprintf(stderr, "internal error: leaf is not one cycle\n"); exit(2); }
        if (!(cU <= cN && cN <= cE)) return;
        /* curtain test, all axes, cyclic */
        for (int A = 0; A < 3; A++) {
            int idx[64], m = 0;
            for (int i = 0; i < N; i++) if ((dirs[i] >> 1) == A) idx[m++] = i;
            for (int a = 0; a < m; a++) {
                int j = idx[a], j2 = idx[(a + 1) % m];
                if (dirs[j2] != (dirs[j] ^ 1)) continue;
                int k = ((j2 - j - 1) % N + N) % N;
                int back = strides[dirs[j] ^ 1];
                bool ok = false;
                for (int t = 2; t <= k && !ok; t++) ok = occ[pos[(j + t) % N] + back];
                if (!ok) return;
            }
        }
        st.cand++;
        if (REDUCE) {
            int rv[64];
            for (int i = 0; i < N; i++) rv[i] = (CX[pos[i]] + 18) + 64 * ((CY[pos[i]] + 22) + 64 * (CZ[pos[i]] + 28));
            int r = red.reducible(rv, N, BFS_LIMIT);
            if (r == 1) return;
            if (r == -1) st.bfs_over++;
        }
        st.surv++;
        std::string w(N, ' ');
        for (int i = 0; i < N; i++) w[i] = "ewnsud"[dirs[i]];
        out.push_back(w);
    }

    /* decide site ORDER[pos] = v as occupied with out-edges `outs`, then continue */
    void place(int pos, int outs, int edges) {
        int v = ORDER[pos];
        int k = indeg[v], nout = __builtin_popcount(outs);
        int ne2 = edges + nout;
        if (ne2 > N) return;
        int nE = cE + (outs & 1), nN = cN + ((outs >> 1) & 1), nU = cU + ((outs >> 2) & 1);
        { int m = nN > nU ? nN : nU; if (2 * m + nU > N) return; }
        const int tgt[3] = {v + SX, v + SY, v + SZ};
        for (int b = 0; b < 3; b++) if (outs & (1 << b)) { if (!INBOX[tgt[b]] || indeg[tgt[b]] >= 2) return; }
        int im = inmask[v];
        /* pushed-down conditions at the corner v */
        if (PSI) {
            if (im & 4) {                                   /* edge down from v */
                int base = v - SZ, t = -1;
                if (im & 1) t = base - SX; else if (im & 2) t = base - SY;
                else if (outs & 1) t = base + SX; else if (outs & 2) t = base + SY;
                if (t >= 0 && !occ[t]) return;
            } else if (im & 2) {                            /* edge south from v */
                int base = v - SY, t = -1;
                if (im & 1) t = base - SX; else if (outs & 1) t = base + SX;
                if (t >= 0 && !occ[t]) return;
            }
        }
        /* U-turns: unit squares whose last corner is v */
        {
            const int sa[3] = {SX, SX, SY}, sb[3] = {SY, SZ, SZ}, ba[3] = {1, 1, 2}, bb[3] = {2, 4, 4};
            for (int q = 0; q < 3; q++) {
                int c = v - sa[q] - sb[q];
                int cnt = ((outmask[c] & ba[q]) != 0) + ((outmask[c] & bb[q]) != 0) + ((outmask[v - sb[q]] & bb[q]) != 0) + ((outmask[v - sa[q]] & ba[q]) != 0);
                if (cnt == 3) return;
            }
        }
        st.nodes++;
        /* --- apply --- */
        int save_ends[64], save_ne = ne;
        memcpy(save_ends, ends, ne * sizeof(int));
        int undo_slot[8], undo_val[8], nu = 0;
        auto setmate = [&](int s, int val) { undo_slot[nu] = s; undo_val[nu] = mate[s]; nu++; mate[s] = val; };
        int in1 = -1, in2 = -1;
        for (int b = 0; b < 3; b++) if (im & (1 << b)) { if (in1 < 0) in1 = 3 * v + b; else in2 = 3 * v + b; }
        /* remove consumed ends */
        { int m = 0; for (int a = 0; a < ne; a++) if (ends[a] != in1 && ends[a] != in2) ends[m++] = ends[a]; ne = m; }
        bool closed = false, dead = false;
        int o1 = -1, o2 = -1;
        for (int b = 0; b < 3; b++) if (outs & (1 << b)) { int s = 3 * tgt[b] + b; if (o1 < 0) o1 = s; else o2 = s; }
        if (k == 2) {
            if (mate[in1] == in2) closed = true;
            else { int a = mate[in1], b = mate[in2]; setmate(a, b); setmate(b, a); }
        } else if (k == 1) {
            int a = mate[in1]; setmate(a, o1); setmate(o1, a);
        } else {
            setmate(o1, o2); setmate(o2, o1);
        }
        occ[v] = 1; outmask[v] = (unsigned char)outs;
        cE = nE; cN = nN; cU = nU;
        for (int b = 0; b < 3; b++) if (outs & (1 << b)) {
            int u = tgt[b]; indeg[u]++; inmask[u] |= (1 << b); ends[ne++] = 3 * u + b;
            if (indeg[u] == 2) {            /* two ends meet at u: if they are the two ends of one arc the polygon closes there */
                int s1 = -1, s2 = -1;
                for (int c = 0; c < 3; c++) if (inmask[u] & (1 << c)) { if (s1 < 0) s1 = 3 * u + c; else s2 = 3 * u + c; }
                if (mate[s1] == s2 && !(ne == 2 && ne2 == N)) dead = true;
            }
        }
        if (closed) {
            if (ne == 0 && ne2 == N) leaf();
        } else if (!dead && ne >= 2 && ne2 + lower_bound_future() <= N) {
            path.push_back({pos, outs});
            if ((int)path.size() == split_nodes) collect->push_back(path);
            else go(pos + 1, ne2);
            path.pop_back();
        }
        /* --- undo --- */
        for (int b = 0; b < 3; b++) if (outs & (1 << b)) { int u = tgt[b]; indeg[u]--; inmask[u] &= ~(1 << b); }
        cE -= (outs & 1); cN -= ((outs >> 1) & 1); cU -= ((outs >> 2) & 1);
        occ[v] = 0; outmask[v] = 0;
        while (nu) { nu--; mate[undo_slot[nu]] = undo_val[nu]; }
        ne = save_ne; memcpy(ends, save_ends, ne * sizeof(int));
    }

    void go(int pos, int edges) {
        int room = N - edges;
        for (; pos < (int)ORDER.size(); pos++) {
            int v = ORDER[pos], k = indeg[v];
            if (k == 0) {
                /* a new arc here costs 2 edges and its two ends must still reach other arcs */
                if (room >= 4) {
                    int dmin = 1 << 20;
                    for (int a = 0; a < ne; a++) { int dd = mdist(v, ends[a] / 3); if (dd < dmin) dmin = dd; }
                    if (2 + (dmin - 1) <= room) { place(pos, 3, edges); place(pos, 5, edges); place(pos, 6, edges); }
                }
                continue;
            }
            if (k == 1) { place(pos, 1, edges); place(pos, 2, edges); place(pos, 4, edges); return; }
            place(pos, 0, edges);
            return;
        }
    }

    void run_root() {              /* whole search, or task collection when split_nodes > 0 */
        place(0, 3, 0); place(0, 5, 0); place(0, 6, 0);
    }
    void run_task(const std::vector<Choice> &t) {
        /* replay the choices; the last one is expanded normally */
        replay(t, 0, 0);
    }
    void replay(const std::vector<Choice> &t, size_t i, int edges) {
        /* re-apply choice i by hand (same code path as place, without tests that already passed) */
        if (i == t.size()) { go(t.back().pos + 1, edges); return; }
        int pos = t[i].pos, outs = t[i].outs, v = ORDER[pos];
        int k = indeg[v], im = inmask[v];
        const int tgt[3] = {v + SX, v + SY, v + SZ};
        int in1 = -1, in2 = -1;
        for (int b = 0; b < 3; b++) if (im & (1 << b)) { if (in1 < 0) in1 = 3 * v + b; else in2 = 3 * v + b; }
        { int m = 0; for (int a = 0; a < ne; a++) if (ends[a] != in1 && ends[a] != in2) ends[m++] = ends[a]; ne = m; }
        int o1 = -1, o2 = -1;
        for (int b = 0; b < 3; b++) if (outs & (1 << b)) { int s = 3 * tgt[b] + b; if (o1 < 0) o1 = s; else o2 = s; }
        if (k == 2) { int a = mate[in1], b = mate[in2]; mate[a] = b; mate[b] = a; }
        else if (k == 1) { int a = mate[in1]; mate[a] = o1; mate[o1] = a; }
        else { mate[o1] = o2; mate[o2] = o1; }
        occ[v] = 1; outmask[v] = (unsigned char)outs;
        cE += (outs & 1); cN += ((outs >> 1) & 1); cU += ((outs >> 2) & 1);
        for (int b = 0; b < 3; b++) if (outs & (1 << b)) { int u = tgt[b]; indeg[u]++; inmask[u] |= (1 << b); ends[ne++] = 3 * u + b; }
        path.push_back(t[i]);
        replay(t, i + 1, edges + __builtin_popcount(outs));
    }
    void reset() {
        std::fill(occ.begin(), occ.end(), 0); std::fill(indeg.begin(), indeg.end(), 0);
        std::fill(inmask.begin(), inmask.end(), 0); std::fill(outmask.begin(), outmask.end(), 0);
        ne = 0; cE = cN = cU = 0; path.clear();
    }
};

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: raster N [options]\n"); return 1; }
    N = atoi(argv[1]);
    int threads = (int)std::thread::hardware_concurrency();
    const char *outfile = nullptr;
    for (int i = 2; i < argc; i++) {
        std::string a = argv[i];
        if (a == "-nopsi") PSI = false;
        else if (a == "-noreduce") REDUCE = false;
        else if (a == "-bfs") BFS_LIMIT = atoi(argv[++i]);
        else if (a == "-split") SPLIT = atoi(argv[++i]);
        else if (a == "-part") { PART_R = atoi(argv[++i]); PART_M = atoi(argv[++i]); }
        else if (a == "-threads") threads = atoi(argv[++i]);
        else if (a == "-out") outfile = argv[++i];
        else { fprintf(stderr, "unknown option %s\n", a.c_str()); return 1; }
    }
    if (N < 6 || N > 40 || (N & 1)) { fprintf(stderr, "N must be even, 6..40\n"); return 1; }

    /* extents allowed by (#z) <= (#y) <= (#x), each at least 2: x-edges <= N-4, y-edges <= (N-2)/2, z-edges <= N/3.
       A coordinate can differ from the root's by at most half the number of edges on that axis. */
    HX = (N - 4) / 2; HY = (N - 2) / 4; int HZ = N / 6;
    W = 2 * HX + 1; D = 2 * HY + 1; H = HZ + 1;
    PW = W + 2; PD = D + 2; PH = H + 2; NPAD = PW * PD * PH;
    SX = 1; SY = PW; SZ = PW * PD;
    CX.assign(NPAD, 0); CY.assign(NPAD, 0); CZ.assign(NPAD, 0); INBOX.assign(NPAD, 0);
    auto id = [&](int x, int y, int z) { return (x + 1) + PW * ((y + 1) + PD * (z + 1)); };
    ROOT = id(HX, HY, 0);
    for (int z = 0; z < H; z++) for (int y = 0; y < D; y++) for (int x = 0; x < W; x++) {
        int p = id(x, y, z);
        CX[p] = (signed char)x; CY[p] = (signed char)y; CZ[p] = (signed char)z;
        if (p >= ROOT) { INBOX[p] = 1; ORDER.push_back(p); }
    }

    std::vector<std::vector<Choice>> tasks;
    Stats total;
    {
        Search s;
        s.split_nodes = SPLIT; s.collect = &tasks;
        s.run_root();
        total.add(s.st);
        for (auto &w : s.out) (void)w;
        /* polygons that closed before the split depth were found during collection */
        static std::vector<std::string> early; early = s.out;
        std::atomic<size_t> next(0);
        std::mutex mu;
        std::vector<std::string> words = early;
        auto worker = [&]() {
            Search *w = new Search();
            for (;;) {
                size_t t = next++;
                if (t >= tasks.size()) break;
                if ((long long)(t % PART_M) != PART_R) continue;
                w->reset();
                w->run_task(tasks[t]);
            }
            std::lock_guard<std::mutex> lk(mu);
            total.add(w->st);
            words.insert(words.end(), w->out.begin(), w->out.end());
            delete w;
        };
        std::vector<std::thread> pool;
        for (int i = 0; i < threads; i++) pool.emplace_back(worker);
        for (auto &th : pool) th.join();
        std::sort(words.begin(), words.end());
        FILE *fo = outfile ? fopen(outfile, "w") : stdout;
        for (auto &w : words) fprintf(fo, "%s\n", w.c_str());
        if (outfile) fclose(fo);
    }
    fprintf(stderr, "N=%d box=%dx%dx%d tasks=%zu part=%d/%d nodes=%llu closed=%llu candidates=%llu survivors=%llu bfs_limit_hits=%llu\n",
            N, W, D, H, tasks.size(), PART_R, PART_M, total.nodes, total.closed, total.cand, total.surv, total.bfs_over);
    return 0;
}
