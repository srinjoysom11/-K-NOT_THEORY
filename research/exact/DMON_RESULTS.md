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
