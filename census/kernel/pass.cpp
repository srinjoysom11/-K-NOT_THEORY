// pass.cpp -- monotone knot-diagram simplification in the style of
// Petronio & Zanellati, "Algorithmic simplification of knot diagrams: new
// moves and experiments", JKTR 25(10) 2016, arXiv:1508.03226, Sec. 1
// (moves Z3 and procedure P).  Standalone, C++20, standard library only.
//
// Moves implemented (all are isotopies of the knot):
//   R1  removal (face of size 1)
//   R2  removal (face of size 2 whose one strand is over at both crossings)
//   Z3  (generalised pass move): delete a maximal over-run (resp. under-run)
//       alpha of k passages and re-insert it along a path gamma in the dual
//       graph of the remaining diagram, gamma over (resp. under) everything.
//       decreasing  : gamma a shortest dual path with l < k
//       horizontal  : gamma a shortest dual path with l == k
//       (scramble   : gamma any simple dual path; used only to make test
//                     inputs, never by the simplifier)
// Procedure P (PZ Sec. 1):
//   loop { if R1/R2 applies: apply, continue
//          if a decreasing Z3 exists: apply the one with largest k-l, continue
//          BFS over horizontal Z3 moves to depth H (visited set keyed by an
//            exact canonical code of the diagram); stop at the first state that
//            admits a decreasing move; move there and continue
//          else stop }
//
// PD convention (KnotTheory / Spherogram): X[i,j,k,l], i = incoming
// under-edge, slots listed counter-clockwise, k = outgoing under-edge.  The
// code only uses that the four slots are listed in cyclic order and that
// slots 1,3 are the over-strand, so a clockwise convention also works as long
// as input and output use the same one (the output is written in the same
// cyclic sense as the input).
//
// Compile:  g++ -O2 -std=c++20 -Wall -Wextra -o pass pass.cpp
// Usage:    ./pass [--H 2] [--paths 4] [--maxstates 20000] [--hmin 2]
//                  [--seed S] [--no-under] [--scramble M] [--selftest] [-v]
//           input lines on stdin:  name n a1 ... a4n
//           output lines:          name n_in n_out b1 ... b(4 n_out)

#include <algorithm>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <deque>
#include <functional>
#include <iostream>
#include <random>
#include <sstream>
#include <string>
#include <unordered_set>
#include <vector>

using std::string;
using std::vector;

[[noreturn]] static void die(const string& m) {
    std::fprintf(stderr, "pass: FATAL: %s\n", m.c_str());
    std::exit(2);
}
#define CHECK(c, m)                                                            \
    do {                                                                       \
        if (!(c))                                                              \
            die(string(m) + "  [failed: " #c "]  (pass.cpp:" +                  \
                std::to_string(__LINE__) + ")");                               \
    } while (0)

// ---------------------------------------------------------------- options
struct Opts {
    int H = 2;            // horizontal BFS depth
    int paths = 4;        // shortest paths tried per run (horizontal / ties)
    int maxStates = 20000;// cap on horizontal BFS visited set
    int hmin = 2;         // minimum run length for horizontal moves
    bool under = true;    // also use under-runs
    bool seeded = false;
    uint64_t seed = 0;
    int scramble = 0;     // if >0: output a scrambled diagram instead
    bool selftest = false;
    bool verbose = false;
};
static Opts OPT;
static std::mt19937_64 RNG(12345);

// ------------------------------------------------------------- Diagram
// Compact diagram: n crossings, dart d = 4x+p (crossing x, slot p, slots in
// cyclic order).  tw[d] = the dart at the other end of the edge.  op[x] = 1
// if slots {1,3} carry the over-strand, 0 if slots {0,2} do.
struct Diagram {
    int n = 0;
    vector<int> tw;
    vector<uint8_t> op;
};
static inline int Vx(int d) { return d >> 2; }
static inline int Ps(int d) { return d & 3; }
static inline int dart(int x, int p) { return 4 * x + (p & 3); }
static inline bool isOver(const Diagram& D, int d) {
    return (Ps(d) & 1) == D.op[Vx(d)];
}

// faces: orbits of phi(d) = rot^{-1}(tw(d))  (turn left at every vertex)
static int facesOf(const Diagram& D, vector<int>& fid) {
    fid.assign(4 * D.n, -1);
    int F = 0;
    for (int d = 0; d < 4 * D.n; d++) {
        if (fid[d] >= 0) continue;
        int e = d, guard = 0;
        do {
            CHECK(fid[e] < 0, "face tracing revisited a dart");
            fid[e] = F;
            int t = D.tw[e];
            e = dart(Vx(t), Ps(t) + 3);
            CHECK(++guard <= 4 * D.n, "face tracing did not close");
        } while (e != d);
        F++;
    }
    return F;
}

