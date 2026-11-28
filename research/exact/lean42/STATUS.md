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
