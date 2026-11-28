# Lean42 status (setup, Phase 1, Phase 2)

Toolchain `leanprover/lean4:v4.25.2`, Mathlib pinned to `v4.25.2` (git dependency in `lakefile.toml`).
Build: `cd research/exact/lean42 && lake build` (about 1230 jobs; Mathlib is already built in `.lake`).
No `sorry`, no `native_decide`, no new axioms: `#print axioms knotClass` gives
`[propext, Classical.choice, Quot.sound]`.

## Environment
* `lake exe cache get` FAILS: host `lakecache.blob.core.windows.net` is refused by the agent proxy
  (HTTP 403 "no rule or network setting allows this host"). Mathlib was therefore built from source
  (only the 1221 jobs reachable from `Lean42/Prelude.lean`; about 70 minutes on 4 cores).
* Reservoir (`reservoir.lean-lang.org`) and elan's own download host are blocked too: the lakefile
  uses the git URL of Mathlib, and the toolchain archive was fetched from github.com releases and
  unpacked by hand into `~/.elan/toolchains/leanprover--lean4---v4.25.2`.

## What is proved, file by file (all in `Lean42/`)
| File | Content |
|---|---|
| `Geom.lean` | `Pt = Fin 3 → ℚ`; `seg` and `tri` as convex hulls; `mem_seg`, `mem_tri`; injective affine maps map segments/triangles to segments/triangles. |
| `FM.lean` | Fourier-Motzkin: `feasible` is a program, `feasible_iff` proves it decides linear systems over ℚ (strict and non-strict). Basis of the decidable intersection predicates. |
| `Polygon.lean` | closed polygon = cyclic vertex list, `edges`, `pset`, `Simple` (edges meet only in common endpoints), rotation lemmas. |
| `Delta.lean` | `DeltaMove` (Burde-Zieschang Def. 1.6 and Remark: degenerate triangles allowed, new polygon simple), `Equiv` (Def. 1.7 + rotation, reversal, translation), transport along injective affine maps (`Equiv.map`), `mirror`. |
| `Spec.lean` | verbatim copy of the frozen `Len52/Spec.lean` (namespace `Lean42.Spec`). |
| `Lat.lean` | unit lattice edges; `latPoly_simple`: a lattice polygon is simple. |
| `Square.lean` | the unit lattice square meets lattice edges only at corners or along sides (`lat_edge_square`), facts on sides, diagonal and half-squares. |
| `Moves.lean` | `flip_equiv`, `uturn_equiv`: the flip and U-turn removal as two explicit Delta-moves each, with the free triangles proved free. |
| `Words.lean` | polygon of a word (`wpoly`), `isPolygon_iff`, `latPoly_wpoly`, `simple_wpoly`, `symMat` (linear map of a lattice symmetry). |
| `Ops.lean` | rotation, reversal, symmetry on polygons: `IsPolygon` preserved and polygons `Equiv`. |
| `Flip.lean` | corner flip and U-turn removal on words (`flip_wpoly`, `uturn_wpoly`). |
| `Knot.lean` | `KnotType P` and **`knotClass : KnotClass (KnotType P)`** for an arbitrary polygon `P` (all six fields); `knotType_of_equiv`, `knotType_of_equiv_mirror`: the class contains `P` and its mirror image. |
| `Decide.lean` | `simpleB`/`simple_iff`: `Simple` is decidable; `deltaB`/`deltaMove_iff`: the Delta-move at the first edge is decided by a program (Fourier-Motzkin). Checked by `#eval` on small examples (unit square: simple; self-crossing pentagon: not; Delta over a free triangle: true, over a triangle crossing an edge: false, apex on the edge (bisection): true, apex on the line outside the edge: false). |
| `Diagram.lean` | Phase 3/4 step A and B: fixed rational projection, genericity (B-Z 1.11, decidable `genericB`), crossing events, colourings by a Mathlib `Quandle` (`col`), Alexander quandles `AlexQ`, `inv Q L = {col L, col L.reverse}`; proved: `inv_reverse`, `inv_translate`, `genericB_translate`. |
| `DiagramCheck.lean` | `#guard` checks of `col` against an independent Python computation (3_1, 4_1). |
| `Check.lean` | `#print axioms` of all main theorems: `[propext, Classical.choice, Quot.sound]`. |

