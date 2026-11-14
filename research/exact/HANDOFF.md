# Handoff: exact minimal lengths by exhaustive enumeration (branch `claude/great-einstein-snvnnb`)

Last updated 14 Nov 2026. Read this first; then `enum.cpp` (its header states the lemmas).
Labels: [E] established, [C] computed here (command given), [J] proposal.

## Goal of this line of work
Prove new exact values of Len(K) (least number of edges of a simple-cubic polygon of knot type K).
Proved so far in the literature: 3_1 = 24 [Diao93], 4_1 = 30 and 5_1 = 34 [Scharein09, full
proofs never published]. Target: **Len(5_2) = 36**, and "every knot except 3_1, 4_1, 5_1 needs
at least 36 edges". A Haiku literature check (8 web searches, 14 Nov 2026) found no proof of
either statement; that is not proof of novelty, re-check before claiming.

Method: for each even n <= 34 list every n-edge polygon that could be a shortest polygon of its
knot type; identify each one; if none is a 5_2 (or anything new), the bound follows, because the
upper bound 36 is known (`data/rechnitzer_SC_minimal.csv`).

## Lemmas the pruning rests on (proofs still to be written up in PROOF.md)
1. **Curtain lemma.** Sub-path v0, v0+a, (k steps perpendicular to a), then -a. If none of the
   k-1 points directly "below" the interior (shifted by -a) is a vertex, the sub-path can be
   pushed down: same knot, 2 fewer edges. k = 1 is the BFACF -2 move. So in a shortest polygon
   every such sub-path has an occupied point below its interior.
2. **Pushed-down normal form.** Among shortest polygons of a type with (#z) <= (#y) <= (#x)
   steps, take one minimising Psi = sum(z - zmin), then Psi2 = sum(y - ymin). Then no corner
   flip lowers a vertex in z, or keeps z and lowers y. So for consecutive steps (u,h), (h,d),
   (n,x), (x,s) (h horizontal, x in {e,w}) the fourth point of the corner's unit square is a
   vertex. Translation-invariant and bounded below, so the minimum exists.
3. Canonical position: least vertex in (z,y,x) order at the origin; first step < reverse of
   last step (e < n < u); axis order as in 2.
4. Leaf filter: breadth-first search over neutral BFACF moves; a polygon that reaches a U-turn
   is not shortest. A limit hit keeps the polygon (safe direction).
Every rule only discards polygons that are provably not the chosen shortest representative.

## Programs
| file | what | status |
|---|---|---|
| `enum.cpp` | walk-order depth-first search with the rules above | **use this one** |
| `raster.cpp` | same conditions, site-by-site sweep in (z,y,x) order | correct idea, far slower (3.9e9 nodes at n = 22 vs 2.5e7); kept as a negative result and as a future cross-check; not yet shown to give the same output |
| `identify_words.py` | Alexander polynomial + SnapPy name for a file of words (written by a Haiku agent; needs `pip install snappy spherogram`) | works on 5 test words |

Build: `g++ -O3 -march=native -std=c++17 -pthread -o enum enum.cpp`
Run: `./enum N -out FILE` (options in the header: `-nopsi`, `-plain`, `-noaxes`, `-part R M`, `-tourcap C`).

## Checks done [C]
* `./enum N -plain -noaxes`, N = 4..16: 3, 22, 207, 2412, 31754, 452640, 6840774 polygons,
  equal to the known counts of unrooted polygons p_n [E].
* `./enum N -nopsi`, N <= 22: no survivors. N = 24: 2592 survivors (these are the 24-edge
  polygons with the axis rule; expanding by symmetry should give 3328, **not yet done**).
* `./enum 24` (with the normal form): 50 survivors; identical output before and after the
  bound rewrite.
* Not yet done: identify the survivors; cross-check `enum` against `raster` on n <= 22;
  an independent re-implementation of the curtain test.

## Search-tree size [C] (4 threads, this container)
| n | nodes, `-nopsi`, first version | nodes, normal form + span/tour bound |
|---|---|---|
| 18 | 6.5e6 | 1.1e6 |
| 20 | 4.2e7 | 5.2e6 |
| 22 | 3.0e8 | 2.5e7 |
| 24 | 2.2e9 | 1.2e8 (69 s) |
Growth is about 4.85 per 2 edges with the current bounds, so n = 34 is about 3e11 nodes [J:
extrapolation]. Speed is the open issue: about 2e6 nodes/s on 4 threads because the exact
tour bound is slow; `-tourcap` trades pruning for speed (cap 30: 2.8e7 nodes, 4.4 s at n = 22).

## Next steps, in order
1. Make the tour bound cheap (most time goes there); then run n = 26, 28, 30.
2. Identify survivors (`identify_words.py`): expect only 3_1 at 24-28, 4_1 at 30.
   That alone is a machine proof of Len(3_1) = 24 and Len(4_1) = 30 [J until run].
3. `-nopsi` at 24 and 30 plus symmetry expansion: exact counts of shortest polygons
   (3328 for 3_1; 3648 vs 1824 for 4_1 is disputed between [JvRR11] and [Scharein09]).
4. n = 32 and 34 with `-part R M` split over machines; then PROOF.md.
5. Composite knots need no separate argument: the rules hold for every knot type.

## Colab (separate from the proof)
* `colab --auth=adc ...` works; each new VM has its own host `*.prod.r.colab.dev`, which the
  sandbox blocks until it is added to the `k-not-theory` environment (or a wildcard is added
  in Settings). `colab run` therefore fails here; use `colab new`, allow the host, then
  `colab upload` / `colab exec`.
* Ran `census/ml/colab_job.py` (from branch `census/native-pipeline`) on a T4, 20 epochs,
  151 s in total. Log: `research/colab/colab_il_T4.log`. Held-out success within 25/50/100
  expansions: value net 37.5/53.3/75.8 %, random 7.5/31.7/55.0 %, BFS 0/0/18.3 %. Weaker than
  the local CPU run in `census/README.md` (48/69/81 %) because the packaged job embeds 60 k of
  the 183 k training states and overfits after epoch 9. The GPU is not the bottleneck; data is.
* Stop any session you are not using: `colab --auth=adc stop -s NAME` (a T4 uses compute units).
