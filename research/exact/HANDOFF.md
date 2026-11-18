# Handoff: exact minimal lattice lengths by exhaustive enumeration

Branch `claude/great-einstein-snvnnb`. Last updated 15 Nov 2026, about 13:30 UTC.
Read in this order: this file, `LEADS.md` (what to do next and why), `PROOF.md` (the lemmas),
then the header of `enum.cpp`.
Labels: [E] established with source, [C] computed here (command given), [J] proposal.

Scope note. The project skill (`.claude/skills/lattice-knot-tables`) lists lower-bound proofs
as out of scope. The user reopened them on 14 Nov 2026 with the goal "a breakthrough, analytic
or computational"; this directory is that work. Nothing here changes the Goal 1 tables.

## 00. New 18 Nov 2026: Len = 40 for 6_1, 6_2, 6_3, 3_1#3_1, 3_1#-3_1

The unconfined run n = 38 (`enum 38 -stair -tourcap 3`, 1000 parts on Actions) is complete:
18 945 survivors, all of type 0_1, 3_1, 4_1, 5_1 or 5_2 (`out/n38_stair.rigorous.txt`, ALL
RESOLVED). So every other knot has Len >= 40, and with `out/witness40.txt` the five knots above
have Len = 40 (PROOF.md section 7). Slab consequences: PROOF_SLAB.md section 8. Next for the
bulk: n = 40 (about 2200 runner-hours) would give Len(8_19) = 42 and the census of the five
knots at 40; composite completeness at n = 40 needs the 19-edge knotted half-space arcs.

## 0. Formal proof of Len(5_2) = 36 (15-16 Nov 2026: complete)

Goal set by the user: a rigorous, formal proof with no doubt about pruned branches. State:
* `formal/PROOF_RIGOROUS.md`: the complete argument (read this first). Two rounds of adversarial
  review (reports summarised in the commit messages "revision after review round 1/2").
* `lean/` (plain Lean 4.25.0, no Mathlib). Everything is proved, with no sorry: `no_short` (Main.lean)
  says `KnotClass T -> TopHyp T -> CompCert -> forall w, T w -> 36 <= |w|`, with axioms
  propext, Classical.choice and Quot.sound. Build: `cd lean && lake build Len52`.
  `.github/workflows/lean-proof.yml` rebuilds it on GitHub and prints the axioms.
* **CompCert holds (16 Nov 2026).** It is equivalent to 1358 Booleans `checkPart n r` (Cert.lean),
  evaluated by `lake exe checkpart n r`. `python3 formal/verify_comp.py` accepts all 1358 parts and
  writes out/lean/COMPCERT.txt. Every part ran on GitHub Actions (lean-enum runs 43735396072,
  43770731268, 43927007974); the C++ cross-check (in 43770731268) agrees at every length.
* **Provenance = GitHub's job logs**, archived by `formal/gha_archive.py <run>` into
  out/lean/gha_runs/<run>/. verify_comp accepts a part only if its committed log is byte-identical to
  the block the job printed, in a successful job of a lean-enum run whose head commit has the frozen
  sources and the same `run` job. After any new proof run: archive it, then re-run verify_comp.
  The first two runs' collect jobs could not push (read-only default token); lean-collect.yml
  (edit lean/ci/collect.json) commits an earlier run's artifacts. lean-enum.yml now requests
  `contents: write` itself.
* Reproduction: out/lean/REPRO.txt (8 random parts re-run locally, byte-identical); the 206 parts
  first run locally were re-run on GitHub with byte-identical outputs.
* Review: three adversarial rounds. Round 3 (referee report summarised in the commit messages
  "referee round 3") found no mathematical error; its provenance and wording objections are fixed.
* PDFs: paper/len52.pdf; formal/PROOF_RIGOROUS.pdf (pandoc -f gfm to HTML, then Chromium print).
* Paper: paper/len52.tex (build: pdflatex, bibtex, pdflatex x2; numbers from paper/figs/make_figs.py).
  Site: site/ (data from site/build_data.py), published by .github/workflows/pages.yml from main.
