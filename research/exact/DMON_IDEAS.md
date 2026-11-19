# Five new devices (DMONs and search tests) for the normal-form search (18 Nov 2026)

Naming (paper/len52.tex, "The DMON tests"; DMON = Dynamic Midwalk Obligation Neutralizer):
DMON1 closed walk, DMON2 self-avoiding, DMON3 lowest start, DMON4 direction of travel, DMON5 sorted
axes, DMON6 curtains, DMON7 corners; the completeness theorem of the search is the PanDMONium theorem.
The search additionally uses tests that never discard a word passing the DMON tests (return distance,
span bound, exact tour with cap, MST bound, "a site needs two free neighbours", leaf flip-reduction),
and `-prime` / `-stair` (plane-crossing lemma, PROOF.md Lemma 3) with Lemma 4 for completeness.
Below, D1 is a new DMON (a stronger DMON6), D2 and D3 are new search tests, D4 is a condition valid for
a declared target class, and D5 is a completeness device. Further ideas E1-E8 (parity budget, group
MST, diagonal height functions, mirror halving, GC variants, stronger leaf reduction, bitboards) were
sent to the experimenting session on 19 Nov; results go to DMON_RESULTS.md on its branch.

Baseline costs (`out/*.log`, `out/ci/`): `-prime` nodes n = 24: 1.49e7, 26: 6.15e7, 30: ~2.6e9
(-stair 2.2e9, about 80 s per eighth on 4 cores), n = 38 `-stair -tourcap 3`: 2.03e12 nodes,
1.0e6 runner-seconds; growth about 4.2x per two edges. n = 40 would be about 2200 runner-hours.
**Every factor of 4.2 in nodes saved is one more length.**

Rules for experiments: never modify `enum.cpp` (its hash is in the proof logs); work in a copy
`enum_dmon.cpp` with each DMON behind its own flag; compare against `enum` on the same n and
options. A pure bound (D2, D3) must give byte-identical output; a new lemma (D1) may only remove
words, and must keep at least one word of every knot type at its minimal length (check against the
known censuses below).

---

## D1. Generalized curtain (strictly stronger than DMON 4)

**Lemma (GC).** Let v_0, v_1 = v_0 + a, v_2, ..., v_m, v_{m+1} = v_m - a (m >= 2) be consecutive
vertices of a lattice polygon P (a a unit vector; the interior steps v_1 -> ... -> v_m are
ARBITRARY, they may also go along +-a). Let Q = {v_1, ..., v_m} and let R be the other vertices.
If none of the points v_j - a (2 <= j <= m-1) lies in R, then replacing v_1, ..., v_m by
v_2 - a, ..., v_{m-1} - a gives a polygon P' of the same knot type with two fewer edges.

*Proof sketch.* P' is closed (v_1 - a = v_0, v_m - a = v_{m+1}) and self-avoiding (the new points
are a translate of an embedded path, not in R by hypothesis, and not v_0, v_{m+1}). Isotopy:
H_t = segment [v_0, v_1 - t a] + (path v_1..v_m translated by -t a) + segment [v_m - t a, v_{m+1}],
t in [0, 1]. A point of the moving path at 0 < t < 1 that lies on an edge of R: if it is a lattice
point p, then [p, p + a] is an edge of the moving path, so p is in Q, but a lattice point on an
R-edge is an R-vertex (contradiction); otherwise it has a fractional coordinate along a, so the
R-edge is parallel to a and on the same line as an edge of the path, and two distinct lattice edges
on a line meet only in end points, which again forces a vertex of Q to be adjacent through an R-edge
(only possible for the first and last edges, which are the shrinking segments). So every H_t is
embedded, and H_1 = P'. (Write this out in full before using it; the curtain lemma is the case where
all interior steps are perpendicular to a, where "not in R" = "not a vertex".)

**Search use.** At a step in direction -a, for EVERY earlier step i0 in direction +a (not only the
last step on that axis, which is all the curtain uses), form the obligation "one of v_j - a,
i0+2 <= j <= current-1, becomes a vertex outside the sub-path": shifted points occupied by vertices
before i0 satisfy it at once; points occupied by the sub-path itself do not count; free points are
the sites; no site -> prune. At the leaf, also the cyclic sub-paths through the root.

**Experiments.** (1) Validate on every known shortest polygon: no polygon of the censuses violates
GC: 3_1 at 24 (3328), 4_1 at 30 (3648), 5_1 at 34 (6672), 5_2 at 36 (114 912); generate them with
`python3 check/slab_census.py out/nNN_*.txt --alex ... --all48 --out FILE`. A single violation means
the proof is wrong. (2) Leaf-only filter on the outputs n = 24..38: how many survivors does it kill?
(3) Prefix version: nodes and seconds at n = 26, 28, 30 vs baseline.

