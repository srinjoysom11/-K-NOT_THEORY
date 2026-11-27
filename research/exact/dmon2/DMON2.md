# DMON2: a second round of DMON ideas, with proofs and first measurements (22 Nov 2026)

Prototype: `enum_x.cpp` (this folder), a copy of `enum_bidir.cpp` from branch `claude/dmon-experiments`
with new flags. Analysis scripts: `orbits.py`, `crank.py`, `rules_lib.py`, `combo.py`.
All runs below: 4-core container, `-alt 4 -stair -tourcap 3 -aotc -aotm` (the production setting of
the n = 40 and n = 42 runs) plus the flags named. "Nodes" are counted exactly as in `enum_bidir`.

## 0. Where the time goes (measured first)

`enum_x 30 ... -rejstats` (n = 30, 127 164 784 nodes) gives the nodes per depth t (steps placed):

| t | 12 | 14 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 24 | 26 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| nodes (millions) | 0.27 | 1.9 | 9.4 | 16.4 | 22.7 | 24.1 | 20.3 | 13.3 | 7.3 | 1.6 | 0.3 |

So the nodes sit in the middle of the tree, 8 to 15 steps before the end. Kills there come mostly from the
axis-count test of D2 (`-aotc`), then from the reach test. At the peak, 90 % of the live nodes have
slack (steps left minus the distance between the two ends of the gap) at least 6. Only 10288 walks close,
so about 99.99 % of the nodes are dead ends that are found only several levels deeper. The tests below
attack this in three ways: a sharper count of the steps still needed on each axis (P1, F2),
new obligations (C1), and conditions that kill at once (F1).

Throughout, w is a shortest word of its knot class in the normal form of the paper: least length m,
sorted axis counts (DMON5), least psi_Z, then least psi_Y, in canonical position (DMON3, DMON4).
"Excess" of a walk = its number of edges minus the Manhattan distance between its end points. The excess
of a walk is at least the excess of any of its sub-walks, since the Manhattan distance is subadditive.

## 1. F1, the face rule (length-decreasing, valid for every shortest polygon)

**Lemma F1.** Let P be a shortest polygon of any knot type, let A be an axis, and let L be the lowest (or
highest) occupied level of P along A. Every sub-arc beta of P whose vertices all lie in L has excess at most 2.

*Proof.* Take A = z and L the lowest level z = z0 (the other cases follow by a lattice symmetry). Let beta
run from v_i to v_j (i < j, j - i < n, so v_i != v_j) and let d = |v_i - v_j|_1. Suppose |beta| >= d + 4.
Let gamma be the path v_i -> v_i - e_z -> (a shortest path in the level z0 - 1) -> v_j - e_z -> v_j, with
d + 2 edges. The level z0 - 1 has no vertex of P, so replacing beta by gamma gives a self-avoiding polygon
P' with |P| - |beta| + d + 2 <= |P| - 2 edges. It has the type of P: (1) push beta down to the arc
beta' = (v_i, v_i - e_z, beta - e_z, v_j - e_z, v_j) across the strip of unit squares between beta and beta - e_z.
That strip meets P only in beta, because the only points of P at heights in [z0 - 1, z0] lie in the level
z0, and a point of the strip in that level is a point of beta. (2) In the closed half-space B = {z <= z0 - 1/2},
the parts of beta' and gamma below z0 - 1/2 are two arcs with the same end points, and the rest of the
polygon does not meet B. Each of them is unknotted in B: it is a lattice path in the level z0 - 1 with two
half-edges up to the boundary of B, so it bounds a vertical strip with its projection to that boundary.
Two unknotted arcs in a ball with the same end points are isotopic relative to the boundary (the fact
already used in the proof of Lemma 3 of PROOF.md). So P' has the type of P and is shorter, a contradiction. []

*Use in the search (`-face`).* By DMON3 the level z = 0 of the root is the lowest level. After each step,
for the maximal run of placed consecutive vertices in z = 0 that ends at the new vertex, if some sub-arc
of the run ending at the new vertex has excess >= 4, discard the walk. This kills at once, with no
completion argument, and often very early: on the n = 38 survivors, the first violation lies within
the first 9 steps in 714 of the 2624 violating words.

## 2. F2, the plane rule (length-decreasing; uses Lemma 3, so prime types, as `-stair`)

**Lemma F2.** If a shortest polygon P has a sub-arc of excess >= 4 inside a lattice plane x_A = c, then P has
a vertex with x_A < c and a vertex with x_A > c.

