# Plan: the n = 42 search in Lean (PanDMONium for the new DMONs)

Goal: a Lean theorem whose only computation is a Lean program run on GitHub Actions (as `checkPart` in the
5_2 proof), saying that no polygon of a target knot type has at most 42 edges unless it is in the output, and
then, with the quandle invariants of Phase 4, which knot types have length at most 42. The frozen 5_2 proof
(`research/exact/lean/`, about 4600 lines, one-ended search with DMON1-DMON7, run to n = 34) is the model;
it is not changed. New code goes in this project (`lean42/`, Lean v4.25.2 with Mathlib).

## 1. Which tests the Lean search needs (ablation, 28 Nov 2026)

Every test needs a soundness proof, so a test goes into Lean only if it pays for its proof. Ablation of the
exact search U2 (`dmon2/enum_u.cpp`) at n = 32, 4 threads, one test group removed at a time. Every variant
outputs a superset of U2's 248 words (the normal-form tests remove words, the bounds do not).

| variant | nodes | time (s) | words | verdict |
|---|---|---|---|---|
| U2 (all) | 6.90e6 | 6.4 | 248 | reference |
| no GW3 walk bound | 1.65e8 | 44.0 | 248 | **keep**: 24x nodes |
| GW3 without per-axis counts (`-walkc`) | 9.04e6 | 34.6 | 248 | **keep `-walkc`** |
| GW3 + `-walkc` only (no `-gwv -pre1 -w3ent -w3nb -w3inc`) | 6.91e6 | 22.7 | 248 | the rest is speed only (3.5x time, same nodes): later |
| no `-aotc -aotm` (axis-ordered travel, plane debt) | 2.08e7 | 25.3 | 248 | **keep**: 3x nodes |
| no `-stair` | 1.72e7 | 16.1 | 248 | **keep a replacement**: 2.5x nodes (section 3) |
| no tau | 9.16e6 | 9.8 | 422 | **keep**: 1.5x time |
| no `-face -plane4` | 8.22e6 | 8.9 | 287 | **keep**: 1.4x time |
| no `-adapt 1` | 7.82e6 | 9.4 | 248 | **keep**: 1.5x time, order only (cheap to prove) |
| no `-aotp` | 7.58e6 | 7.4 | 248 | keep if cheap (1.15x) |
| no `-crank` | 7.11e6 | 7.1 | 269 | **drop** (1.03x; needs the psi normal form) |
| no tour / MST / Held-Karp (`-tourcap 0 -nomst`) | 6.92e6 | 6.9 | 248 | **drop** (1.07x) |
| no `-hk -hkw` | 6.91e6 | 6.5 | 248 | drop |
| no `-ax1d` | 6.90e6 | 6.7 | 248 | drop |

So the Lean search L42 is: the two-ended search (E9) with fail-first end choice (`-adapt 1`), the 5_2 tests
(DMON1-DMON7: self-avoidance, canonical position, no U-turn, axis counts, curtain and corner obligations,
reach and two free neighbours), the axis-ordered travel test with plane debt (`-aot -aotc -aotm`, `-aotp`),
the GW3 walk bound with per-axis counts, tau, the face rules (`-face -plane4`, `-cycleaf` at the leaf), and
a primeness-free replacement of `-stair`. Dropped: crank, the tour, MST and Held-Karp tests, `-ax1d`, and
the speed-only parts of GW3 (they can be added later with their own small proofs).

Cost estimate at n = 42: U2 took 6.88 runner-hours (1.34e10 nodes). L42: x1.03 (no crank), x1.2-1.3 (no
primeness, section 3), x3.5 (no GW3 engineering), x3-10 (Lean against C++; the 5_2 Lean program matched
enum.cpp node for node and ran at a few times its cost). About 100-300 runner-hours for n = 42, plus about
25% for n <= 40: affordable on Actions in waves of 128 jobs. To be measured in stage A.

## 2. The theorem

As in `Len52.Main.no_short`, with T the knot type (`KnotType` of `Lean42/Knot.lean`, a theorem of
`KnotClass`, not a hypothesis) and the target's invariant:

  for every target K with a quandle Q (Phase 4): if every polygon of type K has a diagram whose Q-colouring
  count is c_Q(K), and no output word of length n <= 42 has that count, then every polygon of type K has at
  least 44 edges.

The hypothesis on the colouring count is Phase 3 (`PHASE3_PLAN.md`); until Phase 3 is done it stays a named
hypothesis, exactly like `TopHyp` in the 5_2 proof, and the computation and the normal form are complete.

## 3. Primeness

`-stair` uses Lemma 3 of PROOF.md (a twice-crossed mid-plane splits a prime knot as a connected sum, so one
side is trivial). Its proof needs the connected-sum decomposition and the uniqueness of unknotted ball-arc
pairs, which are far from what can be formalised here. The Lean search uses agent K's primeness-free rules
instead (`dmon2/wip_K/REPORT.md`): Lemma 3* (curtain disk: a side that projects injectively is a geodesic),
Lemma 5* (a certified computer lemma for arcs of at most L* = 17 edges, L = 18 running), Lemma M (one maximum:
level-by-level Delta-sweep), rules S4 (`-arcmin`) and S5 (`-onemax`). All three are statements about
Delta-moves, so they fit `Lean42/Delta.lean`. They recover 79-87% of `-stair` (all of it where N <= 2M).
They also remove the restriction to prime targets.

## 4. Stages

* **A. Executable port, no proofs.** Port L42 to Lean as a program (two-ended state, the tests above), check
  that it gives the same words as the C++ L42 variant at n <= 34 and the same node counts, and measure the
  cost per node. This fixes the cost of n = 42 before any proof is written. First build L42 in C++ (U2 with
  the dropped tests off and S4/S5 from `wip_K/enum_s3.cpp` in place of `-stair`) and measure it at n = 34-40.
* **B. Normal form (PanDMONium II).** Extend `Survive` by the face rules F1/F2, tau and S4/S5, and prove that
  every knot type has a shortest polygon in this normal form (the 5_2 proof does it for DMON1-DMON7 in
  `Len52/NF/`). Lemma 3*, Lemma M and the face rules are Delta-move constructions; Lemma 5* is a finite
  computation checked by a Lean program.
* **C. Completeness of the search.** Port `Len52/SP/` to the two-ended state, and prove each new prefix test
  sound: every word in normal form passes it. The bounds (travel, plane debt, GW3 with axis counts) are
  "the rest of the word is such a walk" arguments.
* **D. Runs.** All parts for n = 4, ..., 42 on Actions, with the provenance rules of the 5_2 proof
  (`run_local.sh`, `verify_comp.py`).
* **E. Leaf invariants.** The Phase 4 quandle counts on the output words, and the final theorem per target.

## 5. Paper

The n = 42 result goes in a second paper. The 5_2 paper is complete and reviewed. The second paper needs
new theory: the two-ended search, the face rules, tau, the primeness-free lemmas, the quandle invariants
and the Delta-move foundation of `Lean42/`. Its result is a table (which knot types have length at most 42,
with Len(8_19) = 42), not one value. It cites the first paper for DMON1-DMON7 and PanDMONium.