// knot traversal: out[j] = dart through which passage j leaves its crossing
static vector<int> traversal(const Diagram& D, int startOut) {
    vector<int> out;
    int e = startOut;
    do {
        out.push_back(e);
        int t = D.tw[e];
        e = dart(Vx(t), Ps(t) + 2);
        CHECK((int)out.size() <= 2 * D.n, "traversal did not close");
    } while (e != startOut);
    return out;
}

static void validate(const Diagram& D, const string& ctx) {
    if (D.n == 0) return;
    CHECK((int)D.tw.size() == 4 * D.n && (int)D.op.size() == D.n,
          ctx + ": array sizes");
    for (int d = 0; d < 4 * D.n; d++) {
        CHECK(D.tw[d] >= 0 && D.tw[d] < 4 * D.n, ctx + ": twin range");
        CHECK(D.tw[d] != d && D.tw[D.tw[d]] == d, ctx + ": twin involution");
    }
    for (int x = 0; x < D.n; x++) CHECK(D.op[x] <= 1, ctx + ": op value");
    vector<int> fid;
    int F = facesOf(D, fid);
    CHECK(F == D.n + 2, ctx + ": Euler check F = n+2 failed (F=" +
                            std::to_string(F) + ", n=" + std::to_string(D.n) +
                            ") -- diagram is not planar");
    // single component, every dart used exactly once, each crossing twice
    vector<int> out = traversal(D, 0);
    CHECK((int)out.size() == 2 * D.n,
          ctx + ": not a single component (traversal length " +
              std::to_string(out.size()) + " != 2n=" +
              std::to_string(2 * D.n) + ")");
    vector<int> seen(4 * D.n, 0), visits(D.n, 0);
    for (int o : out) {
        seen[o]++;
        seen[D.tw[o]]++;
        visits[Vx(o)]++;
    }
    for (int d = 0; d < 4 * D.n; d++) CHECK(seen[d] == 1, ctx + ": dart use");
    for (int x = 0; x < D.n; x++)
        CHECK(visits[x] == 2, ctx + ": crossing not visited twice");
    // each passage is either over at both darts or under at both
    for (int o : out) {
        int in = dart(Vx(o), Ps(o) + 2);
        CHECK(isOver(D, o) == isOver(D, in), ctx + ": passage over/under");
    }
}

// --------------------------------------------------------------- PD I/O
static bool parsePD(const vector<long long>& a, Diagram& D, string& err) {
    if (a.size() % 4) { err = "PD length not a multiple of 4"; return false; }
    int n = (int)a.size() / 4;
    D.n = n;
    D.tw.assign(4 * n, -1);
    D.op.assign(n, 1);  // slots 0,2 under (i in, k out), slots 1,3 over
    if (n == 0) return true;
    vector<vector<int>> where(2 * n + 1);
    for (int d = 0; d < 4 * n; d++) {
        long long L = a[d];
        if (L < 1 || L > 2 * n) {
            err = "label out of range 1..2n: " + std::to_string(L);
            return false;
        }
        where[L].push_back(d);
    }
    for (int L = 1; L <= 2 * n; L++) {
        if (where[L].size() != 2) {
            err = "label " + std::to_string(L) + " occurs " +
                  std::to_string(where[L].size()) + " times";
            return false;
        }
        D.tw[where[L][0]] = where[L][1];
        D.tw[where[L][1]] = where[L][0];
    }
    // orientation consistency of the input labels (KnotTheory: k = i+1)
    for (int x = 0; x < n; x++) {
        long long i = a[4 * x], j = a[4 * x + 1], k = a[4 * x + 2],
                  l = a[4 * x + 3];
        long long m = 2 * n;
        if (k != i % m + 1) {
            err = "crossing " + std::to_string(x) +
                  ": under-strand labels not consecutive (k != i+1)";
            return false;
        }
        if (!(j == l % m + 1 || l == j % m + 1)) {
            err = "crossing " + std::to_string(x) +
                  ": over-strand labels not consecutive";
            return false;
        }
    }
    return true;
}

// PD output: edges numbered 1..2n along the knot; edge 1 enters an
// under-crossing (that of crossing 0), each X listed from its incoming
// under-edge in the same cyclic sense as the internal slot order.
static vector<int> toPD(const Diagram& D) {
    vector<int> res;
    if (D.n == 0) return res;
    int n = D.n, m = 2 * n;
    int u = (D.op[0] == 1) ? 0 : 1;  // an under slot of crossing 0
    // leave crossing 0 through the under slot opposite to u, so that the
    // under passage at crossing 0 is passage 0 and slot u is its in-dart
    vector<int> out = traversal(D, dart(0, u + 2));
    CHECK((int)out.size() == m, "toPD: traversal length");
    vector<int> lab(4 * n, 0);
    vector<char> isOut(4 * n, 0);
    for (int j = 0; j < m; j++) {
        int L = (j + 1) % m + 1;  // edge leaving passage j; entering 0 gets 1
        lab[out[j]] = L;
        lab[D.tw[out[j]]] = L;
        isOut[out[j]] = 1;
    }
    for (int x = 0; x < n; x++) {
        int pin = -1;
        for (int p = 0; p < 4; p++) {
            int d = dart(x, p);
            if (!isOver(D, d) && !isOut[d]) pin = p;
        }
        CHECK(pin >= 0, "toPD: no incoming under slot");
        for (int s = 0; s < 4; s++) res.push_back(lab[dart(x, pin + s)]);
    }
    // self-check (iii): labels consistent with over/under pattern
    for (int x = 0; x < n; x++) {
        int i = res[4 * x], j = res[4 * x + 1], k = res[4 * x + 2],
            l = res[4 * x + 3];
        CHECK(k == i % m + 1, "toPD: under labels not consecutive");
        CHECK(j == l % m + 1 || l == j % m + 1,
              "toPD: over labels not consecutive");
    }
    return res;
}

