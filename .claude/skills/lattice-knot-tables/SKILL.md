---
name: lattice-knot-tables
description: Project skill for the MA498 knot-theory research in this repository (Goal 1 - numerical tables of minimal lattice length Len(K) in the simple cubic lattice). Use for any work on minimal lattice polygons, Len(K) upper bounds, the 11- and 12-crossing tables, BFACF / annealing / replica-exchange / ML search methods, the benchmark, knot identification of nsewud words, or writing up results. Also use before quoting any number from the wiki or literature, and when deciding whether a task is in scope.
---

# Minimal lattice knots: Goal 1 (numerical tables)

Read this before any research task in this repo. It fixes the scope, the rules that make
a result count, where things live, and the order of work. Numbers and traps are in
`references/state-of-the-art.md`; read that before quoting any value.

## 1. The research question

**Len(K)** = least number of unit edges of a polygon in the simple cubic lattice Z^3 of
knot type K. (The project brief calls it c(K); everywhere else c(K) is the crossing
number. Always write Len(K) and c for crossing number.)

**Goal 1, the only goal in scope:** produce new, verified, reproducible **upper bounds**
for Len(K), above all the first SC tables for 11-crossing knots (552) and 12-crossing
knots (2176), and find out whether a better search method than 2009-style simulated
annealing exists. The deliverable is a paper whose backbone is the table, with a method
comparison done fairly.

Out of scope unless the user reopens them (do not start these, point to them instead):
- Goal 2, analytic bounds (transferring ropelength bounds to Len, explicit constants).
- Goal 3, links (exact Len of Hopf / Whitehead / Solomon, link tables).
- Wiki curation for its own sake. Only add to `wiki/` what a Goal 1 task needs, or a
  result Goal 1 produced.
- Lower-bound proofs, except the exhaustive-enumeration tasks listed in section 6
  (T3c, T7b), which are the only lower-bound-style results Goal 1 allows.

## 2. Rules that decide whether a result counts

These come from `research/PLAN.md` section 1 and are not negotiable.

1. **Certificate or it did not happen.** A bound is claimed only with: the final word,
   the seed word, and the exact command (program, all parameters, RNG seed) that
   regenerates it. BFACF moves cannot change knot type [JvRW91 Thm 3.11], so seed plus
   reproducible run is the proof. SnapPy, the fingerprint and Knoodle are independent
   checks, not the proof.
2. **A failed search is not a lower bound.** Write "no shorter polygon found with budget
   B" and never "Len(K) = n" unless n is one of the three proved values (24, 30, 34).
3. **Non-BFACF moves** (pivot, crankshaft, learned generators) must end with an exact
   identification of the final word, and the write-up must say the certificate is that
   identification, not the move sequence.
4. **Fair comparisons.** Same RNG seeds, same budget of attempted moves, same knot set.
   A method "beats annealing" only with non-overlapping 95% binomial intervals on the
   pooled runs and no worse on more than 2 of the 12 hard knots, then confirmed once on
   the held-out set.
5. **No speed-up claims** without the command, machine load, and a baseline number
   measured in the same session.
6. **Label every statement**: [E] established (with source key), [C] computed here
   (script and output file), [J] conjecture or proposal (with how to check it).
7. **Negative results are results.** Report "worse than baseline" plainly; the first
   untuned record-to-record method lost to annealing (100 vs 129 of 240 runs) and that
   is recorded as such.

## 3. Where things live

Research code and outputs are on the branch **`research/len11-table`**, not `main`.
Check it out (or `git fetch origin research/len11-table`) before working.

| What | Path |
|---|---|
| Plan, task list T1-T7, done-criteria | `research/PLAN.md` |
| Lattice toolkit: word <-> vertices, self-avoidance, PD code, SnapPy identify | `code/latticeknot.py` |
| Literature table, 249 prime knots <= 10 crossings, verified | `data/rechnitzer_SC_minimal.csv` (`.json`, `_raw.json`) |
| Diagram -> long lattice seed for 801 knots (3-11 crossings) | `research/code/seeds.py` -> `research/data/seeds.json` |
| BFACF annealing, single run (C) | `research/code/bfacf.c` |
| Multi-threaded batch over many knots (C++) | `research/code/bfacf_batch.cpp` |
| Shared engine | `research/code/bfacf_core.hpp` |
| Benchmark harness (methods `cycle`, `rrt`, optional contact bias) | `research/code/bench.cpp`, `research/data/bench_hard12.txt` |
| Python driver with verification | `research/code/run_search.py`, `research/code/verify_batch.py` |
| Alexander + Jones fingerprint lookup | `research/code/fingerprint.py`, `research/code/alexander.py` |
| Tabulation | `research/code/summarize.py` -> `research/out/summary.md`, `research/out/table_11_crossings.csv` |
| Composite trefoil sums, pumping search | `research/code/run_composites.py`, `research/code/pump.py` |
| Exhaustive small-length enumerator (counts of valid words) | `BTP/knotmaker.cpp` |
| Knowledge base (cite with `[Key]`) | `wiki/` (start at `wiki/README.md`, `wiki/00-notation.md`) |
| Open problems feeding Goal 1 | `wiki/open-problems.md` A1, A3, A6, C16, D17-D19 |
| Papers (gitignored, never commit) | `papers/` via `download_papers.ps1` |

Word format everywhere: closed word over `n s e w u d` (n = +y, s = -y, e = +x, w = -x,
u = +z, d = -z). Literature CSV stores `start_vertex` + `direction_word`; seeds and
outputs store the word alone.

## 4. Commands (from the file headers; run from the repo root)

