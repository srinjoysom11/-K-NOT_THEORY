# The knot 5_2 needs exactly 36 edges on the cubic lattice

**Theorem.** Len(5_2) = 36: some closed self-avoiding walk of 36 unit steps on the cubic lattice
ℤ³ is a knot of type 5_2, and no such walk with fewer steps is.

This file is the complete argument, written to be checked line by line. Each step is either proved
here or is a named textbook theorem, cited with the place where it is proved. The finite
computation is done by a program whose completeness is proved in Lean (§5, §10). Labels: **[P]**
proved here (and, where marked, in Lean), **[T]** textbook theorem with reference, **[C]** finite
computation with the command that reproduces it.

How to read it. §1 fixes the definitions. §2 turns three kinds of local change of a lattice
polygon into isotopies. §3–§4 show that if a 5_2 polygon with at most 34 edges existed, a
particular one of them would satisfy a list of local conditions ("Survive", conditions C1–C7). §5
proves that the search program outputs every word with these conditions. §6–§7 show that no output
word is a 5_2, using Fox 7-colourings. §8 records the computation, §9 the 36-edge example, §10 the
formalisation, §11 what is trusted and why.

---------------------------------------------------------------------------------------------------

## 1. Definitions

**Lattice words and polygons.** The six unit vectors are coded
0 = e = (1,0,0), 1 = w = (−1,0,0), 2 = n = (0,1,0), 3 = s = (0,−1,0), 4 = u = (0,0,1),
5 = d = (0,0,−1). The *axis* of a direction d is ⌊d/2⌋, and rev(d) is the opposite direction.

A *word* w = w_0 w_1 … w_{n−1} gives the walk with vertices v_0 = 0 and v_{i+1} = v_i + unit(w_i).
The word is a *polygon word* (`IsPolygon` in Lean) when

* n ≥ 4, every letter is a direction, v_n = 0, and
* v_0, …, v_{n−1} are pairwise distinct.

Its *polygon* |w| ⊂ ℝ³ is the union of the n closed unit segments [v_i, v_{i+1}] (indices mod n).

**Lemma 1.1 [P].** For a polygon word, |w| is a simple closed polygonal curve.

*Proof.* Two distinct unit lattice segments meet in at most one common endpoint. If they shared an
interior point they would be collinear and overlap, and then they would be the same segment,
because their endpoints are lattice points at distance 1. Segment i has endpoints v_i and v_{i+1}.
These sets are distinct for i ≠ j, because the v_i are distinct and n ≥ 3. Segments i and j share
an endpoint only if {v_i, v_{i+1}} ∩ {v_j, v_{j+1}} ≠ ∅, which by distinctness means j = i ± 1
(mod n). So |w| is a cycle of n segments that meet only consecutively, at single points. ∎

A *lattice polygon* is any set of this form or a translate of one. Every lattice polygon with n
edges is the translate of |w| for some polygon word w of length n: start at any vertex and read the
steps.

**Knot types.** A knot is a tame simple closed curve in ℝ³; here all knots are polygonal. Two
knots are *equivalent* (have the same knot type) if there is an orientation-preserving
homeomorphism of ℝ³ carrying one onto the other. For polygonal knots this is the same as ambient
isotopy, and the same as being related by a finite sequence of Δ-moves [T: Burde–Zieschang,
*Knots*, Ch. 1, §1.A–B; Reidemeister, *Knotentheorie* (1932), §1]. A **Δ-move** replaces one edge
[a, b] of a polygonal knot K by the two edges [a, c], [c, b], or the reverse. It is allowed when
the closed triangle abc meets K only in [a, b] (resp. in [a, c] ∪ [c, b]).

We use only the easy direction: *a Δ-move does not change the knot type.* (The triangle has a
neighbourhood in ℝ³ that meets K in a single arc. A homeomorphism supported in that neighbourhood
pushes one side of the triangle onto the other two, and it is isotopic to the identity.)

Knot types are taken as **unoriented**. The **mirror image** K* of K is its image under a
reflection of ℝ³.

**Len.** For a knot type K, Len(K) is the least n such that some lattice polygon with n edges has
type K.

**The knot 5_2** is the type of the diagram with PD code
`[[1,5,2,4],[3,9,4,8],[5,1,6,10],[7,3,8,2],[9,7,10,6]]` (KnotInfo; Rolfsen's table, *Knots and
Links*, App. C). A knot and its mirror image have the same Len: a reflection of ℤ³ maps lattice
polygons to lattice polygons with the same number of edges. So the theorem is about the pair
𝒦 = {5_2, 5_2*}.

