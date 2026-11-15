# Why the enumeration proves lower bounds on Len(K)

Labels: [E] established with source, [C] computed here, [J] proposal. Everything in sections 1-4
is elementary and proved in full here, so the only inputs from the literature are the upper
bounds (explicit polygons) and standard knot theory (an arc pushed across an embedded disk
whose interior misses the knot gives an isotopic knot).

Throughout, a *polygon* is a closed self-avoiding walk in Z^3 with unit steps, n is its number
of edges, and knot types are taken **up to mirror image** (a reflection of Z^3 maps polygons
of K to polygons of the mirror of K, so Len(K) = Len(mirror K)). Steps are written
e, w = +x, -x; n, s = +y, -y; u, d = +z, -z. A polygon is *shortest* if no polygon of the same
knot type has fewer edges. The 4-edge square is the only shortest unknot and is excluded
below (n >= 6).

## 1. Curtain lemma

**Lemma 1.** Let P be a polygon with n >= 6 edges that contains consecutive vertices
v_0, v_1, ..., v_{k+2} (k >= 1) with v_1 = v_0 + a, v_{k+2} = v_{k+1} - a for a unit vector a,
and with all k steps from v_1 to v_{k+1} perpendicular to a. If none of the k - 1 points
v_j - a, 2 <= j <= k, is a vertex of P, then there is a polygon of the same knot type with
n - 2 edges.

*Proof.* Let g be the path v_1, ..., v_{k+1}; it lies in a plane perpendicular to a and is
self-avoiding. Let C be the union of the k unit squares with corners
v_j, v_{j+1}, v_{j+1} - a, v_j - a (1 <= j <= k). C is an embedded disk (the product of the arc g
with a unit interval). Its boundary consists of the edge v_0 v_1, the path g, the edge
v_{k+1} v_{k+2}, and the translated path g' = g - a from v_0 to v_{k+2}. The first three lie on P.

A unit lattice edge meets a unit lattice square only in a corner of the square or in one of
its four sides (the open square contains no lattice point, and an edge perpendicular to the
square's plane meets that plane in a lattice point). The lattice points of C are the v_j and
the v_j - a, 1 <= j <= k+1. By hypothesis the points v_j - a, 2 <= j <= k, are not on P, so P
contains no rung v_j, v_j - a with 2 <= j <= k and no edge of g' (each edge of g' has an end
point v_j - a with 2 <= j <= k when k >= 2; when k = 1 the single edge of g' is v_0 v_3, and if
it were an edge of P then P would be the 4-edge square). Hence P meets C exactly in the three
boundary sides, and the interior vertices of g' are not on P. Replacing those three sides by
g' is an isotopy of P across the disk C. The result is a self-avoiding lattice polygon with
(k + 2) - k = 2 fewer edges. []

For k = 1 this is the BFACF move of type -2 (a "U-turn" a, b, -a is never present in a shortest
polygon).

**Consequence (curtain test).** In a shortest polygon, for every pair of cyclically
consecutive steps along one axis that point in opposite directions, with k >= 1 steps between
them, at least one of the k - 1 points "below" the interior of the stretch between them is a
vertex of the polygon.

## 2. Pushed-down normal form

A *corner flip* at a vertex v with non-collinear neighbours p, q replaces v by v' = p + q - v,
provided v' is not a vertex. The unit square p, v, q, v' then meets the polygon only in the
edges pv and vq, so the flip is an isotopy; it keeps the number of edges, and it keeps the
number of steps along each axis (two consecutive steps are exchanged).

**Lemma 2.** Let K be a knot type and let M' be the set of shortest polygons of K (or its
mirror) with (#z-steps) <= (#y-steps) <= (#x-steps). M' is not empty (permute the axes). Let
Psi(P) = sum over vertices of (z - z_min(P)) and Psi2(P) = sum of (y - y_min(P)), and choose
P in M' minimising Psi and, among those, Psi2 (both are non-negative integers and invariant
under translation, so the minimum exists). Then in P:
(a) for consecutive steps (u, h) or (h, d) with h horizontal, and
(b) for consecutive steps (n, x) or (x, s) with x in {e, w},
the point v' = p + q - v (p, v, q the three vertices of the corner) is a vertex of P.

