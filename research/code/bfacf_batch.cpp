/*
 * bfacf_batch.cpp -- multi-threaded BFACF annealing over a list of knots.
 *
 * Same moves, same RNG and same selection rule as bfacf.c + run_search.py, so for
 * equal arguments it reproduces their output word for word; it only removes the
 * Python driver and the one-process-per-run overhead.
 *
 * usage: bfacf_batch IN OUT ROUNDS RUNS CYCLES N_HIGH N_LOW ZMAX ZLOW BASE THREADS
 *   IN  : text file, one "name word" per line
 *   OUT : appended; one "name start_length best_length chain word" per line
 *         (chain = comma-separated round:rngseed steps that improved the word, or "-")
 *   round rd (1..ROUNDS) starts RUNS runs with RNG seeds BASE + 1000*rd + i, i = 1..RUNS,
 *   from the shortest word so far; ties are broken by the smaller RNG seed.
 *   Knots already present in OUT are skipped, so an interrupted batch can be resumed.
 *
 * build: g++ -O2 -std=c++17 -pthread -o bfacf_batch bfacf_batch.cpp
 */
#include <atomic>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <memory>
#include <mutex>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>

#include "bfacf_core.hpp"

int main(int argc, char **argv) {
    if (argc < 12) {
        std::cerr << "usage: bfacf_batch IN OUT ROUNDS RUNS CYCLES N_HIGH N_LOW ZMAX ZLOW BASE THREADS\n";
        return 1;
    }
    std::string in = argv[1], out = argv[2];
    int rounds = atoi(argv[3]), runs = atoi(argv[4]);
    Params p{atol(argv[5]), atol(argv[6]), atol(argv[7]), atof(argv[8]), atof(argv[9])};
    long base = atol(argv[10]);
    int threads = atoi(argv[11]);

    std::set<std::string> done;
    { std::ifstream f(out); std::string line, name; while (std::getline(f, line)) { std::istringstream ss(line); if (ss >> name) done.insert(name); } }
    std::vector<std::pair<std::string, std::string>> jobs;
    { std::ifstream f(in); std::string name, word; while (f >> name >> word) if (!done.count(name)) jobs.push_back({name, word}); }
    std::ofstream fo(out, std::ios::app);
    std::mutex mu;
    std::atomic<size_t> next(0), finished(0);

    auto worker = [&]() {
        auto A = std::make_unique<Annealer>();
        for (;;) {
            size_t j = next++;
            if (j >= jobs.size()) return;
            std::string best = jobs[j].second, chain;
            try {
                for (int rd = 1; rd <= rounds; rd++) {
                    std::string rb; long rseed = 0;
                    for (int i = 1; i <= runs; i++) {
                        long sd = base + 1000L * rd + i;
                        std::string w = A->run(best, (uint64_t)sd, p);
                        if (rb.empty() || w.size() < rb.size()) { rb = w; rseed = sd; }
                    }
                    if (rb.size() < best.size()) {
                        best = rb;
                        chain += (chain.empty() ? "" : ",") + std::to_string(rd) + ":" + std::to_string(rseed);
                    }
                }
            } catch (std::exception &e) {
                std::lock_guard<std::mutex> lk(mu);
                std::cerr << jobs[j].first << " ERROR " << e.what() << std::endl;
                continue;
            }
            std::lock_guard<std::mutex> lk(mu);
            fo << jobs[j].first << ' ' << jobs[j].second.size() << ' ' << best.size() << ' '
               << (chain.empty() ? "-" : chain) << ' ' << best << std::endl;
            size_t k = ++finished;
            if (k % 25 == 0 || k == jobs.size()) std::cerr << k << "/" << jobs.size() << std::endl;
        }
    };
    std::vector<std::thread> pool;
    for (int t = 0; t < threads; t++) pool.emplace_back(worker);
    for (auto &t : pool) t.join();
    return 0;
}
