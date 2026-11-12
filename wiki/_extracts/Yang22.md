# Yang22 — Applying Deep Reinforcement Learning to the HP Model for Protein Structure Prediction
- **Authors:** Kaiyuan Yang (NUS Computer Science; now Univ. of Zurich), Houjing Huang (Institute of Automation, CAS), Olafs Vandans (EXN SIA, Latvia), Adithya Murali (NVIDIA), Fujia Tian (CityU Hong Kong), Roland H. C. Yap* (NUS), Liang Dai* (CityU Hong Kong)
- **Venue / year / identifiers:** arXiv:2211.14939v2 [cs.LG], 9 Dec 2022 (preprint submitted to Physica A, December 12, 2022; published as Physica A 609, 128395 (2023) per EPG24's reference list)
- **File:** papers/5_ml_rl/Yang-et-al_2022_Deep_RL_HP_model_2211.14939.pdf   **Pages:** 21
- **Text layer:** ok (Tables 2 and 3 scrambled in the text layer; both verified on page images)

## Abstract
A central problem in computational biophysics is protein structure prediction, i.e., finding the optimal folding of a given amino acid sequence. This problem has been studied in a classical abstract model, the HP model, where the protein is modeled as a sequence of H (hydrophobic) and P (polar) amino acids on a lattice. The objective is to find conformations maximizing H-H contacts. It is known that even in this reduced setting, the problem is intractable (NP-hard). In this work, we apply deep reinforcement learning (DRL) to the two-dimensional HP model. We can obtain the conformations of best known energies for benchmark HP sequences with lengths from 20 to 50. Our DRL is based on a deep Q-network (DQN). We find that a DQN based on long short-term memory (LSTM) architecture greatly enhances the RL learning ability and significantly improves the search process. DRL can sample the state space efficiently, without the need of manual heuristics. Experimentally we show that it can find multiple distinct best-known solutions per trial. This study demonstrates the effectiveness of deep reinforcement learning in the HP model for protein folding.

## Notation and conventions
- (p. 3) HP model on the **2D square lattice**: "The HP model folding process is set up as a self-avoiding walk (SAW)." First unit at (0,0); to remove symmetries "the first two HP units are put in a position of 'up'. And the first turn (non-Forward action) is only allowed to be Left" so the 2nd unit is always at (0,1) (Fig. 3A).
- (p. 4) Constraints (1) adjacency |x_i−x_j|+|y_i−y_j| = 1 for |i−j| = 1; (2) self-avoidance (i≠j ⇔ positions differ). Relative action set A_3 = {L, F, R} (left, forward, right). "Growing SAW (GSAW)"; "one-step probability" = 1 / (#unoccupied neighbours) ∈ {1/3, 1/2, 1, 0}; 0 means premature termination = incomplete SAW.
- (p. 4) Contact: two units adjacent on lattice but not adjacent in the sequence; H–H contact between two hydrophobic units. E_state = −(# H–H contacts) (Fig. 1: HPPHPH folds to E = −2).
- Episode = one SAW walk; complete SAW = all N units placed; incomplete SAW = terminated early because no valid action (not a valid solution) (p. 7).
- N-mer, "best-known energy" from the Istrail benchmark (p. 10). RAND = random exploration baseline (ε = 1 for all episodes) (p. 7, 11).

## Numbered statements
None (no theorems). Equations (1)–(11) in Methods.

## Key equations and quantitative claims outside numbered statements
- (p. 5–6) Bellman optimality (3); Q-learning update (4) Q(s,a) ← Q(s,a) + β[r + γ max Q(s′,a′) − Q(s,a)]; TD error δ (5).
- (p. 7) ε-greedy (6); exponential decay (7): ε_i = ε_min + (ε_max − ε_min)·exp(−iλ/ψ), ψ = total episodes for decay, λ = 5, ε_min = 0.01, ε_max = 1.
- (p. 7) Reward (8): r_{t+1} = η·|E_state| with η = 1 only when the episode is finished (t = T), else 0 — sparse reward given only for complete or incomplete SAW ends: "Incomplete SAW is not a valid solution" (reward for incomplete walk = number of contacts of the partial walk at termination as written; ⚠ the paper does not say whether incomplete walks receive a penalty).
- (p. 8) State representation: one-hot encoded sequence of length N; each position has a 6-dim binary vector = 4 movement-status types (∅ for the fixed first two units — printed "‘∅’"; ‘-’ for not yet placed; L; F; R as listed "(,L,F,R)" with two symbols lost in the text layer) + 2 monomer types (H, P). Example 8-mer HHPPHPHH with action sequence L, R, R, F.
- (p. 8) Architecture: LSTM DQN. "a two-layer 256-hidden-state stacked LSTM architecture is sufficient for HP sequences shorter than N ≤ 36. For longer HP sequences (N = 48, 50), a three-layer LSTM with 512 hidden states can achieve better results." Final fully connected layer from last hidden state of last layer gives Q-values for the three actions.
- (p. 8–10) Two networks (policy, target) with target cloned every C = 100 updates; discount γ = 0.98; replay memory FIFO of the last min(50000, ψ/10) transitions (ψ = total episodes per trial); mini-batch size 32 uniform; Huber loss (11); Adam, learning rate 0.0005.
- (p. 10–11) Benchmarks: N ∈ {20, 24, 25, 36, 48, 50} from the Istrail benchmark (Table 1). Episodes per trial: 100K for 20mer-A,B; 500K for 24mer–36mer; 600K for 48mer and 50mer (p. 12). Four random seeds for each method (RAND and DRL), "All experiments are repeated four times with four random seeds" (p. 11).
- (p. 11) Hardware/software: NVIDIA GeForce RTX 3070 Ti, PyTorch 1.10.1, CUDA 11.3, OpenAI Gym; environment extended from gym-lattice [53]. Training time not reported (⚠ no wall-clock times given).
- (p. 11–12) Results: 20mer-B: RAND finds some close to BKV by chance; DRL consistently finds −10. 36mer: DRL −14, RAND by luck −12. 50mer: RAND at best −15; DRL reaches −21 "in all of the four random seed trials". "RAND alone can match the best-known results for 20mer-A and 24mer, and gives close results for 20mer-B and 25mer ... The performance gap between DRL and RAND is seen from N ≥ 36." DRL reaches BKV for all six selected benchmark sequences (all complete SAWs).
- (p. 12–13) Comparison with related RL: Dogan-AntQ (2015) tabular RL with ant-swarm heuristics: 24mer −9, 36mer −13, 48mer −19; Li-FoldingZero (2018): only 20mer-A at BKV; "RAND can already encounter best-known solutions for the 24mer"; Wu-QL (2019) 5 million episodes per trial, N ≤ 20; Yu-DRL (2020): in the range of RAND; the related work "has not focused on whether their foldings are complete or incomplete SAWs. Our results are all complete SAW."
- (p. 13–14) LSTM vs fully-connected (Fig. 8): FCN with the same number of layers and roughly the same number of parameters is "much less stable" and shows "catastrophic forgetting" on the 36mer.
- (p. 14) Sample efficiency: exhaustive enumeration [42]: 41,889,578 (≈ 4×10^7) complete SAWs for 20mer; 2,158,326,727 (≈ 2×10^9) for 24mer; claims: 100K episodes "less than 0.2%" of the 20mer SAW space; 500K "less than 0.02%" for 24mer; for 36mer 500K < 2.5×10^{−7}%. (⚠ 100,000/41,889,578 = 0.239%, i.e. not < 0.2%; 500,000/2,158,326,727 = 0.0232%, not < 0.02%; the 20mer estimate also depends on how HP sequence symmetries are counted — as printed.)
- (p. 14–15) Manual pruning heuristics (avoid consecutive 'Forward' actions making rod chains; early-stop SAW if remaining units cannot improve) did not help: default DRL converged faster (Fig. 9).
- (p. 15–16, Table 3) Distinct best-known solutions found for 48mer (E = −23) and next-best (E = −22) per trial: a: 48 / 91; b: 12 / 17; c: 24 / 80; d: 10 / 60. "the 36mer can have more than 180 distinct conformations that all have the best-known energy of −14" (p. 17). Conformation database released on Zenodo (GitHub repo); Appendix lists action sequences, e.g. 20mer-A best folds "LFLLRRLFLLRLRRLLFL" and "LFLLRLFLRLLRLRLFLL"; 20mer-B "LFLLRRLRLLFLRRLLFL" (p. 19; ⚠ the paper says two conformations for 20mer-A and one for 20mer-B in Fig. A.11 layout).
- (p. 16) Reproducibility: "Most [related works] did not list a working set of hyper-parameters, especially the number of time-steps or episodes"; paper lists hyper-parameters and number of trials.

## Methods / algorithms
1. (p. 3–4) Environment: 2D square-lattice growing SAW with relative actions L, F, R; first two units fixed, first turn must be L (symmetry removal); incomplete SAW if no action available.
2. (p. 7) Reward: sparse; r = |E_state| = number of H–H contacts at episode end, 0 otherwise.
3. (p. 8) State: N × 6 one-hot matrix (movement ∅/-/L/F/R + H/P).
4. (p. 8–10) DQN with LSTM (2×256 for N ≤ 36; 3×512 for N = 48, 50), policy + target networks (C = 100), γ = 0.98, replay memory min(50000, ψ/10), batch 32, Huber loss, Adam lr 5×10^{-4}, ε-greedy with exponential decay ε_i = ε_min + (ε_max − ε_min)exp(−5i/ψ), ε ∈ [0.01, 1].
5. (p. 11–12) Trials: 100K episodes (20mers), 500K (24–36mers), 600K (48, 50mers); 4 seeds; log minimum energy in a moving window of 200 episodes (Fig. 7–9).
6. Verification: energies computed directly from the lattice conformation by the environment; BKVs from Istrail benchmark; distinct conformations counted modulo translation/rotation symmetry ("invariant to translational and rotational symmetries", Fig. 10 caption) (reflection symmetry is removed by the L-first rule).

## Tables
**Table 1 (p. 11).** "Selected benchmark HP sequences from the Istrail Benchmark with their best known energies."

| N-mer ID | Length | HP Sequence | Best Known Energy |
|---|---|---|---|
| 20mer-A | 20 | HPHPPHHPHPPHPHHPPHPH | −9 |
| 20mer-B | 20 | HHHPPHPHPHPPHPHPHPPH | −10 |
| 24mer | 24 | HHPPHPPHPPHPPHPPHPPHPPHH | −9 |
| 25mer | 25 | PPHPPHHPPPPHHPPPPHHPPPPHH | −8 |
| 36mer | 36 | PPPHHPPHHPPPPPHHHHHHHPPHHPPPPHHPPHPP | −14 |
| 48mer | 48 | PPHPPHHPPHHPPPPPHHHHHHHHHHPPPPPPHHPPHHPPHPPHHHHH | −23 |
| 50mer | 50 | HHPHPHPHPHHHHPHPPPHPPPHPPPPHPPPHPPPHPHHHHPHPHPHPHH | −21 |

**Table 2 (p. 12).** "Performance comparison among related RL work on Istrail Benchmark sequences. Table entries are lowest energies of E_state obtained. '-' indicates information not provided. Results matching the best known energies are highlighted in red bold. Second-closest results are highlighted in blue." (verified on page image)

| N-mer ID | Dogan-AntQ (2015) | Li-FoldingZero (2018) | Wu-QL (2019) | Yu-DRL (2020)^a | Random | Ours | Best Known |
|---|---|---|---|---|---|---|---|
| 20mer-A | - | −9 (best) | −9 (best) | −6 \| −8 | −9 (best) | −9 (best) | −9 |
| 20mer-B | - | - | −10 (best) | −8 \| −9 | −9 | −10 (best) | −10 |
| 24mer | −9 (best) | −8 | - | −6 \| −8 | −9 (best) | −9 (best) | −9 |
| 25mer | - | −7 | - | - \| −7 | −7 | −8 (best) | −8 |
| 36mer | −13 | −13 | - | - \| −13 | −12 | −14 (best) | −14 |
| 48mer | −19 | −18 | - | - | −17 | −23 (best) | −23 |
| 50mer | - | −18 | - | - | −15 | −21 (best) | −21 |

^a Yu et al. [39] reported two classes of RL methods, DRL and AlphaGo Zero with Pretraining; the two results are separated by "|". ("(best)" = red bold in the original; blue second-closest marks not recorded.)

**Table 3 (p. 15).** "Number of distinct best-known solutions E_state = −23, and next best solutions E_state = −22 from the DRL experiments for 48mer, over four repeated trials with different random seeds. Note the count of distinct solutions are on a per-trial basis, i.e., there can be overlap of solutions among trials." (verified on page image)

| N-mer ID | Trial | #Distinct Best-known Solutions | #Distinct Next Best Solutions |
|---|---|---|---|
| 48mer | a | 48 | 91 |
| 48mer | b | 12 | 17 |
| 48mer | c | 24 | 80 |
| 48mer | d | 10 | 60 |

## Figures
- **Fig. 1 (p. 2)** — "HP model on a 2D square lattice. Example six-unit HP sequence, S = HPPHPH with N = 6, folds into a conformation with two H-H contacts. The energy of this state is E_state = −2 (the optimal conformation)."
- **Fig. 2 (p. 3)** — "Overview of our DRL method with LSTM-based DQN. … There are two NNs for the learning, the Policy Network and the Target Network. The TD error is used to calculate the loss. Back propagation … tunes the learnable parameters θ in the Policy Network. The HP model SAW agent interacts with the RL environment at each time step t by taking actions based on the ε-greedy method. Action-state-reward experiences e_t are stored in replay memory D_t. Mini-batches B of experiences are uniformly sampled for DQN training." Image: ../figures/Yang22/p03.png
- **Fig. 3 (p. 4)** — "(A) HP model SAW as a Markov Decision Process … (B) … an incomplete SAW … has no valid actions from A_3 …; the self-avoiding constraint forbids the agent from going 'Forward' at t_k then 'Left' at t_{k+1}." Image: ../figures/Yang22/p04.png
- **Fig. 4 (p. 5)** — "HP model as optimal SAW path finding. All possible SAW paths from a HP sequence are overlaid with a red-blue color-scale 'energy heatmap' … (A) HPPH (N = 4) … (B) HPPHHPPH (N = 8), optimal score 3 … (C) HPPHPHPHHPPHH (N = 13) … score 6." Image: ../figures/Yang22/p05.png
- **Fig. 5 (p. 8)** — "The SAW on the left is not yet complete … converted into a sequence vector of length N representing movement status and monomer type … The action sequence for the current SAW state is L, R, R, F. Finally we encode the sequence data with one-hot encoding for 6 features." Image: ../figures/Yang22/p08.png
- **Fig. 6 (p. 9)** — "LSTM-based recurrent neural network used in DQN. Input X(t) represents the t-th step of input sequence X with length N. The first layer of LSTM cells accepts 6-dimensional inputs … Hidden state of the final recurrent layer's N-th cell is passed to another fully connected layer. The last output layer outputs the predicted Q-values for the three actions a ∈ A_3." Image: ../figures/Yang22/p09.png
- **Fig. 7 (p. 11)** — "Learning curves of DRL (red) and RAND (blue) on the 100K-episode-trial of 20mer-B, 500K-episode-trial of 36mer, and 600K-episode-trial of 50mer. X-axis is the index of episodes in progression. Y-axis denotes the energy found by the agent. The curves are plotted with the moving minimum of 200 episodes. The shaded area represents the standard deviation. Note the best-known minimal energies for 20mer-B, 36mer, and 50mer are −10, −14, −21 respectively. Experiments are repeated four times on four random seeds for both RAND and DRL methods." Image: ../figures/Yang22/p11.png
- **Fig. 8 (p. 14)** — "Comparison of DQN with Fully-Connected Network (FCN) vs with LSTM. Learning curves of RAND (blue), DQN with FCN (yellow), and DQN with LSTM (red) on the 500K-episode-trial of 36mer. …" Image: ../figures/Yang22/p14.png
- **Fig. 9 (p. 15)** — "Default DRL algorithm (red) versus DRL with additional manual pruning heuristics (cyan) on the 500K-episode-trial of 36mer. …" **Fig. 10 (p. 16)** — "Examples of four best-known solutions found by DRL agent for 48mer with E_state = −23 (to accompany Table 3). Note these solutions are invariant to translational and rotational symmetries." Image: ../figures/Yang22/p16.png
- **Fig. A.11 (p. 19)** — "Examples of best-known solutions found by DRL agent along with the action sequences stored in the conformation database." **Fig. A.12 (p. 19)** — screenshots of 48mer next-best conformations (E = −22) action sequences (Trial b, count 17).

## Stated limitations, open problems, future work
- "the HP model … is not designed for modelling practical protein folding" (p. 17); benchmark sequences are degenerate (many best-known conformations).
- Future: model-based DRL such as EfficientZero (MCTS look-ahead); extension to HPNX model (p. 17).
- The related work comparison relies on reported results with unknown trial counts (p. 16).
- Only 2D square lattice, N ≤ 50, tested (⚠ no 3D results; 3D extension is in EPG24).

## References worth following
- [30] Mnih et al., Human-level control through deep RL, Nature 518 (2015) (DQN); [40] Mnih et al., Playing Atari (2013).
- [35] Dogan–Ölmez, A novel state space representation for the solution of 2D-HP protein folding problem using RL, Appl. Soft Comput. 26 (2015); [36] Li et al., FoldingZero (2018); [38] Wu et al., Research on predicting 2D-HP folding using RL with full state space, BMC Bioinformatics (2019); [39] Yu–Schreck–Ma, DRL for protein folding in the HP model with pull moves (NeurIPS Workshop 2020).
- [42] Irbäck–Troein, Enumerating designing sequences in the HP model (2002) (SAW counts); [43,44] growing SAW (Hemmer–Hemmer; Lyklema–Kremer); [53] gym-lattice (Miranda); [45] Hooper–Klotz, Trapping in SAWs with nearest-neighbor attraction (2020).
- [17] Wüst–Landau, Versatile approach to access the low temperature thermodynamics of lattice polymers and proteins, PRL 102 (2009) (cf. WL12); [15] Thachuk et al. replica exchange MC for HP; [51] Chen–Huang branch and bound (benchmark source).
- [25] Vandans et al., PRE 101 (2020) (knot-type ML; cf. Vandans20).

## Extraction notes
- All 21 pages read; Tables 2 and 3 verified on images; Table 1 from text layer.
- Lattice relevance (key): 2D square-lattice growing self-avoiding walk with relative moves; state/reward/DQN setup; counts of complete SAWs (41,889,578 for N=20; 2,158,326,727 for N=24) and number of degenerate optimal conformations (e.g. > 180 for 36mer; Table 3 for 48mer) — relevant as a template for RL over lattice polygon/walk conformations. No knot content.
- ⚠ percentage claims in Sec. 3.4; ⚠ no wall-clock times; ⚠ reward for incomplete SAW unspecified.
