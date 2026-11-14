# Results so far (all measured on this 4-core box; load from other jobs made some timings noisy)

## 1. Exact census, independent generator
Own enumerator (nonseparable plane maps -> medial graphs -> crossing resolutions;
no plantri), Regina `simplify()` as first filter, SnapPy canonical identity as the
rigorous final test. Reproduces the published prime-knot counts exactly,
every level 3..12 (alternating + non-alternating new knots):

| n | 8 | 9 | 10 | 11 | 12 |
|---|---|---|----|----|----|
| found | 18+3 | 41+8 | 123+42 | 367+185 | 1288+888 |

Two bugs the published counts caught (and the fixes): HOMFLY collisions between
distinct knots at 10 crossings (fixed by using SnapPy's canonical signature as the
identity), and composite knots appearing as non-minimal diagrams at 8 and 9 crossings
(fixed by exhaustive Reidemeister search on non-hyperbolic, non-torus new ids).

## 2. C++ kernel (Regina C++ engine, built from the official 7.4.1 tag)
Candidate generation + `simplify()` at n=12: 47.2 s wall (Python) -> ~10-12 s wall (C++),
4.7x. Census unchanged.

## 3. Rigorous pruning/merging: one global Reidemeister closure (kernel/bfsclose.cpp)
States = diagrams up to n+2 crossings; moves R3, all removals, R2-add (sampled);
union-find across the whole input; any state with < n crossings proves the class
reducible. Every step is a Regina-checked move, so there is no model in the
correctness path. Level 11 (11,067 survivors of simplify):

- 100% of reducible survivors proven reducible at the full setting; 0 false reductions;
  0 impure classes (every class verified to be one knot).
- SnapPy calls: 11,067 -> 561 (19.7x fewer) at full exploration; 826 (13x) at the
  setting used in the pipeline.
- Level 12: 75,935 survivors -> 4,463 SnapPy calls (17x); identity stage 41.0 s -> 3.0 s.
- Sharding the closure by a mirror-invariant Jones hash loses nothing (different Jones
  => different knots). A poorly mixed hash had silently halved parallelism (2 of 4 shards).

## 4. End-to-end, level 12
Old (Python gen + SnapPy on every survivor): gen+simplify 47.2 s + identity 41.0 s
= 88 s (+ shadows). New (C++ gen + sharded closure + SnapPy on reps): 12.1 + 0.8 + 21.3 + 3.0
= 37 s; whole level incl. shadows 43.1 s vs ~94 s (same shadow code) = **2.2x**, with other
jobs running concurrently. Remaining cost: closure 21 s, gen 12 s, shadows 5.8 s.
Closure parameters were tuned on level 11 and then applied to 12; correctness is
checked by the exact census at every level, speed at 12 is out-of-sample for the tuning.

## 5. Learned pruning (negative / modest)
Gradient boosting on diagram-shape features: AUC 0.58-0.61, saves 5-8% (same as random).
Adding HOMFLY/Jones features: AUC 0.72-0.84, but a safe threshold saves <= ~13% and some
settings lose knots. HOMFLY lookup alone saves 52-64% but loses knots (1 of 552 at n=11,
56 of 2176 at n=12) because distinct knots share HOMFLY.
ML-gated rigorous search does not help at n=11 (model features cost 0.34 ms/diagram vs
1.92 ms for SnapPy).

## 6. Annealing vs replica exchange vs random walk (kernel/search.cpp, n=11 hard survivors)
All moves are Regina-checked; 0 false reductions in every run. On survivors where
`simplify()` fails (2% reduced by plateau walk):
- annealing 90% at 4000 proposals (hot schedule, T 3->0.6)
- parallel tempering 80-85% at the same budget: **does not beat annealing**
- a pure random walk with a tight crossing cap (n+2) matches annealing (79% at 2000
  proposals) and is faster; loose caps break it (57% at n+6, 37% at n+8) while annealing is
  cap-insensitive (76-77%). Height cap, not temperature, is the active ingredient here.
- exhaustive height-1 search: 95% but 34 ms on minimal diagrams.
- Economics: search is break-even against SnapPy (+0.07 ms/diagram best case) at n=11
  because SnapPy costs only ~2 ms/diagram. The closure (item 3) is far better.

---
# Update: all-native pipeline (knotml/build3.py) and a new level

## 7. Exact census now reaches 13 crossings (published counts, cold run)
Every level 3..13 reproduces the published prime-knot counts exactly. The 13-crossing level was never
used for tuning (closure parameters were tuned at 11):

| n | new knots found | published | wall (4 cores) |
|---|---|---|---|
| 12 | 1288 + 888 | 1288 + 888 | 14.8 s (was ~94 s) |
| 13 | 4878 + 5110 = 9988 | 4878 + 5110 | 95.8 s |

13-crossing breakdown: 34,659 shadows -> 4,878 (flype classes) | 1.47M diagrams built (18.5M skipped
by the bigon criterion) | 125,628 survivors -> 51,073 identified | enumerate 21.0 s, reduce 18.1 s,
generate 7.8 s, closure 20.2 s, identify 25.5 s. 31 composite/non-minimal markers were resolved.

