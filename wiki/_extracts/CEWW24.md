# CEWW24 — PatternBoost: Constructions in Mathematics with a Little Help from AI
- **Authors:** François Charton (FAIR, Meta; CERMICS Ecole des Ponts), Jordan Ellenberg (Univ. of Wisconsin–Madison), Adam Zsolt Wagner (Worcester Polytechnic Institute), Geordie Williamson (Sydney Mathematical Research Institute)
- **Venue / year / identifiers:** arXiv:2411.00566v1 [math.CO], 1 Nov 2024 (document dated November 4, 2024). Code: https://github.com/zawagner22/transformers_math_experiments
- **File:** papers/5_ml_rl/Charton-Ellenberg-Wagner-Williamson_2024_PatternBoost_2411.00566.pdf   **Pages:** 32
- **Text layer:** ok (figure labels garbled; Tables 2 and 3 verified on page images; Table 4 and 5 read from text layer)

## Abstract
We introduce PatternBoost, a flexible method for finding interesting constructions in mathematics. Our algorithm alternates between two phases. In the first "local" phase, a classical search algorithm is used to produce many desirable constructions. In the second "global" phase, a transformer neural network is trained on the best such constructions. Samples from the trained transformer are then used as seeds for the first phase, and the process is repeated. We give a detailed introduction to this technique, and discuss the results of its application to several problems in extremal combinatorics. The performance of PatternBoost varies across different problems, but there are many situations where its performance is quite impressive. Using our technique, we find the best known solutions to several long-standing problems, including the construction of a counterexample to a conjecture that had remained open for 30 years.

## Notation and conventions
- (p. 4) "score function": measure of how good a construction is (higher is better); "local search": algorithm taking a construction and returning one scoring at least as well. Example scores: score(G) = #edges(G) − 2·#triangles(G) (p. 4).
- (p. 4–7) PatternBoost loop: (1) starter database from local search from empty construction, keep best fraction (25% in the toy example); (2) tokenise and train transformer; (3) sample new constructions; (4) run local search from them; (5) iterate.
- "#Searches" in Table 3 = number of local searches in millions (p. 12). "Best" = best known value (OEIS A006855 for no-squares, n ≤ 40; ≥ lower bounds beyond).
- (p. 9) Local search for no-squares: delete edges greedily until no 4-cycles, then add random edges for as long as possible. Score = number of edges.
- (p. 12) Pattern 312 for binary matrices: three column indices c_1 < c_2 < c_3 and three row indices r_1 < r_2 < r_3 such that entries (r_1,c_3), (r_2,c_1), (r_3,c_2) are all ones.
- (p. 14) Spanning subgraph of the d-cube with diameter d; (p. 20) k-Sperner/saturated k-Sperner family; (p. 21) cross-Sperner tuples; π(n,k); (p. 22) double covers of discrete boxes.
- "[n]" = {0,…,n−1} (fn. 2, p. 19). Model: Makemore (Karpathy), decoder-only GPT-2-style transformer (p. 23–24).

## Numbered statements
**Question 3.1 (p. 12; Brualdi–Cao [14]).** How large can the permanent of a binary n×n matrix be, that does not contain the pattern 312? Known (p. 12): the maximum value lies between the exponentials 2^{0.89n} and (24^{1/4})^n (partial results in [49]).

**Question 3.2 (p. 14).** What is the maximum number of edges one can delete from the d-dimensional hypercube, without increasing its diameter? (Constructions from [22,26,11] give at least 2^d + C(d, ⌊d/2⌋) − 2 edges remaining; Graham [26] conjectured it optimal; best known lower bound of the form 2^d + c·2^d/√d [39] — text as read "2d + c · 2d/d" garbled; see ⚠ in notes.)

**Conjecture (Graham, p. 14, status: disproved here for d = 6).** The minimal number of edges of a spanning subgraph of the d-cube with diameter d is 2^d + C(d,⌊d/2⌋) − 2. PatternBoost found a spanning subgraph of the 6-cube with diameter 6 and 81 edges (vs. 2^6 + C(6,3) − 2 = 82), "disproves the above conjecture, and marks the first progress on this problem in 30 years" (p. 15). For d = 5 "it seems that the above construction is optimal" (p. 15). Edge list in Appendix F.

