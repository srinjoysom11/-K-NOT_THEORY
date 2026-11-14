// R3-equivalence classes of diagrams (Burton Sec. 4.1, but with a global
// union so every class is explored once, not once per member).
//
// Diagrams related by R3 moves (and reflection / rotation / reversal, which
// Regina's knot signature ignores) represent the same knot, so SnapPy needs to
// identify only one diagram per class.  This is a proof, not a heuristic.
//
// usage: r3close input.txt out.txt maxstates
// input line: id n pd...    output line: id class_id class_size_found
#include <array>
#include <cstdio>
#include <cstdlib>
#include <deque>
#include <fstream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
#include "link/link.h"

int main(int argc, char** argv) {
    if (argc != 4) { std::fprintf(stderr, "usage: %s in out maxstates\n", argv[0]); return 2; }
    const size_t maxStates = std::strtoull(argv[3], nullptr, 10);
    std::ifstream in(argv[1]);
    FILE* out = std::fopen(argv[2], "w");
    std::unordered_map<std::string, long> seen;      // signature -> class id
    std::vector<long> csize;
    std::string line;
    long classes = 0, truncated = 0;
    while (std::getline(in, line)) {
        std::istringstream ss(line);
        long id; int n; ss >> id >> n;
        std::vector<std::array<int, 4>> pd(n);
        for (auto& c : pd) for (int& v : c) ss >> v;
        regina::Link L = regina::Link::fromPD(pd.begin(), pd.end());
        std::string s0 = L.knotSig(true, true, true);
        auto it = seen.find(s0);
        if (it != seen.end()) { std::fprintf(out, "%ld %ld\n", id, it->second); continue; }
        long cid = classes++;
        csize.push_back(1);
        seen.emplace(s0, cid);
        std::deque<regina::Link> queue;
        queue.push_back(std::move(L));
        bool hitCap = false;
        while (!queue.empty()) {
            regina::Link cur = std::move(queue.front()); queue.pop_front();
            for (size_t c = 0; c < cur.size(); ++c)
                for (int side = 0; side < 2; ++side) {
                    if (!cur.hasR3(cur.crossing(c), side)) continue;
                    regina::Link nxt(cur);
                    nxt.r3(nxt.crossing(c), side);
                    std::string s = nxt.knotSig(true, true, true);
                    if (seen.emplace(s, cid).second) {
                        ++csize[cid];
                        if (csize[cid] >= maxStates) { hitCap = true; }
                        else queue.push_back(std::move(nxt));
                    }
                }
            if (hitCap) break;
        }
        if (hitCap) ++truncated;
        std::fprintf(out, "%ld %ld\n", id, cid);
    }
    std::fprintf(stderr, "classes %ld, truncated %ld, signatures stored %zu\n", classes, truncated, seen.size());
    std::fclose(out);
    return 0;
}