## 8. What made level 12 go from ~94 s to 14.8 s (each step is a proof, not a heuristic)
1. C++ kernel on Regina's engine: generation+simplify 47 s -> ~10 s.
2. Bigon criterion (same strand over at both crossings of a 2-sided face => R2-reducible): skip those
   crossing assignments before building the diagram; 14.7M -> 0.97M diagrams built at n=12 (15x).
3. Flype-class reduction of shadows: one shadow per alternating knot (flyping theorem, Menasco-
   Thistlethwaite; flypes preserve any crossing assignment, Burton 3.2). 7,202 -> 1,288 shadows at n=12.
4. Global Reidemeister closure (union-find, Regina-checked moves): SnapPy-class identity on 4-17x fewer
   diagrams, 0 false reductions, 0 impure classes.
5. Native identity: extracted SnapPea kernel + Regina isoSig (byte-identical to SnapPy on 10,880
   hyperbolic knots), ~1.2 ms/diagram vs ~1.9 ms in Python.
6. C++ shadow enumeration (3.9 s for level 12 from scratch); canonical-form root pruning 7.9x in Python.
Two silent bugs found by measuring: a hash that made "4 shards" really 2, and exhaustive search at
height 3 (exponential, cannot succeed on prime knots) stalling the 13-crossing run.

