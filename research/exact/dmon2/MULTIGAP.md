# Lead 9: multi-gap search (specification for the DMON experiments session)

## Problem it solves

`enum_v` grows one walk from the root at both ends (head Hd, tail Tl) and closes one gap of R missing
steps. The bounds that prune (tour, GW3 walk, axis counts) are weak while the gap is long: the dead nodes
sit 8 to 15 steps before the end (DMON2.md section 0). Two earlier facts say that more ends help:
* E9 (two ends instead of one) gave 0.28x nodes alone at n = 28, and 16x in time at n = 30 stacked with
  D2 (DMON_RESULTS.md E9). Its gain came entirely from the last two vertices before the root: one tail
  letter gave 2.5x, two gave 4.3x, longer tails nothing more. The walk must return to a concrete vertex,
  not just to the root's neighbourhood. An anchor gives the same kind of concrete target in the middle
  of the gap.
* Lead 2 (choosing between the ends with full probes) gave 5.9x fewer nodes, but each probe cost a full
  test evaluation (LEADS3.md row 2).

A multi-gap search splits the missing part into several shorter gaps whose end cells are known, and
lets the fail-first rule (`-adapt 1`) choose among all 2k ends. Shorter gaps have tighter bounds.

## Version A (exact, no new lemma): pin single-site obligations

1. When an obligation (curtain, corner, ray, face or crank obligation) has exactly one site c left, the
   final polygon must contain the vertex c. A simple polygon visits c exactly once.
2. Branch on the two letters at c: the entry letter a (the step into c) and the exit letter b (the step
   out of c), with b != -a. That is at most 6 x 5 = 30 branches, fewer after occupancy and the no-U-turn
   checks. Mark c, c - a and c + b as used (c - a and c + b are the neighbours on the polygon).
3. The single gap Hd -> Tl becomes two gaps: Hd -> (c - a) and (c + b) -> Tl, with the shared budget
   R' = R - 2. A gap is closed when its two ends meet (with the junction letters checked for reversal and
   U-turn, as in GW3).
4. Bounds become sums over gaps: the distance bound is sum_i dist(gap_i) <= R'; the tour and GW3 bounds
   assign each remaining obligation to some gap (minimum over assignments, or the cheaper lower bound
   min over gaps per obligation, summed with the gap distances counted once).
5. The fail-first rule picks the end, over all 2k ends, with the fewest legal letters.
6. Repeat: an obligation that becomes single-site inside any gap creates a further anchor. Cap k (start
   with k <= 3) and measure.

Every polygon is generated exactly once: c is a vertex of the polygon, visited once, so the entry and exit
letters are determined, and the concatenation of the gaps gives back the word. No deduplication is
needed.

## Version B (larger change): an anchor at the highest vertex

Fix per task the position of the highest vertex h (largest z, then y, then x, matching the reversed
DMON3 order) and grow four ends: two at the root (Hd, Tl) and two at h. Every vertex then satisfies
z <= z(h), and vertices on the top level are lexicographically <= h: a box constraint known from the
start. Risk (DMON2.md 8.3): a prefix appears under many positions of h, so the work may repeat across
tasks. Do Version A first.

## What changes in the tests

Classify every test of `enum_v.cpp` before coding:
* **Set-based** tests (occupancy, plane-crossing counts for `-stair`, axis counts `-aotp -ax1d`, the
  tour and walk bounds): work for any number of gaps, with sums over gaps.
* **Order-based** tests that read the word from the root (psi tie-breaks, DMON3/4 canonical position,
  curtain sites, `-face -plane4 -crank`, tau's comparison of w(P) and w(tau P)): keep them on the root's
  head side while it is contiguous; otherwise check them on the finished polygon (as `-cycleaf` already
  does for face, plane4 and crank).
* **Leaf** tests: unchanged.

## Acceptance

* Output byte-identical (sorted) to `enum_v` with flags F for n = 28, 30, 32, 34, 36 (full runs, not
  parts: the task lists differ between variants, so compare only totals).
* Report nodes, total runner-seconds and the rejection histogram by R, against F.
* If n = 36 is faster than F by 1.5x or more, run n = 38 and n = 40, then n = 42 as a full run.

F = `-face -plane4 -aotp -crank -adapt 1 -tourcap 0 -mstonly -ax1d -hk 5 -hkw -cycleaf -tau 1 -tauz 1
-tauax 1 -walk 8 N/2` (write the tau values explicitly; `-tauz -tauax` mis-parses), on top of the common
options `-alt 4 -stair -tourcap 3 -aotc -aotm -threads 4`. Reference totals: LEADS3.md row 00 and
bench/ci/r5_enumv_F, r6_n42_F.

## Soundness for the Lean port

Version A is a reorganisation of the search: it adds no lemma. Its soundness statement is "every word
accepted by the single-gap search with the same tests is produced by the multi-gap search", proved by
the exactly-once argument above. Keep the code simple enough to port.