**Question 4.1 (p. 23; Leader–Milićević–Tan [34]).** Let A be a d-dimensional discrete box, and suppose B^(1),…,B^(m) are proper sub-boxes that cover every point in A exactly twice. Must we have m ≥ 2^d? (Context: Alon–Bohman–Holzman–Kleitman [4]: a d-dimensional discrete box cannot be partitioned into fewer than 2^d proper sub-boxes.)

**Theorem 4.2 (p. 23) — proved here (by computer-found construction, App. E for {0,1,2}^5 with 41 boxes).** Let d ≥ 5. There is a collection of (41/32)·2^d ≈ 1.28·2^d proper sub-boxes that cover every point of {0,1,2}^d exactly twice. (Pushing the constant below 1 would resolve Question 4.1.)

**Proposition A.1 (p. 28; Appendix A) — proved here.** There exists an absolute constant c > 0 such that f(n) ≥ c·n/√(log n), where f(n) := max{|S| : S ⊂ [n]², a,b,c ∈ S distinct ⟹ d(a,b) ≠ d(b,c)} (no isosceles triangles in the n×n grid). (⚠ the denominator "√log n" is read from the text layer; page image shows only the numerator "cn" in the crop viewed.)
Proof idea (as given): take a random subset with probability p per point; bound by union bound the probability that a point v ∈ S is the peak of an isosceles triangle by C p² n² log n; alter to remove such points.

Other claims (non-numbered):
- Saturated k-Sperner (p. 21): Gerbner et al. conjectured minimum size 2^{k−1}; Morrison–Noel–Scott [38] proved for k ≤ 5, disproved for larger k with ε ≈ 0.023 (saturated 6-Sperner system of size 30); Martin–Veldt [36] ε = 0.0385 (saturated 7-Sperner of size 56). With PatternBoost: saturated 8-Sperner system of size 108 (n = 12), improving the bound to ε = 0.04085 "with the same methods as in [38]" (Appendix C lists the sets).
- Cross-Sperner (p. 22, Table 4): improvements over Behague–Kuperus–Morrison–Wright [7] constructions for some small (n,k); "We did not manage to beat their conjectured upper bound for any values of the parameters."
- No-isosceles-triangles: f(n) values for n = 4..10 = 6, 7, 9, 10, 13, 16, 18; f(16) = 28, f(27) = 48, f(32) = 56 (SAT-solver optimal, up to n ≈ 32); looks linear, perhaps ≈ (16/9)n for larger n (p. 17). For n = 64, standard methods ≈ 3 months gave 108 points; PatternBoost loop trained on ≈ 10^6 maximal constructions (104–108 points) gave 110 within a few days; "never anything better – even though the graph … would suggest that 112 is also possible". n = 100: standard 154, PatternBoost 160; optimum likely ≈ 176. Upper bound f(n) ≤ e^{−c log^{1/9} n}·n² [10]; improving to n^{1.99} is open (p. 16).
- No 5 on a sphere (p. 17–20): choose points in n×n×n grid with no 5 on a sphere (planes count as degenerate spheres); known order of magnitude between about n^{1.5}?? (text garbled "n^{1/36}…"; ⚠ the exact known bounds from [45] are illegible in the text layer); for n = 4 there are over 700,000 cospheral 5-tuples out of 7.6 million; n = 5: 230 million 5-tuples; SAT/LP reach n ≈ 5. PatternBoost run up to n = 10 (Fig. 16, constructions in Appendix B). Tokenisation x_i = (a_0,a_1,a_2) ↦ a_0n²+a_1n+a_2; cospherality test via 5×5 determinant (1); GPU evaluation: generating 10K constructions for n = 4 takes 500 s on a single CPU thread vs 23 s on GPU; 48-fold data augmentation by the cube's symmetries (fn. 3: augmentation may overfit, not observed).
- Double covers (Table 5, p. 23): smallest m found: {0,1,2}²: 6; {0,1,2}³: 11; {0,1,2}⁴: 21; {0,1,2}⁵: 41; for {0,1,2}⁶ implies 2·41 = 82; neither Gurobi nor PatternBoost found fewer in reasonable time (these match LP solver Gurobi results).

