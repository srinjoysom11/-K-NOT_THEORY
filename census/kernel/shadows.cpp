// Shadow enumeration in C++ (port of knotml/maps.py), no Regina needed.
//
//   nonseparable plane maps with m edges, built edge by edge  ->  medial graphs
//   (4-regular shadows)  ->  canonical dedupe  ->  single-component filter.
//
// usage: shadows N out_dir
// writes  out_dir/shadows_N.txt  (format read by kernel/gen: count, then per shadow:
//         n, lab[4n], arr0[n], arr1[n], nbigons u v c ...)
//         out_dir/altpd_N.txt    ("id n pd..." of the alternating diagram of each shadow)
#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <map>
#include <string>
#include <vector>
using std::vector;
typedef vector<int> Code;

static void vertex_cycles(const vector<int>& sigma, vector<int>& vid, vector<vector<int>>& cycles) {
    int nd = sigma.size(); vid.assign(nd, -1); cycles.clear();
    for (int d = 0; d < nd; ++d) {
        if (vid[d] >= 0) continue;
        vector<int> cyc; int x = d;
        while (vid[x] < 0) { vid[x] = cycles.size(); cyc.push_back(x); x = sigma[x]; }
        cycles.push_back(cyc);
    }
}
static vector<vector<int>> face_cycles(const vector<int>& sigma, const vector<int>* alpha) {
    int nd = sigma.size(); vector<char> seen(nd, 0); vector<vector<int>> out;
    for (int d = 0; d < nd; ++d) {
        if (seen[d]) continue;
        vector<int> cyc; int x = d;
        while (!seen[x]) { seen[x] = 1; cyc.push_back(x); x = alpha ? sigma[(*alpha)[x]] : sigma[x ^ 1]; }
        out.push_back(cyc);
    }
    return out;
}
static bool nonseparable(const vector<int>& sigma) {
    int m = sigma.size() / 2; vector<int> vid; vector<vector<int>> cycles; vertex_cycles(sigma, vid, cycles);
    int nv = cycles.size(); vector<vector<int>> adj(nv);
    for (int e = 0; e < m; ++e) {
        int a = vid[2 * e], b = vid[2 * e + 1];
        if (a == b) return false;
        adj[a].push_back(b); adj[b].push_back(a);
    }
    if (nv == 2) return true;
    vector<int> disc(nv, -1), low(nv, 0), it(nv, 0), par(nv, -1);
    int t = 1, rootChildren = 0; disc[0] = low[0] = 0;
    vector<int> st = {0};
    while (!st.empty()) {
        int v = st.back();
        if (it[v] < (int)adj[v].size()) {
            int w = adj[v][it[v]++];
            if (disc[w] < 0) { disc[w] = low[w] = t++; par[w] = v; st.push_back(w); if (v == 0) ++rootChildren; }
            else if (w != par[v]) low[v] = std::min(low[v], disc[w]);
        } else {
            st.pop_back();
            if (!st.empty()) {
                int p = st.back(); low[p] = std::min(low[p], low[v]);
                if (p != 0 && low[v] >= disc[p]) return false;
            }
        }
    }
    return t == nv && rootChildren <= 1;
}
static Code canon(const vector<int>& sigma, const vector<int>* alphaIn) {
    int nd = sigma.size(); vector<int> alpha(nd);
    for (int d = 0; d < nd; ++d) alpha[d] = alphaIn ? (*alphaIn)[d] : (d ^ 1);
    vector<int> sinv(nd); for (int d = 0; d < nd; ++d) sinv[sigma[d]] = d;
    vector<int> fs(nd, 0), deg(nd, 0);
    for (auto& cyc : face_cycles(sigma, &alpha)) for (int d : cyc) fs[d] = cyc.size();
    { vector<char> seen(nd, 0);
      for (int d = 0; d < nd; ++d) if (!seen[d]) {
          vector<int> cyc; int x = d; while (!seen[x]) { seen[x] = 1; cyc.push_back(x); x = sigma[x]; }
          for (int y : cyc) deg[y] = cyc.size(); } }
    typedef std::array<int, 3> Sig; vector<Sig> sig(nd);
    for (int d = 0; d < nd; ++d) sig[d] = {deg[d], std::min(fs[d], fs[alpha[d]]), std::max(fs[d], fs[alpha[d]])};
    Sig mn = *std::min_element(sig.begin(), sig.end());
    vector<int> roots; for (int d = 0; d < nd; ++d) if (sig[d] == mn) roots.push_back(d);
    Code best; bool have = false;
    vector<int> lab(nd), order; order.reserve(nd);
    for (int r = 0; r < 2; ++r) {
        const vector<int>& rot = r == 0 ? sigma : sinv;
        for (int s : roots) {
            std::fill(lab.begin(), lab.end(), -1); order.clear(); order.push_back(s); lab[s] = 0;
            for (size_t i = 0; i < order.size(); ++i) {
                int d = order[i];
                for (int x : {alpha[d], rot[d]}) if (lab[x] < 0) { lab[x] = order.size(); order.push_back(x); }
            }
            Code code; code.reserve(2 * nd);
            for (int d : order) { code.push_back(lab[alpha[d]]); code.push_back(lab[rot[d]]); }
            if (!have || code < best) { best = code; have = true; }
        }
    }
    return best;
}
static vector<vector<int>> children(const vector<int>& sigma) {
    int m = sigma.size() / 2, x = 2 * m, y = 2 * m + 1; vector<vector<int>> out;
    vector<int> vid; vector<vector<int>> cycles; vertex_cycles(sigma, vid, cycles);
    for (auto& face : face_cycles(sigma, nullptr)) {
        vector<int> corners; for (int d : face) corners.push_back(d ^ 1);
        for (size_t i = 0; i < corners.size(); ++i) for (size_t j = i + 1; j < corners.size(); ++j) {
            int a1 = corners[i], a2 = corners[j];
            if (vid[a1] == vid[a2]) continue;
            vector<int> s2 = sigma; s2.push_back(0); s2.push_back(0);
            s2[x] = sigma[a1]; s2[a1] = x; s2[y] = sigma[a2]; s2[a2] = y;
            out.push_back(std::move(s2));
        }
    }
    for (auto& cyc : cycles) {
        int k = cyc.size(); if (k < 2) continue;
        for (int l = 1; l <= k / 2; ++l) for (int i = 0; i < k; ++i) {
            if (2 * l == k && i >= l) continue;
            vector<int> A, B;
            for (int t = 0; t < l; ++t) A.push_back(cyc[(i + t) % k]);
            for (int t = 0; t < k - l; ++t) B.push_back(cyc[(i + l + t) % k]);
            vector<int> s2 = sigma; s2.push_back(0); s2.push_back(0);
            const vector<int>* arcs[2] = {&A, &B}; int news[2] = {x, y};
            for (int q = 0; q < 2; ++q) {
                const vector<int>& arc = *arcs[q]; int nw = news[q];
                for (size_t t = 0; t + 1 < arc.size(); ++t) s2[arc[t]] = arc[t + 1];
                s2[arc.back()] = nw; s2[nw] = arc[0];
            }
            out.push_back(std::move(s2));
        }
    }
    return out;
}
static void medial(const vector<int>& sigma, vector<int>& sm, vector<int>& am) {
    int n = sigma.size() / 2; vector<int> sinv(sigma.size());
    for (size_t d = 0; d < sigma.size(); ++d) sinv[sigma[d]] = d;
    auto after = [](int x) { return 4 * (x >> 1) + (x % 2 == 0 ? 1 : 3); };
    auto before = [](int x) { return 4 * (x >> 1) + (x % 2 == 0 ? 2 : 0); };
    sm.assign(4 * n, 0); am.assign(4 * n, 0);
    for (int i = 0; i < n; ++i) {
        int d = 2 * i, dp = 2 * i + 1;
        for (int p = 0; p < 4; ++p) sm[4 * i + p] = 4 * i + (p + 1) % 4;
        am[4 * i + 1] = before(sigma[d]); am[4 * i + 3] = before(sigma[dp]);
        am[4 * i + 2] = after(sinv[d]);   am[4 * i + 0] = after(sinv[dp]);
    }
}