**The class T.** T(w) holds when w is a polygon word and the knot type of |w| lies in 𝒦.
The theorem says: T(w) ⇒ |w| ≥ 36, and T(w₃₆) holds for an explicit word w₃₆ of length 36.

---------------------------------------------------------------------------------------------------

## 2. Four moves that do not change the knot type

**Lemma 2.1 (segment and square) [P].** Let Q be a closed unit lattice square, i.e. the convex
hull of q, q+a, q+a+b, q+b with q ∈ ℤ³ and a ⊥ b unit lattice vectors. Let E be a closed unit
lattice segment. Then E ∩ Q is empty, a corner of Q, or a side of Q.

*Proof.* Let H be the plane of Q.
* If E is not parallel to H, it is perpendicular to H, since lattice directions are coordinate
  axes. Then E meets H in at most one point, which is a lattice point because one coordinate of E
  is constant except along the axis normal to H, and the end values are integers. The only
  lattice points of Q are its corners.
* If E is parallel to H but not in H, E ∩ Q = ∅.
* If E ⊂ H, then in the coordinates of H both E and Q are unions of cells of the unit grid, and a
  unit grid edge meets a unit grid square in ∅, a corner or a side. ∎

**Lemma 2.2 (corner flip) [P].** Let w be a polygon word and 1 ≤ i < n with w_{i−1}, w_i on
different axes. Put v′ = v_{i−1} + unit(w_i), and suppose v′ is not a vertex of w. Let w′ =
swapAt(w, i) be w with letters i−1 and i exchanged. Then:
* w′ is a polygon word;
* its vertices are those of w with v_i replaced by v′;
* |w′| has the same knot type as |w|.

*Proof.* The walk of w′ agrees with w up to v_{i−1}. It then goes to v_{i−1} + unit(w_i) = v′,
then to v′ + unit(w_{i−1}) = v_{i+1}, and agrees with w afterwards. The vertices are distinct
because v′ is new. Let Q be the unit square v_{i−1}, v_i, v_{i+1}, v′. Its four corners consist of
three vertices of |w| and the non-vertex v′. By Lemma 2.1, every edge of |w| meets Q in ∅, a corner
or a side.
* A side of Q containing v′ is not an edge of |w|, since v′ is not a vertex.
* The side [v_{i−1}, v_{i+1}] is not a side of Q: it is a diagonal.
* So the only edges that meet Q in a side are [v_{i−1}, v_i] and [v_i, v_{i+1}]. All other edges
  meet Q at most in corners, and only in v_{i−1} or v_{i+1} (not v_i, whose only edges are the two
  above).

Now do two Δ-moves.
1. In the triangle v_{i−1} v_i v_{i+1} ⊂ Q, replace the two edges at v_i by the diagonal
   [v_{i−1}, v_{i+1}]. The triangle meets |w| exactly in the two edges, so this is allowed.
2. In the triangle v_{i−1} v′ v_{i+1} ⊂ Q, replace the diagonal by [v_{i−1}, v′] ∪ [v′, v_{i+1}].
   The intermediate knot meets Q only in the diagonal and in the points v_{i−1}, v_{i+1}, so this
   triangle meets it only in the diagonal; this is allowed.

The result is |w′|. ∎

**Lemma 2.3 (U-turn removal) [P].** Let w be a polygon word with n ≥ 6 and i + 3 ≤ n, such that
w_i = a, w_{i+1} = b, w_{i+2} = rev(a) with a ⊥ b. Let w′ = removeUturn(w, i), the word with the
three letters a b rev(a) replaced by the single letter b. Then w′ is a polygon word of length n − 2,
and |w′| has the same knot type as |w|.

*Proof.* The vertices of w′ are those of w with v_{i+1} and v_{i+2} deleted. Note that
v_{i+3} = v_i + b, so consecutive vertices still differ by a unit vector. The vertices are
distinct, and n − 2 ≥ 4. Let Q be the square v_i, v_{i+1}, v_{i+2}, v_{i+3}, with all four corners
vertices of |w|.
* Three of its sides are edges of |w|.
* The fourth, [v_i, v_{i+3}], is not an edge of |w|: v_{i+3} = v_{i−1} would force n = 4.
* By Lemma 2.1 every other edge meets Q in at most a corner, and only at v_i or v_{i+3}, because
  v_{i+1}, v_{i+2} have no other edges.

