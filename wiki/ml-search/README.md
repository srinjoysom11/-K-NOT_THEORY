# ML, reinforcement learning and search methods

Goal-1 background: which learning and search techniques have been used on knots, lattice self-avoiding chains and extremal constructions, what they achieved, and how they certified results. Lattice-specific Monte Carlo (BFACF, GAS) is in [algorithms/bfacf-and-gas](../algorithms/bfacf-and-gas.md).

## 1. Generic "find a better construction" loops

| method | loop | results relevant here | source |
|---|---|---|---|
| **Deep cross-entropy RL** | network emits a construction letter by letter; score N sessions; keep the top y%; train on their (state, action) pairs; repeat | counterexamples in spectral graph theory (λ_1 + μ, n = 19, ≈ 5000 iterations, "a few hours on an average PC"), distance-Laplacian, permanents (n ≲ 10 alone), trees via Prüfer codes | [Wagner21] |
| **PatternBoost** | alternate *local* classical search (many good constructions) with *global* transformer trained on the best; transformer samples seed the next local phase | triangle-free n = 20 converges to K_{10,10}; C_4-free n = 33: 91 edges (local search alone: 89 from 50 M runs); a 30-year-old conjecture refuted. Global-only (no local search) was "disastrously bad" | [CEWW24] |
| **LLM-guided search** | an LLM proposes configurations or proofs; human validation | pearl necklaces with fewer spheres than the FCC minimal length (N_P = N_L − 1 for all 5–7-crossing knots, 8_19, 10_124; N_L − 2 for 8_1); ropelength bounds marked unverified | [Klotz26pearl], [Klotz26llm] |
| **AlphaEvolve** (LLM-driven evolutionary code search) | LLMs edit a *program* that builds or searches for a construction; evaluators score it; an evolutionary database keeps the best programs | on > 50 problems matched the best known construction in ≈ 75% and beat it in ≈ 20%: kissing number in dimension 11 raised to 593; packings (11 and 12 unit hexagons in a hexagon: sides 3.931, 3.942; circle packings); Heilbronn configurations; ⟨4,4,4⟩ complex matrix multiplication rank 48. No knots, lattices or ropelength appear in it | [Novikov25]; [GGTW25]: follow-up on 67 problems in analysis, combinatorics, geometry and number theory — rediscovers most best-known constructions, improves several, sometimes generalises finite cases to formulas; only lattice-point problems are grid subsets (no isosceles triangles in [n]², no 5 cospherical/coplanar points in [n]³). ⚠ the local PDF is truncated (re-download from arXiv 2511.02864) |

*My remark:* minimal-length search is exactly this shape (a construction = a closed lattice walk; a score = −length subject to the knot type being correct). PatternBoost's finding that the local search is essential matches the success of BFACF/GAS: a learned global proposal is worth adding *on top of* BFACF, not instead of it.

## 2. RL on knot diagrams

* **Unknotting braids** ([GHRS20]): state = braid word (≤ 2N_max letters); actions = SmartCollapse, cyclic shifts, two braid relations, N_max conjugations (5 + N_max actions); reward = −(word length) per step, −4N_max for illegal moves. TRPO with a feed-forward net (ChainerRL defaults, 5×10⁶ steps ≈ 24 h on one GPU) fully reduces ≈ 85% of unknot braids at every tested length up to 96 letters, beating A3C by > 2× and a random walk by ≈ 8× at N_max = 96. **Certification:** reaching the empty word is an explicit proof of unknottedness. Classification side: Reformer/transformer classifiers distinguish unknots from knots at mid- to high-90s accuracy but score 2.2% on 176 known hard 15-crossing unknots.
* **Unknotting number** ([Applebaum24]): RL agent finds minimal unknotting crossing sets in diagrams with up to ≈ 200 crossings; u(K) determined for ≈ 57k knots where the RL upper bound meets a knot Floer lower bound; 43 knots with ≤ 12 crossings get u (assuming additivity); a by-product dataset of 2.6 M hard unknot diagrams.
* **Learning topological invariance** ([HR25]): contrastive / generative transformers map braid representatives of the same knot to the same embedding point; a student–teacher probe finds the embedding correlates strongly with the Goeritz matrix; used to search near the unknot cluster for Jones-trivial braids (no counterexample to the Jones unknot conjecture among several 100k generated knots).
* **ML-guided discovery** ([DJLT21]): ML spotted a relation between signature and cusp geometry, leading to the proved inequality |2σ(K) − slope(K)| ≤ c·vol(K)·inj(K)^{−3} (natural slope).