* If a GitHub part fails: re-run that job from the Actions page, or run the part locally with
  run_local.sh. Never change Spec/Diagram/Search/Coloring/Cert/CheckMain/lakefile: the source hash
  ties every log to them.
* Not used by this proof: the plane-crossing lemma, the arc lemma, primeness, and the faster `-prime`
  C++ runs below (they remain as cross-checks).

## 1. What exists and what it shows

Len(K) = least number of edges of a simple-cubic lattice polygon of knot type K.
Proved in the literature: Len(3_1) = 24 [Diao93]; Len(4_1) = 30 and Len(5_1) = 34 [Scharein09],
whose full proofs were never published. Everything else is an upper bound.

**Method.** For each even n, `enum n` lists every n-edge polygon that could be the chosen
shortest polygon of its knot type. Two lemmas do the pruning (full proofs in `PROOF.md`):
the *curtain lemma* (a stretch that goes up, runs level, and comes down can be pushed down
unless a vertex sits under its interior) and the *pushed-down normal form* (among shortest
polygons take one minimising total height, then total y; then every corner that could be
flipped downwards is blocked by a vertex). If no survivor of length <= m has knot type K,
then Len(K) > m.

**Results so far [C].** Commands are `./enum N -out out/nN_psi.txt 2> out/nN_psi.log` unless noted.

| n | search nodes | survivors | what they are |
|---|---|---|---|
| 6-22 | up to 1.5e7 | 0 | so every knot needs >= 24 edges (machine proof of [Diao93], given the lemmas) |
| 24 | 6.8e7 | 50 | all Alexander t^2 - t + 1 (trefoil) |
| 24, `-nopsi` | 1.0e9 | 2592 | expand by the 48 symmetries to exactly 3328 polygons in 75 classes = [Scharein09]'s numbers |
| 26 | 4.8e8 (earlier build) | 62 | all trefoil polynomial (non-shortest trefoils the leaf filter cannot shorten) |
| 28, `-prime` | 3.2e8 | 98 | all trefoil polynomial; with n <= 26 this excludes a 4_1 polygon below 30 edges |
| 30, `-prime` | 1.486e9 (8 parts on GitHub Actions; 3 parts repeated locally, byte-identical) | 190 | 92 are 3_1, 98 are 4_1 (`out/n30_prime.rigorous.txt`); the flip closure of the 98 is 3648 polygons in 76 symmetry classes (`out/n30_4_1.census.txt`), the published count of minimal 4_1 polygons |
| 32, `-prime` | 7.76e9 (64 parts, Actions run 43675517776, 36.5 runner-h) | 542 | 76 3_1, 466 4_1 (`out/n32_prime.rigorous.txt`, ALL RESOLVED) |
| 34, `-prime -tourcap 3` | 7.74e10 (240 parts, run 43677800789, 12.6 runner-h) | 1398 | 88 0_1, 134 3_1, 1056 4_1, 120 5_1; **no 5_2**. The 120 5_1 words rebuild 6672 polygons in 142 classes (`out/n34_5_1.census.txt`) = [JvRR11] |
| 36, `-prime -tourcap 3` | 4.33e11 (250 parts, run 43678208728, 78.4 runner-h, slowest part 25 min) | 6662 | 462 0_1, 364 3_1, 2756 4_1, 2068 5_1, 1012 5_2; the 1012 5_2 words rebuild 114 912 polygons in 2396 classes (`out/n36_5_2.census.txt`) = [JvRR11] |
| 20-26, `-prime` | 7.7e5 to 6.1e7 | 0, 0, 50, 62 | same survivor files as without `-prime` |

Independent checks: `check/REPORT.txt` (Python written by a Haiku agent from the definitions
only: validity of every word, the 3328 count, flip classes, and that the 50 normal-form
survivors are exactly the words of the 2592 that satisfy the pushed-down condition, with one
in every flip class). Plain polygon counts for n <= 16 equal the known values. Output files
were byte-identical across six rewrites of the bounds.