## Key equations and quantitative claims outside numbered statements
Toy problem: triangle-free graphs on n = 20 vertices (pp. 3–8).
- Optimum 100 edges (Mantel/Turán, complete bipartite 10+10). Starter database: 40,000 greedy runs from empty graph; best 99 (two runs of 40,000 reach 99); distribution peaks at 66; keep top 25% as training set. Adjacency upper triangle flattened to 190 entries with comma delimiter after every row; BPE tokenization with 100 tokens reduces maximum word length to 72 (Table 1 shows examples of tokens: ID 1 "0", 2 "1", 3 "00", 4 "01", 5 "11", 6 "100", 7 "0100", …, 93 "0001101", 94 "11010000", 95 "0100100", 96 "00010000", 97 "11010", 98 "010001", 99 "101000").
- Transformer: Makemore, 2 layers, 4 heads, embedding dimension 16; trained 15,000 steps: train loss 2.07, test loss 2.09. Generated 100,000 graphs; only 37,000 had the correct number of entries (190) to be interpreted. Local search from those 37,000 gave score 99 a total of 47 times (vs 2 before) and the optimum 100 a total of 46 times (all distinct graph labellings). Peak of distribution shifted from 66 to 70 (Fig. 3).
- Iteration: take best 10,000 of previous generation, finetune (no restart); 5 more loops ⇒ essentially only complete bipartite graphs (Fig. 4), majority with equal parts.
- Ablation: global-only (no local search; keep best 1% and retrain) is "disastrously bad": best found after fifty loops has only 48 edges (p. 7); [49] (Wagner 2021) got better global-only results with a simpler/faster NN running thousands of loops.
No-squares (C_4-free) problem, n = 33 vertices (pp. 8–12).
- Baseline: 50 million local searches from the empty graph: min score 68, max 89, peak 81; 5 graphs with 89 edges, 204 with 88, 3425 with 87. Max possible for n = 33 is 96 [OEIS A006855].
- PatternBoost, 2 layers/4 heads/dim 16, 100 BPE tokens, 4 runs: each generation 500,000 candidates, valid ones locally improved and added to the 50k best solutions; after 50 million local searches (158 generations) best model found one graph with 91 edges (found after 20.5 million local searches), 21 with 89, 454 with 88, 6,957 with 87; distribution bimodal (low mode 81 = new generations, high mode 86 = accumulated good candidates). About one third of model predictions were invalid (wrong length).
- Larger model (256 dim, 6 layers, 8 heads): 91 edges after < 1 million local searches (vs 8.6 million for the small model). Improved tokenizer (delimiter after each row; BPE over {0,1,","}): invalid outputs only 5–10%; 40 models with 128 dim, 4 heads, 4 and 6 layers for n = 33: after 50 million local searches one found 93 edges, two found 92; a 96-edge graph (optimal) discovered after 116.5 million local searches (6 layers, dim 128, 4 heads).
- Learning curves of 20 models (6 layers, 128 dim, 4 heads; Fig. 7): two models learn significantly faster (≈ 50 generations to 10,000 graphs with > 88 edges vs 120–200 for others) and are first to find 92 edges and only ones to reach ≥ 93; suggests strategy "run a large number of models for a few hours and keep the fastest learners" (p. 11).
- Scaling (p. 11, Table 3): models with 128 dim, 4 or 6 layers, new tokenizer for n = 20..55: all n ≤ 30 optimal in < 80 million local searches; n = 33 optimum after 116.5 million.
312-avoiding permanent, n = 25 (pp. 11–14).
- Simple random greedy local search: 30,000 runs, highest permanent 641,000. PatternBoost best permanent 5,101,230; "human" handcrafted (two weeks) method 5,200,384 (Fig. 8: per(A_25) = 5101230 vs per(A′_25) = 5200384). Top 10 constructions of the two methods completely disjoint; human method found only 8 matrices better than PatternBoost's best. Adding the human method's 1000 best constructions to the training set produced 41 new constructions with permanents in the 5.1·10^6–5.2·10^6 range, none beating 5,200,384 (several ≈ 5.19·10^6).
Hypercube diameter (pp. 14–15): score = number of edges (minimise); local search adds random edges until spanning with diameter d then removes random edges while diameter stays d. Run for d = 5 and 6.
Transformer/ML settings (pp. 23–25).
- Makemore: decoder-only; token + learned positional embedding; layers = self-attention + MLP with hidden layer 4d and GeLU; 2–6 layers, d between 16 and 128, 4 attention heads; training: cross-entropy over next token, parameters updated every 32 examples with AdamW, learning rate 5·10^{-4}, weight decay 0.01; trained for fixed number of steps chosen to avoid overfitting (train loss ≈ test loss). Generation: sample token by token from empty sequence with the predicted distribution. Tokenization: fixed-length (k binary entries per token, e.g., 8 → 0–255) or BPE (iteratively merge most common subsequence; example S = {100001, 110001, 001001} → average length 6 → 3.33).
- No-5-on-sphere PatternBoost loop (p. 19): N configurations from scratch, keep top 10%; tokenize; train transformer; sample N; local search seeded in specified order then random additions; keep top 10%; repeat 10–50 times.

