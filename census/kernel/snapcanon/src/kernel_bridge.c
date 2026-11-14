/*
 *  kernel_bridge.c
 *
 *  SNAPCANON: this file is new (it is not part of SnapPea).  It reproduces, in C,
 *  the sequence of kernel calls that SnapPy makes for
 *
 *      M = snappy.Link(pd).exterior()          # spherogram + Triangulation.with_hyperbolic_structure
 *      for _ in range(25):
 *          if M.solution_type() == "all tetrahedra positively oriented": ...
 *          M.randomize()
 *      K = M.canonical_retriangulation()        # _canonical_retriangulation(): proto_canonize + retry
 *
 *  The PD -> KLP conversion mirrors spherogram/links/links_base.py (python_KLP,
 *  KLPCrossing, vertex_to_KLP, _orient_crossings) and snappy's cython glue
 *  (get_triangulation_from_PythonKLP in cython_src/core/tail.pyx).  For knots the
 *  crossing sign does not depend on the orientation chosen, so a consistent
 *  traversal is enough; the sign rule was checked against spherogram on the
 *  test diagrams (see validate.py).
 */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <setjmp.h>

#include "SnapPea.h"
#include "kernel.h"          /* Triangulation, Tetrahedron, EVALUATE, ... (kernel-internal header) */
#include "snapcanon_rand.h"
#include "kernel_bridge.h"

/* Defined in snappea/snapcanon_shims.c */
extern __thread jmp_buf *snapcanon_fatal_jmp;
extern __thread char     snapcanon_last_error[256];

/* KLP vertex naming (spherogram vertex_to_KLP):  index i = v if sign == +1,
 * else (v - 1) mod 4;  names 0..3 = Ybackward, Xforward, Yforward, Xbackward. */
static const int KLP_STRAND[4] = { KLPStrandY, KLPStrandX, KLPStrandY, KLPStrandX };
static const int KLP_DIR[4]    = { KLPBackward, KLPForward, KLPForward, KLPBackward };

static int klp_name_index(int sign, int v)
{
    return sign == 1 ? v : (v + 3) % 4;
}

static void set_err(char *errmsg, size_t errlen, const char *msg)
{
    if (errmsg && errlen > 0) {
        strncpy(errmsg, msg, errlen - 1);
        errmsg[errlen - 1] = '\0';
    }
}

/* Analysis of the PD code: partner slots, traversal directions, signs and components. */
typedef struct PDInfo {
    int n;
    int *pc;          /* pc[4c+v]: crossing at the other end of slot (c,v)          */
    int *ps;          /* ps[4c+v]: slot at that crossing                            */
    int *sign;        /* sign[c] = +1 or -1                                          */
    int *enter;       /* enter[2c+p]: entering slot (0..3, parity p) of strand p at c */
    int *comp;        /* comp[2c+p]: component index of strand p at c                */
    int  ncomp;
} PDInfo;

static void pdinfo_free(PDInfo *I)
{
    free(I->pc); free(I->ps); free(I->sign); free(I->enter); free(I->comp);
    memset(I, 0, sizeof *I);
}