// --------------------------------------------------------- canonical code
// Exact canonical code of the rooted-map encoding minimised over all 4n
// roots: equal codes <=> diagrams isomorphic by an orientation-preserving
// homeomorphism of S^2 preserving crossing information.
static vector<int> encodeFrom(const Diagram& D, int root) {
    vector<int> label(D.n, -1), start(D.n, 0), order;
    vector<int> code;
    code.reserve(5 * D.n);
    label[Vx(root)] = 0;
    start[Vx(root)] = Ps(root);
    order.push_back(Vx(root));
    for (size_t q = 0; q < order.size(); q++) {
        int v = order[q];
        code.push_back(isOver(D, dart(v, start[v])) ? 1 : 0);
        for (int i = 0; i < 4; i++) {
            int t = D.tw[dart(v, start[v] + i)];
            int w = Vx(t);
            if (label[w] < 0) {
                label[w] = (int)order.size();
                start[w] = Ps(t);
                order.push_back(w);
            }
            code.push_back(label[w] * 4 + ((Ps(t) - start[w] + 4) & 3));
        }
    }
    return code;
}
static string canonKey(const Diagram& D) {
    if (D.n == 0) return string("unknot0");
    vector<int> best;
    for (int r = 0; r < 4 * D.n; r++) {
        vector<int> c = encodeFrom(D, r);
        if (best.empty() || c < best) best.swap(c);
    }
    string s;
    s.reserve(best.size() * 3);
    for (int v : best) {
        s.push_back((char)(v & 0xff));
        s.push_back((char)((v >> 8) & 0xff));
        s.push_back((char)((v >> 16) & 0xff));
    }
    return s;
}

// ---------------------------------------------------------------- Map
// General planar map with vertices of any degree, used for surgery.
struct Map {
    vector<vector<int>> rot;
    vector<char> valive, cross;
    vector<uint8_t> op;
    vector<int> dv, dp, tw;
    vector<char> dalive;
    int newDart() {
        dv.push_back(-1);
        dp.push_back(-1);
        tw.push_back(-1);
        dalive.push_back(1);
        return (int)dv.size() - 1;
    }
    int newVertex(bool c) {
        rot.emplace_back();
        valive.push_back(1);
        cross.push_back(c ? 1 : 0);
        op.push_back(0);
        return (int)rot.size() - 1;
    }
    void setRot(int v, const vector<int>& ds) {
        rot[v] = ds;
        for (size_t i = 0; i < ds.size(); i++) {
            dv[ds[i]] = v;
            dp[ds[i]] = (int)i;
        }
    }
    void link(int a, int b) {
        tw[a] = b;
        tw[b] = a;
    }
    void killVertex(int v) {
        valive[v] = 0;
        rot[v].clear();
    }
};

static Map toMap(const Diagram& D) {
    Map M;
    for (int x = 0; x < D.n; x++) M.newVertex(true);
    for (int d = 0; d < 4 * D.n; d++) M.newDart();
    for (int x = 0; x < D.n; x++) {
        M.setRot(x, {dart(x, 0), dart(x, 1), dart(x, 2), dart(x, 3)});
        M.op[x] = D.op[x];
    }
    for (int d = 0; d < 4 * D.n; d++) M.tw[d] = D.tw[d];
    return M;
}

// replace crossing x by two degree-2 vertices, one per strand
static void uncross(Map& M, int x) {
    CHECK(M.valive[x] && M.cross[x] && M.rot[x].size() == 4, "uncross");
    vector<int> r = M.rot[x];
    M.killVertex(x);
    int a = M.newVertex(false), b = M.newVertex(false);
    M.setRot(a, {r[0], r[2]});
    M.setRot(b, {r[1], r[3]});
}

