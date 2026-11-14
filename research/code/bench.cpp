/*
 * bench.cpp -- time-to-target benchmark for lattice-knot search methods.
 *
 * Every method uses the same primitive (one attempted BFACF move, bfacf_core.hpp) and
 * the same budget of attempted moves, so methods are compared move for move.
 * A run stops as soon as the polygon reaches the target length.
 *
 * usage: bench IN OUT LABEL RUNS BUDGET BASE THREADS METHOD [params]
 *   IN    : lines "name word target"
 *   OUT   : appended; lines "label name seed hit_attempts best_length trace"
 *           hit_attempts = attempted moves when the target was first reached, -1 if never
 *           trace = length@attempts for every new record, ';'-separated
 *   seeds : BASE + 1 .. BASE + RUNS (same seeds for every method)
 *   METHOD cycle ZMAX ZLOW NHIGH NLOW [GAMMA]
 *            repeat: NHIGH attempts at z ~ U(0,ZMAX), then NLOW attempts at ZLOW.
 *            (0.2 0.02 100000 60000 is the protocol of Scharein et al. 2009.)
 *   METHOD rrt Z DELTA [GAMMA]
 *            "record-to-record": constant fugacity Z, but any +2 move that would lift the
 *            length above (best length so far + DELTA) is refused. Z may exceed the
 *            critical fugacity 0.2134 because the cap stops the polygon from growing.
 *   GAMMA (optional, default 0): contact bias on neutral moves, see bfacf_core.hpp.
 *
 * build: g++ -O2 -std=c++17 -pthread -static -o bench bench.cpp
 */
#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <memory>
#include <mutex>
#include <sstream>
#include <thread>
#include "bfacf_core.hpp"

struct Job { std::string name, word; int target; long seed; };

int main(int argc, char **argv) {
    if (argc < 9) { std::cerr << "usage: bench IN OUT LABEL RUNS BUDGET BASE THREADS METHOD [params]\n"; return 1; }
    std::string in = argv[1], out = argv[2], label = argv[3];
    int runs = atoi(argv[4]);
    long long budget = atoll(argv[5]);
    long base = atol(argv[6]);
    int threads = atoi(argv[7]);
    std::string method = argv[8];
    auto arg = [&](int i, double dflt) { return argc > i ? atof(argv[i]) : dflt; };
    double zmax = 0, zlow = 0, z = 0, gamma = 0; long nhigh = 0, nlow = 0; int delta = 0;
    if (method == "cycle") { zmax = arg(9, 0.2); zlow = arg(10, 0.02); nhigh = (long)arg(11, 100000); nlow = (long)arg(12, 60000); gamma = arg(13, 0); }
    else if (method == "rrt") { z = arg(9, 0.1); delta = (int)arg(10, 4); gamma = arg(11, 0); }
    else { std::cerr << "unknown method\n"; return 1; }

    std::vector<Job> jobs;
    { std::ifstream f(in); std::string name, word; int target;
      while (f >> name >> word >> target) for (int r = 1; r <= runs; r++) jobs.push_back({name, word, target, base + r}); }
    std::ofstream fo(out, std::ios::app);
    std::mutex mu;
    std::atomic<size_t> next(0);

    auto worker = [&]() {
        auto A = std::make_unique<Annealer>();
        for (;;) {
            size_t j = next++;
            if (j >= jobs.size()) return;
            const Job &J = jobs[j];
            A->gamma = gamma; A->cap = 1 << 30;
            A->load(J.word);
            A->seed_rng((uint64_t)J.seed);
            int best = A->nact; long long hit = -1, t = 0;
            std::ostringstream tr; tr << best << "@0";
            auto step = [&](double zz) {
                A->attempt(zz); t++;
                if (A->nact < best) { best = A->nact; tr << ';' << best << '@' << t; if (best <= J.target && hit < 0) hit = t; }
            };
            if (method == "cycle") {
                while (t < budget && hit < 0) {
                    double zh = A->runif() * zmax;
                    for (long i = 0; i < nhigh && t < budget && hit < 0; i++) step(zh);
                    for (long i = 0; i < nlow && t < budget && hit < 0; i++) step(zlow);
                }
            } else {
                while (t < budget && hit < 0) { A->cap = best + delta; step(z); }
            }
            std::lock_guard<std::mutex> lk(mu);
            fo << label << ' ' << J.name << ' ' << J.seed << ' ' << hit << ' ' << best << ' ' << tr.str() << std::endl;
        }
    };
    std::vector<std::thread> pool;
    for (int i = 0; i < threads; i++) pool.emplace_back(worker);
    for (auto &th : pool) th.join();
    return 0;
}
