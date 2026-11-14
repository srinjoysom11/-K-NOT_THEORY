# Three leads, ranked

Written 14 Nov 2026 after one day on exact minimal lattice lengths. Read `HANDOFF.md` first.
Labels: [E] established with source, [C] computed here (file given), [J] proposal or conjecture.
Each lead says what would count as success, what has been measured, the first three steps,
and what would kill it. Odds are my own estimates, given so that the next person can argue.

Notation: Len(K) = least number of edges of a simple-cubic lattice polygon of knot type K,
b(K) = bridge number, n = number of edges.

---------------------------------------------------------------------------------------------

## Lead 1. Prove Len(5_2) = 36 (and "every prime knot except 3_1, 4_1, 5_1 needs >= 36")

**Why it is a result.** Only three exact values are proved (24, 30, 34), the last two with
proofs that were announced in 2009 and never published. [Scharein09] says of 5_2 that
enumeration "will not scale" and "more powerful analytical results will be needed"
(`wiki/open-problems.md` A1). A literature check found no proof (8 web searches by a Haiku
agent; not proof of novelty). The same run gives machine proofs of the three classical
values as a by-product.

**Why it is within reach [C].** The search needs every n <= 34. With the plane-crossing lemma
(`PROOF.md` Lemma 3, option `-prime`) the tree is 5 times smaller with identical output:

| n | nodes, default | nodes, `-prime` | survivors (`-prime`) |
|---|---|---|---|
| 20 | 3.1e6 | 7.7e5 | 0 |
| 22 | 1.46e7 | 2.9e6 | 0 |
| 24 | 6.8e7 | 1.5e7 | 50 (same file as default) |
| 26 | 4.8e8 (older build) | 6.1e7 | 62 (same file as default) |
| 28 | | 3.2e8 | 98, all trefoil polynomial |
| 30-34 | | about 1.5e9, 7e9, 3.3e10 [J: growth 4.1 to 5.2 per 2 edges] | |

Measured speed with `-prime` is 3.5e5 nodes/s on 4 vCPUs, so n = 30, 32, 34 need about
75 min, 6 h and 27 h here: **about a day and a half on this container, or two to three hours
on 64 cores.** Parts are independent and resumable.

**Steps.**
1. `ENUM_OPTS=-prime TAG=prime ./run_parts.sh N M R...` for n = 28 (M = 2), 30 (M = 8),
   32 (M = 32), 34 (M = 128). Commit `out/` after every batch.
2. Identify all survivors: `python3 identify_words.py`. Expected: only Alexander
   polynomials of 3_1 (lengths 24-34), 4_1 (30-34), 5_1 (34). **If the polynomial of 5_2
   (2t^2 - 3t + 2) appears at n <= 34, the known table is wrong, which would be a bigger
   result; check that polygon three ways before saying so.**
3. Make the identification a proof: for each survivor simplify its diagram by Reidemeister
   moves to at most 5 crossings (spherogram `simplify('global')`, or `census/kernel` on the
   other branch) and record the final diagram next to the word. Knots with at most 5
   crossings are told apart by the Alexander polynomial.
4. Validation ladder before claiming anything: (a) `-nopsi` at n = 30 and symmetry expansion
   (`check/crosscheck.py` generalises) should give the number of shortest 4_1 polygons;
   [JvRR11] says 3648 and [Scharein09] says 1824, so this settles a standing disagreement
   either way. (b) The same at n = 34 for 5_1 (both sources: 6672). (c) Run `raster.cpp` at
   n = 24 (about 2 h) and compare its output with `out/n24_psi.txt`. (d) Have a second person
   or agent re-derive Lemmas 1-3 from `PROOF.md` without reading the code.
5. Composite knots are not covered by `-prime`. Either run n <= 34 once without it (about
   26 h on 4 vCPUs, `HANDOFF.md` section 3), or prove the missing case of Lemma 3: no shortest
   polygon with n <= 34 is cut by a 2-edge plane with a knotted arc on each side. Sketch:
   each side closes up to a knotted polygon with (its length) + 2 + d edges, d the distance
   between the two cut points; d <= 5 already forces n >= 36; a knotted arc cannot be
   monotone along any axis and needs two maxima in height, so each side has at least d + 8
   edges, which leaves only d in {6, 7, 8} with n in {30, 32, 34} to check by enumerating arcs.

**Odds.** 0.8 that the run finishes with the expected survivors; the main risk is a bug that
a cross-check exposes, not the mathematics. **Kill:** a survivor that is none of 3_1, 4_1, 5_1
after triple identification (then it is a different, better paper), or a failed count in 4(a).

---------------------------------------------------------------------------------------------

## Lead 2. Reach n = 40: the six-crossing knots and the first exact composite value