**Composite knots [C].** `-prime` is complete for prime knots only, but PROOF.md section 2b
(Lemma 4, programs `arcknot.cpp` and `unknot_cert.cpp`, logs in `out/arc/`) shows that the one
case it misses needs at least 40 edges (`arcknot 18` finished on 15 Nov: 3.57e9 arcs, none
knotted, `out/arc/arc18.log`). So for n <= 38 the `-prime` and `-stair` outputs are complete
for all knot types.

**Identification.** `identify_rigorous.py` simplifies each survivor's diagram to at most 5
crossings and reads the type from the Alexander polynomial; outputs are `out/*.rigorous.txt`.
A 36-edge 5_2 polygon is in `out/upper_5_2_len36.txt` (from `data/rechnitzer_SC_minimal.csv`).

**Result [C], 15 Nov 2026.** Given the lemmas of PROOF.md and correctness of `enum.cpp`,
`arcknot.cpp`, `unknot_cert.cpp`: every knot type other than 0_1, 3_1, 4_1, 5_1 has Len >= 36,
so **Len(5_2) = 36** (upper bound: `out/upper_5_2_len36.txt`); and every knot type other than
0_1, 3_1, 4_1, 5_1, 5_2 has Len >= 38 (so 6_1, 6_2, 6_3, 3_1 # 3_1 need 38 or 40; best known 40).
End-to-end checks: the survivors rebuild the published minimal-polygon counts 3328 (3_1, 24),
3648 (4_1, 30), 6672 (5_1, 34), 114 912 (5_2, 36). Not formally verified and not yet reviewed
by anyone outside this project; `raster.cpp` has not been compared beyond n = 22.
Next: n = 38 (section 3, step 4); the arc lemma for 18 edges that it needs is done.

## 2. Files

| file | what |
|---|---|
| `enum.cpp` | the enumerator; options in its header (`-prime`, `-nopsi`, `-plain`, `-noaxes`, `-bridge B`, `-part R M`, `-tourcap C`, `-threads T`) |
| `run_parts.sh` | resumable driver: `./run_parts.sh N M R1 R2 ...` runs parts R of M, skips finished ones |
| `PROOF.md` | statements and proofs of the lemmas and of completeness of the search |
| `LEADS.md` | the three leads, ranked, with evidence, first steps and kill criteria |
| `out/` | survivors (`.txt`) and run lines (`.log`) per n; `n24_nopsi.txt`; `nN_bridge3.*` |
| `check/` | independent cross-check of the n = 24 lists |
| `bridge/` | bridge number vs Len for 801 knots (KnotInfo data); `bridge/pretzel/` annealing attack on the bridge inequality |
| `identify_words.py` | Alexander polynomial and SnapPy name for a file of words |
| `identify_rigorous.py` | simplifies each diagram to at most 5 crossings, then names it by Alexander polynomial |
| `arcknot.cpp`, `unknot_cert.cpp` | Lemma 4 (PROOF.md 2b): arcs of at most 16 edges in a half-space are unknotted; `./arcknot L \| ./unknot_cert` |
| `check/census_from_survivors.py` | full census of a knot type at its minimal length from the survivors (flip closure and symmetries) |
| `.github/workflows/exact-enum.yml`, `ci/request.json` | the enumeration on GitHub Actions (section 3) |
| `slab.cpp`, `queue_slab.sh`, `PROOF_SLAB.md`, `check/slab_census.py`, `out/slab/` | shortest knots confined to a slab 0 <= z <= L (section 3a) |
| `check/witness40.py`, `out/witness40.txt` | 40-edge polygons of 6_1, 6_2, 6_3, 3_1#3_1, 3_1#-3_1 and their check (upper bounds for section 3 step 4) |
| `raster.cpp` | site-by-site sweep, same conditions; 3.9e9 nodes at n = 22 against 1.5e7, kept as a negative result and as the starting point for lead 2 |
| `../colab/colab_il_T4.log` | the one Colab training run (section 5) |

Build: `g++ -O3 -march=native -std=c++17 -pthread -o enum enum.cpp` (binaries are gitignored).
Python: `python3 -m pip install --break-system-packages snappy spherogram database_knotinfo`.

## 3. How to resume the main computation (lead 1)

**GitHub Actions (what is running now).** `.github/workflows/exact-enum.yml` starts when
`research/exact/ci/request.json` changes on this branch. One push = one run of at most 256
jobs; each job builds `enum`, repeats the n = 22 and n = 24 self-tests, runs one part
(limit 350 minutes; a part of n = 30 in 8 took 24 to 41 minutes), and the last job commits
`out/ci/*.partR_M.{txt,log}`, `out/nN_prime.ci_summary.txt` and, only if every part is
present, the merged `out/nN_prime.txt`. If parts fail, re-run the failed jobs from the
Actions page (or push the same request again); finished parts are kept as artifacts for
30 days. Then run `python3 identify_rigorous.py out/nN_prime.txt`.

**Queue on 15 Nov, 04:50 UTC, and what to do as each run lands.** Runs execute one after
another (20 jobs at a time): n = 32 (run 43675517776, 64 parts, old cap), n = 34 (run
43677800789, 240 parts, `-tourcap 3`), n = 36 (250 parts, `-tourcap 3`). Each run ends with a
commit "exact: enumeration parts from GitHub Actions run ..." on this branch.
1. After each such commit: `git pull`, look at `out/nN_prime.m*.ci_summary.txt` (first line
   says COMPLETE or how many parts are missing), then
   `python3 identify_rigorous.py out/nN_prime.txt` (must end with ALL RESOLVED).
2. n = 34: expect only 3_1, 4_1, 5_1. Then
   `python3 check/census_from_survivors.py out/n34_prime.txt --alex "1,-1,1,-1,1"` must give
   T = 6672 [JvRR11]. With that, the theorem "every knot other than 3_1, 4_1, 5_1 has
   Len >= 36, so Len(5_2) = 36" is complete (PROOF.md section 5).
3. n = 36: expect 3_1, 4_1, 5_1, 5_2 only; census of 5_2 with `--alex "2,-3,2"`, the sampled
   number is 114 912 [JvRR11].
4. n = 38: submitted on 17 Nov 2026 in four requests of 250 parts each,
   `{"runs": [{"n": 38, "m": 1000, "from": 0, "to": 250, "opts": "-stair -tourcap 3", "tag": "stair"}]}`
   then from 250 to 500, 500 to 750, 750 to 1000 (all four pushed; the runs are independent, each
   builds from its own commit; `git log ci/request.json` lists them). Each run
   commits its parts as `out/ci/n38_stair.part*_1000.*` and a summary
   `out/n38_stair.m1000.ci_summary.txt`; the merged `out/n38_stair.txt` is written by the
   run that finds all 1000 parts present. (`-stair` is `-prime` plus the staircase rule of
   PROOF.md section 2a; at n = 32 it gave the same 542 words as `-prime`.) Expected cost
   350 to 430 runner-hours; a job is killed at 350 minutes, the slowest n = 36 part of 250
   took 25 minutes. The runs share the 20 runners with the Lean re-runs of section 0, so
   they may wait for hours before starting.
   Then `python3 identify_rigorous.py out/n38_stair.txt` (must end ALL RESOLVED). If no
   knot outside {0_1, 3_1, 4_1, 5_1, 5_2} survives, then Len(6_1) = Len(6_2) = Len(6_3) =
   Len(3_1 # 3_1) = 40. The arc lemma for 18 edges, needed for composites at n = 38, is
   done (`out/arc/arc18.log`: 3.57e9 arcs, none knotted).
   The upper bounds are in the repo: `out/witness40.txt` has one 40-edge polygon each of
   6_1, 6_2, 6_3, the granny knot 3_1 # 3_1 and the square knot 3_1 # -3_1, and
   `python3 check/witness40.py` identifies them (6-crossing diagram, Alexander polynomial,
   and the Jones polynomial to tell granny from square); it must end ALL WITNESSES OK.
   So an empty n = 38 gives Len = 40 for all five.
5. Local cross-checks. n = 30 with `-tourcap 3` (`out/n30_primec3.part*`): done, the same
   190 words as `out/n30_prime.txt`. n = 30 with `-stair -tourcap 3` (`out/n30_stair.part*`):
   done, the same 190 words, 2.16e9 nodes against 2.64e9. n = 32 with `-stair -tourcap 3`
   (`queue_stair.sh`, 32 parts, files `out/n32_stair.part*_32.*`, started 05:07 UTC on
   15 Nov, about an hour on 4 vCPU): the sorted union must equal `out/n32_prime.txt` from
   Actions. To resume after an interruption:
   `ENUM_BIN=./enum ENUM_OPTS="-stair -tourcap 3" TAG=stair ./run_parts.sh 32 32 $(seq 0 31)`
   (finished parts are skipped).

**Locally:**

```
cd research/exact
g++ -O3 -march=native -std=c++17 -pthread -o enum enum.cpp
./enum 22 -out /dev/null                      # expect nodes=14572713 survivors=0
./enum 24 -prime -out /tmp/a.txt && cmp /tmp/a.txt out/n24_psi.txt     # expect identical, nodes=14938363
ENUM_OPTS=-prime TAG=prime setsid nohup ./run_parts.sh 28 2 0 1 > /dev/null 2>&1 &
ENUM_OPTS=-prime TAG=prime setsid nohup ./run_parts.sh 30 8 $(seq 0 7) > /dev/null 2>&1 &
# then n = 32 with M = 32 and n = 34 with M = 128
sort -u out/n30_prime.part*_8.txt > out/n30_prime.txt
python3 identify_words.py out/n30_prime.txt   # expect only the 3_1 and 4_1 polynomials
```

`-prime` uses the plane-crossing lemma (PROOF.md Lemma 3). Its output is complete for prime
knots, which is what Len(5_2) = 36 needs. Without it the search is complete for all knot
types and 5 times larger.

Cost, measured up to n = 28 [C], projected beyond [J]. With `-prime` this 4-vCPU container
does about 3.5e5 nodes/s (the cheap nodes are the ones the lemma removes; the rest are
costly), and the tree grew 4.1-fold from 24 to 26 and 5.2-fold from 26 to 28.

| n | nodes with `-prime` | time on 4 vCPU |
|---|---|---|
| 26 | 6.1e7 | 2 min |
| 28 | 3.2e8 | 15.5 min |
| 30 | about 1.5e9 | about 75 min |
| 32 | about 7e9 | about 6 h |
| 34 | about 3.3e10 | about 27 h |

Without `-prime` (complete for composite knots too) everything is about 5 times larger.
An earlier version of this file said 4.5 h for n = 34; that used the speed of the
unpruned search and was wrong.

**`-tourcap 3` makes the search about 10 times faster [C, 15 Nov].** The exact search over
visiting orders stops after `-tourcap` calls and then answers "possible". The default 3000
was tuned at n = 22; at n = 28 two thirds of all calls were in searches that gave up anyway.
n = 28, part 0 of 32, one thread: cap 3000: 131 s, 1.01e7 nodes; 300: 63 s; 100: 41 s;
30: 26 s; 10: 19 s; 3: 15 s, 1.64e7 nodes; 1: 13.5 s; 0: 13.2 s, 1.81e7 nodes. Survivors
identical in all cases. Use `-prime -tourcap 3` from now on (about 1.2e6 nodes/s per core
here). The cost table above is for the old cap; divide the times by about 8.
Other lengths, one thread: n = 22: 6.2 s -> 2.9 s (cap 10); n = 24: 52 s -> 17 s (cap 10),
10 s on 4 threads with cap 3 and the same 50 words; n = 26: 444 s -> 98 s (cap 10);
n = 30, part 5 of 64: cap 3: 43 s, 4.23e7 nodes; cap 10: 58 s, 3.92e7 nodes. So cap 3 is
still the better choice at n = 30. The tree with cap 3 is 1.3 (n = 22) to 1.8 (n = 30) times
the tree with cap 3000, and this ratio grows slowly with n.
Projection [J] with cap 3 on Actions runners (4 threads, half the speed of this container):
n = 34 about 16 runner-hours, n = 36 about 90, n = 38 about 500.

**Census check at n = 24 [C].** `python3 check/census_from_survivors.py out/n24_psi.txt
--alex "1,-1,1"`: the 50 survivors give a flip closure of 2592 and, with the 48 symmetries,
3328 polygons in 75 classes: the published number of shortest trefoils [JvRR11]. With 3648
at n = 30 for 4_1 this is the end-to-end test of the search: a missed flip class would show
as a smaller count. The next such test is 6672 for 5_1 at n = 34.

**Where the time goes [C, gprof at n = 22, old cap].** 64 % in the exact search over visiting orders
(`tour`), 18 % in building and reusing the cheap order (`tour_ok`), 15 % in obligation
bookkeeping (`update`), 3 % in the walk itself. About 40 % of nodes need the exact search,
about 66 recursive calls each. Tried and reverted, because output and time were unchanged or
worse: predecessor / successor / spanning-tree bounds on a distance table before and inside
the exact search. The infeasible cases are infeasible because of visiting order, which only
the search sees. So the remaining levers are (a) more cores, (b) a smaller tree (LEADS.md
lead 2), not a faster bound.

Parts are independent, so more cores shorten this in proportion. Commit `out/` after each
batch of parts; the logs are the evidence.

## 3a. Slab-confined minimal lengths (started 17 Nov 2026)

n_{L,K} = fewest edges of a polygon of type K inside 0 <= z <= L. Only n_{1,3_1} = 26 has a
published proof; arXiv:1204.6674 gives Monte Carlo values and counts for knots to 7 crossings.
`slab.cpp` is `enum.cpp` plus `-slab L` (enum.cpp itself is left untouched because its hash is
in the logs of the unconfined results). Why the lemmas still hold, the checks, and the results
table are in `PROOF_SLAB.md`; keep that table current.

* Run: `nohup ./queue_slab_parts.sh "1:38:8 2:32:8 1:40:16 2:34:16 1:42:48" > q.out 2>&1 &`
  (items L:n:m; m parts per run, parts in `out/slab/local/` (not committed: cheap to redo),
  merged into `out/slab/L<L>_n<n>.*`
  when all are done). Use this rather than the older `queue_slab.sh`: the container is often
  restarted and then a whole unpartitioned run is lost; here at most one part is lost.
  Restartable: finished parts (log has `seconds=`) are skipped; delete `*.tmp` first.
* After each run: `./slab_report.sh` (one line per run), or `python3 identify_rigorous.py out/slab/L1_n36.txt` (must end ALL RESOLVED),
  and at a minimal length the census, e.g.
  `python3 check/slab_census.py out/slab/L1_n36.txt --alex "1,-3,1"`; compare with the
  published count (4_1: 1480 at L = 1, 6064 at L = 2; 5_1: 72 per chirality at L = 1, 760 at
  L = 2; 5_2: 6240 per chirality at L = 1). A match is an independent test of the search.
* Cost [C]: the 1-slab grows by 3.5 per two edges (n = 34: 91 s on 4 cores, so n = 40 about
  1 h, n = 42 about 4 h, n = 48 about 170 h: use Actions); the 2-slab by about 4.4
  (n = 26: 12 s, n = 34 about 1.3 h, n = 40 about 100 core-hours).
* **Status 17 Nov (see PROOF_SLAB.md sections 4-5 for proofs and tables).** Proved [C]:
  n_{1,3_1} = 26, n_{1,4_1} = 36 (census 1480), n_{1,5_1} = 38; n_{L,3_1} = 24 and
  **n_{L,5_1} = 34, n_{L,5_2} = 36 for all L >= 2**, n_{L,4_1} = 30 for L >= 3 (from the
  unconfined censuses split by height; every published count reproduced). Upper bounds
  (soft-wall annealing): 1-slab 5_2 42, 6_1 48, 6_2 48, 6_3 50, square 44, **granny 46 (published
  Monte Carlo value 48)**; 2-slab 6_1 42, 6_2 42, 6_3 44. Next, as runs finish:
  - Done: 1-slab n = 40: no 5_2, no composite => n_{1,5_2} = 42. 1-slab n = 42: no composite =>
    n_{1,square} = 44; census of 5_2 in the 1-slab = 14192 (7096 per chirality) against the
    published 6240: the published count is too low (explicit list out/slab/census_L1_5_2_n42.txt).
  - Done 17 Nov: n_{1,5_1} = 38 (census 144) and n_{2,4_1} = 32 (census 6064), as published.
  - Done: W = 1 arcs L = 21 (24 knotted, end points fix the handedness: no granny at 44 from a
    wall, 144 squares; PROOF_SLAB.md section 7). Granny = 46 once Actions 1-slab n = 44 shows none.
  - Done: W = 2 arcs L = 19: 448 square + 16 granny polygons at 40 = published counts (section 6).
  - Done locally 17 Nov (4 parallel parts each, `arcslab -part R M`): W = 1 arcs L = 22 (86 knotted,
    end points fix the handedness: 22+22 only squares) and L = 23 (1540): 21+23 gluings give 96
    grannies at 46 (PROOF_SLAB.md section 7). The Actions arc run 44068540954 was cancelled as
    redundant; `arc-enum.yml` stays for longer arcs.
  - W = 2 arcs to L = 19: pair analysis gives the 2-slab composites at 40.
  - Actions 1-slab n = 46, 2-slab n = 38, 40: lower bounds for the six-crossing knots
    (with the witnesses above: n_{1} = 48, 48, 50 and n_{2} = 42, 42, 44 if nothing shorter).
  - Unconfined n = 38 (Actions): Len(6_x) = 40 and Len(composites) = 40 => with the height-3
    witnesses (out/witness40.txt: 6_1 and both composites have height 3) n_{L} = 40 for L >= 3;
    6_2, 6_3 need height-3 polygons (`./anneal_soft.sh 3 ...`; found: out/slab/witness_L3.txt).
  - **18 Nov ~06:40 UTC: slab runs 44060487866 (1-slab 44, 46; 2-slab 40) and 44089937624 (1-slab 48,
    2-slab 42) CANCELLED** so that the last n = 38 collect job (queued behind them) could run.
    Resubmitted 18 Nov ~07:30 after n = 38: the 123 parts of {L1 n44 m16, L1 n46 m64, L2 n40 m64} not
    yet in out/slab/ci (one request entry per part). Then (same time) {L1 n48 m128, L2 n42
    m128} for 6_3 resubmitted as a second run.
  - (Earlier) submitted 13:15 UTC: 1-slab n = 48 and 2-slab n = 42 (128 parts each, about 670 runner-hours)
    for 6_3 (published 50 and 44). With these, every entry of the table to 6 crossings is decided.
* On Actions: `.github/workflows/slab-enum.yml`, started by a push that changes
  `ci/slab_request.json` (runs with L, n, m and optional from/to, opts). Parts land in
  `out/slab/ci/L<L>_n<n>.part<r>_<m>.*`; when all parts of a run are there the collect job
  writes `out/slab/L<L>_n<n>.txt` and `.log` (so `slab_report.sh` and `queue_slab.sh` see it).
  Submitted 17 Nov (re-submitted 10:00 UTC, the first run was based on a commit without the
  self-test reference files): 1-slab n = 44 (16 parts), 46 (64); 2-slab n = 40 (64); about 190
  runner-hours, queued behind the n = 38 run and the Lean runs (run 44060487866; runs 43987782203
  and 44057098590 were cancelled but still showed `queued` at 10:50 UTC: cancel again if they
  start). (2-slab n = 36, 38 dropped:
  with the unconfined n = 38 run they add nothing.) They give the lower
  bounds for 6_1 and 6_2 (48 in the 1-slab, 42 in the 2-slab); the upper bounds need explicit
  polygons (anneal inside the slab with `research/code` bfacf, ZMAX argument, or run the
  census length itself).
* Composite knots: the half-slab arc lemma is done for L = 1 up to 20 edges
  (PROOF_SLAB.md section 1a; `./run_arcslab.sh 1 24 L...`), so the 1-slab search is complete
  for all knot types to n = 42. Running: L = 21 for W = 1 (knotted 21-edge arcs exist; then
  `python3 check/arcslab_pairs.py 1 21` decides what two such arcs glued across a wall give:
  square/granny at 44) and W = 2 (`./run_arcslab.sh 2 22 11 ... 19`; minsum 22 because every
  knot in the 2-slab has >= 24 edges); with W = 2 up to 18 edges plus the pair analysis at 19,
  the 2-slab composites at 40 are settled.
* Upper bounds (explicit polygons): `bfacf_slab H WORD SEED CYCLES N_HIGH N_LOW ZMAX ZLOW [last]`
  is research/code/bfacf.c confined to the H-slab; start words from `braid2slab.py "1,1,2,-1,-3,2,-3"`
  (any braid closure, as a polygon in the 1-slab); check results with `check/slab_word.py WORD`
  (length, height, knot type). In the 1-slab use ZMAX about 0.5, ZLOW about 0.05 (the slab's
  critical fugacity is well above the bulk 0.2135).
  **Caution [observation, 17 Nov]:** from the braid start, 4_1 always ends at 44 edges, even
  after excursions to 400+ edges, while from a 36-edge census polygon it always returns to 36.
  So BFACF inside the 1-slab looks non-ergodic on a knot type, or mixes extremely slowly (no
  proof of irreducibility in slabs seems to be published; arXiv:1204.6674 relies on the bulk
  theorem). Hence (a) annealing in the 1-slab needs many different starts and cannot replace
  the enumeration, and (b) the published Monte Carlo slab values could be too high for some
  knots: compare every exact result with them (5_2 at L = 1: published 42, exact run n = 40
  decides whether it is lower).

## 4. Things that went wrong here (do not repeat)

* The container was restarted after a few hours and killed a 70-minute run that had no
  checkpoint. Use `run_parts.sh` with parts of 15 minutes or less and commit often.
* A Colab session with nothing attached is reclaimed; a `nohup` job on it died with its
  output. Keep a `colab exec` in the foreground for the whole job and download each part.
* `colab run` cannot work from this sandbox: every VM has its own host
  `*.prod.r.colab.dev`, blocked until that exact host is added to the `k-not-theory`
  environment (the tool refuses wildcards; a wildcard can be added in the environment's
  settings by the user). Use `colab --auth=adc new`, allow the host, then `upload` / `exec`.
* A T4 VM has 2 vCPUs, so it adds little for this search. A high-memory CPU VM was refused
  once ("Service Unavailable"); not retried.
* The sweep enumerator (`raster.cpp`) with a root-centred 27 x 15 x 6 box is about 150 times
  slower than the walk enumerator. See lead 2 before reviving it.
* The first exact visiting-order bound cost 30 times more per node than it saved; the cheap
  bounds (span, spanning tree, reuse of the parent's order) are what made it pay.
* The simple bridge filter (`-bridge 3`) cuts the tree 74-fold at n = 22 but only 3-fold at
  n = 26; it will not make n = 38 cheap.
* Two-move rules (17 Nov): a vertex that is the only blocker of a lowering corner flip, or
  the only occupied site of a curtain, must not itself be flippable out of the way. Sound,
  but it cut only 0.5 % of the nodes at n = 22 and 24 (it removes 10 of the 50 output words
  at n = 24), so it was not kept in `enum.cpp`.

## 5. Colab and training (status, for whoever picks up the ML side)

* One run [C]: `census/ml/colab_job.py` from branch `census/native-pipeline`, T4, 20 epochs,
  151 s. Held-out success within 25 / 50 / 100 expansions: value net 37.5 / 53.3 / 75.8 %,
  random 7.5 / 31.7 / 55.0 %, breadth-first 0 / 0 / 18.3 %. This is below the earlier local
  CPU run (48 / 69 / 81 %, `census/README.md`) because the packaged job embeds 60 k of the
  183 k training states and overfits after epoch 9. More GPU does not help; more expert
  data does (it needs the Regina build described in `census/BUILD.md`).
* Nothing in leads 1-3 needs training. The honest ML opening is in `LEADS.md` section 4.
* Other branches not merged here: `census/native-pipeline` (14-crossing census, custom
  identifier `kernel/snapcanon`, pass-move unknotter), `finer_research` (11-crossing table v3).
  A handoff request was sent to the "ML-annealing knot simplification" session; no reply
  arrived before this file was written.
