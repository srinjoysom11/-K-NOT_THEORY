# Shortest lattice knots in a slab: what `slab.cpp` proves

Labels as in PROOF.md: [E] established with source, [C] computed here, [J] proposal.
This file only records what changes when the polygon is confined to a slab; the lemmas and
the search are those of PROOF.md.

## 0. Setting and what is known

The *L-slab* is the set of lattice points with 0 <= z <= L (L + 1 levels). For a knot type K,
n_{L,K} is the least number of edges of a polygon of type K inside the L-slab. Reflection in
x keeps the slab, so n_{L,K} = n_{L,mirror K}, and knot types are taken up to mirror image as
before. n_{L,K} is non-increasing in L and equals Len(K) for large L.

* [E] n_{1,3_1} = 26 is proved (Ishihara, Scharein, Diao, Arsuaga, Vazquez, Shimokawa,
  "Bounds for the minimum step number of knots confined to slabs in the simple cubic lattice",
  J. Phys. A 45 (2012) 065003). As far as I can find it is the only slab value with a proof.
* [E, numerical] Gasumova, Janse van Rensburg, Rechnitzer, "Lattice knots in a slab",
  arXiv:1204.6674, give Monte Carlo (BFACF) values of n_{L,K} and the number of shortest
  polygons for knots up to 7 crossings and some composites. These are upper bounds with
  counts, not theorems. The ones used below (counts are per chirality for chiral knots):

| K | n_{1,K} | n_{2,K} | n_{3,K} | polygons at L = 1, 2, 3, 4 |
|---|---|---|---|---|
| 3_1 | 26 | 24 | 24 | 36, 152, 1660, 1664 |
| 4_1 | 36 | 32 | 30 | 1480, 6064, 2720, 3648 |
| 5_1 | 38 | 34 | 34 | 72, 760, 1360, 3296 |
| 5_2 | 42 | 36 | 36 | 6240, 720, 24792, 55336 |
| 6_1 | 48 | 42 | 40 | 8036, 12704, 1168, 3000 |
| 6_2 | 48 | 42 | 40 | 2208, 720, 2984, 14632 |
| 6_3 | 50 | 44 | 40 | 1248, 7536, 592, 3408 |
| 3_1 # 3_1 | 48 | 40 | 40 | 2430, 8, 7800, 10492 |
| 3_1 # -3_1 | 44 | 40 | 40 | 144, 448, 56616, 78576 |

## 1. The lemmas inside a slab

Call a polygon *slab-shortest* if it lies in the L-slab and no polygon of the same knot type
in the L-slab has fewer edges.

**Bounding box.** A corner flip replaces v by v' = p + q - v with p, q the neighbours of v.
p and q differ from v in one coordinate each, in different coordinates, so every coordinate of
v' equals the same coordinate of p or of q. A U-turn removal (steps a, c, -a replaced by c)
adds no new vertex. So neither move leaves the bounding box of the polygon, and in particular
neither leaves the slab.

**Lemma 1 (curtain) holds for slab-shortest polygons.** The new path g' = g - a consists of
the points v_j - a. If a is horizontal they have the heights of the v_j. If a is vertical,
g lies in one level and g' lies in the level of v_0 = v_1 - a, which is a vertex of P. In both
cases g' is in the slab, so the shorter polygon is in the slab.