Two Δ-moves: the triangle v_i v_{i+1} v_{i+2} gives the diagonal [v_i, v_{i+2}], and then the
triangle v_i v_{i+2} v_{i+3} turns the diagonal plus [v_{i+2}, v_{i+3}] into [v_i, v_{i+3}]. Each
triangle meets the current knot only in the replaced edges, as in Lemma 2.2. ∎

**Lemma 2.4 (same polygon, rigid motions) [P].**
(a) rotate1(w) = w_1 … w_{n−1} w_0 has polygon |w| − v_1, a translate.
(b) revWord(w) = rev(w_{n−1}) … rev(w_0) has polygon |w|: the same cycle traversed backwards from
    v_0.
(c) Let f be a bijection of {0,…,5} with f(rev d) = rev f(d) (`IsSym`). Then there is a signed
    permutation matrix M with M·unit(d) = unit(f(d)), and |w.map f| = M|w|.

Translations and rotations (det M = 1) are ambient isotopies, through a path in SO(3) and in the
translation group. A reflection (det M = −1) maps a knot to its mirror image.

*Proof.* (a) and (b): direct from the definition of the vertices. (c): f permutes the three axes
and maybe flips signs. M is the corresponding signed permutation matrix, and the vertices of
w.map f are M v_i by induction. ∎

**Corollary 2.5 [P].** T has the closure properties `KnotClass` (Lean, Spec.lean):

| property | justification |
|---|---|
| T(w) ⇒ w is a polygon word | definition of T |
| closed under rotate1 and revWord | Lemma 2.4 (a), (b) |
| closed under w ↦ w.map f for every IsSym f | Lemma 2.4 (c); 𝒦 is closed under mirror image |
| closed under valid corner flips | Lemma 2.2 |
| closed under U-turn removal when n ≥ 6 | Lemma 2.3 |

In the Lean development these are the hypotheses `KnotClass T`. Everything after this point uses
only these properties of T, together with the colouring property of §6.

---------------------------------------------------------------------------------------------------

## 3. Parity

**Lemma 3.1 [P, Lean: `isPolygon_length_even`].** A polygon word has even length.

*Proof.* v_n = 0 means that, along each axis, the number of positive steps equals the number of
negative steps. ∎

---------------------------------------------------------------------------------------------------

## 4. A normal form for a shortest polygon in T

Suppose T(w₀) holds. Let m be the least length of a word in T. Then m ≤ |w₀| and m is even.

**4.1 Axis order.** Choose w₁ ∈ T of length m. Let #_A(w) be the number of letters on axis A.
Some permutation π of the axes sorts the counts so that #_z ≤ #_y ≤ #_x. The map f(d) = the
direction with the same sign on axis π(axis d) is IsSym. Applying it keeps T (Cor. 2.5), keeps the
length, and permutes the counts. Let W be the set of words of T of length m with #_z ≤ #_y ≤ #_x;
it is not empty.

**4.2 Height functions.** For a word w let z_min be the least z-coordinate of v_0, …, v_{n−1}. Put

* Ψ(w) = Σ_{i<n} (z(v_i) − z_min), and
* Ψ₂(w) = Σ_{i<n} (y(v_i) − y_min).

Both are non-negative integers, unchanged by translation and by the moves of Lemma 2.4 (a), (b).
Choose w* ∈ W minimising Ψ, and among those, minimising Ψ₂.

**4.3 Canonical position.**
* Rotate w* (Lemma 2.4 a, repeatedly) so that v_0 is the vertex that is least in the order
  (z, then y, then x). Rotation translates all vertices by the same vector, so the result is still
  in W with the same Ψ and Ψ₂.
* The vertices are distinct, so every other vertex is strictly greater than v_0 = 0 in that order.
  This is condition **C3**.
* The two edges at v_0 lead to v_1 and v_{n−1}. Both are greater than 0, so unit(w_0) and
  −unit(w_{n−1}) both lie in {e, n, u}, and they are different because v_1 ≠ v_{n−1}.
* If w_0 > rev(w_{n−1}), replace the word by revWord (Lemma 2.4 b). This exchanges the two edges
  and keeps W, Ψ, Ψ₂ and v_0.

Call the result w. It satisfies **C4**: w_0 < rev(w_{n−1}).

If m = 4, w is a unit square, a case handled directly in §7. From now on m ≥ 6.

**4.4 The curtain condition (C6) [P, Lean: part of `exists_survivor`].** Let the letter at
position i be a. Suppose the next k ≥ 1 letters (cyclically) are perpendicular to a, the letter
after them is rev(a), and k + 2 ≤ n. Then one of the points v_{i+j} − a, 2 ≤ j ≤ k, is a vertex.

