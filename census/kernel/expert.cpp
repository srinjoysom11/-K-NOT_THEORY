// Expert data for learned search guidance.
//
// For each hard survivor (simplify() fails, but the knot is reducible), run an
// exhaustive BFS over Reidemeister moves (R3, removals, sampled R2-adds, up to
// n+2 crossings) until a diagram with fewer crossings is found.  Then compute,
// for every visited state, its exact move-distance to the nearest reduced
// state inside the explored graph (backward BFS; moves are reversible so the
// graph is undirected).  Emit labelled states:
//     startid  start_n  dist  nstate  pd...
// Every diagram written is reached from the start by Regina-checked moves.
//
// usage: expert in.txt out.txt maxStates adds perStartOthers seed
#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <deque>
#include <fstream>
#include <random>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
#include "link/link.h"
using regina::Link; using regina::StrandRef;

int main(int argc, char** argv) {
    if (argc != 7) { std::fprintf(stderr, "usage: %s in out maxStates adds others seed\n", argv[0]); return 2; }
    const long maxStates = std::atol(argv[3]);
    const size_t A = std::atol(argv[4]);
    const int others = std::atoi(argv[5]);
    std::mt19937_64 rng(std::strtoull(argv[6], nullptr, 10));
    std::ifstream in(argv[1]);
    FILE* out = std::fopen(argv[2], "w");
    std::string line;
    long solved = 0, total = 0;
    while (std::getline(in, line)) {
        std::istringstream ss(line);
        long id; int n; ss >> id >> n;
        std::vector<std::array<int, 4>> pd(n);
        for (auto& c : pd) for (int& v : c) ss >> v;
        Link L0 = Link::fromPD(pd.begin(), pd.end());
        ++total;
        std::vector<Link> nodes; std::vector<std::vector<int>> adj; std::vector<int> depth;
        std::unordered_map<std::string, int> seen;
        auto add = [&](Link&& M, int d) -> int {
            std::string s = M.knotSig(true, true, true);
            auto it = seen.find(s);
            if (it != seen.end()) return it->second;
            int k = int(nodes.size()); seen.emplace(s, k);
            nodes.push_back(std::move(M)); adj.emplace_back(); depth.push_back(d);
            return k;
        };
        add(Link(L0), 0);
        std::vector<int> goals;
        for (size_t qi = 0; qi < nodes.size() && goals.empty() && (long)nodes.size() < maxStates; ++qi) {
            Link cur(nodes[qi]);
            const size_t m = cur.size(), N0 = size_t(n);
            auto link2 = [&](Link&& M) {
                int d = depth[qi] + 1; size_t sz = M.size();
                int k = add(std::move(M), d);
                adj[qi].push_back(k); adj[k].push_back(int(qi));
                if (sz < N0) goals.push_back(k);
            };
            for (size_t c = 0; c < m; ++c) {
                regina::Crossing* cc = cur.crossing(c);
                if (cur.hasR1(cc)) { Link M(cur); M.r1(M.crossing(c)); link2(std::move(M)); }
                if (cur.hasR2(cc)) { Link M(cur); M.r2(M.crossing(c)); link2(std::move(M)); }
                for (int side = 0; side < 2; ++side)
                    if (cur.hasR3(cc, side)) { Link M(cur); M.r3(M.crossing(c), side); link2(std::move(M)); }
            }
            if (m + 2 <= N0 + 2) {
                struct Add { unsigned c1, c2; unsigned char t1, t2, s1, s2; };
                std::vector<Add> adds;
                for (size_t c1 = 0; c1 < m; ++c1) for (int t1 = 0; t1 < 2; ++t1)
                for (size_t c2 = 0; c2 < m; ++c2) for (int t2 = 0; t2 < 2; ++t2)
                for (int s1 = 0; s1 < 2; ++s1) for (int s2 = 0; s2 < 2; ++s2)
                    if (cur.hasR2(StrandRef(cur.crossing(c1), t1), s1, StrandRef(cur.crossing(c2), t2), s2))
                        adds.push_back({unsigned(c1), unsigned(c2), (unsigned char)t1, (unsigned char)t2, (unsigned char)s1, (unsigned char)s2});
                std::shuffle(adds.begin(), adds.end(), rng);
                if (adds.size() > A) adds.resize(A);
                for (auto& a : adds) {
                    Link M(cur);
                    M.r2(StrandRef(M.crossing(a.c1), a.t1), a.s1, StrandRef(M.crossing(a.c2), a.t2), a.s2);
                    link2(std::move(M));
                }
            }
        }
        if (goals.empty()) continue;
        ++solved;
        // exact distance to the nearest goal inside the explored graph
        std::vector<int> dist(nodes.size(), -1);
        std::deque<int> q;
        for (int g : goals) { dist[g] = 0; q.push_back(g); }
        while (!q.empty()) {
            int u = q.front(); q.pop_front();
            for (int v : adj[u]) if (dist[v] < 0) { dist[v] = dist[u] + 1; q.push_back(v); }
        }
        // emit: every state within 6 of a goal, plus random others
        std::vector<int> idx(nodes.size()); for (size_t i = 0; i < idx.size(); ++i) idx[i] = int(i);
        std::shuffle(idx.begin(), idx.end(), rng);
        int extra = 0;
        for (int i : idx) {
            if (dist[i] < 0) continue;
            bool near = dist[i] <= 3;
            if (!near) { if (extra >= others) continue; ++extra; }
            auto p = nodes[i].pdData();
            std::fprintf(out, "%ld %d %d %zu", id, n, dist[i], nodes[i].size());
            for (auto& c : p) for (int v : c) std::fprintf(out, " %d", v);
            std::fprintf(out, "\n");
        }
    }
    std::fprintf(stderr, "solved %ld of %ld starts\n", solved, total);
    std::fclose(out);
    return 0;
}
