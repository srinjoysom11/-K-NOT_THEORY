# Novikov25 — AlphaEvolve: A coding agent for scientific and algorithmic discovery
- **Authors:** Alexander Novikov*, Ngân Vũ*, Marvin Eisenberger*, Emilien Dupont*, Po-Sen Huang*, Adam Zsolt Wagner*, Sergey Shirobokov*, Borislav Kozlovskii*, Francisco J. R. Ruiz, Abbas Mehrabian, M. Pawan Kumar, Abigail See, Swarat Chaudhuri, George Holland, Alex Davies, Sebastian Nowozin, Pushmeet Kohli and Matej Balog* (Google DeepMind; * equal contribution). Corresponding: Balog, Novikov, Kohli.
- **Venue / year / identifiers:** arXiv:2506.13131v1 [cs.AI], 16 Jun 2025 ("white paper", © 2025 Google DeepMind)
- **File:** papers/5_ml_rl/Novikov-et-al_2025_AlphaEvolve_2506.13131.pdf   **Pages:** 44
- **Text layer:** partly garbled (math italic letters render as private glyphs; formulas in App. B and Fig. 5/12 checked against page images)

## Abstract
In this white paper, we present AlphaEvolve, an evolutionary coding agent that substantially enhances capabilities of state-of-the-art LLMs on highly challenging tasks such as tackling open scientific problems or optimizing critical pieces of computational infrastructure. AlphaEvolve orchestrates an autonomous pipeline of LLMs, whose task is to improve an algorithm by making direct changes to the code. Using an evolutionary approach, continuously receiving feedback from one or more evaluators, AlphaEvolve iteratively improves the algorithm, potentially leading to new scientific and practical discoveries. We demonstrate the broad applicability of this approach by applying it to a number of important computational problems. When applied to optimizing critical components of large-scale computational stacks at Google, AlphaEvolve developed a more efficient scheduling algorithm for data centers, found a functionally equivalent simplification in the circuit design of hardware accelerators, and accelerated the training of the LLM underpinning AlphaEvolve itself. Furthermore, AlphaEvolve discovered novel, provably correct algorithms that surpass state-of-the-art solutions on a spectrum of problems in mathematics and computer science, significantly expanding the scope of prior automated discovery methods (Romera-Paredes et al., 2023). Notably, AlphaEvolve developed a search algorithm that found a procedure to multiply two 4 × 4 complex-valued matrices using 48 scalar multiplications; offering the first improvement, after 56 years, over Strassen's algorithm in this setting. We believe AlphaEvolve and coding agents like it can have a significant impact in improving solutions of problems across many areas of science and computation.

## Notation and conventions
- Evaluation function h: maps a solution to a set of scalar metrics, by convention maximised; implemented as a Python function `evaluate` returning a dict of scalars (p. 3-4).
- ⟨m, n, p⟩ = tensor representing the product of an m×n and an n×p matrix; "rank" of its decomposition = number of scalar multiplications (Table 2 caption p. 9; Section 3.1 p. 9). Sorted sizes m ≤ n ≤ p used because of symmetry (p. 34).
- Autoconvolution f∗f(t) = ∫_R f(t−x) f(x) dx (p. 38). Step functions "with N equally-spaced intervals on [−1/4, 1/4]" (p. 38).
- Square-of-ratio convention (p. 41): for min/max distance ratio problems the reference [29] reports the square of the ratio; same convention used here (values written as √(number)).
- SOTA = state of the art; "best known" cited per row to a reference [n] (App. A).
- No lattice, knot, stick, ropelength or polymer notion appears in the paper (text searched).

