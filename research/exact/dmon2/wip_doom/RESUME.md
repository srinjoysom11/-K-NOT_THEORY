# wip_doom: how much can a stronger bound still cut? (resume notes)

## What was measured

`doom.patch` instruments `../enum_u.cpp` (the fixed U2 search, commit 9da2d45). It adds three counters.
1. **Closure below a node.** For each node placed by `step_body` (outside the replayed prefix), it records whether the
   node's subtree reached `leaf()` (a closed polygon that passed all incremental tests) and whether it produced a
   candidate (passed `full_ok`, `cyc_ok`, tau). Printed as `doom R=...`.
2. **Plain self-avoidance.** At the same nodes with R - 1 <= 16 remaining steps, it runs an exact search for a
   self-avoiding walk of exactly R - 1 steps from Hd to Tl through free cells, ignoring all obligations (budget 2e5
   states). It counts nodes where no such walk exists.
3. **Exact obligation walk.** At each node where the GW3 walk bound is alive (R1 <= 24), it runs an exact search for a
   self-avoiding walk of exactly R1 steps from Hd to Tl that hits every obligation in the GW3 mask (`w_full`, using GW3's
   own site masks `gcM` and heuristic `w_hc`). Budget 3e5 states. Printed as `exact R1=...`.

## Results at n = 32 (all 5645 tasks, flags U2, 4 threads, about 6 s)

| R (remaining) | nodes | with a closure below | plain SAW impossible |
|---|---|---|---|
| 2-7 | 23k-60k each | 12-38% | 1.5-7.5% |
| 8-18 | 39k-155k each | 2.8-16% | 0.0% |
| 19 (task depth) | 457k | 0.8% | 0.0% |

Exact obligation walk at GW3-alive nodes: it fails at 0.0-0.4% of them (R1 = 8..18), with no budget hits.

Reading: about 95% of the search tree has no closed polygon below it, so the most an ideal bound could cut is about
20-25x. Self-avoidance alone explains almost none of it. The obligations known at the node, checked exactly, explain
at most 0.4% more than GW3 already does. The doomed nodes die from obligations and tests created by the steps of the
completion itself (the rejection histogram with `-rejstats` puts most kills in the `aot` and `tour_mst` columns, the
axis-count tests and the walk bound, at R1 <= 18).

## How to reproduce

```bash
cd research/exact/dmon2 && cp enum_u.cpp /tmp/enum_doom.cpp && patch /tmp/enum_doom.cpp wip_doom/doom.patch
g++ -O3 -march=native -std=c++17 -pthread -o /tmp/enum_doom /tmp/enum_doom.cpp
/tmp/enum_doom 32 -alt 4 -stair -tourcap 3 -aotc -aotm -threads 4 -face -plane4 -aotp -crank -adapt 1 -tourcap 0 -mstonly -ax1d -hk 5 -hkw -cycleaf -tau 1 -tauz 1 -tauax 1 -gwv 1 -walkc 2 -pre1 -w3ent 2 -w3nb 4 -w3inc 2 -walk 8 18 -rejstats -out /tmp/d32.txt 2> /tmp/d32.log
grep '^doom\|^exact' /tmp/d32.log
```

The output words are unchanged by the patch (the checks only count).

## Next steps (not started)

1. **Self-consistent bound.** Extend the GW3 walk so that the walk's own turns and axis use create the obligations
   the real search would create (corner and curtain obligations from its own steps, axis counts), and require the walk
   to meet them too. Measure first with the doom counters: what fraction of doomed GW3-alive nodes does it kill?
2. **Where the chains die.** For doomed nodes, record the depth at which the last descendant dies and the test that
   kills it, to find which created obligation dominates.
3. **Reorganise the search**: the multi-gap search (MULTIGAP.md, Version A) or a meet-in-the-middle over the last
   2k steps, since bounds on the current state are nearly exhausted.
