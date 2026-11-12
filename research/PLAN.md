# Research plan: shorter lattice knots, faster tools, knot statistics

Written 12 Nov 2026 for implementation by other agents or students. Branch `research/len11-table`.
Each task below is self-contained: inputs, what to build, and how to tell it is done.

Labels: **[E]** established (source given), **[C]** computed here (script → output), **[J]** proposal or conjecture (check given).
Len(K) = least number of unit steps of a simple-cubic lattice polygon of knot type K.

## 0. Where things stand

| Item | Status | Files |
|---|---|---|
| Seeds for all 801 prime knots, 3–11 crossings | [C] done | `code/seeds.py` → `data/seeds.json` |
| BFACF engine (C++) | [C] done | `code/bfacf_core.hpp`, `code/bfacf_batch.cpp`, `code/bfacf.c` |
| Calibration, 249 knots ≤ 10 crossings | [C] 245 at literature bound with 24 runs; the other 4 reach it with 240 runs; none shorter | `out/calib_le10.csv`, `out/hard4.csv` |
| First table, 552 knots with 11 crossings | [C] all verified; alternating 64–70, non-alternating 54–64; **24 runs only, some values probably 2 too long** | `out/c11.csv`, `out/table_11_crossings.csv` |
| Trefoil sums n = 2..10 | [C] no improvement; no repeatable 16-step unit found (no positive control for that test) | `out/trefoil_sums.csv`, `code/pump.py` |
| Elementary knotword → knot lookup | [C] Alexander + Jones; 801/801 correct candidate set, 707 unique, 0.044 s each | `code/fingerprint.py`, `out/fingerprint_table.json` |
| Growth of the number of knot types | [C] Q ≥ 1.1031 (789 types with a polygon of ≤ 68 steps), up from 1.0927 using the literature table; relies on Q(n) ≤ Q^n as quoted in `wiki/lattice-length/exact-values-and-proofs.md` (JvRP95 Thm 10) — re-read the original before citing | one-liner in the session; reproduce in T7 |
| Benchmark harness | [C] built, first two data points only | `code/bench.cpp`, `data/bench_hard12.txt`, `out/bench/raw.txt` |

First benchmark numbers [C] (12 hard knots × 20 runs, budget 16 million attempted moves, seeds 1–20):
Scharein-style annealing solved 129 of 240 runs; the first untuned version of the new "record-to-record" method (z = 0.10, Δ = 4) solved 100 of 240. **So the first new idea, untuned, is worse than the baseline.** Nothing below has been shown to beat annealing yet.

