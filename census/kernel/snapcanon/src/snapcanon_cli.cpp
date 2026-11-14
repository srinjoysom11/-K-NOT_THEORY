/*
 *  snapcanon_cli -- batch driver for snapcanon_signature().
 *
 *  usage: snapcanon_cli [--retriangulations N] [--seed S] [--shard I K] FILE
 *
 *  FILE holds one diagram per line:   id n a1 a2 ... a4n
 *  (a KnotTheory / Spherogram PD code with n crossings).  Blank lines are skipped.
 *  Output, one line per processed diagram:   id status signature
 *    status     the SNAPCANON_* return code (0 hyperbolic, 1 not hyperbolic, ...)
 *    signature  the canonical string when status is 0, otherwise "-"
 *  --shard I K  process only the diagrams whose index among the data lines is I mod K
 *               (0 <= I < K), so K processes can split a file.
 *  --retriangulations N  randomize() attempts per diagram (default 25, as in SnapPy).
 */
#include "snapcanon.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

namespace {

void usage(const char *prog)
{
    std::fprintf(stderr,
                 "usage: %s [--retriangulations N] [--seed S] [--shard I K] FILE\n", prog);
    std::exit(2);
}

}  // namespace

int main(int argc, char **argv)
{
    int max_retri = 25;
    unsigned seed = 1u;
    long shard_i = 0, shard_k = 1;
    const char *path = nullptr;

    for (int a = 1; a < argc; ++a) {
        const std::string arg = argv[a];
        if (arg == "--retriangulations" && a + 1 < argc) {
            max_retri = std::atoi(argv[++a]);
        } else if (arg == "--seed" && a + 1 < argc) {
            seed = static_cast<unsigned>(std::strtoul(argv[++a], nullptr, 10));
        } else if (arg == "--shard" && a + 2 < argc) {
            shard_i = std::atol(argv[++a]);
            shard_k = std::atol(argv[++a]);
            if (shard_k < 1 || shard_i < 0 || shard_i >= shard_k)
                usage(argv[0]);
        } else if (arg.size() > 1 && arg[0] == '-') {
            usage(argv[0]);
        } else {
            path = argv[a];
        }
    }
    if (path == nullptr || max_retri < 0)
        usage(argv[0]);

    std::ifstream in(path);
    if (!in) {
        std::fprintf(stderr, "snapcanon_cli: cannot open %s\n", path);
        return 1;
    }

    std::string line;
    long index = 0;
    std::vector<int> pd;
    while (std::getline(in, line)) {
        std::istringstream ss(line);
        std::string id;
        if (!(ss >> id))
            continue;                       // blank line
        const long this_index = index++;
        if (this_index % shard_k != shard_i)
            continue;

        int n = -1;
        ss >> n;
        bool ok = (n >= 0) && !ss.fail();
        pd.assign(static_cast<size_t>(ok ? 4 * n : 0), 0);
        for (int k = 0; ok && k < 4 * n; ++k) {
            if (!(ss >> pd[static_cast<size_t>(k)]))
                ok = false;
        }

        int status;
        char sig[4096];
        sig[0] = '\0';
        if (!ok) {
            status = SNAPCANON_ERR_INPUT;
        } else {
            status = snapcanon_signature(
                reinterpret_cast<const int (*)[4]>(pd.data()), n, max_retri, seed,
                sig, sizeof sig);
        }
        if (status == SNAPCANON_HYPERBOLIC)
            std::printf("%s %d %s\n", id.c_str(), status, sig);
        else
            std::printf("%s %d -\n", id.c_str(), status);
    }
    return 0;
}
