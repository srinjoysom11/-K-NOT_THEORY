# DMON experiments: resume notes (keep this file current; a session can end at any time)

Branch `claude/dmon-experiments`. Parent/controller session: `session_018pTY7SbYuVC3M42VdksNN6`
(send reports with send_message; ask it for more compute if all GitHub jobs are busy).
Task: `DMON_IDEAS.md` D1..D5, in the order D2, D1, D3, D5, D4. Rules: `enum.cpp` is never edited;
new code lives in `enum_dmon.cpp` behind flags (default off: identical output and node counts).

## How to resume
* Code: `g++ -O3 -march=native -std=c++17 -pthread -o enum_dmon enum_dmon.cpp`; reference `enum` is built from `enum.cpp`.
* Local paired run: `./run_dmon_bench.sh BIN TAG N "flags"` writes `out/dmon/nN_TAG.{txt,log}`.
* **Compute on GitHub** (works when the Claude container is gone): edit `ci/dmon_request.json`, push to
  `claude/dmon-experiments`; workflow `.github/workflows/dmon-bench.yml` runs `enum` and `enum_dmon` on the
  same part of the search, compares outputs, and commits logs to `out/dmon/ci/` (+ `SUMMARY.md`, made by
  `check/dmon_ci_summary.py`). Request format: see the header of the workflow file.
* If the runners are all busy (jobs queued for a long time): message the parent session and ask for one.

## Status (update after every step)
| step | state |
|---|---|
| D2 `-aot`, `-aotc` | DONE, benchmarked n = 24..30, identical output, table in DMON_RESULTS.md |
| D1 `-gcleaf`, `-gc` | DONE: lemma validated (0/128560), proof written, benchmarks n=26..30: nodes unchanged (0.9996-0.9999x), time +30-45 %, output identical |
| `check/gc_check.cpp` | done (censuses 0 violations) |
| D3 (-bfsdist, -gmst, -onetree) | DONE: identical output, <= 3 % nodes (5 % with 1-tree), +60-100 % time: no gain. D2 follow-ups -aotm/-aote/-aott done (best: -aotc -aotm -aote 0.26x nodes, 0.18x time at n=28). DMON-only mode done. Tables in DMON_RESULTS.md |
| D5 arcknot 19 | arcknot.cpp now has -part R M (parts verified to sum to the whole at L=14,15; no -part = identical). `./run_arc19.sh 64 4` (restartable, parts in out/dmon/arc19/part{R}_64.{left,log}) started 19 Nov ~04:00; when all 64 parts have `seconds=` in the log: glue (check/arc19_glue.py, to be written) |
| D4, extras E1..E8 | not started |
| report to parent after D2 | sent (interim, then final) |
| GitHub dmon-bench smoke run 44417093364 | queued for >8 h (runner pool saturated by old slab-enum runs); parent asked for a runner; keep working locally |

## Next steps
1. D1: generate the four censuses with `python3 check/slab_census.py ... --all48 --out FILE`, run `gc_check` on them
   (any violation: STOP and report), then `-gcleaf` (survivors unchanged expected), then `-gc` (compare with -gcleaf output).

## Instructions received from the parent session (19 Nov, keep following them)
Order: D2 (done) -> D1 -> D3 -> D5 -> D4, then extras E1..E8 in this order. Report to the parent after EACH item
(`send_message` to session_018pTY7SbYuVC3M42VdksNN6): lemma or pure bound? nodes/seconds ratios at n = 24, 26, 28 (30 sampled with -part).
* Names (CLAUDE.md / paper): DMON1..DMON7 = closed walk, self-avoiding, lowest start, direction of travel, sorted axes, curtains, corners; PanDMONium = completeness theorem.
  Bounds (return distance, span, tour/MST, two free neighbours, flip reduction) are SEARCH TESTS, not DMONs. D1 = new DMON ("DMON6+ / GC"); D2, D3, E1, E2 = search tests; D4 = target-restricted condition; D5 = completeness device.
