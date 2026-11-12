# Wagner21 — Constructions in combinatorics via neural networks
- **Authors:** Adam Zsolt Wagner (School of Mathematical Sciences, Tel Aviv University)
- **Venue / year / identifiers:** arXiv:2104.14516v1 [math.CO], 29 Apr 2021
- **File:** papers/5_ml_rl/Wagner_2021_Constructions_via_neural_networks_2104.14516.pdf   **Pages:** 23
- **Text layer:** ok (square roots, floor/ceiling brackets and fractions partly dropped by the text layer; checked on page images of pp. 8 and 12)

## Abstract
We demonstrate how by using a reinforcement learning algorithm, the deep cross-entropy method, one can find explicit constructions and counterexamples to several open conjectures in extremal combinatorics and graph theory. Amongst the conjectures we refute are a question of Brualdi and Cao about maximizing permanents of pattern avoiding matrices, and several problems related to the adjacency and distance eigenvalues of graphs.

## Notation and conventions
- (p. 3) Construction = word of fixed length from a finite alphabet (e.g. n(n−1)/2 bits for an n-vertex graph; Prüfer codes of length n−2 on alphabet of size n for trees; length-2^n 0-1 string for an antichain in {0,1}^n).
- (p. 3–5) "session" = one generated construction (game); reward given only at the end of a session; "top y percentile" kept for training; "top x percentage" of sessions survive to the next iteration (parameters x, y not given numerically in the paper).
- (p. 6–8) λ_1 = largest adjacency eigenvalue, μ = matching number; π = proximity = (1/(n−1))·min_v Σ_w d(v,w); ∂_1 ≥ … ≥ ∂_n distance eigenvalues; D = diameter.
- (p. 9–10) CP_D(T) characteristic polynomial of distance matrix with normalised coefficients d_k = 2^k |δ_k| / 2^{n−2}; CP_A(T) = Σ a_i x^{α_i}; p_A(T), p_D(T) = peak indices; m(T) = number of non-zero coefficients of CP_A, n(T) = number of terms in CP_D (= |V|+1). (p. 11 f(T) = p_A(T)/m(T) − 1 + … garbled: the reward is f(T) = p_A(T)/m(T) − (1 − p_D(T)/n(T)) as best read; with values p_D/n = 1/2, p_A/m = 1/7 for the 48-vertex tree.)
- (p. 12–13) transmission t(v_i); distance Laplacian D^L = T − D; transmission regular; DL-cospectral.
- (p. 14–16) 312 pattern, permanent per(A), f_312(n) = max permanent of an n×n 0-1 matrix avoiding 312; A∗B and A∘B direct sums with four zeros turned into ones (Fig. 12).
- (p. 17) ec(B) = exact cover number: minimum number of hyperplanes whose union meets {0,1}^n in precisely B.

## Numbered statements
**Conjecture 2.1 (p. 5; [4] Aouchiche–Hansen survey; disproved).** Let G be a connected graph on n ≥ 3 vertices, with largest eigenvalue λ_1 and matching number μ. Then λ_1 + μ ≥ √(n−1) + 1. Status: already disproved by Stevanović [44] (counterexample with n = 600). Here refuted with n = 19: tree with λ_1 = √10, μ = 2, λ_1 + μ ≈ 5.16 < 5.24 ≈ √18 + 1; appears true for n ≤ 18 (p. 6). (⚠ p. 6 text writes the threshold as "√19 − 1 + 1"; as printed the value ≈ 5.24 matches √18+1 = √(n−1)+1 for n=19.)

**Theorem 2.2 (p. 7; Graham–Pollack [26], quoted).** If T is a tree on n vertices with distance matrix D(T), then det(D(T)) = (−1)^{n−1}(n−1)2^{n−2}.

**Conjecture 2.3 (p. 8; Aouchiche–Hansen [6]; refuted here).** Let G be a connected graph on n ≥ 4 vertices with diameter D, proximity π and distance spectrum ∂_1 ≥ … ≥ ∂_n. Then π + ∂_{⌊2D/3⌋} > 0. (Context: Merris: ∂_{⌊D/2⌋} > −1 hence π + ∂_{⌊D/2⌋} > 0.) Refutation (p. 9): path on 13 vertices with n pendant vertices attached to a vertex adjacent to its midpoint; diameter 12; for n ≥ 190 the graph satisfies π + ∂_8 < 0 (checked by computer); "our graph on 203 vertices is in fact (close to being) the smallest counterexample" (p. 9, plausible; not proved). RL search with n = 30 found a graph with π + ∂_{⌊2D/3⌋} ≈ 0.4 (not itself a counterexample) after a few days (p. 8).

