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
| D2 `-aot`, `-aotc` implemented | done; output identical at n = 24, 26, 28; n = 30 run in progress (see out/dmon/n30_*.log) |
| D1 `-gcleaf`, `-gc` implemented | code written (enum_dmon.cpp), NOT yet validated or benchmarked |
| `check/gc_check.cpp` | built; 0 violations in out/n24..n38 survivor lists; censuses (3_1@24, 4_1@30, 5_1@34, 5_2@36) NOT yet run |
| D3, D5, D4 | not started |
| report to parent after D2 | NOT yet sent |

## Next steps
1. Finish n = 30 for D2 (base, -aot, -aotc), write the D2 section of `DMON_RESULTS.md`, commit, push, report to parent.
2. D1: generate the four censuses with `python3 check/slab_census.py ... --all48 --out FILE`, run `gc_check` on them
   (any violation: STOP and report), then `-gcleaf` (survivors unchanged expected), then `-gc` (compare with -gcleaf output).
