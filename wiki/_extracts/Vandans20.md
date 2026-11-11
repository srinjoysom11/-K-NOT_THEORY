# Vandans20 — Identifying knot types of polymer conformations by machine learning
- **Authors:** Olafs Vandans, Kaiyuan Yang, Zhongtao Wu, Liang Dai (City University of Hong Kong; National University of Singapore; The Chinese University of Hong Kong; Shenzhen Research Institute, CityU). "O.V. and K.Y. contributed equally."
- **Venue / year / identifiers:** Physical Review E 101, 022502 (2020); DOI 10.1103/PhysRevE.101.022502; received 14 November 2019, accepted 14 January 2020, published 11 February 2020; Editors' Suggestion, Featured in Physics.
- **File:** papers/5_ml_rl/Vandans-et-al_2020_Identifying_knot_types_polymers_ML_PRE.pdf   **Pages:** 10
- **Text layer:** ok (formulas B1–B5 garbled in text layer; read from page image)

## Abstract
We investigate the use of artificial neural networks (NNs) as an alternative tool to current analytical methods for recognizing knots in a given polymer conformation. The motivation is twofold. First, it is of interest to examine whether NNs are effective at learning the global and sequential properties that uniquely define a knot. Second, knot classification is an important and unsolved problem in mathematical and physical sciences, and NNs may provide insights into this problem. Motivated by these points, we generate millions of polymer conformations for five knot types: 0, 3₁, 4₁, 5₁, and 5₂, and we design various NN models for classification. Our best model achieves a five-class classification accuracy of above 99% on a polymer of 100 monomers. We find that the sequential modeling ability of recurrent NNs is crucial for this result, as it outperforms feed-forward NNs and successfully generalizes to differently sized conformations as well. We present our methods and suggest that deep learning may be used in specific applications of knot detection where some error is permissible. Hopefully, with further development, NNs can offer an alternative computational method for knot identification and facilitate knot research in mathematical and physical sciences.

## Notation and conventions
- **a** (p. 2): bond length, used as the unit length; "The hardcore diameter D_bead equals the bond length, a".
- **L_polymer** (p. 2): number of monomers (60, 80, 100). **D**: diameter of spherical confinement (9a, 10a, 11a for L = 60, 80, 100). **L_p**: persistence length, 4a in the main text, 2a in App. C.
- **N_data** (p. 5–6, Table I footnote a): dataset size = "Number of polymers per knot type". **N_knot** = number of knot classes (= 5).
- **N_cross** (Fig. 9, p. 7): "the minimum crossing number for a knot type, e.g., 5 for the 5₂ knot".
- **Accuracy** (p. 4): "the sum of the diagonal elements divided by the total sum of the confusion matrix". Confusion matrix: "each column represents the instances of a predicted knot type while each row represents the ground truth knot type."
- Knot labels: 0 (unknot), 3₁, 4₁, 5₁, 5₂. Knot type of training samples determined by the Alexander polynomial [49] (p. 2).
- FC(p): fully connected layer of p neurons; LSTM(p): LSTM layer with p-dimensional output; C = number of classes (p. 3).

## Numbered statements
None (no theorems). Equations (B1)–(B5) transcribed below.