**Conjecture 2.4 (p. 10; Collins [18]; refuted in a strong sense).** The sequence of absolute values of the non-zero coefficients of CP_A(T) forms a unimodal sequence, and its peak is at the same place as the peak of the normalised coefficients of CP_D(T).

**Theorem 2.5 (p. 11) — proved here.** There exists an infinite sequence of trees (T_k)_{k∈N} satisfying lim n(T_k) = lim m(T_k) = ∞ such that f(T_k) ≥ 0.3 for all k ∈ N.
Proof idea: take T_{d²,d} (path on d vertices with (n−d)/d leaves attached to each vertex), d ≥ 31; by Prop. 2.6 p_A/m = 1/(d+1); by result of [1], p_D(T) ≤ (2/3)n(T)+…; hence f ≥ 1 − 1/(d+1) − 2/3 − 1/(d²+1) ≥ 0.3 for d ≥ 31 (p. 12).

**Proposition 2.6 (p. 11) — proved here.** If n ≥ d², then p_A(T_{n,d})/m(T_{n,d}) = 1/(d+1). Proof idea: coefficients of CP_A of a tree are counts of matchings (a_{n−k} = (−1)^{n+k/2} N_{k/2}(T) for even k, 0 for odd k); largest matching has size d so d+1 non-zero coefficients; bounds C(d,k)((n−d)/d)^k ≤ |a_{n−2k}| ≤ C(d,k)((n−d)/d + 2)^k show strictly decreasing sequence for n ≥ d² − d + 1.

**Conjecture 2.7 (p. 12; Shor [18]; open).** For any tree on n vertices, the peak p_D(T) satisfies ⌊n/2⌋ ≤ p_D(T) ≤ ⌈n(1 − 1/√5)⌉ (lower bound = star, upper = path).

**Question 2.8 (p. 14; Brualdi–Cao [15]).** Given an integer n and a permutation σ, what is f_σ(n) = max{per(A) : A ∈ M_n(σ)}? (M_n(σ) = n×n 0-1 matrices avoiding σ.) Brualdi–Cao's guess for σ = 312: the matrix pictured (n = 5, per 12) with per = Fibonacci F_{n+2} − 1 (p. 14–15). Refuted here: f_312(n) for n = 1..8 equals 1, 2, 4, 8, 16, 32, 64, 120 (computer-assisted optimality proof for n ≤ 8; believed optimal to n ≤ 10); best found constructions (Fig. 11): per(A_n) = 1, 2, 4, 8, 16, 32, 64, 120, 225, 424, 795, 1484, 2809 for n = 1..13 (n = 13 "likely not optimal", found under assumption of similarity).

**Proposition 2.9 (p. 16) — proved here.** 2^{0.89n} ≤ f_312(n) ≤ 24^{n/4} ≈ 2^{1.15n}. Proof idea: upper bound by Brègman–Minc with at most 4n−4 ones in a 312-avoiding matrix, row sums as equal as possible (4! = 24); lower bound: per(A∗B) ≥ per(A)per(B) so log_2 f_312 is superadditive, Fekete's lemma, g(13)/13 ≥ 0.88 from per(A_13) = 2809 > 2^{0.88·13}; improvement to 0.89 via per(A_13 ∘ A_11) = 5113196 > 2^{0.89·25}.

**Conjecture 3.1 (p. 17; Aaronson–Groenland–Grzesik–Kielak–Johnston [2]; refuted here).** For any B ⊂ {0,1}^k and n ≥ k: ec({0,1}^n ∖ (B × {0}^{n−k})) = n − k + ec({0,1}^k ∖ B). Counterexample (p. 18): n = 6, k = 4, B = {1000, 1111, 1001, 1011, 0110, 0001, 0010, 0111}; ec({0,1}^4∖B) ≥ 3 (cannot be covered with two hyperplanes, by case analysis) but {0,1}^6∖(B×{0}^2) is covered by four hyperplanes: −x2 + x5 + x6 = 1; x2 − x3 + x6 = 1; x1 + x2 − x4 + x5 + x6 = 2; 2x1 − x2 − 2x3 + 2x4 + x5 − x6 = 0. (Context: Alon–Füredi: ec({0,1}^n∖0) = n.)

**Problem 3.2 (p. 19; Király–Nagy–Pálvölgyi–Visontai [32]).** Is g(a,b) < 2·C(a+b,b)? (g = max size of weakly cross-intersecting (a,b)-set system.) Answered "no" in general: a (4,4)-set system of size 146 > 140 = 2·C(8,4), listed in the appendix (pp. 22–23).
**Problem 3.3 (p. 19; [32]).** Is g(a,a) = o(2^{2a})? (Tuza [47]: g(a,a) ≤ 2^{2a}.) Open.
**Problem 4.1 (p. 19).** Use a different reinforcement learning algorithm to find an explicit counterexample to an open conjecture in mathematics.