## Decisions
1. **Translation is a generator of `Equiv`** (with Delta-moves, rotation, reversal). By
   Burde-Zieschang Prop. 1.10 (proof of (1) => (3), Fig. 1.6) translations are composites of
   Delta-moves, so the relation is the same, but we do not prove it. Any statement "no lattice
   polygon is `Equiv` to ..." is stronger for a bigger relation, so the lower bounds do not weaken.
   Phase 3/4 must show that diagram invariants are unchanged by translation (clear).
2. **Rotations by 90 degrees are not proved Delta-equivalent to the identity.** The class
   `KnotType P` is saturated under the 48 lattice symmetries: it is the union over `IsSym f` of the
   classes of the 48 concrete polygons `symMat f (P)`. It contains `P` and `mirror P` and is larger
   than "K or mirror K", so lower bounds for it are stronger. Delta-moves commute with every
   lattice symmetry (`Equiv.map`). For invariants: a polygon in the class of `σ(w_K)` has the
   invariant of `σ(w_K)` (fixed projection direction, Delta-invariance), and that is computed on a
   concrete polygon. Hence Phase 3 needs only: the colouring count for one fixed generic rational
   direction is unchanged along a Delta-chain between two polygons that are generic for that
   direction (perturbing non-generic intermediate polygons); no proof that rotations are
   Delta-equivalent to the identity and no independence of the projection direction.
3. `Simple` is stated as "any two different edges meet only in common endpoints", with distinct
   vertices; consecutive edges then share exactly their common vertex and others are disjoint.

## Not done / next
* Translation by Delta-moves (decision 1) and rotations by Delta-moves (decision 2) are *not*
  proved; both are avoided as explained above.
* `Decide.lean` is not optimised (36 Fourier-Motzkin systems per edge in `badB`); it is meant as the
  verified specification of the decision procedure.
* Phase 3 (diagrams, Reidemeister) is the next stage.

