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

*Proof.* Two distinct unit lattice segments meet in at most one common endpoint:
* if they are perpendicular, the intersection point has, on each segment's axis, the integer value
  of the other segment, so it is an endpoint of both;
* if they are parallel but not collinear, they are disjoint;
* if they are collinear, two unit segments between consecutive integers overlap only when they are
  equal, and otherwise meet at most in a shared endpoint.

Segment i has endpoints v_i and v_{i+1}.
These sets are distinct for i ≠ j, because the v_i are distinct and n ≥ 3. Segments i and j share
an endpoint only if {v_i, v_{i+1}} ∩ {v_j, v_{j+1}} ≠ ∅, which by distinctness means j = i ± 1
(mod n). So |w| is a cycle of n segments that meet only consecutively, at single points. ∎

A *lattice polygon* is any set of this form or a translate of one. Every lattice polygon with n
edges is the translate of |w| for some polygon word w of length n: start at any vertex and read the
steps.

**Knot types.** A knot is a tame simple closed curve in ℝ³; here all knots are polygonal. Two
knots are *equivalent* (have the same knot type) if there is an orientation-preserving
homeomorphism of ℝ³ carrying one onto the other. For polygonal knots this is the same as ambient
isotopy, and the same as being related by finitely many Δ-moves [T: Burde–Zieschang, *Knots*,
Ch. 1; Reidemeister, *Knotentheorie* (1932), Ch. I].

A **Δ-move** replaces one edge [a, b] of a polygonal knot K by the two edges [a, c], [c, b], or the
reverse. Here a, b, c are not collinear, and the closed triangle abc meets K only in [a, b]
(resp. in [a, c] ∪ [c, b]).

The proof uses exactly three facts from the topology of knots, each a classical theorem.
* **(E1)** A Δ-move does not change the knot type. This is elementary: the triangle has a
  neighbourhood that meets K in a single arc, and a homeomorphism supported there, isotopic to the
  identity, pushes one side of the triangle onto the other two.
* **(E2)** The Wirtinger presentation of the knot group, read off a regular diagram (§6).
* **(E3)** Two knot diagrams with the same PD code represent the same knot up to mirror image
  (§9). It is used only to identify K₅₂ with the 5_2 of the tables.

The equivalence "homeomorphism ⇔ Δ-moves ⇔ Reidemeister moves" is not used in its hard direction.

Knot types are taken as **unoriented**. The **mirror image** K* of K is its image under a
reflection of ℝ³.

**Len.** For a knot type K, Len(K) is the least n such that some lattice polygon with n edges has
type K.

**The knot.** Let w₃₆ = `eeennuwwwwssseennwuueedddnnuuswsswdd` (36 letters, a polygon word: §9),
and let **K₅₂** be the knot type of |w₃₆|.

§9 shows that K₅₂ is the knot called 5_2 in the knot tables (or its mirror image): the diagram of
|w₃₆| along (1, −19, 40) has the PD code that KnotInfo lists for 5_2. This identification is the only
place where (E3) is used. Everything else is about K₅₂ itself, so the statement Len(K₅₂) = 36 needs
only (E1) and (E2).

A knot and its mirror image have the same Len: a reflection of ℤ³ maps lattice polygons to lattice
polygons with the same number of edges. So the theorem is about the pair 𝒦 = {K₅₂, K₅₂*}.

**The class T.** T(w) holds when w is a polygon word and the knot type of |w| lies in 𝒦.
* The theorem says T(w) ⇒ |w| ≥ 36.
* T(w₃₆) holds by definition, which gives Len(K₅₂) ≤ 36.

---------------------------------------------------------------------------------------------------

## 2. Four moves that do not change the knot type

**Lemma 2.1 (segment and square) [P].** Let Q be a closed unit lattice square, i.e. the convex
hull of q, q+a, q+a+b, q+b with q ∈ ℤ³ and a ⊥ b unit lattice vectors. Let E be a closed unit
lattice segment. Then E ∩ Q is empty, a corner of Q, or a side of Q.