Quoted background: Bollobás: cross-intersecting (a,b)-set systems have size ≤ C(a+b,b); Frankl relaxation; [32]: g(a,b) ≥ (2 − o(1))C(a+b,b) as a+b → ∞.

## Key equations and quantitative claims outside numbered statements
- Algorithm 1 (p. 4) "The deep cross-entropy method": initialise a neural network; repeat: generate N sessions by sampling letters from the network's output distribution; score; sort; keep top y percentage; for remaining constructions train on (observation, action) pairs to minimise cross-entropy; keep top x percentage for next iteration. (N, x, y not given numerically in the paper.)
- Input representation (p. 5): for n-vertex graphs, two vectors of length n(n−1)/2: first has 1 at edges taken, 0 at rejected or not yet considered; second has a single 1 at the edge currently considered. Network (all binary-string applications): three hidden layers with 128, 64 and 4 neurons; learning rate chosen experimentally (value not given). Top few sessions may be allowed to survive indefinitely (sometimes better results); [46] recommends similar.
- λ_1 + μ experiment (p. 6): n = 19, reward λ_1 + μ (minimised); average reward of top 10% sessions per iteration; goes below threshold after ≈ 5000 iterations; "typically takes a few hours on an average PC" (Fig. 2). Network learns trees are best (deleting edges outside a maximum matching keeps μ and lowers λ_1), then decreases diameter, converging to a "balanced double star" (Fig. 3, 4: 19-vertex graph with λ_1 = √10, μ = 2).
- Proximity (p. 8–9): n = 30, reward π + ∂_{⌊2D/3⌋}, "after a few days"; top-10% graphs share structure: long path with star near middle whose neighbourhood is partitioned into disjoint cliques; best value ≈ 0.4; hand extrapolation to path on 13 vertices + 190+ pendant vertices gives counterexample (Fig. 6, "190 leaves").
- Trees (p. 10): trees as Prüfer codes of length n−2 over alphabet n; reward f(T) = p_A/m − (1 − p_D/n)-type; found tree on 48 vertices with p_D/n = 1/2 and p_A/m = 1/7 (Fig. 7), six high-degree vertices, every edge adjacent to one of them. T_{30,5}: p-fraction values 3125 and 3625 (5- vs 4-matchings); a different 30-vertex tree has 4705 5-matchings vs 4601 4-matchings and f = 1/3 > f(T_{30,5}) = 1/6 (Fig. 8). ⚠ p. 12 states f(T_{30,d}) comparisons "for any d".
- Transmission regularity (p. 13): graphs G (transmission regular) and H (not) with identical distance-Laplacian characteristic polynomial x^12 − 216x^11 + 21188x^10 − 1245904x^9 + 48797440x^8 − 1336652544x^7 + 26129121472x^6 − 364516883456x^5 + 3556516628224x^4 − 23113129559040x^3 + 90045806284800x^2 − 159318669312000x (12 vertices; Fig. 9). Found "more of a coincidence that some of the runs of the algorithm stumbled upon a construction"; "None of the reward functions we tried performed particularly well".
- Permanents (p. 15): network performed well alone for n ≲ 10; for larger n permanent computation (#P-complete, Valiant [48]) too expensive; n = 11, 12 improved by ad hoc methods; n = 13 under strong similarity assumption. A∗B and A∘B constructions preserve 312-avoidance; at n = 10 the best via these operations has permanent 394 (vs 424 found) (p. 16). Fekete limit lim g(n)/n exists = sup g(n)/n.
- LP counterexamples (Sec. 3, p. 17): solved with Gurobi [28] using methods of [52]; hyperplane-cover counterexample found by sampling B via ad hoc heuristics and solving IPs.
- (p. 19) Concluding: cross-entropy method "a very simple algorithm that has good convergence and works well in simple environments"; DQN-type methods train slowly in this sparse-reward setting (feedback only at end, about n²/2 steps per graph) (p. 2).

## Methods / algorithms
1. (p. 3–5) Encode construction as word; sample letters autoregressively from policy network conditioned on prefix (input as two binary vectors for graphs); play full session; black-box reward at the end.
2. (p. 4) Deep cross-entropy loop (Algorithm 1) with keep-top-y% for training and keep-top-x% (elite survival) across iterations.
3. (p. 5) Network: dense layers 128–64–4, final softmax over alphabet; Python code for §§2.2–2.3 at [51]. Compute: "a few hours on an average PC" (λ_1+μ), "a few days" (proximity). No GPU budget stated.
4. (p. 5–6) Verification: counterexamples checked by computing the invariant directly (eigenvalues, matchings, distance spectra, permanent by direct computation; Gurobi for LP certificates; computer-assisted proofs of optimality for n ≤ 8 in the permanent problem).
5. For LP-solvable problems, use LP/IP solvers instead (Sec. 3).

## Tables
None.

## Figures
- **Fig. 1 (p. 4)** — "We are generating a graph, and so far the network has included edges 1,2,3,6, and rejected edges 4,5 (dotted), corresponding to the sequence 111001. We input this into the neural network to get a probability distribution on whether to include or reject the next edge." (p(take) = 0.7, p(reject) = 0.3.) Image: ../figures/Wagner21/p04.png
- **Fig. 2 (p. 6)** — "The average value of λ_1 + µ of the best 10% of the sessions in each iteration decreases over time. After 5000 iterations it goes slightly below the conjectured threshold of √(19−1)+1, meaning we have found a counterexample to Conjecture 2.1." Image: ../figures/Wagner21/p06.png
- **Fig. 3 (p. 7)** — "The evolution of the best construction over time. The network quickly realizes that sparse graphs are best, and eventually the 'balanced double star' structure emerges." **Fig. 4 (p. 7)** — "A graph on 19 vertices satisfying λ_1 + µ < √(n−1) + 1." Image: ../figures/Wagner21/p07.png
- **Fig. 5 (p. 8)** — "The graph on 30 vertices with smallest value of π + ∂_{⌊2D/3⌋} found by the network." **Fig. 6 (p. 9)** — "A counterexample to Conjecture 2.3." (path on 13 vertices, 190 leaves.)
- **Fig. 7 (p. 10)** — "The tree T on 48 vertices found by the network, where the two peaks of the polynomials are furthest apart. It has p_A(T)/m(T) = 1/7 and p_D(T)/n(T) = 1/2." Image: ../figures/Wagner21/p10.png
- **Fig. 8 (p. 12)** — "The tree T on the left has f(T) = 1/3. For T_{30,5} on the right, we have f(T_{30,5}) = 1/6." **Fig. 9 (p. 13)** — graphs G (transmission regular) and H, DL-cospectral. **Fig. 10 (p. 14)** — "The pattern 312". **Fig. 11 (p. 15)** — "The best constructions we found for Question 2.8, with σ = 312. Dark squares denote ones and light squares denote zeros." (A_1…A_13 with permanents listed.) Image: ../figures/Wagner21/p15.png
- **Fig. 12 (p. 16)** — definition of A∗B and A∘B. **Fig. 13 (p. 18)** — "Covering {0,1}^6 ∖ (B × {0}^2) with four hyperplanes. The circles represent the points of {0,1}^6. Black disks are elements of B, otherwise the numbers in a circle represent which of the four hyperplanes contain that point."

## Stated limitations, open problems, future work
- "while we did not succeed in refuting any of the most famous conjectures in the field" (p. 1).
- Cross-entropy method not sophisticated; "other algorithms are much better suited" for the DL-cospectral problem (p. 13); Problem 4.1 asks for success with other RL algorithms (p. 19).
- Permanent problem: computational cost limits learning to n ≲ 10; optimal shape as n → ∞ and constant c in f_312(n) = c^{n(1+o(1))} unknown (p. 15–16).
- Open: Conjecture 2.7 (Shor), Problems 3.2 (general), 3.3; minimality of the 203-vertex counterexample unproved (p. 9); whether p_D(T_{n,d})/n(T_{n,d}) ≈ 1/2 "We do not know how to prove this" (p. 11).

## References worth following
- [35] Lapan, Deep Reinforcement Learning Hands-On (cross-entropy chapter 4); [46] cross-entropy implementation notes; [51] code repository.
- [15] Brualdi–Cao, Pattern-avoiding (0,1)-matrices, arXiv:2005.00379; [13] Brègman, permanents; [48] Valiant, #P-completeness of the permanent.
- [4]/[6] Aouchiche–Hansen (conjectures); [44] Stevanović; [18] Collins; [1] Aalipour et al. (unimodality of distance polynomial coefficients); [2] Aaronson et al. (hyperplane covers); [32] Király et al. (weakly cross-intersecting systems).
- Later work building on this paper: CEWW24 (PatternBoost, [49] there), GGTW25.

## Extraction notes
- All text pages 1–19 read; pp. 20–23 are references and the 146-set (4,4)-system listing (Appendix A, pp. 22–23) transcribed verbatim to `wiki/data/Wagner21_appendixA_146_set.txt` (2026-11-12; 146 pairs of disjoint 4-subsets of {1,…,11}, counts verified). Statements checked against page images for Conjecture 2.3 and Conjecture 2.7 (pp. 8, 12).
- Lattice relevance: none to knots or lattice polygons; relevance as an early RL (deep cross-entropy) search-for-constructions paper; search space = binary strings; reward black-box.
- ⚠ p. 6 threshold notation; ⚠ f(T) formula garbled in text layer.
