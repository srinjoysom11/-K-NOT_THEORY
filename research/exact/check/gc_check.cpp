/*
 * gc_check.cpp -- test the generalized curtain lemma (DMON_IDEAS.md, D1) on lists of polygons.
 *
 * Lemma (GC).  Let v_0, v_1 = v_0 + a, v_2, ..., v_m, v_{m+1} = v_m - a (m >= 2) be cyclically
 * consecutive vertices of a lattice polygon P, a a unit vector, the steps v_1 -> ... -> v_m
 * arbitrary.  Q = {v_1..v_m}, R = the other vertices.  If none of v_j - a (2 <= j <= m-1) is in R,
 * then P is not a shortest polygon of its knot type.
 *
 * This program is written from that statement only (no code shared with enum.cpp).  It reads
 * words over e w n s u d (one per line, last field = word), checks that each is a closed
 * self-avoiding polygon, and counts the words in which some (i0, m) violates the condition,
 * i.e. the words GC would delete.  Every cyclic window is tried (also those through the start).
 *
 * usage: gc_check FILE [-v] [-keep OUTFILE]    -keep writes the words that pass GC
 * build: g++ -O2 -std=c++17 -o gc_check gc_check.cpp
 */
#include <array>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>
using namespace std;
typedef array<int, 3> P3;

static P3 step_of(char c) {
    switch (c) {
        case 'e': return {1, 0, 0};  case 'w': return {-1, 0, 0};
        case 'n': return {0, 1, 0};  case 's': return {0, -1, 0};
        case 'u': return {0, 0, 1};  default: return {0, 0, -1};
    }
}

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: gc_check FILE [-v] [-keep OUT]\n"); return 1; }
    bool verbose = false; const char *keep = nullptr;
    for (int i = 2; i < argc; i++) {
        string a = argv[i];
        if (a == "-v") verbose = true;
        else if (a == "-keep") keep = argv[++i];
    }
    ifstream f(argv[1]);
    FILE *fk = keep ? fopen(keep, "w") : nullptr;
    string line; long total = 0, bad_input = 0, viol = 0, shown = 0;
    while (getline(f, line)) {
        if (line.empty() || line[0] == '#') continue;
        istringstream ss(line); string w, t; while (ss >> t) w = t;
        bool okw = !w.empty(); for (char c : w) if (!strchr("ewnsud", c)) okw = false;
        if (!okw) continue;
        int n = (int)w.size();
        vector<P3> v(n + 1); v[0] = {0, 0, 0};
        map<P3, int> idx; bool saw = true;
        for (int i = 0; i < n; i++) {
            P3 s = step_of(w[i]);
            v[i + 1] = {v[i][0] + s[0], v[i][1] + s[1], v[i][2] + s[2]};
            if (i + 1 < n) { if (idx.count(v[i + 1])) saw = false; idx[v[i + 1]] = i + 1; }
        }
        idx[v[0]] = 0;
        if (!(v[n] == v[0]) || !saw) { bad_input++; continue; }
        total++;
        bool violated = false; int vi0 = -1, vm = -1;
        for (int i0 = 0; i0 < n && !violated; i0++) {
            P3 a = step_of(w[i0]);
            for (int m = 2; m <= n - 2 && !violated; m++) {
                P3 b = step_of(w[(i0 + m) % n]);
                if (!(b[0] == -a[0] && b[1] == -a[1] && b[2] == -a[2])) continue;
                bool found = false;                       /* some v_j - a is a vertex of R */
                for (int j = 2; j <= m - 1 && !found; j++) {
                    P3 q = v[(i0 + j) % n];
                    P3 s = {q[0] - a[0], q[1] - a[1], q[2] - a[2]};
                    auto it = idx.find(s);
                    if (it == idx.end()) continue;
                    int k = ((it->second - i0) % n + n) % n;   /* position relative to v_0 */
                    bool inQ = (k >= 1 && k <= m);
                    if (!inQ) found = true;
                }
                if (!found) { violated = true; vi0 = i0; vm = m; }
            }
        }
        if (violated) {
            viol++;
            if (verbose && shown++ < 5) printf("violation: %s  i0=%d m=%d\n", w.c_str(), vi0, vm);
        } else if (fk) fprintf(fk, "%s\n", w.c_str());
    }
    if (fk) fclose(fk);
    printf("%s: polygons=%ld invalid_input=%ld GC_violations=%ld passing=%ld\n", argv[1], total, bad_input, viol, total - viol);
    return 0;
}