*Proof.* Let H be the plane of Q.
* If E is not parallel to H, it is perpendicular to H, since lattice directions are coordinate
  axes. E runs along the normal axis between two consecutive integers, and H lies at an integer
  level of that axis, so E ∩ H is empty or an endpoint of E, which is a lattice point. The only
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

The flip number t + 1 is at the vertex v_{t+1}. The two edges there have the letters a and
s_{t+1}, which lie on different axes. The neighbours are v_{t+1} − a and v_{t+2}, and the new point
is v_{t+1} − a + v_{t+2} − v_{t+1} = v_{t+2} − a. That point is not a vertex of the current
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
at vertex i. (In cases 2 and 4, v_{i+1} − unit(p) = v_i + unit(d) − unit(p) = v_{i−1} + unit(d).) If it were not a vertex, that flip (Lemma 2.2) would give w′ ∈ T with the same length
and the same multiset of letters, so w′ ∈ W, with v_i replaced by v′.
* Case 1: z(v′) = z(v_{i−1}) = z(v_i) − 1.
* Case 2: z(v′) = z(v_{i+1}) = z(v_i) − 1.

  In both cases v_i is not a lowest vertex (a neighbour is lower), and v′ has the height of a
  vertex of w (v_{i−1} or v_{i+1}), so it is not below z_min. So z_min is unchanged and Ψ(w′) = Ψ(w) − 1, contradicting the choice of w*.
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
`research/exact/enum.cpp` run with `-tourcap 0 -nomst -noreduce`: for unsplit runs (one part) the
node counts agree exactly at every length tried, and the output words agree at every length (§8).
(Split runs are not comparable node by node: each Lean part re-counts the tree above the split
depth.) It runs a depth-first search over walks from the origin, extending a prefix
by the letters 0, …, 5 in turn and discarding an extension when one of the tests below fails. When
the walk closes after N steps, the word is output if the final tests pass.

**Theorem 5.1 [P, Lean: `search_complete`].** Let w satisfy Survive with
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

**The first step (S0).** The top level tries the first letters 0, …, 5 and skips a first letter
when v_0 + unit(d) is not in A, or when d = u (4). For w: v_1 is in A by C3. And w_0 ≠ u, because C4
gives w_0 < rev(w_{N−1}). If w_0 = u, then rev(w_{N−1}) = 5, so w_{N−1} = u, and v_{N−1} = −unit(u)
would have z = −1, contradicting C3.

**Tests on the letter d = w_i (i ≥ 1), and why each passes for w.**

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
*Knots*, 2nd ed. (de Gruyter 2003), Ch. 1]. Here π is a linear map with kernel ℝD followed by
no further change, so it is the orthogonal projection along D composed with a linear isomorphism of
the plane. An orientation-reversing isomorphism turns the diagram into its mirror image, which by
Theorem 6.1 does not change the number of colourings. At a crossing the strand of greater height
D·p, the one nearer a viewer far out along +D, is the over-strand.

**Arcs and colourings.** Walking along the polygon from v_0, sort the under-passages
u_0 < … < u_{c−1}. Arc e runs from u_e to u_{e+1} (mod c). A *Fox 7-colouring* gives each arc an
element of ℤ/7 so that at every crossing 2·(over-arc) ≡ (incoming under-arc) + (outgoing under-arc).
Constant colourings always exist. A diagram with c = 0 has only those. (Lean: `foxRows`,
`HasNontrivialColoring`.)

**Theorem 6.1 [P from (E2)].** The number c₇(D) of Fox 7-colourings of a regular diagram D of a knot
K depends only on the knot group G(K) = π₁(ℝ³ ∖ K). In particular it is the same for all regular
diagrams of K and of K*.

