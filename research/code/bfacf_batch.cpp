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

static const int G = 160, MAXV = 8192;
static const int DX[6] = {1, -1, 0, 0, 0, 0};
static const int DY[6] = {0, 0, 1, -1, 0, 0};
static const int DZ[6] = {0, 0, 0, 0, 1, -1};
static const char DC[6] = {'e', 'w', 'n', 's', 'u', 'd'};

struct Params { long cycles, nhigh, nlow; double zmax, zlow; };

struct Annealer {
    std::vector<unsigned char> grid;
    int px[MAXV], py[MAXV], pz[MAXV], nxt[MAXV], prv[MAXV];
    int act[MAXV], whr[MAXV], nact;
    int freelist[MAXV], nfree;
    uint64_t s[4];
    std::string best;

    Annealer() : grid((size_t)G * G * G, 0), nact(0), nfree(0) {}
    unsigned char &g(int x, int y, int z) { return grid[((size_t)x * G + y) * G + z]; }
    static uint64_t rotl(uint64_t x, int k) { return (x << k) | (x >> (64 - k)); }
    uint64_t rnd() {
        uint64_t r = rotl(s[1] * 5, 7) * 9, t = s[1] << 17;
        s[2] ^= s[0]; s[3] ^= s[1]; s[1] ^= s[2]; s[0] ^= s[3]; s[2] ^= t; s[3] = rotl(s[3], 45);
        return r;
    }
    double runif() { return (rnd() >> 11) * (1.0 / 9007199254740992.0); }
    void seed_rng(uint64_t x) {
        for (int i = 0; i < 4; i++) {
            x += 0x9e3779b97f4a7c15ULL;
            uint64_t z = x;
            z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9ULL;
            z = (z ^ (z >> 27)) * 0x94d049bb133111ebULL;
            s[i] = z ^ (z >> 31);
        }
    }
    static int dircode(char c) {
        for (int i = 0; i < 6; i++) if (DC[i] == c) return i;
        throw std::runtime_error(std::string("bad letter ") + c);
    }
    int newv(int x, int y, int z) {
        if (nfree == 0) throw std::runtime_error("out of vertices");
        int v = freelist[--nfree];
        px[v] = x; py[v] = y; pz[v] = z; g(x, y, z) = 1;
        whr[v] = nact; act[nact++] = v;
        return v;
    }
    void delv(int v) {
        g(px[v], py[v], pz[v]) = 0;
        int i = whr[v], w = act[--nact];
        act[i] = w; whr[w] = i;
        freelist[nfree++] = v;
    }
    static bool inb(int x, int y, int z) {
        return x > 0 && y > 0 && z > 0 && x < G - 1 && y < G - 1 && z < G - 1;
    }
    void snapshot() {
        best.clear();
        int v = act[0];
        do {
            int w = nxt[v], dx = px[w] - px[v], dy = py[w] - py[v], dz = pz[w] - pz[v];
            for (int i = 0; i < 6; i++) if (DX[i] == dx && DY[i] == dy && DZ[i] == dz) best.push_back(DC[i]);
            v = w;
        } while (v != act[0]);
        if ((int)best.size() != nact) throw std::runtime_error("internal error: broken polygon");
    }
    void attempt(double z) {
        double z2 = z * z, den = 1.0 + 3.0 * z2;
        double p_plus = z2 / den, p_minus = 1.0 / den, p_zero = (1.0 + z2) / (2.0 * den);
        int a = act[rnd() % nact], b = nxt[a];
        int ex = px[b] - px[a], ey = py[b] - py[a];
        int axis = ex ? 0 : (ey ? 1 : 2);
        int k = rnd() & 3, d = 0;
        for (int i = 0, c = 0; i < 6; i++) { if (i / 2 == axis) continue; if (c++ == k) { d = i; break; } }
        int ax = px[a] + DX[d], ay = py[a] + DY[d], az = pz[a] + DZ[d];
        int bx = px[b] + DX[d], by = py[b] + DY[d], bz = pz[b] + DZ[d];
        if (!inb(ax, ay, az) || !inb(bx, by, bz)) return;
        int pa = prv[a], nb = nxt[b];
        bool A = (px[pa] == ax && py[pa] == ay && pz[pa] == az);
        bool B = (px[nb] == bx && py[nb] == by && pz[nb] == bz);
        double u = runif();
        if (A && B) {                       /* -2 */
            if (nact <= 4 || u >= p_minus) return;
            delv(a); delv(b); nxt[pa] = nb; prv[nb] = pa;
        } else if (A) {                     /* 0 */
            if (g(bx, by, bz) || u >= p_zero) return;
            g(px[a], py[a], pz[a]) = 0; px[a] = bx; py[a] = by; pz[a] = bz; g(bx, by, bz) = 1;
        } else if (B) {                     /* 0 */
            if (g(ax, ay, az) || u >= p_zero) return;
            g(px[b], py[b], pz[b]) = 0; px[b] = ax; py[b] = ay; pz[b] = az; g(ax, ay, az) = 1;
        } else {                            /* +2 */
            if (g(ax, ay, az) || g(bx, by, bz) || u >= p_plus || nfree < 2) return;
            int v = newv(ax, ay, az), w = newv(bx, by, bz);
            nxt[a] = v; prv[v] = a; nxt[v] = w; prv[w] = v; nxt[w] = b; prv[b] = w;
        }
    }
    /* one annealing run; returns the shortest word seen */
    std::string run(const std::string &w, uint64_t seed, const Params &p) {
        while (nact) delv(act[0]);
        nfree = 0;
        for (int i = MAXV - 1; i >= 0; i--) freelist[nfree++] = i;
        int n = (int)w.size();
        if (n + 64 > MAXV) throw std::runtime_error("word too long");
        int x = 0, y = 0, z = 0, mn[3] = {0, 0, 0}, mx[3] = {0, 0, 0};
        for (int i = 0; i < n; i++) {
            int d = dircode(w[i]); x += DX[d]; y += DY[d]; z += DZ[d];
            if (x < mn[0]) mn[0] = x;
            if (x > mx[0]) mx[0] = x;
            if (y < mn[1]) mn[1] = y;
            if (y > mx[1]) mx[1] = y;
            if (z < mn[2]) mn[2] = z;
            if (z > mx[2]) mx[2] = z;
        }
        if (x || y || z) throw std::runtime_error("word does not close");
        x = G / 2 - (mn[0] + mx[0]) / 2; y = G / 2 - (mn[1] + mx[1]) / 2; z = G / 2 - (mn[2] + mx[2]) / 2;
        int first = -1, last = -1;
        for (int i = 0; i < n; i++) {
            if (!inb(x, y, z)) throw std::runtime_error("polygon does not fit in box");
            if (g(x, y, z)) throw std::runtime_error("word is not self-avoiding");
            int v = newv(x, y, z);
            if (first < 0) first = v; else { nxt[last] = v; prv[v] = last; }
            last = v;
            int d = dircode(w[i]); x += DX[d]; y += DY[d]; z += DZ[d];
        }
        nxt[last] = first; prv[first] = last;
        seed_rng(seed);
        snapshot();
        for (long c = 0; c < p.cycles; c++) {
            double zh = runif() * p.zmax;
            for (long i = 0; i < p.nhigh; i++) attempt(zh);
            for (long i = 0; i < p.nlow; i++) { attempt(p.zlow); if (nact < (int)best.size()) snapshot(); }
        }
        return best;
    }
};

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
