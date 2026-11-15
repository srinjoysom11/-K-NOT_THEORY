# Handoff: exact minimal lattice lengths by exhaustive enumeration

Branch `claude/great-einstein-snvnnb`. Last updated 15 Nov 2026, about 05:00 UTC.
Read in this order: this file, `LEADS.md` (what to do next and why), `PROOF.md` (the lemmas),
then the header of `enum.cpp`.
Labels: [E] established with source, [C] computed here (command given), [J] proposal.

Scope note. The project skill (`.claude/skills/lattice-knot-tables`) lists lower-bound proofs
as out of scope. The user reopened them on 14 Nov 2026 with the goal "a breakthrough, analytic
or computational"; this directory is that work. Nothing here changes the Goal 1 tables.

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
| 32, `-prime` | running on GitHub Actions, 64 parts (run 43675517776) | | |
| 34, `-prime -tourcap 3` | queued on GitHub Actions, 240 parts, run 43677800789 (the first submission, run 43675532405 with the old cap, was cancelled) | | |
| 36, `-prime -tourcap 3` | queued on GitHub Actions, 250 parts (pushed 15 Nov 04:50 UTC) | | |
| 20-26, `-prime` | 7.7e5 to 6.1e7 | 0, 0, 50, 62 | same survivor files as without `-prime` |

Independent checks: `check/REPORT.txt` (Python written by a Haiku agent from the definitions
only: validity of every word, the 3328 count, flip classes, and that the 50 normal-form
survivors are exactly the words of the 2592 that satisfy the pushed-down condition, with one
in every flip class). Plain polygon counts for n <= 16 equal the known values. Output files
were byte-identical across six rewrites of the bounds.

**Composite knots [C].** `-prime` is complete for prime knots only, but PROOF.md section 2b
(Lemma 4, programs `arcknot.cpp` and `unknot_cert.cpp`, logs in `out/arc/`) shows that the one
case it misses needs at least 38 edges (40 if `arcknot 18`, running, finds nothing). So for
n <= 36 the `-prime` output is complete for all knot types.

**Identification.** `identify_rigorous.py` simplifies each survivor's diagram to at most 5
crossings and reads the type from the Alexander polynomial; outputs are `out/*.rigorous.txt`.
A 36-edge 5_2 polygon is in `out/upper_5_2_len36.txt` (from `data/rechnitzer_SC_minimal.csv`).

**Not yet shown.** n = 32 and n = 34 (running). `raster.cpp` (a second enumerator in a
different order) has not been compared with `enum.cpp` beyond "no survivors for n <= 22".
So **no new theorem is claimed yet**. If the survivors at 32 and 34 are only 3_1, 4_1, 5_1,
the statement is: every knot other than 3_1, 4_1, 5_1 needs at least 36 edges, and
Len(5_2) = 36.

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
4. n = 38, not yet submitted. Wait for the part times of n = 36 (in the summary file), then
   push four requests one after another, each when the previous one has been picked up:
   `{"runs": [{"n": 38, "m": 1000, "from": 0, "to": 250, "opts": "-stair -tourcap 3", "tag": "stair"}]}`
   then from 250 to 500, 500 to 750, 750 to 1000. (`-stair` is `-prime` plus the staircase
   rule of PROOF.md section 2a, about 20 % fewer nodes; use it only once the local n = 32
   run with it, step 5, has given the same words as `out/n32_prime.txt`.) If the slowest n = 36 part took more than
   60 minutes, use m = 2000 in eight pushes instead (a job is killed at 350 minutes).
   If no knot outside {3_1, 4_1, 5_1, 5_2} survives at 38, then Len(6_1) = Len(6_2) =
   Len(6_3) = Len(3_1 # 3_1) = 40. For composite knots at n = 38 the arc lemma is needed
   for 18 edges (`out/arc/arc18.log`, running locally on 15 Nov; rerun with
   `./arcknot 18 2> out/arc/arc18.log | ./unknot_cert > out/arc/arc18.unresolved.txt`,
   a few hours on one core).
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
