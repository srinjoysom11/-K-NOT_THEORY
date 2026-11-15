// arcknot.cpp -- Lemma 4 of PROOF.md: short arcs in a half-space are unknotted.
//
// Enumerates every self-avoiding lattice walk b with L edges (given on the command line) that
//   * stays in the half-space z >= 0 and has both end points A, B on the level z = 0, A != B,
//   * contains no U-turn (three consecutive steps a, c, -a),
//   * has L + d(A,B) >= MINSUM (default 22), d = Manhattan distance.
// For each walk it forms the closure C = b + (B -> B - e_z) + a monotone path in the level
// z = -1 + (A - e_z -> A) and counts the local maxima of C along each axis (a maximal run of
// consecutive vertices with the same coordinate whose two outside neighbours are lower).
// If some axis has exactly one local maximum, C is a 1-bridge curve, hence unknotted.
// Closures with at least two maxima on every axis are printed as words (one per line) for
// identification by other means.
//
// Up to the 8 symmetries of the half-space fixing the z-axis direction the first step is
// e or u; only those are enumerated (option -all enumerates the 5 possible first steps).
//
// Build: g++ -O3 -std=c++17 -o arcknot arcknot.cpp     Run: ./arcknot L [-minsum S] [-all] [-uturns]
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
using namespace std;

static const int DX[6] = {1, -1, 0, 0, 0, 0}, DY[6] = {0, 0, 1, -1, 0, 0}, DZ[6] = {0, 0, 0, 0, 1, -1};
static const char LET[7] = "ewnsud";
static const int OFF = 20, SZ = 41;
static unsigned char vis[SZ][SZ][SZ];
static int L, MINSUM = 22;
static bool ALLOW_UTURN = false;
static int px[64], py[64], pz[64], st[64];
static long long walks = 0, leaves = 0, onebridge = 0, printed = 0;
static long long hist[4][8]; // hist[axis][min(maxima,7)]

static int maxima(const vector<int>& c) { // cyclic sequence of one coordinate
    int n = c.size(), cnt = 0;
    // find a position where the coordinate changes, start there
    int s = -1;
    for (int i = 0; i < n; i++) if (c[i] != c[(i + 1) % n]) { s = (i + 1) % n; break; }
    if (s < 0) return 0; // constant coordinate: planar curve
    int i = s;
    do {
        int j = i; // run i..j of equal value
        while (c[(j + 1) % n] == c[i]) j = (j + 1) % n;
        int before = c[(i - 1 + n) % n], after = c[(j + 1) % n];
        if (before < c[i] && after < c[i]) cnt++;
        i = (j + 1) % n;
    } while (i != s);
    return cnt;
}

static void leaf() {
    int ax = px[0], ay = py[0], bx = px[L], by = py[L];
    int d = abs(bx - ax) + abs(by - ay);
    if (d == 0 || L + d < MINSUM) return;
    leaves++;
    vector<int> X, Y, Z;
    for (int i = 0; i <= L; i++) { X.push_back(px[i]); Y.push_back(py[i]); Z.push_back(pz[i]); }
    int x = bx, y = by;
    X.push_back(x); Y.push_back(y); Z.push_back(-1);
    while (x != ax) { x += (ax > x) ? 1 : -1; X.push_back(x); Y.push_back(y); Z.push_back(-1); }
    while (y != ay) { y += (ay > y) ? 1 : -1; X.push_back(x); Y.push_back(y); Z.push_back(-1); }
    int mx = maxima(X), my = maxima(Y), mz = maxima(Z);
    hist[0][mx > 7 ? 7 : mx]++; hist[1][my > 7 ? 7 : my]++; hist[2][mz > 7 ? 7 : mz]++;
    if (mx <= 1 || my <= 1 || mz <= 1) { onebridge++; return; }
    printed++;
    int n = X.size();
    string w;
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n, ddx = X[j] - X[i], ddy = Y[j] - Y[i], ddz = Z[j] - Z[i];
        for (int k = 0; k < 6; k++) if (DX[k] == ddx && DY[k] == ddy && DZ[k] == ddz) w += LET[k];
    }
    printf("%s\n", w.c_str());
}

static void dfs(int k) {
    int x = px[k], y = py[k], z = pz[k];
    if (k == L) { if (z == 0) { walks++; leaf(); } return; }
    int r = L - k;
    if (z > r) return;
    // the largest final planar distance still reachable must give L + d >= MINSUM
    if (abs(x - px[0]) + abs(y - py[0]) + (r - z) + L < MINSUM) return;
    for (int s = 0; s < 6; s++) {
        if (k >= 1 && s == (st[k - 1] ^ 1)) continue;                        // no reversal
        if (!ALLOW_UTURN && k >= 2 && s == (st[k - 2] ^ 1) && (st[k - 1] >> 1) != (s >> 1)) continue; // no U-turn
        int nx = x + DX[s], ny = y + DY[s], nz = z + DZ[s];
        if (nz < 0) continue;
        if (vis[nx + OFF][ny + OFF][nz]) continue;
        vis[nx + OFF][ny + OFF][nz] = 1;
        st[k] = s; px[k + 1] = nx; py[k + 1] = ny; pz[k + 1] = nz;
        dfs(k + 1);
        vis[nx + OFF][ny + OFF][nz] = 0;
    }
}

int main(int argc, char** argv) {
    if (argc < 2) { fprintf(stderr, "usage: arcknot L [-minsum S] [-all] [-uturns]\n"); return 1; }
    L = atoi(argv[1]);
    bool all = false;
    for (int i = 2; i < argc; i++) {
        if (!strcmp(argv[i], "-minsum")) MINSUM = atoi(argv[++i]);
        else if (!strcmp(argv[i], "-all")) all = true;
        else if (!strcmp(argv[i], "-uturns")) ALLOW_UTURN = true;
    }
    if (L < 1 || L > 19) { fprintf(stderr, "L out of range\n"); return 1; }
    px[0] = py[0] = pz[0] = 0;
    vis[OFF][OFF][0] = 1;
    for (int s = 0; s < 5; s++) {
        if (!all && s != 0 && s != 4) continue;
        int nx = DX[s], ny = DY[s], nz = DZ[s];
        vis[nx + OFF][ny + OFF][nz] = 1;
        st[0] = s; px[1] = nx; py[1] = ny; pz[1] = nz;
        dfs(1);
        vis[nx + OFF][ny + OFF][nz] = 0;
    }
    fprintf(stderr, "L=%d minsum=%d all=%d uturns=%d walks_ending_on_level0=%lld tested=%lld one_bridge=%lld printed=%lld\n",
            L, MINSUM, (int)all, (int)ALLOW_UTURN, walks, leaves, onebridge, printed);
    for (int a = 0; a < 3; a++) {
        fprintf(stderr, "maxima along %c:", "xyz"[a]);
        for (int m = 0; m < 8; m++) fprintf(stderr, " %d:%lld", m, hist[a][m]);
        fprintf(stderr, "\n");
    }
    return 0;
}