*Proof.* Otherwise x_A = c is the lowest or the highest occupied level along A, and Lemma F1 applies. []

*Use in the search (`-plane4`).* When the run of placed vertices in the plane x_A = c through the new vertex
contains such a sub-arc, the final polygon occupies the levels c - 1 and c + 1 on axis A; for z and c = 0
this is impossible and the walk is discarded (this is F1). The program widens the range [mn, mx] used by
the plane-crossing debt of `-prime` to contain c - 1 and c + 1. The debt stays a lower bound: every
mid-plane strictly between the final lowest and highest levels is crossed at least twice, and a
mid-plane p + 1/2 with mn < p < mx - 1 has the occupied levels mn and p below it and p + 1 and mx above
it (a connected polygon occupies every level between its extreme levels), so Lemma 3 asks 4 crossings.

## 3. P1, per-plane maximum of debt and travel (a pure bound: output unchanged)

`-aotc` bounds the steps t_A still needed on axis A by the larger of two sums: the travel of the gap walk
on A (head end -> sites -> tail end) and the plane debt cdef[A]. Both are sums over the mid-planes of A,
and the larger of the two can be taken plane by plane.

**Lemma P1.** Let f_p be the number of edges of the missing middle that cross the mid-plane p + 1/2 of
axis A, let owed_p be the debt of that plane (the term of `owed` in `enum_bidir`), and let l <= h be the
least and greatest A-coordinates among the head end (c0), the tail end (ct) and the single sites of the
pending obligations. For the visiting order o in {l before h, h before l} let r_{o,p} be the number of
consecutive pairs in (c0, l, h, ct) (order 1) or (c0, h, l, ct) (order 2) that lie on opposite sides of
the plane. Then t_A = sum_p f_p >= min_o sum_p max(owed_p, r_{o,p}).

*Proof.* f_p >= owed_p is the plane-crossing lemma used by `-prime`, which is a statement about each
plane. The missing middle is a walk from the head end to the tail end that visits a site of every pending
obligation, so it visits a vertex with A-coordinate l and one with h, in some order o. Between two
consecutive visits of the sequence for o, the sub-walk crosses every plane that separates the two
coordinates; these sub-walks have no edge in common. So f_p >= r_{o,p} for the true order o, and
t_A >= sum_p max(owed_p, r_{o,p}) >= the minimum over o. []

## 4. C1, crankshaft obligations (a new DMON; uses the psi normal form)

A **hat** is a stretch of letters u, b, ..., b (k >= 1 times), d with b horizontal, starting at the vertex
P = v_j and ending at Q = P + k b. Rotating the rigid U-shaped arc by 90 degrees about the line PQ moves
its top bar from height z(P) + 1 down to height z(P), beside the base PQ.

**Lemma C1.** In w, for each of the two horizontal directions c perpendicular to b, one of the k + 1
points P + c + t b (0 <= t <= k) is a vertex of w.