**What it would give.** Len(6_1) = Len(6_2) = Len(6_3) = Len(3_1 # 3_1) = 40 (all four have
40-edge polygons, [JvRP95] Table I, [JvRR11]); the exact number of shortest 5_2 polygons
(114,912 claimed from sampling [JvRR11]); and the case b = 3 of lead 3. An exact value for a
composite knot would be the first evidence-by-proof on the additivity question
([JvRP95] Conj. 7).

**The gap.** n = 36 and 38 cost about 20 and 90 times n = 34 at the current growth
(4.3-4.6 per 2 edges). So the tree must shrink 30- to 100-fold, or the growth rate must drop.

**What has been tried [C].**
* Lemma 3 as a bound on crossings still owed: 5-fold, constant in n. Done.
* Bridge filter (`-bridge 3`, at least 3 maxima along every axis): 74-fold and 11-fold at
  n = 22 and 24 against the default, about 3-fold at 26 (2.0e5, 6.3e6, 9.8e7 nodes,
  `out/nN_bridge3.log`). The gain shrinks with n; useless alone at 38.
* Sweeping the lattice site by site (`raster.cpp`): 150 times worse, but in a box of
  27 x 15 x 6 sites. Lemma 3 says the true boxes are tiny: (#steps on an axis) >= 4 (#gaps) - 4,
  so for n = 34 the three gap counts sum to at most 11, e.g. 5 x 5 x 4 sites. The sweep was
  never run in such boxes.

**Ideas, in the order I would try them [J].**
1. *Outer levels are staircases.* Lemma 3 says more than the count: where an outer plane is
   crossed twice, the whole outer level is one monotone path. In all 2592 trefoils and 248
   of 249 table polygons such a level exists. In normal form (Lemma 2) the top one must also
   be blocked from below at its two inner ends. Encode this as a rule on the first and last
   level of each axis; it should cut the choices at the extremes, where the walk now wanders.
2. *A library of reducible configurations*, in the spirit of the four-colour proof. The two
   pruning rules now in use are the first entries: "a U-turn" and "a corner with a free flip
   point below". Generate by machine every pattern inside a small window (say 3 x 3 x 3: path
   fragments plus cells marked occupied / free / unknown) from which some sequence of
   corner flips inside the window reaches a U-turn, a free curtain, or a lower normal-form
   potential. Each pattern is a small lemma that a checker verifies independently, and each
   turns into an obligation "one of these cells must become a vertex", which the search
   already handles. Evidence that longer sequences matter: all 62 survivors at n = 26 and 8
   of 18 in the n = 30 sample are non-shortest trefoils that single flips cannot expose.
3. *Thin-box sweep.* For each admissible triple of gap counts, sweep the box level by level
   with the per-plane crossing counts as hard constraints (>= 4 inside, 2 or >= 4 outside).
   First experiment: n = 24 in boxes with gap counts (3,3,3), (2,3,3), (2,2,4), which must
   reproduce the 50 (or 2592) polygons; compare nodes with 1.5e7.
4. Mirror symmetry in x (not used yet): a factor 2.
5. Constant factors: two thirds of the time is the visiting-order bound (`tour`); a bitset
   version or a cheaper sufficient test would give 2 to 3.

**Steps.** (i) Measure idea 1 at n = 24-28. (ii) Build the pattern generator for 2-flip
sequences only and count how many survivors at 26 it removes; that number decides whether
the library is worth building out. (iii) Only then choose between 2 and 3.

**Odds.** 0.3 for n = 38 within a few weeks of work. **Kill:** if after ideas 1 and 2 the
growth per 2 edges is still above 4, n = 38 needs about 1e12 nodes and a cluster, not ideas.

---------------------------------------------------------------------------------------------

## Lead 3. A bridge-number inequality: Len(K) >= 16 b(K) - 8  [J, new as far as I know]

**Statement.** For every knot K, Len(K) >= 16 b(K) - 8, with equality for connected sums of
trefoils. The weaker Len(K) >= 12 b(K) would already be new. Known: Len >= 4 b from total
curvature [JvRP95 Lemma 2]; Len >= 6 b follows by counting, on each axis, one step up and
one step down per maximum (check whether Janse van Rensburg-Promislow 1999 state it).

**Why it matters.** b(K) - 1 is additive under connected sum. The inequality would give
Len(3_1^n) >= 16 n + 8, matching the best polygons found for n <= 6 [JvRR11], so with a
construction for all n it would settle the minimal edge index mu(3_1) = 16, where the
proved range is 4 <= mu <= 17 [JvRP95 Thm 13, 14]. For b = 2 it is exactly Diao's theorem.

**Evidence [C].** Table values are upper bounds, so each row below is a failed attempt to
refute, not a proof.
* All 801 prime knots to 11 crossings, bridge numbers from KnotInfo
  (`bridge/len_vs_bridge.csv`, `bridge/REPORT.txt`): no violation. Smallest gaps:
  3_1 (0), 8_19 (2: 42 against 40), 8_20, 11n_73, 11n_74 (4). The fifteen 4-bridge knots have
  Len >= 60 against 56.
