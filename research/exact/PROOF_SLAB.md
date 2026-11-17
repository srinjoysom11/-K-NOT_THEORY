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
  plane with knotted arcs on both sides needs at least 2 (m + 1) + 2 = 2 m + 4 edges. For
  L = 1 and L = 2 there is no horizontal mid-plane with two occupied levels on each side, so
  vertical planes are the only ones that matter. **Done for L = 1 with m = 20 (section 1a)**:
  in the 1-slab the output is complete for all knot types for n <= 42.

## 1a. Short arcs in a half-slab are unknotted (L = 1) [C]

Let b be a self-avoiding walk with no U-turn in the half-slab x >= 0, 0 <= z <= 1, with end
points A != B on the wall level x = 0. Its closure C(b) (b, one edge out of the half-slab at
each end, and a shortest path between them in the level x = -1 that stays in 0 <= z <= 1) is a
polygon in the 1-slab with |b| + d(A, B) + 2 edges, and the ball-arc pair of b is knotted
exactly when C(b) is knotted (the region x < 0 of the slab is a ball, and any two closing paths
in it are isotopic there).

**Lemma 4' (half-slab, L = 1).** If b has at most 20 edges, C(b) is unknotted.

*Proof (computer).* If |b| + d + 2 < 26 then C(b) is unknotted, since every knotted polygon in
the 1-slab has at least 26 edges (section 4: no survivors for n <= 24, complete for all knot
types). Otherwise |b| + d >= 24. `arcslab L -w 1 -minsum 24` lists all such b (in its
coordinates the wall is z = -1/2 and the slab direction is y) and counts local maxima of the
closure along each axis; the closures with two or more maxima on every axis go to
`unknot_cert`, which shrinks each to the square. `./run_arcslab.sh 1 24 12 ... 20`, logs in
`out/arcslab/w1_L<L>.log`, leftovers (none) in `.left`:

| L | walks tested (L + d >= 24) | one local maximum on some axis | shrunk to the square | left over | seconds |
|---|---|---|---|---|---|
| 12 | 28 | 28 | 0 | 0 | 0 |
| 13 | 2 034 | 2 034 | 0 | 0 | 0 |
| 14 | 42 840 | 42 840 | 0 | 0 | 0 |
| 15 | 416 484 | 416 484 | 0 | 0 | 0 |
| 16 | 2 350 688 | 2 350 688 | 0 | 0 | 2 |
| 17 | 10 214 446 | 10 186 620 | 27 826 | 0 | 11 |
| 18 | 39 244 808 | 38 944 130 | 300 678 | 0 | 44 |
| 19 | 139 909 788 | 138 038 174 | 1 871 614 | 0 | 174 |
| 20 | 473 508 342 | 464 202 880 | 9 305 462 | 0 | 679 |

For L <= 11, L + d >= 24 is impossible. []