## Key equations and quantitative claims outside numbered statements
- (B1) Sigmoid: 1 / (1 + exp(−Σ_i w_i x_i − b)) (p. 8).
- (B2) ReLU: max(0, Σ_i w_i x_i − b) (p. 8). ⚠ sign of b as printed differs between B1 and B2 (−b in both inside the expression; neuron in Fig. 10 is a(wᵀx + b)).
- (B3) Loss: L(y, ŷ) = − Σ_{c=1}^{M} ŷ_c ln(y_c), "where M is the number of class labels c, ŷ_c is the predicted probability of the label belonging to class c, and y is true probability distribution" (p. 8). ⚠ as printed the log is on the true distribution.
- Cost C = (1/N) Σ_{i=1}^{N} L(y_i, ŷ_i); updates (B4) w → w′ = w − η∇C_w, (B5) b → b′ = b − η∇C_b; optimizers Adam and RMSprop; "considered trained when the weight updates become sufficiently small" (p. 8).
- Simulation (p. 2): bead model with hard-core repulsion; bending potential giving persistence length 4a; spherical confinement D = 9a/10a/11a for L = 60/80/100; crankshaft moves (global, can change knot type); knot-type self-correlation time ≈ 5.4 × 10³ MC steps; one conformation saved every 10⁴ steps; 2 × 10⁵ or 2 × 10⁶ conformations per knot type.
- Knot-type distribution in simulation (L = 100, L_p = 4a, D = 11a; Fig. 9, p. 7): 0: 79.2%, 3₁: 15.0%, 4₁: 3.0%, 5₁: 0.9%, 5₂: 1.3%.
- Data split (p. 4): 72% training / 18% holdout validation / 10% test; best-validation model saved.
- Headline (p. 5–6): N_knot = 5, L = 100, N_data = 2 × 10⁶: RNN 99.59% vs feed-forward 71.25% (validation accuracy, Table I).
- Length dependence (RNN, N_data = 2 × 10⁵): 98.51% (L=60), 95.85% (L=80), 91.66% (L=100) (p. 6).
- Data-size dependence (RNN, L = 100): 91.66% → 99.59% as N_data goes 2 × 10⁵ → 2 × 10⁶ (p. 6).
- Fig. 6(a) FFNN per-class test accuracy "between 67.6% and 75.3%"; Fig. 6(b) RNN "consistently at above 99%" on 1 million unseen test data (p. 4).
- Generalization (p. 6): RNN trained on L = 100 applied unchanged to L = 60 → accuracy "above 98%", L = 80 → "above 97%" (1 million test polymers each).
- Control experiment (p. 6): 2 million 3₁ conformations split randomly into two dummy-labelled groups → NN stays at ∼50% (random guess); Knot0-vs-Knot31 (1M + 1M) → "above 95%". Each epoch trains on 1 600 000 and validates on 400 000 samples.
- Timing (pp. 6–7): Alexander polynomial ≈ 3 × 10⁻³ s per L = 100 conformation (single CPU core); RNN ≈ 1.5 × 10⁻⁴ s (many GPU cores); "RNN is about 20 times faster".
- Bending stiffness (App. C, p. 8): 20 000 conformations per knot type with L = 100, L_p = 2a; RNN trained on L_p = 4a gives "above 99% for every knot type".

## Methods / algorithms
1. **Data generation (p. 2, App. A):** Monte Carlo of a single circular bead-chain polymer (hard-core beads, diameter = bond length a), bending potential (L_p = 4a), spherical confinement to raise knotting probability; crankshaft trial moves; save every 10⁴ steps; knot type via Alexander polynomial; 5 classes {0, 3₁, 4₁, 5₁, 5₂}.
2. **Preprocessing / state representation (p. 2–3):** sequence of XYZ coordinates converted to increments from the previous coordinate (Δx, Δy, Δz per bond), e.g. [0, 0.8, 0.5, 1.4, 2.2] → [+0.8, −0.3, +0.9, +0.8]; bond length unit so values are bounded ("akin to normalization").
3. **FFNN (p. 3, Fig. 4):** flatten coordinates → FC(p), FC(q), …, FC(r) → output FC(C) with sigmoid-activated neurons performing softmax over C classes. Nearly identical to setup of Wei–Melko–Chen [46].
4. **RNN (p. 3–4, Fig. 5):** stacked LSTM layers: LSTM(p) takes 3-dim input per step; LSTM(q) bidirectional; … LSTM(r); final FC(C) sigmoid/softmax on hidden state of the final recurrent layer's T-th cell. Number of steps not intrinsic to the model → applies to other lengths. Bidirectional motivated by knot type being invariant under reversing the sequence.
5. **Implementation (p. 4):** Keras with TensorFlow 2.0 backend, GPU. Loss: categorical cross-entropy (B3); activation ReLU; optimizers Adam / RMSprop (p. 8). Layer widths (p, q, r) and hyper-parameters such as learning rate/batch size/epochs are not given beyond parameter counts in Table I.
6. **Evaluation (p. 4):** confusion matrix and overall accuracy on test set.