## Numbered statements
- **Lemma 1 (p. 43, App. B.11).** Let S ⊂ R^d be a set of points satisfying 0 ∉ S and min{‖x − y‖ : x ≠ y ∈ S} ≥ max{‖x‖ : x ∈ S}. Then unit spheres centred at {2x/‖x‖ : x ∈ S} form a valid kissing configuration in dimension d. In particular, the kissing number in dimension d is at least |S|. *Proved here.* Proof as printed: for x ≠ y, ‖x − y‖² ≥ max{‖x‖², ‖y‖²} gives 2⟨x,y⟩ ≤ ‖x‖² + ‖y‖² − max{‖x‖²,‖y‖²} = min{‖x‖²,‖y‖²} ≤ ‖x‖·‖y‖ (eq. 4, since the min of two positive numbers is ≤ their geometric mean); points 2x/‖x‖ have norm 2; non-overlap ⇔ ‖2x/‖x‖ − 2y/‖y‖‖ ≥ 2 ⇔ 2⟨x,y⟩ ≤ ‖x‖·‖y‖, which is (4).
- No other theorems/propositions. The mathematical results are reported as new numerical bounds (listed below), each "provably" correct by explicit construction whose data and verification code are in the accompanying Google Colab (p. 3 footnote 2, p. 38).

## Key equations and quantitative claims outside numbered statements
### Headline numbers
- p. 3: improves SOTA for 14 matrix-multiplication targets; ⟨4,4,4⟩ rank 48 over complex numbers (previous: 49 via recursive Strassen; Fawzi et al. 47 over GF(2)).
- p. 3, p. 10: on > 50 mathematical problems, "match the best known constructions on ∼75%" and "surpasses the SOTA ... on ∼20%"; started from a simple or random construction; spans > 5 branches (analysis, combinatorics, number theory, geometry) with numerous parameter settings.
- p. 14: scheduling heuristic recovers on average 0.7% of Google's fleet-wide compute resources otherwise stranded. p. 16: tiling heuristic gives average 23% kernel speedup, 1% reduction in Gemini training time; kernel optimisation time from months to days. p. 17: FlashAttention kernel 32% faster, pre/post-processing 15% faster. p. 16: TPU Verilog rewrite removed unnecessary bits (also independently found by synthesis tools).