## 3. Hard unknots and simplification

[CSS26] (ReAPR): alternates pass-move reduction with re-embedding that minimises total height variation (min-cost flow; the minimum equals 2(n − k), k = least crossings to virtualise to make the diagram virtually alternating). It simplifies every published hard unknot plus new sets (≈ 2.6 M diagrams) in under 30 s total CPU, matching SnapPy and ≈ 60× faster. Relevant here: test set A is **200 BFACF-generated lattice unknots** with ≈ 111k crossings each, on which Regina and SnapPy's diagrammatic method time out. So diagram-level certification of lattice polygons needs re-embedding methods, not Reidemeister moves alone.

## 4. Knot-type recognition of polymer conformations

| source | model | data | result |
|---|---|---|---|
| [Vandans20] | RNN vs feed-forward | confined bead chains L = 60–100, 5 knot types, up to 2×10⁶ per type | RNN 99.59% vs FFNN 71.25% (L = 100); ≈ 20× faster than computing Alexander polynomials; generalises to other lengths |
| [BKBO22] | bidirectional LSTM | strongly confined flexible rings N = 64–512, 5 knot types, 3 densities | works on highly entangled rings; coarse-graining helps for longer rings; errors stay within topological family; CNNs worse; input features matter |
| [ZZD25] | transformer + diffusion | Langevin rings N = 100–1000, 8 knot types, 2.4×10⁶ conformations | > 99% accuracy, one model across lengths, ≈ 4500× faster than Alexander polynomials; diffusion model *generates* conformations of a requested knot type with correct size statistics |

None of these classifiers certifies a knot type; they are fast filters. *My remark:* for a lattice search they can pre-screen candidates, but every reported minimum must be checked with an invariant (HOMFLY, hyperbolic volume) or by BFACF-connectivity to a known polygon.

## 5. Lattice protein folding (HP model) — the closest analogue

Folding a sequence as a self-avoiding walk on a lattice to maximise H–H contacts is the same kind of combinatorial search as finding short lattice knots.

| source | method | lattice / benchmark | result |
|---|---|---|---|
| [RC23] | Lazy Nested Monte Carlo Search with biased playouts | 3D HP, ten 48-mers | reaches best known energies on several, not state of the art (PERM, REMC, Wang–Landau are better); NRPA/UCT weaker |
| [Yang22] | DQN with LSTM, sparse terminal reward | 2D HP, lengths 20–50 | best known energies on all benchmarks, several distinct optima per trial |
| [EPG24] | DQN with reservoir layer (N ≤ 36) or LSTM + attention | 3D HP | optimal for short chains with 25% fewer episodes; ⚠ despite the abstract, its own Table 3 shows the LSTM model matching best known values only for 3D1–3D4 (1–4 above on 3D5–3D9) |
| [WL12] | Wang–Landau sampling of the density of states with pull, bond-rebridging and pivot moves (fully blind, no sequence-specific tuning) | 2D/3D HP, hardest benchmarks (e.g. 103-mer: 59 energy levels, g(E) over > 50 orders of magnitude) | found all known putative ground states and, for most sequences, the full density of states — the strongest classical baseline here (cited as state of the art by [RC23]) |

## 6. What carries over to minimal-length search (*my remarks*)

1. Keep a strong local move set (BFACF neutral/negative moves) as the inner loop; use learning only to propose starting points or bias move choice.
2. Certification must be independent of the model: invariants for the knot type, and minimality remains unprovable by search; exhaustive enumeration ([Scharein09] style) is the only certifier so far.
3. Rewards: GHRS20's dense "−length" reward with a large illegal-move penalty is a direct template (length = number of lattice edges; illegal = self-intersection or change of knot type).
4. Move sets from HP-model work (pull moves, bond-rebridging, pivots — [WL12]) mix fast but do **not** preserve knot type; in a fixed-type search they need a knot-type check after each accepted move, or restriction to BFACF.
5. Data: [data/rechnitzer_SC_minimal.csv](../../data/rechnitzer_SC_minimal.csv) and the [Scharein09] tables give targets for all 249 prime knots ≤ 10 crossings.