int main(int argc, char** argv) {
    if (argc != 3) { std::fprintf(stderr, "usage: %s N out_dir\n", argv[0]); return 2; }
    int N = std::atoi(argv[1]); std::string dir = argv[2];
    vector<vector<int>> cur = {{1, 0}};
    for (int m = 2; m <= N; ++m) {
        std::map<Code, vector<int>> seen;
        for (auto& s : cur) for (auto& ch : children(s)) {
            if (!nonseparable(ch)) continue;
            Code c = canon(ch, nullptr);
            if (!seen.count(c)) seen.emplace(std::move(c), ch);
        }
        cur.clear(); for (auto& kv : seen) cur.push_back(kv.second);
        std::fprintf(stderr, "m=%d: %zu non-separable maps\n", m, cur.size());
    }
    // medial shadows of the N-edge maps
    std::map<Code, std::pair<vector<int>, vector<int>>> med;
    for (auto& s : cur) {
        vector<int> sm, am; medial(s, sm, am);
        if ((int)face_cycles(sm, &am).size() != N + 2) { std::fprintf(stderr, "medial not planar: bug\n"); return 1; }
        Code c = canon(sm, &am);
        if (!med.count(c)) med.emplace(std::move(c), std::make_pair(sm, am));
    }
    FILE* fs = std::fopen((dir + "/shadows_" + argv[1] + ".txt").c_str(), "w");
    FILE* fa = std::fopen((dir + "/altpd_" + argv[1] + ".txt").c_str(), "w");
    vector<std::string> blocks, altlines;
    for (auto& kv : med) {
        const vector<int>& sm = kv.second.first; const vector<int>& am = kv.second.second;
        int n = N; vector<int> lab(4 * n, 0), arr0(n, -1), arr1(n, -1);
        vector<std::pair<int, int>> passes; int h = 0, k = 0;
        for (;;) {
            ++k; int a = am[h]; lab[h] = lab[a] = k;
            int c = a >> 2, q = a & 3; passes.push_back({c, q});
            h = 4 * c + (q + 2) % 4;
            if (h == 0 || k > 2 * n) break;
        }
        if (!(h == 0 && k == 2 * n)) continue;                          // not a knot
        for (auto& p : passes) (p.second & 1 ? arr1 : arr0)[p.first] = p.second;
        std::string b = std::to_string(n) + "\n";
        for (int v : lab) b += std::to_string(v) + " "; b += "\n";
        for (int v : arr0) b += std::to_string(v) + " "; b += "\n";
        for (int v : arr1) b += std::to_string(v) + " "; b += "\n";
        vector<std::array<int, 3>> cons;
        for (auto& cyc : face_cycles(sm, &am)) if (cyc.size() == 2) {
            int hh = cyc[0], a = am[hh], u = hh >> 2, v = a >> 2;
            if (u != v) cons.push_back({u, v, ((hh & 3) & 1) ^ ((a & 3) & 1)});
        }
        b += std::to_string(cons.size());
        for (auto& c : cons) b += " " + std::to_string(c[0]) + " " + std::to_string(c[1]) + " " + std::to_string(c[2]);
        b += "\n"; blocks.push_back(b);
        // alternating diagram: even passes go under; crossing 0 normalised to bit 0
        vector<int> bit(n, -1); bool ok = true;
        for (size_t j = 0; j < passes.size(); ++j) {
            int c = passes[j].first, q = passes[j].second;
            int want = (j % 2 == 0) ? (q & 1) : ((q & 1) ^ 1);
            if (bit[c] >= 0 && bit[c] != want) ok = false;
            bit[c] = want;
        }
        if (!ok) { std::fprintf(stderr, "shadow not alternating-resolvable: bug\n"); return 1; }
        if (bit[0] == 1) for (int& x : bit) x = 1 - x;
        std::string al = std::to_string(altlines.size()) + " " + std::to_string(n);
        for (int c = 0; c < n; ++c) {
            int q = bit[c] ? arr1[c] : arr0[c];
            for (int t = 0; t < 4; ++t) al += " " + std::to_string(lab[4 * c + (q + t) % 4]);
        }
        altlines.push_back(al + "\n");
    }
    std::fprintf(fs, "%zu\n", blocks.size()); for (auto& b : blocks) std::fputs(b.c_str(), fs);
    for (auto& l : altlines) std::fputs(l.c_str(), fa);
    std::fclose(fs); std::fclose(fa);
    std::fprintf(stderr, "wrote %zu shadows\n", blocks.size());
    return 0;
}