### Geometry / combinatorics results (all from Section 3.2, Fig. 5 and Appendix B; "→" = previous best → AlphaEvolve; all are explicit constructions)
- **Kissing number in dimension 11 (p. 13, B.11 p. 42-43):** lower bound 592 [31] → 593: AlphaEvolve found 593 non-zero integer-coordinate points in R^11 with maximum norm smaller than the minimum pairwise distance (then Lemma 1 applies). (p. 13 says "593 non-overlapping unit spheres touching a central unit sphere".) Exact Lemma condition on p. 43 is "min pairwise distance ≥ max norm"; the text says "maximum norm ... smaller than their minimum pairwise distance" ⚠ (strict vs non-strict wording).
- **Packing n unit regular hexagons into a regular hexagon, minimise outer side length (B.7, p. 41, Fig. 11):** n = 11: 3.943 [29] → 3.931; n = 12: 4.0 [29] → 3.942.
- **Min ratio of max to min pairwise distance for n points in R^d (B.8, p. 41-42, Fig. 12):** d = 2, n = 16: best known √12.890 [29] → √12.889266112 (ratio ≈ 3.5902; squares reported); d = 3, n = 14: √4.168 [29] → √4.165849767. Fig. 5 shows "12.890 → 12.889" for the squared ratio.
- **Heilbronn problem for triangles (B.9, p. 42, Fig. 13 left):** n = 11 points in/on a unit-area triangle, maximise the smallest triangle area: 0.036 [29] → "larger than 0.0365".
- **Heilbronn problem for convex regions (B.10, p. 42, Fig. 13):** n = 13: 0.0306 [29] → 0.0309; n = 14: 0.0277 [29] → 0.0278 (points on/in a unit-area convex region).
- **Packing circles in a unit square, maximise sum of radii (B.12, p. 43-44, Fig. 14):** n = 26: 2.634 → 2.635; n = 32: 2.936 → 2.937. ⚠ Fig. 5 (p. 12) shows "Sum of radii 2.6340 → 2.6358" for the n = 26 case, App. B.12 gives 2.635 (consistent to 3 digits).
- **Packing circles in a rectangle of perimeter 4, maximise sum of radii (B.13, p. 44, Fig. 14 right):** n = 21: 2.364 [29] → 2.3658 (Fig. 14 caption "≥ 2.365").
- **Sums and differences of finite sets (B.6, p. 40-41):** C6 = largest constant such that there exist arbitrarily large finite integer sets A, B with |A+B| ≪ |A| and |A−B| ≫ |A+B|^{C6}. Known: 1.14465 ≤ C6 ≤ 4/3 (upper bound [39, Cor. 3], lower bound [39, Thm 1]). Tool (eq. 3, Gyarmati et al. [39]): C6 ≥ 1 + log(|U−U|/|U+U|)/log(2 max(U)+1) for any finite set U of non-negative integers containing zero with |U−U| ≤ 2 max(U)+1. AlphaEvolve found a set U1 of size 2003 giving 1.1479 ≤ C6, and U2 of size 54265 giving 1.1584 ≤ C6.
- **Erdős minimum overlap (B.5, p. 40, Fig. 10):** C5 = largest constant with sup_{x∈[−2,2]} ∫_{−1}^{1} f(t) g(x+t) dt ≥ C5 for all non-negative f, g: [−1,1] → [0,1] with f + g = 1 on [−1,1], ∫ f = 1 (extended by zero). Known 0.379005 ≤ C5 ≤ 0.380927 (lower bound [107] by convex programming). Equivalent (via [40]) to the infimum over step functions h on [0,2] with values in [0,1] and ∫_0^2 h = 1 of max_k ∫ h(x)(1 − h(x+k)) dx. AlphaEvolve step function gives C5 ≤ 0.380924. ⚠ Fig. 5 states the previous bound as 0.380926 while B.5 says 0.380927.
- **First autocorrelation inequality (B.1, p. 38):** C1 = largest constant with max_{−1/2≤t≤1/2} f∗f(t) ≥ C1 (∫_{−1/4}^{1/4} f)² for all non-negative f. Known 1.28 ≤ C1 ≤ 1.5098 (lower [17], upper [70]); AlphaEvolve: step function with 600 equally spaced intervals on [−1/4, 1/4] gives C1 ≤ 1.5053.
- **Second autocorrelation inequality (B.2, p. 38):** C2 smallest constant with ‖f∗f‖²_2 ≤ C2 ‖f∗f‖_1 ‖f∗f‖_∞ for all non-negative f. Known 0.88922 ≤ C2 ≤ 1 (lower bound from a step function [70]); AlphaEvolve: 50 equal intervals, 0.8962 ≤ C2.
- **Third autocorrelation inequality (B.3, p. 38):** C3 largest constant with max |f∗f(t)| ≥ C3 (∫ f)² for any f (may take both signs); C3 ≤ C1; known C3 ≤ 1.45810 ([104] p. 75); AlphaEvolve: 400 equal intervals, C3 ≤ 1.4557.
- **Uncertainty inequality (B.4, p. 39):** A(f) = inf{r > 0 : f(x) ≥ 0 for all |x| ≥ r}; C4 = largest constant with A(f)A(f̂) ≥ C4 for all even f with max(f(0), f̂(0)) < 0. Known 0.2025 ≤ C4 ≤ 0.3523 ([33]; paper states 0.353, rounding gives 0.3523). AlphaEvolve: C4 ≤ 0.3521 with f(x) = P(x)e^{−πx²}, P = c0 H0 + c1 H4 + c2 H8 (Hermite), [c0, c1, c2] ≈ [0.32925, −0.01159, −8.9216×10⁻⁵], upper bound r_max²/(2π) where r_max = largest positive root of P(x)/x². Note on p. 39: after publication of the first version, Cohn pointed out a refined approach [18] giving 0.3284; incorporating it AlphaEvolve got 0.3216 (details in Colab). ⚠ This note refers to a "first version" though the file is labelled v1.
- Fig. 5 (p. 12) summary of "SOTA-breaking" values: 1.5098 → 1.5053; 0.8892 → 0.8962; 1.4581 → 1.4557; 0.3523 → 0.3521; hexagon outer edge 4.000 → 3.942; max/min distance 12.890 → 12.889; sum of radii 2.6340 → 2.6358; 0.380926 → 0.380924; 1.1446 → 1.1584 (image-checked; note 0.8892 vs 0.88922 in B.2, 1.1446 vs 1.14465 in B.6, rounding only).