*Proof.* Suppose not. Rotate so that i = 0; this does not change membership of points in the
vertex set up to translation. The letters are then a, s_1, …, s_k, rev(a), …

For t = 1, …, k − 1, apply the corner flip (Lemma 2.2) at vertex t of the current word. Each flip
moves the letter a one place to the right. After t flips the walk is

  v_0, v_2 − a, v_3 − a, …, v_{t+1} − a, v_{t+1}, v_{t+2}, …

The flip number t + 1 is at the vertex v_{t+1}. Its neighbours are v_{t+1} − a and v_{t+2}, which
lie on different axes, and its new point is v_{t+2} − a. That point is not a vertex of the current
word:
* it is not an original vertex, by assumption, since 2 ≤ t + 2 ≤ k;
* it is not one of the new points v_j − a with j ≤ t + 1, because the v_j are distinct.

So every flip is valid and stays in T.

After the k − 1 flips the letters at positions k − 1, k, k + 1 are a, s_k, rev(a), with a ⊥ s_k.
Lemma 2.3 (n = m ≥ 6) removes this U-turn and gives a word of T of length m − 2, contradicting the
minimality of m. For k = 1 no flips are needed. ∎

**4.5 The corner conditions (C7) [P, Lean].** Let 1 ≤ i < n, p = w_{i−1}, d = w_i.
1. If p = u and d is horizontal, then v_{i−1} + unit(d) is a vertex.
2. If d = d (down) and p is horizontal, then v_{i+1} − unit(p) is a vertex.
3. If p = n and d ∈ {e, w}, then v_{i−1} + unit(d) is a vertex.
4. If d = s and p ∈ {e, w}, then v_{i+1} − unit(p) is a vertex.

*Proof.* In each case the named point is v′ = v_{i−1} + v_{i+1} − v_i, the new point of the flip
at vertex i. If it were not a vertex, that flip (Lemma 2.2) would give w′ ∈ T with the same length
and the same multiset of letters, so w′ ∈ W, with v_i replaced by v′.
* Case 1: z(v′) = z(v_{i−1}) = z(v_i) − 1.
* Case 2: z(v′) = z(v_{i+1}) = z(v_i) − 1.

  In both cases v_i is not a lowest vertex (a neighbour is lower), and v′ is not lower than a
  vertex of w. So z_min is unchanged and Ψ(w′) = Ψ(w) − 1, contradicting the choice of w*.
* Cases 3, 4: z(v′) = z(v_i), so Ψ(w′) = Ψ(w), and y(v′) = y(v_i) − 1 with y_min unchanged by the
  same argument. So Ψ₂(w′) = Ψ₂(w) − 1, contradicting the choice of w*. ∎

**Theorem 4.6 [P, Lean: `exists_survivor`].** If T(w₀) holds, there is a word w with T(w),
|w| ≤ |w₀|, and either |w| = 4 or `Survive(w)`. Here Survive means:

| condition | statement |
|---|---|
| C1, C2 | w is a polygon word |
| C3 | v_1, …, v_{n−1} are greater than 0 in (z, y, x) order |
| C4 | w_0 < rev(w_{n−1}) |
| C5 | #_z ≤ #_y ≤ #_x |
| C6 | the curtain condition, for every cyclic position |
| C7 | the four corner conditions at v_1, …, v_{n−1} |

*Proof.* §4.1–4.5. C5 holds because w ∈ W. ∎

---------------------------------------------------------------------------------------------------

## 5. The search outputs every word with Survive

The program is `Len52.Search.searchPart N 9 M r` (Lean, Search.lean). It is the same algorithm as
`research/exact/enum.cpp` run with `-tourcap 0 -nomst -noreduce`: the node counts agree exactly at
every length tried (§8). It runs a depth-first search over walks from the origin, extending a prefix
by the letters 0, …, 5 in turn and discarding an extension when one of the tests below fails. When
the walk closes after N steps, the word is output if the final tests pass.

**Theorem 5.1 [P, Lean: `search_complete`, in progress].** Let w satisfy Survive with
|w| = N ≤ 34. Let κ(w) be the key of its prefix of length 9 (the base-6 number, mod M; any value if
N ≤ 9). Then w is in the output of `searchPart N 9 M κ(w)`. Hence w is in the union of the outputs
of the parts r = 0, …, M − 1.