* Trefoil sums n = 1..6: gap 0 every time. 3_1 # 4_1: 6. 4_1 # 4_1: 12.
* Pretzel and Montesinos knots built to attack the bound, bridge number r = 4..8
  (`bridge/pretzel/REPORT.txt`, `bridge/pretzel2/REPORT.txt`; 48 to 168 annealing runs per
  knot, every best polygon checked by Alexander polynomial and SnapPy volume). No violation.
  The best family, P(3,-3,3,-3,...,2) with alternating signs, gives

  | bridges r | 4 | 5 | 6 | 7 | 8 |
  |---|---|---|---|---|---|
  | best length found | 60 | 76 | 92 | 108 | 124 |
  | 16 r - 8 | 56 | 72 | 88 | 104 | 120 |

  that is 16 r - 4 every time: **exactly 16 edges per extra bridge**, the slope of the trefoil
  sums. Montesinos knots with a 2/3 tangle reach the same 60 and 76. A further 120 restarts
  from the best words of four of these knots changed nothing, but restarts from a short
  polygon are not independent samples, so 16 r - 4 is an upper bound for these knots, not
  their Len.
* Smallest known gaps overall: trefoil sums 0, 8_19 = P(-2,3,3) 2, everything else >= 4.

**What I could not do.** A proof for general b. Counting alone stops at 6 b: with exactly
2 b steps per axis every coordinate takes two values and the polygon sits in a unit cube,
but one extra step per axis breaks that argument and gives only a correction of order
b^(1/3). The linear gain has to come from the blockers: by Lemma 1 every maximum is a level
stretch of at least 2 edges with a vertex under its interior, and in normal form (Lemma 2)
under both inner ends.

**Routes to a proof [J].**
1. *Surgery.* Show that a shortest polygon with b >= 3 contains a removable piece (an
   outermost maximum together with the strand that blocks it) of at least 16 edges whose
   removal leaves a polygon of a knot with bridge number b - 1. Induction then starts from
   Diao's 24. The staircase outer levels of Lemma 3 are the natural pieces to remove.
2. *Discharging.* Give every edge charge 1 and move charge to maxima and minima by local
   rules; the reducible configurations of lead 2 say which neighbourhoods cannot occur.
   A target of 12 b needs average charge 2 per extremum per axis beyond the trivial count.
3. *The case b = 3 by machine.* "Every knot with b >= 3 has Len >= 40" follows from lead 2 at
   n = 38 and would prove Len(3_1 # 3_1) = 40.

**Cheap next tests, each under an hour.** (a) Done for r <= 8, see above; next is an
independent search (fresh diagram seeds, tuned schedule) on the r = 4 knot P(-3,-3,3,2), whose
bound 56 against 60 is the easiest place for the conjecture to fail. (b) The 12-crossing knots with b = 4 and the 14-crossing ones with b = 5, using
the diagrams of the census branch. (c) Montesinos knots whose tangles are 2/5 or 3/7 instead
of 1/3: is there a tangle that buys a bridge for fewer than 16 edges?

**Odds.** 0.55 that the inequality is true as stated; 0.8 for 12 b; 0.15 that a general proof
is found soon. **Kill:** one verified polygon below 16 b - 8. That would itself be worth
reporting, and the conjecture would fall back to the best slope the data allow.

---------------------------------------------------------------------------------------------

## 4. Smaller openings that use the same engine

* **Slabs and tubes.** Restrict z to {0, ..., L} (a few lines in `enum.cpp`; the lemmas hold
  because every push used in them moves inwards). The tree is far smaller, so exact shortest
  lengths in the 1-slab and 2-slab for all knots to 6 or 7 crossings look reachable. Known:
  the trefoil needs 26 in the 1-slab [Ishihara12]. Check the tube papers of Ishihara,
  Shimokawa and coauthors (2017) before claiming.
* **FCC lattice.** Two consecutive steps whose sum is a lattice vector can always be replaced
  by that vector, so a shortest FCC polygon has only 7 continuations per step. The
  conjectured Len_FCC(4_1) = 20 ([MannML] open question 2) needs n <= 19. Needs a new
  enumerator; the trefoil value 15 is reported as found by computer in Mann et al. 2009
  (from memory, verify).
* **Traps.** The survivors that are not shortest (62 at n = 26) are a complete list, in
  normal form, of trefoils that neutral moves and shortening moves cannot improve. That is
  exact data on why annealing stalls ([Ozawa26merge] problems 13.1-13.4), and the one place
  where training has a real job: a policy that learns which lengthening move escapes a trap,
  trained on exhaustive data and judged on the benchmark of `research/PLAN.md` section 2.
