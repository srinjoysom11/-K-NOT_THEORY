// Stochastic Reidemeister search: can we prove a diagram is reducible
// (i.e. reach fewer crossings) by actual R1/R2/R3 moves?
//
// Every move is performed by Regina and checked by Regina (has* before r*),
// so a success is a certificate that the knot has a diagram with fewer
// crossings.  Nothing here can mark a minimal diagram as reducible.
//
// usage: search input.txt method budget seed out.txt [shard nshards]
//   method: walk | sa | pt | exh1 | exh2
//   budget: proposals per diagram (ignored for exh*)
// input line:  id n  a1 a2 a3 a4 ... (PD code, 4n ints)
// output line: id best_crossings time_us proposals
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

using regina::Link;
using regina::StrandRef;
using Clock = std::chrono::steady_clock;
static double envd(const char* k, double d) { const char* v = std::getenv(k); return v ? std::atof(v) : d; }

struct Mover {
    std::mt19937_64 rng;
    explicit Mover(uint64_t seed) : rng(seed) {}
    double u() { return std::uniform_real_distribution<double>(0, 1)(rng); }
    int ri(int n) { return int(rng() % uint64_t(n)); }

    // Greedy removals on a random crossing (energy goes down, always accepted).
    bool tryRemove(Link& L) {
        size_t n = L.size();
        if (n == 0) return false;
        for (int t = 0; t < 4; ++t) {
            regina::Crossing* c = L.crossing(ri(int(n)));
            if (L.hasR1(c)) { L.r1(c); return true; }
            if (L.hasR2(c)) { L.r2(c); return true; }
        }
        return false;
    }
    bool tryR3(Link& L) {
        size_t n = L.size();
        for (int t = 0; t < 12; ++t) {
            regina::Crossing* c = L.crossing(ri(int(n)));
            int side = ri(2);
            if (L.hasR3(c, side)) { L.r3(c, side); return true; }
        }
        return false;
    }
    StrandRef arc(Link& L) { return StrandRef(L.crossing(ri(int(L.size()))), ri(2)); }
    bool tryR2Add(Link& L) {
        for (int t = 0; t < 30; ++t) {
            StrandRef a = arc(L), b = arc(L);
            int sa = ri(2), sb = ri(2);
            if (L.hasR2(a, sa, b, sb)) { L.r2(a, sa, b, sb); return true; }
        }
        return false;
    }
    bool tryR1Add(Link& L) {
        StrandRef a = arc(L);
        int side = ri(2), sign = ri(2) ? 1 : -1;
        if (L.hasR1(a, side, sign)) { L.r1(a, side, sign); return true; }
        return false;
    }
    // One Metropolis step at temperature T (T<=0: no uphill moves).  Returns
    // false if no move was possible.  cap = maximum allowed crossings.
    bool step(Link& L, double T, size_t cap) {
        if (u() < 0.30 && tryRemove(L)) return true;
        double r = u();
        if (T <= 0 || r < 0.60) return tryR3(L);
        size_t before = L.size();
        Link backup(L);
        bool ok = (r < 0.92) ? tryR2Add(L) : tryR1Add(L);
        if (!ok) return false;
        size_t delta = L.size() - before;
        if (L.size() > cap || u() >= std::exp(-double(delta) / T)) L = std::move(backup);
        return true;
    }
};

struct Result { size_t best; long proposals; };

Result run_walk(Link L, long budget, Mover& m) {
    size_t n0 = L.size(), best = n0; long p = 0;
    while (p < budget && best >= n0) { m.step(L, 0.0, n0); ++p; best = std::min(best, L.size()); }
    return {best, p};
}

Result run_sa(Link L0, long budget, Mover& m, int restarts, double Thi, double Tlo) {
    size_t n0 = L0.size(), best = n0, cap = n0 + size_t(envd("CAP", 6)); long p = 0;
    long per = std::max(1L, budget / restarts);
    for (int r = 0; r < restarts && best >= n0; ++r) {
        Link L(L0);
        for (long i = 0; i < per && best >= n0; ++i, ++p) {
            double T = Thi * std::pow(Tlo / Thi, double(i) / double(per));
            m.step(L, T, cap);
            best = std::min(best, L.size());
        }
    }
    return {best, p};
}

Result run_pt(const Link& L0, long budget, Mover& m, int R, double Tlo, double Thi, int sweep) {
    size_t n0 = L0.size(), best = n0, cap = n0 + size_t(envd("CAP", 6)); long p = 0;
    std::vector<Link> rep(R, Link(L0));
    std::vector<double> T(R);
    for (int i = 0; i < R; ++i) T[i] = Tlo * std::pow(Thi / Tlo, R > 1 ? double(i) / (R - 1) : 0.0);
    while (p < budget && best >= n0) {
        for (int i = 0; i < R && best >= n0; ++i)
            for (int s = 0; s < sweep; ++s, ++p) {
                m.step(rep[i], T[i], cap);
                best = std::min(best, rep[i].size());
                if (best < n0) break;
            }
        for (int i = (m.ri(2)); i + 1 < R; i += 2) {      // swap neighbouring temperatures
            double d = (1.0 / T[i] - 1.0 / T[i + 1]) * (double(rep[i].size()) - double(rep[i + 1].size()));
            if (d >= 0 || m.u() < std::exp(d)) std::swap(rep[i], rep[i + 1]);
        }
    }
    return {best, p};
}

int main(int argc, char** argv) {
    if (argc < 6) { std::fprintf(stderr, "usage: %s input method budget seed out [shard nshards]\n", argv[0]); return 2; }
    std::string method = argv[2];
    long budget = std::atol(argv[3]);
    uint64_t seed = std::strtoull(argv[4], nullptr, 10);
    int shard = argc > 6 ? std::atoi(argv[6]) : 0, nsh = argc > 7 ? std::atoi(argv[7]) : 1;
    std::ifstream in(argv[1]);
    FILE* out = std::fopen(argv[5], "w");
    std::string line; long idx = 0;
    while (std::getline(in, line)) {
        if ((idx++ % nsh) != shard) continue;
        std::istringstream ss(line);
        long id; int n; ss >> id >> n;
        std::vector<std::array<int, 4>> pd(n);
        for (auto& c : pd) for (int& v : c) ss >> v;
        Link L = Link::fromPD(pd.begin(), pd.end());
        Mover m(seed * 1000003ULL + uint64_t(id));
        auto t0 = Clock::now();
        Result r{size_t(n), 0};
        if (method == "walk") r = run_walk(L, budget, m);
        else if (method == "sa") r = run_sa(L, budget, m, int(envd("SA_RESTARTS", 4)), envd("SA_THI", 1.0), envd("SA_TLO", 0.25));
        else if (method == "pt") r = run_pt(L, budget, m, int(envd("PT_R", 8)), envd("PT_TLO", 0.25), envd("PT_THI", 1.1), int(envd("PT_SWEEP", 20)));
        else if (method == "exh1") { L.simplifyExhaustive(1); r.best = L.size(); }
        else if (method == "exh2") { L.simplifyExhaustive(2); r.best = L.size(); }
        double us = std::chrono::duration<double, std::micro>(Clock::now() - t0).count();
        std::fprintf(out, "%ld %zu %.0f %ld\n", id, r.best, us, r.proposals);
    }
    std::fclose(out);
    return 0;
}
