// Global Reidemeister closure with union-find.
//
// States are diagrams (identified by Regina signatures, up to reflection,
// rotation and reversal).  Moves: R3, all crossing-removing R1/R2, and R2 that
// adds crossings, as long as the diagram stays within n+h crossings.  All
// states reached from a diagram represent the same knot, so:
//   * diagrams whose searches meet are merged into one class (one SnapPy call)
//   * any state with fewer than n crossings proves the class is reducible
// Every step is a Regina-checked Reidemeister move, so both conclusions are
// proofs.  Each state is explored once for the whole input.
//
// usage: bfsclose input.txt out.txt h maxStatesPerStart [D] [A]  (D = max R3 moves after a crossing-adding R2; A = max sampled R2-adds per n-crossing state)
// input line: id n pd...   output line: id root_class reducible(0/1)
#include <array>
#include <cstdio>
#include <cstdlib>
#include <deque>
#include <fstream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
#include "link/link.h"

using regina::Link;
using regina::StrandRef;

struct UF {
    std::vector<long> p; std::vector<char> red;
    long add() { p.push_back(long(p.size())); red.push_back(0); return long(p.size()) - 1; }
    long find(long x) { while (p[x] != x) { p[x] = p[p[x]]; x = p[x]; } return x; }
    void unite(long a, long b) { a = find(a); b = find(b); if (a != b) { p[a] = b; red[b] |= red[a]; } }
};

int main(int argc, char** argv) {
    if (argc < 5 || argc > 7) { std::fprintf(stderr, "usage: %s in out h maxStates\n", argv[0]); return 2; }
    const int h = std::atoi(argv[3]);
    const long maxStates = std::atol(argv[4]);
    const int D = argc >= 6 ? std::atoi(argv[5]) : 1000;
    const size_t A = argc >= 7 ? size_t(std::atoi(argv[6])) : size_t(1) << 30;
    uint64_t rs = 88172645463325252ULL;
    auto rnd = [&]() { rs ^= rs << 13; rs ^= rs >> 7; rs ^= rs << 17; return rs; };
    std::ifstream in(argv[1]);
    FILE* out = std::fopen(argv[2], "w");
    std::unordered_map<std::string, long> seen;
    UF uf;
    struct Rec { long id; long node; };
    std::vector<Rec> recs;
    std::string line;
    long statesTotal = 0, truncated = 0;
    while (std::getline(in, line)) {
        std::istringstream ss(line);
        long id; int n; ss >> id >> n;
        std::vector<std::array<int, 4>> pd(n);
        for (auto& c : pd) for (int& v : c) ss >> v;
        Link L = Link::fromPD(pd.begin(), pd.end());
        std::string s0 = L.knotSig(true, true, true);
        auto it = seen.find(s0);
        if (it != seen.end()) { recs.push_back({id, it->second}); continue; }
        long node = uf.add();
        seen.emplace(s0, node);
        recs.push_back({id, node});
        std::deque<std::pair<Link,int>> queue;      // (diagram, R3 depth since last crossing-adding move)
        queue.emplace_back(std::move(L), 0);
        long explored = 0;
        const size_t nmax = size_t(n + h);
        auto visit = [&](Link& M, int depth) {
            std::string s = M.knotSig(true, true, true);
            auto f = seen.find(s);
            if (f != seen.end()) { uf.unite(node, f->second); return; }
            seen.emplace(s, node);
            ++statesTotal;
            if (M.size() < size_t(n)) { uf.red[uf.find(node)] = 1; return; }
            queue.emplace_back(std::move(M), depth);
        };
        while (!queue.empty() && !uf.red[uf.find(node)] && explored < maxStates) {
            Link cur = std::move(queue.front().first); int dep = queue.front().second; queue.pop_front();
            ++explored;
            const size_t m = cur.size();
            for (size_t c = 0; c < m && !uf.red[uf.find(node)]; ++c) {
                regina::Crossing* cc = cur.crossing(c);
                if (cur.hasR1(cc)) { Link M(cur); M.r1(M.crossing(c)); visit(M, 0); }
                if (cur.hasR2(cc)) { Link M(cur); M.r2(M.crossing(c)); visit(M, 0); }
                for (int side = 0; side < 2; ++side)
                    if (cur.hasR3(cc, side) && (m <= size_t(n) || dep < D)) { Link M(cur); M.r3(M.crossing(c), side); visit(M, m <= size_t(n) ? 0 : dep + 1); }
            }
            if (m + 2 <= nmax && !uf.red[uf.find(node)]) {
                struct Add { unsigned c1, c2; unsigned char t1, t2, s1, s2; };
                std::vector<Add> adds;
                for (size_t c1 = 0; c1 < m; ++c1) for (int t1 = 0; t1 < 2; ++t1)
                for (size_t c2 = 0; c2 < m; ++c2) for (int t2 = 0; t2 < 2; ++t2)
                for (int s1 = 0; s1 < 2; ++s1) for (int s2 = 0; s2 < 2; ++s2) {
                    if (cur.hasR2(StrandRef(cur.crossing(c1), t1), s1, StrandRef(cur.crossing(c2), t2), s2))
                        adds.push_back({unsigned(c1), unsigned(c2), (unsigned char)t1, (unsigned char)t2, (unsigned char)s1, (unsigned char)s2});
                }
                for (size_t i = adds.size(); i > 1; --i) std::swap(adds[i - 1], adds[rnd() % i]);
                if (adds.size() > A) adds.resize(A);
                for (auto& a : adds) {
                    Link M(cur);
                    M.r2(StrandRef(M.crossing(a.c1), a.t1), a.s1, StrandRef(M.crossing(a.c2), a.t2), a.s2);
                    visit(M, 1);
                    if (uf.red[uf.find(node)]) break;
                }
            }
        }
        if (!queue.empty() && !uf.red[uf.find(node)]) ++truncated;
    }
    for (auto& r : recs) {
        long root = uf.find(r.node);
        std::fprintf(out, "%ld %ld %d\n", r.id, root, int(uf.red[root]));
    }
    std::fprintf(stderr, "classes (roots) %zu, states %ld, truncated starts %ld\n",
                 [&]{ std::vector<char> m(uf.p.size()); size_t k = 0; for (auto& r : recs) { long q = uf.find(r.node); if (!m[q]) { m[q] = 1; ++k; } } return k; }(),
                 statesTotal, truncated);
    std::fclose(out);
    return 0;
}