### Matrix multiplication (Section 3.1, Table 2/3)
- p. 9-10: starting from a standard gradient-based algorithm (initializer, reconstruction loss, Adam), AlphaEvolve evolves the decomposition algorithm; evaluation: for each target run with multiple random seeds, metric = best (lowest) rank and fraction of seeds achieving it; elements rounded to nearest integer or half-integer; prompt asks for near-integral solutions. p. 11 (Fig. 4): the rank-48 ⟨4,4,4⟩ program required 15 mutations; changes touch optimizer (Adam→AdamW with weight decay), weight initialisation (smaller scale), loss (discretisation loss, half-integer cosine annealing), hyper-parameter sweep (ranges listed in the diff, e.g. learning rate 0.01-0.2), gradient/parameter noise, cyclic clipping with 2000-step cycle.
- p. 34: 54 sizes considered; match SOTA in 38, surpass in 14, fall behind in 2; programs run beyond ⟨5,5,5⟩ with 1000 random seeds on a single GPU often run out of memory. p. 34 note: concurrent work [49] also found rank 90 for ⟨4,5,6⟩.

## Methods / algorithms
AlphaEvolve procedure (this is an LLM-guided evolutionary program search, not a lattice/knot method).
1. (p. 3-4, Fig. 1-2) Human supplies the problem definition: evaluation code h, an initial (possibly rudimentary) program with `# EVOLVE-BLOCK-START/END` markers, optional background knowledge. Loop: parent_program, inspirations = database.sample(); prompt = prompt_sampler.build(...); diff = llm.generate(prompt); child = apply_diff(parent, diff); results = evaluator.execute(child); database.add(child, results).
2. (p. 5) Abstraction choices: evolve the raw solution string; evolve a constructor function; evolve a bespoke search algorithm within a fixed compute budget; or co-evolve solutions and search algorithms. Hypothesis: highly symmetric solutions favour evolving constructors; non-symmetric ones favour evolving search algorithms.
3. (p. 5) Prompt sampling: previously discovered solutions from the database + system instructions; optional explicit context (equations, code, literature PDFs), stochastic formatting, rendered evaluation results, meta-prompt evolution (prompts co-evolved in a separate database).
4. (p. 5-7) Generation: LLM outputs SEARCH/REPLACE diff blocks (or whole code block for short programs). Models: ensemble of Gemini 2.0 Flash (throughput) and Gemini 2.0 Pro (occasional higher-quality suggestions).
5. (p. 7-8) Evaluation: optional evaluation cascade (increasingly hard test cases, early pruning, small-scale first), LLM-generated feedback (e.g. simplicity), parallelised evaluation (on the order of 100 compute-hours per solution is feasible), multiple scores optimised simultaneously.
6. (p. 8) Evolution database: inspired by MAP-elites and island-based population models; balances exploration/exploitation.
7. (p. 8) Distributed pipeline: asynchronous (asyncio) controller, LLM samplers, evaluation nodes; optimised for throughput.
8. (p. 12) For the maths problems: each generation evolves a search-heuristic program with a fixed time budget (e.g. 1000 seconds) that is shown the best construction found by the previous best heuristic; final constructions come from a sequence of specialised heuristics (early: large gains from random/simple states; late: fine-tuning). Problems mostly suggested by Javier Gómez Serrano and Terence Tao.
9. (p. 13-17) Engineering applications: Borg scheduling heuristic (vector bin-packing with 2 variables; heuristic score = −(cpu_residual + mem_residual + mem_residual/cpu_residual + cpu_residual/mem_residual), Fig. 6), Pallas tiling heuristic for Gemini, Verilog RTL of a TPU arithmetic circuit, XLA IR for FlashAttention.
10. (p. 17-18) Ablations on matrix-multiplication decomposition and kissing number: removing evolution, context in prompt, meta-prompt evolution, full-file evolution, or using only a small base LLM each significantly lowers the aggregated target metric at all compute fractions (Fig. 8; averaged over targets and 3 random seeds; only qualitative curves, no numbers in the text).
- Compute: not given as a total budget; per-solution evaluation up to ~100 compute-hours; "thousands of LLM samples suffice" (Table 1).