* Runners: do not cancel slab-enum runs 44258289972 / 44258325382. Benchmark on the container (n <= 30, -part for 30/32); the dmon-bench workflow starts when the queue drains (use it later for n = 32/34).
* D2 follow-ups: -aotc is valid exactly when -prime/-stair is on (state this); try (a) per-axis travel of MULTI-site obligations (min over sites), (b) -aot inside tour_ok with the witness tour's per-axis lower bound, (c) aot check before update() from counts alone. Also report -aot/-aotc in DMON-only mode (no -prime) at n = 24, 26 (cost reference there: n=24 1.81e8, 26 1.08e9 nodes; `enum -tourcap 0 -nomst -noreduce` reproduces them for unsplit n <= 26).
* After every change compare NODE COUNTS too (flag off == enum exactly). For D1 log per-rejection-site counters (which test kills how many prefixes).
* D1 (new DMON) needs in DMON_RESULTS.md: (a) the minimality argument in full (the move, why it keeps the knot type, why it shortens); (b) the completeness argument PanDMONium-style (obligation created at a prefix is satisfied by every completion that passes GC; obligation invariant of paper sec. 4.4 still holds). No sketches (CLAUDE.md). Do NOT touch lean/.
* Extras: E1 parity budget; E2 group MST (= D3b); E3 more height functions (diagonals) in -bridge-style test; E4 mirror halving (statistic S = A_xy * A_yz >= 0; check on censuses first); E5 GC variants (a) cyclic through root, (b) shifted path may reuse sub-path points (already), (c) GC obligations go through the same feasibility pipeline; E6 leaf reduction with +-2 BFACF moves; E7 bitboards / child ordering; E8 low priority.

## Results so far (19 Nov)
* D1 lemma validated: 0 violations in 3328 (3_1@24), 3648 (4_1@30), 6672 (5_1@34), 114912 (5_2@36) = 128560 polygons (out/dmon/gc_census_check.txt); also 0 in all stored survivor lists n=24..38; program leaf test == check/gc_check on all closed polygons n=8..14 (all violate, as they are unknots).
* D1 prefix (-gc): output identical; nodes ~ unchanged (n=24 15 884 608 vs 15 886 694), time worse (5.8 s vs 3.6 s). -gcleaf kills 0 leaves. Benchmarks n=26,28,30 running: see out/dmon/ and scratchpad d1_chain.out.
* D3 code (-bfsdist S, -gmst) written, NOT tested.

