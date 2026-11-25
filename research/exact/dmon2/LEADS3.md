# DMON3 leads: running list (25 Nov 2026)

Target: make n = 42 cheap and n = 44, 46 tractable (n = 42 production: about 680 runner-hours with
`enum_bidir -stair -tourcap 3 -aotc -aotm -alt 4`, 3.4e12 nodes, 2.5 us per node per thread on Actions).
Status codes: [M] measured, [R] running (agent or Actions), [I] idea only, [X] measured and dropped.

| # | Lead | Kind | Status | Result so far |
|---|---|---|---|---|
| 1 | Fail-first end choice, cheap counts (`-adapt 1`) | search order, exact | [M] | 0.60x nodes, 0.57x time at n = 28, identical output |
| 2 | Fail-first with full probes of both ends (`-adapt 3`) | search order + 1-step lookahead, exact | [M][R] | 0.17x nodes at n = 28 (5.9x fewer), identical output; time not yet reduced (probes cost) |
| 3 | DMON2 stack: per-plane debt (P1), face (F1), plane (F2), crank (C1) | bounds / new DMONs | [M][R] | 0.53x nodes n = 28, 0.58x n = 30; Actions run at n = 32, 34 |
| 4 | Diagonal mid-plane debt (DMON2 8.1) | new lemma, prime types | [R] | agent |
| 5 | Transposition table of dead subtrees | memoisation, exact | [X] | a sound key (ends, letter window, curtain-site bits, all vertices within R+4, obligations, plane state) never repeats: 0 hits at n = 24, 26, 1 hit in 5.1 M band nodes at n = 28; the `-memo` skip is exact but 1.7-2x slower |
| 6 | Tour test: cap, exact small DP, per-axis bounds, joint tour + plane-debt + sorted-count bound | bound / engineering | [R] | agent. Profile n = 26: tour + tour_ok 53% of time, update2 18%, plane_route_need 13%, aot_ok 11% |
| 7 | Centroid balance B1 | leaf filter | [M] | survivors 4.3x fewer (8.1x with psi_X); no node gain |
| 8 | Slab split: 2-slab n = 42 run + unconfined restricted to extent >= 3 on all axes | target restriction | [M] | only 27% of n = 38 survivors have min extent <= 2: about 1.3x, minor |
| 9 | Multi-gap search: pin single-site obligations (and/or the highest vertex) as anchors; fail-first over all 2k ends | search order, exact | [I] | generalises E9 (4.3x) and lead 2 (5.9x nodes); large implementation |
| 10 | Unit propagation: take forced moves (an end with exactly one legal letter) before branching | search order | [R] | part of agent for lead 2 |
| 11 | Per-node engineering (bitboards, incremental aot / plane_route_need, cheaper tour) | engineering, exact | [I] | 2.5 us/node is slow; candidates from the profile above |
| 12 | Stiffness bound | bound | [X] | unsound ceiling 2.2x only (DMON2 section 7) |
| 14 | Count-class split (exact per-axis budgets c_x, c_y, c_z per run) | target split | [X] | 1.45x more nodes at n = 24, 26, 28 (work repeated across classes) |
| 15 | Push axes of the psi normal form (all 6 ordered pairs) | normal form | [X] | the current pair (z, y) is the best; others 1.04-1.18x more nodes |
| 16 | Body-diagonal plane debt: planes x +- y +- z = c + 1/2, every step crosses one; a twice-crossed plane has a geodesic side (prime targets) | new lemma, debt | [R] | agent; slack-0 one-peak test included (profile: slack 0 is rare above R = 6, so the debt part matters) |
| 17 | Test scheduling: reorder / skip pure bounds per (R, slack) bucket | engineering, exact | [R] | agent |
| 18 | Autopsy of dead subtrees at R = 8..16: which exact relaxation (obstacle-aware distance, obstacle-aware tour, pockets) proves them dead | diagnostic | [R] | agent. A perfect oracle at R = 15 would cut nodes about 25x at n = 28 |
| 13 | Stick-number / crossing-number target bounds | target restriction | [X] | sticks: no pruning; crossings: no usable prefix upper bound (D4) |