## Tables
**Table 1 (p. 2)** — Capabilities and typical behaviours of AlphaEvolve and our previous agent.

| | FunSearch [83] | AlphaEvolve |
|---|---|---|
| Scope of evolution | evolves single function | evolves entire code file |
| Size | evolves up to 10-20 lines of code | evolves up to hundreds of lines of code |
| Language | evolves code in Python | evolves any language |
| Evaluation | needs fast evaluation (≤ 20min on 1 CPU) | can evaluate for hours, in parallel, on accelerators |
| LLM samples | millions of LLM samples used | thousands of LLM samples suffice |
| LLMs | small LLMs used; no benefit from larger | benefits from SOTA LLMs |
| Context | minimal context (only previous solutions) | rich context and feedback in prompts |
| Objectives | optimizes single metric | can simultaneously optimize multiple metrics |

**Table 2 (p. 9)** — Upper bounds on the rank of the tensor ⟨m,n,p⟩ representing the product of an m×n matrix and an n×p matrix, i.e. the number of scalar multiplications required to compute this matrix product. Beyond the examples shown here, for all parameters m, n, p ≤ 5, AlphaEvolve either matched or surpassed the best known solutions, and provided exact algorithms (see Table 3). For ⟨3,4,7⟩, ⟨4,4,4⟩, and ⟨4,4,8⟩, the algorithms discovered by AlphaEvolve use complex-valued multiplications which can be used for exact multiplication of complex or real-valued matrices.

| ⟨m,n,p⟩ | best known [reference] | AlphaEvolve |
|---|---|---|
| ⟨2,4,5⟩ | 33 [42] | 32 |
| ⟨2,4,7⟩ | 46 [93] | 45 |
| ⟨2,4,8⟩ | 52 [93] | 51 |
| ⟨2,5,6⟩ | 48 [93] | 47 |
| ⟨3,3,3⟩ | 23 [52] | 23 |
| ⟨3,4,6⟩ | 56 [48] | 54 |
| ⟨3,4,7⟩ | 66 [91] | 63 |
| ⟨3,4,8⟩ | 75 [91] | 74 |
| ⟨3,5,6⟩ | 70 [48] | 68 |
| ⟨3,5,7⟩ | 82 [91] | 80 |
| ⟨4,4,4⟩ | 49 [95] | 48 |
| ⟨4,4,5⟩ | 62 [47] | 61 |
| ⟨4,4,7⟩ | 87 [93] | 85 |
| ⟨4,4,8⟩ | 98 [95] | 96 |
| ⟨4,5,6⟩ | 93 [48] | 90 |
| ⟨5,5,5⟩ | 93 [72] | 93 |

(⚠ In Table 3, the reference for ⟨4,4,7⟩ is "[93, 95]" while Table 2 gives "[93]". Text layer verified for numbers; table glyph header read from text.)

