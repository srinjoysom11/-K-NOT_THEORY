# Kaggle plan: scaling the knot-census pruning benchmark

Goal: extend the exact census (and the pruning experiments) from 12 crossings
to 13-15, then use GPU quota for the neural / evolutionary direction.

Status going in: exact census reproduced through 12 crossings (1288+888 at 12),
Regina `simplify()` removes ~99.5% of candidates, ML pruning on diagram-shape
features did not beat random (AUC 0.58-0.60). Invariant-feature comparison is
still running.

Kaggle limits below are from memory and must be checked in the current docs
before relying on them: ~4 CPU cores / ~30 GB RAM per CPU session, session
length ~9-12 h, weekly GPU quota ~30 h, internet must be switched on to pip
install, files move via Kaggle Datasets / notebook output.

## Cost estimates (extrapolated, not measured)

Growth observed 11 -> 12: candidates x9.4, survivors x6.9. At 12 crossings the
run is ~361 CPU-s (gen 150, SnapPy 164, simplify 31, features 16).

| n  | new knots (alt + non-alt) | est. CPU-hours | 4-core wall hours | sessions (~9 h) |
|----|---------------------------|----------------|-------------------|-----------------|
| 13 | 4,878 + 5,110             | ~1             | ~0.3              | 1 (minutes)     |
| 14 | 19,536 + 27,436           | ~7             | ~2                | 1               |
| 15 | 85,263 + 168,030          | ~55            | ~14               | 2               |
| 16 | 379,799 + 1,008,906       | ~440           | ~110              | ~12             |

A C++ generator (see Phase 0) should cut these by ~1.3-2x. Stop at 15 unless
Phase 1 shows the estimates are conservative.

## Phase 0: preparation here (no Kaggle needed)

1. Profile candidate generation at n=11: split Python PD building vs Regina
   `fromPD`/`knotSig`. Decides whether the C++ kernel is worth writing.
2. Sharded runner `knotml/shard.py`: `--level n --shard i --of K`.
   - Shadows split deterministically by index (round-robin on a cost-sorted
     list, so shards are balanced).
   - Each shard writes survivors, counts, CPU times, and (optionally) SnapPy
     ids to one npz. No cross-shard duplicate diagrams exist, so no
     cross-shard dedupe is needed before identity.
3. Merge script `knotml/merge.py`: unions ids across shards, applies the known
   table from lower levels, resolves composites, prints the exact census and
   compares to the published counts.
4. Precompute shadows once. The plane-map enumeration is single-threaded
   Python; expected shadow counts ~32k (n=13), ~145k (14), ~650k (15). Ship
   them as a dataset so shards don't each recompute them. If enumeration at 14+
   is too slow or too big, rewrite it in C++ first (own code, not plantri).
5. Crash safety: Burton reports SnapPy crashes at scale. Wrap identity workers
   so a crash retries the item and logs it instead of killing the shard.
6. Reproducibility: pin `snappy==3.3.2`, `regina==7.4`; record the random seed
   used for `simplify()`.
7. Acceptance test: run n=11 and n=12 with K=4 shards locally; merged census
   must equal 552 and 2176 exactly.

## Phase 1: CPU runs on Kaggle (n = 13, then 14, then 15)

- Upload one dataset: code zip, `known.json` (through n-1), shadows for n.
- One notebook, internet on for `pip install`, runs shards with a process pool
  and writes results to the output folder; download and merge here.
- Success criterion at each n: merged census equals the published counts
  (Thistlethwaite, Table 3). A mismatch is a bug, not a result.
- Gate: only start n+1 when n matches and measured CPU time is within 2x of
  the estimate above.

## Phase 2: pruning experiments with the exact data (n <= 14)

Survivors: ~0.5M at 13, ~3.7M at 14 (estimated). Keep features compact; do not
store dense feature matrices for 15.

1. Finish the feature-set comparison (diagram / invariants / both) and rerun
   it on 13 and 14 with the same no-peeking protocol.
2. Test the strategy that could actually be safe and large: group survivors by
   HOMFLY key and send only a sample per group to SnapPy, ordered by model
   score, with the rest pruned. Measure SnapPy calls saved and census
   completeness. HOMFLY lookup alone lost 56 of 2,176 knots at n=12.
3. Report: calls saved at 100% completeness, versus the oracle (51.8% at n=11,
   61.0% at n=12) and versus random.

## Phase 3: GPU quota, neural simplifier (the original idea)

The benchmark that matters: survivors where `simplify()` fails but the diagram
is reducible (57-67% of non-alternating survivors). A learned simplifier is
useful if it reduces a meaningful share of them.

1. Representation: PD graph with crossing signs; train a GNN to predict
   "reducible" (compare against the gradient-boosting baseline).
2. Imitation then RL: collect shortest simplification paths via exhaustive
   Reidemeister search on small diagrams (the denoised-trajectory idea), clone
   them, then fine-tune with reward = crossings removed.
3. Evolution strategies as the parallel alternative (workers share only
   scalars), later reused for the polygonal-knot model.
4. Metric: fraction of hard-reducible survivors reduced, per unit compute,
   versus `simplifyExhaustive(1)` and `simplifyExhaustive(2)`.

## Risks

- Kaggle quotas and session limits may differ from what is listed; check first.
- Plane-map enumeration may be the first real wall (n >= 14).
- ML may stay negative; the plan still produces exact census data to 14-15.
- Everything runs your account and my code: review the notebook before running
  it, and never paste Kaggle API tokens into chat.

## Needed from you

- Confirm Kaggle account is verified for internet access, and check current limits.
- Choose the stopping level (suggest 15).
- Run notebooks and move the output folders; I can't reach Kaggle from here.