// smooth all degree-2 non-crossing vertices; returns number of free circles
static int smooth(Map& M) {
    int circles = 0;
    for (int v = 0; v < (int)M.rot.size(); v++) {
        if (!M.valive[v] || M.cross[v]) continue;
        CHECK(M.rot[v].size() == 2, "smooth: non-crossing vertex of degree " +
                                        std::to_string(M.rot[v].size()));
        int a = M.rot[v][0], b = M.rot[v][1];
        int ta = M.tw[a], tb = M.tw[b];
        CHECK(ta >= 0 && tb >= 0, "smooth: dangling dart");
        if (ta == b) {
            circles++;
        } else {
            M.link(ta, tb);
        }
        M.dalive[a] = M.dalive[b] = 0;
        M.killVertex(v);
    }
    return circles;
}

static Diagram fromMap(const Map& M, int circles, const string& ctx) {
    vector<int> nid(M.rot.size(), -1);
    int n = 0;
    for (int v = 0; v < (int)M.rot.size(); v++)
        if (M.valive[v]) {
            CHECK(M.cross[v] && M.rot[v].size() == 4,
                  ctx + ": leftover non-crossing vertex");
            nid[v] = n++;
        }
    Diagram D;
    D.n = n;
    if (n == 0) {
        CHECK(circles == 1, ctx + ": crossingless result must be one circle");
        return D;
    }
    CHECK(circles == 0, ctx + ": split component created");
    D.tw.assign(4 * n, -1);
    D.op.assign(n, 0);
    vector<int> newd(M.dv.size(), -1);
    for (int v = 0; v < (int)M.rot.size(); v++)
        if (M.valive[v])
            for (int p = 0; p < 4; p++) newd[M.rot[v][p]] = dart(nid[v], p);
    for (int v = 0; v < (int)M.rot.size(); v++)
        if (M.valive[v]) {
            D.op[nid[v]] = M.op[v];
            for (int p = 0; p < 4; p++) {
                int d = M.rot[v][p];
                int t = M.tw[d];
                CHECK(t >= 0 && newd[t] >= 0, ctx + ": twin not a crossing dart");
                D.tw[dart(nid[v], p)] = newd[t];
            }
        }
    validate(D, ctx);
    return D;
}

// faces of a general map (alive darts), turn-left rule
static int mapFaces(const Map& M, vector<int>& fid) {
    fid.assign(M.dv.size(), -1);
    int F = 0;
    for (int d = 0; d < (int)M.dv.size(); d++) {
        if (!M.dalive[d] || fid[d] >= 0) continue;
        int e = d, guard = 0;
        do {
            CHECK(fid[e] < 0, "mapFaces revisit");
            fid[e] = F;
            int t = M.tw[e];
            int w = M.dv[t];
            int deg = (int)M.rot[w].size();
            e = M.rot[w][(M.dp[t] + deg - 1) % deg];
            CHECK(++guard <= (int)M.dv.size(), "mapFaces did not close");
        } while (e != d);
        F++;
    }
    return F;
}

// ------------------------------------------------------------ R1 / R2
static bool tryR1(const Diagram& D, Diagram& res) {
    for (int d = 0; d < 4 * D.n; d++) {
        int t = D.tw[d];
        if (Vx(t) != Vx(d) || Ps(t) != ((Ps(d) + 1) & 3)) continue;
        int x = Vx(d), p = Ps(d);
        Map M = toMap(D);
        vector<int> r = M.rot[x];
        M.dalive[r[p]] = M.dalive[r[(p + 1) & 3]] = 0;
        M.killVertex(x);
        int w = M.newVertex(false);
        M.setRot(w, {r[(p + 2) & 3], r[(p + 3) & 3]});
        int c = smooth(M);
        res = fromMap(M, c, "R1");
        CHECK(res.n == D.n - 1, "R1 crossing count");
        return true;
    }
    return false;
}

static bool tryR2(const Diagram& D, Diagram& res) {
    vector<int> fid;
    int F = facesOf(D, fid);
    vector<vector<int>> fd(F);
    for (int d = 0; d < 4 * D.n; d++) fd[fid[d]].push_back(d);
    for (int f = 0; f < F; f++) {
        if (fd[f].size() != 2) continue;
        int d1 = fd[f][0];
        int t1 = D.tw[d1];
        int x = Vx(d1), y = Vx(t1);
        if (x == y) continue;
        if (isOver(D, d1) != isOver(D, t1)) continue;  // clasp, not R2
        Map M = toMap(D);
        uncross(M, x);
        uncross(M, y);
        int c = smooth(M);
        res = fromMap(M, c, "R2");
        CHECK(res.n == D.n - 2, "R2 crossing count");
        return true;
    }
    return false;
}

// ------------------------------------------------------------------ Z3
struct Run {
    int j, k;   // passages j..j+k-1 (cyclic) form the run
    bool over;  // over-run or under-run
};

static vector<Run> findRuns(const Diagram& D, const vector<int>& out) {
    int m = (int)out.size();
    vector<char> ov(m);
    for (int j = 0; j < m; j++) ov[j] = isOver(D, out[j]) ? 1 : 0;
    vector<Run> runs;
    int j0 = -1;
    for (int j = 0; j < m; j++)
        if (ov[j] != ov[(j + m - 1) % m]) { j0 = j; break; }
    CHECK(j0 >= 0, "findRuns: all passages have the same type");
    int j = j0, done = 0;
    while (done < m) {
        int k = 0;
        while (k < m && ov[(j + k) % m] == ov[j]) k++;
        runs.push_back({j, k, ov[j] == 1});
        j = (j + k) % m;
        done += k;
    }
    return runs;
}

