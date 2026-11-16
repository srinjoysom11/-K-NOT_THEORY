/*
 *  snapcanon.h -- canonical identity string of a knot complement from a PD code.
 *
 *  For a knot (or link) diagram given as a PD code, snapcanon_signature() builds the
 *  hyperbolic structure of the complement with the SnapPea kernel, retriangulates
 *  randomly until the structure is geometric, takes the canonical retriangulation
 *  (Epstein-Penner / SnapPea canonize) and returns the Regina isomorphism signature
 *  of that triangulation.  The signature does not depend on the diagram, the
 *  orientation or the mirror image: two diagrams of the same knot up to mirror
 *  image receive the same string.
 *
 *  Each call is self-contained.  Concurrent calls from different threads are
 *  supported: the kernel's rand() replacement and its malloc bookkeeping are
 *  thread-local, and no other mutable global state is used.  Calls are not
 *  re-entrant from within a callback (there are no callbacks).
 *
 *  Link with libsnapcanon.a and Regina's libregina-engine (see README.md).
 */
#ifndef SNAPCANON_H
#define SNAPCANON_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Return codes of snapcanon_signature(). */
#define SNAPCANON_HYPERBOLIC       0   /* hyperbolic: signature written to out            */
#define SNAPCANON_NOT_HYPERBOLIC   1   /* no geometric solution after max_retriangulations */
#define SNAPCANON_CANON_FAILED     2   /* the canonical retriangulation could not be computed */
#define SNAPCANON_ERR_INPUT       (-1) /* bad arguments or PD code that is not a diagram  */
#define SNAPCANON_ERR_KERNEL      (-2) /* the SnapPea kernel hit a fatal error            */
#define SNAPCANON_ERR_ALLOC       (-3) /* out of memory                                   */
#define SNAPCANON_ERR_INTERNAL    (-4) /* internal inconsistency (bug)                    */
#define SNAPCANON_ERR_BUFFER      (-5) /* out buffer too small for the signature          */

/*
 *  pd                    ncrossings PD tuples (KnotTheory / Spherogram convention),
 *                        pd[c] = {a, b, c, d}; each edge label occurs exactly twice.
 *  ncrossings            number of crossings; 0 (unknot) gives SNAPCANON_NOT_HYPERBOLIC.
 *  max_retriangulations  how many randomize() steps to try before giving up
 *                        (SnapPy's identity uses 25).
 *  seed                  seed of the retriangulation randomness; the result is
 *                        independent of it for hyperbolic diagrams.
 *  out, outlen           receives the NUL-terminated signature on SNAPCANON_HYPERBOLIC.
 *                        On other return codes out is set to "" when out is non-NULL.
 *
 *  Returns one of the SNAPCANON_* codes above.
 */
int snapcanon_signature(const int (*pd)[4], int ncrossings, int max_retriangulations,
                        unsigned seed, char *out, size_t outlen);

/* Short English description of a return code (never NULL). */
const char *snapcanon_strerror(int status);

#ifdef __cplusplus
}
#endif

#endif /* SNAPCANON_H */