## Tables
**Table I (p. 5).** "Polymer length, dataset size, and design of the neural network. Dataset size is the number of polymers per knot type. Models were trained using 72% of the dataset, with the training progress monitored on the 18% hold-out validation dataset. All models were trained to classify five knot types: knot 0, 3₁, 4₁, 5₁, and 5₂." (checked against page image; text layer misaligns rows)

| Polymer Length | Dataset size^a | NN architecture | Number of parameters | Training accuracy | Validation accuracy |
|---|---|---|---|---|---|
| 60 | 200 000 | Feed-forward | 428 685 | 81.62% | 80.23% |
| 60 | 200 000 | Recurrent | 862 625 | 99.17% | **98.51%** |
| 80 | 200 000 | Feed-forward | 464 685 | 50.00% | 43.38% |
| 80 | 200 000 | Recurrent | 862 625 | 98.20% | **95.85%** |
| 100 | 200 000 | Feed-forward | 2 073 185 | 48.73% | 47.59% |
| 100 | 2 000 000 | Feed-forward | 1 696 885 | 72.05% | 71.25%^b |
| 100 | 200 000 | Recurrent | 729 415 | 98.15% | 91.66% |
| 100 | 2 000 000 | Recurrent | 889 385 | 99.90% | **99.59%**^c |

a Number of polymers per knot type, N_knot = 5. b Test dataset evaluation results for this feed-forward model shown in Fig. 6(a). c Test dataset evaluation results for this RNN model shown in Fig. 6(b).

**Confusion matrices transcribed from figures** (rows = true label, columns = predicted label; axis order as printed in the figure: 0, 3₁, 4₁, 5₂, 5₁; cells "fraction (count)"; read at 200 dpi).

Fig. 6(a) FFNN, L = 100, test (p. 4):

| true \ pred | 0 | 3₁ | 4₁ | 5₂ | 5₁ |
|---|---|---|---|---|---|
| 0 | 0.715 (143044) | 0.184 (36828) | 0.071 (14149) | 0.019 (3806) | 0.011 (2173) |
| 3₁ | 0.058 (11648) | 0.676 (135173) | 0.111 (22276) | 0.075 (14932) | 0.080 (15971) |
| 4₁ | 0.022 (4323) | 0.074 (14869) | 0.734 (146751) | 0.149 (29709) | 0.022 (4348) |
| 5₂ | 0.004 (754) | 0.043 (8699) | 0.120 (23948) | 0.682 (136398) | 0.151 (30201) |
| 5₁ | 0.001 (134) | 0.055 (10927) | 0.018 (3575) | 0.174 (34768) | 0.753 (150596) |

Fig. 6(b) RNN, L = 100, test (p. 4):

| true \ pred | 0 | 3₁ | 4₁ | 5₂ | 5₁ |
|---|---|---|---|---|---|
| 0 | 0.995 (199030) | 0.003 (619) | 0.001 (277) | 0.000 (62) | 0.000 (12) |
| 3₁ | 0.002 (369) | 0.994 (198829) | 0.001 (100) | 0.002 (361) | 0.002 (341) |
| 4₁ | 0.001 (158) | 0.000 (80) | 0.998 (199590) | 0.001 (170) | 0.000 (2) |
| 5₂ | 0.000 (34) | 0.001 (262) | 0.001 (139) | 0.995 (199087) | 0.002 (478) |
| 5₁ | 0.000 (4) | 0.001 (271) | 0.000 (8) | 0.002 (478) | 0.996 (199239) |