struct Z3Prep {
    Map M;
    int P1 = -1, P2 = -1, a1 = -1, b2 = -1;
    vector<int> fid;
    int nf = 0, F1 = -1, F2 = -1;
    vector<vector<int>> adj;  // adj[f] = darts d with fid[d]=f, fid[tw d]!=f
    vector<int> distA, distB;
};

static vector<int> faceBFS(const Z3Prep& z, int src) {
    vector<int> dist(z.nf, -1);
    std::deque<int> q;
    dist[src] = 0;
    q.push_back(src);
    while (!q.empty()) {
        int f = q.front();
        q.pop_front();
        for (int d : z.adj[f]) {
            int g = z.fid[z.M.tw[d]];
            if (dist[g] < 0) {
                dist[g] = dist[f] + 1;
                q.push_back(g);
            }
        }
    }
    return dist;
}

// Delete the run from D; leave dangling ends P1 (after u1) and P2 (before u2).
static void prepareZ3(const Diagram& D, const vector<int>& out, const Run& r,
                      Z3Prep& z) {
    int m = (int)out.size();
    auto OUT = [&](int j) { return out[((j % m) + m) % m]; };
    auto IN = [&](int j) { return D.tw[OUT(j - 1)]; };
    CHECK(r.k >= 1 && r.k < m, "prepareZ3: bad run length");
    z.M = toMap(D);
    Map& M = z.M;
    int jm1 = r.j - 1, jk1 = r.j + r.k - 1, jk = r.j + r.k;
    // subdivide e0 (u1 -> c_1) by P1
    z.P1 = M.newVertex(false);
    z.a1 = M.newDart();
    int b1 = M.newDart();
    M.setRot(z.P1, {z.a1, b1});
    M.link(OUT(jm1), z.a1);
    M.link(IN(r.j), b1);
    // subdivide ek (c_k -> u2) by P2
    z.P2 = M.newVertex(false);
    int a2 = M.newDart();
    z.b2 = M.newDart();
    M.setRot(z.P2, {a2, z.b2});
    M.link(OUT(jk1), a2);
    M.link(IN(jk), z.b2);
    // delete alpha
    M.dalive[b1] = M.dalive[a2] = 0;
    M.setRot(z.P1, {z.a1});
    M.setRot(z.P2, {z.b2});
    for (int i = 0; i < r.k; i++) {
        int o = OUT(r.j + i);
        int in = dart(Vx(o), Ps(o) + 2);
        int x = Vx(o);
        CHECK(M.valive[x] && M.cross[x], "prepareZ3: crossing on run twice");
        CHECK((isOver(D, o) ? 1 : 0) == (r.over ? 1 : 0),
              "prepareZ3: run passage type");
        M.dalive[o] = M.dalive[in] = 0;
        vector<int> rr = M.rot[x];
        int p = Ps(o);
        M.killVertex(x);
        int w = M.newVertex(false);
        M.setRot(w, {rr[(p + 1) & 3], rr[(p + 3) & 3]});
    }
    z.nf = mapFaces(M, z.fid);
    z.F1 = z.fid[z.a1];
    z.F2 = z.fid[z.b2];
    z.adj.assign(z.nf, {});
    for (int d = 0; d < (int)M.dv.size(); d++) {
        if (!M.dalive[d]) continue;
        int f = z.fid[d], g = z.fid[M.tw[d]];
        if (f != g) z.adj[f].push_back(d);
    }
    // Euler check on the deleted map: V - E + F = 2 (connected)
    long long Vn = 0, E2 = 0;
    for (int v = 0; v < (int)M.rot.size(); v++)
        if (M.valive[v]) {
            Vn++;
            E2 += (long long)M.rot[v].size();
        }
    CHECK(E2 % 2 == 0 && Vn - E2 / 2 + z.nf == 2,
          "prepareZ3: deleted map not planar/connected");
    if (OPT.seeded)
        for (auto& v : z.adj) std::shuffle(v.begin(), v.end(), RNG);
    z.distA = faceBFS(z, z.F1);
    z.distB = faceBFS(z, z.F2);
    CHECK(z.distA[z.F2] >= 0, "prepareZ3: F2 unreachable");
}