*Proof.*
1. **A group-theoretic count.** Let D₇ be the dihedral group of order 14, acting on ℤ/7 by the
   maps t ↦ ±t + c. Its reflections are r_a(t) = 2a − t, a ∈ ℤ/7, and they are pairwise distinct.
   Let σ: D₇ → ℤ/2 send reflections to 1 and rotations to 0. Let α: G → ℤ/2 be the abelianisation
   G → H₁(ℝ³ ∖ K) ≅ ℤ followed by reduction mod 2.
   * H₁ ≅ ℤ, generated by a meridian, follows from (E2) by abelianising: all Wirtinger generators
     become equal.
   * Since H₁ ≅ ℤ, α is the unique surjection G → ℤ/2, so every isomorphism of knot groups carries
     α to α. Put

   Hom*(G, D₇) = {φ : G → D₇ homomorphism with σ∘φ = α}.

   Its size depends only on the group G. An equivalence of knots, and also a reflection of ℝ³,
   restricts to a homeomorphism of the complements, which induces an isomorphism of the knot
   groups. So |Hom*(G, D₇)| is the same for K, for every knot equivalent to K, and for K*.
2. **The count equals the number of Fox colourings.** Orient K and take a regular diagram with
   arcs x₁, …, x_c.
   - If c = 0, then G ≅ ℤ, and Hom*(G, D₇) consists of the 7 maps sending the generator to a
     reflection. That is the same number as the colourings of a diagram with one arc.
   - If c ≥ 1, the Wirtinger presentation [T (E2): Burde–Zieschang, *Knots*, Ch. 3, "Wirtinger
     presentation"; Rolfsen, *Knots and Links*, Ch. 3 §D; Lickorish, *An Introduction to Knot
     Theory*, Ch. 11] is

       G = ⟨x₁, …, x_c | x_{out} = x_{over}^{ε} x_{in} x_{over}^{−ε}, one relation per crossing⟩,

     with ε = ±1 the sign of the crossing. Every generator x_i is a meridian, and in H₁ ≅ ℤ all of
     them map to the same generator. So a homomorphism φ: G → D₇ satisfies σ∘φ = α exactly when
     every φ(x_i) is a reflection, say r_{a_i}.
   - Since r_b r_a r_b = r_{2b−a} and r_b^{−1} = r_b, the relation at a crossing holds exactly when
     a_out ≡ 2a_over − a_in, which is the Fox equation 2a_over ≡ a_in + a_out.

   So a ↦ φ with φ(x_i) = r_{a_i} is a bijection from the Fox colourings onto Hom*(G, D₇). ∎