The proof shows that no test ever discards a prefix of w. Fix such a w, with vertices v_j. At the
moment the search extends the prefix w_0 … w_{i−1} by the letter d = w_i, it holds:
* the occupied set O = {v_0, …, v_i};
* the head v_i, and R = N − i, the number of steps left including this one;
* the letter counts per axis;
* for each axis, the last and first letters on it;
* a list Π of pending obligations.

**The box.** Every vertex satisfies |v_j|₁ ≤ min(j, N − j) ≤ 17. So every point the tests look at
(vertices, vertices ± a unit vector, their neighbours) lies in the packed grid
|x|, |y| ≤ 31, −3 ≤ z ≤ 28, where packing is injective. The set A of *allowed* points is: greater
than 0 in (z, y, x) order, |x|, |y| ≤ 24, z ≤ 24. By C3 every vertex other than v_0 is in A.

**Tests on the letter d = w_i, and why each passes for w.**

* **S1.** d ≠ rev(w_{i−1}). Otherwise v_{i+1} = v_{i−1} (if i + 1 = N, then v_{i−1} = v_0 with
  0 < i − 1), against C2.
* **S2.** d ≠ rev(w_{i−2}) for i ≥ 2.
  - If w_{i−1} is on the axis of d, then w_{i−1} = d or rev(d), and either way one of S1 at i or
    i − 1 fails.
  - Otherwise w_{i−2}, w_{i−1}, w_i is a curtain with k = 1, which C6 forbids: it would need a
    j with 2 ≤ j ≤ 1.
* **Last step (R = 1).**
  - **S3**: v_i + unit(d) = 0, which is C1.
  - **S4**: rev(d) > w_0, which is C4.
* **Other steps (R ≥ 2).**
  - **S5** v_{i+1} ∉ O: C2.
  - **S6** v_{i+1} ∈ A: C3 and the box.
  - **S7** |v_{i+1}|₁ ≤ R − 1: the remaining R − 1 unit steps lead from v_{i+1} to v_N = 0.
  - **S8**, with c′ the counts after the step:
    + 2·max(c′_y, c′_z) + c′_z ≤ N;
    + c′_z ≤ c′_y + (R − 1);
    + c′_y ≤ c′_x + (R − 1).

    The final counts satisfy #_z ≤ #_y ≤ #_x and #_x + #_y + #_z = N, so 2#_y + #_z ≤ N. Each final
    count is at least the current one and at most the current one plus R − 1. These give the three
    inequalities.

**Obligations.** After the step the program updates Π.
1. **Removal.** It removes every obligation that has the new head v_{i+1} among its sites.
2. **Curtain.** If the last earlier letter on the axis of d is at index j and equals rev(d) = a,
   the letters j + 1, …, i − 1 are perpendicular to a, and k = i − j − 1 ≥ 1 by S1. The program
   forms the sites v_{j+t} − a, 2 ≤ t ≤ k.
   - If one is occupied, nothing is added.
   - Otherwise the sites in A form a new obligation.
   - If none is in A, the prefix is discarded (**S9**).
3. **Corner.** If (w_{i−1}, d) is one of the four corner patterns of C7, the point v′ of §4.5 is
   formed.
   - If occupied, nothing is added.
   - If not in A, the prefix is discarded (**S10**).
   - Otherwise the obligation [v′] is added.

**Invariant (I).** Every obligation in Π contains a site that is a vertex v_m of w with
i + 2 ≤ m ≤ N − 1.

*Proof by induction on i.*
* A new curtain obligation comes from an instance of C6 at position j, which supplies a site that
  is a vertex of w. That vertex is not in O ∪ {v_{i+1}}, otherwise nothing would have been added.
  So it is v_m with m ≥ i + 2 and m ≤ N − 1, it is in A, and so it is in the list. The same
  argument shows S9 never discards a prefix of w.
* Corner obligations: the same, with C7 (so S10 passes too).
* An old obligation had a site v_m with m ≥ i + 1. If m = i + 1 it was just removed. ∎

* **S11.** Every obligation in Π has a site s with |v_{i+1} − s|₁ + |s|₁ ≤ R − 1, and at least two of
  the six neighbours of s are the head v_{i+1}, the origin, or free and in A.

  For w, take s = v_m from (I). The walk of w goes v_{i+1} → v_m in m − i − 1 steps and v_m → v_N = 0
  in N − m steps, which gives the distance bound. The neighbours v_{m−1} and v_{m+1} (v_N = v_0)
  are distinct. Each is the head (m − 1 = i + 1), the origin (m + 1 = N), or a later vertex, which
  is free and in A.