**Corollary.** In the 1-slab a slab-shortest polygon with a twice-crossed vertical plane and a
knotted arc on each side has at least 21 + 21 + 2 = 44 edges. So `slab n -slab 1 -stair` is
complete for all knot types for n <= 42, and n_{1,3_1 # +-3_1} >= 44 as soon as the 1-slab runs
to n = 42 show no composite. At n = 44 (square knot, Monte Carlo value 44) the only extra
polygons are two knotted 21-edge arcs glued across a wall; `check/arcslab_pairs.py` lists the
knotted 21-edge arcs (`./run_arcslab.sh 1 24 21`) with their end points and chirality and decides
which composites such gluings can give.

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
| 28 | 1.1e8 | 60 | 3_1 |
| 30 | 4.7e8 | 34 | 3_1 |

So every non-trivial knot other than the trefoil needs at least 32 edges in the 2-slab
(n_{2,4_1} >= 32; Monte Carlo value 32).

(Further results are appended as `queue_slab.sh` finishes them.)

### Slabs in which the bulk minimum is attained [C]

If n = Len(K) then n_{L,K} = n exactly when some shortest polygon of K has height <= L, and the
shortest polygons of K in the L-slab are the shortest polygons of K in space of height <= L.
By the census argument of PROOF.md (flip closure of the output of the unconfined search, then
all 48 symmetries) they can be counted from the unconfined runs:
`python3 check/slab_census.py out/n36_prime.txt --alex "2,-3,2" --all48` and likewise for the
others. Counts are up to translation, both chiralities together:

| K | Len(K) | height 2 | <= 3 | <= 4 | all | published, per chirality, L = 2, 3, 4 |
|---|---|---|---|---|---|---|
| 3_1 | 24 | 304 | 3 320 | 3 328 | 3 328 | 152, 1 660, 1 664 |
| 4_1 | 30 | 0 | 2 720 | 3 648 | 3 648 | (n_{2} = 32), 2 720, 3 648 (achiral: not doubled) |
| 5_1 | 34 | 1 520 | 2 720 | 6 592 | 6 672 | 760, 1 360, 3 296 |
| 5_2 | 36 | 1 440 | 49 584 | 110 672 | 114 912 | 720, 24 792, 55 336 |

Every published count is reproduced exactly (twice the published value for the chiral knots).
With Len(3_1) = 24 [Diao93], Len(4_1) = 30, Len(5_1) = 34 ([Scharein09], and the unconfined
search here) and Len(5_2) = 36 (PROOF.md, Lean-checked) this gives:

* n_{L,3_1} = 24 for all L >= 2;
* n_{L,4_1} = 30 for all L >= 3, and n_{2,4_1} >= 32;
* **n_{L,5_1} = 34 for all L >= 2**, with 1 520, 2 720, 6 592 shortest polygons for L = 2, 3, 4;
* **n_{L,5_2} = 36 for all L >= 2**, with 1 440, 49 584, 110 672 shortest polygons for L = 2, 3, 4
  (and 114 912 in space).

Before this only n_{1,3_1} = 26 had a proof; the values above were Monte Carlo estimates.


## 5. Upper bounds: explicit polygons [C]

Upper bounds need only an explicit polygon. `anneal_soft.sh HS SEEDS "name:braid;..."` builds a
start polygon in the 1-slab from a braid word (`braid2slab.py`: strands along rows of level 0,
over-crossings through level 1, nested closure loops) and anneals it with `bfacf_soft.c`. Every
polygon it records lies in the HS-slab; BFACF moves never change the knot type, but the type is
checked anyway: `python3 check/slab_witnesses.py out/slab/witness_L1.txt 1` verifies
self-avoidance, length, height and knot type (a diagram with <= 6 crossings, then the Alexander
polynomial; granny and square are separated by the Kauffman bracket polynomial f(A), which is
palindromic only for the square knot). Shortest checked polygons, 1-slab
(`out/slab/witness_L1.best.txt`):

| K | length | published Monte Carlo n_{1,K} |
|---|---|---|
| 5_2 | 42 | 42 |
| 6_1 | 48 | 48 |
| 6_2 | 48 | 48 |
| 6_3 | 50 | 50 |
| 3_1 # -3_1 (square) | 44 | 44 |
| **3_1 # 3_1 (granny)** | **46** | **48** |

The 46-edge granny knot in the 1-slab,

    sseuennwdnwwwwunneesssdwwwnneeussseeedennuwwsd

reduces to a 6-crossing diagram that is the connected sum of two trefoils (crossings on
strands 1-7 and on 8-11, 0), with f(A) = A^8 + 2A^16 - 2A^20 + A^24 - 2A^28 + A^32, the square
of the trefoil's polynomial (granny, not square). So **n_{1,3_1#3_1} <= 46**, below the Monte
Carlo value 48 of arXiv:1204.6674. The lower bound is 44 or more once the 1-slab runs to n = 42
show no composite; whether it is 44 or 46 is decided by the run n = 44 (complete except for
polygons with a twice-crossed wall and two knotted 21-edge arcs) and `check/arcslab_pairs.py 1 21`.

**Remark (BFACF in the 1-slab) [observation].** BFACF confined to the 1-slab does not seem to be
irreducible on knot types, or it mixes so slowly that in practice it is not. From the braid
start, 4_1 always settled at 44 edges (dozens of seeds, excursions to more than 400 edges and
high phases of 2 * 10^6 moves), while from a 36-edge census polygon it always came back to 36.
Allowing two more levels with a penalty per vertex above level 1 (`bfacf_soft.c`, recording
only polygons inside the 1-slab) reaches 36 from the same start at once. Irreducibility of
BFACF in slabs does not seem to be proved in the literature (arXiv:1204.6674 cites the bulk
theorem of Janse van Rensburg and Whittington). This is a plausible reason why the published
value for the granny knot is too high, and a reason to check every Monte Carlo slab value
against exact runs.

**Knots to 8 crossings (1-slab), against the published table.** The published values for all
knots to 8 crossings and eight composites are in `data/slab_published.txt` (arXiv:1204.6674,
Tables 5 and 7). Starting from the diagram seeds of `research/data/seeds.json` (height 1
already) and from braid words for the composites, `anneal_soft.sh 1 ...` finds polygons of the
published length for 7_1-7_6, 8_1-8_5, 8_7-8_9, 8_13, 8_17, 8_19-8_21 (4 seeds each; the
others are still above it) and nothing shorter for any prime knot. Composites are different:
the granny knot is the case found shorter (46 against 48). Checks:
`python3 check/slab_witnesses8.py out/slab/witness_L1.txt 1 > out/slab/witness_L1.best.txt`
(SnapPy simplification to <= 8 crossings, then the Alexander/Jones fingerprint, which separates
all knots of crossing number <= 8 including the composites), then
`python3 check/slab_compare.py out/slab/witness_L1.best.txt 1`.

**Structure of the short composite polygons.** All three 46-edge granny polygons found split
along a twice-crossed vertical wall into two knotted arcs of 21 and 23 edges whose closures are
trefoils of the same handedness; the 44-edge square knots split into 21 + 21 with opposite
handedness. Since knotted half-slab arcs have at least 21 edges (section 1a), the question
"granny at 44?" is a question about the 21-edge trefoil arcs alone (`check/arcslab_glue.py 1 21 21`).
