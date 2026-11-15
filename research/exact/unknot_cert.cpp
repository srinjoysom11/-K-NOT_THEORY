// unknot_cert.cpp -- certify that lattice polygons are unknotted by shrinking them.
//
// Reads words (e w n s u d, one closed self-avoiding polygon per line) from stdin.
// Moves used, both isotopies (PROOF.md sections 1 and 2):
//   * U-turn removal: consecutive steps a, c, -a are replaced by c (2 edges fewer);
//   * corner flip: a vertex v with non-collinear neighbours p, q is moved to p + q - v
//     when that point is free.
// Strategy: remove U-turns while there are any; otherwise breadth-first search over corner
// flips (at most LIMIT states, default 200000) for a polygon that has a U-turn. A polygon that
// reaches 4 edges is the unit square: unknotted. Words that do not reach 4 edges are printed
// to stdout with the length reached; a summary goes to stderr.
// Build: g++ -O3 -std=c++17 -o unknot_cert unknot_cert.cpp    Run: ./unknot_cert [LIMIT] < words
#include <cstdio>
#include <cstdlib>
#include <deque>
#include <iostream>
#include <map>
#include <string>
#include <unordered_set>
#include <vector>
using namespace std;

struct P { int x, y, z; };
static inline bool eq(const P& a, const P& b) { return a.x == b.x && a.y == b.y && a.z == b.z; }
static inline long long key(const P& a) { return ((long long)(a.x + 512) << 40) | ((long long)(a.y + 512) << 20) | (a.z + 512); }
typedef vector<P> Poly;

static bool parse(const string& w, Poly& v) {
    v.clear();
    P p = {0, 0, 0};
    unordered_set<long long> seen;
    for (char c : w) {
        if (!seen.insert(key(p)).second) return false;
        v.push_back(p);
        switch (c) {
            case 'e': p.x++; break; case 'w': p.x--; break;
            case 'n': p.y++; break; case 's': p.y--; break;
            case 'u': p.z++; break; case 'd': p.z--; break;
            default: return false;
        }
    }
    return p.x == 0 && p.y == 0 && p.z == 0 && v.size() >= 4;
}

// remove one U-turn if present; returns true if removed
static bool remove_uturn(Poly& v) {
    int n = v.size();
    if (n <= 4) return false;
    for (int i = 0; i < n; i++) {
        const P &a = v[i], &b = v[(i + 1) % n], &c = v[(i + 2) % n], &d = v[(i + 3) % n];
        // steps a->b and c->d opposite  <=>  b - a = c - d  <=>  a, d adjacent with d - a = c - b
        if (b.x - a.x == c.x - d.x && b.y - a.y == c.y - d.y && b.z - a.z == c.z - d.z) {
            int i1 = (i + 1) % n, i2 = (i + 2) % n;
            Poly w;
            for (int j = 0; j < n; j++) if (j != i1 && j != i2) w.push_back(v[j]);
            v.swap(w);
            return true;
        }
    }
    return false;
}

static bool has_uturn(const Poly& v) {
    int n = v.size();
    if (n <= 4) return false;
    for (int i = 0; i < n; i++) {
        const P &a = v[i], &b = v[(i + 1) % n], &c = v[(i + 2) % n], &d = v[(i + 3) % n];
        if (b.x - a.x == c.x - d.x && b.y - a.y == c.y - d.y && b.z - a.z == c.z - d.z) return true;
    }
    return false;
}

static string ser(const Poly& v) {
    string s;
    s.reserve(v.size() * 3);
    for (const P& p : v) { s += (char)(p.x + 64); s += (char)(p.y + 64); s += (char)(p.z + 64); }
    return s;
}

// BFS over corner flips; on success v becomes a polygon with a U-turn
static bool flip_search(Poly& v, size_t limit) {
    unordered_set<string> seen;
    deque<Poly> q;
    seen.insert(ser(v));
    q.push_back(v);
    while (!q.empty() && seen.size() < limit) {
        Poly cur = q.front();
        q.pop_front();
        int n = cur.size();
        unordered_set<long long> occ;
        for (const P& p : cur) occ.insert(key(p));
        for (int i = 0; i < n; i++) {
            const P &p = cur[(i - 1 + n) % n], &c = cur[i], &r = cur[(i + 1) % n];
            P f = {p.x + r.x - c.x, p.y + r.y - c.y, p.z + r.z - c.z};
            if (eq(f, c)) continue;                       // cannot happen for unit steps
            int dx = abs(p.x - r.x) + abs(p.y - r.y) + abs(p.z - r.z);
            if (dx != 2 || (p.x != r.x) + (p.y != r.y) + (p.z != r.z) != 2) continue; // collinear
            if (occ.count(key(f))) continue;
            Poly nx = cur;
            nx[i] = f;
            if (!seen.insert(ser(nx)).second) continue;
            if (has_uturn(nx)) { v.swap(nx); return true; }
            q.push_back(nx);
        }
    }
    return false;
}

int main(int argc, char** argv) {
    size_t limit = argc > 1 ? atol(argv[1]) : 200000;
    string w;
    long long total = 0, bad = 0, certified = 0, unresolved = 0, searches = 0;
    map<int, long long> reached;
    while (getline(cin, w)) {
        if (w.empty() || w[0] == '#') continue;
        size_t sp = w.find_last_of(" \t");
        if (sp != string::npos) w = w.substr(sp + 1);
        Poly v;
        total++;
        if (!parse(w, v)) { bad++; printf("BAD %s\n", w.c_str()); continue; }
        while (v.size() > 4) {
            if (remove_uturn(v)) continue;
            searches++;
            if (!flip_search(v, limit)) break;
        }
        reached[v.size()]++;
        if (v.size() == 4) certified++;
        else { unresolved++; printf("%d %s\n", (int)v.size(), w.c_str()); }
    }
    fprintf(stderr, "words=%lld bad=%lld certified_unknot=%lld unresolved=%lld flip_searches=%lld limit=%zu\n",
            total, bad, certified, unresolved, searches, limit);
    for (auto& kv : reached) fprintf(stderr, "final_length %d: %lld\n", kv.first, kv.second);
    return 0;
}
