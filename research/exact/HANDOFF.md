# Handoff: exact minimal lattice lengths by exhaustive enumeration

Branch `claude/great-einstein-snvnnb`. Last updated 14 Nov 2026, about 22:00 UTC.
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
| 28 | not run | | was running on a Colab VM that was reclaimed |
| 30 | part 0 of 16 only: 4.3e8 | 18 | 10 are 4_1 (SnapPy m004), 8 trefoil polynomial |
| 20-26, `-prime` | 7.7e5 to 6.1e7 | 0, 0, 50, 62 | same survivor files as without `-prime` |

Independent checks: `check/REPORT.txt` (Python written by a Haiku agent from the definitions
only: validity of every word, the 3328 count, flip classes, and that the 50 normal-form
survivors are exactly the words of the 2592 that satisfy the pushed-down condition, with one
in every flip class). Plain polygon counts for n <= 16 equal the known values. Output files
were byte-identical across six rewrites of the bounds.

**Not yet shown.** Anything at n = 28, 32, 34; the rest of n = 30. Identification so far is
Alexander polynomial plus SnapPy, not a Reidemeister-simplified diagram. `raster.cpp` (a second
enumerator in a different order) has not been compared with `enum.cpp` beyond "no survivors
for n <= 22". So **no new theorem is claimed yet**.

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
| `raster.cpp` | site-by-site sweep, same conditions; 3.9e9 nodes at n = 22 against 1.5e7, kept as a negative result and as the starting point for lead 2 |
| `../colab/colab_il_T4.log` | the one Colab training run (section 5) |

Build: `g++ -O3 -march=native -std=c++17 -pthread -o enum enum.cpp` (binaries are gitignored).
Python: `python3 -m pip install --break-system-packages snappy spherogram database_knotinfo`.

## 3. How to resume the main computation (lead 1)

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

Cost [C up to n = 26, J beyond]: nodes grow 4.3- to 4.6-fold per 2 edges; this 4-vCPU
container does about 1.6e6 nodes/s when nothing else runs.

| n | nodes with `-prime` | time on 4 vCPU | nodes without | time |
|---|---|---|---|---|
| 26 | 6.1e7 (measured) | 1 min | 3e8 | 3 min |
| 28 | about 2.6e8 | 3 min | 1.4e9 | 15 min |
| 30 | about 1.2e9 | 13 min | 6.9e9 (part 0 of 16 measured: 4.3e8) | 75 min |
| 32 | about 5.5e9 | 1 h | 3.2e10 | 5.5 h |
| 34 | about 2.5e10 | 4.5 h | 1.5e11 | 26 h |

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