## Methods / algorithms
1. (p. 4–7) PatternBoost generic loop with two components: local search and score function; global step = transformer trained on best constructions and sampled to give seeds for local search; fine-tune across generations without restart.
2. (p. 5–6, 10, 24) Representation: flatten adjacency (upper triangle) with row delimiters; BPE tokenization (vocabulary 100 for the toy problem).
3. (p. 23–24) Architecture and optimiser as above; loss = cross-entropy next-token.
4. (p. 9–12) Scaling experiments; model size and tokenizer ablations; 40 models; best-of-N selection.
5. Evaluation = directly scoring generated constructions with the score function (mechanical verification, e.g. counting edges and checking no 4-cycles); hard constraint violations are repaired by local search. Compute: not given in GPU-hours; examples: 50–116.5 million local searches; no-isosceles n = 64: ≈ 3 months of problem-specific search for the 108-point baseline then "a few days" for the transformer loop.

## Tables
**Table 1 (p. 6).** "Examples of some of the tokens created by BPE" — token IDs 1–7: "0","1","00","01","11","100","0100"; token IDs 93–99: "0001101","11010000","0100100","00010000","11010","010001","101000". (Transcribed from text layer: strings for IDs 1–7 listed as "0" "1" "00" "01" "11" "100" "0100"; IDs 93–99 "0001101" "11010000" "0100100" "00010000" "11010" "010001" "101000". ⚠ the text states "string '10' received the name 'token 14'" and "token 59 corresponded to '0010000'" — not in the table.)

| token ID | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|
| string | "0" | "1" | "00" | "01" | "11" | "100" | "0100" |

| token ID | 93 | 94 | 95 | 96 | 97 | 98 | 99 |
|---|---|---|---|---|---|---|---|
| string | "0001101" | "11010000" | "0100100" | "00010000" | "11010" | "010001" | "101000" |

**Table 2 (p. 10).** "No-squares problem, n = 33. Distribution of the number of edges of candidate solutions, after 50 million local searches." (verified on image)

| Edges | Local search | PatternBoost 2 layers 16 dimensions | PatternBoost 4 layers 128 dimensions, improved tokenizer |
|---|---|---|---|
| 91 | 0 | 1 | 15 |
| 90 | 0 | 0 | 206 |
| 89 | 5 | 21 | 2,529 |
| 88 | 204 | 454 | 26,842 |
| 87 | 3,425 | 6,957 | 175,089 |

**Table 3 (p. 12).** "No-squares problem. Best solutions found by PatternBoost, and number of local searches (millions). Best of 6 models for n < 39 (80 for n = 33), of 12 models for n ≥ 39." (verified on image; "Best" = best known; bold in the image on "Best found" for n = 20–30 and 33 where it equals the optimum.)

