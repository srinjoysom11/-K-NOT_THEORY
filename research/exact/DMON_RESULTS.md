# DMON experiments: results (branch claude/dmon-experiments)

Machine: 4-core container, `g++ -O3 -march=native -std=c++17 -pthread`, one run at a time, 4 threads.
`enum` = `enum.cpp` unchanged (sha256 276a574d...). `enum_dmon` = `enum_dmon.cpp`; with no new flag it gives
byte-identical output and identical node counts to `enum` (checked at n = 24, 26 and by the CI job).
Logs: `out/dmon/`. Resume notes: `DMON_STATE.md`.

## D2. Axis-ordered travel (pure bound)

Flags: `-aot` is D2 as written in DMON_IDEAS.md. `-aotc` is `-aot` where, per axis A, the lower bound t_A on the
remaining steps along A is the larger of (a) the travel bound of `span_need` and (b) `cdef[A]`, the plane
crossings still owed on A under `-prime`/`-stair` (each owed crossing is one future step along A, so (b) is also
a lower bound on t_A; it is the same quantity the old test only used summed over the three axes).
Test (in `update`, only with the axis rule on): L_A = even(c_A + t_A); z' = L_z, y' = max(L_y, z'), x' = max(L_x, y');
prune if x' + y' + z' > N. (c_A + t_A is already even, because t_A has the parity of the head coordinate.)

`-stair -tourcap 3`, whole search (no -part):

| n | variant | nodes | ratio | seconds | ratio | survivors | output vs enum |
|---|---|---|---|---|---|---|---|
| 24 | enum | 15 886 694 | 1 | 3.6 | 1 | 50 | - |
| 24 | -aot | 8 844 973 | 0.557 | 1.6 | 0.44 | 50 | identical |
| 24 | -aotc | 5 559 450 | 0.350 | 1.0 | 0.28 | 50 | identical |
| 26 | enum | 76 302 828 | 1 | 18.9 | 1 | 62 | - |
| 26 | -aot | 38 158 720 | 0.500 | 8.0 | 0.42 | 62 | identical |
| 26 | -aotc | 22 315 231 | 0.292 | 4.2 | 0.22 | 62 | identical |
| 28 | enum | 408 794 261 | 1 | 115.4 | 1 | 98 | - |
| 28 | -aot | 189 095 418 | 0.463 | 45.0 | 0.39 | 98 | identical |
| 28 | -aotc | 117 097 571 | 0.286 | 25.0 | 0.22 | 98 | identical |
| 30 | enum | 2 162 299 744 | 1 | 635.5 | 1 | 190 | - |
| 30 | -aot | 1 138 211 175 | 0.526 | 279.7 | 0.44 | 190 | identical |
| 30 | -aotc | 644 549 582 | 0.298 | 140.9 | 0.22 | 190 | identical |

`-prime -tourcap 3` (no `-stair`): n = 24: 20 913 121 -> 11 201 719 (0.536) / 7 337 328 (0.351) nodes, 4.0 s -> 1.8 s / 1.2 s;
n = 26: 94 932 798 -> 45 965 725 (0.484) / 27 732 743 (0.292), 21.0 s -> 8.3 s / 4.5 s. Output identical (cmp), 50 and 62 survivors.
Default options without `-prime` at n = 20, 22: identical (empty) output, nodes 0.41 / 0.38 (the survivors lists are empty there,
so this is only a weak identity check).

Reading: `-aot` alone halves the nodes; the per-axis crossing debt in `-aotc` gives a further factor 1.7, in total about
3.4x fewer nodes and 4.5x less time at n = 28 and 30. Growth per two edges of `-aotc`: 22.3e6 -> 117e6 -> 645e6 = 5.2x, 5.5x
(baseline 5.4x, 5.3x), so the saving is a constant factor of about 3.4 (0.7 of a length step, since a length step costs 4.2x to 5.4x here),
not a change of growth rate.

`-aotc` is valid exactly when `-prime` or `-stair` is on (then `cdef[A]` is the plane-crossing debt of Lemma 3 of PROOF.md);
without `-prime` it equals `-aot`. In the DMON-only setting of the paper's proof (no `-prime`) the plain `-aot` is the one to use.
In the vocabulary of the paper (DMON1-DMON7 are the properties of a polygon; return distance, span, tour/MST, two free neighbours and
flip reduction are search tests) D2 is a **search test**, not a DMON, and a **pure bound**: the word list must not change, and it does not.

## D1. Generalized curtain (GC): a new DMON ("DMON6+")

### 1. Definitions

P is a polygon with n >= 6 edges, i.e. a closed self-avoiding lattice walk. Vertex indices are taken mod n. a is a unit vector of Z^3.
Fix i0 and m with 2 <= m <= n - 2 and put v_j = P(i0 + j). Then v_0, ..., v_{m+1} are m + 2 different consecutive vertices of P
(different because m + 1 < n).

* The window (v_0, ..., v_{m+1}) is a **GC window** (for a) if v_1 = v_0 + a and v_{m+1} = v_m - a. The steps v_1 -> v_2 -> ... -> v_m
  are arbitrary: they may be perpendicular to a, or equal to +a or -a. (The curtain of Lemma 1 is the case where all are perpendicular.)
* Q = {v_1, ..., v_m} is the **curtain**, the part that will be moved. R = V(P) \ Q is the **rest**. v_0 and v_{m+1} are in R.
* The window is **closed up** if some point v_j - a with 2 <= j <= m - 1 is in R. For m = 2 there is no such j, so a GC window with m = 2 (a U-turn)
  is never closed up.

Intuition: the curtain is pushed one unit down its rail. Each v_j goes to b_j = v_j - a. The two end edges v_0 v_1 and v_m v_{m+1} have length one and shrink
to length zero (b_1 = v_0, b_m = v_{m+1}), so the polygon loses two edges. This is possible if the new places b_2, ..., b_{m-1} are not taken by the rest.
If b_j lands on the curtain itself, nothing is wrong: the curtain leaves.

### 2. Minimality

**Lemma GC.** Let P have a GC window that is not closed up. Then P' = (v_0, b_2, ..., b_{m-1}, v_{m+1}) followed by the part A of P from v_{m+1} to v_0 through R
is a polygon with n - 2 edges and the same knot type as P. Hence a shortest polygon of a knot type has no GC window that is not closed up.

*Proof.* If m = 2, then P' is P with the U-turn v_0 v_1 v_2 v_3 removed, and Lemma 1 of PROOF.md (k = 1) says that P' has the same type. Let m >= 3 from now on.

**(i) P' is a polygon with n - 2 edges.** Its vertices are v_0, b_2, ..., b_{m-1}, v_{m+1} and the n - m - 2 vertices of A strictly between v_{m+1} and v_0: in all
2 + (m - 2) + (n - m - 2) = n - 2. Consecutive vertices are adjacent: b_1 = v_0 and b_2, ..., b_{m-1}, b_m = v_{m+1} are translates of consecutive v's. The b_j with 2 <= j <= m - 1 are
different from each other (translates of different points), not in R (the window is not closed up), and v_0, v_{m+1} are in R. So all vertices are different.

**(ii) Two facts about lattice edges.**
(F1) Two different unit lattice edges meet in at most a common end point. A lattice point that is not an end point of a unit lattice edge has distance at least 1 from it,
and two unit lattice edges with no common point have distance at least 1. (Their coordinates are integers; the distance in each coordinate between two intervals with integer end points is 0 or at least 1; if all three coordinate distances were 0 the edges would share a lattice point.)
(F2) Let 0 < t < 1, let e = [u, u'] be a unit lattice edge and E = [w, w'] a unit lattice edge, and let e_t = e - t a (a unit edge of the lattice Z^3 - t a). Then
 (a) if e and E are both perpendicular to a, e_t and E do not meet (the a-coordinate of e_t is an integer minus t, that of E an integer);
 (b) if E is parallel to a and e is perpendicular to a, e_t meets E only if an end point of e_t lies in the interior of E, i.e. u - t a = w + x a with 0 < x < 1 (or the same for u'), which means u = w + (x + t) a, so x + t = 1 and u = w' (taking w' = w + a);
 (c) if E is perpendicular to a and e is parallel to a, e_t meets E only in an end point z of E that lies in the interior of e_t, which means z = u + (x - t) a for the lower end u of e with 0 < x < 1, so z = u;
 (d) if both are parallel to a and meet, they lie on one line, and the open intervals (w, w + 1) and (u - t, u + 1 - t) of a-coordinates overlap only if u - w is 0 or 1, i.e. u = w or u = w + a.
 (b) is proved by: a point of E has integer coordinates perpendicular to a; on e_t this means an end point of e_t (e is perpendicular to a, so only its end points have integer perpendicular coordinates). (c) is the same with the roles exchanged. 

**(iii) H_t is simple for 0 <= t < 1.** For such t let S1_t = [v_0, v_1 - t a], Y_t the path v_1 - t a, ..., v_m - t a, S2_t = [v_m - t a, v_{m+1}], M_t = S1_t Y_t S2_t, and H_t = M_t followed by A.
All H_t have the same number of vertices, they move continuously with t, H_0 = P, and each edge has length 1 or 1 - t > 0.

* *Y_t is simple* (a translate of a sub-path of P).
* *S1_t meets Y_t only at their junction v_1 - t a.* S1_t is the part of the edge [v_0, v_1] of P with a-coordinates [0, 1 - t] (measured from v_0). Let e = [v_j, v_{j+1}] (1 <= j <= m - 1) and E = [v_0, v_1].
 If e is perpendicular to a, (F2b) with w = v_0 gives that e_t meets E only if u = v_1, i.e. at the junction. If e is parallel to a and meets the line of E, then (F2d) says that u - w is 0 or 1: u = v_0 is impossible (v_0 is not in Q),
 and u = v_1 gives e_t with a-coordinates [1 - t, 2 - t], which touches S1_t = [0, 1 - t] only at the junction.
* *S2_t meets Y_t only at its junction v_m - t a.* The same argument for the reversed polygon with a replaced by -a.
* *S1_t and S2_t are disjoint.* They lie on the lines v_0 + Ra and v_{m+1} + Ra. If the lines differ they are disjoint. If they are equal, v_{m+1} = v_0 + c a with c an integer; S1_t has coordinates [0, 1 - t], S2_t has [c, c + 1 - t]. They can only meet for c in {-1, 0, 1}: c = 0 means v_{m+1} = v_0, c = 1 means v_{m+1} = v_1 in Q, c = -1 means v_0 = v_{m+1} + a = v_m in Q. All impossible.
* *M_t meets A only at v_0 and v_{m+1}.* S1_t is part of the edge [v_0, v_1] of P and A consists of other edges of P, so (F1) S1_t meets A only at v_0 (v_1 is not in R). The same holds for S2_t and v_{m+1}.
 Let e_t = e - t a with e = [v_j, v_{j+1}], 1 <= j <= m - 1, be an edge of Y_t and E = [w, w'] an edge of A (so w, w' are in R). Suppose they meet.
 Case e and E perpendicular to a: impossible by (F2a). Case E parallel to a, e perpendicular: by (F2b) u = w' for an end point u of e, but u is in Q and w' is in R. Case E perpendicular, e parallel: by (F2c) the lower end u of e is an end point z of E, but u is in Q and z in R.
 Case both parallel to a: by (F2d) u = w or u = w + a, an end point of E, in R; but u is in Q. In all cases a contradiction.
So H_t is simple for 0 <= t < 1.

**(iv) Knot type along a path of polygons.** The simple closed polygons with N vertices form an open set in (R^3)^N: a simple polygon has positive distance between non-adjacent edges and no two adjacent edges overlap, and this stays true after the vertices are moved by a small amount;
and moving the vertices of a simple polygon by a small amount (along the straight line) is an isotopy, supported in a thin tube around the polygon. Hence the knot type is constant along every continuous path of simple N-gons. By (iii) H_t, 0 <= t <= 7/8, is such a path, so
H_{7/8} has the type of P.

**(v) From H_{7/8} to P'.** Put l = 1 - 7/8 = 1/8, t = 7/8. Then Y_t = (b_1, ..., b_m) + l a, S1_t = [v_0, v_0 + l a] and S2_t = [v_{m+1} + l a, v_{m+1}].
Let w = v_0 + l a and s = v_2 - v_1 = b_2 - v_0. Near v_0 the polygon H_t consists of the last edge e_in = [v_{-1}, v_0] of A, the edge S1_t = [v_0, w], and the first edge [w, w + s] of Y_t.
 * If s = a, these three points are on a line, and deleting the vertex w does not change the curve. (s = -a is impossible: v_2 = v_0.)
 * If s is perpendicular to a, let T = triangle (v_0, w, w + s); in coordinates x along a and y along s from v_0, T = {0 <= x <= l, 0 <= y <= x/l}. I claim that T meets H_t only in the two legs [v_0, w] and [w, w + s]. Then replacing the legs by the third side [v_0, w + s]
   is a Delta-move (the vertex w moves along the segment from w to the third side through T, and during this motion the polygon stays simple), so it does not change the knot type. T lies within distance l of the lattice edge g = [v_0, b_2]. The rest of H_t:
   - an edge E of A other than e_in does not contain v_0, and does not contain b_2 (b_2 is not in R as the window is not closed up and m >= 3), so by (F1) E has distance >= 1 from g, so none of E is in T;
   - e_in = {v_0 + u e, 0 <= u <= 1}: e = a would give v_{-1} = v_1, e = s would give v_{-1} = b_2 in R (not closed up). The other directions e = -a, -s, or e out of the plane of a and s, leave T: T has x >= 0 and y >= 0. So e_in meets T only in v_0;
   - the second edge of Y_t starts at w + s in a direction c that is not -s (v_3 != v_1). T has x <= l and y <= x/l < 1 away from the vertex (l, 1), so it meets this edge only in (l, 1): for c = s, y > 1; for c = +a, x > l; for c = -a, y = 1 > x/l; for c out of the plane it is out of the plane;
   - a later edge [b_j, b_{j+1}] + l a, j >= 3, is a translate of a lattice edge that contains neither b_1 nor b_2, hence has distance >= 1 from g and >= 1 - l > l from g after the translation, so it misses T;
   - S2_t lies within l of the lattice point v_{m+1}, which is not on g (v_{m+1} is not v_0, and not b_2), hence at distance >= 1 from g, so S2_t misses T.
 The same argument at the other end (reverse the polygon, replace a by -a) lets us delete the vertex v_{m+1} + l a. For m = 3 the second triangle T' shares the vertex b_2 + l a with T; T and T' are in planes through the line b_2 + l a + Ra and meet this line only in that point
   (T lies on y <= 1 and touches y = 1 only in (l, 1); T' is on the other side of the vertex or in another plane), so the second Delta-move is also valid after the first. For m >= 4 the lattice edges [v_0, b_2] and [b_{m-1}, v_{m+1}] have no common point, so T and T' are at distance >= 1 - 2l > 0.
 The result is the polygon P'_l with vertices v_0, b_2 + l a, ..., b_{m-1} + l a, v_{m+1} and A.
 For 0 <= x <= l the polygon P'_x (middle vertices b_2, ..., b_{m-1} moved by x a) is simple: P' = P'_0 is a simple lattice polygon, so its non-adjacent edges have distance >= 1 (F1), adjacent edges are perpendicular or opposite, and a movement of at most 1/8 of the middle vertices cannot make non-adjacent edges meet (distance stays >= 1 - 2x > 0),
 nor adjacent edges overlap (their directions change by an angle < 45 degrees). By (iv) P'_l has the type of P'.
Combining (iv) and (v), P has the type of P'. []

### 3. Use in the search (new DMON6+, "GC")

**DMON6+.** *A shortest polygon P has no GC window that is not closed up.* (By Lemma GC. This contains DMON6 as the special case where the steps in the window other than the first and last are perpendicular to a and the window is taken at the most recent step on its axis.)

The search tests it in two places.
* *At the leaf* (`-gcleaf`): all cyclic windows (i0, m), 2 <= m <= n - 2, including those that pass the root, are tested: for each, some v_j - a, 2 <= j <= m - 1, must be a vertex whose index is not in {i0 + 1, ..., i0 + m} mod n. (`gc_leaf_ok`.)
* *On prefixes* (`-gc`): at step i in direction d, for every earlier step i0 <= i - 2 in direction d^1 (= +a) other than the last step on the axis of d (that window is the ordinary curtain, already treated by DMON6), the obligation
  "one of the points v_j - a, 2 <= j <= m - 1 (m = i - i0), becomes a vertex of the rest" is built by `gcob`: if one of the points is already a vertex with index <= i0, the obligation is satisfied; points occupied by vertices of the window do not count; the other allowed free points are the sites;
  no site means the walk is discarded. The sites go through the same tests as the other obligations (discharged when the head enters a site; reach: the distance from the head to the site and on to the origin is at most the remaining steps; the site needs two free neighbours, the head, or the origin;
  the axis test `-aot` uses single-site GC obligations too). By default the GC obligations stay out of the exact tour and the MST test (`-gctour 0`): with `-tourcap 3` extra obligations make the capped exact tour give up more often and the tour test loses more than GC gains.

### 4. Completeness (PanDMONium style)

Let w be the word of a polygon P that passes the conditions DMON1-DMON7 and DMON6+ (a shortest polygon in normal form, as in the proof of the theorem), with vertices v_0, ..., v_n = v_0. Obligation invariant (paper, Lemma "Obligation invariant"):
after step i every pending obligation has a site that is a vertex v_m of w with i + 2 <= m <= n - 1. *Claim: the GC obligations built by the search at step i keep this invariant, and building them never discards w.*
Let step i be a step in direction d = -a and let i0 <= i - 2 be a step in direction a, so (v_{i0}, ..., v_{i+1}) is a GC window of P with m = i - i0 >= 2 and Q = {v_{i0+1}, ..., v_i}, R = {v_k : k <= i0 or k >= i + 1} (indices 0..n-1). By DMON6+ the window is closed up, so some v_{i0+j} - a, 2 <= j <= m - 1, is a vertex v_k with k in R's index set, k in [0, n - 1].
 * If k <= i0, that point is occupied by a vertex with index <= i0, so `gcob` returns "satisfied" and adds nothing.
 * k = i + 1 is impossible: v_{i0+j} - a = v_{i+1} = v_i - a would give j = m.
 * Otherwise k >= i + 2, so the point is free after step i, it is allowed (it is a vertex of P other than v_0, or is v_0 with k = n which was covered by the first case), and it is one of the sites of the new obligation. So the list of sites is not empty, w is not discarded, and the obligation has a site v_k with i + 2 <= k <= n - 1.
For the remaining tests (removal of an obligation when the head enters one of its sites, reach, two free neighbours, span, tours) the proof of the PanDMONium theorem uses only that every pending obligation has a site that is a later vertex of w (the invariant), so it applies to the new obligations without change.
At the closing step the search requires that no obligation is pending, and cyclic windows through the root are tested at the leaf; for w both hold because w passes DMON6+ (a pending obligation after step n - 1 would need a site v_k with k >= n + 1, which does not exist; for the cyclic windows the definition of "closed up" is the one tested).
Hence w passes every GC test, and the output of `enum_dmon -gc` contains a polygon of every knot type with Len(K) = n, exactly as the output of `enum`.

### 5. Experiments

**(a) The lemma on all known shortest polygons.** `check/gc_check.cpp` (written from the statement of the lemma, no code shared with the search) on the censuses
generated by `check/slab_census.py ... --all48` (counts agree with the published numbers): 3_1 at 24: 3328 polygons, 4_1 at 30: 3648, 5_1 at 34: 6672, 5_2 at 36: 114 912:
**0 violations in 128 560 polygons** (`out/dmon/gc_census_check.txt`). Also 0 violations in every stored survivor list `out/n24_psi.txt ... out/n38_stair.txt` (50, 62, 190, 542, 1398, 6662, 18 945 words).
Not vacuous: all 68, 790, 15 706, 140 796 closed polygons of lengths 8, 10, 12, 14 (all unknotted, none shortest) violate GC, and the search's leaf test (`-plain -plaindump -gcleaf`) gives exactly the same set of
passing polygons as `gc_check` (both: none).

**(b) The move keeps the knot type** (`check/gc_move_test.py`): 400 random polygons obtained from the 3_1 words of `out/n24_psi.txt` by random +2 BFACF moves and corner flips (length up to 44);
every GC window that is not closed up (19 528 windows, m from 2 to 44, many with interior steps along +-a) was shrunk with the move; the shrunk word is a valid polygon with n - 2 edges and has the same Alexander polynomial in all 19 528 cases.

**(c) Leaf-only filter (`-gcleaf`)**: removes no word and no leaf at n = 24, 26, 28: `gc_leaf_drops = 0`, output identical to `enum`, node counts identical. (The leaf tests of DMON6, the pending obligations and the corner conditions have already removed
every closed polygon that violates GC.)

**(d) Prefix version (`-gc`)**, `-stair -tourcap 3`, output byte-identical to `enum` in every row:

| n | variant | nodes | ratio to enum (or to -aotc) | seconds | closed polygons reached | survivors |
|---|---|---|---|---|---|---|
| 24 | enum | 15 886 694 | 1 | 3.6 | 114 | 50 |
| 24 | -gc | 15 884 608 | 0.99987 | 5.8 (3 threads) | 69 | 50 |
| 26 | enum | 76 302 828 | 1 | 18.9 | 594 | 62 |
| 26 | -gcleaf | 76 302 828 | 1 | 17.3 | 594 | 62 |
| 26 | -gc | 76 288 851 | 0.99982 | 24.7 | 234 | 62 |
| 26 | -aotc | 22 315 231 | 1 | 4.2 | 427 | 62 |
| 26 | -gc -aotc | 22 310 147 | 0.99977 | 5.7 | 168 | 62 |
| 28 | enum | 408 794 261 | 1 | 115.4 | 3130 | 98 |
| 28 | -gcleaf | 408 794 261 | 1 | 98.6 | 3130 | 98 |
| 28 | -gc | 408 693 507 | 0.99975 | 140.4 | 982 | 98 |
| 28 | -aotc | 117 097 571 | 1 | 25.0 | 2239 | 98 |
| 28 | -gc -aotc | 117 059 765 | 0.99968 | 33.1 | 712 | 98 |
| 30 (part 0 of 8) | enum | 272 901 739 | 1 | 74.9 | 1486 | 19 |
| 30 (part 0 of 8) | -gc | 272 819 080 | 0.99970 | 106.8 | 387 | 19 |
| 30 | -aotc | 644 549 582 | 1 | 140.9 | 10 353 | 190 |
| 30 | -gc -aotc | 644 308 561 | 0.99963 | 201.2 | 2782 | 190 |

(Seconds are wall-clock on a machine that was otherwise idle except for the n = 24 row, 3 threads, and the `-gcleaf` row at n = 28, which ran faster than the `enum` row: timing noise between runs is about 15 %.)

**(e) Which test does the work** (`-rejstats`, n = 24, `-stair -tourcap 3`, prefixes killed inside `update`; `enum` / `-gc`):
no site for a corner obligation 79 641 / 79 611; some site of a curtain or corner obligation unreachable or without two free neighbours 2 379 677 / 2 378 229; exact tour or tree bound 6 351 669 / 6 351 109;
GC: no site 5, GC site unreachable or without two free neighbours 2075. So GC adds about 2 080 prefix kills in 15.9 million nodes, and removes only a few thousand other kills, because those prefixes die one or two steps later anyway.

**Conclusion D1.** GC is a valid new DMON (proved in full above, 0 violations in 128 560 known shortest polygons, 19 528 move checks, identical output). As a search device it is useless in this search:
the 15 884 608 vs 15 886 694 node counts show that the existing DMON6 (U-turns and perpendicular curtains), DMON7 (corners) and the reach tests already prune every prefix that GC could prune, and the extra obligations cost 30 to 45 % more time.
It could matter in a search without DMON7/-prime or as a leaf test for candidate polygons coming from other sources (random polygons, BFACF searches), where it is a cheap necessary condition for being shortest; we did not need it there.

## D2 follow-ups (requested by the parent session)

All are search tests (pure bounds): output byte-identical to `enum` in every row, checked with `cmp`. `-stair -tourcap 3`, whole search. Nodes ratio and seconds ratio are against `enum`.

* `-aote`: the counts-only part of D2 (head coordinate, plus the plane debt with `-aotc`) is tested before `update()`, i.e. before any obligation is built. Rejected nodes are still counted as nodes, so the node counts must equal those of `-aot` / `-aotc` without it, and they do (n = 24, 26, 28). It saves time only.
* `-aotm`: per-axis travel also for multi-site obligations: on axis q, a multi-site obligation needs the walk to reach the coordinate of one of its sites, so the travel on q is at least the least value, over its sites, of the travel bound with the range extended to that site's coordinate; the maximum over the obligations is used. This is a lower bound on the steps on axis q.
* `-aott`: the same per-axis test inside the exact tour, with (per-axis distance of the partial tour so far) + (per-axis span of the sites still to visit from the current point); this is a lower bound (the witness tour is an upper bound and is not used).

| n | variant | nodes | ratio | seconds | ratio |
|---|---|---|---|---|---|
| 24 | enum | 15 886 694 | 1 | 3.6 | 1 |
| 24 | -aot -aote | 8 844 973 | 0.557 | 1.6 | 0.44 |
| 24 | -aot -aotm | 8 158 082 | 0.514 | 1.6 | 0.44 |
| 24 | -aotc -aote | 5 559 450 | 0.350 | 0.9 | 0.25 |
| 24 | -aotc -aotm -aote | 5 065 015 | 0.319 | 0.9 | 0.25 |
| 24 | -aotc -aotm -aote -aott | 4 891 452 | 0.308 | 0.9 | 0.25 |
| 26 | enum | 76 302 828 | 1 | 18.9 | 1 |
| 26 | -aot -aote | 38 158 720 | 0.500 | 7.4 | 0.39 |
| 26 | -aot -aotm | 34 622 342 | 0.454 | 7.0 | 0.37 |
| 26 | -aotc -aote | 22 315 231 | 0.292 | 3.7 | 0.20 |
| 26 | -aotc -aotm -aote | 20 044 495 | 0.263 | 3.5 | 0.19 |
| 26 | -aotc -aotm -aote -aott | 19 166 535 | 0.251 | 3.7 | 0.20 |
| 28 | enum | 408 794 261 | 1 | 115.4 | 1 |
| 28 | -aot -aote | 189 095 418 | 0.463 | 39.3 | 0.34 |
| 28 | -aot -aotm | 170 725 832 | 0.418 | 37.8 | 0.33 |
| 28 | -aotc -aote | 117 097 571 | 0.286 | 21.8 | 0.19 |
| 28 | -aotc -aotm -aote | 104 466 494 | 0.256 | 20.4 | 0.18 |

(`-aote` alone leaves the node counts of `-aot`/`-aotc` unchanged and saves 8 to 13 % of the time; `-aotm` saves a further 8 to 10 % of the nodes; `-aott` 3 to 4 % of the nodes at no time gain, because with `-tourcap 3` the exact tour is entered rarely and is cut off after three calls.
With the default `-tourcap 3000` at n = 24: `-aotc -aotm -aote` 4 079 000 nodes, plus `-aott` 3 949 679.) Best combination for the production setting (`-stair -tourcap 3`): **`-aotc -aotm -aote`**, 0.26x nodes and 0.18x time at n = 28.

**DMON-only mode** (no `-prime`; the setting of the paper's proof; `-tourcap 0 -nomst -noreduce`). `enum` reproduces the reference counts: n = 24: 181 235 380 nodes, n = 26: 1 078 116 768. Here `-aotc` is the same as `-aot` (no plane debt).

| n | variant | nodes | ratio | seconds | ratio |
|---|---|---|---|---|---|
| 24 | enum | 181 235 380 | 1 | 10.3 | 1 |
| 24 | -aot -aote | 70 162 235 | 0.387 | 4.2 | 0.41 |
| 24 | -aot -aotm -aote | 64 507 589 | 0.356 | 4.4 | 0.43 |
| 26 | enum | 1 078 116 768 | 1 | 66.5 | 1 |
| 26 | -aot -aote | 362 445 758 | 0.336 | 22.0 | 0.33 |
| 26 | -aot -aotm -aote | 328 946 957 | 0.305 | 22.6 | 0.34 |
| 24, `-tourcap 3` without `-prime` | enum | 86 639 605 | 1 | 9.6 | 1 |
| 24, `-tourcap 3` without `-prime` | -aot -aotm -aote | 34 672 268 | 0.400 | 3.8 | 0.40 |

Outputs identical in all rows (50 survivors with the default reduction; 56 and 168 candidates with `-noreduce`). Growth per two edges of the DMON-only search with `-aot`: 70.2e6 -> 362e6 = 5.2x (baseline 5.95x).

## D3. Obstacle-aware distances and the group spanning tree (search tests, pure bounds)

* `-bfsdist S` (D3a): when the slack s = (remaining steps) - (Manhattan distance to the origin) is at most S, the remaining walk must be a self-avoiding walk from the head to the origin through free allowed points, so the length of a shortest such walk (BFS, depth-limited, points that cannot reach the origin within the budget are not expanded) is a lower bound.
* `-gmst` (D3b): minimum spanning tree over the head, the origin and one node per pending obligation (single-site or not); the edge weight between two nodes is the least Manhattan distance between a site of the one and a site of the other. Any tour that visits one site of every obligation, starting at the head and ending at the origin, is a spanning tree on the sites it chooses, whose weight is at least the weight of this tree, so its length is at least this MST weight. (The old MST bound ignored multi-site obligations.)

`-stair -tourcap 3`, whole search except the last rows; output byte-identical to `enum` in every row.

| n | variant | nodes | ratio | seconds |
|---|---|---|---|---|
| 24 | -bfsdist 0 | 15 878 854 | 0.9995 | 3.7 |
| 24 | -bfsdist 2 | 15 836 659 | 0.9968 | 3.9 |
| 24 | -bfsdist 4 | 15 784 101 | 0.9935 | 5.6 |
| 24 | -bfsdist 100 | 15 739 802 | 0.9908 | 8.1 |
| 24 | -gmst | 15 605 292 | 0.9823 | 5.6 |
| 24 | -gmst -bfsdist 2 | 15 561 032 | 0.9795 | 6.2 |
| 24 | -aotc -gmst -bfsdist 2 (vs -aotc 5 559 450) | 5 460 951 | 0.9823 | 1.5 (vs 1.0) |
| 26 | -bfsdist 0 / 2 / 4 | 76 262 098 / 76 073 809 / 75 833 065 | 0.9995 / 0.9970 / 0.9939 | 18.4 / 20.4 / 27.9 |
| 26 | -gmst | 74 699 482 | 0.9790 | 31.9 |
| 28 | -bfsdist 2 | 407 636 444 | 0.9972 | 118.1 |
| 28 | -gmst | 399 109 725 | 0.9763 | 186.6 |
| 28 | -aotc -gmst -bfsdist 2 (vs -aotc 117 097 571) | 114 180 932 | 0.9751 | 37.6 (vs 25.0) |
| 30 part 0 of 8 | -gmst -bfsdist 2 (vs enum 272 901 739, 74.9 s) | 264 840 865 | 0.9705 | 145.2 |

**Conclusion D3: no gain.** Even a BFS of unlimited depth (`-bfsdist 100`) removes only 0.9 % of the nodes at n = 24, and the group tree 2 %; both cost 1.5 to 2 times the time. The Manhattan bounds are already tight where the walk has little room, and the obstacles do not change the distance
(the head, near the end, is in the middle of free space, or the prefix is killed by an obligation first).

**1-tree bound** (`-onetree`, implies the group graph; requested by the parent): the walk head -> sites -> origin, closed by a zero-weight edge origin-head, is a Hamiltonian cycle on the group nodes, and for every node v the cycle is at least MST(all nodes except v) + the two cheapest edges at v (this holds for any non-negative weights, so also for the least-distance weights between groups; the MST + matching bound is not used because it is not a lower bound). The bound is the maximum over all v. n = 24: 15 135 178 nodes (0.953), 15.3 s; n = 26: 72 279 905 nodes (0.947), 93.7 s. Output identical. So it is a little stronger than the plain MST but 4 to 5 times slower as implemented (all v, every call, O(ng^3)); not worth it. An incremental MST was not tried: the whole MST/tour block takes most of the time, but even a free 1-tree would only remove 5 % of the nodes.

**Where the kills happen** (`-rejstats`, kills inside `update` by remaining steps R1 after the step; `out/dmon/n24_rejstats_enum.log`, `n26_rejstats_enum.log`, `n26_rejstats_aotcm.log`): at n = 26 with `enum`, 32.0 M prefixes die in the tour/MST test, 10.7 M in the reach or two-free-neighbours test, 0.34 M for a corner without site.
They die between R1 = 2 and 16, with the peak at R1 = 8 to 12 (tour/MST: 3.7M, 7.1M, 8.8M, 7.1M, 3.3M at R1 = 8, 9, 10, 11, 12; reach: 2.5M, 2.6M, 2.1M at R1 = 8, 9, 10); there are no kills at all for R1 >= 17 (the first 9 steps of 26 are enumerated without any pruning from `update`, only the return distance and the plane debt prune there).
With `-aotc -aotm -aote` the axis test takes over: 5.3 M kills in `-aot` and 3.4 M more before `update` (`aot_early`), the tour/MST kills drop from 32.0 M to 2.5 M and the reach kills from 10.7 M to 1.7 M, and the axis kills start earlier (R1 = 3 to 16, peak 10 to 12).
Consequence: to save a length step one must prune at R1 >= 14, where today nothing dies; the new axis test is the first that does something there (R1 = 14, 15, 16: 123 113, 36 354, 8 010 kills at n = 26).

## E9. Bidirectional construction (a search order, not a new lemma): `enum_bidir.cpp`

### 1. What is searched

Let w = w_0 ... w_{n-1} be the word of a polygon in canonical position, v_0 = v_n the root, v_i = v_{i-1} + w_{i-1}. A **two-ended prefix** with H head letters and T tail letters (H + T = t) consists of
the head letters w_0, ..., w_{H-1} (vertices v_0, ..., v_H) and the tail letters w_{n-T}, ..., w_{n-1} (vertices v_{n-T}, ..., v_n = v_0). The schedule is fixed: step number t is a head step if t is even and t < ALT, a tail step if t is odd and t < ALT, and a head step if t >= ALT.
So (H, T) is a function of t, and the word determines its prefixes. Every word is visited exactly once (a word is a head part followed by a middle part and a tail part; the search chooses the head part and the tail part letter by letter, and the middle part
is whatever is left). The part of the word that is still missing, w_H ... w_{n-T-1}, is a **completion**: R = n - t letters leading from the head end v_H to the tail end v_{n-T}.
A tail step adds the vertex v_{n-T-1} = v_{n-T} - w_{n-T-1}, i.e. a move in direction -w_{n-T-1} from the tail end. The closing step (R = 1) is the one edge from the head end to the tail end.

With ALT = 0 the tail never moves and the search is exactly `enum.cpp`: the node counts are equal to enum's (n = 24: 15 886 694 with `-stair -tourcap 3`, 86 639 605 with `-tourcap 3`; checked).

### 2. Which tests are applied to a two-ended prefix, and why each is implied by DMON1-DMON7 for every completion that is the rest of a polygon w passing DMON1-DMON7

Let w pass DMON1-DMON7 (and, for `-prime`/`-stair`, the plane-crossing lemma); we show that every two-ended prefix of w passes every test. (This is the part of the completeness proof of the paper that changes; the invariant argument is the same.)

* *Self-avoidance, position.* All vertices of w are different (DMON2) and above the root (DMON3), so the new vertex of a head or tail step is free and allowed. The box bound is as in `enum`.
* *No reversal, no U-turn (DMON6 with k = 1).* For a head step the letter w_H must not be the reverse of w_{H-1} or w_{H-2} (the two letters before it in the cyclic word, which for H < 2 are the last letters of the tail); for a tail step w_{n-T-1} must not be the reverse of w_{n-T} or w_{n-T+1} (the two letters after it, which for T < 2 are the first letters of the head). These are consecutive letters of w.
* *DMON4.* Once both first letters exist, the reverse of the last letter w_{n-1} must be greater than the first letter w_0. This is DMON4 for w, tested as soon as both letters are known.
* *DMON5, axis counts.* The final counts c_z <= c_y <= c_x of w are at least the counts of the letters of the prefix and at most these counts plus R. (The same inequalities as for a one-ended prefix, with the counts of both ends.)
* *Return distance.* The R missing letters lead from v_H to v_{n-T}, so the Manhattan distance of the two end points is at most R. For a head step, the distance from the new head end to the tail end; for a tail step, to the head end.
* *DMON6, curtain obligations.* New head letter w_H on the axis A: let w_j be the last letter on A before it in the word, in the order ..., w_{n-2}, w_{n-1}, w_0, w_1, ..., w_{H-1} read from the leftmost existing letter (so that when no head letter is on A, w_j is the tail letter on A that is nearest to the root: the window passes through the root).
  If w_j = -w_H the letters between are perpendicular to A (none is on A), so w_j ... w_H is a curtain window of w, and DMON6 says that some interior point v_{j+u} - a (2 <= u <= k) is a vertex of w. It is occupied (then the obligation is satisfied) or free, and then it is a vertex of the missing middle part, because every vertex of w that is not placed is a vertex v_m with H < m < n - T,
  and it is allowed. So the list of free allowed points is not empty, and the obligation "one of them is visited by the middle part" holds for w. For a new tail letter w_{n-T-1} the same with the first existing letter on A to its right (the leftmost existing letter on A, which may be a head letter: the window passes through the root).
* *DMON7, corner obligations.* A head step makes the corner at v_H (between w_{H-1} and w_H) for H >= 1; a tail step makes the corner at v_{n-T} (between w_{n-T-1} and w_{n-T}) for T >= 1 (before the step). The vertex is not the root, and DMON7 says that the fourth point of the unit square is a vertex of w; it is placed or it is a free allowed middle vertex. (The patterns are those of `enum.cpp`, in terms of the two letters and the previous and next vertex.)
* *Reach, two free neighbours.* Every site s of a pending obligation is a middle vertex v_m of w (invariant, below): the head end reaches s and s reaches the tail end in the R missing letters, so |v_H - s| + |s - v_{n-T}| <= R; and the two neighbours of s on w are vertices of w that are the head end, the tail end, or free allowed middle vertices.
* *Span, axis-ordered travel (`-aot`, `-aotm`), tour, minimum spanning tree.* They bound the length of a walk from the head end through one site of every pending obligation to the tail end, in the Manhattan metric (per axis for `-aot`: the travel on each axis is a lower bound on the number of letters on that axis among the R missing ones, and the final counts are ordered and even). The missing middle of w is such a walk (by the invariant). Nothing changes except that the end point is the tail end instead of the root.
* *Plane crossings (`-prime`, `-stair`).* Lemma 3 of PROOF.md is a statement about the final polygon; the number of edges across a lattice mid-plane that the prefix has, plus the crossings that are still owed (interior planes 4, outer planes 2, parity), is at most the number of edges across the plane that the polygon has, and every owed crossing is an edge of the missing middle. This does not depend on the order in which the edges were added: the counters are updated for head and tail steps alike (a tail step crosses the plane between the two levels of the move). For the stair rule, a stretch (consecutive steps inside one level) that uses two opposite directions is recorded per side: the stretch of a head run and the stretch of a tail run are parts of stretches of w, and a part that uses two opposite directions makes the whole stretch use them.
  The directions used are directions of moves (for the tail, the reversed letters); two opposite letters are two opposite moves, so the test is the same.

**Obligation invariant.** After every step, every pending obligation has a site that is a vertex v_m of w with H < m < n - T. *Proof.* For an obligation created at this step, shown above. An obligation is removed when a head or tail step reaches one of its sites; if it is not removed, its site v_m was not the new vertex, so it is still not placed and H < m < n - T holds for the new H, T (the new vertex is v_H or v_{n-T}, and m differs from it). []
So no test discards w, and w is visited, reaches the closing step, and is printed.

**The closed polygon.** At the closing step the program assembles the word from the root and applies the complete cyclic tests: no U-turn in the cyclic word, DMON4, every curtain window of every axis (so also those through the root and through the closing edge), the corner conditions at all vertices except the root, and DMON5, and then the flip search of `enum.cpp`. The set of words that pass this and the flip search is the set `enum` prints (its leaf test is exactly this test, and its prefix tests only discard words that fail it); so the output is the same set of words for any sound set of prefix tests.

### 3. Results

All outputs are byte-identical to `enum` (sorted word lists, compared with `cmp`; `-noreduce` so that the candidate lists, not only the survivors of the reducer, are compared).

DMON-only mode (no `-prime`), `-tourcap 3`, `-noreduce`:

| n | enum nodes | enum_bidir -alt 12 nodes | ratio | -alt 100 nodes | ratio |
|---|---|---|---|---|---|
| 20 | 3 569 661 | 549 562 | 0.154 | 553 818 | 0.155 |
| 22 | 17 632 284 | 2 743 447 | 0.156 | 2 790 180 | 0.158 |
| 24 | 86 639 605 | 13 693 204 | 0.158 | 13 918 275 | 0.161 |
| 26 | 420 628 059 | 64 867 075 | 0.154 | 66 087 677 | 0.157 |

`-stair -tourcap 3 -noreduce`, n = 24: enum 15 886 694 nodes (identical to `-alt 0`); `-alt 12`: 4 845 943 (0.305); `-alt 100`: 4 857 751 (0.306); with `-aotc -aotm`, `-alt 12`: 1 264 568 (0.080 of enum, 0.25 of enum_dmon's best single-ended 5 065 015).

**DMON-only, n = 28** (`-tourcap 3 -noreduce`, 2 threads while the machine was loaded, so the seconds are only indicative): enum 2 097 129 249 nodes (630 s); `-alt 12` 327 946 854 (0.156; 114 s); `-alt 100` 335 215 673 (0.160; 115 s). Output identical.

**Production mode** `-stair -tourcap 3` (idle machine, 4 threads, whole search; output of every row byte-identical to `enum`; `enum` rows are those of the D2 table; the n = 32 `enum` count is the sum of the 32 CI parts `out/n32_stair.part*_32.log`; the n = 32 word list is identical to `out/n32_stair.txt`, 542 words):

| n | enum nodes | enum s | bidir -alt 12 nodes (ratio) | s | bidir -alt 12 -aotc -aotm nodes (ratio) | s (ratio) |
|---|---|---|---|---|---|---|
| 24 | 15 886 694 | 3.6 | 4 845 899 (0.305) | 1.1 | 1 264 532 (0.080) | 0.3 (0.08) |
| 26 | 76 302 828 | 18.9 | 22 101 134 (0.290) | 5.5 | 4 614 264 (0.060) | 1.1 (0.058) |
| 28 | 408 794 261 | 115.4 | 114 571 936 (0.280) | 30.7 | 21 185 618 (0.052) | 5.6 (0.049) |
| 30 | 2 162 299 744 | 635.5 | - | - | 130 872 854 (0.061) | 39.3 (0.062) |
| 32 | 11 801 669 632 | - | - | - | 623 885 917 (0.053) (`-alt 4`) | 214.4 |

Stacked with D2 (`-aotc -aotm`) the factors multiply as the parent expected: 0.28 (bidirectional alone, n = 28) x 0.256 / 1 (D2 alone, single-ended: 0.256 at n = 28) = 0.072 expected, 0.052 measured; so they stack slightly better than the product. Time per node is about the same as `enum`'s (n = 30: 0.30 us against 0.29 us per node).
Best single-ended (D2: `-aotc -aotm -aote`, n = 28): 104 466 494 nodes, 20.4 s; bidirectional + D2: 21 185 618 nodes, 5.6 s: a further factor 4.9 in nodes and 3.6 in time.
At n = 30: 635 s -> 39 s (16x); at n = 32: 11.8e9 nodes -> 0.62e9 (19x fewer nodes).
Growth per two edges of the best combination (`-aotc -aotm`, alt 4 or 12): 1.26e6, 4.61e6, 2.12e7, 1.27e8 (alt 4), 6.24e8 (alt 4): factors 3.65, 4.59, 6.0, 4.9. Enum: 4.8, 5.36, 5.29, 5.46. So the saving is a constant factor of about 17 to 19 (1.7 steps of two edges) from n = 28 on, not (yet) a change of growth rate.

**How long a tail is needed** (n = 30, `-stair -tourcap 3 -aotc -aotm`, nodes / seconds; all outputs identical to enum):
`-alt 1` (no tail letter; the single-ended search with these tests) 547 640 491 / 160.5; `-alt 2` and `-alt 3` (one tail letter) 217 560 467 / 66.8; `-alt 4` (two tail letters) 127 164 784 / 40.4; `-alt 6` 140 645 701 / 42.9; `-alt 10` 127 599 291 / 39.0; `-alt 12` 130 872 854 / 39.3; `-alt 16` 139 056 135 / 40.1; `-alt 20` 139 815 105 / 39.3; `-alt 100` 139 410 230 / 39.6.
So one tail letter gives a factor 2.5 and two give a factor 4.3, and longer tails give nothing more. The gain comes from the last two vertices before the root: the walk must come back through one of the three neighbours of the root that are above it (e, n, u), with DMON4 on the first and last letters and the corner conditions there; the return distance is then the distance to a concrete vertex and not to the root.
Recommended: `-alt 4`.

**Rejection histogram** (`out/dmon/n26_rejstats_bidir_alt4*.log`, n = 26, `-stair -tourcap 3`, kills by remaining steps R1): the kills are still at R1 = 2 to 16 with the peak at 8 to 11 (tour/MST kills at R1 = 8, 9, 10, 11: 1.43M, 2.17M, 2.17M, 1.40M instead of 3.7M, 7.1M, 8.8M, 7.1M for enum without D2; reach kills 0.60M, 0.54M, 0.48M, 0.24M instead of 2.5M, 2.6M, 2.1M, 0.8M); there are still no kills at R1 >= 17. So pruning does not start earlier in terms of remaining steps: it is the same kind of kill, but the number of prefixes that reach those depths is 3.7 times smaller (the tail letters remove prefixes that can never close up, one or two steps before they would have been caught). With `-aotc -aotm` the axis test kills 0.43M at R1 = 10 and acts from R1 = 2 to 17.

(d) Plane and stair counters: `-alt 0` gives the node counts of enum exactly (n = 24: 15 886 694 with `-stair -tourcap 3`, 86 639 605 without `-prime`) and, for `-alt` > 0 and every n in the tables, the same output; the counters are updated by the tail steps in reverse order of the word, and stair stretches are kept per side.

## D4. Crossing budget for target-restricted runs (a target-restricted condition, not a DMON)

**Statement used.** For a polygon P of a knot K, any regular diagram of P has at least c(K) crossings (c = crossing number). Take the three projections along the axes with the generic tilt (u, v, w) -> (u + eps w, v + eps^2 w), eps = 1/1000, which are regular diagrams of the lattice polygon (computed in exact integer arithmetic, `check/crossings3.py`; the only zero determinants are collinear disjoint edges, which do not cross).
If the goal of a run is a bound for the knots with c(K) >= c0, every polygon that matters has at least c0 crossings in each of the three projections, so polygons with fewer in one projection may be dropped.

**Leaf experiment** (`out/dmon/d4_leaf_crossings.txt`, survivor lists of `enum -prime/-stair`; fraction of the words that have at least c0 crossings in all three projections, i.e. the part of the list that a target c0 would keep):

| n | words | c0 = 5 | c0 = 6 | c0 = 7 | c0 = 8 |
|---|---|---|---|---|---|
| 24 | 50 | 20.0 % | 4.0 % | 0 | 0 |
| 30 | 190 | 78.9 % | 43.2 % | 12.1 % | 3.2 % |
| 32 | 542 | 75.3 % | 45.6 % | 18.1 % | 5.7 % |
| 34 | 1398 | 84.3 % | 58.3 % | 23.5 % | 7.4 % |
| 36 | 6662 | 92.4 % | 76.1 % | 41.9 % | 18.9 % |
| 38 | 18 945 | 95.7 % | 84.6 % | 57.5 % | 30.3 % |

(All of these words are knots with c <= 5 or unknots, so none is a polygon the target is about; the table shows how many such polygons the filter would still keep.) For n = 40 and c0 = 7 the filter would drop a bit under half of the survivors: it saves identification work, not search work.

**Prefix version: not implemented, and it cannot work with this bound.** A prefix bound needs an upper bound on the crossings that the R missing edges can still create. In the projection along z a horizontal unit edge crosses only edges that lie over the four unit columns around it (an x-edge at (x..x+1, y, z) and a y-edge at x0 in {x, x+1}, y0 in {y-1, y}, at any height), and a column can hold edges at every height of the polygon (about 10 levels at n = 40);
so one edge can cross up to about 40 others, and R edges up to about 40 R, which is more than the target c0 = 6 or 7 as long as R >= 1. The bound prunes nothing. A useful prefix test would need a lower bound on the final number of crossings from the shape of the prefix (the number of crossings that the prefix already has is a lower bound for the final count, but it is the wrong direction for pruning: pruning needs an upper bound of the final count).
So D4 is only a leaf filter; the search is not helped.

## Slab runs with the two-ended search: `enum_bidir -slab L`

`-slab L` has the semantics of `slab.cpp` (PROOF_SLAB.md): points with 0 <= z <= L (and |x|, |y| <= 27), the axis rule only y-steps <= x-steps (the z axis is no longer exchangeable), N <= 52.
Prefix test: 2 c_y + c_z <= N and c_y <= c_x + (R - 1); closed polygon: c_y <= c_x. The axis-ordered travel test (`-aot`) uses the order y <= x only. Nothing else changes: the curtain move, the corner flips and the plane-crossing lemma never leave the bounding box of the polygon, as in PROOF_SLAB.md.
Validation against the stored outputs of `slab.cpp` (`-slab L -stair -tourcap 3`; `enum_bidir` with `-alt 4 -aotc -aotm`), word lists byte-identical (`cmp`):

| slab | n | words | slab.cpp nodes | seconds | enum_bidir nodes (ratio) | seconds (ratio) |
|---|---|---|---|---|---|---|
| L = 1 | 30 | 12 | 25 087 124 | 6 | 3 554 939 (0.142) | 1.6 (0.26) |
| L = 1 | 34 | 12 | 316 576 888 | 91 | 39 305 490 (0.124) | 18.1 (0.20) |
| L = 2 | 30 | 34 | 467 566 850 | 209 | 56 532 101 (0.121) | 20.5 (0.098) |
| L = 2 | 34 | 728 | 8 997 673 384 | 2859 | 1 024 975 436 (0.114) | 442 (0.155) |

(The slab.cpp seconds are those in its logs, 4 threads on the machine that ran them; the bidirectional runs are on this container, 4 threads, with the D5 job idle.)

## E1. Parity budget (`-par` in `enum_dmon.cpp`; a search test, pure bound)

Every step changes the parity of x + y + z. The R1 - 1 vertices that are still to come (the head is placed, the last vertex is the root) alternate in parity, beginning with the parity opposite to the head's: ceil((R1 - 1)/2) of one parity and floor((R1 - 1)/2) of the other. Every pending single-site obligation needs its own such vertex (distinct sites are distinct vertices);
so the number of distinct single sites of each parity may not exceed the number of future vertices of that parity. Output identical to `enum`; nodes (`-stair -tourcap 3`): n = 24: 15 886 694 -> 15 883 814 (0.9998); n = 26: 76 302 828 -> 76 286 779 (0.9998); with `-aotc -aotm -aote`: 5 065 015 -> 5 064 364 and 20 044 495 -> 20 041 901 (0.9999). No gain: the tour and spanning-tree tests already kill the prefixes where many sites are pending.

## E3. More height functions (target: nontrivial knots)

The condition of `-bridge 2` (every polygon of a nontrivial knot has at least two local maxima along every generic height function) in `enum.cpp` costs nothing in the search (n = 24: 15 886 694 -> 15 886 304 nodes, n = 26: 76 302 828 -> 76 302 597) and removes no survivor (there are no unknotted survivors up to n = 26).
Leaf test on the n = 38 survivors (`check/heights_unknot.py`, `out/n38_stair.rigorous.txt`: 2251 unknots among 18 945 words): the 3 axes, the 13 directions (3 axes, 6 face diagonals, 4 body diagonals), these with 5 generic tilts each, and 200 random directions: **0 of the 2251 unknots has a height function with a single maximum, and no knotted word is flagged**. The unknotted survivors are not in 1-bridge position in any direction tried (they are the unknots that the flip search cannot shrink within its state limit); more height functions do not help.

## E11. Child ordering (`-order`)

Children in order of increasing slack (R - 1 - distance to the origin): node counts and output identical to `enum` (n = 24: 15 886 694; n = 26: 76 302 828). Timing on a loaded machine (2 threads next to the arc job) was not meaningful; not re-measured.

## D5. Knotted 19-edge arcs and the composites at n = 40 (a completeness device)

**What is computed.** `arcknot 19` (now with `-part R M`, parts verified to add up to the whole at L = 14 and 15) enumerates every self-avoiding walk b with 19 edges in the half-space z >= 0 that starts and ends on the level z = 0 (A != B), has no U-turn, and has L + d(A, B) >= 22; it forms the closure C(b) (the edge down, a monotone path in the level z = -1, the edge up) and discards the closures with exactly one local maximum on some axis (they are unknotted, 1-bridge curves);
the others are passed to `unknot_cert`, which shrinks a closure to the unit square by U-turn removals and corner flips (isotopies). 64 parts (`out/dmon/arc19/part*_64.{left,log}`; parts 0 to 11 on the container, 12 to 63 by GitHub Actions run 44612872108 with `arc19-enum.yml`):

| walks ending on level 0 | tested (L + d >= 22) | one local maximum on some axis | passed to unknot_cert | shrunk to the square | **left over** | bad words |
|---|---|---|---|---|---|---|
| 15 199 414 591 | 14 840 000 590 | 14 667 287 422 | 172 713 168 | 172 712 208 | **960** | 0 |

The 960 left-over closures all reduce to polygons with 24 edges (final length 24 for every one), and the knot type of each closure is a trefoil (identified with `identify6.classify`, chirality included): **480 right-handed and 480 left-handed**. So the knotted 19-edge arcs without a U-turn are exactly these 960 (each begins and ends with a vertical step; the set is closed under the 8 symmetries of the horizontal plane and under reversal), and the closure of each has 24 edges (d = 3), so it is a shortest trefoil polygon with a 3-edge level.
Lemma 4 says that there is none with 18 edges or fewer; this is the 19-edge list that its "sharpness" remark (7072 trefoils) announced.

**Gluing** (`check/arc19_glue.py`). For two knotted arcs b, c with the same displacement B - A, the polygon is b, the edge B -> B - e_z, the reflection of c in the plane z = -1/2 traversed back to A - e_z, and the edge up: 19 + 19 + 2 = 40 edges. There are 12 displacement classes (eight of 118 arcs and four of 4 arcs), 111 456 ordered pairs, **55 728 distinct polygons** (up to translation and reading; `out/dmon/arc19/glued40.txt`).
Knot types, from the types of the two closures, with the rule checked on 300 randomly chosen glued polygons by direct identification (it is a function of the two closure types): same chirality of the closures gives 3_1#-3_1 (the square knot), opposite chirality gives 3_1#3_1 (the granny; right- or left-handed): 45 536 square, 5096 right-handed granny, 5096 left-handed granny. **No other knot type occurs.**
Cross-check (`check/arc19_witness.py`) with the five composite and prime witnesses of `out/witness40.txt`: 3_1#3_1 and 3_1#-3_1 each have a twice-crossed plane with two levels on each side, and each (in some symmetric image) is in the glued set; 6_1, 6_2, 6_3 have no such plane and are not in it.

**What n = 40 completeness needs, in full.**

*Definitions.* A *half-space arc* is a self-avoiding lattice walk b from A to B (A != B) with all vertices at z >= 0 and A, B at z = 0. Its *closure* C(b) is b, the edge from B down to B - e_z, a shortest lattice path in the level z = -1 to A - e_z, and the edge up to A (a polygon with |b| + d(A, B) + 2 edges, d = Manhattan distance of A and B);
the ball-arc pair of b in the half-space z >= 0 is *knotted* if and only if C(b) is a non-trivial knot (PROOF.md section 2b; any two closing paths below the level z = 0 are isotopic there). A *twice-crossed plane* is a mid-plane H (one coordinate equal to p + 1/2) crossed by exactly two edges of the polygon.

**Proposition (D5).** Let P be a shortest polygon, with n = 40 edges, of a knot type K, and let H be a twice-crossed plane of P with at least two occupied levels on each side. Then, after a symmetry of the lattice that maps H to z = -1/2, P is one of the 55 728 polygons of `glued40.txt` (up to translation and reading), made of two of the 960 knotted 19-edge arcs.

*Proof.* The two edges across H are A'A and B'B, with A, B above H and A', B' below. Let b be the arc of P from A to B above H and a the arc from B' to A' below H; |P| = |a| + |b| + 2. After the symmetry, b is a half-space arc as defined above (b lies in z >= 0 and A, B are on the level z = 0, the level next to H), and the reflection of a in H, called a*, is a half-space arc too, from A to B (reflect z -> -1 - z and read it backwards), with the same displacement B - A as b.
(1) *Both ball-arc pairs are knotted.* Suppose the pair of b is unknotted. Let b' be a shortest lattice path from A to B in the level of A and B. The arc A'A, b', BB' is unknotted in the half-space (it bounds a disk with its projection to H), and the level of A, B contains no vertex of a. Replacing b by b' gives a polygon of type K (two unknotted arcs in a ball with the same end points are isotopic relative to the boundary) with |P| - |b| + d(A, B) edges. As P is shortest and |b| >= d(A, B), |b| = d(A, B), so b is a shortest lattice path between two points at the same height: it has no step across levels and lies in the level next to H,
so the vertices of P above H all lie in one level, contrary to the assumption of two occupied levels. (This is the first half of the proof of Lemma 3, valid for every knot type, PROOF.md section 2a.) The same for the pair of a, by symmetry.
(2) *No U-turn.* b and a are sub-paths of the shortest polygon P, so neither contains three consecutive steps c, c', -c (Lemma 1 with k = 1).
(3) *Length.* By Lemma 4 (PROOF.md section 2b, computer proof: half-space arcs with at most 18 edges and no U-turn are unknotted) and (1), (2): |b| >= 19 and |a| >= 19. Since |a| + |b| + 2 = 40, |a| = |b| = 19.
(4) *The list.* Let b be a 19-edge half-space arc without U-turn whose pair is knotted. If 19 + d(A, B) < 22, then C(b) has fewer than 24 edges, hence is unknotted (the smallest knot, the trefoil, needs 24 edges: Diao93, and PROOF.md section 5), so 19 + d >= 22, which is the condition used by `arcknot`. By the enumeration, C(b) has at least two local maxima along every axis (else it is a 1-bridge curve, unknotted), and `unknot_cert` does not shrink it to the square (else it would be unknotted);
so b is in the list of 960 (up to the symmetries of the half-space; the list is closed under them). The same holds for a*.
(5) *Gluing.* P is the polygon b, B -> B - e_z, a read from B' to A', A' -> A, i.e. the polygon of `check/arc19_glue.py` for the pair (b, a*): both are in the list, with the same displacement. []

*Consequence for the search at n = 40.* Let P be a shortest polygon of a knot type K with Len(K) = 40, in the normal form of PROOF.md. If every mid-plane with two occupied levels on each side is crossed at least 4 times, then P passes every test of `-stair` and its type is in the `-stair` output (PROOF.md section 2b: this part uses the corollary and the first half of Lemma 3 only, no primeness); otherwise P is one of the glued polygons. So the knot types with Len = 40 are exactly the types in the `-stair` output at n = 40, together with 3_1#3_1 and 3_1#-3_1 (the only types of the glued polygons; the witnesses of `out/witness40.txt` show Len = 40 for both).

**Completeness at n = 42 (what the D5 argument gives, and what has to be computed).**

**Proposition (D5 at n = 42).** Let P be a shortest polygon with n = 42 edges of a knot type K, and H a twice-crossed plane of P with at least two occupied levels on each side. With b and a as in the proof above (after a symmetry mapping H to z = -1/2, b in z >= 0 and a* the reflection of a): steps (1) and (2) hold unchanged (both ball-arc pairs are knotted, no U-turn), so by Lemma 4 |a|, |b| >= 19, and |a| + |b| = 42 - 2 = 40 leaves exactly the splits
**(|b|, |a|) in {(19, 21), (20, 20), (21, 19)}**. Hence b and a* are knotted half-space arcs with 19, 20 or 21 edges, without U-turn, with the same displacement B - A, and P is the glued polygon (b, a*) of one of the three kinds: 19 + 21, 20 + 20, 21 + 19 (the last is the first with the roles of the two sides exchanged, which is a symmetry of the lattice: reflection in H).
*The list for each length L.* A walk b with L edges is a knotted arc only if its closure has at least 24 edges (L + d + 2 >= 24, i.e. L + d >= 22) and C(b) has two local maxima on every axis and is not shrunk to the square by `unknot_cert`; so the list of knotted arcs with L edges is the left-over of `arcknot L` | `unknot_cert` (L = 19: 960 arcs, all trefoil closures, computed; L = 20 and L = 21: `ci/arc19_request.json`, 128 and 256 parts, by `arc19-enum.yml`, written to `out/dmon/arc20/` and `out/dmon/arc21/`).
*Gluing and types.* As for 19 + 19: for equal displacement, glue the 19-arcs with the 21-arcs and the 20-arcs with each other, and identify the type of every glued polygon from the types of the two closures (Alexander polynomials multiply; chirality from `identify6`), the rule being checked on a sample by direct identification. The knot types that occur are then the types of the shortest polygons of length 42 that have a twice-crossed plane.
*The rest.* If every mid-plane with two occupied levels on each side is crossed at least 4 times, P passes every test of `-stair` (PROOF.md section 2b, corollary and consequence for the search: the argument is the same for any n, the only length-dependent step is the use of Lemma 4 for the arcs, which is replaced by the proposition above). So **the knot types with Len = 42 are the types in the `-stair` output at n = 42 together with the types of the glued polygons of the three splits.**
(The condition "the unconfined search is complete for N <= 48" is a property of the program only: the box |x|, |y| <= 27, z <= 24 contains every polygon with at most 48 edges; `enum_bidir` accepts N <= 48 in the unconfined mode.)

**The single-ended version of the tail finding (`-rootnb` in `enum_dmon.cpp`, a search test, pure bound).** The vertex before the root, v_{n-1}, is a free neighbour of the root among the three above it (e, n, u: DMON3), the direction m = v_{n-1} - v_n must exceed the first letter (DMON4: the reverse of the last letter is greater than the first), so the remaining walk of R1 steps from the head must reach one of these (up to three) points in R1 - 1 steps: min over the admissible free m of |head - (root + m)| + 1 <= R1.
Instead of |head - root| <= R1 of `enum`. Output identical; nodes (`-stair -tourcap 3`): n = 24: 15 886 694 -> 14 980 645 (0.943); n = 26: 76 302 828 -> 71 549 630 (0.938); with `-aotc -aotm -aote`: 5 065 015 -> 4 722 237 (0.932) and 20 044 495 -> 18 488 147 (0.922).
So this test alone gives only about 6 to 8 %. The much larger gain of one tail letter in `enum_bidir` (a factor 2.5 at n = 30) comes from the tail letter being a real step: the curtain and corner obligations that involve the last letters, the DMON4 test, and the distance to a concrete vertex are all checked from the start, and the first letters of the head constrain the last ones.