// enumerate up to maxPaths shortest dual paths F1 -> F2 (lists of darts)
static void shortestPaths(const Z3Prep& z, int maxPaths,
                          vector<vector<int>>& paths) {
    int L = z.distA[z.F2];
    vector<int> cur;
    std::function<void(int)> rec = [&](int f) {
        if ((int)paths.size() >= maxPaths) return;
        if (f == z.F2 && (int)cur.size() == L) {
            paths.push_back(cur);
            return;
        }
        for (int d : z.adj[f]) {
            int g = z.fid[z.M.tw[d]];
            if (z.distA[g] == z.distA[f] + 1 && z.distA[g] + z.distB[g] == L) {
                cur.push_back(d);
                rec(g);
                cur.pop_back();
                if ((int)paths.size() >= maxPaths) return;
            }
        }
    };
    rec(z.F1);
}

// a random simple dual path F1 -> F2 (for scrambling only)
static bool randomPath(const Z3Prep& z, vector<int>& path) {
    std::uniform_int_distribution<int> pick(0, z.nf - 1);
    for (int attempt = 0; attempt < 20; attempt++) {
        int mid = pick(RNG);
        // shortest F1->mid then mid->F2, by BFS with parent darts
        auto bfsPath = [&](int s, int t, vector<int>& pd) {
            vector<int> par(z.nf, -2);
            std::deque<int> q;
            par[s] = -1;
            q.push_back(s);
            while (!q.empty()) {
                int f = q.front();
                q.pop_front();
                vector<int> nb = z.adj[f];
                std::shuffle(nb.begin(), nb.end(), RNG);
                for (int d : nb) {
                    int g = z.fid[z.M.tw[d]];
                    if (par[g] == -2) {
                        par[g] = d;
                        q.push_back(g);
                    }
                }
            }
            if (par[t] == -2) return false;
            pd.clear();
            for (int f = t; f != s;) {
                int d = par[f];
                pd.push_back(d);
                f = z.fid[d];
            }
            std::reverse(pd.begin(), pd.end());
            return true;
        };
        vector<int> p1, p2;
        if (!bfsPath(z.F1, mid, p1) || !bfsPath(mid, z.F2, p2)) continue;
        path = p1;
        path.insert(path.end(), p2.begin(), p2.end());
        // simple: faces visited must be distinct
        vector<char> used(z.nf, 0);
        bool ok = true;
        int f = z.F1;
        used[f] = 1;
        for (int d : path) {
            int g = z.fid[z.M.tw[d]];
            if (used[g]) { ok = false; break; }
            used[g] = 1;
            f = g;
        }
        if (ok) return true;
    }
    return false;
}

// re-insert alpha along the dual path (darts d_1..d_l); new crossings put the
// new arc over (over-run) or under (under-run) the crossed strand
static Diagram buildZ3(const Z3Prep& z, const vector<int>& path, bool over,
                       const string& ctx) {
    Map M = z.M;  // copy
    // check path is a simple face path from F1 to F2
    {
        vector<char> used(z.nf, 0);
        int f = z.F1;
        used[f] = 1;
        for (int d : path) {
            CHECK(z.fid[d] == f, ctx + ": path not contiguous");
            int g = z.fid[M.tw[d]];
            CHECK(!used[g], ctx + ": path revisits a face");
            used[g] = 1;
            f = g;
        }
        CHECK(f == z.F2, ctx + ": path does not end at F2");
    }
    int prev = M.newDart();
    M.setRot(z.P1, {z.a1, prev});
    for (int d : path) {
        int t = M.tw[d];
        int zv = M.newVertex(true);
        int zb = M.newDart(), zp = M.newDart(), za = M.newDart(),
            zn = M.newDart();
        // dart d runs a->b with face f_{i-1} on its left; at z (counter-
        // clockwise): towards b, towards f_{i-1} (prev), towards a, next
        M.setRot(zv, {zb, zp, za, zn});
        M.op[zv] = over ? 1 : 0;  // slots 1,3 = new arc
        M.link(d, za);
        M.link(t, zb);
        M.link(prev, zp);
        prev = zn;
    }
    int q = M.newDart();
    M.setRot(z.P2, {z.b2, q});
    M.link(prev, q);
    int c = smooth(M);
    return fromMap(M, c, ctx);
}

// -------------------------------------------------------- simplifier core
struct Stats {
    long long r1 = 0, r2 = 0, z3dec = 0, z3hor = 0, bfsStates = 0;
};
static Stats ST;

static bool hasR1(const Diagram& D) {
    for (int d = 0; d < 4 * D.n; d++) {
        int t = D.tw[d];
        if (Vx(t) == Vx(d) && Ps(t) == ((Ps(d) + 1) & 3)) return true;
    }
    return false;
}
static bool hasR2(const Diagram& D) {
    vector<int> fid;
    int F = facesOf(D, fid);
    vector<int> cnt(F, 0), first(F, -1);
    for (int d = 0; d < 4 * D.n; d++) {
        if (first[fid[d]] < 0) first[fid[d]] = d;
        cnt[fid[d]]++;
    }
    for (int f = 0; f < F; f++)
        if (cnt[f] == 2) {
            int d1 = first[f], t1 = D.tw[d1];
            if (Vx(d1) != Vx(t1) && isOver(D, d1) == isOver(D, t1)) return true;
        }
    return false;
}