| n | Best | Best found | #Searches (M) |
|---|---|---|---|
| 20 | 46 | 46 | 0.4 |
| 21 | 50 | 50 | 0.8 |
| 22 | 52 | 52 | 0.4 |
| 23 | 56 | 56 | 2.3 |
| 24 | 59 | 59 | 1.8 |
| 25 | 63 | 63 | 3.1 |
| 26 | 67 | 67 | 8.4 |
| 27 | 71 | 71 | 21.0 |
| 28 | 76 | 76 | 23.8 |
| 29 | 80 | 80 | 41.7 |
| 30 | 85 | 85 | 78.3 |
| 31 | 90 | 87 | 126.3 |
| 32 | 92 | 91 | 104.9 |
| 33 | 96 | 96 | 116.5 |
| 34 | 102 | 95 | 39.9 |
| 35 | 106 | 100 | 121.3 |
| 36 | 110 | 102 | 38.4 |
| 37 | 113 | 106 | 29.8 |
| 38 | 117 | 110 | 77.1 |
| 39 | 122 | 113 | 11.7 |
| 40 | 127 | 117 | 11.2 |
| 41 | ≥132 | 102 | 8.6 |
| 42 | ≥137 | 124 | 6.8 |
| 43 | ≥142 | 128 | 15.6 |
| 44 | ≥148 | 132 | 12.1 |
| 45 | ≥154 | 136 | 11.1 |
| 46 | ≥157 | 140 | 10.4 |
| 47 | ≥163 | 144 | 12.1 |
| 48 | ≥168 | 147 | 1.9 |
| 49 | ≥174 | 152 | 12.2 |
| 50 | ? | 156 | 15.2 |
| 51 | ? | 161 | 14.7 |
| 52 | ? | 165 | 14.1 |
| 53 | ? | 169 | 5.2 |
| 54 | ? | 173 | 9.0 |
| 55 | ? | 177 | 8.2 |

(⚠ n = 41: "Best found" 102 is lower than n = 40's 117 and n = 36–37's; as printed. ⚠ The Table 3 caption says best of 6 models for n < 39 "(80 for n = 33)" while the text of Sec. 3.1.2 says 40 models for n = 33.)

**Table 4 (p. 22).** "Comparison of constructions and conjectured upper bounds for various (n,k) values. The bold values denote an improvement over the previous best known constructions." (text layer; bold not visible in text — improvements inferred by comparing rows)

| (n,k) | (6,3) | (7,3) | (8,3) | (9,3) | (5,4) | (6,4) | (7,4) | (8,4) |
|---|---|---|---|---|---|---|---|---|
| BKMW construction | 810 | 6075 | 50625 | 421875 | 108 | 729 | 19683 | 531441 |
| BKMW conjectured upper bound | 852 | 6818 | 54551 | 436413 | 129 | 2075 | 33215 | 531441 |
| Our construction | 810 | 6480 | 51840 | 414720 | 108 | 1764 | 28350 | 531441 |

(⚠ For (9,3) "Our construction" 414720 is below the BKMW construction 421875, so it is not an improvement there; improvements by value comparison: (7,3), (8,3), (6,4), (7,4). Appendix D gives constructions for (7,3) with value 6480 and (8,3) 51840 and (6,4) 1764, (7,4) 28350.)

**Table 5 (p. 23).** "The smallest number m of proper sub-boxes we could find to cover every point of the box A = {0,1,2}^d exactly twice."

| A | m |
|---|---|
| {0,1,2}² | 6 |
| {0,1,2}³ | 11 |
| {0,1,2}⁴ | 21 |
| {0,1,2}⁵ | 41 |