## New priorities from the parent (19 Nov, 02:14 UTC), after D1 was accepted (keep -gc off)
1. D3 (-bfsdist S, -gmst) and the D2 follow-ups as planned (-aotm multi-site per-axis, aot inside tour_ok, -aote early check, DMON-only mode n = 24, 26).
2. NEW: since the capped exact tour gives up at -tourcap 3, try a cheap admissible bound between MST and the exact tour: 1-tree / Held-Karp-style bound
   (MST on all nodes except one + the two cheapest edges at it; with the path head -> ... -> origin closed by a zero edge head-origin). NOT "MST + matching on odd nodes" (not a lower bound). Also an incremental MST (reuse parent's tree) to cut per-node cost. Report kills and time.
3. NEW: histogram of rejections by remaining steps R (per test), to see whether kills are deep or shallow (bounds acting earlier save the most).
Then D5, D4, E1..E8. Report after each item.
Counters seen so far (n = 24 enum): tour/MST 6.35M kills, reach/2-free-neighbour 2.38M, corner-no-site 79.6k, of 15.9M nodes.

## Reprioritisation from the parent (19 Nov, 02:34 UTC): do E9, E10, E11 BEFORE D5/D4 (D5 job already running in background: ./run_arc19.sh, restartable)
Accepted: best production set -aotc -aotm -aote; D3/1-tree recorded as no gain. Key result = the histogram (nothing dies at R1 >= 17): only tests that act early change the growth rate.
* E9 Bidirectional construction (search order, not a lemma): grow head (forward from v_0) and tail (backward from v_0 = v_n) alternately; R = n - (head + tail steps); return test dist(head, tail) <= R; DMON4 and wrap curtains/corners tested as soon as tail steps exist. Fixed interleaving (head, tail, head, tail, ... until a split depth, then head only). Check: output byte-identical (sorted) to enum for n = 24..28; report nodes and rejection histogram by R.
* E10 early budget tests at R1 >= 14 in the style of -aot: (a) per-axis count of obligation sites beyond a plane (extended-extent crossing debt); (b) DMON5+DMON3 height: z >= 0 so owes h down-steps -> forces y, x steps (CHECK whether already in -aot: it IS: t_z >= |z_head| and c_z + t_z is ordered with y, x; and c + |h| >= 2*range on every axis automatically).
* E11 child ordering by increasing slack (R-1-dist); node counts unchanged in a full enumeration, report time only.
Then D5, D4, E1-E8. Report after each.

## Status 19 Nov ~09:00 UTC
* NOTE: background jobs die when the container restarts. D5 arc job: `./run_arc19.sh 64 2` (restartable; 4 of 64 parts were done when it was killed; part 0: 382 s, 2 783 960 candidate closures, 17 unresolved = knotted, all 24-edge closures). Restart it after any restart; it skips parts whose log has `seconds=`.
* E10(a) -aotx: VACUOUS (0 evaluations at n=24): every single-site obligation lies inside the bounding box of the walk (corner site = coordinates copied from 3 vertices; curtain site has the level of v_0). E10(b): already in -aot.
* E11 -order: node counts identical (as expected); time not yet measured on an idle machine.
* E9 bidirectional: enum_bidir.cpp written (DMON-only mode). alt=0 reproduces enum node counts (86 639 687 vs 86 639 605 at n=24); output identical for n=20,22,24 with alt = 0, 6, 12, 100; nodes n=24: 86.6M -> 13.7M (0.158x at alt=12). n=26/28 validation running (scratchpad bd_chain.sh -> out/dmon/bidir/). Next: add -prime/-stair (plane counters are order independent; stair runs need one state per side), then report to parent.

## Parent's checklist for E9 (19 Nov 09:05 UTC)
Report (a) TIME not only nodes (both ends make each test costlier); (b) the factor with -aot -aotm stacked (expected ~0.16 x 0.3 = 20x ~ 1.7 lengths); (c) rejection histogram by R1 (does pruning start earlier?);
(d) in -stair mode: node counts with -alt 0 equal enum -stair EXACTLY, then outputs equal for alt > 0 (plane/stair counters correct when the tail adds crossings in reverse order).
Write-up note: DMON_RESULTS.md must restate the PanDMONium completeness argument for two-ended prefixes (every test on a two-ended prefix is implied by DMON1-7 for every completion) with a short list of which tests are applied at the tail side and why each is sound.

## Status 19 Nov ~10:00 UTC: E9 DONE (needs report acceptance)
enum_bidir.cpp (separate program; -prime/-stair/-aot/-aotc/-aotm/-alt K, default alt 12, recommend -alt 4). Identical output n=20..32; -alt 0 == enum node counts exactly; production -stair -tourcap 3 -aotc -aotm: n=28 0.052x nodes (5.6 s vs 115 s), n=30 0.061x (39 s vs 635 s), n=32 0.053x (6.2e8 vs 1.18e10 nodes, 214 s, output == out/n32_stair.txt). Tables and soundness list in DMON_RESULTS.md.
D5 arc job resumed (./run_arc19.sh 64 2 is restartable) - check `ls out/dmon/arc19/*.log | wc -l` (64 needed).

## Parent's REVISED priorities (message queued 19 Nov 09:43 UTC, read 20:39 after a ~11 h container pause; replaces the order of the previous one)
1. CI confirmation of enum_bidir at n=34 and n=36: NEW workflow file on MY branch (.github/workflows/bidir-enum.yml, push-triggered by a request file), same -part/-split scheme; do not edit exact-enum.yml or lean-*.yml. Compare with out/n34_prime.txt / out/n36_prime.txt (mode of those: `-prime -tourcap 3`) or run -stair; say which. Report summed nodes and runner-seconds against the n34/n36 logs.
2. Add `-slab L` to enum_bidir.cpp with exactly the semantics of slab.cpp (diff vs enum.cpp: MAXN 56 / N <= 52; ALLOWED adds |x|,|y| <= 27 and z <= L; axis rule only y-steps <= x-steps (leaf: (SLAB>=0 || cz<=cy) && cy<=cx; prefix: 2*cy+cz <= N and cy <= cx+(R-1)). Validate byte-for-byte against out/slab/L1_n40.txt, L1_n42.txt (1-slab), L2_n36/38 (2-slab) with the opts of their .log files (-slab L -stair -tourcap 3). Report node ratio and time. (Remaining slab runs, ~600 runner-hours with slab.cpp, are NOT to be resubmitted; they should run with enum_bidir -slab.)
3. Production run of unconfined n=40 with enum_bidir -stair -tourcap 3 -aotc -aotm -alt 4 on Actions (new workflow; each job < ~4 h). TELL THE PARENT the planned part count and estimated runner-hours BEFORE launching. Target: complete n=40 with no 8_19 gives Len(8_19) = 42.
4. D5 (19-edge arcs, composites at n=40), then D4 (done: leaf only), E1-E8.
* LESSON (CI smoke run 44417093364, ran 11 h late once the pool drained): with `-part r m` the per-part word lists of enum and of a pruned variant differ, because the pruning changes the task list the parts are cut from; only the UNION over all parts is comparable (smoke: 62 = 62 survivors, nodes ratio 0.293 as locally). dmon-bench.yml no longer fails a job on per-part differences.

## 20 Nov status: bidir CI + slab
* enum_bidir -slab L validated byte-for-byte vs slab.cpp outputs: L1 n=30 (12 words), L1 n=34 (12), L2 n=30 (34), L2 n=34 (728 words). Nodes/time vs slab.cpp: L1 n=30 3.55M vs 25.1M (0.14x), 1.6 s vs 6 s; L1 n=34 39.3M vs 316.6M (0.124x), 18 s vs 91 s; L2 n=30 56.5M vs 467.6M (0.121x), 20.5 s vs 209 s; L2 n=34 1.025e9 vs 8.998e9 (0.114x), 442 s vs 2859 s. (opts -slab L -stair -tourcap 3 [-alt 4 -aotc -aotm]). L1_n40 / L1_n42 not yet re-run.
* CI request pushed: ci/bidir_request.json = n=34 m=16 and n=36 m=64, opts `-prime -tourcap 3 -alt 4 -aotc -aotm` (same mode as out/n34_prime.txt / out/n36_prime.txt: `-prime -tourcap 3`). Workflow .github/workflows/bidir-enum.yml merges to out/bidir/n34_prime_bd.txt etc. Reference costs: n=34 7.736e10 nodes, 45 419 runner-s; n=36 4.332e11 nodes, 282 379 runner-s.
* arc19: 12 of 64 parts done; job dies on container pause; restart with `./run_arc19.sh 64 2`.

## 20 Nov, later: parent's decisions (message 20:49 UTC)
* n=40 unconfined APPROVED: m=128, opts `-stair -tourcap 3 -aotc -aotm -alt 4`; launch as soon as the n=34/36 unions equal out/n34_prime.txt / out/n36_prime.txt; logs carry seconds and enum_bidir.cpp sha (workflow does). After merge: run identify_rigorous.py on the union and send the tally. (Parent: explicit 42-edge 8_19 polygon now in out/witness42_8_19.txt on its branch.)
* Re-run L1_n42 locally with enum_bidir -slab 1 (713 words; complete for all knot types): started (out/dmon/slab/L1_n42.{txt,log}); slab.cpp: 5.96e10 nodes, 22176 s.
* After n=40 is launched: slab runs with enum_bidir -slab in MY workflow: 1-slab n=48 and 2-slab n=42 (estimate ~85 runner-hours each, m=128 each). Then D5 (arcknot 19) on Actions: workflow arc19-enum.yml + ci/arc19_request.json (parts 12..63) pushed 20 Nov.
* Drop E3; record E1 and the D4 leaf result as negative/minor (done in DMON_RESULTS.md).

## 20 Nov: CI confirmation done, n=40 launched
* bidir-enum run 44612420289: n=34 (16 parts, `-prime -tourcap 3 -alt 4 -aotc -aotm`): 1398 survivors, byte-identical to out/n34_prime.txt; 3.472e9 nodes (0.0449 of enum's 7.736e10), 1874 runner-s (0.0413 of 45 419). n=36 (64 parts): 6662 survivors, byte-identical to out/n36_prime.txt; 2.455e10 nodes (0.0567 of 4.332e11), 13 647 runner-s (0.0483 of 282 379). Files: out/bidir/n34_prime_bd.txt, n36_prime_bd.txt, ci_summaries.
* arc19: all 64 parts on disk (CI run 44612872108 for parts 12..63; parts 0..11 local). Next: python3 check/arc19_glue.py --sample 300 --out out/dmon/arc19/glued40.txt; python3 check/arc19_witness.py out/dmon/arc19/glued40.txt.
* n=40 unconfined run launched by pushing ci/bidir_request.json = {n:40, m:128, opts "-stair -tourcap 3 -aotc -aotm -alt 4", tag stair_bd}; results will be committed by the workflow to out/bidir/n40_stair_bd.txt (+ ci_summary with nodes and runner_seconds). When merged: python3 identify_rigorous.py out/bidir/n40_stair_bd.txt and send the tally to the parent. NOTE: the request file is replaced; the n=34/36 results stay in out/bidir/.
* THEN: slab runs with enum_bidir -slab: 1-slab n=48 and 2-slab n=42 (m=128 each), in the same workflow (use a separate push, request file with those opts: "-slab 1 -stair -tourcap 3 -alt 4 -aotc -aotm" and "-slab 2 ...").

## 20 Nov (21:20): parent's next messages
* D5 write-up: DONE in DMON_RESULTS.md (Proposition D5, five steps; "knotted" = ball-arc pair in the half-space knotted; unknotted side => staircase by Lemma 3 => contradiction).
* After n=40 lands (send identify_rigorous tally FIRST): (1) slab runs 1-slab n=48 and 2-slab n=42 once L1_n42 re-run matches; (2) prepare n=42 unconfined: needs knotted 20- and 21-edge arcs (arcknot now accepts L <= 22, grid enlarged, identical for L=14,15) on Actions (64-256 parts each) and gluings 19+21, 20+20 (splits a+b+2=42, a,b>=19: (19,21),(20,20),(21,19)); estimate runner-hours and TELL THE PARENT BEFORE LAUNCHING; (3) census check: bulk granny (5096+5096) and square (45 536) counts at n=40 from the glued set plus the composites of the n=40 -stair output (flip closure, 48 symmetries, check/slab_census.py --all48); compare with JvRR11 P_K tables if in wiki/lattice-length/.
* enum_bidir.cpp now accepts unconfined N <= 48 (was 40) for n=42.

## 20 Nov 21:25: parent approved the n=42 chain (message 21:21 UTC)
Order on Actions: (1) n=40 (running); (2) arcs L=20 (m=128) and L=21 (m=256): SUBMITTED via ci/arc19_request.json ("runs" list; workflow arc19-enum.yml writes out/dmon/arc20/part{r}_128.{left,log}, out/dmon/arc21/part{r}_256.*; 4 parts per job; 32 + 64 jobs); (3) n=42 unconfined m=256 `-stair -tourcap 3 -aotc -aotm -alt 4`: LAUNCH WITHOUT ASKING once the n=40 result checks out (merged; identify_rigorous ALL RESOLVED, or unresolved words identified with SnapPy; and measured n=40 runner-hours x 5.4 <= 700), otherwise ask the parent first; (4) slab runs (1-slab n=48, 2-slab n=42) after n=42 is submitted, once the L1_n42 re-run matched. Also: put the n=42 completeness argument in DMON_RESULTS.md now.

## !!! HOLD from the user (20 Nov, after the status update) !!!
The user said: "Let's wait on manual decision after n=40 is done." This OVERRIDES the parent's standing instruction to launch n=42 automatically.
After n=40 is merged: run identify_rigorous.py, send the tally to the parent AND report to the user, then STOP. Do NOT launch n=42, the 1-slab n=48 / 2-slab n=42 runs, or anything that needs more runners, and do not add or attach another repository for runners, until the user decides.
Already submitted and left as they are (small, queued behind n=40): arc runs L=20 (m=128) and L=21 (m=256), ci/arc19_request.json, run 44618021834.

## 20 Nov 11:30 UTC: n=40 DONE (user hold still in force)
n=40 `-stair` merged: 59 084 survivors, 5.437e11 nodes, 360 113 runner-s (100 h). identify6.py --chir: ALL RESOLVED. Tally in out/bidir/n40_stair_bd.tally.txt (0_1 8271; 3_1 5084; 4_1 7568; 5_1 11746; 5_2 25765; 6_1 64; 6_2 346; 6_3 136; 3_1#-3_1 104; no 7-crossing knot, no 8_19, no granny in the -stair output). With D5: Len=40 types = 6_1, 6_2, 6_3, 3_1#3_1, 3_1#-3_1; all other knots (incl. every c>=7 knot and 8_19) have Len >= 42.
Arcs L=20 (128 parts, out/dmon/arc20/) and L=21 (256 parts, out/dmon/arc21/) are on disk, NOT yet processed (gluing 19+21 and 20+20 for n=42).
STILL ON HOLD by the user: n=42 (est. 540 runner-hours, m=256), slab runs, more runners. Local L1_n42 slab re-run: see out/dmon/slab/L1_n42.log (was still running).


## FINAL NOTE (20 Nov): direction paused by the user to focus on the first paper (len52). Work stopped; nothing is running.
DONE (all pushed to claude/dmon-experiments; details and proofs in DMON_RESULTS.md):
* D2 axis-ordered travel (-aot/-aotc/-aotm/-aote): pure bound, ~0.26x nodes, 5.7x faster at n=28. D1 generalized curtain: lemma proved and validated (0 violations in 128 560 shortest polygons) but prunes nothing. D3, E1, E3, D4: negative or minor.
* E9 two-ended search (enum_bidir.cpp, -alt 4): identical output, ~0.05x nodes / 16-20x faster with D2; confirmed in CI at n=34, 36 (byte-identical to the stored -prime lists); -slab L validated vs slab.cpp (L1 n=30,34; L2 n=30,34).
* n=40 unconfined (CI): 59 084 survivors, identify6 ALL RESOLVED; with D5, Len=40 exactly for 6_1, 6_2, 6_3, 3_1#3_1, 3_1#-3_1; every other knot beyond 5_2 has Len >= 42; 100 runner-hours.
* D5: 960 knotted 19-edge arcs, 6918 (L=20) and 55 036 (L=21), all trefoil closures; gluings give only 3_1#3_1 / 3_1#-3_1 at n=40 (55 728 polygons) and at n=42 (splits 19+21, 20+20, 21+19: about 13.4 million ordered pairs).
OPEN (nothing started):
* n=42 -stair search (est. ~540 runner-hours, m=256, command: ci/bidir_request.json with n=42, "-stair -tourcap 3 -aotc -aotm -alt 4"); needed for Len of the 7- and 8-crossing knots at 44.
* Slab runs with enum_bidir -slab: 1-slab n=48 and 2-slab n=42 (about 85 runner-hours each; the 6_3 slab values); the local L1_n42 re-run (expected 713 words) was NOT finished and has NOT been compared (out/dmon/slab/L1_n42.log empty).
* Census check of the granny/square counts at n=40; parent's PROOF.md section 8 (Len(8_19)=42) is on its own branch.
No Actions runs are queued or running from this branch (last runs: 44616339687 n=40, 44618021834 arcs, both completed).

## 21 Nov: the USER lifted the hold ("Start the jobs for n=42 and queue the lean verification for it and the new dmons as well")
n=42 unconfined launched: ci/bidir_request.json = {n:42, m:256, "-stair -tourcap 3 -aotc -aotm -alt 4", tag stair_bd}; estimate ~540 runner-hours (parts ~2.1 h). Workflow bidir-enum.yml commits out/bidir/n42_stair_bd.txt + summary when all 256 parts are in. Then: identify6.py --chir on the union (use 4 chunks), tally, Len(7_x / 8_x) consequences.

## 22 Nov: Lean verification of the new devices (user: "Then only Lean verify that the new DMONs are correct.")
The user narrowed the Lean request to the correctness of the new devices (not n = 42). Done in the new package `lean_dmon/` (frozen `lean/` untouched; only `Len52.Spec` imported):
`Dmon.aot_sound` (D2, one- and two-ended, -aotm, -aotc with cdef as hypothesis) and `Dmon.gc_polygon` / `Dmon.gc_shortest` (D1; topological step `GCStep` as hypothesis).
Local build OK, standard axioms only, differential test vs the C++ formula identical on 1600 random cases. CI: `.github/workflows/dmon-lean.yml` on this branch (new file; the parent's lean-*.yml are unchanged).
Details, hypotheses and what is not covered: DMON_RESULTS.md last section, `lean_dmon/README.md`.
The n=42 run (run 44961220166, push 166a063) was still queued at the time of writing.

* 25 Nov: why the n=42 run (44961220166, 256 parts) was incomplete. It was not a timeout. The jobs for parts 167, 185, 188 and 192-255 (67 jobs) were never given a runner: each shows created = started = 2026-11-21 23:19:4x and completed 2026-11-22 23:19:42 with conclusion cancelled and no steps, i.e. GitHub cancelled them after they had waited 24 hours in the queue (about 20 jobs run at a time on this account, 189 parts fitted into the 24 hours). The 189 finished parts are intact (source hash `enum_bidir.cpp=eaaf37d9a337a12b`, same as now). Rule for later requests: keep a request to what can start within 24 hours (about 20 concurrent jobs x 24 h / part duration), or send it in several requests. The 67 missing parts are re-requested with the same options and source (m = 256, the collect job merges them with the committed parts and writes the n=42 file when all 256 are present); job timeout raised from 350 to 355 minutes because the longest finished part took 340 minutes.