// best decreasing Z3 (largest k-l); returns false if none
static bool bestDecZ3(const Diagram& D, Diagram& res, bool apply) {
    if (D.n == 0) return false;
    vector<int> out = traversal(D, 0);
    vector<Run> runs = findRuns(D, out);
    int bestGain = 0;
    Run bestRun{0, 0, true};
    for (const Run& r : runs) {
        if (!r.over && !OPT.under) continue;
        Z3Prep z;
        prepareZ3(D, out, r, z);
        int l = z.distA[z.F2];
        if (r.k - l > bestGain) {
            bestGain = r.k - l;
            bestRun = r;
            if (!apply) return true;
        }
    }
    if (bestGain <= 0) return false;
    Z3Prep z;
    prepareZ3(D, out, bestRun, z);
    vector<vector<int>> paths;
    shortestPaths(z, OPT.seeded ? std::max(1, OPT.paths) : 1, paths);
    CHECK(!paths.empty(), "bestDecZ3: no path");
    size_t pick = 0;
    if (OPT.seeded) pick = std::uniform_int_distribution<size_t>(0, paths.size() - 1)(RNG);
    res = buildZ3(z, paths[pick], bestRun.over, "Z3-decreasing");
    CHECK(res.n == D.n - bestGain, "Z3-decreasing crossing count");
    return true;
}

static bool hasDecreasing(const Diagram& D) {
    if (D.n == 0) return false;
    if (hasR1(D) || hasR2(D)) return true;
    Diagram dummy;
    return bestDecZ3(D, dummy, false);
}

static void horizontalChildren(const Diagram& D, vector<Diagram>& kids) {
    vector<int> out = traversal(D, 0);
    vector<Run> runs = findRuns(D, out);
    for (const Run& r : runs) {
        if (!r.over && !OPT.under) continue;
        if (r.k < OPT.hmin) continue;
        Z3Prep z;
        prepareZ3(D, out, r, z);
        if (z.distA[z.F2] != r.k) continue;
        vector<vector<int>> paths;
        shortestPaths(z, OPT.paths, paths);
        for (auto& p : paths) {
            Diagram c = buildZ3(z, p, r.over, "Z3-horizontal");
            CHECK(c.n == D.n, "Z3-horizontal crossing count");
            kids.push_back(std::move(c));
        }
    }
}

// BFS over horizontal moves; returns a state with a decreasing move
static bool horizontalSearch(const Diagram& D, Diagram& res) {
    std::unordered_set<string> visited;
    visited.insert(canonKey(D));
    vector<Diagram> frontier{D};
    for (int depth = 1; depth <= OPT.H; depth++) {
        vector<Diagram> next;
        for (const Diagram& S : frontier) {
            vector<Diagram> kids;
            horizontalChildren(S, kids);
            for (Diagram& c : kids) {
                string key = canonKey(c);
                if (!visited.insert(key).second) continue;
                ST.bfsStates++;
                if (hasDecreasing(c)) {
                    res = std::move(c);
                    ST.z3hor += depth;
                    return true;
                }
                if ((int)visited.size() >= OPT.maxStates) return false;
                next.push_back(std::move(c));
            }
        }
        frontier.swap(next);
        if (frontier.empty()) break;
    }
    return false;
}
// NOTE: horizontalSearch returns only the final state of the horizontal
// sequence; every intermediate state was produced by validated Z3 moves.

static Diagram simplify(Diagram D) {
    validate(D, "input");
    while (D.n > 0) {
        Diagram R;
        if (tryR1(D, R)) { ST.r1++; D = std::move(R); continue; }
        if (tryR2(D, R)) { ST.r2++; D = std::move(R); continue; }
        if (bestDecZ3(D, R, true)) { ST.z3dec++; D = std::move(R); continue; }
        if (OPT.H > 0 && horizontalSearch(D, R)) { D = std::move(R); continue; }
        break;
    }
    return D;
}

static Diagram scrambleDiagram(Diagram D, int moves) {
    for (int t = 0; t < moves && D.n > 0; t++) {
        vector<int> out = traversal(D, 0);
        vector<Run> runs = findRuns(D, out);
        const Run& r =
            runs[std::uniform_int_distribution<size_t>(0, runs.size() - 1)(RNG)];
        Z3Prep z;
        prepareZ3(D, out, r, z);
        vector<int> path;
        if (!randomPath(z, path)) continue;
        Diagram c = buildZ3(z, path, r.over, "scramble");
        CHECK(c.n == D.n - r.k + (int)path.size(), "scramble crossing count");
        D = std::move(c);
    }
    return D;
}