*Proof.* M' is closed under corner flips. (a) In both cases one neighbour of v, say p, is
directly below v, and v' = p + (q - v) lies at the height of p. If v' were free, the flip gives
P' in M' with the same vertices except v replaced by v'. Since z_v = z_p + 1 > z_min, the vertex
v is not on the lowest level, and z_{v'} = z_p >= z_min, so z_min is unchanged and
Psi(P') = Psi(P) - 1, a contradiction. (b) Here one neighbour p has y_p = y_v - 1, and v' has the
same z as v and y_{v'} = y_p. The flip changes no z-coordinate, so Psi is unchanged, y_min is
unchanged for the same reason as before, and Psi2 drops by 1, a contradiction. []

## 2a. Plane-crossing lemma (prime knots)

**Lemma 3.** Let P be a shortest polygon of a **prime** knot and H a lattice mid-plane
(one coordinate equal to p + 1/2) crossed by exactly two edges of P. Then on one side of H all
vertices of P lie in the level next to H and form a shortest lattice path between their end
points. Hence every mid-plane with at least two occupied levels on each side is crossed by at
least 4 edges (the number of crossings is even).

*Proof.* Let the crossing edges be A'A and B'B with A, B on the same side, let b be the arc of P
from A to B on that side and a the arc on the other side. H together with the point at infinity
is a 2-sphere meeting P in two points, so K is the connected sum of the two ball-arc pairs.
K is prime, so one of them is trivial; say it is the side of b (otherwise exchange the sides).
Two unknotted arcs in a ball with the same end points are isotopic relative to the boundary.
Let b' be a shortest lattice path from A to B inside the level of A and B; the arc A'A, b', BB'
is unknotted in the half-space (it bounds a disk with its projection to H), and that level
contains no vertex of a. So replacing b by b' gives a polygon of type K with
|P| - |b| + d(A, B) edges, where d is the Manhattan distance. As P is shortest and
|b| >= d(A, B), we get |b| = d(A, B): b is a shortest path between two points with the same
height, so it has no step across levels and lies in the level next to H. []

*Use in the search (`-prime`).* For the walk so far, on each axis count the edges across each
mid-plane. Every mid-plane between occupied levels must finally be crossed an even number of
times, at least twice, and at least 4 times if it already has two occupied levels on each
side. Each later step crosses exactly one mid-plane, so the number of crossings still owed,
summed over the three axes, is a lower bound on the number of steps left.

*Use in the search (`-stair`).* The lemma says more about an outermost plane. Let c be the
lowest (or highest) occupied level on some axis, H the mid-plane next to it, and suppose at
least two occupied levels lie on the other side of H. If H is crossed exactly twice, the side
with two levels is not the staircase side, so the vertices in level c form one shortest path:
every stretch of the polygon inside level c is monotone (it never uses two opposite
directions). So if the walk so far has a stretch inside level c that uses two opposite
directions, H needs 4 crossings and not 2. If only two levels are occupied on the axis, H needs
4 crossings when both levels contain such a stretch. The program records such stretches per
level while the walk grows (only stretches of consecutive steps of the walk are examined, so
some are missed, which is safe) and raises the number of crossings owed accordingly.
This stays a lower bound when the walk later goes beyond level c: each new level adds a new
outermost plane that owes 2 crossings, and H still owes at least 2, so the true number owed is
at least the one computed with 4 for H.
Measured [C]: 24 % fewer nodes at n = 24, 22 % at n = 28 (part 0 of 32); the survivors at
n = 24, 26 and 28 (part 0 of 32) are the same words as without it.

*Data [C].* In all 2592 canonical 24-edge trefoils and in the stored polygons of all 249 knots
of the literature table, a mid-plane crossed by only 2 edges occurs only at an outermost gap
(it does occur there in 2592 of 2592 and 248 of 249), never further in. So the lemma is sharp
in this form, and it gives (#steps on an axis) >= 4 (#gaps) - 4, the bounding-box bound of
[Scharein09] Prop. 2, whose proof was never published.

*Composite knots.* The first half of the proof does not use primeness: for any shortest
polygon, if one side of a twice-crossed mid-plane is an unknotted ball-arc pair, that side is a
staircase in the level next to H. So a twice-crossed mid-plane with at least two occupied
levels on each side has a knotted arc on **both** sides. Section 2b shows this needs at least
38 edges. With `-prime` alone the output is complete for prime knot types only; with section 2b
it is complete for all knot types up to n = 36.

## 2b. Short arcs in a half-space are unknotted (composite knots)

Let b be a self-avoiding lattice walk from A to B that stays in the half-space z >= 0 with
A != B on the level z = 0. Its *closure* C(b) is b, the edge from B down to B - e_z, a
shortest path in the level z = -1 to A - e_z, and the edge up to A. C(b) is a polygon with
|b| + d(A, B) + 2 edges (d = Manhattan distance), and the ball-arc pair of b in the half-space
is knotted exactly when C(b) is a non-trivial knot (any two closing paths below the level
z = 0 are isotopic there).

**Lemma 4 [C].** If b has at most 17 edges and no U-turn (three consecutive steps a, c, -a),
then C(b) is unknotted. (For at most 16 edges the U-turn condition is not needed.)

*Proof (computer).* If |b| + d + 2 <= 22 then C(b) has fewer than 24 edges and is unknotted
[E: Diao93; C: section 5, n <= 22]. Otherwise |b| + d >= 22. Up to the 8 symmetries of the
half-space the first step of b is e or u. `arcknot L` lists all such b with L edges and
L + d >= 22 and counts the local maxima of C(b) along each axis. A closed curve with one local
maximum along some direction is unknotted (tilt each level stretch slightly so that the height
function has one maximum and one minimum: a 1-bridge presentation). The closures with at least
two maxima along every axis are passed to `unknot_cert`, which shrinks each one to the 4-edge
square by U-turn removals (Lemma 1, k = 1) and corner flips (section 2). Result:

| L | walks tested (L + d >= 22) | one local maximum on some axis | shrunk to the square | left over |
|---|---|---|---|---|
| 11 | 2 047 | 2 047 | 0 | 0 |
| 12 | 82 757 | 82 757 | 0 | 0 |
| 13 | 883 811 | 883 811 | 0 | 0 |
| 14 | 6 238 626 | 6 238 626 | 0 | 0 |
| 15 | 35 583 605 | 35 567 997 | 15 608 | 0 |
| 16 | 178 187 146 | 177 874 674 | 312 472 | 0 |
| 17 | 820 920 314 | 817 563 786 | 3 356 528 | 0 |
| 16, U-turns allowed | 980 557 389 | 967 162 777 | 13 394 612 | 0 |

For L <= 10 the condition L + d >= 22 cannot hold (d <= L). Logs: `out/arc/arcL.log`.
Independent check (`check/arc_check.py`, Python, written from the definition without reading
the C++): the same numbers of walks tested and the same histograms of maxima for L = 11 to 14;
`check/arc_alexander.py`: all 15 608 closures at L = 15 have Alexander polynomial 1. []

*Sharpness.* Knotted arcs with 19 edges exist: 7072 of the 24-edge trefoils (counted with
their 6 directions) have an outer level that is a 3-edge path, and removing it and the two
edges to it leaves a 19-edge arc. Whether 18 is possible is being computed (`arcknot 18`).

**Corollary.** Let P be a shortest polygon of some knot type and H a mid-plane crossed by
exactly two edges of P with a knotted arc on both sides. Then P has at least 38 edges.

*Proof.* The two arcs are sub-paths of a shortest polygon, so they have no U-turn (Lemma 1).
After a symmetry of the lattice each of them is a walk as in Lemma 4, so each has at least 18
edges, and |P| >= 18 + 18 + 2. []

**Consequence for the search.** Let P be a shortest polygon with n <= 36 edges, of any knot
type, in the normal form of Lemma 2 and in canonical position. By the Corollary and the remark
on composite knots in section 2a, every mid-plane of P with at least two occupied levels on
each side is crossed at least 4 times. That is the only property of P that `-prime` uses beyond
sections 1, 2 and 3. So for n <= 36 the output of `enum n -prime` contains a polygon of every
knot type K (prime or composite) with Len(K) = n.

## 3. Canonical position

Translate P so that its least vertex in the order (z, then y, then x) is the origin, start the
word there, and choose the direction so that the first step is smaller than the reverse of the
last step in the order e < n < u (the two edges at the origin point in two different directions
among +x, +y, +z, because the origin is the least vertex). None of this changes the polygon.

## 4. Completeness of the search

**Proposition.** Fix an even n >= 6. If some knot type K has Len(K) = n, then the output of
`enum n` contains a word of a polygon of type K (or its mirror).

*Proof.* Take P as in Lemma 2 and put it in canonical position (section 3). The program
performs a depth-first search over all self-avoiding walks from the origin that stay among
points greater than the origin in (z, y, x) order, and discards a walk only when one of the
following holds for every closed completion of it with n edges:
1. it contains a U-turn, or a curtain whose test fails (Lemma 1; P is shortest);
2. a corner of type (a) or (b) has v' not a vertex (Lemma 2);
3. the axis counts or the direction rule are violated (choice of P, section 3);
4. it cannot return to the origin in the remaining number of steps, or cannot visit the
   points that 1 or 2 require to become vertices. The tests used are lower bounds on the
   remaining walk in the Manhattan metric (single points; span on each axis; minimum spanning
   tree; an exact search over visiting orders that answers "possible" when it hits its call
   limit), and the fact that a point that must become a vertex needs two neighbours that are
   free, the head of the walk, or the origin.
At a closed polygon the program applies the cyclic versions of 1 and 2 and then a breadth-first
search over corner flips; if a flip sequence reaches a polygon with a U-turn, that polygon and
hence P's candidate is not shortest. When the search hits its state limit the polygon is kept.
P passes every test, so it is printed. []

## 5. From the output to a theorem

Let S(n) be the output for length n. Then:
* If S(n) is empty for all n < m, no knot type has Len < m... except the unknot (Len 4).
* If every polygon in S(n), n <= m, has a knot type in a set T, then every knot type outside T
  has Len > m.
The identification step is the only place where knot invariants enter. For the statements
aimed at here it is enough to (i) compute the Alexander polynomial of each survivor and
(ii) simplify its diagram by Reidemeister moves to at most 5 crossings: the knots with at
most 5 crossings are 0_1, 3_1, 4_1, 5_1, 5_2 and their Alexander polynomials are pairwise
different [E: Rolfsen table].

## 6. What is and is not checked by machine

* The search program itself is not formally verified. Guards: plain counts agree with the
  known numbers of polygons for n <= 16; the output is unchanged across four rewrites of the
  bounds; an independent Python re-check of the survivors (research/exact/check/).
* The hash used in the flip search can only make it miss a reduction (keep more polygons).
* Rule 4's "possible when the limit is hit" and the state limit both err on the side of
  keeping polygons.
