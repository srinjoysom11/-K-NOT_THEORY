/*
 *  snapcanon_shims.c
 *
 *  SNAPCANON: headless replacements for the SnapPea user-interface hooks.  The
 *  stock implementations live in unix_kit/unix_UI.c (uFatalError calls exit()).
 *  Here a fatal kernel error longjmps back to the bridge (kernel_bridge.c), which
 *  turns it into a negative return code instead of terminating the process.
 *  Memory allocated by the kernel before the error is leaked; see README.md.
 *
 *  Also provides the thread-local generator behind the rand() macro in
 *  snapcanon_rand.h.
 */
#include <stdio.h>
#include <setjmp.h>
#include "SnapPea.h"
#include "kernel.h"          /* struct Triangulation */
#include "snapcanon_rand.h"

/* Set by kernel_bridge.c around every kernel call. */
extern __thread jmp_buf *snapcanon_fatal_jmp;
__thread jmp_buf *snapcanon_fatal_jmp = NULL;

/* Human-readable reason for the most recent fatal kernel error (per thread). */
extern __thread char snapcanon_last_error[256];
__thread char snapcanon_last_error[256] = "";

static void snapcanon_fail(const char *what)
{
    if (snapcanon_fatal_jmp != NULL)
        longjmp(*snapcanon_fatal_jmp, 1);
    /* Kernel called outside the bridge: there is nowhere to return to. */
    fprintf(stderr, "snapcanon: %s outside of a bridge call\n", what);
    abort();
}

void uAcknowledge(const char *message)
{
    (void)message;   /* messages are not shown in a headless library */
}

void uFatalError(const char *function, const char *file)
{
    snprintf(snapcanon_last_error, sizeof snapcanon_last_error,
             "kernel fatal error in %s() (%s.c)", function, file);
    snapcanon_fail("uFatalError");
}

void uAbortMemoryFull(void)
{
    snprintf(snapcanon_last_error, sizeof snapcanon_last_error, "out of memory");
    snapcanon_fail("uAbortMemoryFull");
}

int uQuery(const char *message, const int num_responses,
           const char *responses[], const int default_response)
{
    (void)message; (void)num_responses; (void)responses;
    return default_response;   /* batch behaviour: always take the default */
}

void uLongComputationBegins(const char *message, Boolean is_abortable)
{
    (void)message; (void)is_abortable;
}

FuncResult uLongComputationContinues(void)
{
    return func_OK;            /* never cancelled */
}

void uLongComputationEnds(void)
{
}

/* SNAPCANON: the only accessor from kernel_code/interface.c that the kernel needs.  The
 * rest of interface.c is not copied because it drags in the orbifold API. */
int get_num_cusps(Triangulation *manifold)
{
    return manifold->num_cusps;
}

/* Thread-local xorshift32 generator returning 31-bit values (like RAND_MAX = 2^31-1). */
static __thread unsigned int snapcanon_rng_state = 2463534242u;

void snapcanon_srand(unsigned int seed)
{
    snapcanon_rng_state = seed ? seed : 2463534242u;
}

int snapcanon_rand(void)
{
    unsigned int x = snapcanon_rng_state;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    snapcanon_rng_state = x;
    return (int)(x >> 1);
}
