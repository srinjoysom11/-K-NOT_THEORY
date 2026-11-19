# DMON experiments: results (branch claude/dmon-experiments)

Machine: 4-core container, `g++ -O3 -march=native -std=c++17 -pthread`, one run at a time, 4 threads.
`enum` = `enum.cpp` unchanged (sha256 276a574d...). `enum_dmon` = `enum_dmon.cpp`; with no new flag it gives
byte-identical output and identical node counts to `enum` (checked at n = 24, 26 and by the CI job).
Logs: `out/dmon/`. Resume notes: `DMON_STATE.md`.

## D2. Axis-ordered travel (pure bound)

Flags: `-aot` is D2 as written in DMON_IDEAS.md. `-aotc` is `-aot` where, per axis A, the lower bound t_A on the
remaining steps along A is the larger of (a) the travel bound of `span_need` and (b) `cdef[A]`, the plane
crossings still owed on A under `-prime`/`-stair` (each owed crossing is one future step along A, so (b) is also
a lower bound on t_A; it is the same quantity the old test only used summed over the three axes).
Test (in `update`, only with the axis rule on): L_A = even(c_A + t_A); z' = L_z, y' = max(L_y, z'), x' = max(L_x, y');
prune if x' + y' + z' > N. (c_A + t_A is already even, because t_A has the parity of the head coordinate.)

`-stair -tourcap 3`, whole search (no -part):

| n | variant | nodes | ratio | seconds | ratio | survivors | output vs enum |
|---|---|---|---|---|---|---|---|
| 24 | enum | 15 886 694 | 1 | 3.6 | 1 | 50 | - |
| 24 | -aot | 8 844 973 | 0.557 | 1.6 | 0.44 | 50 | identical |
| 24 | -aotc | 5 559 450 | 0.350 | 1.0 | 0.28 | 50 | identical |
| 26 | enum | 76 302 828 | 1 | 18.9 | 1 | 62 | - |
| 26 | -aot | 38 158 720 | 0.500 | 8.0 | 0.42 | 62 | identical |
| 26 | -aotc | 22 315 231 | 0.292 | 4.2 | 0.22 | 62 | identical |
| 28 | enum | 408 794 261 | 1 | 115.4 | 1 | 98 | - |
| 28 | -aot | 189 095 418 | 0.463 | 45.0 | 0.39 | 98 | identical |
| 28 | -aotc | 117 097 571 | 0.286 | 25.0 | 0.22 | 98 | identical |
| 30 | enum | 2 162 299 744 | 1 | 635.5 | 1 | 190 | - |
| 30 | -aot | 1 138 211 175 | 0.526 | 279.7 | 0.44 | 190 | identical |
| 30 | -aotc | 644 549 582 | 0.298 | 140.9 | 0.22 | 190 | identical |

`-prime -tourcap 3` (no `-stair`): n = 24: 20 913 121 -> 11 201 719 (0.536) / 7 337 328 (0.351) nodes, 4.0 s -> 1.8 s / 1.2 s;
n = 26: 94 932 798 -> 45 965 725 (0.484) / 27 732 743 (0.292), 21.0 s -> 8.3 s / 4.5 s. Output identical (cmp), 50 and 62 survivors.
Default options without `-prime` at n = 20, 22: identical (empty) output, nodes 0.41 / 0.38 (the survivors lists are empty there,
so this is only a weak identity check).

Reading: `-aot` alone halves the nodes; the per-axis crossing debt in `-aotc` gives a further factor 1.7, in total about
3.4x fewer nodes and 4.5x less time at n = 28 and 30. Growth per two edges of `-aotc`: 22.3e6 -> 117e6 -> 645e6 = 5.2x, 5.5x
(baseline 5.4x, 5.3x), so the saving is a constant factor of about 3.4 (0.8 of a length step, since a length step costs 4.2x to 5.4x here),
not a change of growth rate.
