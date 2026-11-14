/*
 *  kernel_bridge.h
 *
 *  Internal C interface between the C++ layer (snapcanon.cpp) and the SnapPea
 *  kernel copy in snappea/.  Not part of the public API (see snapcanon.h).
 */
#ifndef SNAPCANON_KERNEL_BRIDGE_H
#define SNAPCANON_KERNEL_BRIDGE_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Gluing data of a canonical retriangulation, in plain arrays.
 *   nbr[4*t + f]          index of the tetrahedron glued across face f of tetrahedron t
 *   perm[16*t + 4*f + v]  image of vertex v of t under the gluing across face f
 *                         (the image of f itself is the glued face of the neighbour)
 */
typedef struct SCTriangulation {
    int  ntet;
    int *nbr;
    int *perm;
} SCTriangulation;

/* Status codes (shared with snapcanon.h). */
#define SC_OK              0
#define SC_NOT_HYPERBOLIC  1
#define SC_CANON_FAILED    2
#define SC_ERR_INPUT     (-1)
#define SC_ERR_KERNEL    (-2)
#define SC_ERR_ALLOC     (-3)
#define SC_ERR_INTERNAL  (-4)

/* Runs the whole SnapPea pipeline for the PD code pd (4*ncross ints, KnotTheory
 * convention).  On SC_OK, *out holds the canonical retriangulation; the caller must
 * release it with sc_free_triangulation().  errmsg (optional) receives a short
 * description of any failure. */
int  sc_canonical_triangulation(const int *pd, int ncross, int max_retri, unsigned seed,
                                SCTriangulation *out, char *errmsg, size_t errlen);

void sc_free_triangulation(SCTriangulation *t);

#ifdef __cplusplus
}
#endif

#endif
