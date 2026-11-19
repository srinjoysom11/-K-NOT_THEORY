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