*Second proof (classical, by moves).* Two regular diagrams of equivalent knots in one plane are
related by planar isotopy and Reidemeister moves [T: Reidemeister, "Elementare Begründung der
Knotentheorie", Abh. Math. Sem. Univ. Hamburg 5 (1927) 24–32; Burde–Zieschang Ch. 1]. Each move
gives a bijection of colourings:
* **R1**: the equation 2a ≡ a + b at the kink forces b ≡ a.
* **R2**: if X passes over Y twice, the equations give y₂ ≡ 2x − y₁ and y₃ ≡ y₁.
* **R3**: with T over M over B and incoming colours t, m, b, the outgoing colour of B is
  2t − 2m + b on both sides, and the inner arcs are determined.

For K*, reflect the plane: the equations are unchanged. This proof needs the hard direction of
Reidemeister's theorem; the first proof needs only (E2).

**Lemma 6.2 [P].** Every regular diagram of a knot of type K₅₂ or K₅₂* has a non-constant Fox
7-colouring. Moreover c₇ = 49.

*Proof.* By Theorem 6.1 one diagram suffices. The diagram of |w₃₆| along D = (1, −19, 40) is regular
and has the non-constant colouring (0, 1, 3, 4, 2) [Lean, kernel-checked: `w52_crossings`,
`w52_coloring`]. That proves the first sentence, which is all the Lean hypothesis TopHyp needs.

For the count, it is the same to compute on the standard diagram, which by §9 is the same diagram up
to relabelling and mirror image. It has PD code
X₁[1,5,2,4], X₂[3,9,4,8], X₃[5,1,6,10], X₄[7,3,8,2], X₅[9,7,10,6]. In X[a,b,c,d], a is the
incoming under-edge, c the outgoing under-edge, and b, d lie on the over-strand.
* The under-passages go 1→2, 3→4, 5→6, 7→8 and 9→10. So the arcs are A = {2,3}, B = {4,5},
  C = {6,7}, D = {8,9}, E = {10,1}.
* The over-strands are B at X₁, D at X₂, E at X₃, A at X₄ and C at X₅.
* The Fox equations are

  2B = E + A,  2D = A + B,  2E = B + C,  2A = C + D,  2C = D + E  (mod 7).

Solve: put A = a and B = a + b.
* The first equation gives E = a + 2b.
* The second gives 2D = 2a + b, so D = a + 4b, because 2⁻¹ = 4 mod 7.
* The third gives C = 2E − B = a + 3b.
* The fourth then reads 2a ≡ 2a + 7b ✓, and the fifth reads 2a + 6b ≡ 2a + 6b ✓.

So the colourings are exactly a·(1,1,1,1,1) + b·(0,1,3,4,2) with a, b ∈ ℤ/7, which gives 49
colourings, 7 of them constant. (A brute-force count over all 7⁵ assignments gives the same 49; the
36-edge diagram of §9 has the same Fox matrix up to relabelling. Lean: `w52_coloring` checks the
non-constant colouring (0,1,3,4,2) of that diagram.) ∎

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

**What has to be computed.** By `compCert_of_checks` (Lean, Cert.lean), CompCert holds as soon as
`checkPart n r = true` for every n in `lengths` = {4, 6, …, 34} and every r < M_n, where

| n | M_n (`parts n`) |
|---|---|
| 4, …, 26 | 1 |
| 28 | 2 |
| 30 | 64 |
| 32 | 256 |
| 34 | 1024 |

and checkPart n r = (searchPart n 9 M_n r).out.all colorCheck. Each of these is a closed Boolean
term.

**How it is computed.** The executable `checkpart n r` (CheckMain.lean) evaluates exactly that term
(`checkPart_eq`). It prints the returned words, then a final line

  RESULT n=… r=… m=M_n nodes=… words=K ok=B

and exits with status 0 if and only if B = true.

A part counts as **accepted** only if all of the following hold:
* its log records exit status 0;
* the output ends with the RESULT line for that (n, r, M_n), with ok=true and exactly K word lines
  before it;
* the output's SHA-256 matches the one logged when it was written;
* the logged commit has every source file of the executable byte-identical to the current one:
  Spec, Diagram, Search, Coloring, Cert, CheckMain, lakefile.toml, lean-toolchain.

`formal/verify_comp.py` checks these conditions for all 1358 parts and writes
`out/lean/COMPCERT.txt`.

Where the parts run:
* In the container: n ≤ 30, and parts 128–255 of n = 32, via `lean/run_local.sh check n M r…`. The
  script refuses to run with uncommitted sources, rebuilds first, and logs a hash of the sources
  (checked again after every part).
* On GitHub Actions: parts 0–127 of n = 32 (run 43770731268) and all of n = 34 (run 43735396072), via
  `.github/workflows/lean-enum.yml`, engine `check`. Each job builds from a clean checkout of the
  commit, using the official Lean 4.25.0 release. The parts were committed by a github-actions[bot]
  commit naming the run. The runs' own collect jobs could not push (the token was read-only), so
  `.github/workflows/lean-collect.yml` (runs 43863149806 and 43864508106) downloaded the jobs'
  artifacts unchanged and merged them with the same merge step.

**8.1 Results.** `formal/verify_comp.py` accepts all 1358 parts: **CompCert holds** (out/lean/COMPCERT.txt).

| n | parts | output words (Survive, all with colorCheck = true) | search nodes |
|---|---|---|---|
| 4–22 | 1 each | 0 | 37 429 179 in total |
| 24 | 1 | 56 | 181 235 380 |
| 26 | 1 | 168 | 1 078 116 768 |
| 28 | 2 | 712 | 6 772 583 100 |
| 30 | 64 | 2 782 | 43 638 057 581 |
| 32 | 256 | 7 212 | 283 692 993 804 |
| 34 | 1024 | 22 070 | 1 929 898 505 964 |
| total | 1358 | 33 000 | 2 265 298 921 776 |

So every word of length ≤ 34 that satisfies Survive has exactly 7 Fox 7-colourings (c₇ = 7), while
c₇(5₂) = 49. By `no_short`, no polygon of length ≤ 34 has the knot type of the 36-step polygon w₃₆.

**8.2 Cross-checks.** These are not needed for the proof; they test it.
* (a) **C++ program.** The C++ program in cross-check mode (`enum.cpp -tourcap 0 -nomst -noreduce`)
  is a separate implementation of the same algorithm. For unsplit runs it gives identical node
  counts, and for every length the same set of words: every n = 4, …, 34 (out/lean/COMPCERT.txt).
* (b) **Python colouring count.** An independent Python projection and colouring count
  (`formal/projections.py`) finds exactly 7 colourings for every output word. (It was written by
  the same author as Diagram.lean, so it tests the implementation rather than the definition.)
* (c) **Survive checker.** An independent Python implementation of Survive
  (`formal/crosscheck/survive.py`, written by the referee from Spec.lean alone) accepts every
  output word of the accepted parts.
* (d) **Trefoil census.** The referee's completeness test on trefoils: the flip and symmetry
  closure of the 50 trefoil outputs at n = 24 is the full set of 3328 shortest trefoils [JvRR11].
  Every word of it that satisfies Survive is among the outputs.
* (e) **Earlier runs.** The earlier, more strongly pruned runs (with the plane-crossing lemma;
  PROOF.md) produced a subset of these words. Reidemeister simplification identified those as
  0_1, 3_1, 4_1, 5_1 for n ≤ 34. None of these has determinant divisible by 7, which is consistent
  with (b).
* (f) **Reproduction of GitHub parts.** A random sample of the parts computed on GitHub Actions was
  re-run in the container. Each produced an output byte-identical to the logged one (same
  SHA-256); see out/lean/REPRO.txt.

---------------------------------------------------------------------------------------------------

## 9. The 36-edge polygon, and why K₅₂ is the knot 5_2

w₃₆ = `eeennuwwwwssseennwuueedddnnuuswsswdd` (36 letters). Lean: `w52`, `w52_eq`, `w52_length`,
and `w52_polygon`, a kernel-checked polygon word.

With D = (1, −19, 40) its projection is regular with 5 crossings (`w52_crossings`). Its PD code,
in the convention of §6 Lemma 6.2, is

  [[10,3,1,4], [6,1,7,2], [2,7,3,8], [4,9,5,10], [8,5,9,6]].

The standard code of 5_2 is `[[1,5,2,4],[3,9,4,8],[5,1,6,10],[7,3,8,2],[9,7,10,6]]`. Relabelling
the edges along the orientation, possibly reversed, and taking the mirror image turns our code into
the standard one. This is kernel-checked in Lean (PD.lean):
* `w52_pd_eq`: Lean computes exactly this code from the word;
* `w52_pd`: it is equivalent to `std52`. Under these conventions it is a relabelling of the mirror
  of KnotInfo's diagram (`w52_pd_mirror`).

Controls, also kernel-checked:
* the code of 5_1 does not match (`w52_pd_not51`);
* without the mirror operation, 3_1, 5_1 and 5_2 are not equivalent to their mirror images, and the
  amphichiral 4_1 is (`chirality_controls`).

`formal/pd_certificate.py` is an independent Python version.

**(E3), stated and proved from its ingredients.** *If two regular knot diagrams have PD codes that
differ only by relabelling the edges, possibly after reversing the orientation and possibly after
mirroring, then the two knots are equivalent, possibly after mirroring.*

1. A PD code lists, for each crossing, the four incident edge-ends in counter-clockwise order, and
   says which pair is the under-strand. So it is a rotation system of the connected 4-valent plane
   graph of the diagram, together with the crossing data.
2. A rotation system determines a connected plane graph up to an orientation-preserving
   homeomorphism of S² [T: rotation principle (Heffter–Edmonds); Mohar–Thomassen, *Graphs on
   Surfaces*, Johns Hopkins 2001, §3.2–3.3]. Here that homeomorphism also matches the crossing
   data. If the mirror operation was used, compose with a reflection of S².
3. An orientation-preserving homeomorphism of S² is isotopic to the identity [T: Kneser, [Kne26]; or the
   Alexander trick]. Lifting such an isotopy of diagrams
   gives an isotopy of knots in S³, which may pass an arc over the point at infinity.
4. A knot is determined up to equivalence by any of its diagrams: two knots with the same diagram
   differ by a vertical isotopy. Knot types in S³ and in ℝ³ are the same [T: Burde–Zieschang,
   *Knots*, Ch. 1; Rolfsen, *Knots and Links*, Ch. 1].

Applied to the diagram of |w₃₆| (`w52_pd`) and the KnotInfo diagram of 5_2: K₅₂ is 5_2 or 5_2*. In
either case Len(5_2) = Len(K₅₂).

Independent evidence, not used: SnapPy identifies the complement of the PD code as m015, the
complement of 5_2. By Gordon–Luecke (*J. Amer. Math. Soc.* 2 (1989) 371–415) the complement
determines the knot up to mirror image. And the 49 colourings of this diagram (Lemma 6.2) agree.

---------------------------------------------------------------------------------------------------

## 10. What is checked by the Lean kernel

| statement | Lean name | status |
|---|---|---|
| definitions: polygon words, Survive, moves, KnotClass | Spec.lean | statement (read by a human) |
| definitions: diagrams, Fox equations, colourings, TopHyp | Diagram.lean, Statement.lean | statement |
| definitions: lengths, parts, CompCert, checkPart | Cert.lean | statement |
| programs: search, colour certificate | Search.lean, Coloring.lean | definitions the statement refers to |
| parity; normal form (Thm 4.6) | `isPolygon_length_even`, `exists_survivor` | **proved** |
| colour certificates (Lemma 7.1); unit squares | `colorCheck_sound`, `square_ok` | **proved** |
| CompCert from the per-part Booleans | `compCert_of_checks` | **proved** |
| completeness of the search (Thm 5.1) | `search_complete` (SearchProof.lean, SP/) | **proved** |
| main theorem: KnotClass T ∧ TopHyp T ∧ CompCert ⇒ ∀ w, T w → 36 ≤ \|w\| | `no_short` (Main.lean) | **proved** |
| w₃₆: polygon word of length 36 with a non-constant colouring | `w52_length`, `w52_polygon`, `w52_coloring` | **proved** |
| w₃₆'s diagram has the PD code of 5_2 (up to mirror image); controls | `w52_pd_eq`, `w52_pd`, `w52_pd_not51`, `chirality_controls` | **proved** |

`#print axioms` for every proved theorem: a subset of {propext, Classical.choice, Quot.sound}; the
workflow `lean-proof.yml` rebuilds everything from a clean checkout and prints them. No
`sorry`, no `native_decide`, no `implemented_by` or `extern` anywhere in the sources (checked with
grep).

---------------------------------------------------------------------------------------------------

## 11. What a reader has to trust

1. **The Lean kernel** (Lean 4.25.0), for the theorems of §10.
2. **The statement files** say what §1, §6 and §9 say: Spec.lean, Diagram.lean, Statement.lean,
   Cert.lean, PD.lean (only for the identification K₅₂ = 5_2) and the statement of `no_short`. They
   are short. `diagram` examines every pair of edges (`nonAdjPairs` and the consecutive pairs), so
   it lists every crossing. Cross-checks 8.2(b) and (c) compare
   them with independent code on every output word.
3. **Classical theorems of knot theory.**
   - (E1) Δ-moves are isotopies, and (E2) the Wirtinger presentation. From them, §2 and §6 prove the
     two hypotheses KnotClass T and TopHyp T of `no_short`, for T = the polygons of type K₅₂ or K₅₂*.
   - (E3), from its cited ingredients, only to identify K₅₂ with the 5_2 of the tables (§9).
4. **Execution of 1358 closed Boolean terms** checkPart n r. They were evaluated by code compiled
   from the committed sources: the Lean 4.25.0 compiler, its bundled C compiler with `-O3
   -march=native`, the Lean runtime's primitive operations, and the hardware. The record that the
   evaluation returned `true` is the logs (exit status, output hash, commit). For n ≥ 30 the logs
   come from GitHub Actions, so their provenance rests on GitHub's records of the runs. This is the
   standard trust model for proofs by verified computation that are too large for the kernel. It is
   backed by cross-check 8.2(a). A separate implementation in C++ gives the same words at every
length, and the same node counts wherever the runs are unsplit (n ≤ 26).
Every part's output is deterministic, so anyone can re-run any part and compare its SHA-256 with the
logged one. A random sample of the GitHub parts was re-run in the container this way (§8.2(f)). The
whole computation costs about 450 core-hours.

5. **The acceptance script and git.** `formal/verify_comp.py` (about 150 lines; its rules are
   those of §8) and the git history it reads, for the commits and the github-actions[bot] commits
   that name the runs.

Nothing else is assumed. In particular:
* No pruning rule is taken on trust. Each one is a theorem about Survive (§5, Lean
  `search_complete`).
* Survive is a theorem about a shortest polygon of the class, after the normal-form choice (§4,
  Lean `exists_survivor`).
* The skipped branches of the search are exactly the prefixes that no word with Survive has, so a
  5_2 polygon with at most 34 edges cannot be hiding in them.
* The plane-crossing lemma, the arc lemma and the primality of 5_2 (PROOF.md §2a–2b) are **not**
  used.

---------------------------------------------------------------------------------------------------

## References

* [BZ] G. Burde, H. Zieschang, *Knots*, 2nd ed., de Gruyter Studies in Mathematics 5, 2003.
  Ch. 1 (knots, diagrams, Reidemeister moves), Ch. 3 (the knot group, Wirtinger presentation).
* [Diao93] Y. Diao, "Minimal knotted polygons on the cubic lattice", *J. Knot Theory Ramifications*
  2 (1993) 413–425.
* [Fox62] R. H. Fox, "A quick trip through knot theory", in *Topology of 3-Manifolds and Related
  Topics* (M. K. Fort, ed.), Prentice-Hall 1962, 120–167.
* [GL89] C. McA. Gordon, J. Luecke, "Knots are determined by their complements", *J. Amer. Math.
  Soc.* 2 (1989) 371–415.
* [JvRR11] E. J. Janse van Rensburg, A. Rechnitzer, "Minimal knotted polygons in cubic lattices",
  *J. Stat. Mech.* (2011) P09008.
* [Kne26] H. Kneser, "Die Deformationssätze der einfach zusammenhängenden Flächen", *Math. Z.* 25
  (1926) 362–372.
* [MT01] B. Mohar, C. Thomassen, *Graphs on Surfaces*, Johns Hopkins University Press, 2001.
* [Prz98] J. H. Przytycki, "3-coloring and other elementary invariants of knots", *Banach Center
  Publ.* 42 (1998) 275–295.
* [Rei27] K. Reidemeister, "Elementare Begründung der Knotentheorie", *Abh. Math. Sem. Univ.
  Hamburg* 5 (1927) 24–32.
* [Rol76] D. Rolfsen, *Knots and Links*, Publish or Perish 1976. Ch. 3 §D (Wirtinger presentation),
  App. C (knot table).
* [Sch09] R. Scharein, K. Ishihara, J. Arsuaga, Y. Diao, K. Shimokawa, M. Vazquez, "Bounds for the
  minimum step number of knots in the simple cubic lattice", *J. Phys. A* 42 (2009) 475006.
* KnotInfo: C. Livingston, A. H. Moore, *KnotInfo: Table of Knot Invariants*,
  knotinfo.math.indiana.edu (data read through the Python package `database_knotinfo`,
  15 Nov 2026).