* **S12.** If |Π| ≥ 2: Σ over the axes q of min(a₁, a₂) ≤ R − 1, where
  - c is the head's q-coordinate;
  - [l, h] is the smallest interval containing c, 0 and the q-coordinates of the sites of
    one-site obligations;
  - a₁ = (c − l) + (h − l) + h and a₂ = (h − c) + (h − l) − l.

  For w these sites are later vertices (I). The rest of the walk is a sequence of R − 1 unit steps
  from v_{i+1} to 0 that visits all of them. On axis q its coordinate starts at c, ends at 0, and
  takes the values l and h, in one order or the other. So the number of q-steps is at least a₁ or
  at least a₂, and the q-steps add up to R − 1.
* **Closing step.** At the last step (R − 1 = 0), S11 cannot hold for any obligation: its site
  would be the origin, which is occupied. For w, (I) gives Π = ∅ because no later vertices remain,
  so nothing is discarded.
* **Final tests (L1–L3).**
  - **L1**: w_0 ≠ rev(w_{N−2}) and w_1 ≠ rev(w_{N−1}). These are S2 across the root.
  - **L2**: for each axis whose last and first letters are opposite, the wrap-around curtain has
    an occupied site. This is C6 at the last letter on that axis, and k ≥ 1 there by C2.
  - **L3**: C5.
* **Parts.** At depth 9 the program continues only if the key of the prefix is ≡ r (mod M). For
  r = κ(w) this holds along w.

So every test passes along w, and w is output. ∎

The proof uses only C1–C7. It does not use the plane-crossing lemma, the arc lemma or primeness of
5_2; those were used in the earlier, faster runs (PROOF.md §2a–2b) and are **not** part of this
proof.

---------------------------------------------------------------------------------------------------

## 6. Fox 7-colourings

**Diagrams.** Fix D = (D_x, D_y, D_z) ∈ ℤ³ with no zero coordinate. Project by
π(x, y, z) = (D_z x − D_x z, D_z y − D_y z), whose kernel is ℝD, and call h(p) = D·p the height.

The projection of a polygon word is **regular** (Lean: `diagram D w = some cs`) when:
* no edge maps to a point;
* edges sharing a vertex have images meeting only at that vertex's image;
* images of edges sharing no vertex are disjoint or cross in a single point interior to both, at
  different heights;
* no two crossing points coincide.

These are exactly the conditions of a regular projection: finitely many multiple points, all of
them transverse double points, and no vertex mapped onto a double point [T: Burde–Zieschang,
*Knots*, 2nd ed. (de Gruyter 2003), Def. 1.11]. Here π is a linear map with kernel ℝD followed by
no further change, so it is the orthogonal projection along D composed with a linear isomorphism of
the plane. An orientation-reversing isomorphism turns the diagram into its mirror image, which by
Theorem 6.1 does not change the number of colourings. At a crossing the strand of greater height
D·p, the one nearer a viewer far out along +D, is the over-strand.

**Arcs and colourings.** Walking along the polygon from v_0, sort the under-passages
u_0 < … < u_{c−1}. Arc e runs from u_e to u_{e+1} (mod c). A *Fox 7-colouring* gives each arc an
element of ℤ/7 so that at every crossing 2·(over-arc) ≡ (incoming under-arc) + (outgoing under-arc).
Constant colourings always exist. A diagram with c = 0 has only those. (Lean: `foxRows`,
`HasNontrivialColoring`.)

**Theorem 6.1 [T].** The number c₇(K) of Fox 7-colourings of a regular diagram of a knot K does not
depend on the diagram, and c₇(K*) = c₇(K).

*Proof.* Two regular diagrams of equivalent polygonal knots, projected to the same plane, are
related by planar isotopy and finitely many Reidemeister moves R1, R2, R3 [T: Reidemeister,
"Elementare Begründung der Knotentheorie", Abh. Math. Sem. Univ. Hamburg 5 (1927) 24–32;
Burde–Zieschang, 2nd ed., Def. 1.13 and Prop. 1.14]. (The numbering of Burde–Zieschang was taken
from lecture notes based on that edition and should be checked against the book.)

Diagrams of the same knot in different directions D are covered by first rotating the knot, which
is an isotopy. It is therefore enough to check that each move induces a bijection between the
colouring sets. A move changes the diagram only inside a disc, and the Fox equations do not depend
on orientations or crossing signs, only on which strand is over.

* **Planar isotopy** does not change arcs, crossings or which strand is over.
* **R1** (a kink). One crossing, whose over-strand lies on the same arc as one of its two
  under-arcs, a or b. Its equation 2a ≡ a + b forces b ≡ a. So the colourings of the diagram with
  the kink correspond bijectively to those without it, where a and b are one arc.
