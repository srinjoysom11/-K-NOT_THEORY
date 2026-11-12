/*
 * bfacf_core.hpp -- the BFACF engine shared by bfacf_batch.cpp and bench.cpp.
 * One Annealer object owns one polygon on a G^3 grid. attempt(z) tries one BFACF
 * move with the standard probabilities at fugacity z; every accepted move slides the
 * polygon across one empty unit square, so the knot type never changes.
 */
#pragma once
#include <cmath>
#include <cstdint>
#include <stdexcept>
#include <string>
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
    double gamma = 0.0;         /* contact bias: neutral moves get an extra factor min(1, exp(gamma * change in contacts)) */
    int cap = 1 << 30;          /* +2 moves that would exceed this length are rejected */

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
    int occ6(int x, int y, int z) {
        return g(x + 1, y, z) + g(x - 1, y, z) + g(x, y + 1, z) + g(x, y - 1, z) + g(x, y, z + 1) + g(x, y, z - 1);
    }
    /* contact filter for a neutral move of the vertex at (ox,oy,oz) to (nx,ny,nz); only used when gamma != 0 */
    bool contact_ok(int ox, int oy, int oz, int nx, int ny, int nz) {
        int d = occ6(nx, ny, nz) - occ6(ox, oy, oz);   /* both counts include the same two bonded neighbours */
        if (d >= 0) return true;
        return runif() < std::exp(gamma * d);
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
            if (gamma != 0.0 && !contact_ok(px[a], py[a], pz[a], bx, by, bz)) return;
            g(px[a], py[a], pz[a]) = 0; px[a] = bx; py[a] = by; pz[a] = bz; g(bx, by, bz) = 1;
        } else if (B) {                     /* 0 */
            if (g(ax, ay, az) || u >= p_zero) return;
            if (gamma != 0.0 && !contact_ok(px[b], py[b], pz[b], ax, ay, az)) return;
            g(px[b], py[b], pz[b]) = 0; px[b] = ax; py[b] = ay; pz[b] = az; g(ax, ay, az) = 1;
        } else {                            /* +2 */
            if (g(ax, ay, az) || g(bx, by, bz) || u >= p_plus || nfree < 2 || nact + 2 > cap) return;
            int v = newv(ax, ay, az), w = newv(bx, by, bz);
            nxt[a] = v; prv[v] = a; nxt[v] = w; prv[w] = v; nxt[w] = b; prv[b] = w;
        }
    }
    /* place the polygon given by a closed word, centred in the box */
    void load(const std::string &w) {
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
        snapshot();
    }
    /* one annealing run (Scharein et al. 2009 protocol); returns the shortest word seen */
    std::string run(const std::string &w, uint64_t seed, const Params &p) {
        load(w);
        seed_rng(seed);
        for (long c = 0; c < p.cycles; c++) {
            double zh = runif() * p.zmax;
            for (long i = 0; i < p.nhigh; i++) attempt(zh);
            for (long i = 0; i < p.nlow; i++) { attempt(p.zlow); if (nact < (int)best.size()) snapshot(); }
        }
        return best;
    }
};