## D2. Axis-ordered travel (sharper version of DMON 3 + 6, pure bound)

Per axis A the walk still has to travel t_A >= |displacement to the origin along A|, and at least
the per-axis span that `span_need` already computes for single-site obligations. Final counts
c_A^f satisfy c_A^f >= c_A + t_A, every c_A^f is even (closed polygon), and c_z^f <= c_y^f <= c_x^f,
c_x^f + c_y^f + c_z^f = N. Prune when
z' = even(c_z + t_z), y' = max(even(c_y + t_y), z'), x' = max(even(c_x + t_x), y') has x' + y' + z' > N.
Today the axis rule only uses the counts so far and the total travel only uses the sum over axes;
this couples them (large z-travel forces at least as many y- and x-steps). Cost per node: a few
integer operations (the per-axis spans are already computed inside span_need).
**Experiment:** identical output, node and time ratio at n = 26..32.

## D3. Obstacle-aware distances (sharper DMON 6, pure bound)

(a) When the slack s = (R - 1) - DIST0[head] is small (try s <= 2, 4), replace the Manhattan
distance by a bounded BFS through free allowed cells (depth <= R - 1): the walk cannot pass through
its own vertices, and near the end (where most nodes are) it is nearly geodesic, so walls of
occupied cells force detours. With s = 0 it is a monotone-path DP in the box between head and origin.
(b) In the MST bound of `tour_ok`, multi-site obligations are skipped. Use the group MST (contract
each obligation to one node, edge weight = minimum distance between members): still a lower bound,
and it includes every pending obligation.
**Experiment:** identical output; nodes and time; tune the slack threshold.

## D4. Crossing budget for target-restricted runs (new, valid for a declared target)

When the goal of a run is a bound for knots of crossing number >= c0 (for example n = 40: the
knots with Len = 40 are already known; what is new is "every knot with crossing number >= 7 has
Len >= 42"), every polygon of such a knot has at least c0 crossings in EVERY regular projection.
Use the three tilted axis projections (x + eps z, y + eps^2 z) etc.; they are regular diagrams, and
c(K) <= crossings of any diagram. Leaf filter: < c0 crossings in some projection -> drop. Prefix
bound: crossings so far + (remaining steps) * (max crossings one unit edge can still create, bounded
by the occupancy of the neighbouring columns) < c0 -> prune.
**Experiments:** on n = 32..38 outputs, the fraction of survivors with >= 6 (resp. 7) crossings in
all three projections; then the prefix version's node count at n = 30, 32 with c0 = 6 (target "knots
with c >= 6 at n = 32").

## D5. Arc gluing: makes `-stair` complete for composites beyond n = 38

`-prime`/`-stair` are proved for prime knots; Lemma 4 (half-space arcs with <= 18 edges and no
U-turn are unknotted) is what makes n <= 38 complete for composites. At n = 40 the only polygons the
plane-crossing rule can wrongly drop are those with a twice-crossed plane and a knotted arc on both
sides: two 19-edge knotted half-space arcs glued across the plane. List the knotted 19-edge arcs
(`arcknot 19`, about 4 h on one core; add `-part R M` as in `arcslab.cpp`), glue all pairs with
matching end points (as `check/arcslab_glue.py` does for slabs) and add those polygons to the
`-stair` output. Result: the cheap `-stair` search becomes complete for ALL knot types at n = 40
(and with 20/21-edge arcs at n = 42), instead of needing the much larger search without `-prime`.
In the 1- and 2-slab this worked exactly (448 square + 16 granny at L = 2 = published counts;
granny analysis at L = 1, PROOF_SLAB.md sections 6-7).
**Experiment:** `arcknot 19` in parts, glue (19, 19), knot types and counts of the glued polygons;
cross-check that the 40-edge composites of `out/witness40.txt` (or their flip-closures) appear.

---

Order of work suggested to the experimenting session: D2 (cheap, quick win or not), D1 (largest
potential; validate the lemma first), D3, D5, D4.

## First result (experimenting session, 19 Nov)

D2 at `-stair -tourcap 3`, output byte-identical to `enum`: `-aot` nodes 0.56x / 0.50x / 0.46x at
n = 24 / 26 / 28 (time 0.44x / 0.42x / 0.39x); `-aotc` (also counting the plane-crossing debt per axis
as remaining steps on that axis, valid with `-prime`/`-stair`) nodes 0.35x / 0.29x / 0.29x, time
0.28x / 0.22x / 0.22x (n = 28: 115 s -> 25 s). D1 checker: 0 violations on all stored survivor lists
n = 24..38.

**D2 final (19 Nov, branch claude/dmon-experiments commit bd9f007, DMON_RESULTS.md there).**
Whole search, 4 threads, `-stair -tourcap 3`, outputs byte-identical to `enum` at every n:

| n | enum nodes | -aot nodes | -aotc nodes | enum s | -aot s | -aotc s |
|---|---|---|---|---|---|---|
| 24 | 1.589e7 | 0.557x | 0.350x | 3.6 | 1.6 | 1.0 |
| 26 | 7.63e7 | 0.500x | 0.292x | 18.9 | 8.0 | 4.2 |
| 28 | 4.09e8 | 0.463x | 0.286x | 115 | 45 | 25 |
| 30 | 2.162e9 | 0.526x | 0.298x | 635 | 280 | 141 |

`-prime` alone at n = 24/26: 0.536x/0.351x and 0.484x/0.292x nodes. Growth per two edges is
unchanged (5.3-5.5x), so this is a constant factor: about 3.4x in nodes and 4.5x in time, about
0.7 of a length step. `-aotc` uses the plane-crossing debt, so it is valid exactly in `-prime`/`-stair`
runs.

**Reference costs of the DMON-only search of the Len(5_2) proof** (paper session, out/lean/parts):
nodes n = 24: 1.81e8, 26: 1.08e9, 28: 6.77e9, 30: 4.36e10, 32: 2.84e11, 34: 1.93e12 (about
1060 core-hours); fit 0.057 * 2.493^n. No per-DMON ablations exist. Lesson from that work: compare
node counts, not only outputs, after every change.

**D1 final (19 Nov, DMON_RESULTS.md on claude/dmon-experiments).** The generalized curtain lemma is
valid: full proof written; 0 violations in all four censuses (128 560 shortest polygons) and in all
stored survivor lists n = 24..38; 19 528 random GC moves kept the Alexander polynomial. As a search
device it does nothing measurable: `-gcleaf` kills 0 leaves, `-gc` keeps the output and removes only
0.01-0.04 % of nodes while costing 30-45 % more time, because DMON6 (U-turns, perpendicular curtains),
DMON7 and the reach tests already kill those prefixes one or two steps earlier. Rejection counters at
n = 24 (`-rejstats`): the tour/MST bound kills 6.35M prefixes, reach / two-free-neighbours 2.38M, GC
about 2 000, out of 15.9M nodes. Conclusion: the remaining gains are in sharper bounds (D2 done, D3
next, plus a 1-tree style bound between MST and the exact tour), not in new local lemmas.

**D3 and D2 follow-ups (19 Nov, commit ac82993 on claude/dmon-experiments).** D3 is no gain: `-bfsdist`
0.991-0.9995x nodes, `-gmst` 0.97-0.98x, a 1-tree bound 0.95x at 4-5x the time. D2 follow-ups help:
best production set `-aotc -aotm -aote` (multi-site obligations per axis; counts-only part before
the obligation update): n = 24 0.319x nodes (0.9 s vs 3.6 s), n = 26 0.263x (3.5 s vs 18.9 s),
n = 28 0.256x (20.4 s vs 115.4 s), outputs byte-identical. In the DMON-only setting of the paper
(no `-prime`; `enum -tourcap 0 -nomst -noreduce` reproduces the proof's node counts) `-aot -aote -aotm`
gives 0.356x / 0.305x nodes at n = 24 / 26 and lowers the growth per two edges from 5.95 to 5.2.

**Where pruning happens** (`-rejstats`, n = 26): tour/MST kills 32.0M prefixes, reach/two-free 10.7M,
all at R1 = 2..16 remaining steps (peak 8-12); nothing dies at R1 >= 17, i.e. the first ~9 of 26
steps are enumerated unpruned. The axis test is the first that acts at R1 = 14-16. So the next
devices must act early: bidirectional construction around the root (E9), early budget tests (E10).

**E9 bidirectional construction, first result (19 Nov, commit ee1b693, `enum_bidir.cpp`).** The head
grows forward from the root and the tail backward, alternately for the first ALT steps, then the
head only; every test uses (head, tail) as the two end points of the missing middle; the final
decision at a closed polygon is the complete cyclic test plus the flip BFS. With ALT = 0 it
reproduces enum's node count (n = 24: 86 639 687 vs 86 639 605, DMON-only, `-tourcap 3`); output
(sorted) byte-identical to enum for n = 20, 22, 24 and ALT = 0, 6, 12, 100. Nodes, DMON-only:
n = 20: 0.154x, n = 22: 0.156x, n = 24: 0.158x (13.7M vs 86.6M) - a factor about 6.3, constant so far.
Pending: n = 26, 28; time; stacking with `-aot -aotm`; `-prime`/`-stair` mode; the completeness
argument for two-ended prefixes.
