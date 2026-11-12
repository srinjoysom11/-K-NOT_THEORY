/*
 * bfacf.c -- BFACF simulated annealing on a simple-cubic lattice polygon.
 *
 * Every move is one of the three BFACF moves (neutral corner flip, +2, -2), each
 * of which is an isotopy across one unit square whose interior and free corners
 * are checked to be unoccupied. Hence the knot type never changes (JvRW91 Thm 3.11).
 *
 * usage: bfacf WORD SEED CYCLES N_HIGH N_LOW ZMAX ZLOW
 *   WORD   closed word over n,s,e,w,u,d (start vertex irrelevant)
 *   each cycle: N_HIGH attempted moves at z ~ U(0,ZMAX), then N_LOW at z = ZLOW
 *   (protocol of Scharein et al. 2009, section 4).
 * output (stdout): one line "BEST <length> <word>"
 * Deterministic given (WORD, SEED, parameters): the run itself is the certificate.
 *
 * build: gcc -O2 -o bfacf bfacf.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define G 160
#define MAXV 8192

static unsigned char grid[G][G][G];
static int px[MAXV], py[MAXV], pz[MAXV], nxt[MAXV], prv[MAXV];
static int act[MAXV], whr[MAXV], nact = 0;
static int freelist[MAXV], nfree = 0;
static const int DX[6] = {1, -1, 0, 0, 0, 0};
static const int DY[6] = {0, 0, 1, -1, 0, 0};
static const int DZ[6] = {0, 0, 0, 0, 1, -1};
static const char DC[6] = {'e', 'w', 'n', 's', 'u', 'd'};

static uint64_t s[4];
static inline uint64_t rotl(uint64_t x, int k) { return (x << k) | (x >> (64 - k)); }
static inline uint64_t rnd(void) {
    uint64_t r = rotl(s[1] * 5, 7) * 9, t = s[1] << 17;
    s[2] ^= s[0]; s[3] ^= s[1]; s[1] ^= s[2]; s[0] ^= s[3]; s[2] ^= t; s[3] = rotl(s[3], 45);
    return r;
}
static inline double runif(void) { return (rnd() >> 11) * (1.0 / 9007199254740992.0); }
static void seed_rng(uint64_t x) {
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
    fprintf(stderr, "bad letter %c\n", c); exit(2);
}
static int newv(int x, int y, int z) {
    if (nfree == 0) { fprintf(stderr, "out of vertices\n"); exit(3); }
    int v = freelist[--nfree];
    px[v] = x; py[v] = y; pz[v] = z; grid[x][y][z] = 1;
    whr[v] = nact; act[nact++] = v;
    return v;
}
static void delv(int v) {
    grid[px[v]][py[v]][pz[v]] = 0;
    int i = whr[v], w = act[--nact];
    act[i] = w; whr[w] = i;
    freelist[nfree++] = v;
}
static inline int inb(int x, int y, int z) {
    return x > 0 && y > 0 && z > 0 && x < G - 1 && y < G - 1 && z < G - 1;
}

static char bestw[MAXV];
static int bestn;
static void snapshot(void) {
    int v = act[0], k = 0;
    do {
        int w = nxt[v], dx = px[w] - px[v], dy = py[w] - py[v], dz = pz[w] - pz[v];
        for (int i = 0; i < 6; i++) if (DX[i] == dx && DY[i] == dy && DZ[i] == dz) bestw[k++] = DC[i];
        v = w;
    } while (v != act[0]);
    bestw[k] = 0; bestn = k;
    if (k != nact) { fprintf(stderr, "internal error: broken polygon\n"); exit(4); }
}

static void attempt(double z) {
    double z2 = z * z, den = 1.0 + 3.0 * z2;
    double p_plus = z2 / den, p_minus = 1.0 / den, p_zero = (1.0 + z2) / (2.0 * den);
    int a = act[rnd() % nact], b = nxt[a];
    int ex = px[b] - px[a], ey = py[b] - py[a], ez = pz[b] - pz[a];
    int axis = ex ? 0 : (ey ? 1 : 2);
    int k = rnd() & 3, d = 0;
    for (int i = 0, c = 0; i < 6; i++) { if (i / 2 == axis) continue; if (c++ == k) { d = i; break; } }
    int ax = px[a] + DX[d], ay = py[a] + DY[d], az = pz[a] + DZ[d];
    int bx = px[b] + DX[d], by = py[b] + DY[d], bz = pz[b] + DZ[d];
    if (!inb(ax, ay, az) || !inb(bx, by, bz)) return;
    int pa = prv[a], nb = nxt[b];
    int A = (px[pa] == ax && py[pa] == ay && pz[pa] == az);
    int B = (px[nb] == bx && py[nb] == by && pz[nb] == bz);
    double u = runif();
    if (A && B) {                       /* -2 : pa-a-b-nb is a U, replace by edge pa-nb */
        if (nact <= 4 || u >= p_minus) return;
        delv(a); delv(b); nxt[pa] = nb; prv[nb] = pa;
    } else if (A) {                     /* 0 : corner a flips to b' */
        if (grid[bx][by][bz] || u >= p_zero) return;
        grid[px[a]][py[a]][pz[a]] = 0; px[a] = bx; py[a] = by; pz[a] = bz; grid[bx][by][bz] = 1;
    } else if (B) {                     /* 0 : corner b flips to a' */
        if (grid[ax][ay][az] || u >= p_zero) return;
        grid[px[b]][py[b]][pz[b]] = 0; px[b] = ax; py[b] = ay; pz[b] = az; grid[ax][ay][az] = 1;
    } else {                            /* +2 : edge a-b replaced by a-a'-b'-b */
        if (grid[ax][ay][az] || grid[bx][by][bz] || u >= p_plus || nfree < 2) return;
        int v = newv(ax, ay, az), w = newv(bx, by, bz);
        nxt[a] = v; prv[v] = a; nxt[v] = w; prv[w] = v; nxt[w] = b; prv[b] = w;
    }
}

