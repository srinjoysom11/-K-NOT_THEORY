/*
 *  snapcanon_rand.h
 *
 *  SNAPCANON: force-included (-include) into every SnapPea kernel translation unit.
 *  The kernel calls the C library rand() in randomize_triangulation_with_options()
 *  (simplify_triangulation.c) and in cusp_neighborhoods.c.  libc rand() is global
 *  state, so it is replaced by a thread-local generator that is seeded per call.
 *  This makes results reproducible for a given seed and safe across threads.
 */
#ifndef SNAPCANON_RAND_H
#define SNAPCANON_RAND_H

/* Include <stdlib.h> first so that the libc prototype is already declared. */
#include <stdlib.h>

int  snapcanon_rand(void);
void snapcanon_srand(unsigned int seed);

#define rand() snapcanon_rand()

#endif