**Table 3 (p. 34)** — Full version of Table 2, showing the best ranks obtained by AlphaEvolve for tensor decomposition for all considered parameters. Of the 54 targets, AlphaEvolve matches the state of the art in 38 cases, surpasses it in 14 cases (green), and falls behind in 2 cases (red). In all cases, AlphaEvolve provides exact algorithms, using integer or half-integer entries in the decomposition. For ⟨3,4,7⟩, ⟨4,4,4⟩, and ⟨4,4,8⟩ the algorithms use complex-valued multiplications.

| ⟨m,n,p⟩ | best known [ref] | AlphaEvolve | | ⟨m,n,p⟩ | best known [ref] | AlphaEvolve |
|---|---|---|---|---|---|---|
| ⟨2,2,2⟩ | 7 [95] | 7 | | ⟨3,3,3⟩ | 23 [52] | 23 |
| ⟨2,2,3⟩ | 11 [93] | 11 | | ⟨3,3,4⟩ | 29 [93] | 29 |
| ⟨2,2,4⟩ | 14 [93] | 14 | | ⟨3,3,5⟩ | 36 [93] | 36 |
| ⟨2,2,5⟩ | 18 [93] | 18 | | ⟨3,3,6⟩ | 40 [93] | 40 |
| ⟨2,2,6⟩ | 21 [93] | 21 | | ⟨3,3,7⟩ | 49 [93] | 49 |
| ⟨2,2,7⟩ | 25 [93] | 25 | | ⟨3,3,8⟩ | 55 [93] | 55 |
| ⟨2,2,8⟩ | 28 [93] | 28 | | ⟨3,4,4⟩ | 38 [93] | 38 |
| ⟨2,2,9⟩ | 32 [93] | 32 | | ⟨3,4,5⟩ | 47 [26] | 47 |
| ⟨2,2,10⟩ | 35 [93] | 35 | | ⟨3,4,6⟩ | 56 [48] | 54 |
| ⟨2,2,11⟩ | 39 [93] | 39 | | ⟨3,4,7⟩ | 66 [91] | 63 |
| ⟨2,2,12⟩ | 42 [93] | 42 | | ⟨3,4,8⟩ | 75 [91] | 74 |
| ⟨2,2,13⟩ | 46 [93] | 46 | | ⟨3,5,5⟩ | 58 [91] | 58 |
| ⟨2,2,14⟩ | 49 [93] | 49 | | ⟨3,5,6⟩ | 70 [48] | 68 |
| ⟨2,2,15⟩ | 53 [93] | 53 | | ⟨3,5,7⟩ | 82 [91] | 80 |
| ⟨2,2,16⟩ | 56 [93] | 56 | | ⟨4,4,4⟩ | 49 [95] | 48 |
| ⟨2,3,3⟩ | 15 [93] | 15 | | ⟨4,4,5⟩ | 62 [47] | 61 |
| ⟨2,3,4⟩ | 20 [93] | 20 | | ⟨4,4,6⟩ | 73 [48] | 73 |
| ⟨2,3,5⟩ | 25 [93] | 25 | | ⟨4,4,7⟩ | 87 [93, 95] | 85 |
| ⟨2,3,6⟩ | 30 [93] | 30 | | ⟨4,4,8⟩ | 98 [95] | 96 |
| ⟨2,3,7⟩ | 35 [93] | 35 | | ⟨4,4,9⟩ | 104 [92] | 108 (worse) |
| ⟨2,3,8⟩ | 40 [93] | 40 | | ⟨4,5,5⟩ | 76 [26] | 76 |
| ⟨2,3,9⟩ | 45 [93] | 45 | | ⟨4,5,6⟩ | 93 [48] | 90 |
| ⟨2,3,10⟩ | 50 [93] | 50 | | ⟨5,5,5⟩ | 93 [72] | 93 |
| ⟨2,4,4⟩ | 26 [93] | 26 | | ⟨6,6,6⟩ | 153 [72] | 156 (worse) |
| ⟨2,4,5⟩ | 33 [42] | 32 | | | | |
| ⟨2,4,6⟩ | 39 [93] | 39 | | | | |
| ⟨2,4,7⟩ | 46 [93] | 45 | | | | |
| ⟨2,4,8⟩ | 52 [93] | 51 | | | | |
| ⟨2,5,5⟩ | 40 [93] | 40 | | | | |
| ⟨2,5,6⟩ | 48 [93] | 47 | | | | |