*Proof.* Suppose none is. Let w' be w with the stretch u b^k d replaced by c b^k (-c). Its new vertices
are the k + 1 free points, so w' is self-avoiding and has the length of w. *Same type.* Rotate the arc
about the line through P and Q, from direction u to direction c. The set swept by the moving arc is
contained in the box spanned by P, Q, P + u and P + c, at distance at most 1 from the axis PQ. Its
lattice points are only P, Q, the old bar P + u + t b and the new bar P + c + t b: the interior axis
points P + t b (0 < t < k) are at distance 0 and are reached only by the end rungs, which turn about P
and Q, and the points P + t b + u + c are at distance sqrt 2. An edge of w other than the moving arc that
meets the swept set must have a lattice end point in the box: an old bar point already has its two
edges, a new bar point is not a vertex, and an edge along the axis meets the swept set only at its end
point P or Q, which stay fixed. So the rotation is an isotopy. *Lower potential.* The k + 1 moved
vertices go down by 1 and the lowest level does not change (z(P) >= z_min), so psi_Z(w') = psi_Z(w) - (k + 1).
*Still in W.* The counts become c_z - 2 and c_c + 2 on the axis of c. If that axis is x, they are sorted.
If it is y (so b is along x), they are unsorted only if c_y + 2 > c_x, that is c_x = c_y (counts are even),
and then the axis swap x <-> y, a lattice symmetry that keeps the type and psi_Z, sorts them. Either way a
word of W has smaller psi_Z than w, a contradiction. []

*Use in the search (`-crank`).* When a head or tail step completes a hat, add the two obligations (one
per side c); an occupied point satisfies one at once, and if a side has no allowed point the walk is
discarded. The same rotation applied to a horizontal U (rotated down) or to a U with a vertical bar
(moved to smaller y) gives obligations that hold only under a condition on the final counts
(c_z < c_y, resp. c_y > c_z or c_x >= c_y + 4); they are checked at the leaf only (`crank.py`).

## 5. B1, centroid balance (leaf rule; uses the psi normal form)

**Lemma B1.** 2 psi_Z(w) <= n (z_max - z_min) and 2 psi_Y(w) <= n (y_max - y_min). If Step 3 of the normal form
is extended by a third tie-break, least psi_X, then also 2 psi_X(w) <= n (x_max - x_min).

*Proof.* The reflection z -> -z keeps the length, the counts and the type class (a knot class is closed
under the 48 symmetries), and maps psi_Z to n (z_max - z_min) - psi_Z. As w has least psi_Z in W,
psi_Z(w) <= n (z_max - z_min) - psi_Z(w). The reflection y -> -y keeps every z-coordinate, so the reflected
word also has least psi_Z, and the same argument applies to psi_Y. With the third tie-break, the
reflection x -> -x keeps psi_Z and psi_Y. The extension does not affect any earlier lemma: the chosen
word still has least psi_Z, and least psi_Y among those. []

In words: the centre of mass of the vertices lies in the lower half of the bounding box along z and y
(and x with the tie-break). It decides which of the reflected copies of a polygon is kept. The search
finds about 2.8 copies of each polygon at n = 38 (18 945 words in 6 685 symmetry classes).

## 6. Measurements

**Search (nodes / survivors / seconds).** P1 alone leaves the word list unchanged (checked with `cmp` at
n = 30, as a pure bound must). F1, F2 and C1 remove words that are not shortest polygons.

| n | baseline | -aotp | -face -plane4 | -face -plane4 -aotp | + -crank |
|---|---|---|---|---|---|
| 24 | 1 307 348 / 50 | 878 885 / 50 | 1 155 698 / 50 | 728 966 / 50 | 695 768 / 43 |
| 26 | 4 645 901 / 62 | 3 433 786 / 62 | 3 944 440 / 48 | 2 773 843 / 48 | 2 622 349 / 48 |
| 28 | 22 545 724 / 98, 6.5 s | 15 859 832 / 98, 4.6 s | 19 248 570 / 53, 5.6 s | 12 734 573 / 53, 3.8 s | 11 947 219 / 36, 3.8 s |
| 30 | 127 164 784 / 190, 40.1 s | 98 509 302 / 190, 31.6 s | - | 79 876 537 / 135, 26.0 s | 74 276 491 / 106, 27.2 s |

Ratios of the full stack to the baseline: nodes 0.53 (n = 28), 0.58 (n = 30); time 0.58 and 0.68. F1 alone
gives 0.93 at n = 28 and F2 a further 0.92; P1 gives 0.70 (n = 28) and 0.77 (n = 30); C1 0.92 to 0.94 but
costs about as much time as it saves. B1 as a prefix bound (`-balz`, a dynamic program over heights)
removes 14 of the 98 words at n = 28 and essentially no nodes: it is a leaf filter.

**Soundness checks.** The words at the minimal length of their type are complete censuses of shortest
polygons in canonical position passing DMON1-7. A length-decreasing rule (F1, F2) must keep all of them,
and a psi rule (C1, B1) must keep at least one per type:

| type at Len | words | violate F1 (must be 0) | violate C1 | violate B1 (z, y) | pass all |
|---|---|---|---|---|---|
| 3_1 at 24 | 50 | 0 | 12 | 20 | 22 |
| 4_1 at 30 | 98 | 0 | 26 | 60 | 34 |
| 5_1 at 34 | 120 | 0 | 4 | 68 | 52 |
| 5_2 at 36 | 1012 | 0 | 114 | 570 | 388 |

In the n = 30 search, `-face -plane4 -aotp` keeps all 98 words of 4_1 (its minimal length) and the
stack with `-crank` keeps 78 of them.

**Leaf (identification work).** On the 18 945 survivors at n = 38 the rules keep: F1 and F2 at the faces
14 096; with the leaf form of C1 (all valid variants) 10 866; with B1 on z and y 4 393 (4.3 times fewer);
with B1 on x as well 2 325 (8.1 times fewer). At n = 42 this shrinks the identification step by the same
order.

## 7. Ideas that do not work (measured), so that nobody repeats them

* **Stiffness of free walks.** In free space DMON7 forbids four corner types, so a walk none of whose
  corners is supported by another vertex is a staircase in the order down*, south*, (east* or west*),
  north*, up*. On the n = 38 survivors, 99.2 % of the pattern corners in the last 10 steps (91.8 % in the
  last 14) are supported by a vertex placed earlier. An experimental bound that allows only such supports
  (`-stiffx`, unsound) cuts nodes by only 2.2 times at n = 28, even though it wrongly discards most
  shortest polygons (6 of the 50 trefoils at n = 24 survive it). So the ceiling of this idea is low: the
  obligations of DMON6/7 already capture most of it. A sound part: **if the completion supports one of
  its own pattern corners, its excess is at least 4.** The other pass through the support point is a
  sub-walk between two adjacent points. One step would make a U-turn with the corner letters, and every
  3-step walk between adjacent points contains a reversal or a U-turn, so it has at least 5 edges. This
  makes the stiff bound sound only when the slack is at most 2, and those nodes lie at the end of the tree.
* **Lattice stick number as a target bound.** Even the unknotted survivors have 15 to 28 sticks (n = 36,
  38), so a stick bound for 7-crossing knots prunes nothing.
* **An early rule for the x-reflection.** When the bottom row (z = 0, y = 0) is the root alone, the
  x-reflection keeps the root, and exactly half of these survivors read e before w (781 / 781 at n = 38).
  But only 8 % of the survivors have this property. For the rest, the reflected root is the far end of the
  bottom row, which the walk may reach only at the end.
* **Centroid balance as a prefix bound.** See section 6: no node gain.

## 8. Further ideas, with proofs where they exist, not yet measured

1. **Diagonal mid-planes (a new plane lemma).** For the mid-plane x + y = c + 1/2 (and the five other
   diagonal families), if it is crossed by exactly two edges of a shortest polygon of a prime knot, then
   the arc on one side is a Manhattan geodesic. *Proof.* As Lemma 3, with b' a geodesic from A to B that
   stays in the closed half-space of b: A and B have x + y = c + 1; take the steps on z first and then
   alternate the two horizontal letters so that x + y stays in {c + 1, c + 2}. The arc A'A, b', BB' bounds an
   embedded disk with its projection to the plane, so it is unknotted in the half-space, and the other
   arc does not enter that half-space. Minimality gives |b| = |A - B|_1. [] So a diagonal plane whose
   two sides both contain two edges with opposite directions is crossed at least 4 times. Each x- or
   y-step crosses one plane of the family, so this gives the pairwise bounds t_x + t_y >= D_{x+y} (and the
   five others) for the axis-count test. Since P1 showed that this test is sensitive to the sharpness of
   the per-axis bounds, this is the next experiment.
2. **Conditional crank obligations in the count test.** If a crank obligation that is valid only when
   c_z < c_y has no reachable site, the final polygon must have c_z = c_y; feed this equality into the
   sorted-count test of D2.
3. **A second anchor at the highest vertex.** Fix the position of the highest vertex (in the order z, y, x
   reversed) per task and grow four ends. The gain of E9 came from knowing the two vertices before the
   root, and the same could hold at the far side; the risk is that one prefix appears under many anchor
   positions.
4. **Tangle minimality across 4-crossed planes (for 2-bridge targets).** A 2-bridge knot has no essential
   Conway sphere, so across a mid-plane crossed 4 times one side is a rational tangle (prime knots have
   no local knots). A table of the least lattice length of each small rational tangle with given end
   points would give a DMON in the style of `-stair`. This needs a classification of small lattice
   tangles, a computation in the style of `arcknot`.

## 9. Assessment

None of these is a breakthrough in the sense of a change of growth rate. The full stack gives about 1.7
times at n = 28 to 30, and B1 cuts the survivor lists 4 to 8 times. Two facts from section 0 and section 7
bound what any further pruning of this kind can give: the nodes sit 8 to 15 steps before the end with
slack >= 6, and even an over-strong stiffness bound gives only 2.2 times. A larger gain will need a new
lemma that bites when the gap still has 15 or more steps, of the kind of Lemma 3 (which bites at any
depth because it is a statement about planes, not about the gap walk). The diagonal planes of section 8.1
are the closest candidate of that kind.