Fig. 7 left, RNN trained L = 100 applied to L = 60 (p. 5):

| true \ pred | 0 | 3₁ | 4₁ | 5₂ | 5₁ |
|---|---|---|---|---|---|
| 0 | 0.984 (196871) | 0.012 (2365) | 0.003 (587) | 0.001 (144) | 0.000 (33) |
| 3₁ | 0.001 (247) | 0.988 (197555) | 0.000 (43) | 0.004 (788) | 0.007 (1366) |
| 4₁ | 0.001 (157) | 0.000 (5) | 0.999 (199782) | 0.000 (56) | 0.000 (0) |
| 5₂ | 0.000 (76) | 0.002 (499) | 0.000 (45) | 0.995 (199044) | 0.002 (336) |
| 5₁ | 0.000 (11) | 0.002 (494) | 0.000 (3) | 0.002 (320) | 0.996 (199172) |

Fig. 7 right, RNN trained L = 100 applied to L = 80 (p. 5):

| true \ pred | 0 | 3₁ | 4₁ | 5₂ | 5₁ |
|---|---|---|---|---|---|
| 0 | 0.972 (194408) | 0.016 (3270) | 0.008 (1609) | 0.003 (600) | 0.001 (113) |
| 3₁ | 0.001 (271) | 0.980 (196014) | 0.001 (211) | 0.008 (1591) | 0.010 (1913) |
| 4₁ | 0.001 (116) | 0.000 (69) | 0.997 (199304) | 0.002 (493) | 0.000 (18) |
| 5₂ | 0.000 (20) | 0.000 (99) | 0.000 (76) | 0.996 (199213) | 0.003 (592) |
| 5₁ | 0.000 (0) | 0.001 (105) | 0.000 (3) | 0.002 (492) | 0.997 (199400) |

Fig. 11, RNN trained L_p = 4a applied to L_p = 2a, L = 100 (p. 8):

| true \ pred | 0 | 3₁ | 4₁ | 5₂ | 5₁ |
|---|---|---|---|---|---|
| 0 | 0.996 (19917) | 0.003 (57) | 0.001 (21) | 0.000 (2) | 0.000 (3) |
| 3₁ | 0.004 (84) | 0.990 (19795) | 0.001 (13) | 0.003 (57) | 0.003 (50) |
| 4₁ | 0.002 (40) | 0.001 (13) | 0.996 (19915) | 0.002 (32) | 0.000 (0) |
| 5₂ | 0.000 (6) | 0.004 (71) | 0.002 (44) | 0.990 (19790) | 0.004 (89) |
| 5₁ | 0.000 (2) | 0.004 (80) | 0.000 (0) | 0.004 (83) | 0.992 (19835) |

