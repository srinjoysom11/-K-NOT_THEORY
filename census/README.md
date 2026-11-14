# census/: an independent, native prime-knot census pipeline (levels 3-14) and hard-unknot tools

Self-contained directory on its own branch (`census/native-pipeline`); it touches no existing file.
It is a **side deliverable for Goal 1**, not one of tasks T1-T7: it enumerates prime knot diagrams up to
14 crossings, identifies knots by a canonical complement signature, and provides a `word -> name`
style identifier (`kernel/snapcanon`) plus a diagram for every knot. See "How this could feed Goal 1" (all [J]).

Evidence labels (the repo's rule 6): **[E]** established, with source; **[C]** computed here, with the command
and output file; **[J]** conjecture or proposal, with how to check it. Nothing here claims a Len(K) value.

## 1. What was computed

### 1.1 Exact census, levels 3-14 [C]
Number of prime knots with exactly n crossings (up to mirror image), alternating + non-alternating, found by
`python -m knotml.build3` and compared with the published table [E: Thistlethwaite, "The enumeration and
classification of prime 20-crossing knots", Table 3; Burton, "The Next 350 Million Knots", SoCG 2020]:

| n | found | published | match |
|---|---|---|---|
| 8 | 18 + 3 | 18 + 3 | yes |
| 9 | 41 + 8 | 41 + 8 | yes |
| 10 | 123 + 42 | 123 + 42 | yes |
| 11 | 367 + 185 | 367 + 185 | yes |
| 12 | 1288 + 888 | 1288 + 888 | yes |
| 13 | 4878 + 5110 | 4878 + 5110 | yes |
| 14 | 19536 + 27436 | 19536 + 27436 | yes |

Levels 3-7 also match (1+0, 1+0, 2+0, 3+0, 7+0). Output: `evidence/levels3-13_build3_fresh_run.log` (one fresh
run from an empty data directory), `evidence/level14_build3_final.log`.
Matching published counts is a **check, not a proof**. It does not show that each output knot corresponds to a
named table entry; the knot-by-knot match (a bijection with KnotInfo or the Regina census) has not been done [J].

Level 14 first gave 27,437 non-alternating (`evidence/level14_build3_before_canonical_fix.log`). Cause [C]:
the extracted SnapPea identifier occasionally returns a non-canonical retriangulation (20 tetrahedra where the
canonical one has 28), so one knot carried two ids. Equal ids prove the same knot; unequal ids prove nothing.
Fix (pipeline level): `knotml/build3.py:canonicalize_new` re-canonizes each new id to a fixpoint of SnapPy's
`isometry_signature` (2 ids changed at level 14). Independent check afterwards, `python -m knotml.verify 14`:
59,924 hyperbolic ids over levels <= 14, 7,978 equal-volume pairs, 0 isometric pairs (0 duplicate ids).
The 3 non-hyperbolic ids at level 14 are the published 1 torus knot + 2 satellites. All ids found:
`evidence/census_ids_levels_le14.json.gz` (id -> level; level -1 marks resolved composite diagrams).

### 1.2 Speed [C]
Level 12, 4 cores: **14.8 s** (`evidence/levels3-13_build3_fresh_run.log`) against the original Python pipeline's
logged stages, generation+simplify 47.15 s plus identification 41.04 s = 88.2 s
(`evidence/baseline_python_pipeline_levels11-12.log`, same machine, same session), i.e. at least 5.9x counting only
those two stages (shadow enumeration in the baseline was not logged). Level 13: 91.5 s. Level 14: 788 s, measured
while other jobs shared the 4 cores, so conservative. Machine load was not recorded for the 14.8 s run. The
speedup is the product of the steps in section 3; no step trades correctness.

### 1.3 Hard unknot diagrams [C]
The 21 diagrams of Burton et al. (arXiv 2104.14076, Appendix A Gauss codes; validated and loaded with
`regina.Link.fromGauss`, stored in `ml/unknots/all_unknots.txt`).
* Regina `simplify()` alone solves only 5 of 21 (Monster, Thistlethwaite, Ochiai I, Tuzun-Sikora, Ochiai III).
* **`kernel/pass`** (generalized pass moves, section 3.6): default `--H 2 --paths 4` solves 19 of 21, including
  PZ78; `--H 3 --paths 8` also solves PZ138 (20 of 21). PZ120 is unsolved. Output: `evidence/pass_hard_unknots.txt`.
* `kernel/unknot` (random walk of Regina-checked Reidemeister moves, crossings capped at current + 4, 3M-proposal
  stages, 5 seeds): 13 of the 16 diagrams not solved by `simplify()` are solved in 5 of 5 runs (D28 0.6 s, D43 1.3 s,
  Haken 141 crossings 0.23 s); PZ78, PZ120, PZ138 are not (0/3 even at 30M-proposal stages). Output:
  `ml/unknots/bench1.log`, `ml/unknots/bench_pz.log` (partial).
What it does not show: a Z-move route certifies that a diagram is an unknot (isotopy) but gives **no bound on m(D)**,
the Reidemeister-move measure of Burton et al. Converting each Z3 into Reidemeister moves would [J].

### 1.4 `kernel/pass` correctness check [C]
Exact, chirality-sensitive HOMFLY-PT before vs after on 2,000 census diagrams (`ml/pass_sample_2000.txt`; diagrams
that `simplify()` cannot reduce): **0 mismatches** in three modes, including `--scramble 3`, where 1,786 diagrams
gain crossings. Command: `python ml/check_pass.py in out`. Output: `evidence/pass_homfly_check.txt`.
Recall on truly reducible survivors (labels from the census): 1,110 of 1,122 (98.9%), 0 false reductions
(computed against local census labels not shipped here; rerun by `build3` data) [C, output not saved].

### 1.5 Negative and modest results [C, interactive runs; commands in RESULTS.md]
* Replica exchange did **not** beat annealing on hard-diagram reduction (80-85% vs 90% at 4000 proposals); a
  capped random walk matches annealing. The crossing cap, not temperature, is the active ingredient here.
* Gradient-boosted pruning of candidate diagrams: AUC 0.58-0.84, safe savings at most about 13%, some settings lose knots.
* Imitation-learned graph network (value of a diagram = moves to a smaller one), trained on level 11 only,
  tested on 120 unseen level-12 hard diagrams: success within 25 / 50 / 100 expansions 48 / 69 / 81% vs random
  7.5 / 32 / 55% vs BFS 0 / 0 / 18% (`ml/guided_search.py`, `ml/train_il.py`). A sample-efficiency result only:
  1.39 ms vs 0.15 ms per expansion in Python. Training log: `evidence/train_local.log`.
* RL fine-tuning (`ml/rl_finetune.py`) runs end to end; at CPU smoke-test scale success 0.95 -> 0.90, no gain
  (`evidence/rl_local.log`). The Colab job (`ml/colab_job.py`) was tested locally on CPU, never run on Colab.

## 2. Layout
| path | what |
|---|---|
| `knotml/` | Python drivers: `build3.py` (pipeline), `verify.py`, `native_id.py`, `kernel.py`, older `build.py`/`build2.py`, map/shadow code |
| `kernel/shadows.cpp` | enumerates knot shadows (non-separable plane maps -> medial graphs), no Regina needed |
| `kernel/gen.cpp` | resolves crossings with the bigon (R2) criterion, Regina `simplify()`, emits survivors |
| `kernel/bfsclose.cpp` | global Reidemeister closure with union-find (merges diagrams, proves reducibility) |
| `kernel/snapcanon/` | extracted SnapPea kernel + Regina isoSig: canonical id of a knot complement (GPL, see `snappea/NOTICE.md`) |
| `kernel/pass.cpp` | generalized pass moves (Petronio-Zanellati Z3), standard library only |
| `kernel/search.cpp`, `unknot.cpp`, `expert.cpp`, `r3close.cpp` | random-walk / annealing / tempering search, hard-unknot driver, imitation-learning data, R3 classes |
| `ml/` | graph value net, imitation and RL scripts, Colab job, hard-unknot codes, sample inputs |
| `evidence/` | logs and outputs cited above |
| `RESULTS.md`, `PLAN_KAGGLE.md` | full running notes (older sections predate the evidence labels above; trust this README where they differ) |

## 3. Why the pipeline is fast and still exact
Each step removes work only by proof: (1) C++ generation on Regina's engine; (2) bigon criterion: if the same strand
is over at both crossings of a 2-sided face the diagram is R2-reducible, so skip it before building it; (3) flype-class
reduction: one shadow per alternating knot (Menasco-Thistlethwaite flyping theorem [E]; a flype carries any
crossing assignment to the same knot with the same crossing count [E: Burton 2020, Sec. 3.2]); (4) Reidemeister
closure: diagrams connected by Regina-checked moves are one knot, and any state with fewer crossings proves reducibility;
(5) native canonical identity, byte-identical to SnapPy's `isometry_signature` on 10,880 test diagrams (reported by
the extraction run; the 14-crossing duplicate check above is the independent confirmation); (6) `kernel/pass` as a deterministic
reducibility prover (not yet wired into `build3`).
Coverage assumption to keep in mind [J]: composites and satellites are resolved by exhaustive search up to height 2 and
HOMFLY matching of torus knots; the exact published counts at 13 and 14 (1 torus + 2 satellites at 14) support this, not prove it.

## 4. Provenance and known gaps
* `kernel/pass.cpp` was written by a parallel Claude Code session at my request and verified here (md5 of the
  transcription equals the sender's, `ed57d53a42e53e0fb1ac2ee93e3a8b82`; compile, self-test, HOMFLY invariance, hard unknots above).
* `kernel/snapcanon` was extracted from SnapPy (commit `8b4e86f`) by a Claude Code subagent; its multi-component-link
  path hangs on one test link (knots only are validated and used). Its README was not written; `Makefile` documents the build.
* Regina is built from the official tag `regina-7.4.1`; it is not vendored (BUILD.md).
* Open: PZ120 (needs the Petronio-Zanellati move C), a Reidemeister bound m(PZ78), the knot-by-knot match to a named table,
  levels 15-16 (model: about 68 min and 6 h; not run), wiring `kernel/pass` into the pipeline, and a real Colab/GPU run of `ml/colab_job.py`.

## 5. How this could feed Goal 1 [J]
* The 12-crossing census gives one diagram for each of the 2,176 knots (alternating and non-alternating), the input `research/code/seeds.py`
  needs; `kernel/snapcanon` is a `word -> name`-style identifier (T1) once a word is converted to a PD code (`code/latticeknot.py` already does that).
* Check: convert the 801 existing seeds' names with `snapcanon` and compare with the repo's SnapPy names (T1's exit test).
