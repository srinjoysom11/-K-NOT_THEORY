# EPG24 — Protein Structure Prediction in the 3D HP Model Using Deep Reinforcement Learning
- **Authors:** Giovanny Espitia (Dept. of Physics, Univ. of Texas at Austin), Yui Tik Pang (School of Physics, Georgia Tech), James C. Gumbart (School of Physics, Georgia Tech)
- **Venue / year / identifiers:** arXiv:2412.20329v1 [cs.LG], 29 Dec 2024 (dated December 31, 2024); "Preprint. Under review."
- **File:** papers/5_ml_rl/Espitia-Pang-Gumbart_2024_3D_HP_model_deep_RL_2412.20329.pdf   **Pages:** 15
- **Text layer:** ok (tables 1–3 partly column-scrambled; Table A.1 is rotated, read from text layer and checked on page image)

## Abstract
We address protein structure prediction in the 3D Hydrophobic-Polar lattice model through two novel deep learning architectures. For proteins under 36 residues, our hybrid reservoir-based model combines fixed random projections with trainable deep layers, achieving optimal conformations with 25% fewer training episodes. For longer sequences, we employ a long short-term memory network with multi-headed attention, matching best-known energy values. Both architectures leverage a stabilized Deep Q-Learning framework with experience replay and target networks, demonstrating consistent achievement of optimal conformations while significantly improving training efficiency compared to existing methods.
(⚠ "matching best-known energy values" for longer sequences is contradicted by the paper's own Table 3: LSTM-A reaches BKV only for 3D1–3D4; 3D5–3D9 are 1–4 above BKV. Also "proteins under 36 residues" vs text "N ≤ 36".)

## Notation and conventions
- (p. 2) 3D HP model on cubic lattice G ⊂ Z³: "the protein folding process is modeled as a self-avoiding walk (SAW) on G, where each amino acid in the sequence occupies a single lattice point". First two residues fixed: r_0 = (0,0,0), r_1 = (0,1,0).
- (p. 2) Constraints: unit distance between consecutive residues (Eq. 1); "bond angle constraint: the bond angles formed by three consecutive amino acids must be restricted to 90° or 180° to ensure rotational invariance" (Eq. 2; ⚠ paper's justification as printed); self-avoidance (Eq. 3); translational invariance (Eq. 4).
- (p. 2) Energy: "An H-H contact occurs when two non-consecutive hydrophobic amino acids are placed adjacent to each other in the lattice. The energy … E = −(number of valid H-H contacts)" (Eq. 5). BKV = best-known value of E.
- N = sequence length. Sequence names 3D1–3D9 (3D benchmark, lengths 20–60) and A1–A11 (length 27). Compact notation in Tables 1–2: e.g. (HP)2 = HPHP, H2 = HH.
- Episode = one full SAW placement of the N residues (reward only at end, based on energy of the fold) (p. 2).
- FFNN = fully connected feed-forward baseline; FFNN-R = reservoir-based FFNN ("Hybrid-Reservoir"); LSTM-OLH = LSTM using only last hidden state; LSTM-A = LSTM with multi-head attention (p. 6).

## Numbered statements
None (no theorems). Equations (1)–(14) listed in Methods below.

## Key equations and quantitative claims outside numbered statements
- (p. 3) MDP (S, A, P, R, γ); Bellman optimality (6); DQN loss (7) L(θ) = E[(r + γ max Q(s_{t+1}, a_{t+1}; θ^−) − Q(s,a;θ))²]; minibatch loss (9); target y_t (8); target network update every C steps θ^− ← θ (10); ε-greedy (11). ⚠ C, γ, ε schedule, replay-buffer size not given.
- (p. 4) State: 8-dim one-hot vector per time step: first six entries = available actions (ND = No Decision, F, L, R, U, D — B excluded) and last two = residue type (H or P); episode tensor shape (N, 8, 1). "The neural network does not directly observe amino acid placements; instead, it deduces this information from actions taken thus far." (⚠ the text says "available actions" but the vector encodes the action taken/ND state; B (backward) excluded, giving 5 move outputs F, L, R, U, D.) Network output = (5,1) Q-values (p. 5). ND ends the episode.
- (p. 5) Reservoir (Eq. 12) r(t) = f(W_in x(t) + W r(t−1)), f = tanh; W_in described as "the trainable input weight matrix" ⚠ while W (reservoir matrix) is random and fixed (Erdős–Rényi sparse topology; Xavier uniform init p. 6); abstract calls it "fixed random projections". Reservoir size N_r = 1000 for N ≤ 36, ≈ 3000 for N = 48, 50. Fully connected layers 512, 256, 128, 84 with ReLU (p. 5; ⚠ p. 6 FFNN baseline is "512→256→84→output"; Table A.1 lists FFNN layer sizes "512, 256, 84" for both FNN-Vanilla and FNN-Reservoir while text says reservoir model has 512, 256, 128, 84).
- (p. 5–6) LSTM-A: LSTM layers + multi-head attention (Eq. 13 softmax(QK^T/√d_k)V; Eq. 14 Concat(head_1,…,head_4)W^O), hidden size d = 512, "four attention heads", batch-first; last time step of attention output → fully connected output layer to action space. (⚠ Fig. 3 caption says "8-head attention mechanism"; text and Discussion say 4 heads.)
- (p. 6–7) Training: single NVIDIA H100 GPU, PyTorch 2.5.0, CUDA 11.8; Adam, learning rate 0.001; smooth L1 loss; experience replay + ε-greedy. "network depth beyond 5 layers shows a decrease in performance, while batch size of 32 provides optimal balance" (p. 8).
- (p. 7) Parameter counts: FFNN-R 264,445 trainable parameters vs LSTM-A 6,324,741 (3-layer, N ≤ 36) and 10,527,237 (5-layer) per Table A.1.
- (p. 7) FFNN-R converges "often reaching near-optimal conformations within the first 50,000 episodes"; attention in LSTM-A starts mattering after ≈ 100,000 episodes. Claim: FFNN-R "approximately 25% fewer training episodes" than vanilla FFNN to reach optimal conformations (no table of episodes-to-optimum given besides Table A.1 where each run lists a fixed episode budget of 200K for FFNN/FFNN-R, 200K–750K for LSTMs).
- (p. 7–8, "3.1 Efficiency") Memory: LSTM-A 2.4 GB for N ≤ 36 (LSTM layers 512 units 1.8 GB, attention 0.4 GB, auxiliary 0.2 GB); FFNN-R consistent 800 MB (sparse reservoir 1000 nodes, 10% connectivity, 400 KB; input weights 1000×8, 32 KB; FC 256 and 84 nodes 1 MB). Training time: LSTM-A ≈ 8 hours for N ≤ 36 and up to 48 hours for 3d5–3d9; 500,000 episodes for 48–50 residues; FFNN-R ≈ 200,000 episodes for N ≤ 36, ≈ 1.5 hours; "80–90% unique conformational states within the first 50,000 episodes". (⚠ A.1 lists LSTM-A times up to 65:00:00 for 3d9.)
- (p. 8–10) Limitations: LSTM-A training "computationally demanding beyond 60 amino acids"; FFNN-R "degrades significantly after length 36"; memory of LSTM-A scales quadratically with N. Claims comparison to GA, ACO, PERM: "superior performance on longer sequences while requiring significantly less computational time" (qualitative; no timing for baselines).
- Benchmarks (p. 6) from Table 1 of Boumedine & Bouroubi 2022 (BKVs).

## Methods / algorithms
1. (p. 2) Environment: 3D cubic lattice SAW; agent places residues sequentially; reward at episode end from E = −(#H–H contacts); constraints 90°/180° bond angles (no backward move).
2. (p. 3–4) Stabilised DQN: experience replay buffer, target network (periodic copy every C steps), ε-greedy; update minimising (9) with smooth L1 loss; Adam lr 0.001; minibatch 16 or 32 (A.1).
3. (p. 4) State encoding: per step 8-dim one-hot (ND,F,L,R,U,D + H,P); tensor (N,8,1).
4. (p. 5) FFNN-R: flatten input → fixed sparse random reservoir (tanh; size 1000 for N ≤ 36, ~3000 for N = 48–50) → FC 512–256–(128)–84 ReLU → 5 outputs.
5. (p. 5–6) LSTM-A: LSTM(512) → 4-head attention → last time step → FC → 5 Q-values; 3 layers for N ≤ 36, 5 layers for N ≥ 46; batch size 16 or 32; 200K–750K episodes.
6. (p. 6–7) Evaluation: minimum energy found over training (Fig. 5, 6: minimum conformation energy vs episode), compared to BKV and to GA, BILS, TPPSO baselines (values quoted from [Boumedine–Bouroubi 2022] and [Yang et al. 2023] presumably — not stated which); verification = energy computed by the environment for the achieved lattice conformation.
7. Ablations (p. 6–8): FFNN → FFNN-R → LSTM-OLH → LSTM-A; reservoir size, number of layers (> 5 worse), batch size 32 best.
Compute budget: 1 H100; Table A.1 gives per-run times (1 h – 65 h) and dates (Oct–Dec 2024); Hive/Phoenix PACE clusters acknowledged.

## Tables
**Table 1 (p. 8).** "Sequences and their corresponding best known conformation energy values (BKV)." (3D sequences; text layer, subscript counts as printed.)

| SEQ. | LENGTH | SEQUENCE | BKV |
|---|---|---|---|
| 3D1 | 20 | (HP)2PH(HP)2(PH)2HP(PH)2 | −11 |
| 3D2 | 24 | H2P2(HP2)6H2 | −13 |
| 3D3 | 25 | P2HP2(H2P4)3H2 | −9 |
| 3D4 | 36 | P(P2H2)2P5H5(H2P2)2P2H(HP2)2 | −18 |
| 3D5 | 46 | P2H3PH3P3HPH2PH2P2HPH4PHP2H5PHPH2P2H2P | −35 |
| 3D6 | 48 | P2H(P2H2)2P5H10P6(H2P2)2HP2H5 | −31 |
| 3D7 | 50 | H2(PH)3PH4PH(P3H)2P4(HP3)2HPH4(PH)3PH2 | −34 |
| 3D8 | 58 | PH(PH3)2P(PH2PH)2H(HP)3(H2P2H)2PHP4(H(P2H)2)2 | −44 |
| 3D9 | 60 | P(PH3)3H5P3H10PHP3H12P4H6PH2PH | −55 |

**Table 2 (p. 8).** "Sequences and their corresponding best known conformation energy values (BKV) (continued)." (A-series, all length 27)

| SEQ. | LENGTH | SEQUENCE | BKV |
|---|---|---|---|
| A1 | 27 | PHPHPH3P2HPHP11H2P | −9 |
| A2 | 27 | PH2P10H2P2H2P2HP2HPH | −10 |
| A3 | 27 | H4P5HP4H3P9H | −8 |
| A4 | 27 | H3P2H4P3HPHP2H2P2HP3H2 | −15 |
| A5 | 27 | H4P4HPH2P3H2P10 | −8 |
| A6 | 27 | HP6HPH3P2H2P3HP4HPH | −12 |
| A7 | 27 | HP2HPH2P3HP5HPH2PHPHPH2 | −13 |
| A8 | 27 | HP11HPHP8HPH2 | −4 |
| A9 | 27 | P7H3P3HPH2P3HP2HP3 | −7 |
| A10 | 27 | P5H2PHPHPHPHP2H2PH2PHP3 | −11 |
| A11 | 27 | HP4H4P2HPHPH3PHP2H2P2H | −16 |

(⚠ A11 appears in Table 2 but in no later table.)

**Table 3 (p. 9).** "Energy values of 3d protein sequences obtained by different algorithms. The right-most column corresponds to the least energy conformation found by our models. The results of all experiments tabulated in Table 4 in the appendix section." (⚠ the appendix table is named Table A.1.) Left block (3D sequences, LSTM-A):

| SEQ. | LENGTH | BKV | GA | BILS | LSTM-A |
|---|---|---|---|---|---|
| 3D1 | 20 | −11 | −11 | −10 | −11 |
| 3D2 | 24 | −13 | −13 | −9 | −13 |
| 3D3 | 25 | −9 | −9 | −7 | −9 |
| 3D4 | 36 | −18 | −18 | −12 | −18 |
| 3D5 | 46 | −35 | −32 | −22 | −33 |
| 3D6 | 48 | −31 | −31 | −19 | −30 |
| 3D7 | 50 | −34 | −30 | −18 | −32 |
| 3D8 | 58 | −44 | −37 | −23 | −40 |
| 3D9 | 60 | −55 | −50 | −36 | −51 |

Right block (A-series, FFNN-R):

| SEQ. | LENGTH | BKV | GA | TPPSO | FFNN-R |
|---|---|---|---|---|---|
| A1 | 27 | −9 | −8 | −9 | −9 |
| A2 | 27 | −10 | −10 | −10 | −10 |
| A3 | 27 | −8 | NA | −8 | −8 |
| A4 | 27 | −15 | −15 | −15 | −15 |
| A5 | 27 | −8 | −8 | −8 | −8 |
| A6 | 27 | −12 | NA | −11 | −11 |
| A7 | 27 | −13 | −13 | −12 | −12 |
| A8 | 27 | −4 | −4 | −4 | −4 |
| A9 | 27 | −7 | −7 | −7 | −7 |
| A10 | 27 | −11 | NA | −11 | −11 |

(Table 3 as read from text layer; ⚠ GA/TPPSO/BILS baselines' sources not identified in the pages read; ⚠ for 3D5–3D9 LSTM-A is worse than GA on 3D5 (−33 vs −32 is better) — GA −32, LSTM-A −33 on 3D5; GA −31 vs −30 on 3D6 (GA better), 3D7 GA −30 vs −32 (LSTM-A better), 3D8 GA −37 vs −40, 3D9 GA −50 vs −51. ⚠ A4, A9 FFNN-R values (−15, −7) contradict Table A.1 (−14, −6) for the FNN-Reservoir runs.)

**Table A.1 (pp. 13–15; shown only on p. 13).** "3D Trial Runs, Dictionary: LSTM-OLH → LSTM - OnlyLastHidden, LSTM-A (Num of Heads) → LSTM - with Attention, FNN-VANILLA → Without Reservoir, FNN-Reservoir → With Reservoir". Columns: Sequence | Architecture | Num Layers | Size of Layer | Batch Size | Num Training Episodes | Time to Train | Date | E_Min Best (= BKV) | E_min Experimental (found) | Num Parameters. (Rotated table, read from text layer and image; "−" = blank.)

| Seq | Architecture | Layers | Layer size | Batch | Episodes | Time | Date | E_min best | E_min exp. | Params |
|---|---|---|---|---|---|---|---|---|---|---|
| 3d1 | LSTM-A (4) | 3 | 512 | 16 | 200K | 6:54:38 | 10/12/24 | −11 | −11 | 6324741 |
| 3d2 | LSTM-A (4) | 3 | 512 | 16 | 220K | 7:33:33 | 10/12/24 | −13 | −13 | 6324741 |
| 3d3 | LSTM-A (4) | 3 | 512 | 16 | 220K | 7:54:00 | 12/12/24 | −9 | −9 | 6324741 |
| 3d4 | LSTM-A (4) | 3 | 512 | 16 | 250K | 11:14:39 | 10/12/24 | −18 | −18 | 6324741 |
| 3d5 | LSTM-A (4) | 5 | 512 | 16 | 500K | 41:27:15 | 10/13/24 | −35 | −33 | 10527237 |
| 3d6 | LSTM-A (4) | 5 | 512 | 16 | 500K | 41:23:16 | 10/13/24 | −31 | −30 | 10527237 |
| 3d5 | LSTM-A (4) | 5 | 512 | 32 | 750K | 45:15:55 | 10/20/24 | −35 | −33 | 10527237 |
| 3d7 | LSTM-A (4) | 5 | 512 | 32 | 750K | 49:49:49 | 10/20/24 | −34 | −32 | 10527237 |
| 3d6 | LSTM-A (4) | 5 | 512 | 32 | 750K | 46:15:23 | 10/22/24 | −31 | −30 | 10527237 |
| 3d8 | LSTM-A (4) | 5 | 512 | 32 | 750K | 57:00:00 | 10/22/24 | −44 | −40 | 10527237 |
| 3d8 | LSTM-A (4) | 6 | 512 | 32 | 750K | − | 10/22/24 | −44 | − | − |
| 3d9 | LSTM-A (4) | 5 | 512 | 32 | 750K | 65:00:00 | 10/26/24 | −55 | −51 | − |
| 3d1 | LSTM-OLH | 3 | 512 | 16 | 200K | 3:18:16 | 10/26/24 | −11 | −11 | 5274117 |
| 3d2 | LSTM-OLH | 3 | 512 | 16 | 220K | 4:06:36 | 10/26/24 | −13 | −13 | 5274117 |
| 3d3 | LSTM-OLH | 3 | 512 | 16 | 220K | 1:06:10 | 10/26/24 | −9 | −9 | 5274117 |
| 3d4 | LSTM-OLH | 3 | 512 | 16 | 250K | 1:24:51 | 10/26/24 | −18 | −18 | − |
| 3d5 | LSTM-OLH | 5 | 512 | 16 | 500K | − | 10/26/24 | −35 | −35 | − |
| 3d6 | LSTM-OLH | 5 | 512 | 16 | 500K | − | 10/26/24 | − | − | − |
| 3d7 | LSTM-OLH | 5 | 512 | 32 | 750K | − | 10/26/24 | − | − | − |
| 3d8 | LSTM-OLH | 5 | 512 | 32 | 750K | − | 10/26/24 | − | − | − |
| 3d9 | LSTM-OLH | 5 | 512 | 32 | 750K | − | 10/26/24 | − | − | − |
| 3d1 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 0:58:15 | 10/26/24 | −11 | −11 | − |
| 3d2 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 220K | 1:06:16 | 10/26/24 | −13 | −13 | − |
| 3d3 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 220K | 1:06:29 | 10/26/24 | −9 | −9 | − |
| 3d4 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 250K | 1:25:10 | 10/26/24 | −18 | −18 | − |
| 3d5 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 500K | 3:13:46 | 10/26/24 | −35 | −30 | − |
| A1 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 1:08:39 | 10/30/24 | −9 | −9 | − |
| A2 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 1:08:18 | 10/30/24 | −10 | −10 | − |
| A3 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 1:26:09 | 10/30/24 | −8 | −8 | − |
| A4 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 1:27:57 | 10/30/24 | −15 | −14 | − |
| A5 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | − | 10/30/24 | −8 | −8 | − |
| A6 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 1:09:17 | 10/30/24 | −12 | −11 | − |
| A7 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 1:27:20 | 10/30/24 | −13 | −12 | − |
| A8 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 1:27:26 | 10/30/24 | −4 | −4 | − |
| A9 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 1:27:50 | 10/30/24 | −7 | −6 | − |
| A10 | FNN-VANILLA | 4 | 512, 256, 84 | 16 | 200K | 1:27:57 | 10/30/24 | −11 | −11 | − |
| A1 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | 1:12:23 | 11/2/2024 | −9 | −9 | 264445 |
| A2 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | 1:27:59 | 11/2/2024 | −10 | −10 | − |
| A3 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | 1:13:31 | 11/2/2024 | −8 | −8 | − |
| A4 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | 1:14:01 | 11/2/2024 | −15 | −14 | − |
| A5 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | − | 11/2/2024 | −8 | − | − |
| A6 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | 1:27:23 | 11/2/2024 | −12 | −11 | − |
| A7 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | 1:28:23 | 11/2/2024 | −13 | −12 | − |
| A8 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | 1:27:01 | 11/2/2024 | −4 | −4 | − |
| A9 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | 1:27:33 | 11/2/2024 | −7 | −6 | − |
| A10 | FNN-RESERVOIR | 4 | 512, 256, 84 | 16 | 200K | 1:09:38 | 11/2/2024 | −11 | −11 | − |

⚠ Internal inconsistencies as printed: (1) Table A.1 FNN-Reservoir A4 (−14) and A9 (−6) are above BKV and the reservoir model is not shown to be better than vanilla on A-series (identical energies), while the abstract/text claim FFNN-R "consistently achieved BKVs for A1–A5 and A8–A10" and Table 3 lists FFNN-R −15 for A4 and −7 for A9. (2) LSTM-OLH 3d5 row lists −35 as found with no training time and 3d6–3d9 are blank, while text says LSTM-OLH "still struggled". (3) No row reports a run for 3d5–3d9 reaching BKV. (4) Date format inconsistent (10/12/24 vs 11/2/2024). (5) Time-to-train for LSTM-A 3d1–3d4 (7–11 h) vs 3.3–1.4 h for LSTM-OLH. (6) The paper's Table 3 3D5 LSTM-A −33 equals the A.1 "E_min experimental" for 3d5.

## Figures
- **Fig. 1 (p. 4)** — "Deep reinforcement learning training loop. In a), we sample a batch of experience from the buffer. The batch then serves as input to the Q-network in b). Based on the output Q-value tensor, the agent makes a decision in c) to take a_{t+1} that corresponds to the greatest value of the Q-output tensor. In step d), the experience is stored in the replay memory." Image: ../figures/EPG24/p04.png
- **Fig. 2 (p. 5)** — "The input layer consists of a (N, 8, 1) tensor representing the state at a particular timestep. The reservoir is a randomly initialized weight matrix with a topology specified beforehand. The linear layers consists of a simple fully-connected feed forward neural network. The output is a (5, 1) tensor representing the Q-value or future expected total reward per action." Image: ../figures/EPG24/p05.png
- **Fig. 3 (p. 6)** — "LSTM-A architecture for protein folding. Sequential states are processed through LSTM cells, generating hidden states that are weighted by an 8-head attention mechanism. The attention output is mapped to action Q-values through a fully connected layer …" (⚠ 8-head vs text 4 heads). Image: ../figures/EPG24/p06.png
- **Fig. 4 (p. 7)** — "Least Energy Conformations for different sequences." Panels 3d1, 3d5, 3d9, A4: 3D lattice folds. Image: ../figures/EPG24/p07.png
- **Fig. 5 (p. 9)** — "Plots a) 3d1 and b) 3d5 show the minimum conformation energy as a function of episode." **Fig. 6 (p. 10)** — "Plots a) A2 and b) A4 show the minimum conformation energy as a function of episode." Images: ../figures/EPG24/p09.png, p10.png
- **Fig. 7 (p. 11)** — "Evolution of multi-head attention weights during protein structure prediction training. Each row shows the attention patterns of four attention heads at different training iterations (0, 80,000, 160,000, and 200,000). The x and y axes represent query and key positions in the protein sequence, with colors indicating attention strength (purple: 0.0 to yellow: 0.05)." Image: ../figures/EPG24/p11.png
- **Fig. B.1 (p. 14)** — "Reward histograms across the four studied architectures when training for the 3d1 sequence." **Fig. B.2** — same for 3d5. **Fig. B.3, B.4 (p. 15)** — "Loss function across the four studied architectures when training for the 3d1 / 3d5 sequence." Image: ../figures/EPG24/p14.png

## Stated limitations, open problems, future work
- "LSTM-A training becomes computationally demanding beyond 60 amino acids, while FFNN-R performance degrades significantly after length 36. Memory requirements for LSTM-A scale quadratically with sequence length" (p. 10).
- Future work: "extending the architectures to handle realistic protein force fields, incorporating additional physical constraints, optimizing the attention mechanism's efficiency for longer sequences, and exploring hybrid approaches"; linear scaling relationship between sequence length and reservoir size "merits investigation"; parallel training strategies (pp. 10–11).
- "Our implementation achieves state-of-the-art results for the HP model, though important limitations remain" (p. 10) — but see ⚠ on Table 3.

## References worth following
- [Yang et al. 2023] K. Yang, H. Huang, O. Vandans, A. Murali, F. Tian, R. H. C. Yap, L. Dai, Applying deep reinforcement learning to the HP model for protein structure prediction, Physica A 609, 128395 (2023) (see Yang22).
- Boumedine–Bouroubi, Protein folding in 3D lattice HP model using a combining cuckoo search with hill-climbing, Appl. Soft Comput. 119 (2022) (source of BKVs).
- Mnih et al., Nature 518 (2015) (DQN); Li et al., FoldingZero (NeurIPS 2018); Jaeger, Echo state network (2007); Vaswani et al. (2017); Unger–Moult (1993); Beutler–Dill (1996); Grassberger PERM (1997); Shmygelska–Hoos (2005).

## Extraction notes
- All 15 pages read. Tables 1–3 and A.1 transcribed; Table A.1 read from rotated page (text layer and image consistent). Table 1/2 sequence strings from text layer (lengths cross-checked by arithmetic for 3D1–3D4).
- Lattice relevance (key): cubic-lattice self-avoiding walks with fixed first two residues; moves F, L, R, U, D relative actions (no backward); bond angles restricted to 90°/180° (i.e., no 180° reversal except straight continuation — as stated); energy = −#HH contacts; DQN over lattice conformations. No knot content.
- ⚠ Several inconsistencies noted above (abstract vs Table 3; Table 3 vs Table A.1; 4 vs 8 heads; layer sizes).