## Figures
- **Fig. 1 (p. 2)** — "Two visual representations of the same circular polymer conformation in simulation. The task of this work is to recognize knots in such a circular polymer conformation. (a) Touching-bead model of a circular polymer in simulation. (b) The representation of a polymer conformation by rods." *What it shows:* coloured bead chain and the same chain drawn as tubes. Image: ../figures/Vandans20/p02.png
- **Fig. 2 (p. 2)** — "Five knot types that are to be classified. The five diagrams at the top display the simple representations of these five knot types. The five diagrams at the bottom are examples of conformations generated by our Monte Carlo simulations. The knot types of these conformations are usually too complicated to be identified visually, and we train neural networks to recognize knots in these circular polymers." *What it shows:* ideal diagrams of 0, 3₁, 4₁, 5₁, 5₂ above sample simulated conformations. Image: ../figures/Vandans20/p02.png
- **Fig. 3 (p. 3)** — "Left: An example of polymer conformation with L_polymer = 100. Right: The inputs of this conformation for neural networks. Δx, Δy, Δz represent the changes in monomer positions in the x, y, and z directions at every step, e.g., from the fifth to the sixth monomer." *What it shows:* 3D plot of a 5₂ conformation and three traces of Δ ∈ [−1, 1] vs segment index 0–100. Image: ../figures/Vandans20/p03.png
- **Fig. 4 (p. 3)** — "The feed-forward architecture used in this work. 3D coordinates are flattened and sent through layers of p, q, …, r fully connected neurons, abbreviated FC(p), FC(q), FC(r), etc. The output layer contains sigmoid-activated neurons for C classes, performing the softmax operation to output class probabilities for y_c. Please see Appendix B for technical details on neural networks." Image: ../figures/Vandans20/p03.png
- **Fig. 5 (p. 3)** — "LSTM-based recurrent neural network used in our work. Input x_i^{(t)} represents the tth step of input sequence x_i. The first layer of LSTM(p) cells accepts three-dimensional inputs, and produces p-dimensional outputs, which are passed downstream. The LSTM(q) layer is bidirectional, which scans the sequence forward and backward. Data flow from layer to layer, as well as between cells within layers, capturing sequentiality. The last layer contains sigmoid neurons, outputting C class probabilities y_c, basing its predictions on the hidden state of the final recurrent layer's Tth cell." Image: ../figures/Vandans20/p03.png
- **Fig. 6 (p. 4)** — "Feed-forward and RNN models trained with polymers of length L_polymer = 100 were used to predict five knot types on 1 million unseen test data. … (a) The feed-forward network is able to predict with accuracy between 67.6% and 75.3%; (b) the RNN model is able to classify the polymers to their correct knot types consistently at above 99%." *What it shows:* two 5×5 confusion matrices (transcribed above). Image: ../figures/Vandans20/p04.png
- **Fig. 7 (p. 5)** — "The LSTM-based RNN model from Fig. 6(b) generalizing to predict knot types on polymers of variable length. The model was trained using polymer length L_polymer = 100 and was asked to predict knot type labels on 1 million L_polymer = 60 polymers and 1 million L_polymer = 80 polymers. … Left is the confusion matrix for L_polymer = 60 and right is for L_polymer = 80, and both generalizations yield good accuracy." Image: ../figures/Vandans20/p05.png
- **Fig. 8 (p. 6)** — "Comparison of a real classification and a control experiment. Knot0-Knot31 refers to the data set of 1 million conformations of unknot and 1 million conformations of knot 3₁ (a real classification). Knot31-Knot31 refers to the data of 2 million conformations of knot 3₁ with two dummy labels (a control experiment). An epoch is an iteration over the entire training and validation data. Each epoch trains on 1 600 000 samples and validates on 400 000 samples." *What it shows:* accuracy vs epochs (0–50): Knot0–Knot31 rises from ~0.6 to ~0.97 (val) / ~0.98 (train) by ~20 epochs; control curves flat at 0.5. Image: ../figures/Vandans20/p06.png
- **Fig. 9 (p. 7)** — "Top: Evolution of the crossing number of the knot type, N_cross, during the Monte Carlo simulation. Here, N_cross represents the minimum crossing number for a knot type, e.g., 5 for the 5₂ knot. Middle: The autocorrelation of N_cross as a function of the simulation time. The correlation time is approximately 5.4 × 10³ steps. Bottom: The distribution of knot types in our simulation of the polymer L = 100 and L_p = 4a confined in a sphere with a diameter of D = 11a." *What it shows:* N_cross trace over 3 × 10⁷ MC steps (values 0–6); exponential-looking autocorrelation decay to ~0.07 at 2 × 10⁴ steps, annotated "correlation time ≈ 5400 MC steps"; bar chart 79.2/15.0/3.0/0.9/1.3%. Image: ../figures/Vandans20/p07.png
- **Fig. 10 (p. 8)** — "The neuron calculates a weighted sum of the inputs, and passes the result through a nonlinear activation function a(wᵀx + b), to scale the output in the [0, 1] range. Many neurons are connected together in a neural network." Image: ../figures/Vandans20/p08.png
- **Fig. 11 (p. 8)** — "The confusion matrix of applying the RNN model trained from the conformations of L_p = 4a to the conformations with L_p = 2a." Image: ../figures/Vandans20/p08.png