* **R2** (strand X over strand Y twice). Y is cut into y₁, y₂, y₃. The equations 2x ≡ y₁ + y₂ and
  2x ≡ y₂ + y₃ give y₂ ≡ 2x − y₁ and y₃ ≡ y₁. So the colourings correspond bijectively to those of
  the diagram where Y is one arc y₁.
* **R3**. Every R3 disc has a top strand T over the other two, a middle strand M over the bottom
  strand B, and B under both. Colour the incoming ends t, m, b.
  - Before the move (M crosses B, then T crosses both): B becomes 2m − b, M becomes 2t − m, then B
    becomes 2t − (2m − b) = 2t − 2m + b.
  - After it (T crosses both, then M crosses B): B becomes 2t − b, M becomes 2t − m, then B becomes
    2(2t − m) − (2t − b) = 2t − 2m + b.

  Outgoing colours agree and the inner arcs are determined, so the colourings correspond.

For the mirror image, reflect the plane of the diagram: over/under and all equations are unchanged,
and the result is a diagram of K*. ∎

**Lemma 6.2 [P].** c₇(5_2) = 49. In particular every regular diagram of a knot of type 5_2 or
5_2* has a non-constant Fox 7-colouring.

*Proof.* By Theorem 6.1 any one diagram will do. Take the 5-crossing diagram of §9, which is the
standard diagram. Its Fox matrix, with rows in the order of Lean's `foxRows` and columns the arcs
0–4, is

| row | arc 0 | arc 1 | arc 2 | arc 3 | arc 4 |
|---|---|---|---|---|---|
| 1 | −1 | 2 | 0 | 0 | −1 |
| 2 | 2 | 0 | −1 | −1 | 0 |
| 3 | −1 | −1 | 0 | 2 | 0 |
| 4 | 0 | −1 | −1 | 0 | 2 |
| 5 | 0 | 0 | 2 | −1 | −1 |

* x = (0, 1, 3, 4, 2) is a colouring. The five products are 0, −7, 7, 0, 0, all ≡ 0 mod 7.
* The constant vector (1, 1, 1, 1, 1) is a colouring, and it is independent of x. So the kernel
  mod 7 has dimension ≥ 2 and the rank is ≤ 3.
* The minor on rows 1–3 and columns 0–2 is det[[−1,2,0],[2,0,−1],[−1,−1,0]] = 3 ≢ 0 (mod 7). So
  the rank is ≥ 3.

Hence the rank is 3, and there are 7^{5−3} = 49 colourings, of which 7 are constant.
[Lean: `w52_coloring` checks the colouring x in the kernel.] ∎

This is the hypothesis `TopHyp T` of the Lean theorem.

---------------------------------------------------------------------------------------------------

## 7. Certificates that a diagram has only constant colourings

For an output word w the program `colorCheck` (Lean, Coloring.lean) proceeds as follows.
* It finds a direction D from a fixed list for which the projection is regular.
* It builds the c × c Fox matrix F mod 7.
* It computes, by unchecked elimination, a matrix L with c − 1 rows such that row k of L·F is
  e_k − e_0 mod 7. It then **checks** this identity.

If x is a colouring, then F x ≡ 0, so (L F) x ≡ 0, so x_k ≡ x_0 for all k: x is constant.

**Lemma 7.1 [P, Lean: `colorCheck_sound`].** colorCheck w = true ⇒ some regular diagram of |w| has
only constant 7-colourings.

**Unit squares.** All 24 polygon words of length 4 have regular projections with 0 crossings, so
only constant colourings [Lean: kernel-checked, `square_ok`].

**Corollary 7.2.** If colorCheck w = true, then T(w) is false: by Lemma 6.2 a 5_2 or 5_2* polygon
has a non-constant colouring in every regular diagram.

---------------------------------------------------------------------------------------------------

## 8. The computation [C]

For every even N with 4 ≤ N ≤ 34 and every part r < M_N, every word in the output of
`searchPart N 9 M_N r` passes colorCheck (Lean: `CompCert`).

Commands, results and logs: `research/exact/out/lean/` (filled in by the runs; table in §8.1 when
complete). Parts for N ≥ 30 run on GitHub Actions (`.github/workflows/lean-enum.yml`), N ≤ 28 in
the container (`lean/run_local.sh`). Every log records the commit, the node count and the time.

**8.1 Results.** (to be completed when the runs finish)