## Figures
- **Fig. 1 (p. 5)** — "Left: score distribution of all the examples we generated by greedily adding edges for as long as possible. Right: the score distribution of the best 25% of the examples from the left, which we will use as a training set." *What it shows:* histograms of number of edges (peak ≈ 66, maximum 99). Image: ../figures/CEWW24/p05.png
- **Fig. 2 (p. 5)** — "Flattening the adjacency matrix" (010 / 01 / 0 → 010,01,0).
- **Fig. 3 (p. 7)** — "The score distribution in the second generation. The peak has shifted from 66 to 70." **Fig. 4 (p. 8)** — "The evolution of scores across the next 5 generations. By the end, the model has learned to generate many different complete bipartite graphs."
- **Fig. 5 (p. 9)** — "The results of adding random edges to empty graph for as long as possible, without creating any 4-cycles, 50M times in total." **Fig. 6 (p. 9)** — "Results with PatternBoost, 50M local searches in total." (score histograms 75–91; bimodal for PatternBoost.) Image: ../figures/CEWW24/p09.png
- **Fig. 7 (p. 11)** — "Evolution of scores over generations, for 20 different models. All models have 6 layers, and 128 dimensions, and only differ by their initialization. Left: average score of the 10,000 best solutions found so far. Right: best solution found so far." Image: ../figures/CEWW24/p11.png
- **Fig. 8 (p. 13)** — "The best construction found by general method PatternBoost (left) versus the best construction found by the best problem-specific standard algorithm we could create (right)." (permanent matrices; per = 5101230 vs 5200384.) Image: ../figures/CEWW24/p13.png
- **Fig. 9 (p. 14)** — "A subgraph of the 5-cube with diameter 5, with 2^4 + C(5,2) − 2 = 40 edges." **Fig. 10 (p. 15)** — "A spanning subgraph of the 6-cube with diameter 6 and 81 edges, which is a counterexample to the above conjecture. Note the presence of several blocking vertices from which one can only go up or one can only go down." Image: ../figures/CEWW24/p15.png
- **Figs. 11–13 (pp. 16–17)** — best no-isosceles constructions for n = 4–10 (f = 6, 7, 9, 10, 13, 16, 18), n = 16, 27, 32 (28, 48, 56), and plot of f(n) up to 32 (looks linear). **Fig. 14 (p. 18)** — "Left: a 108 point construction in [64]² … Right: a 110 point construction found by adding only one transformer loop." **Fig. 15 (p. 18)** — "Left: a 154 point construction in [100]² found by standard methods. Right: a 160 point construction found by PatternBoost." Image: ../figures/CEWW24/p18.png
- **Fig. 16 (p. 20)** — "Best constructions for 'no 5 on a sphere' for n = 2, 3, …, 10, found by PatternBoost." *What it shows:* points in best construction (axis from 4 up to 26) vs grid size n = 2..10. Image: ../figures/CEWW24/p20.png
- **Fig. 17 (p. 20)** — "A saturated 4-Sperner family of size 8. The addition of any set creates a chain of length 5." **Fig. 18 (p. 21)** — "A saturated 8-Sperner family of size 108, with n = 12." **Fig. 19 (p. 22)** — "A cross-Sperner family for the parameters (n,k) = (4,2). |F_1|·|F_2| = 4·4 = 16, which is optimal. So π(4,2) = 16."

## Stated limitations, open problems, future work
- "In practice however, one should always tailor the local search algorithm to the specific problem" (p. 25); "PatternBoost clearly works better for some problems than for others" (p. 8); the no-squares problem is "notoriously difficult for machine learning methods" (p. 8); "the problems discussed here are just the first few we tried".
- Global-only (no local search) performs poorly (p. 7).
- "A larger transformer is needed to understand deeper structures, and a larger training set is then necessary" (p. 7).
- In other domains evaluation may be harder; the method requires fast, reliable mechanical evaluation (p. 2).
- Unanswered: whether lower or upper bound is closer to truth for hypercube problem (p. 15); open Questions 3.1, 4.1; constant 1.28 in Thm 4.2 should be reduced (p. 23); likely better local search for the Sperner problems (p. 21).
- No-isosceles: even f(n) ≤ n^{1.99} is open (p. 16).

## References worth following
- [49] A. Z. Wagner, Constructions in combinatorics via neural networks, arXiv:2104.14516 (= Wagner21 in this wiki).
- [31] A. Karpathy, Makemore; [42] Radford et al., GPT-2; [48] Vaswani et al., Attention is all you need (2017).
- [43] Romera-Paredes et al., Mathematical discoveries from program search with large language models (FunSearch), Nature 625 (2024).
- [19] Davies et al., Advancing mathematics by guiding human intuition with AI, Nature 600 (2021) (knot theory application, cf. DJLT21).
- [38] Morrison–Noel–Scott; [36] Martin–Veldt (saturated Sperner); [7] Behague–Kuperus–Morrison–Wright (cross-Sperner); [14] Brualdi–Cao; [4] Alon–Bohman–Holzman–Kleitman; [41] OEIS A006855.

## Extraction notes
- Pages 1–28 read in full; appendices B–F (pp. 29–32: explicit constructions for no-5-on-sphere n = 2..10, saturated 8-Sperner system of 108 sets, cross-Sperner families, 41-box double cover, 81-edge 6-cube subgraph) not transcribed (pure data lists, many hundreds of numbers).
- Tables 2 and 3 verified cell by cell against page images. Table 4 and 5 and Table 1 from text layer only.
- Lattice relevance: no direct knot/lattice-knot content. Relevant as a method template for search over discrete configurations (local search seeded by transformer samples; 48-fold cube-symmetry augmentation for points in the [n]^3 integer grid; "no 5 on a sphere" grid-point sets).
- ⚠ Known bounds for "no 5 on a sphere" (from [45]) and for the hypercube lower bound are garbled in the text layer; not recorded.