## Phase 4a: choice of the quandles (computed; scripts in `tools/`)
Data used: the n = 44 witnesses of 7_1..7_7 and 8_20 are **not in the repository**, so the knot
types were represented by the minimal-diagram seed words of `research/data/seeds.json` (84-102 edges),
by `out/witness40.txt` (6_1, 6_2, 6_3, 3_1#3_1, 3_1#-3_1), `out/witness42_8_19.txt` and the unknot.
Counts of quandle colourings are knot invariants, so any representative will do; as a test, the
counts are identical for three different projections and for both orientations of the polygon
(`tools/quandle_counts.py`, Smith normal form over Z/p^k, CRT for composite n). The Lean definitions
of `Lean42/Diagram.lean` reproduce the Python counts (`DiagramCheck.lean`).

Quandles: Alexander quandles A(n,t) = (Z/n, x*y = (1-t)x + t y), t a unit (dihedral R_n = A(n,-1)).
The mirror image of K has the counts of K for t^-1. A single quandle q "separates" K from tau if
{c_K(q), c_K(q^-1)} and {c_tau(q), c_tau(q^-1)} are disjoint (this covers both chiralities).
Every pair (target, survivor type) is separated by some A(n,t) with n <= 30 (`tools/quandle_cover.py`).
A set cover of the pairs {7_1..7_7, 8_20} x {0_1,3_1,4_1,5_1,5_2,6_1,6_2,6_3,3_1#3_1,3_1#-3_1,8_19}
and {8_19} x (same without 8_19) needs 8 quandles (exhaustive search: no cover with at most 7
quandles of modulus <= 26). Choice (greedy, all moduli <= 15):

  A(15,2), A(7,6), A(5,4), A(7,2), A(13,12), A(9,2), A(11,3), A(13,2).

Counts (a/b: counts for t and t^-1 when they differ; here all equal):

| knot | A(15,2) | A(7,6) | A(5,4) | A(7,2) | A(13,12) | A(9,2) | A(11,3) | A(13,2) |
|---|---|---|---|---|---|---|---|---|
| 0_1 | 15 | 7 | 5 | 7 | 13 | 9 | 11 | 13 |
| 3_1 | 45 | 7 | 5 | 7 | 13 | 27 | 11 | 13 |
| 4_1 | 15 | 7 | 25 | 7 | 13 | 9 | 11 | 13 |
| 5_1 | 15 | 7 | 25 | 7 | 13 | 9 | 11 | 13 |
| 5_2 | 15 | 49 | 5 | 7 | 13 | 9 | 121 | 13 |
| 6_1 | 225 | 7 | 5 | 49 | 13 | 81 | 11 | 169 |
| 6_2 | 15 | 7 | 5 | 7 | 13 | 9 | 11 | 13 |
| 6_3 | 15 | 7 | 5 | 49 | 169 | 9 | 11 | 13 |
| 3_1#3_1 | 135 | 7 | 5 | 7 | 13 | 81 | 11 | 13 |
| 3_1#-3_1 | 135 | 7 | 5 | 7 | 13 | 81 | 11 | 13 |
| 8_19 | 45 | 7 | 5 | 7 | 13 | 27 | 11 | 169 |
| 7_1 | 15 | 49 | 5 | 7 | 13 | 9 | 11 | 13 |
| 7_2 | 75 | 7 | 5 | 7 | 13 | 9 | 11 | 13 |
| 7_3 | 15 | 7 | 5 | 7 | 169 | 9 | 11 | 13 |
| 7_4 | 45 | 7 | 25 | 7 | 13 | 27 | 11 | 13 |
| 7_5 | 15 | 7 | 5 | 49 | 13 | 9 | 11 | 13 |
| 7_6 | 75 | 7 | 5 | 7 | 13 | 9 | 11 | 13 |
| 7_7 | 45 | 49 | 5 | 7 | 13 | 27 | 11 | 13 |
| 8_20 | 45 | 7 | 5 | 7 | 13 | 81 | 11 | 13 |

Checks on the survivors: all 59,072 words of `dmon2/bench/ci/r6_n42_F/F_n42.words.txt` are generic for
the projection of `Diagram.lean` (0 failures; `tools/quandle_survivors.py`, 163 s) and their count vectors
(8 quandles and their inverses) take only 8 distinct values, all equal to vectors of the types
{0_1, 3_1, 4_1, 5_1, 5_2, 6_1, 6_2, 6_3, 3_1#3_1, 3_1#-3_1, 8_19} (no unknown vector). None of the
7_1..7_7, 8_20 vectors, nor their mirror vectors, occurs among them. 8_19 occurs (it is a survivor type
at n = 42), which is expected: the 8_19 lower bound is for n <= 40.
Remarks: linear Alexander quandles over a prime field do not separate 3_1 from 8_20; A(9,2) does
(27 against 81), as does A(15,2) in the table. 8_19 vs 3_1 needs A(13,2) (13 against 169).
Cost for Phase 7: the count of colourings by A(n,t) is the size of the kernel of a matrix over Z/n;
brute force n^arcs is impossible, so Phase 7 needs a verified Smith-normal-form count (or a
certificate: a basis of the solution module plus a proof that it is complete).

## Phase 3/4 progress (this run)
* A done: `Diagram.lean`. B partly: reversal and translation invariance proved; rotation of the vertex
  list not proved (about 300 lines, see PHASE3_PLAN.md C0).
* C not started: full case analysis and estimates in `PHASE3_PLAN.md` (5000-7000 lines of Lean;
  the long parts are C2c, the local geometry of an elementary Delta-move, and C3, perturbation).
  Decision needed from the coordinator before continuing (see report).
* D done: quandle choice and tables above.