## 9. Learned guidance (imitation learning), held-out
Value net (GNN on the PD graph) trained only on level-11 expert paths, tested on 120 unseen level-12
hard diagrams: success after 25 / 50 / 100 expansions = 48.3 / 69.2 / 80.8% vs 7.5 / 31.7 / 55.0%
(random) and 0 / 0 / 18.3% (BFS); all converge by ~400 expansions. Sample-efficiency win only: 1.39 ms per
expansion in Python vs 0.15 ms. RL fine-tuning and the Colab GPU run are prepared (ml/colab_job.py) but
not yet run (needs the user's Google login).

---
# Update 2: 14 crossings, and the published hard unknot diagrams

## 10. 14-crossing census (cold run, level-11 parameters)
19,536 alternating (exact) + 27,437 non-alternating found, vs published 19,536 + 27,436.
Cause of the +1, found and proven (knotml/verify.py): ONE knot carrying TWO canonical ids. The 3
non-hyperbolic ids are exactly the published 1 torus + 2 satellites; across all 59,925 hyperbolic ids of
levels <= 14 there are 5,455 equal-volume groups (7,979 pairs); SnapPy's isometry test finds exactly one
isometric pair, both at level 14. Merging it gives 46,972 = 19,536 + 27,436, an exact match. This is the
numerically-ambiguous canonical decomposition Burton describes (Sec. 4.2/6.3). Levels <= 13 had none.
Wall time: 814 s (13.6 min) on 4 cores, with other jobs running concurrently: 170,692 shadows -> 19,536;
10.3M diagrams built (149.8M skipped by the bigon criterion); 828,425 survivors -> 326,409 identified;
enumerate 125 s, reduce 106 s, generate 60 s, closure 185 s, identify 241 s.

## 11. Hard unknot diagrams (Burton et al., arXiv 2104.14076, Appendix A Gauss codes, validated)
21 published diagrams (9 to 141 crossings). Regina simplify() alone solves only 5 (Monster, Thistlethwaite,
Ochiai I, Tuzun-Sikora, Ochiai III); the other 16 are the benchmark. Staged random walk, every move
Regina-checked, crossings capped at (current + c), 5 seeds, stage budget 3M proposals:
cap n+4: 13 of 16 solved 5/5 - D28 (needs 3 extra crossings): 0.6 s; D43 (>=3 extra): 1.3 s; both
Freedman-He-Wang diagrams: 0.3-0.4 s; Ochiai II: 15 ms; Ochiai IV (Suzuki, >=2 extra): 1.5 s;
Haken (141 crossings): 0.23 s; H, J, Culprit, Goeritz: < 1 ms.
cap n+3: same except D43 3/5. Annealing (T 3->0.6) at cap n+3: D28 5/5 with 3x fewer proposals than the
walk (330k vs 1.0M) but D43 only 1/5; so annealing helps D28 and hurts D43.
Not solved at 3M budget: PZ78, PZ120, PZ138 (PZ138 reduces 138 -> 78 crossings).

## 12. RL fine-tuning (REINFORCE over child diagrams, imitation loss mixed in), CPU smoke test
ml/rl_finetune.py runs end to end (8 iterations x 8 episodes, <= 20 steps, level-11 training starts):
episode success 0.95 over the first 5 iterations -> 0.90 over the last 5. No improvement and no
degradation; the imitation policy already succeeds ~90-95% on its own training starts in 20 steps, so
this scale cannot show a gain. It de-risks the Colab run (code path verified), nothing more. A meaningful
RL test needs held-out hard starts (level 12/13) and a budget where the imitation policy fails.

---
# Update 3: exact census through 14 crossings, and why the +1 happened

## 13. Level 14 now exact with no post-hoc correction
Root cause of the +1, confirmed (knotml/verify.py plus a fixpoint test): the extracted SnapPea identifier
occasionally returns a NON-canonical retriangulation. For the duplicated knot, one id was a 20-tetrahedron
triangulation and the other the 28-tetrahedron canonical retriangulation (id B == isometry_signature(B);
id A != isometry_signature(A)); re-canonizing A gives B's signature, and is_isometric_to(A, B) is True.
Logic that matters: EQUAL canonical ids prove the same knot; UNEQUAL ids prove nothing.
Fix (knotml/build3.py canonicalize_new): re-canonize every not-yet-known hyperbolic id to an
isometry_signature fixpoint before counting it. Cost +8% at level 13, +6% at level 14.

| level | found (alt + non-alt) | published | wall (4 cores) |
|---|---|---|---|
| 13 | 4878 + 5110 | 4878 + 5110 | 102 s |
| 14 | 19536 + 27436 = 46972 | 19536 + 27436 | 788 s (13.1 min) |

Level 14: 170,692 shadows -> 19,536; 10.28M diagrams built (149.8M skipped by the bigon criterion);
828,425 survivors -> 326,409 identified; 2 ids re-canonized. Independent check afterwards: 59,924
hyperbolic ids over levels <= 14, 7,978 equal-volume pairs, 0 isometric pairs (0 duplicate ids). The 3
non-hyperbolic ids at 14 are the published 1 torus + 2 satellites.
Breakdown (s): enumerate 123, reduce 104, generate 60, closure 147, identify 181, recanonicalize 44, write 9.

## 14. Hard unknots: the PZ diagrams need a different move set (not tuning)
PZ78 / PZ120 / PZ138 stay unsolved by the Reidemeister-only walk: 0/3 at a 30M-proposal stage budget
(PZ120, cap n+4). Diagnosis from the literature (Petronio-Zanellati, arXiv 1508.03226; checked by a parallel
session, [READ] unless marked): their procedure uses generalized pass moves (Z3) plus short horizontal Z3
sequences; PZ138 untangles monotonically in 37 such moves, PZ120 needs one extra "move C". PZ78 has m >= 3
(Burton et al.) and no published upper bound; a Z-route converted to Reidemeister moves would give one.
A pass-move macro is the next step (code requested from the parallel session; unverified until tested here).
Note: the "PZ" in Burton et al.'s table is Petronio-Zanellati, and two appendix captions carry swapped
figure numbers; the crossing counts of the Gauss codes are the reliable identifiers.

---
# Update 4: generalized pass moves (Petronio-Zanellati Z3) solve what the Reidemeister walk could not

Source: kernel/pass.cpp, written by a parallel Claude session at my request (spec: standard library only,
strict PD checks, built-in planarity/Euler assertions on every move), received as text; md5 of my
transcription equals the sender's (ed57d53a42e53e0fb1ac2ee93e3a8b82). I verified it independently here with
Regina; the numbers below are mine, not the sender's.

## 15. Published hard unknots (Burton et al. appendix codes, loaded with Regina fromGauss)
Procedure P = R1/R2 removal, decreasing Z3 (largest k-l), BFS over horizontal Z3 to depth H.
- default (H=2, 4 paths): 19 of 21 solved to 0 crossings in 7.5 s total, including **PZ78** (which the
  capped Reidemeister walk never solved, 0/3 at 30M-proposal stages) and D28, D43, Haken (141 crossings).
- --H 3 --paths 8: 20 of 21, adding **PZ138** (20.9 s total).
- Unsolved: PZ120 (Petronio-Zanellati report their own monotone procedure fails on it; it needs "move C").
Caveat on what this proves: a Z-move route certifies the diagram is an unknot (isotopy), but it does not
bound m(PZ78), the Reidemeister-move measure. Converting each Z3 into R-moves (finger construction) would.

## 16. Correctness check that matters: nontrivial knots keep their HOMFLY
2,000 census survivors (1,000 each from levels 11 and 12), exact chirality-sensitive HOMFLY before vs after:
  default mode: 0 mismatches (1,110 reduced, 890 unchanged, 0 grew)
  --scramble 3 (random crossing-INCREASING reroutes): 0 mismatches (1,786 grew)
  --H 3 --paths 8 --seed 5: 0 mismatches
## 17. As a reducibility prover on census survivors (survivors that simplify() cannot reduce)
Against the exact census labels: of 1,122 truly reducible survivors, 1,110 reduced (98.9% recall), 12 missed,
0 minimal diagrams "reduced" (0 false reductions), 878 minimal left alone. 2.4 s for 2,000 diagrams
(1.2 ms each, unoptimised, single thread): a deterministic polynomial-time proof of reducibility, vs the
randomised search/closure used so far. Not yet wired into the pipeline.
