// Candidate-generation kernel.
//
// For every knot shadow in the input file (shard i of K), resolve every
// crossing assignment (crossing 0 fixed: mirror symmetry), build the diagram
// with Regina's C++ engine, run Regina's simplify(), and emit the survivors
// (diagrams simplify() could not reduce).  Survivors are deduplicated per
// shadow with Regina's knot signatures.  Diagrams that simplify away are never
// signed: they are dropped anyway, so signing them is wasted work.
//
// usage: gen shadows.txt shard nshards out.txt
// shadows.txt:  count, then per shadow:  n, lab[4n], arr0[n], arr1[n]
// out.txt:      "si bits" per survivor, then a "#stats ..." line.
#include <array>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <set>
#include <string>
#include <vector>
#include "link/link.h"

using Clock = std::chrono::steady_clock;

struct Shadow {
    int n;
    std::vector<int> lab, arr0, arr1;
    std::vector<std::array<int, 3>> cons;     // bigon constraints (u, v, c): reducible iff s_u^s_v == c
};

int main(int argc, char** argv) {
    if (argc != 5) {
        std::fprintf(stderr, "usage: %s shadows.txt shard nshards out.txt\n", argv[0]);
        return 2;
    }
    const int shard = std::atoi(argv[2]), nshards = std::atoi(argv[3]);
    std::ifstream in(argv[1]);
    size_t count;
    in >> count;
    std::vector<Shadow> sh(count);
    for (auto& s : sh) {
        in >> s.n;
        s.lab.resize(4 * s.n); s.arr0.resize(s.n); s.arr1.resize(s.n);
        for (auto& v : s.lab) in >> v;
        for (auto& v : s.arr0) in >> v;
        for (auto& v : s.arr1) in >> v;
        int nc; in >> nc; s.cons.resize(nc);
        for (auto& c : s.cons) in >> c[0] >> c[1] >> c[2];
    }
    FILE* out = std::fopen(argv[4], "w");
    uint64_t processed = 0, simplified = 0, survivors = 0, pruned = 0;
    double t_build = 0, t_simp = 0, t_sig = 0;

    for (size_t si = shard; si < count; si += nshards) {
        const Shadow& s = sh[si];
        const int n = s.n;
        std::set<std::string> seen;
        std::vector<std::array<int, 4>> pd(n);
        for (uint64_t bits = 0; bits < (uint64_t(1) << n); bits += 2) {
            bool skip = false;
            for (const auto& c : s.cons)
                if ((int)(((bits >> c[0]) ^ (bits >> c[1])) & 1) == c[2]) { skip = true; break; }
            if (skip) { ++pruned; continue; }
            auto t0 = Clock::now();
            for (int c = 0; c < n; ++c) {
                int q = ((bits >> c) & 1) ? s.arr1[c] : s.arr0[c];
                for (int t = 0; t < 4; ++t) pd[c][t] = s.lab[4 * c + (q + t) % 4];
            }
            regina::Link link = regina::Link::fromPD(pd.begin(), pd.end());
            auto t1 = Clock::now();
            link.simplify();
            auto t2 = Clock::now();
            t_build += std::chrono::duration<double>(t1 - t0).count();
            t_simp += std::chrono::duration<double>(t2 - t1).count();
            ++processed;
            if (link.size() < size_t(n)) { ++simplified; continue; }
            auto t3 = Clock::now();
            std::string key = link.knotSig(true, true, true);
            t_sig += std::chrono::duration<double>(Clock::now() - t3).count();
            if (seen.insert(key).second) {
                // shard key: mirror-invariant knot invariant (any invariant is a valid
                // shard key: diagrams with different values are different knots)
                const auto& J = link.jones();
                // mirror-invariant hash of the whole Jones coefficient sequence
                // (mirror image reverses the sequence); uniform across shards.
                unsigned long long h1 = 1469598103934665603ULL, h2 = 1469598103934665603ULL;
                for (long e = J.minExp(); e <= J.maxExp(); ++e) {
                    h1 = (h1 ^ (unsigned long long)(J[e].longValue() + 1000003)) * 1099511628211ULL;
                    h2 = (h2 ^ (unsigned long long)(J[J.maxExp() - (e - J.minExp())].longValue() + 1000003)) * 1099511628211ULL;
                }
                unsigned long long skey = std::min(h1, h2);
                // alternating iff every edge is under at exactly one end
                std::vector<int> u(2 * n + 1, 0);
                for (int c = 0; c < n; ++c) { ++u[pd[c][0]]; ++u[pd[c][2]]; }
                int alt = 1;
                for (int l = 1; l <= 2 * n; ++l) if (u[l] != 1) { alt = 0; break; }
                std::fprintf(out, "%zu %llu %llu %d\n", si, (unsigned long long)bits, skey, alt);
                ++survivors;
            }
        }
    }
    std::fprintf(out, "#stats %llu %llu %llu %.3f %.3f %.3f %llu\n",
                 (unsigned long long)processed, (unsigned long long)simplified,
                 (unsigned long long)survivors, t_build, t_simp, t_sig, (unsigned long long)pruned);
    std::fclose(out);
    return 0;
}