## Stated limitations, open problems, future work
- "we … suggest that deep learning may be used in specific applications of knot detection where some error is permissible" (abstract, p. 1).
- "We were not certain whether our NN learns the real topological attributes of a knot, or if it is just memorizing the data or picking up features other than the knot type, e.g., conformational size." Control experiment addresses this "to some extent" (p. 6).
- "accuracy decreases as polymer length grows … the conformation space grows rapidly" (p. 6).
- "it is useful to know how many conformations are needed in training to achieve a threshold accuracy for a given polymer length and the number of knot types" (p. 6).
- Conjecture (interpretation, p. 6): "the multiple layers of our LSTM models learn a hierarchical representation of a polymer conformation as composed of smaller curves and shape artifacts"; and differences-of-positions input "likely … simplifies input space".
- "Knot classification is still an unsolved problem, particularly for complex knots. In this work, the trained NN is only capable of identifying simple knots with limited polymer lengths. Hopefully, future studies can extend the capability" (p. 7).
- Timing comparison is not like-for-like: "the RNN model is parallelized and runs on many GPU cores, while the computation of the Alexander polynomials runs on a single CPU core" (p. 7).

## References worth following
- [46] Q. Wei, R. G. Melko, J. Z. Y. Chen, Identifying polymer states by machine learning, Phys. Rev. E 95, 032504 (2017).
- [49] M. Frank-Kamenetskii, A. Vologodskii, Topological aspects of the physics of polymers, Sov. Phys. Usp. 24, 679 (1981).
- [50–53] L. Dai, C. B. Renner, P. S. Doyle, Metastable tight knots in semiflexible chains, Macromolecules 47, 6135 (2014); Origin of Metastable Knots in Single Flexible Chains, PRL 114, 037801 (2015); Metastable knots in confined semiflexible chains, Macromolecules 48, 2812 (2015); L. Dai, P. S. Doyle, Universal knot spectra for confined polymers, Macromolecules 51, 6327 (2018).
- [56] S. Hochreiter, J. Schmidhuber, Long short-term memory, Neural Comput. 9, 1735 (1997).
- [57] M. Schuster, K. K. Paliwal, Bidirectional recurrent neural networks, IEEE Trans. Signal Proc. 45, 2673 (1997).
- [58] A. Graves, J. Schmidhuber, Framewise phoneme classification with bidirectional LSTM…, Neural Netw. 18, 602 (2005).
- [28,29] W. Haken, Theorie der Normalflächen, Acta Math. 105, 245 (1961).

## Extraction notes
- All 10 pages read (pp. 9–10 references). Table I verified cell-by-cell against page image (text layer scrambles row alignment). Confusion matrices read from 200-dpi renders; row sums checked = 200 000 (Figs. 6, 7) or 20 000 (Fig. 11).
- ⚠ Fig. 7 left, row 3₁ sums to 199 999 as read; one count may be misread or a rounding in the figure.
- ⚠ Fig. 11 row 3₁ diagonal read as 19795; row then sums to 19 999 (19796 would give 20 000) — digit possibly misread.
- ⚠ Confusion-matrix axis order is 0, 3₁, 4₁, 5₂, 5₁ (not the order 0, 3₁, 4₁, 5₁, 5₂ used in the text).
- ⚠ Eq. (B3) places ŷ_c outside and y_c inside the log, contrary to standard cross-entropy given the stated definitions; transcribed as printed.
- ⚠ Table I: FFNN at L = 80 has training accuracy 50.00% and validation 43.38%, lower than L = 60 and the 2×10⁵ L = 100 FFNN is 47.59% — as printed.
- Exact layer widths/hyper-parameters (learning rate, batch size, epochs) not reported.
