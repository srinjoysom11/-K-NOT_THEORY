# BKBO22 — Machine learning understands knotted polymers
- **Authors:** Anna Braghetto, Sumanta Kundu, Marco Baiesi, Enzo Orlandini (Dept. of Physics and Astronomy, University of Padova; INFN Sezione di Padova)
- **Venue / year / identifiers:** arXiv:2212.11822v1 [cond-mat.soft], 22 Dec 2022 (published later as Macromolecules 56(7):2899–2909 (2023) per CSS26's reference list; not printed on the PDF pages read)
- **File:** papers/5_ml_rl/Braghetto-Kundu-Baiesi-Orlandini_2022_ML_understands_knotted_polymers_2212.11822.pdf   **Pages:** 13
- **Text layer:** ok (heat-map numbers are in figures; Figs. 4–6 matrices read from page images at 90–110 dpi)

## Abstract
Simulated configurations of flexible knotted rings confined inside a spherical cavity are fed into long-short term memory neural networks (LSTM NNs) designed to distinguish knot types. The results show that they perform well in knot recognition even if tested against flexible, strongly confined and therefore highly geometrically entangled rings. In agreement with the expectation that knots are delocalized in dense polymers, a suitable coarse-graining procedure on configurations boosts the performance of the LSTMs when knot identification is applied to rings much longer than those used for training. Notably, when the NNs fail, usually the wrong prediction still belongs to the same topological family of the correct one. The fact that the LSTMs are able to grasp some basic properties of the ring's topology is corroborated by a test on knot types not used for training. We also show that the choice of the NN architecture is important: simpler convolutional NNs do not perform so well. Finally, all results depend on the features used for input: surprisingly, coordinates or bond directions of the configurations provide the best accuracy to the NNs, even if they are not invariant under rotations (while the knot type is invariant). Other rotational invariant features we tested are based on distances, angles, and dihedral angles.

## Notation and conventions
- (p. 2) N = number of beads (contour length) of the ring; N′ = length of the test rings (when different from the training length N = 128, "N′ ≠ N", printed as N′ in the figure captions: "Test accuracy on polymers with length N′ = 128").
- ρ = 3N/(4πR³) monomer density in a sphere of radius R; ρ_1 = 0.07, ρ_2 = 0.14, ρ_3 = 0.28 (p. 2).
- (p. 5) Accuracy A = "the fraction of correctly classified samples". Training density = rows of the 3×3 matrices; test density = columns.
- Knot types used for training: 0_1, 3_1, 4_1, 5_1, 5_2 (torus family: 3_1, 5_1; twist family: 4_1, 5_2) (p. 2, Fig. 9). Test-only unseen knots: 6_1 (twist), 7_1 (torus) (p. 9).
- Input features (p. 2–3): "coordinates" (x_i), "bonds" (x_{i+1} − x_i), "3 distances" d_i(s) = |x_{i+s} − x_i| with s = (2,5,8)N/16, "3 angles" θ_i(s) with s = (2,5,8)N/24, "3 dihedrals" φ_i(s) with s = (2,5,8)N/32; "3-all" (9×N) and "9 dihedrals" (s = (N/32)×(32/N,1,2,…,8)) (p. 7). Coordinates/bonds are not rotation invariant; distances/angles/dihedrals are.
- (p. 4) N_P = 32: padding of the first 32 feature vectors appended at positions N+1…N+32 to mimic circular periodicity; an input sample is 3 × (N + N_P).

## Numbered statements
None (no theorems). Equations (1)–(8): WCA potential (1), FENE (2), features (3)–(5), fine-graining (6), coarse-graining (7), pentagon embedding z = Σ p_k v_k (8).

## Key equations and quantitative claims outside numbered statements
- (p. 2) Simulation: bead-spring flexible ring; excluded volume via WCA potential U_WCA(r) = 4ε[(σ/r)^12 − (σ/r)^6] + ε for r ≤ r_c = 2^{1/6}σ (0 beyond); bonded beads FENE: U_FENE = U_WCA − 0.5kR_0² ln(1 − (r/R_0)²) for r ≤ R_0, ∞ otherwise, with k = 30ε/σ², R_0 = 1.6σ "chosen to avoid strand crossing". Langevin dynamics, damping γ = 1, velocity-Verlet in LAMMPS, dt = 0.001τ, m = σ = ε = T = 1; (⚠ text says "NVE ensembles" together with Langevin dynamics at temperature T, as printed).
- (p. 2) Compaction: spherical indenter force toward centre with slowly decreasing radius until target density; coordinates recorded every 10^4 simulation time steps (sampling period). Knot types preserved dynamically (strand crossing prevented).
- (p. 2) Data: 5 knot types × N = 64, 128, 256, 512 × 3 densities.
- (p. 4) Training set per density: 6 × 10^5 samples per knot type, split 80% train / 20% validation; for each knot type three independent runs generate 2×10^5 configurations each, training set = first 1.6×10^5 of each run (temporal order), validation = remainder. LSTM trained only at N = 128 (p. 5). Test: additional 5 × 10^5 configurations per knot type and density from an independent run for N′ = 64, 128, 256, 512 (p. 5).
- Training control (p. 5): learning-rate decay by factor 1/2 if validation loss does not improve for 10 epochs; early stopping after 30 epochs without improvement (weights restored from 30 epochs earlier).
- Architecture (Fig. 3 caption, p. 4): bidirectional LSTM; input sequence of N + N_P 3-vectors; first LSTM layer 64 units per direction (128 total); then 2 LSTM layers of 128 units each; global maximum pooling over sequence length giving F = 128 neurons; dense layers of 64 and 5 units; softmax on the last; leaky ReLU on the others; dropout 20% in the feed-forward part. Scale-dependent features normalised per ring (subtract mean, divide by std). Optimizer, learning rate, batch size and total epochs are not stated in the pages read.
- Result, same length N′ = 128 (Fig. 4, p. 5): accuracy A close to 1 for coordinates, bonds, dihedrals; "0.98 ≤ A ≤ 1 for the bond features (best case) and 0.82 ≤ A ≤ 0.93 for 3 distances (worst case)" off-diagonal; "Quite remarkably, the accuracy is sufficiently high even for the most extreme case" training ρ_1 → test ρ_3 (0.96 coordinates, 0.98 bonds).
- Result, different length, no rescaling (Fig. 5, pp. 5–6): N′ = 64: coordinates 0.51 < A < 0.72 (matrix 0.51–0.72), bonds 0.73 < A < 0.78; other features unsatisfactory (≈ 0.28–0.43); N′ = 256 and 512: ≈ random (A ∼ 0.2). In Vandans et al. [51] tests on shorter rings were more satisfactory, but their rings were semiflexible (less entangled) and trained at N = 100, tested at 80, 60.
- Rescaling (pp. 6–7): fine-graining for N′ = 64: insert a bead between each consecutive pair, x_i → X_{2i−1}, ½(x_i + x_{i+1}) → X_{2i}; coarse-graining for N′ = 256: replace each pair of contiguous beads by its midpoint ½(x_{2i−1} + x_{2i}) → X_i; N′ = 512: iterate twice. After rescaling (Fig. 6): N′ = 64 best with 3 dihedrals (0.99 ≤ A ≤ 1); N′ = 256 coordinates A from 0.20 to > 0.75 and up to 0.95 (train ρ_1, test ρ_1); N′ = 512 coordinates A = 0.80 for training at ρ_1 (all test densities in the left column... as printed "irrespective of the density at which the testing rings have been sampled"; the matrix shows 0.80/0.65/0.36 in the first row) — ⚠ the text states 80% "irrespective of the density at which the testing rings have been sampled", while the Fig. 6 row for training ρ_1 reads 0.80, 0.65, 0.36 across test densities ρ_1, ρ_2, ρ_3; the 0.80 is constant down the first column (training density varying). Accuracy higher when training at smallest density ρ_1.
- Caveats on coarse-graining (p. 6): information may be lost; "the topology of the original ring can change by an effective strand passage"; argument via knot-size scaling L ∼ N valid only in the large-N limit.
- Rotational-invariant larger sets (Fig. 7, pp. 7–8): "3-all" and "9 dihedrals" bring N′ = 128 accuracy to values comparable with or greater than coordinates/bonds; worst case training ρ_1, test ρ_3: A = 0.94 ("3 all") and 0.96 ("9 dihedrals"); without rescaling still poor at N′ ≠ N; with rescaling 100% at N′ = 64 and great improvement at 256, 512.
- Mistake structure (Sec. IV, pp. 8–9, Fig. 8; N′ = N = 128, ρ_1 for train and test): confusion mostly along segments joining knots of the same family. For true 5_1 recognised 99.4% (most remaining confusion with 3_1); for true 5_2 99.8% correct (confusion mostly with 4_1; also with 0_1); for true 3_1 99.2% correct (confusion with 0_1, 4_1, 5_1). Features "3 distances" and "3 dihedrals" show larger spread; "9 dihedrals" improves.
- Unseen knots (p. 9–10): with the best features (coordinates, bonds, 3 dihedrals) on average 95.6% of 6_1 rings are classified as 4_1 and 98.7% of 7_1 rings as 5_1 ("general knot family indicator").
- CNN comparison (Appendix, pp. 10–11, Fig. 10): lower accuracy than LSTM for all lengths; best feature = 3 dihedrals, worst = bonds; limitation attributed to finite kernel size.

## Methods / algorithms
1. (p. 2) Simulate flexible ring polymers, FENE/WCA bead-spring, Langevin dynamics in LAMMPS, compacted in spherical cavity by indenter to ρ_1–ρ_3; five knot types.
2. (p. 2–4) Compute features per ring centred at centre of mass: coordinates, bonds, distances, angles, dihedrals with arc-length offsets s ∼ N; normalise; periodic padding of 32 extra vectors.
3. (p. 4) Bidirectional LSTM (as above) with global max-pooling to remove N dependence (so the same trained network accepts any length N′ in principle) and softmax over 5 knot classes; categorical classification (loss function not named in the pages read; ⚠ not stated).
4. (p. 4–5) Training at N = 128 only, one model per feature set and per training density; validation split by simulation time; LR decay/early stopping.
5. (p. 5–7) Evaluate on unseen configurations at N′ ∈ {64,128,256,512}, densities ρ_1–ρ_3; with and without rescaling by fine/coarse-graining to N = 128.
6. (p. 8–9) Visualise softmax outputs on pentagon z = Σ p_k v_k and confusion matrices; test on unseen knots 6_1, 7_1.
Verification of labels: the knot type is known by construction (initial knot type preserved dynamically); no independent invariant computation reported (⚠ not stated).

## Tables
No numbered tables; accuracy matrices are in figures. Transcribed from page images (rows = training density ρ_1,ρ_2,ρ_3; columns = test density ρ_1,ρ_2,ρ_3).

**Fig. 4 data (p. 5; read at 110 dpi), N′ = N = 128, LSTM test accuracy:**

| feature | train ρ_1 (test ρ_1, ρ_2, ρ_3) | train ρ_2 | train ρ_3 |
|---|---|---|---|
| coordinates | 1.00, 0.99, 0.96 | 0.99, 0.99, 0.97 | 0.90, 0.98, 0.99 |
| bonds | 1.00, 0.99, 0.98 | 1.00, 1.00, 0.99 | 0.98, 0.99, 0.99 |
| 3 distances | 0.94, 0.92, 0.82 | 0.93, 0.94, 0.87 | 0.87, 0.92, 0.91 |
| 3 angles | 0.96, 0.94, 0.83 | 0.95, 0.95, 0.90 | 0.92, 0.95, 0.93 |
| 3 dihedrals | 0.98, 0.96, 0.89 | 0.97, 0.97, 0.93 | 0.97, 0.97, 0.95 |

**Fig. 5 data (p. 6; read at 90 dpi), no rescaling:**

| N′ | feature | train ρ_1 | train ρ_2 | train ρ_3 |
|---|---|---|---|---|
| 64 | coordinates | 0.58, 0.54, 0.51 | 0.66, 0.62, 0.58 | 0.72, 0.68, 0.62 |
| 64 | bonds | 0.75, 0.74, 0.73 | 0.75, 0.75, 0.74 | 0.78, 0.78, 0.78 |
| 64 | 3 distances | 0.30, 0.30, 0.30 | 0.28, 0.29, 0.31 | 0.29, 0.30, 0.30 |
| 64 | 3 angles | 0.32, 0.34, 0.36 | 0.34, 0.36, 0.38 | 0.30, 0.31, 0.33 |
| 64 | 3 dihedrals | 0.42, 0.39, 0.33 | 0.43, 0.42, 0.38 | 0.42, 0.41, 0.40 |
| 256 | coordinates | 0.20, 0.20, 0.20 | 0.20, 0.20, 0.20 | 0.20, 0.20, 0.20 |
| 256 | bonds | 0.22, 0.22, 0.24 | 0.21, 0.21, 0.22 | 0.21, 0.21, 0.21 |
| 256 | 3 distances | 0.21, 0.22, 0.22 | 0.21, 0.21, 0.21 | 0.22, 0.22, 0.22 |
| 256 | 3 angles | 0.36, 0.27, 0.23 | 0.37, 0.31, 0.26 | 0.35, 0.32, 0.28 |
| 256 | 3 dihedrals | 0.30, 0.30, 0.28 | 0.29, 0.28, 0.27 | 0.28, 0.27, 0.26 |
| 512 | coordinates | 0.20, 0.20, 0.20 | 0.20, 0.20, 0.20 | 0.20, 0.20, 0.20 |
| 512 | bonds | 0.20, 0.20, 0.20 | 0.20, 0.20, 0.20 | 0.20, 0.20, 0.20 |
| 512 | 3 distances | 0.21, 0.20, 0.20 | 0.20, 0.20, 0.20 | 0.21, 0.20, 0.20 |
| 512 | 3 angles | 0.25, 0.22, 0.20 | 0.26, 0.22, 0.20 | 0.28, 0.24, 0.21 |
| 512 | 3 dihedrals | 0.21, 0.21, 0.20 | 0.21, 0.21, 0.20 | 0.21, 0.21, 0.20 |

**Fig. 6 data (p. 7; read at 90 dpi, small print; treat ± 0.01), after rescaling to N = 128:**

| N′ | feature | train ρ_1 | train ρ_2 | train ρ_3 |
|---|---|---|---|---|
| 64 | coordinates | 1.00, 1.00, 1.00 | 1.00, 1.00, 1.00 | 0.97, 0.99, 1.00 |
| 64 | bonds | 1.00, 1.00, 1.00 | 1.00, 1.00, 1.00 | 0.96, 0.97, 0.99 |
| 64 | 3 distances | 0.98, 0.98, 0.98 | 0.95, 0.96, 0.97 | 0.84, 0.87, 0.92 |
| 64 | 3 angles | 1.00, 1.00, 0.99 | 1.00, 1.00, 1.00 | 0.98, 0.99, 1.00 |
| 64 | 3 dihedrals | 1.00, 1.00, 1.00 | 1.00, 1.00, 1.00 | 1.00, 0.99, 0.99 |
| 256 | coordinates | 0.95, 0.89, 0.76 | 0.93, 0.90, 0.78 | 0.86, 0.93, 0.87 |
| 256 | bonds | 0.95, 0.90, 0.78 | 0.95, 0.92, 0.85 | 0.93, 0.93, 0.87 |
| 256 | 3 distances | 0.74, 0.61, 0.44 | 0.75, 0.64, 0.46 | 0.75, 0.70, 0.54 |
| 256 | 3 angles | 0.78, 0.64, 0.45 | 0.79, 0.70, 0.54 | 0.78, 0.74, 0.59 |
| 256 | 3 dihedrals | 0.85, 0.73, 0.53 | 0.85, 0.78, 0.62 | 0.84, 0.80, 0.67 |
| 512 | coordinates | 0.80, 0.65, 0.36 | 0.80, 0.66, 0.36 | 0.80, 0.74, 0.38 |
| 512 | bonds | 0.79, 0.66, 0.33 | 0.78, 0.66, 0.30 | 0.76, 0.64, 0.25 |
| 512 | 3 distances | 0.48, 0.33, 0.20 | 0.48, 0.33, 0.20 | 0.53, 0.37, 0.20 |
| 512 | 3 angles | 0.52, 0.36, 0.23 | 0.56, 0.40, 0.23 | 0.57, 0.42, 0.22 |
| 512 | 3 dihedrals | 0.60, 0.41, 0.26 | 0.64, 0.47, 0.26 | 0.64, 0.49, 0.25 |

(Figs. 7, 8 and 10 matrices transcribed from the page images on 2026-11-12; see wiki/data/BKBO22_fig7_fig8_fig10.csv.)

## Figures
- **Fig. 1 (p. 3)** — "Each row shows sampled configurations of knotted rings hosting one of the five different knots considered in this study, see the first column. The other columns refer to rings with: N = 128 sampled at ρ_1, N = 128 at ρ_3 and N = 256 at ρ_3." Image: ../figures/BKBO22/p03.png
- **Fig. 2 (p. 3)** — "Example of input features for a configuration with knot 3_1, N = 128, ρ = ρ_3 = 0.28: (a) coordinates, (b) bond directions, (c) 3 distances, (d) 3 angles, and (e) 3 dihedral angles. For the last three cases, the legend shows the values of the curvilinear distance s."
- **Fig. 3 (p. 4)** — "Sketch of the unrolled bidirectional LSTM used in this work …" Image: ../figures/BKBO22/p04.png
- **Fig. 4 (p. 5)** — "Test accuracy on polymers with length N′ = 128, as those used for training. …" Image: ../figures/BKBO22/p05.png
- **Fig. 5 (p. 6)** — "Test accuracy as in Fig. 4 but for configurations with N′ = 64 (first row), 256 (middle row), and 512 (bottom row)." Image: ../figures/BKBO22/p06.png
- **Fig. 6 (p. 7)** — "Test accuracy as in Fig. 5, but after the rescaling of the chain length N′ to N = 128 as described in the text." Image: ../figures/BKBO22/p07.png
- **Fig. 7 (p. 8)** — "LSTM accuracy after its training with 9 × (N + N_P) rotational invariant features for rings of length N = 128 …: (a) Test accuracy for N = 128 … training at the smaller density ρ_1 and testing at the highest density ρ_3 appears to be the worse case (A = 0.94 for '3 all' and A = 0.96 for '9 dihedrals'), however, in all cases the accuracy is high. (b) The same for N′ = 64, 256, and 512. Generalization to different lengths does not work in this case but can be fixed: (c) shows the improved accuracy for NN tested with rescaled configurations." Image: ../figures/BKBO22/p08.png *Data (2026-11-12, page images):* all grids in `wiki/data/BKBO22_fig7_fig8_fig10.csv` (long format; Fig. 7 and Fig. 10 accuracy grids, Fig. 8 5×5 confusion matrices with row = true, column = prediction).
- **Fig. 8 (p. 9)** — "Each row corresponds to a feature and contains the confusion matrix and the knot space for each of the five considered knots, for simulations with N′ = N = 128 and ρ_1 = 0.07 for train and test. We show results for (a) coordinates (they are similar for bond directions), 3 distances (they are similar for 3 angles), 3 dihedral angles, and 9 dihedral angles." Image: ../figures/BKBO22/p09.png *Data (2026-11-12, page images):* all grids in `wiki/data/BKBO22_fig7_fig8_fig10.csv` (long format; Fig. 7 and Fig. 10 accuracy grids, Fig. 8 5×5 confusion matrices with row = true, column = prediction).
- **Fig. 9 (p. 9)** — "Sketch of families of knot types: simple torus knots and twist knots." **Fig. 10 (p. 11)** — "For a CNN trained with various features (columns) of configurations with N = 128: (a) test accuracy for N′ = 128 …; (b) the same for N′ = 64, 256, and 512 after rescaling…" Image: ../figures/BKBO22/p11.png *Data (2026-11-12, page image):* grids in `wiki/data/BKBO22_fig7_fig8_fig10.csv` (figure = Fig10, panels a = N′ = 128, b = N′ = 64, 256, 512).

## Stated limitations, open problems, future work
- "Clearly, a full understanding of how ML can recognize topological (i.e. non local) patterns within entangled closed curves and of which NN architecture or set of features can furnish the best performance is still lacking." (p. 10)
- The ML approach cannot identify knots with certainty, only furnish a probability; "probably not competitive … if the training procedure has to be carried out for any system under investigation" (p. 2).
- Coarse-graining may lose information or change topology by effective strand passage (p. 6).
- Using non-invariant features (coordinates, bonds) departs from "good practice of feeding NNs with inputs respecting the underlying symmetries" (p. 10); other invariant features (e.g., local density along ring [65]) suggested.
- Suggested future: NNs as "general knot family indicator" (p. 10).

## References worth following
- [51] Vandans, Yang, Wu, Dai, Identifying knot types of polymer conformations by machine learning, PRE 101, 022502 (2020) (= Vandans20).
- [52] Davies et al., Advancing mathematics by guiding human intuition with AI, Nature 600 (2021); [55] Gukov et al., Learning to unknot (2021).
- [60] Hochreiter–Schmidhuber LSTM; [58] LAMMPS (Plimpton); [56,57] Grest–Kremer FENE.
- [4] Whittington–van Rensburg, The knot probability in lattice polygons (1990) (lattice context cited in intro); [3] Orlandini–Whittington, Statistical topology of closed curves, Rev. Mod. Phys. 79 (2007).
- [13] Marenduzzo et al. PNAS 2013; [31] Tubiana–Orlandini–Micheletti 2011 (knot delocalisation under confinement); [65] Sleiman et al., Geometric predictors of knotted and linked arcs, ACS Polymers Au (2022).

## Extraction notes
- All 13 pages read (pp. 11–13 references/CNN). Figs. 4–6 matrices transcribed from page images (Fig. 4 at 110 dpi, Figs. 5–6 at 90 dpi, so small-font values in Fig. 6 are ± 0.01 uncertain). Figs. 7, 8, 10 not transcribed.
- Lattice relevance: off-lattice (FENE bead-spring), but cites lattice-polygon knotting (ref [4]); knot localisation/delocalisation under confinement; input coordinate sequences analogous to Vandans20.
- ⚠ Text on p. 6 (80% "irrespective of density") vs Fig. 6 numbers; ⚠ "NVE ensembles" with Langevin dynamics; ⚠ loss function/optimizer/epochs not stated.
