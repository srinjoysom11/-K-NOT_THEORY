// Can stochastic Reidemeister search unknot the published hard unknot diagrams?
//
// Staged search: from the current diagram (m crossings) random-walk / anneal, with at most
// m+cap crossings, until a diagram with fewer than m crossings appears; keep it, remove what
// R1/R2 can remove, and repeat until 0 crossings.  Every move is a Regina-checked Reidemeister
// move, so "solved" is a proof that the diagram is the unknot.
//
// usage: unknot file method cap stageBudget maxStages seeds [Thi Tlo]
//   file line: name n pd...     method: walk | sa
#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <random>
#include <sstream>
#include <string>
#include <vector>
#include "link/link.h"
using regina::Link; using regina::StrandRef;
using Clock = std::chrono::steady_clock;

struct Mover {
    std::mt19937_64 rng;
    explicit Mover(uint64_t s) : rng(s) {}
    double u() { return std::uniform_real_distribution<double>(0, 1)(rng); }
    int ri(int n) { return int(rng() % uint64_t(n)); }
    bool tryRemove(Link& L) {
        size_t n = L.size(); if (!n) return false;
        for (int t = 0; t < 4; ++t) {
            regina::Crossing* c = L.crossing(ri(int(n)));
            if (L.hasR1(c)) { L.r1(c); return true; }
            if (L.hasR2(c)) { L.r2(c); return true; }
        }
        return false;
    }
    bool tryR3(Link& L) {
        size_t n = L.size(); if (!n) return false;
        for (int t = 0; t < 12; ++t) {
            regina::Crossing* c = L.crossing(ri(int(n))); int s = ri(2);
            if (L.hasR3(c, s)) { L.r3(c, s); return true; }
        }
        return false;
    }
    StrandRef arc(Link& L) { return StrandRef(L.crossing(ri(int(L.size()))), ri(2)); }
    bool tryR2Add(Link& L) {
        for (int t = 0; t < 30; ++t) {
            StrandRef a = arc(L), b = arc(L); int sa = ri(2), sb = ri(2);
            if (L.hasR2(a, sa, b, sb)) { L.r2(a, sa, b, sb); return true; }
        }
        return false;
    }
    bool tryR1Add(Link& L) {
        StrandRef a = arc(L); int side = ri(2), sign = ri(2) ? 1 : -1;
        if (L.hasR1(a, side, sign)) { L.r1(a, side, sign); return true; }
        return false;
    }
    bool step(Link& L, double T, size_t cap) {
        if (u() < 0.30 && tryRemove(L)) return true;
        double r = u();
        if (r < 0.60) return tryR3(L);
        size_t before = L.size(); Link backup(L);
        bool ok = (r < 0.92) ? tryR2Add(L) : tryR1Add(L);
        if (!ok) return false;
        size_t delta = L.size() - before;
        if (L.size() > cap || u() >= std::exp(-double(delta) / T)) L = std::move(backup);
        return true;
    }
};

int main(int argc, char** argv) {
    if (argc < 7) { std::fprintf(stderr, "usage: %s file method cap stageBudget maxStages seeds [Thi Tlo]\n", argv[0]); return 2; }
    std::string method = argv[2]; size_t capExtra = std::atoi(argv[3]);
    long stageBudget = std::atol(argv[4]); int maxStages = std::atoi(argv[5]), seeds = std::atoi(argv[6]);
    double Thi = argc > 7 ? std::atof(argv[7]) : 3.0, Tlo = argc > 8 ? std::atof(argv[8]) : 0.6;
    std::ifstream in(argv[1]); std::string line;
    while (std::getline(in, line)) {
        std::istringstream ss(line); std::string name; int n; ss >> name >> n;
        std::vector<std::array<int, 4>> pd(n); for (auto& c : pd) for (int& v : c) ss >> v;
        Link L0 = Link::fromPD(pd.begin(), pd.end());
        int solved = 0; double sumProp = 0, sumMs = 0; size_t worst = 0;
        for (int seed = 1; seed <= seeds; ++seed) {
            Mover m(1000003ULL * seed + 17);
            Link cur(L0); long props = 0; auto t0 = Clock::now(); int stalls = 0;
            for (int stage = 0; stage < maxStages * 50 && cur.size() > 0; ++stage) {
                size_t m0 = cur.size(), cap = m0 + capExtra; bool won = false; Link w(cur);
                for (long i = 0; i < stageBudget; ++i, ++props) {
                    double T = method == "walk" ? 1e3 : Thi * std::pow(Tlo / Thi, double(i) / double(stageBudget));
                    m.step(w, T, cap);
                    if (w.size() < m0) { won = true; break; }
                }
                if (won) { cur = std::move(w); while (cur.simplifyToLocalMinimum()) {} stalls = 0; }
                else if (++stalls >= maxStages) break;                // give up after maxStages failed stages in a row
            }
            double ms = std::chrono::duration<double, std::milli>(Clock::now() - t0).count();
            if (cur.size() == 0) { ++solved; sumProp += props; sumMs += ms; }
            worst = std::max(worst, cur.size());
        }
        std::printf("%-8s n=%-3d %s cap=n+%zu: solved %d/%d", name.c_str(), n, method.c_str(), capExtra, solved, seeds);
        if (solved) std::printf("  mean proposals %.0f  mean %.0f ms", sumProp / solved, sumMs / solved);
        else std::printf("  (worst final size %zu)", worst);
        std::printf("\n"); std::fflush(stdout);
    }
    return 0;
}