Decisions already taken by the team: no replica exchange / parallel tempering. (For the record: the prior work found was Zhu's 2019 Wang–Landau thesis, which studies writhe and reports no minimal lengths; no replica-exchange paper on this problem was found.)

## 1. Rules for every task

1. A bound is only claimed with a certificate: the word, the seed word, and the exact command (program, parameters, RNG seed) that regenerates it. BFACF moves cannot change knot type [E: Janse van Rensburg–Whittington 1991, `wiki/algorithms/bfacf-and-gas.md`], so seed + reproducible run is the proof; SnapPy/Knoodle/fingerprint are independent checks.
2. A search that fails to find a shorter word is not a lower bound. Say so in every write-up.
3. Any method that uses moves other than BFACF must end with an exact identification of the final word, and must say that its certificate is the identification, not the move sequence.
4. Same RNG seeds and same move budget for every method in a comparison.
5. Work on a branch, commit small, never push to `main`. One task = one set of files (listed per task) so parallel agents do not collide.
6. Do not report a speed-up without the command, the machine load at the time, and the baseline number measured in the same session.

## 2. Benchmark (the yardstick for T2–T5)

- **Hard set** `data/bench_hard12.txt`: 8_3, 8_7, 8_16, 9_31, 9_41, 10_13, 10_27, 10_69, 10_72, 10_113, 10_123, 10_157, each with its diagram seed and the literature bound as target. Chosen because they have very few known minimal polygons (Scharein 2009 Table A1, column E) or were missed by the first calibration run.
- **Run** = one RNG seed, at most B attempted BFACF moves, stops on reaching the target.
- **Scores**: (a) fraction of runs solved within B; (b) the run-length distribution: fraction solved as a function of attempted moves; (c) median attempts-to-target per knot.
- **Standard setting**: B = 16,000,000 (one Scharein run of 100 cycles), 100 runs per knot, seeds 1–100, i.e. 1200 runs per method. Takes about 1 minute on 10 idle threads.
- **Output** line format (already implemented): `label knot seed hit_attempts best_length trace`.
- **Baseline label** `scharein`: `bench IN OUT scharein 100 16000000 0 10 cycle 0.2 0.02 100000 60000`.
- A method "beats annealing" if its solved fraction is higher with non-overlapping 95% binomial intervals on the pooled 1200 runs, and it is not worse on more than 2 of the 12 knots.
- Guard against tuning to the test: tune on the hard set, then confirm once on a held-out set of 30 other knots with E ≤ 10 chosen before looking at results (T2 creates `data/bench_holdout30.txt`).

## 3. Tasks

### T1. Tool audit: are we using the fastest correct tools? (do first; others depend on it)

Question to answer with measurements, not opinions.

| Job | Now | Candidates to measure |
|---|---|---|
| Polygon → diagram (PD code) | Python, O(n²) segment pairs (`code/latticeknot.py`) | C++ port; Knoodle's own polygon input |
| Diagram simplification | spherogram `simplify('global')` (Python) | Knoodle `knoodlesimplify` (C++), Regina |
| Naming the knot | SnapPy `identify` + knot Floer homology | Knoodle `knoodleidentify` (lookup table through 13 crossings, splits composites), Topoly, pyknotid, KnotPlot |
| Polynomial fingerprint | `code/fingerprint.py` (Python, 2^crossings state sum) | C++ port with a planar-separator or tangle-by-tangle bracket; HOMFLY via Topoly |
| Diagram → lattice seed | spherogram orthogonal layout (Python) | KnotPlot "embed"; Knoodle PolyFold; keep ours if adequate |

Facts to respect:
- [E] Knoodle (Schumacher, Cantarella; MIT; https://github.com/HenrikSchumacher/Knoodle) identifies 3D polygons by simplifying, splitting into prime summands and table lookup through 13 crossings; its page gives no benchmark numbers.
- [E] The "about 60× faster than SnapPy" figure comes from the abstract of the ReAPR paper (arXiv 2607.28772) and refers to simplifying very large hard unknot diagrams. It is **not** a measured speed-up on our task. Measure before adopting.
- [C] Our current verification costs 0.20 s per knot (SnapPy route) or 0.044 s (fingerprint route), under 1% of search time. Speed matters only once identification moves inside the search loop (T4), where the target is well under 1 ms per polygon of ~60–200 steps.
- Knoodle's two real attractions for us are prime decomposition (lets us certify composite knots, which SnapPy cannot name) and the 12–13 crossing table (needed for T6).

Deliverables: `research/tools/AUDIT.md` with a table (tool, version, build steps on this Windows machine and under WSL, time per polygon at lengths 60 / 200 / 1000, agreement count against SnapPy on all 801 polygons in `out/calib_le10.csv` + `out/c11.csv` and on 10,000 intermediate polygons dumped from annealing runs); a recommendation per job; a thin wrapper `code/identify.{py,cpp}` exposing one function `word → knot name(s)` backed by the winner.
Done when: every disagreement between tools is explained or listed, and the recommended identifier reproduces all 801 names (up to the Perko renumbering noted in `code/seeds.py`).
Rewrite rule: port to C++ or Rust only what the measurements show is a bottleneck; the first candidates are polygon → PD code and the fingerprint.

### T2. Tune the baseline properly (cheap, and it sets the bar honestly)

The Scharein schedule heats for 100,000 moves at z up to 0.2, close to the critical value 0.2134, which inflates the polygon and throws away progress each cycle [J]. Sweep with `bench cycle`:
zmax ∈ {0.05, 0.10, 0.15, 0.20}; zlow ∈ {0.01, 0.02, 0.05}; nhigh ∈ {100, 1,000, 10,000, 100,000}; nlow ∈ {1,000, 10,000, 60,000}.
Use successive halving (20 runs per knot for all 144 settings, keep the best quarter, rerun at 100). Files: `code/tune.py`, `out/bench/tune_cycle.csv`.
Done when: the best setting is reported with its held-out score. **This tuned annealer, not the 2009 schedule, is the baseline every new method must beat.**

### T3. New methods inside the BFACF move set (certificates stay trivial)

Each is a small addition to `code/bench.cpp` plus a sweep; all keep rule 1 intact.

- **T3a. Record-to-record cap** (implemented as `rrt Z DELTA`). Constant fugacity; refuse any +2 move that would exceed best-so-far + Δ. Because of the cap, Z may exceed 0.2134. Sweep Z ∈ {0.05, 0.1, 0.2, 0.3, 0.5, 1.0}, Δ ∈ {2, 4, 6, 8, 12}. First point (0.10, 4) lost to the baseline; the sweep decides whether the idea is dead.
- **T3b. Contact bias** (implemented as optional `GAMMA`). Neutral moves that reduce the number of occupied neighbours are accepted with probability exp(γ·change). Rationale [J]: minimal polygons are compact. Sweep γ ∈ {0.25, 0.5, 1, 2} on top of the best T2 and T3a settings.
- **T3c. Capped exhaustive closure.** From a polygon of length L, breadth-first enumerate every polygon reachable by BFACF moves without exceeding L + 2k (k = 1, then 2), storing a canonical form (least word over 24 rotations × cyclic shifts × 2 directions; no reflections, so chirality is kept) in a hash set. Stop as soon as a polygon of length L − 2 appears, then restart from it. Outcome is either a shorter polygon or the checkable statement "no polygon shorter than L is reachable below length L + 2k". Known sizes [E, `wiki/algorithms/bfacf-and-gas.md`]: 19,618 states for 4_1 at cap 32; 12,337 for 6_3 at cap 42. Expect 10⁵–10⁸ for 9–11 crossings; give the tool a state limit and report when it is hit. Files: `code/closure.cpp`. Use as a finisher after annealing, and report its cost in the same move units as the benchmark (one generated neighbour = one attempt).
- **T3d. Symmetric search.** Check which literature-minimal polygons of the hard set are invariant under a lattice rotation (`data/rechnitzer_SC_minimal.csv`). If several are, add a mode that applies each move together with its image under that symmetry and searches only symmetric polygons. Files: `code/symmetry_check.py`, then a mode in `bench.cpp`.
- **T3e. Learned move policy (the machine-learning entry).** A table of acceptance multipliers indexed by a small local context (the move type and the five step letters around the chosen edge). Train by the cross-entropy method: sample tables, score each on the benchmark, keep the top 10%, refit, repeat (Wagner, arXiv 2104.14516). The result is an explicit table a student can read. Files: `code/policy_cem.py`, policy file read by `bench.cpp`.

Done when (each): sweep CSV in `out/bench/`, a row in the results table, and a one-line verdict against the tuned baseline, including "worse" if it is worse.

### T4. Methods that leave the BFACF move set (need T1 first)

- **T4a. Large moves with a knot filter.** Pivot and crankshaft moves on a sub-arc, accepted only if the result is self-avoiding and the fast identifier from T1 returns the same knot. Final word must pass the exact identifier (rule 3).
- **T4b. Learned seeds, PatternBoost style** (arXiv 2411.00566). Sample thousands of minimal and near-minimal words per knot with `bfacf.c ... last`; train a small sequence model on them; generate candidates for a target knot; filter with the identifier; polish with BFACF. Only start if T2–T3 leave hard knots unsolved.
- **T4c. Knot predictor from step words.** Train a classifier on words labelled for free by the annealer (the moves keep the type). Evaluate on knot types and lengths not seen in training, and against a writhe-only baseline, because published coordinate classifiers were shown to rely on writhe and fail once that shortcut is removed [E: arXiv 2602.17350; two classes only]. It is a filter for T4a, never a certificate.

### T5. Visualiser and benchmark graphs

One static page, no server: `research/viz/index.html` reading `research/viz/data.json`, generated by `code/bench_report.py` from `out/bench/*.txt` and the result CSVs.
- Run-length plot: fraction of runs solved (y) against attempted moves (x, log scale), one line per method, pooled and per knot.
- Method × knot grid of solved fractions, with the baseline row first.
- Best-length-so-far traces (median and quartiles over runs) for a chosen knot.
- 3D viewer: pick any knot from the tables, rotate its polygon, show word, length, bound source and the command that regenerates it.
- Every chart states the budget, number of runs and seeds in its caption. Regenerating after a new method is one command.
Done when: the page shows the two methods already in `out/bench/raw.txt` and updates when a new label is appended.

### T6. Tighten and extend the table (the paper's backbone)

- Re-run all 552 eleven-crossing knots with the tuned baseline or the best method, at no less than 240 runs per knot; report how many values dropped.
- Add lattice stick number upper bounds (count corners) as a free column.
- Extend to the 2,176 twelve-crossing knots once T1 provides an identifier that names them.
- Composite knots of two primes with total crossings ≤ 10, certified with the prime-splitting identifier from T1.

### T7. Statistics of knots (pick one for the paper)

- **T7a. Growth of knot types.** Script the bound Q ≥ (number of knot types with a verified polygon of ≤ n steps)^(1/n), read JvRP95 Thm 10 in the original to confirm the inequality used, and update after T6.
- **T7b. Exact census of short knotted polygons.** Extend `BTP/knotmaker.cpp` with bounding-box pruning and the fingerprint to count trefoil polygons exactly at 24 steps (expect 3328) and at 26 steps (a numerical census gives 281,208; an exact count would remove the condition in Ozawa's completeness statement, see `wiki/algorithms/bfacf-and-gas.md`). This is a proof by enumeration, the only kind of lower-bound-style result in this plan.
- **T7c. Knotted space-filling cycles in small boxes.** Smallest box whose lattice points admit a knotted Hamiltonian cycle; exhaustive enumeration. Check the literature again first (only simulations were found).

## 4. Order and dependencies

T1 and T2 first, in parallel (different files). Then T3a–T3e in parallel, T5 alongside. T4 after T1. T6 after T2/T3 pick a winner. T7 any time.

Suggested staffing: T2, T3a, T3b, T5, T6 and T7a are mechanical and suit a cheaper model. T1 needs care with builds and with interpreting disagreements. T3c, T3d, T4 and T7b need design judgement; review their output before trusting it.