**8.2 Independent cross-checks** (not needed for the proof, they test it):
* (a) The C++ program in cross-check mode gives identical node counts (N ≤ 24 so far) and the same
  set of output words (union over parts), for every N.
* (b) For every output word, an independent Python implementation (`formal/projections.py`) of
  the projection and the colouring count gives 7 colourings. The earlier, faster runs with more
  pruning identified the same words by Reidemeister simplification as 0_1, 3_1, 4_1, 5_1, none of
  determinant divisible by 7.
* (c) End-to-end tests of the search with known counts: the shortest trefoils (3328 polygons, 75
  classes, n = 24), 4_1 (3648, n = 30), 5_1 (6672, n = 34) and 5_2 (114 912, n = 36) are rebuilt
  from the outputs by flip closure. A missing flip class would show as a smaller number.

---------------------------------------------------------------------------------------------------

## 9. The 36-edge 5_2 (upper bound)

w₃₆ = `eeennuwwwwssseennwuueedddnnuuswsswdd` (36 letters) is a polygon word [Lean: `decide`]. With
D = (1, −19, 40) its projection is regular with 5 crossings, and its PD code is

  [[10,3,1,4], [6,1,7,2], [2,7,3,8], [4,9,5,10], [8,5,9,6]].

Relabelling the edges along the orientation, possibly reversed, and taking the mirror image turns
it into the standard code `[[1,5,2,4],[3,9,4,8],[5,1,6,10],[7,3,8,2],[9,7,10,6]]` of 5_2
(`formal/pd_certificate.py`, which also shows the code of 5_1 does not match). A PD code determines
the diagram up to homeomorphism of S², so |w₃₆| has type 5_2 or 5_2*, and Len(5_2) ≤ 36.
Independently, SnapPy reads the PD code as the manifold m015, the complement of 5_2. Its Fox matrix
mod 7 (rows from Lean's `foxRows`):

  [−1, 2, 0, 0, −1], [2, 0, −1, −1, 0], [−1, −1, 0, 2, 0], [0, −1, −1, 0, 2], [0, 0, 2, −1, −1]

has rank 3 mod 7 (Lemma 6.2). That gives 49 colourings, for example x = (0, 1, 3, 4, 2).

---------------------------------------------------------------------------------------------------

## 10. What is checked by the Lean kernel

| statement | Lean name | status |
|---|---|---|
| definitions (polygon words, Survive, moves, KnotClass, diagrams, colourings) | Spec.lean, Diagram.lean | read by a human: they are the statement |
| parity, normal form (Thm 4.6) | `isPolygon_length_even`, `exists_survivor` | (in progress) |
| completeness of the search (Thm 5.1) | `search_complete` | (in progress) |
| colouring certificates (Lemma 7.1), unit squares | `colorCheck_sound`, `square_ok` | (in progress) |
| main theorem: KnotClass T ∧ TopHyp T ∧ CompCert ⇒ ∀ w, T w → 36 ≤ \|w\| | `no_short_5_2` | (in progress) |
| w₃₆ is a polygon word with a non-constant colouring | `w36_*` | (in progress) |

`#print axioms` for each: only `propext`, `Classical.choice`, `Quot.sound`.

---------------------------------------------------------------------------------------------------

## 11. What a reader has to trust, and why it is enough

1. **The definitions** in Spec.lean and Diagram.lean say what §1 and §6 say. They are short, and
   §8.2(b) compares them with independent code on every output word.
2. **Corollary 2.5 and Lemma 6.2** (the hypotheses KnotClass T and TopHyp T). They are proved
   above from: Δ-moves preserve knot type, rigid motions are isotopies or mirrors, Reidemeister's
   theorem, and invariance of Fox colourings. These are textbook theorems over 90 years old.
3. **CompCert**, a finite statement about the program in Search.lean and Coloring.lean. It is
   established by running that same program, compiled by the Lean 4.25.0 compiler, on every part,
   with the logs kept. This is the usual trust model for verified programs that are executed: the
   program's correctness is kernel-checked, while its execution trusts the compiler and the
   hardware. It is backed by §8.2(a), a separate implementation in C++ that agrees node for node.
4. **The Lean kernel.**

Nothing else is assumed. In particular:
* no pruning rule is taken on trust: each is a theorem about Survive (§5), and Survive is a theorem
  about any shortest 5_2 polygon after the normal-form choice (§4);
* the skipped branches of the search are exactly the prefixes that no word with Survive has, so a
  5_2 polygon of length ≤ 34 cannot be hiding in them.