/* Returns 0 on success, SC_ERR_INPUT if the PD code is not a valid 4-valent diagram. */
static int pdinfo_build(const int *pd, int n, PDInfo *I)
{
    int c, v, d, w, k;
    memset(I, 0, sizeof *I);
    I->n     = n;
    I->pc    = malloc(sizeof(int) * 4 * n);
    I->ps    = malloc(sizeof(int) * 4 * n);
    I->sign  = malloc(sizeof(int) * n);
    I->enter = malloc(sizeof(int) * 2 * n);
    I->comp  = malloc(sizeof(int) * 2 * n);
    if (!I->pc || !I->ps || !I->sign || !I->enter || !I->comp) {
        pdinfo_free(I);
        return SC_ERR_ALLOC;
    }
    /* Every edge label must occur exactly twice; its two occurrences are partners. */
    for (c = 0; c < n; c++)
        for (v = 0; v < 4; v++) {
            int count = 0, found_c = -1, found_v = -1;
            for (d = 0; d < n; d++)
                for (w = 0; w < 4; w++)
                    if (pd[4 * d + w] == pd[4 * c + v]) {
                        count++;
                        if (!(d == c && w == v)) { found_c = d; found_v = w; }
                    }
            if (count != 2 || found_c < 0) {
                pdinfo_free(I);
                return SC_ERR_INPUT;
            }
            I->pc[4 * c + v] = found_c;
            I->ps[4 * c + v] = found_v;
        }

    for (k = 0; k < 2 * n; k++) { I->enter[k] = -1; I->comp[k] = -1; }

    /* Traverse every component once.  Starting strand: entering at slot s0 (0 or 1),
     * leaving at slot s0+2, then continue at the partner of the leaving slot. */
    I->ncomp = 0;
    for (c = 0; c < n; c++)
        for (v = 0; v < 2; v++) {
            int c0 = c, s0 = v, cc = c0, e = s0;
            if (I->comp[2 * c0 + s0] != -1)
                continue;
            for (;;) {
                if (I->comp[2 * cc + (e % 2)] != -1) {
                    pdinfo_free(I);
                    return SC_ERR_INTERNAL;   /* strand visited twice: inconsistent diagram */
                }
                I->enter[2 * cc + (e % 2)] = e;
                I->comp[2 * cc + (e % 2)]  = I->ncomp;
                {
                    int leave = (e + 2) % 4;
                    int nc = I->pc[4 * cc + leave];
                    int ns = I->ps[4 * cc + leave];
                    cc = nc;
                    e  = ns;
                }
                if (cc == c0 && e == s0)
                    break;
            }
            I->ncomp++;
        }

    /* Crossing sign.  Slots (0,2) form the under strand, (1,3) the over strand.
     * Sign +1 iff exactly one of the two strands is traversed in its "forward"
     * sense (under: 0 -> 2, over: 1 -> 3); equivalently spherogram's rule. */
    for (c = 0; c < n; c++) {
        int under_fwd = (I->enter[2 * c + 0] == 0);
        int over_fwd  = (I->enter[2 * c + 1] == 1);
        I->sign[c] = (under_fwd != over_fwd) ? 1 : -1;
    }
    return 0;
}

/* Fills a KLPProjection exactly as snappy's get_triangulation_from_PythonKLP does. */
static int build_klp(const PDInfo *I, KLPProjection *P, KLPCrossing *cr)
{
    int c, v;
    for (c = 0; c < I->n; c++) {
        int sign = I->sign[c];
        memset(&cr[c], 0, sizeof cr[c]);
        for (v = 0; v < 4; v++) {
            int me   = klp_name_index(sign, v);
            int d    = I->pc[4 * c + v];
            int w    = I->ps[4 * c + v];
            int nb   = klp_name_index(I->sign[d], w);
            cr[c].neighbor[KLP_STRAND[me]][KLP_DIR[me]] = &cr[d];
            cr[c].strand[KLP_STRAND[me]][KLP_DIR[me]]   = KLP_STRAND[nb];
        }
        /* X strand = slots (3,1) for a positive crossing, (0,2) for a negative one. */
        if (sign == 1) {
            cr[c].component[KLPStrandX] = I->comp[2 * c + 1];
            cr[c].component[KLPStrandY] = I->comp[2 * c + 0];
        } else {
            cr[c].component[KLPStrandX] = I->comp[2 * c + 0];
            cr[c].component[KLPStrandY] = I->comp[2 * c + 1];
        }
        cr[c].handedness = (sign == 1) ? KLPHalfTwistCL : KLPHalfTwistCCL;
    }
    P->num_crossings  = I->n;
    P->num_free_loops = 0;
    P->num_components = I->ncomp;
    P->crossings      = cr;
    return 0;
}

/* Copies the canonical triangulation into plain arrays.  Returns 0 or an error code. */
static int extract_gluings(Triangulation *K, SCTriangulation *out)
{
    Tetrahedron *tet;
    int i = 0, t, f, v;
    int n = K->num_tetrahedra;

    for (tet = K->tet_list_begin.next; tet != &K->tet_list_end; tet = tet->next)
        tet->index = i++;                       /* scratch field, reset below */
    if (i != n)
        return SC_ERR_INTERNAL;

    out->ntet = n;
    out->nbr  = malloc(sizeof(int) * 4 * (size_t)n);
    out->perm = malloc(sizeof(int) * 16 * (size_t)n);
    if (!out->nbr || !out->perm)
        return SC_ERR_ALLOC;

    for (tet = K->tet_list_begin.next; tet != &K->tet_list_end; tet = tet->next) {
        t = tet->index;
        for (f = 0; f < 4; f++) {
            Tetrahedron *nb = tet->neighbor[f];
            int g = EVALUATE(tet->gluing[f], f);   /* face of nb that is glued to face f */
            if (nb == NULL || nb->index < 0 || nb->index >= n)
                return SC_ERR_INTERNAL;
            /* Consistency of the gluing as seen from the neighbour. */
            if (nb->neighbor[g] != tet || EVALUATE(nb->gluing[g], g) != f)
                return SC_ERR_INTERNAL;
            out->nbr[4 * t + f] = nb->index;
            for (v = 0; v < 4; v++)
                out->perm[16 * t + 4 * f + v] = EVALUATE(tet->gluing[f], v);
        }
    }
    for (tet = K->tet_list_begin.next; tet != &K->tet_list_end; tet = tet->next)
        tet->index = 0;                         /* leave the scratch field tidy */
    return 0;
}

