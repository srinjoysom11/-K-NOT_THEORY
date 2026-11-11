# GHRS20 — Learning to Unknot
- **Authors:** Sergei Gukov (Caltech), James Halverson (Northeastern; NSF AI Institute IAIFI), Fabian Ruehle (CERN; Oxford), Piotr Sułkowski (Caltech; Univ. of Warsaw)
- **Venue / year / identifiers:** arXiv:2010.16263v1 [math.GT], 28 Oct 2020; CALT-2020-046, CERN-TH-2020-179
- **File:** papers/5_ml_rl/Gukov-Halverson-Ruehle-Sulkowski_2020_Learning_to_unknot_2010.16263.pdf   **Pages:** 52
- **Text layer:** ok (plot data are not in the text layer; Table 1 verified on page image; Figures' numeric values only from body text)

## Abstract
We introduce natural language processing into the study of knot theory, as made natural by the braid word representation of knots. We study the UNKNOT problem of determining whether or not a given knot is the unknot. After describing an algorithm to randomly generate N-crossing braids and their knot closures and discussing the induced prior on the distribution of knots, we apply binary classification to the UNKNOT decision problem. We find that the Reformer and shared-QK Transformer network architectures outperform fully-connected networks, though all perform well. Perhaps surprisingly, we find that accuracy increases with the length of the braid word, and that the networks learn a direct correlation between the confidence of their predictions and the degree of the Jones polynomial. Finally, we utilize reinforcement learning (RL) to find sequences of Markov moves and braid relations that simplify knots and can identify unknots by explicitly giving the sequence of unknotting actions. Trust region policy optimization (TRPO) performs consistently well for a wide range of crossing numbers and thoroughly outperformed other RL algorithms and random walkers. Studying these actions, we find that braid relations are more useful in simplifying to the unknot than one of the Markov moves.

## Notation and conventions
- (p. 13) Braid generator σ_i^{±1} is written ±i; a braid word is a string of integers in [−(n−1), n−1]. Braid group Br_n has relations (11a) σ_iσ_{i+1}σ_i = σ_{i+1}σ_iσ_{i+1} ("braid relation 1") and (11b) σ_iσ_j = σ_jσ_i for |i−j| ≥ 2 ("braid relation 2") (p. 10).
- N, N_max, n_letters (pp. 16–17, 27): the length of the braid word (number of letters/generators = "crossings" of the braid diagram), values {12, 24, 36, 48, 72, 96}. Paper says "Letting N be the number of letters in the braidword" (p. 37). Note: braid length N is not the minimal crossing number of the closure.
- Markov moves (pp. 11–12): conjugation w → w' w'^{-1}-type cyclic move (σ_i^{-1}wσ_i), stabilization w → wσ_n / destabilization wσ_n → w (changing Br_{n-1} ↔ Br_n).
- Reidemeister move correspondence (p. 13): R1 ↔ Markov stabilization; R2 ↔ insertion of σ_iσ_i^{-1}; R3 ↔ braid relation 1 (11a).
- Class labels (p. 18): non-trivial knots = class 0, unknots = class 1; decision threshold 0.5.
- "Accuracy" in RL (p. 33): "the fraction of unknots for which the RL agents found a series of moves that reduced the input braid word to the empty braid word."
- RL state space (p. 26): braid words of length up to 2N_max; terminal state = empty word in Br_1.
- Dowker–Thistlethwaite notation defined p. 9; Jones polynomial computed with SageMath (p. 24).

## Numbered statements
None (no theorems). Equations: (11a,b) braid relations, (13) stabilization, (15) unknot recognition ∈ NP ∩ coNP (quoted: Hass–Lagarias–Pippenger NP; Kuperberg under GRH and [33] unconditional coNP), (18) number of states, (22) and (24) action counts.
Context claims quoted from literature (pp. 14–16): unknot recognition ∈ NP [31]; ∈ coNP [32,33]; imposing an upper bound on number of Reidemeister moves makes it NP-hard [36]; Jones polynomial computation #P-hard [40]; braid word problem in P (Garside–Thurston, BKL) [35]; 4-ball genus bound |s(K)|/2 ≤ g_4(K) (14).

## Key equations and quantitative claims outside numbered statements
- (18, p. 26) N_states ≤ 1 + Σ_{n=1}^{2N_max} (2n)^n possible braid states.
- (22, p. 30) Naive action count N_actions = 2N_max² + 2N_max + 4 ("several thousands"); (24, p. 32) reduced N_actions = 5 + N_max.
- (p. 15) Knot counts quoted: 165 prime knots with 10 crossings, 1,388,705 prime knots with 16 crossings.
- (p. 16) Generated databases: "over 10^4 non-trivial knots and unknots of various length, with n_letters ∈ {12, 24, 36, 48, 72, 96}" (16). Checks: for RandomUnknot checks Arf invariant, Alexander polynomial and alternating property against unknot values (0, 1, False); for RandomKnot at least one invariant must differ from unknot values; probability of accidental unknot "exponentially suppressed in n_letters" (heuristic).
- (p. 17) Knots with ≤ 9 crossings are uniquely identified by Jones polynomial ⇒ N = 9 braids identifiable; 6455 N = 9 braids drawn, 4664 of which are prime (Fig. 8 caption); induced distribution on crossing number much flatter than uniform on knots ≤ 9 crossings (which grows exponentially) (Fig. 7).
- (p. 18) Classification training: 10,000 braids drawn from the prior for N ∈ {12, 24, 36, 48}; binary cross-entropy loss; decision threshold 0.5.
- (p. 19–20) Full attention (shared-QK) vs Reformer: "performance difference … is negligible"; non-causal marginally better than causal; "a single hash performs slightly worse than four hashes, but four hashes already performs similarly to full attention" (Fig. 9a); Reformers and shared-QK Transformers outperform feedforward network "by a few percent" (Fig. 9b); gap largest for small N, "almost negligible at large N"; "performance increases with N" (Fig. 9c, 10). Exact accuracy values are only in plots; text says accuracy above 90% easy in all cases and mid- to high-90s for NLP architectures (p. 37).
- (p. 21) Fixed-total-letters experiment: 10,000 braids at N = 12 but 2,500 at N = 48 (same number of total letters); performance still increases with N but "much less drastic" (Fig. 9d).
- (p. 22) Confidence study: N = 12, Reformer with parameters of Table 2, test set of 1000 non-trivial knots and 1000 unknots; precision > 95%; "Over 900 of the non-trivial knots (unknots) have outputs within 10^{-3} of their target value 0 (1)"; with 10 random initialisations, 22 of 1000 test knots have output > 0.95 in all 10 runs and 22 of 1000 unknots have output < 0.05 in all 10 runs; no knots/unknots for which all 10 networks are uncertain (0.3 < output < 0.7).
- (p. 23) Hard knots (N = 9): five Reformers (4 hashes, embedding 250, depth 10) on 5000 N = 9 braids, 80/20 split, 50 epochs, best model kept; accuracy ≈ 93% on test set for all five; of 1000 non-trivial test braids, 30 had outputs above 0.9 in all five runs. Hard knots (17): (3_1,19,242), (4_1,3,37), (6_2,1,34), (6_3,1,30), (8_13,1,5), (8_20,4,19) = (Rolfsen number, #hard instances, #total instances in test set; mirrors included). No hard 9-crossing knots; "∼ 2/3 of the hard knots are trefoils, despite … only ∼ 1/3 of the knots in the test set" (⚠ 19 of 30 = 63% trefoils; 242 of ≈ 1000 ... as printed the total trefoil instances are 242 ≈ 24%, not 1/3; as printed). Conjecture: knots with fewer crossings likelier hard.
- (p. 23–24) Jones-polynomial correlation (N = 12, SageMath): mean network output confidence correlates with maximum absolute Jones-degree (Fig. 11); "this correlation was learned by the network and not put in by hand."
- (p. 24–25) Dowker–Thistlethwaite experiment: Reformer (acausal, bucket size 8, 4 hashes, depth 10, 5 heads, embedding 250) trained on DT representations of length 15 drawn from the braid prior; test set 1000 non-trivial knots and unknots: accuracy 90% on knots and 87.7% on unknots; feedforward slightly worse; ≈ 5% lower than braid representations ("braids may be a better representation"). On the 176 known "hard" 15-crossing unknots in DT notation [42,43] (require increasing crossing number before simplification): Reformer accuracy 2.2%, output mean 0.03, std 0.14; adding some hard unknots to training does not help others.
- (p. 26–28) RL reward: negative current braid-word length each step; illegal actions punished with −4N_max; reward based on Dehornoy reduced word was tried and performed worse; "Essentially none of the braids representing the [unknots] have an empty reduced form."
- (p. 32–34) RL algorithms tried: A3C/A2C (FFNN, Reformer), DQN (with/without dueling; FFNN, LSTM), PPO (FFNN), TRPO with GAE (FFNN, Reformer). Result: PPO and DQN worse (DQN oscillatory), A3C ≈ A2C better, "By far the best algorithm was TRPO"; Reformer slightly better with TRPO but trains much slower, so FFNN with ChainerRL TRPO using hyper-parameters of [52] (standard ChainerRL, not tuned). Training: 5 × 10^6 steps on a standard GPU, "around 24 hours."
- (p. 33) Evaluation: agents receive unknots of N_max ∈ {12, 24, 36, 48, 72, 96}; input size 2N_max, zero-padded (0 is not a valid generator); same 10,000 unknots for all algorithms; upper bound of 500 actions; random walker (RW) draws actions uniformly.
- (p. 34, Fig. 12) TRPO: ≈ 85% of unknot braids fully reduced "for all unknots, more or less irrespective of their length"; A3C comparable up to N_max = 48 (around 70%) but drops to 34% at N_max = 72 and 96; RW falls from ≈ 64% at N_max = 12 to ≈ 10% at N_max = 96. (⚠ the A3C drop is described "from around 70% to 34%"; plot values not tabulated.) Average steps: TRPO ≈ 50 at N_max = 12 and nearly constant over N_max; RW needs twice as many at N_max = 12 and 1.3–1.8× A3C for larger N_max; at N_max = 96 about 8,800 unknots solved for TRPO, 3,400 for A3C, 1,000 for RW (averages only over solved cases). Conclusion text (p. 39): "over 80 percent of the cases even for knots with up to 96 crossings … beats A3C by more than a factor of 2, and a brute-force … by a factor of almost 8."
- (p. 35–36, Fig. 13) Action statistics for N = 96 (trained vs untrained): untrained agent picks each action equally; trained agent: SmartCollapse and shift left most frequent; shift right negligible (≈ 0.002); Markov-1 ≈ 0.004; braid relation 1 used ≈ 10 percentage points more often than braid relation 2; "braid relations seem far more important than Markov move 1" (Fig. 13 bar labels read: 0.351, 0.245, 0.240, 0.171, 0.168, 0.179, 0.158, 0.163, 0.157, 0.162, 0.002, 0.004; assignment of values to bars not recoverable from text layer).
- (p. 26) Terminal state only the empty word in Br_1; destabilization keeps single-component property.

## Methods / algorithms
Data generation (Sec. 3, pp. 15–17, App. A pp. 39–43).
1. Subroutines: RandomMarkovMove (Alg. 1: with prob ½ conjugate by random generator pair at the ends, else append max-strand generator ±(max|B|)); BraidRelation1 (Alg. 2: swaps ±k,±(k+1),±k ↔ ±(k+1),±k,±(k+1)); SmartCollapse (Alg. 3: iterate RemoveConsecutiveInverses, RemoveFreeStrands, Destabilize, RemoveNonconsecutiveInverses until stable); Knotify (Alg. 4: weave together strands of different components until closure is a knot).
2. RandomUnknot (Alg. 5): start from empty braid, apply RandomMarkovMove and BraidRelation (M times, start position uniform) then SmartCollapse until braid has length n_letters. RandomKnot (Alg. 6): draw n_letters generators uniformly from n_strands generators with random sign, Knotify, then M random Markov moves + braid relations + SmartCollapse. Parameter M and n_strands not specified in text. (⚠ Alg. 5 listing says BraidRelation2 while text says BraidRelation1; Algorithms 5–6 pseudo-code text garbled.)
3. Checks that braids are (non-)trivial via Arf invariant, Alexander polynomial, alternating test (p. 16).

Classification (Sec. 4, pp. 17–25).
4. Input: braid word as integer sequence (±i), embedding layer + positional embedding (axial positional encoding) (p. 19). Model: ReformerLM (reformer-pytorch [39]) → fully connected → Sigmoid; BCE loss; threshold 0.5. Compared with shared-QK Transformer (full attention) and FFNN with dense layers.
5. Hyper-parameters, Table 1 (p. 19; verified on image): Reformer: full attention {True, False}; n_hashes {1,4}; bucket size {2, N/2}; causal {True, False}; width fixed by other hyper-parameters; depth 10; embedding dim 250; epochs 50; RMSProp; learning rate 0.0001. FFNN: causal False (dense layers); width 850; depth 10; embedding dim 250; epochs 50; RMSProp; learning rate 0.01. Table 2 (p. 22; for confidence study): n_hashes 4; causal False; bucket size 6; depth 10; embedding 250; epochs 250; RMSProp; lr 0.0001. (Table 2 values as read from text layer, not checked on image.)
6. 10,000 braids for each N ∈ {12,24,36,48} for each run (train/test split not stated except 80/20 for the N = 9 experiment).

RL unknotting (Sec. 5, pp. 26–36).
7. Environment: state = braid word of length ≤ 2N_max (zero-padded), start = braid of unknot with N_max letters; reward = −(current braid length) per step, −4N_max for illegal actions; return maximised (long-term) since some unknots must first be lengthened (example w = [−1,2,1,−2] requires insertion of inverses, braid relation, removals, conjugation, two destabilizations: (21)).
8. Actions (N_actions = 5 + N_max, Eq. 24): SmartCollapse; shift left; shift right (cyclic shifts = conjugation); braid relation 1 at the first possible position then shift right; braid relation 2 at first possible position then shift right; N_max actions "conjugation by generator i_m ∈ [−n,n] without removing inverses" (inserting σ_iσ_i^{-1} at ends). No stabilization action (performance slightly went down when added). Max intermediate length 2N_max.
9. Algorithms/hyperparameters: TRPO with GAE, FFNN, ChainerRL implementation, hyper-parameters of [52]; trained 5 × 10^6 steps ≈ 24 h on a standard GPU. Policy update: second-order (conjugate gradient + line search) within trust region on KL-divergence surrogate; value function via SGD.
10. Evaluation on 10,000 unknots per N_max; verification step: an unknot is certified when the agent reaches the empty braid word (the explicit move sequence proves unknottedness). "For non-trivial knots, we do not know what the simplest braid word is … hence we cannot judge how well the algorithm performs" (p. 33); RL never evaluated on non-trivial knots.

## Tables
**Table 1 (p. 19)** — "Parameter values for reformer and feedforward runs. Depth is the number of attention modules in the reformer, which themselves consist of multiple layers. Full attention means that a shared-QK transformer is used, rather than a reformer, i.e., full shared-QK attention is used rather than LSH attention. n_hashes and bucket size are only meaningful when not using full attention." (verified on page image)

| Parameters | Reformer value | Feedforward NN value |
|---|---|---|
| Full Attention | {True, False} | N/A |
| n_hashes | {1, 4} | N/A |
| Bucket Size | {2, N/2} | N/A |
| Causal | {True, False} | False (dense layers) |
| Width | fixed by other hyperparameters | 850 |
| Depth | 10 | 10 |
| Embedding Dimension | 250 | 250 |
| Epochs | 50 | 50 |
| Optimizer | RMSProp | RMSProp |
| Learning Rate | .0001 | 0.01 |

**Table 2 (p. 22)** — "Parameters for the Reformer used to study network confidence." (text layer only)

| Parameter | Value |
|---|---|
| n_hashes | 4 |
| Causal | False |
| Bucket Size | 6 |
| Depth | 10 |
| Embedding Dimension | 250 |
| Epochs | 250 |
| Optimizer | RMSProp |
| Learning Rate | .0001 |

(⚠ Table 2 column order of the text layer is "nhashes, Causal, Bucket Size, Depth, Embedding Dimension, Epochs, Optimizer, Learning Rate" with values "4, False, 6, 10, 250, 250, RMSProp, .0001"; assignment inferred from row order, not verified on image.)

## Figures
- **Fig. 1 (p. 8)** — "Examples of knots. From left to right: unknot (0_1), trefoil (3_1), figure-eight (4_1), 5_1, and 5_2." **Fig. 2 (p. 8)** — "Reidemeister moves" (Type I twist, II poke, III slide). Image: ../figures/GHRS20/p08.png
- **Fig. 3 (p. 10)** — "Obtaining new knots as the sum of prime knots. This knot is the sum of the knot 5_2 (left) and the trefoil 3_1 (right)." **Fig. 4 (p. 11)** — "A braid σ_1σ_2^{-1}σ_1σ_2^{-1} (left) and its closure (right)." **Fig. 5 (p. 11)** — "Braid relations" (a) σ_1σ_2σ_1 = σ_2σ_1σ_2, (b) σ_1σ_3σ_2 = σ_3σ_1σ_2 (⚠ as printed caption (b) differs from (11b) which is σ_iσ_j = σ_jσ_i for |i−j|≥2). **Fig. 6 (p. 12)** — "Markov moves" (a) conjugation σ_1σ_2^{-1}σ_1σ_2^{-1} ↔ σ_2^{-1}σ_1σ_2^{-1}σ_1, (b) stabilization σ_1σ_2σ_1 ↔ σ_1σ_2σ_1σ_3.
- **Fig. 7 (p. 18)** — "Distribution on the number of crossings induced by our prior, and also by a uniform distribution on all knots of 9 or fewer crossings." *What it shows:* log10(probability) vs crossings 3–9, two curves (uniform prior rising, "our prior" flatter). Image: ../figures/GHRS20/p18.png
- **Fig. 8 (p. 19)** — "Drawing 6455 N = 9 braids from our prior yields knots with 9 or fewer crossings, 4664 of which are prime. Plotted are the number of occurrences of knots in the Rolfsen table for knots with 3 through 9 crossings, with mirrors counted for knots that are not self-mirror." (three bar charts by Rolfsen index, self-mirror vs not.)
- **Fig. 9 (p. 21)** — "Overview of the performance of the Reformer models for the UNKNOT decision problem. Shaded regions are confidence intervals associated to hyperparameters listed in Table 1 that are not displayed on the plots." Panels: (a) performance vs n_hashes / full attention, (b) Reformer vs FFNN, (c) Reformer vs braid length N, performance increases with N, (d) performance with number of letters fixed. Axes: percent correct (≈85–100) vs epoch (0–50). Image: ../figures/GHRS20/p21.png
- **Fig. 10 (p. 22)** — "Performance comparison between Reformer and feedforward network for different braid lengths N" (N = 12, 24, 36, 48). Image: ../figures/GHRS20/p22.png
- **Fig. 11 (p. 25)** — "A study of Reformer outputs for N = 12 knots. Top Left: Output distribution for knots. Top Right: Output distribution for unknots. Bottom: Correlation between network outputs and the maximum absolute value of Jones polynomial degrees." *What it shows:* log10(count) histograms with bins (0,0.001),…,(0.9,1); mean log10(output) vs max|Jones degree| 0–15 decreasing from ≈0 to ≈ −15 for knots. Image: ../figures/GHRS20/p25.png
- **Fig. 12 (p. 35)** — "Performance comparison of the TRPO, A3C and RW algorithms. Left: Fraction of unknots whose braid words could be reduced to the empty braid word as a function of initial braid word length N. Right: Average number of actions necessary to reduce the input braid word to the empty braid word as a function of N." Image: ../figures/GHRS20/p35.png
- **Fig. 13 (p. 36)** — "Comparison of the moves that are picked by an untrained agent vs a trained agent." (bars: SmartCollapse, BR1&shift, BR2&shift, shift left, shift right, Markov 1; N = 96). Image: ../figures/GHRS20/p36.png
- **Figs. 14–16 (pp. 46–48)** — knot/unknot diagrams for the "Knot or not?" game; answers: Fig. 14: KUUKUKUUKUKK; Fig. 15: UKUKKUKKUKUU; Fig. 16: KUUKUKUUKKUK (K = non-trivial knot, U = unknot) (p. 45, footnote 12).

## Stated limitations, open problems, future work
- Hardness of the knots found is "preliminary": "While more statistics are necessary to draw a firm conclusion…" (p. 23).
- No systematic way of constructing braid unknots that need crossing increase; unknown whether DT hardness persists in braid representation (p. 25).
- "It would be interesting to investigate this further by looking at the attention modules of the reformer" (p. 21).
- RL: A3C drop at large N_max could be fixed by more complex NNs, longer exploration, discount factor closer to 1; stabilization move omitted; unknown whether intermediate lengthening by > factor 2 is ever needed (pp. 31, 33, 35).
- RL success measured only on unknots (p. 33). Conclusion: "better conceptual understanding" needed for performance increasing with N (p. 37).

## References worth following
- [24] Kitaev, Kaiser, Levskaya, Reformer: the efficient transformer (ICLR 2020).
- [20] Vaswani et al., Attention is all you need (2017).
- [48] Schulman et al., Trust region policy optimization; [52] ChainerRL standard hyper-parameters; [45] Mnih et al. A3C.
- [42, 43] hard-unknot examples (176 15-crossing unknot diagrams in DT form; cited as "[42, 43]": Henrich–Kauffman and Burton-type "unknotting needs more crossings" — exact titles not given in the pages read).
- [31] Hass–Lagarias–Pippenger; [32] Kuperberg; [36] (NP-hardness with bounded Reidemeister moves); [44] Dehornoy braid ordering; [17] Hughes, A neural network approach to predicting and computing knot invariants; [18] volume from Jones polynomial.

## Extraction notes
- Pages 1–45 read (pp. 46–52 figures/references only skimmed). No numeric tables beyond Tables 1–2; all accuracy data are in plots without numbers, so only values quoted in text are recorded.
- Lattice relevance: none (braid-word knots; RL over Markov moves and braid relations). Relevant only as a template for RL "unknotting" with a step-count reward and certified output (empty braid word).
- ⚠ Alg. 5 BraidRelation1 vs BraidRelation2 inconsistency; ⚠ Fig. 5(b) vs (11b); ⚠ trefoil fraction statement (19/30 hard instances vs 242 trefoil instances).