int main(int argc, char **argv) {
    if (argc < 8) { fprintf(stderr, "usage: bfacf WORD SEED CYCLES N_HIGH N_LOW ZMAX ZLOW\n"); return 1; }
    const char *w = argv[1];
    uint64_t seed = strtoull(argv[2], 0, 10);
    long cycles = atol(argv[3]), nhigh = atol(argv[4]), nlow = atol(argv[5]);
    double zmax = atof(argv[6]), zlow = atof(argv[7]);
    int n = (int)strlen(w);
    if (n + 64 > MAXV) { fprintf(stderr, "word too long\n"); return 1; }
    for (int i = MAXV - 1; i >= 0; i--) freelist[nfree++] = i;
    /* centre the polygon in the box */
    int x = 0, y = 0, z = 0, mn[3] = {0, 0, 0}, mx[3] = {0, 0, 0};
    for (int i = 0; i < n; i++) {
        int d = dircode(w[i]); x += DX[d]; y += DY[d]; z += DZ[d];
        if (x < mn[0]) mn[0] = x; if (x > mx[0]) mx[0] = x;
        if (y < mn[1]) mn[1] = y; if (y > mx[1]) mx[1] = y;
        if (z < mn[2]) mn[2] = z; if (z > mx[2]) mx[2] = z;
    }
    if (x || y || z) { fprintf(stderr, "word does not close\n"); return 1; }
    x = G / 2 - (mn[0] + mx[0]) / 2; y = G / 2 - (mn[1] + mx[1]) / 2; z = G / 2 - (mn[2] + mx[2]) / 2;
    int first = -1, last = -1;
    for (int i = 0; i < n; i++) {
        if (!inb(x, y, z)) { fprintf(stderr, "polygon does not fit in box\n"); return 1; }
        if (grid[x][y][z]) { fprintf(stderr, "word is not self-avoiding\n"); return 1; }
        int v = newv(x, y, z);
        if (first < 0) first = v; else { nxt[last] = v; prv[v] = last; }
        last = v;
        int d = dircode(w[i]); x += DX[d]; y += DY[d]; z += DZ[d];
    }
    nxt[last] = first; prv[first] = last;
    seed_rng(seed);
    snapshot();
    for (long c = 0; c < cycles; c++) {
        double zh = runif() * zmax;
        for (long i = 0; i < nhigh; i++) attempt(zh);
        for (long i = 0; i < nlow; i++) { attempt(zlow); if (nact < bestn) snapshot(); }
    }
    printf("BEST %d %s\n", bestn, bestw);
    return 0;
}