On the Windows machine the SnapPy Python is `py -3.12`; elsewhere use `python3`.

```
gcc -O2 -o research/code/bfacf research/code/bfacf.c
g++ -O2 -std=c++17 -pthread -o research/code/bfacf_batch research/code/bfacf_batch.cpp
g++ -O2 -std=c++17 -pthread -static -o research/code/bench research/code/bench.cpp

py -3.12 research/code/seeds.py                                    # once
py -3.12 research/code/verify_batch.py export 11 research/out/in11.txt
research/code/bfacf_batch research/out/in11.txt research/out/raw11.txt 3 8 100 100000 60000 0.2 0.02 0 10
py -3.12 research/code/verify_batch.py check research/out/raw11.txt c11_cpp
py -3.12 research/code/summarize.py

# single run:   bfacf WORD SEED CYCLES N_HIGH N_LOW ZMAX ZLOW [last]  -> "BEST <len> <word>"
# benchmark baseline (Scharein 2009 schedule):
research/code/bench research/data/bench_hard12.txt research/out/bench/raw.txt scharein 100 16000000 0 10 cycle 0.2 0.02 100000 60000
```

Benchmark standard: budget B = 16,000,000 attempted moves per run, 100 runs per knot,
seeds 1-100, 12 hard knots = 1200 runs per method (about a minute on 10 idle threads).

## 5. How to do a task

1. Find the task in `research/PLAN.md` (T1-T7). If the request is not one of them,
   say which task it is closest to, or that it is out of scope (section 1).
2. Respect its dependency: T1 and T2 before claiming any method wins; T4 needs T1's
   identifier; T6 needs a winner from T2/T3.
3. Touch only the files that task lists, so parallel agents and students do not
   collide. Work on a branch; commit small; never push to `main`.
4. Before quoting a literature number, check `references/state-of-the-art.md` and the
   relevant wiki page for its status and convention (radius vs diameter, Perko
   renumbering, chirality, rooted vs unrooted counts).
5. Every new bound goes into a CSV with: knot, start length, best length, literature
   bound (if any), verified flag, which checks passed, provenance chain (round:seed),
   word. Then rerun `summarize.py`.
6. Before saying "new", compare against `data/rechnitzer_SC_minimal.csv` (<= 10
   crossings) and the latest `research/out/table_11_crossings.csv`. A value equal to
   the literature is a reproduction, not a result.
7. Report: what ran (command), what came out (numbers with [C]), what it means, and
   what it does not show (rule 2).

## 6. Order of work (milestones, no fixed dates)

No deadline has been set. Work in this order and stop a phase when its exit test is
met; if time runs short, cut from the bottom of the list, never from phase A.

**Phase A: honest baseline (T1, T2).**
Exit: tool audit table in `research/tools/AUDIT.md` with one `word -> name` wrapper
that reproduces all 801 names; tuned annealing schedule with its held-out score. From
then on the tuned annealer, not the 2009 schedule, is the bar.

**Phase B: method comparison (T3a-T3f, T5 alongside).**
Record-to-record sweep, contact bias, replica exchange (T3f: swap rule
min(1, (z_i/z_j)^(n_j - n_i)), validate the length histogram on the trefoil first),
symmetric search, cross-entropy move policy, capped exhaustive closure (T3c).
Exit: one row per method in the results table with a one-line verdict, including
"worse". Expected outcome per PLAN.md: replica exchange may only match the baseline.

**Phase C: the table (T6). This is the paper.**
Re-run all 552 eleven-crossing knots with the winner at >= 240 runs per knot (the
current table used 24 runs; some values are probably 2 too long); add the lattice
stick-number upper bound (corner count) column; extend to the 2176 twelve-crossing
knots once T1 provides an identifier that names them; composites of two primes with
total crossings <= 10, certified by prime splitting.

**Phase D: one statistics result (T7, pick one).**
T7a growth of knot types (re-read JvRP95 Thm 10 in the original first), or T7b exact
census of trefoil polygons at 24 (expect 3328) and 26 steps, or T7c smallest box with a
knotted Hamiltonian cycle.

**Only if A-C leave hard knots unsolved:** T4 (large moves with a knot filter,
PatternBoost-style learned seeds, a word classifier used as a filter, never a
certificate).

## 7. Things that have already gone wrong (do not repeat)

- The 2009 schedule heats close to the critical fugacity 0.2134, which inflates the
  polygon each cycle; that is why T2 tunes it before anything is compared to it.
- Calibration with 24 runs missed 4 literature values (9_31, 10_13, 10_27, 10_72);
  240 runs recovered them. Small run counts give too-long values.
- SnapPy cannot name torus knots or composites (not hyperbolic). Use the Alexander
  check for torus knots and the prime-splitting identifier (T1) for composites.
- Alexander (and Alexander + Jones) do not determine knot type: 801 knots give 707
  unique fingerprints. A fingerprint match is a candidate, not an identification.
- The "60x faster than SnapPy" figure for ReAPR/Knoodle is about simplifying large
  unknot diagrams, not our task. Measure before adopting.
- A literature search that finds nothing is not proof of novelty. Re-check before
  claiming "first" in the paper (e.g. replica exchange for minimal lengths).
- KA23 quotes a "34.7" universal lower bound from Diao 2003 that does not match Diao's
  formula; do not repeat it.

## 8. Writing up

Every table row and every chart caption states budget, number of runs and seeds.
Every claimed bound links to its certificate. Results equal to the literature are
listed as reproductions. Use `[Key]` citations that resolve in `wiki/SOURCES.md`.
Commit text files only: papers and page renders are copyrighted and gitignored.
