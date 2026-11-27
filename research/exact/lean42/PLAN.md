# Lean proof of the n = 42 results: plan

## 1. What is to be proved

For each target knot K, given by an explicit witness polygon w_K, and for its mirror image:

* **Lower bounds.**
  * For K in {7_1, ..., 7_7, 8_20}, no lattice polygon with at most 42 edges is equivalent to w_K or
    to its mirror image.
  * For K = 8_19, the same statement with 40 edges in place of 42.
* **Upper bounds.** Each witness w_K is a lattice polygon of the stated length:
  * w_{8_19} has 42 edges;
  * the 7-crossing witnesses and the 8_20 witness have 44 edges.
* **Identification.** The diagram of each witness w_K is related by Reidemeister moves to the
  standard diagram of K (a PD code from the knot tables, written out in the file).

"Equivalent" must be defined inside Lean, not assumed. Take Reidemeister's own definition of PL knot
equivalence: two closed simple polygons in Q^3 are equivalent if they are joined by a finite sequence of
Delta-moves. A Delta-move replaces an edge [a, b] by the two edges [a, c], [c, b], or the reverse, when
the closed triangle abc meets the polygon only in [a, b] (or in [a, c] ∪ [c, b]).

Lickorish (Ch. 1, pp. 2-3) states that this relation agrees with equivalence by orientation-preserving
PL homeomorphisms of S^3, but assumes it ("any proof would have to penetrate the technicalities of PL
theory"). He also passes from Delta-moves to Reidemeister moves "with a little careful thought", without
a proof. So Lickorish is not a source for Phase 3; we must write that proof ourselves (see Phase 3).
The final paper states the theorems for Delta-equivalence and quotes the agreement with PL ambient
isotopy precisely (Burde and Zieschang, *Knots*, Ch. 1), saying that the Lean proof does not use it.

## 2. What may be assumed

The proof may assume only the following:
* Lean's core axioms (propext, Quot.sound, Classical.choice) and Mathlib.
* The same trust model as the 5_2 proof for the finite computation: closed Boolean terms
  `checkPart n r = true`, evaluated by compiled code (PROOF_RIGOROUS.md §8).

The two topological hypotheses of the 5_2 proof, `KnotClass` and `TopHyp`, must now be **theorems**:
* `KnotClass` (rotation, reversal, lattice symmetries, corner flips and U-turn removals preserve the
  knot type) follows from the Delta-move definition. The move sequences are explicit.
* `TopHyp` (colourings are invariants) follows from two facts: a Delta-move changes a generic projection
  only by Reidemeister moves, and colouring counts are unchanged by Reidemeister moves.

No `sorry`, `axiom`, `native_decide` or `implemented_by` may appear outside the compiled certificate
check. Every theorem file ends with `#print axioms` for its main results.

## 3. Sources

The books are local copies; never commit them.
* Lickorish, *An Introduction to Knot Theory*, GTM 175: Ch. 1 (Delta-moves, Reidemeister's theorem),
  Ch. 2 (Seifert surfaces, genus, factorisation), Ch. 3 (colourings, quandles via the Alexander module).
* Rourke and Sanderson, *Introduction to Piecewise-Linear Topology*: PL foundations, general position,
  ball pairs.
* Moise, *Geometric Topology in Dimensions 2 and 3*: the PL Schoenflies theorem in R^3. This is needed
  only for Phase 6.
* The existing 5_2 proof, research/exact/lean/. It is frozen: do not edit it. Copy and adapt its code
  into lean42/, keeping the git history of the copied ideas in the commit messages.
* The search being proved: research/exact/dmon2/enum_v.cpp. Its rules and their paper proofs are in
  research/exact/dmon2/DMON2.md, LEADS3.md and the agents' reports summarised there.

## 4. Phases

Each phase ends with a commit that builds with `lake build` and has no `sorry`.

1. **PL basics.** Points of Q^3, segments, triangles and closed simple polygons. Decidable intersection
   predicates on rational segments and triangles. Delta-moves and equivalence (`EqvGen`). The mirror map.
   The embedding of lattice words (Spec.lean's `IsPolygon` words) as polygons.
2. **KnotClass as a theorem.** Rotation and reversal give the same polygon or an equivalent one. A lattice
   symmetry maps equivalent polygons to equivalent polygons, and orientation-reversing symmetries give
   the mirror. A corner flip and a U-turn removal are Delta-moves across a free unit square: give the
   moves explicitly and prove that the triangles are free.
3. **Diagrams and Reidemeister's theorem.**
   * A fixed rational projection direction, and the notion of a polygon in general position for it.
   * Crossings and signs; a combinatorial diagram (PD code or signed Gauss code); Reidemeister moves
     R1, R2 and R3 on it.
   * **Theorem.** If two polygons in general position are Delta-equivalent, their diagrams are related
     by Reidemeister moves and planar isotopy. Prove it by subdividing every Delta-move into small
     Delta-moves in general position, then checking each small move case by case (the triangle's
     projection meets at most one other edge, or one crossing). Lickorish only indicates this; a written
     proof is in Burde and Zieschang, Ch. 1, and in Murasugi, *Knot Theory and Its Applications*, Ch. 4.
   * A simpler route, to be preferred if it works: do not build diagrams at all. Define the colouring
     count of a polygon directly from its projection in one fixed rational direction d (arcs between
     undercrossings, one relation per crossing), prove it is unchanged by a Delta-move whose triangle is
     in general position for d, and prove that every Delta-move between polygons in general position
     factors into such moves. This avoids planar isotopy and PD codes.
   * Also needed: every polygon is Delta-equivalent to one in general position by an arbitrarily small
     move, and the diagram does not depend on that choice up to Reidemeister moves.
4. **Colouring invariants.**
   * Fox p-colourings, and colourings by the linear Alexander quandle Z/p with t = a.
   * Prove that the counts are unchanged by R1, R2 and R3.
   * Conclude `TopHyp`-type theorems for all targets.
   * Fox colourings alone cannot separate 7_1 from 5_2, 7_2 from 6_2, 7_3 from 6_3, or 8_20 from 6_1, so
     choose Alexander quandles (p, a) that do. Check the choice by computation.
5. **The search and its soundness.**
   * Port the rules of enum_v.cpp into a Lean program, extending the 5_2 search:
     * two-ended DFS with the fail-first end choice;
     * axis-count and travel bounds (`-aotp -ax1d`);
     * MST and Held-Karp tour bounds;
     * the GW3 walk bound;
     * the mirror rule tau;
     * the DMON2 rules F1 (face) and C1 (crank);
     * the cyclic leaf checks.
   * Extend the normal-form theorem (the 5_2 proof's PanDMONium theorem) with the new normal-form
     conditions, each proved by explicit moves.
   * Prove that every pruning test removes no word that satisfies the normal form.
6. **The plane lemma.**
   * The C++ production run uses Lemma 3 (`-stair`), which needs primeness. Without it the search costs
     about 3.5-3.7 times as much.
   * A version without primeness (Lemma 3*: a side that is a graph over the plane in some direction must
     be a geodesic, proved by an explicit embedded disk) is being measured.
   * If Lemma 3* is enough, prove it with Delta-moves.
   * Otherwise, formalise:
     * PL Schoenflies in R^3 (Moise);
     * the uniqueness of unknotted ball-arc pairs;
     * primeness of the targets (Lickorish, Ch. 2);
     * Lemma 3 itself.
7. **Certificates and main theorems.** Partition the search into parts, run them by compiled code, check
   the colouring certificates for every survivor and target, and state the final theorems.

## 5. Working rules

* Work in research/exact/lean42/ (a new Lake project with Mathlib). Pin the Mathlib version.
* Proofs, not outlines, as in CLAUDE.md. Each file starts with a comment that says what it proves and
  which book section it follows.
* Commit after each working step. Push to the branch claude/great-einstein-snvnnb.
