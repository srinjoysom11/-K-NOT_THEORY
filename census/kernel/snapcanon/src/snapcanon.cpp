/*
 *  snapcanon.cpp -- C++ layer of snapcanon: SnapPea kernel bridge + Regina isoSig.
 *
 *  The SnapPea part (kernel_bridge.c) returns the gluings of the canonical
 *  retriangulation as plain arrays.  Here they are turned into a regina::Triangulation<3>
 *  and its isomorphism signature is returned.  Regina's classic isomorphism signature is
 *  a combinatorial invariant (it is what SnapPy's undecorated isometry signature is
 *  computed from), so it is invariant under relabelling of tetrahedra and vertices.
 */
#include "snapcanon.h"
#include "kernel_bridge.h"

#include "triangulation/dim3.h"   // Regina: regina::Triangulation<3>, regina::Perm

#include <array>
#include <cstring>
#include <string>
#include <vector>

namespace {

// Builds the Regina triangulation of the canonical gluings and returns its isoSig().
std::string regina_isosig(const SCTriangulation &T)
{
    regina::Triangulation<3> tri;
    std::vector<regina::Simplex<3> *> s(static_cast<size_t>(T.ntet));
    for (int t = 0; t < T.ntet; ++t)
        s[t] = tri.newSimplex();

    for (int t = 0; t < T.ntet; ++t) {
        for (int f = 0; f < 4; ++f) {
            if (s[t]->adjacentSimplex(f) != nullptr)
                continue;   // already joined from the other side
            const int u = T.nbr[4 * t + f];
            const int *p = &T.perm[16 * t + 4 * f];
            // SnapPea: p[v] is the image of vertex v; p[f] is the glued face of the neighbour.
            // Regina: join(myFacet, you, gluing) with gluing[myFacet] = facet of you.
            s[t]->join(f, s[u], regina::Perm<4>(std::array<int, 4>{p[0], p[1], p[2], p[3]}));
        }
    }

    // Sanity: every facet is glued, symmetric, and with the gluing the kernel reported.
    for (int t = 0; t < T.ntet; ++t)
        for (int f = 0; f < 4; ++f) {
            regina::Simplex<3> *nb = s[t]->adjacentSimplex(f);
            const int u = T.nbr[4 * t + f];
            if (nb == nullptr || nb != s[u] || nb->adjacentSimplex(s[t]->adjacentGluing(f)[f]) != s[t])
                return std::string();
            for (int v = 0; v < 4; ++v)
                if (s[t]->adjacentGluing(f)[v] != T.perm[16 * t + 4 * f + v])
                    return std::string();
        }
    return tri.isoSig();
}

}  // namespace

extern "C" int snapcanon_signature(const int (*pd)[4], int ncrossings, int max_retriangulations,
                                   unsigned seed, char *out, size_t outlen)
{
    if (out == nullptr || outlen == 0)
        return SNAPCANON_ERR_INPUT;
    out[0] = '\0';
    if (ncrossings < 0 || max_retriangulations < 0 || (ncrossings > 0 && pd == nullptr))
        return SNAPCANON_ERR_INPUT;

    SCTriangulation T;
    std::memset(&T, 0, sizeof T);
    char err[160];
    const int *flat = (ncrossings > 0) ? reinterpret_cast<const int *>(pd) : nullptr;

    int rc = sc_canonical_triangulation(flat, ncrossings, max_retriangulations, seed,
                                        &T, err, sizeof err);
    if (rc != SC_OK)
        return rc;   // SC_* codes are identical to the SNAPCANON_* codes

    std::string sig;
    try {
        sig = regina_isosig(T);
    } catch (...) {
        sc_free_triangulation(&T);
        return SNAPCANON_ERR_INTERNAL;
    }
    sc_free_triangulation(&T);
    if (sig.empty())
        return SNAPCANON_ERR_INTERNAL;
    if (sig.size() + 1 > outlen)
        return SNAPCANON_ERR_BUFFER;
    std::memcpy(out, sig.c_str(), sig.size() + 1);
    return SNAPCANON_HYPERBOLIC;
}

extern "C" const char *snapcanon_strerror(int status)
{
    switch (status) {
        case SNAPCANON_HYPERBOLIC:      return "hyperbolic";
        case SNAPCANON_NOT_HYPERBOLIC:  return "not hyperbolic (no geometric solution found)";
        case SNAPCANON_CANON_FAILED:    return "canonical triangulation failed";
        case SNAPCANON_ERR_INPUT:       return "invalid input";
        case SNAPCANON_ERR_KERNEL:      return "SnapPea kernel error";
        case SNAPCANON_ERR_ALLOC:       return "out of memory";
        case SNAPCANON_ERR_INTERNAL:    return "internal error";
        case SNAPCANON_ERR_BUFFER:      return "output buffer too small";
        default:                        return "unknown status";
    }
}