**Lemma 2 (pushed-down form) holds with the axis rule (#y-steps) <= (#x-steps) only.**
Let M' be the set of slab-shortest polygons of K (or its mirror) with at most as many y-steps
as x-steps; it is not empty (exchange x and y) and closed under corner flips (bounding box).
Minimise Psi and then Psi2 over M' as before; the proof of (a) and (b) is unchanged. The
z-axis cannot be exchanged with the others, so the condition (#z-steps) <= (#y-steps) is
dropped.

**Lemma 3 (plane crossing) holds for slab-shortest polygons of prime knots.** The replacement
path b' is a shortest lattice path from A to B inside the level next to H that contains A and
B. If H is horizontal that level is one level of the slab. If H is vertical, the heights of
the points of b' lie between those of A and B. So the new polygon is in the slab and the
argument goes through: on one side of a twice-crossed mid-plane the polygon is a staircase in
the level next to the plane. The `-stair` rule is the same statement at an outermost plane.

**Composite knots.** As in PROOF.md section 2a/2b: a twice-crossed mid-plane with two occupied
levels on each side and no staircase side has a knotted arc on both sides, and by the
Corollary to Lemma 4 the polygon then has at least 40 edges (a slab-shortest polygon has no
U-turn by Lemma 1, and Lemma 4 is about all arcs in a half-space). So:

* for n <= 38 the output of `slab n -slab L -stair` is complete for **all** knot types;
* for n >= 40 it is complete for **prime** knot types. For composite knots at n >= 40 one
  needs an arc lemma for the half-slab (arcs in x >= 0, 0 <= z <= L, with both ends on x = 0):
  if every such arc with at most m edges and no U-turn is unknotted, a twice-crossed vertical
  plane with knotted arcs on both sides needs 2 m + 4 edges. Not computed yet [J: for L = 1 one
  needs m = 20 to make n = 42 complete, which would settle the square knot at 44].

**Canonical position** (PROOF.md section 3) is unchanged: the least vertex in (z, y, x) order
is the origin, so the polygon lies in 0 <= z <= (its height), and the search only visits
points with z <= L.

**Completeness.** With these changes the proof of the Proposition in PROOF.md section 4 goes
through word for word: if n_{L,K} = n for a prime knot K (any knot if n <= 38), the output of
`slab n -slab L -stair` contains a polygon of type K or its mirror. Rule 4 there (return to
the origin, visit the required points) is a statement about walks and does not involve the
slab. The flip search at a closed polygon stays in the slab (bounding box), and a U-turn found
there gives a shorter polygon in the slab.

**Census.** The argument for Lemma 2 can be made inside one flip class (the set of polygons
reachable from a given one by corner flips): the class is closed under flips, the numbers of
steps per axis are constant on it, and Psi, Psi2 have a minimum on it. So for a prime knot K
(any knot if n <= 38) and n = n_{L,K}, every flip class of slab-shortest polygons contains,
after exchanging x and y and reversing the direction if necessary, a word of the output.
Hence: the set of all slab-shortest polygons of K and its mirror is the closure of the output
words of that knot type under corner flips, followed by the 16 symmetries of the slab (signed
permutations of the axes fixing the z-axis). `check/slab_census.py` computes this and counts
polygons up to translation, split by height, so one run at length n gives the counts for all
slabs in which n is the minimum.

## 2. The program

`slab.cpp` is `enum.cpp` with these changes and nothing else (diff it to see):

* option `-slab L`: points with z > L are not allowed;
* with `-slab`, the axis rule at a closed polygon is (#y) <= (#x) only, and the pruning on the
  axis counts during the search is "2 (#y) + (#z) <= n" and "(#y) <= (#x) + remaining - 1";
* lengths up to 52 (the grid allows it).

Without `-slab` it behaves as `enum.cpp` (checked: same survivors at n = 24 and n = 26).

## 3. Checks [C]

* **Plain counts.** `slab n -slab L -plain -noaxes` (no pruning, all closed polygons in
  canonical position) against a brute-force Python count of polygons in the L-slab up to
  translation, written separately: L = 1: 135, 1026, 8278, 70954 and L = 2: 205, 2248, 26030,
  306264 for n = 8, 10, 12, 14. Equal.
* **Trefoil census.** Flip closure and 16 symmetries of the output at n = 24 (L = 2, 3, 12)
  and n = 26 (L = 1): 304, 3320, 3328 and 72 polygons. The published numbers per chirality
  are 152, 1660, 1664 and 36. Equal (twice the published value, both chiralities).
* **Inclusion.** The 78 survivors of `enum 24` all occur among the survivors of
  `slab 24 -slab 12`, which has the weaker axis rule.
* Further census comparisons are listed with the results below; each one tests the search
  against an independent Monte Carlo count.

## 4. Results [C]

All runs: `slab n -slab L -stair -tourcap 3`, logs and survivors in `out/slab/L<L>_n<n>.*`,
knot types by `identify_rigorous.py` (must end `ALL RESOLVED`).

### 1-slab

| n | nodes | survivors | knot types |
|---|---|---|---|
| 22 | 2.2e5 | 0 | |
| 24 | 6.2e5 | 0 | |
| 26 | 2.2e6 | 8 | 3_1 |
| 28 | 7.2e6 | 8 | 3_1 |
| 30 | 2.5e7 | 12 | 3_1 |
| 32 | 9.1e7 | 10 | 3_1 |
| 34 | 3.2e8 | 12 | 3_1 |
| 36 | 1.2e9 | 66 | 3_1 (16), 4_1 (38), 0_1 (12) |

With the lemmas above and the correctness of the program this gives:

* n_{1,3_1} = 26 (new proof of the theorem of Ishihara et al.), with exactly 72 shortest
  polygons (36 per chirality);
* every non-trivial knot other than the trefoil needs at least 36 edges in the 1-slab;
* **n_{1,4_1} = 36.** Lower bound: no 4_1 among the survivors for n <= 34. Upper bound: the 38
  words of `out/slab/L1_n36.txt` with verdict 4_1 are explicit polygons. The census
  (`python3 check/slab_census.py out/slab/L1_n36.txt --alex "1,-3,1"`) gives a flip closure of
  1140 words and **1480** polygons, equal to the Monte Carlo count of arXiv:1204.6674.
* The 12 unknotted survivors at n = 36 are polygons from which no sequence of corner flips
  reaches a U-turn (also not when the flips may leave the slab, up to 200 000 states,
  `unknot_cert`): the search keeps them because it only removes polygons it can shorten.

`./slab_report.sh` prints one line per finished run (nodes, survivors, knot types).

### 2-slab

| n | nodes | survivors | knot types |
|---|---|---|---|
| 22 | 1.6e6 | 0 | |
| 24 | 6.3e6 | 20 | 3_1 |
| 26 | 2.6e7 | 74 | 3_1 |

(Further results are appended as `queue_slab.sh` finishes them.)