void sc_free_triangulation(SCTriangulation *t)
{
    if (!t) return;
    free(t->nbr);
    free(t->perm);
    t->nbr = t->perm = NULL;
    t->ntet = 0;
}

int sc_canonical_triangulation(const int *pd, int ncross, int max_retri, unsigned seed,
                               SCTriangulation *out, char *errmsg, size_t errlen)
{
    jmp_buf       jb;
    jmp_buf      *prev = snapcanon_fatal_jmp;
    volatile int  rc = SC_ERR_INTERNAL;
    /* Everything that is set before setjmp() and not changed afterwards is valid after a
     * longjmp().  The kernel objects T and K are only touched on the normal path; on a
     * fatal kernel error they are leaked (see README, limitations). */
    Triangulation *T = NULL, *K = NULL;
    PDInfo         I;
    KLPProjection  P;
    KLPCrossing   *cr = NULL;
    int            i;

    memset(out, 0, sizeof *out);
    memset(&I, 0, sizeof I);
    if (!pd || ncross < 0 || max_retri < 0) {
        set_err(errmsg, errlen, "invalid arguments");
        return SC_ERR_INPUT;
    }
    if (ncross == 0) {
        /* The unknot diagram: its exterior is a solid torus, never hyperbolic. */
        set_err(errmsg, errlen, "no crossings: unknot");
        return SC_NOT_HYPERBOLIC;
    }

    /* Pure C preparation, before any kernel call, so that the error path below only has
     * to release objects whose values are fixed before setjmp(). */
    rc = pdinfo_build(pd, ncross, &I);
    if (rc != 0) {
        set_err(errmsg, errlen, rc == SC_ERR_INPUT ? "PD code is not a valid diagram"
                                                   : "allocation failed");
        return rc;
    }
    cr = malloc(sizeof(KLPCrossing) * (size_t)ncross);
    if (!cr) {
        pdinfo_free(&I);
        set_err(errmsg, errlen, "allocation failed");
        return SC_ERR_ALLOC;
    }
    build_klp(&I, &P, cr);

    snapcanon_srand(seed);

    if (setjmp(jb) != 0) {
        snapcanon_fatal_jmp = prev;
        set_err(errmsg, errlen, snapcanon_last_error);
        pdinfo_free(&I);
        free(cr);
        return SC_ERR_KERNEL;
    }
    snapcanon_fatal_jmp = &jb;

    /* Manifold(Link) -> with_hyperbolic_structure(): triangulate, solve, Dehn-fill (none). */
    T = triangulate_link_complement(&P, TRUE);
    if (T == NULL) {
        set_err(errmsg, errlen, "triangulate_link_complement failed");
        rc = SC_ERR_KERNEL;
        goto done;
    }
    find_complete_hyperbolic_structure(T);
    do_Dehn_filling(T);

    /* for _ in range(max_retri): if solution is geometric: ...; randomize() */
    for (i = 0; ; i++) {
        if (T->solution_type[filled] == geometric_solution)
            break;
        if (i >= max_retri) {
            set_err(errmsg, errlen, "no geometric solution after the allowed retriangulations");
            rc = SC_NOT_HYPERBOLIC;
            goto done;
        }
        randomize_triangulation_with_options(T, 6, 4);   /* Triangulation.randomize() defaults */
    }

    /* _canonical_retriangulation(): up to 10 tries of copy + proto_canonize. */
    {
        int ok = 0, tries;
        for (tries = 0; tries < 10; tries++) {
            copy_triangulation(T, &K);
            if (proto_canonize(K) == func_OK) { ok = 1; break; }
            free_triangulation(K);
            K = NULL;
        }
        if (!ok) {
            set_err(errmsg, errlen, "proto_canonize failed");
            rc = SC_CANON_FAILED;
            goto done;
        }
    }
    canonical_retriangulation_with_opacities(K, NULL);

    rc = extract_gluings(K, out);
    if (rc != 0) {
        set_err(errmsg, errlen, "could not read the canonical gluings consistently");
        sc_free_triangulation(out);
        goto done;
    }
    rc = SC_OK;

done:
    snapcanon_fatal_jmp = prev;
    if (K) free_triangulation(K);
    if (T) free_triangulation(T);
    pdinfo_free(&I);
    free(cr);
    return rc;
}