(Table laid out in two column blocks for compactness: 27 + 27 = 54 rows; "(worse)" marks the two red rows ⟨4,4,9⟩ and ⟨6,6,6⟩, identified from the caption count 38 + 14 + 2 = 54 and the numbers, not from colour. The surpassed rows are exactly those of Table 2 except ⟨3,3,3⟩ and ⟨5,5,5⟩ (14 rows). Colours were not checked on the image.)

## Figures
- **Fig. 1 (p. 3)** — AlphaEvolve high-level overview. *What it shows:* human defines "What?" (evaluation criteria, initial solution, background); AlphaEvolve finds "How?" via prompt sampler, LLM ensemble, program database, evaluator pool.
- **Fig. 2 (p. 4)** — Expanded view of the AlphaEvolve discovery process. *What it shows:* prompt template and configuration, evaluation code, initial program, and the controller loop pseudo-code. Image: ../figures/Novikov25/p04.png
- **Fig. 3 (p. 6)** — Illustrative example of applying AlphaEvolve to evolving a supervised learning pipeline: (a) user file with evolve blocks and `evaluate`; (b) assembled prompt; (c) LLM-generated SEARCH/REPLACE diff (ResNet blocks, AdamW).
- **Fig. 4 (p. 11)** — Changes proposed by AlphaEvolve to discover faster matrix multiplication algorithms (optimizer/initialisation, loss, hyper-parameter sweep; 15 mutations); magnified in Figs 9a-9c (pp. 35-37).
- **Fig. 5 (p. 12)** — Examples of SOTA-breaking mathematical constructions (analysis / geometry / combinatorics panels with the old → new numbers above). Image: ../figures/Novikov25/p12.png
- **Fig. 6 (p. 14)** — Left: heuristic function discovered by AlphaEvolve for Borg scheduling; right: heat map of the scoring function over CPU/memory residuals.
- **Fig. 7 (p. 15)** — Visualization of the tiling heuristic problem for a matrix product C = AB (tile sizes M, N, K).
- **Fig. 8 (p. 18)** — Ablations on tensor decomposition (left) and kissing number (right): target metric vs fraction of compute budget; variants: full method, no meta prompt evolution, small base LLM only, no context in prompt, no full-file evolution, no evolution. Averaged over targets, shaded = intra-target s.d. over 3 seeds; ordering "full method best" qualitative.
- **Fig. 10 (p. 40)** — Construction found by AlphaEvolve for Erdős's minimum overlap problem. *What it shows:* a step function h on roughly [−0.2, 0.2] ⊂ domain, values in [0,1], irregular plateaus peaking near 1.0. Image: ../figures/Novikov25/p40.png
- **Fig. 11 (p. 41)** — Packing 11 unit hexagons into a regular hexagon of side 3.931 (left) and 12 into side 3.942 (right). *What it shows:* tilted, non-lattice arrangements of unit hexagons in the outer red hexagon. Image: ../figures/Novikov25/p41.png
- **Fig. 12 (p. 42)** — 16 points in 2D with max/min distance ratio ≈ √12.889266112; 14 points in 3D with ratio ≈ √4.165849767. *What it shows:* point sets with the max-distance pairs (red) and min-distance pairs (blue) joined. Image: ../figures/Novikov25/p42.png
- **Fig. 13 (p. 43)** — New Heilbronn constructions: 11 points in unit-area triangle (min area ≥ 0.0365); 13 points in convex region (≥ 0.0309); 14 points (≥ 0.0278). Image: ../figures/Novikov25/p43.png
- **Fig. 14 (p. 44)** — Circle packings: 26 circles in unit square (sum of radii ≥ 2.635); 32 circles (≥ 2.937); 21 circles in a perimeter-4 rectangle (≥ 2.365). Image: ../figures/Novikov25/p44.png