// ------------------------------------------------------------------ I/O
static void emit(const string& name, int nin, const Diagram& D) {
    vector<int> pd = toPD(D);
    // self-check: the printed PD re-parses to an isomorphic diagram
    if (D.n > 0) {
        vector<long long> a(pd.begin(), pd.end());
        Diagram E;
        string err;
        CHECK(parsePD(a, E, err), "output PD does not re-parse: " + err);
        validate(E, "re-parsed output");
        CHECK(canonKey(E) == canonKey(D), "output PD is not the diagram");
    }
    std::ostringstream os;
    os << name << ' ' << nin << ' ' << D.n;
    for (int v : pd) os << ' ' << v;
    std::cout << os.str() << '\n';
}

static int selftest();

int main(int argc, char** argv) {
    for (int i = 1; i < argc; i++) {
        string a = argv[i];
        auto need = [&](void) -> long long {
            if (i + 1 >= argc) die("missing value for " + a);
            return std::atoll(argv[++i]);
        };
        if (a == "--H") OPT.H = (int)need();
        else if (a == "--paths") OPT.paths = (int)need();
        else if (a == "--maxstates") OPT.maxStates = (int)need();
        else if (a == "--hmin") OPT.hmin = (int)need();
        else if (a == "--seed") { OPT.seeded = true; OPT.seed = (uint64_t)need(); RNG.seed(OPT.seed); }
        else if (a == "--no-under") OPT.under = false;
        else if (a == "--scramble") OPT.scramble = (int)need();
        else if (a == "--selftest") OPT.selftest = true;
        else if (a == "-v") OPT.verbose = true;
        else die("unknown option " + a);
    }
    if (OPT.selftest) return selftest();
    string line;
    while (std::getline(std::cin, line)) {
        std::istringstream is(line);
        string name;
        long long n;
        if (!(is >> name)) continue;
        if (name[0] == '#') continue;
        if (!(is >> n)) die("line without n: " + name);
        vector<long long> a;
        long long v;
        while (is >> v) a.push_back(v);
        if ((long long)a.size() != 4 * n)
            die(name + ": expected " + std::to_string(4 * n) + " labels, got " +
                std::to_string(a.size()));
        Diagram D;
        string err;
        if (!parsePD(a, D, err)) die(name + ": bad PD: " + err);
        validate(D, name + " input");
        Stats before = ST;
        Diagram R = (OPT.scramble > 0) ? scrambleDiagram(D, OPT.scramble)
                                       : simplify(D);
        emit(name, (int)n, R);
        if (OPT.verbose)
            std::fprintf(stderr,
                         "%s: %lld -> %d  R1=%lld R2=%lld Z3dec=%lld "
                         "Z3hor(depth sum)=%lld bfsStates=%lld\n",
                         name.c_str(), n, R.n, ST.r1 - before.r1,
                         ST.r2 - before.r2, ST.z3dec - before.z3dec,
                         ST.z3hor - before.z3hor,
                         ST.bfsStates - before.bfsStates);
    }
    return 0;
}

// --------------------------------------------------------------- selftest
static Diagram mustParse(const vector<long long>& a, const string& nm) {
    Diagram D;
    string err;
    if (!parsePD(a, D, err)) die("selftest " + nm + ": " + err);
    validate(D, "selftest " + nm);
    return D;
}

static int selftest() {
    // trefoil, figure-eight (KnotTheory PD), and a 2-crossing R2 unknot
    vector<long long> tref = {1, 5, 2, 4, 3, 1, 4, 6, 5, 3, 6, 2};
    vector<long long> fig8 = {4, 2, 5, 1, 8, 6, 1, 5, 6, 3, 7, 4, 2, 7, 3, 8};
    vector<long long> loop1 = {1, 1, 2, 2};
    struct T { string nm; vector<long long> pd; int expect; };
    vector<T> tests = {{"3_1", tref, 3}, {"4_1", fig8, 4}, {"R1loop", loop1, 0}};
    int fails = 0;
    for (auto& t : tests) {
        Diagram D = mustParse(t.pd, t.nm);
        Diagram R = simplify(D);
        std::printf("selftest %s: n=%d -> %d (expected %d) %s\n", t.nm.c_str(),
                    D.n, R.n, t.expect, R.n == t.expect ? "OK" : "FAIL");
        if (R.n != t.expect) fails++;
        // random scrambles must stay valid and must simplify back without
        // ever going below the minimal crossing number of the knot
        for (int s = 0; s < 200; s++) {
            Diagram S = scrambleDiagram(D, 1 + s % 6);
            vector<int> pd = toPD(S);
            vector<long long> a(pd.begin(), pd.end());
            Diagram E = mustParse(a, t.nm + " scrambled");
            CHECK(canonKey(E) == canonKey(S), "selftest: PD round trip");
            Diagram R2 = simplify(E);
            CHECK(R2.n >= t.expect, "selftest: went below crossing number");
        }
        std::printf("selftest %s: 200 random scrambles valid, re-simplified "
                    "without going below %d\n",
                    t.nm.c_str(), t.expect);
    }
    std::printf("selftest %s\n", fails ? "FAILED" : "PASSED");
    return fails ? 1 : 0;
}