## Section summaries (parts not transcribed above)
- Sec. 1 (p. 1-3) Introduction: motivation, comparison with FunSearch (Table 1), summary of results (matrices, > 50 maths problems, four Google engineering problems).
- Sec. 2 (p. 3-8) Method (see Methods).
- Sec. 3.1 (p. 9-11) Matrix multiplication; Sec. 3.2 (p. 10-13) maths problems; Sec. 3.3 (p. 13-17) engineering applications (scheduling +0.7% fleet resources; kernel tiling 23%/1%; TPU Verilog; FlashAttention IR 32%/15%).
- Sec. 4 (p. 17-18) Ablations. Sec. 5 (p. 18-21) Related work (FunSearch, LLM-guided evolution, superoptimisation, AlphaTensor [26]). Sec. 6 (p. 21) Discussion. Acknowledgements, author contributions, references (pp. 21-33). App. A (pp. 34-37) full matrix-multiplication results; App. B (pp. 38-44) details of the maths discoveries.

## Stated limitations, open problems, future work
- p. 2: automated-evaluator requirement is a limitation: tasks needing manual experimentation are out of scope.
- p. 21: "The main limitation of AlphaEvolve is that it handles problems for which it is possible to devise an automated evaluator"; natural sciences with only some simulable experiments are harder; LLM evaluation of ideas "is not a setting we have optimized for"; next steps: distilling AlphaEvolve-augmented performance into base LLMs; feedback loops on the order of months for improving the next version.
- p. 13: "More examples and details on these problems and the methods used will be provided in an upcoming paper" (this is GGTW25).
- p. 34: scaling beyond ⟨5,5,5⟩ limited by GPU memory.

## References worth following
- [83] Romera-Paredes et al., FunSearch (Nature 2023/24), predecessor.
- [29] Friedman, Packing Center (the SOTA packing records used in B.7-B.13; reference as numbered [29] in the paper).
- [40] Haugland, minimum overlap problem step-function bound; [107] White, minimum overlap lower bound (convex programming).
- [39] Gyarmati, Hennecart, Ruzsa, Sums and differences of finite sets (lower bound for C6).
- [70] Matolcsi–Vinuesa, autocorrelation inequalities; [33] Gonçalves–Oliveira e Silva–Steinerberger, uncertainty principle; [18] Cohn et al., improved constant 0.3284.
- [31] Ganzhinov, kissing number in 11 dimensions (592); [26] Fawzi et al. AlphaTensor.
- (Reference numbers as printed; author/titles of [29], [31], [33], [39], [40], [70], [107] were not individually read from the reference list; check pp. 22-33 before citing.)

## Extraction notes
- Pages rendered: 4, 9, 12, 34, 38-44; read as images: 12, 38-42 (formulas, Fig. 5, Fig. 12). Table 2 numbers from text layer (consistent with Table 3); Table 3 transcribed from text layer, colours not verified on image.
- Methods/engineering sections were read fully in text; pp. 22-33 (acknowledgements and references) skimmed.
- ⚠ Minor numeric inconsistencies listed inline (0.380926 vs 0.380927; 2.6358 vs 2.635; "v1" vs "first version" note; ⟨4,4,7⟩ reference).
- Relevance to the project: no knots, lattices, stick numbers or ropelength. It documents a search paradigm (LLM-evolved heuristic search programs given a time budget, improving a best-known construction) and geometric packing/distance/Heilbronn/kissing benchmarks which are the same genre as searching for optimal conformations; no code or compute totals for those searches are given beyond the "e.g. 1000 seconds" per-heuristic budget.
