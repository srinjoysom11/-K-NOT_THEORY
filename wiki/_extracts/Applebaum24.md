# Applebaum24 — The unknotting number, hard unknot diagrams, and reinforcement learning
- **Authors:** Taylor Applebaum, Sam Blackwell, Alex Davies, Thomas Edlich, András Juhász, Marc Lackenby, Nenad Tomašev, Daniel Zheng (Google DeepMind, London; Mathematical Institute, Oxford)
- **Venue / year / identifiers:** arXiv:2409.09032v2 [math.GT] 19 Jul 2025. MSC 2010: 57K10, 57K14, 68T07, 68T20.
- **File:** papers/5_ml_rl/Applebaum-et-al_2024_Unknotting_number_RL_2409.09032.pdf   **Pages:** 30
- **Text layer:** ok (formulas partly garbled; checked against page images for pp. 12–16, 22–24)

## Abstract
We have developed a reinforcement learning agent that often finds a minimal sequence of unknotting crossing changes for a knot diagram with up to 200 crossings, hence giving an upper bound on the unknotting number. We have used this to determine the unknotting number of 57k knots. We took diagrams of connected sums of such knots with oppositely signed signatures, where the summands were overlaid. The agent has found examples where several of the crossing changes in an unknotting collection of crossings result in hyperbolic knots. Based on this, we have shown that, given knots K and K′ that satisfy some mild assumptions, there is a diagram of their connected sum and u(K) + u(K′) unknotting crossings such that changing any one of them results in a prime knot. As a by-product, we have obtained a dataset of 2.6 million distinct hard unknot diagrams; most of them under 35 crossings. Assuming the additivity of the unknotting number, we have determined the unknotting number of 43 at most 12-crossing knots for which the unknotting number is unknown.

## Notation and conventions
- **u(D), u(K)** (p. 1): "The unknotting number u(D) of a knot diagram D is the minimal number of crossing changes required to obtain a diagram of the unknot U. The unknotting number u(K) of a knot K is defined as u(K) := min{u(D) : D is a diagram of K}."
- **c(D), c(K)** (p. 2): "The crossing number c(D) of a knot diagram D is the number of double points of D." c(K) := min{c(D)}. "If c(D) = c(K), we say that D is a minimal crossing number diagram of K."
- **Crossing arc** (pp. 1–2): framed, oriented arc a embedded in S³ with K ∩ a = ∂a; crossing change = finger move along a.
- **Gordian distance d(K,K′)** (p. 3): distance in the Gordian graph (vertices knots, edges = one crossing change); u(K) = d(K,U).
- **g4(K)** (p. 3): 4-ball genus; g4(K) ≤ u(K). Lower bounds used: |σ(K)|/2, |τ(K)|, |ν(±K)| (−K = mirror), |s(K)|/2. "σ, τ, and s are symmetric with respect to mirroring, but ν is not."
- **Knot naming** (p. 2): for c ∈ [3,10], "c_n refers to knot number n of crossing number c in Rolfsen's table"; 11–13 crossing names (e.g. 12n288, 12a981) as in KnotInfo.
- **Hard unknot diagram** (p. 6): "a diagram of the unknot is hard if, in any sequence of Reidemeister moves to the trivial diagram, the crossing number has to first increase before it decreases."
- **Inter-/in-component crossing — Definition 4.1** (p. 17): "a crossing change in a diagram of a connected sum is inter-component if it results in a knot that is not a connected sum (e.g., hyperbolic) and is in-component otherwise."
- **Overlay sum** (p. 14): connected sum diagram obtained by overlaying diagrams of K and K′ (Fig. 7); "in an overlay sum, every crossing arc only intersects the connected sum sphere at most once."
- **One step lookahead** (p. 8): features = invariants of the diagram together with invariants of all diagrams obtained by changing one crossing.
- **Generalised tangle / prime generalised tangle** (Defs. 4.2, 4.3, p. 18): see below.
- **MDP** (p. 7): (S, A_s, P_a, R_a); S = "certain invariants of diagrams that can be obtained by crossing changes from a fixed knot diagram D"; action = changing a crossing of D; reward 1 if s′ is a diagram of U, 0 otherwise. V^π(s) := E[Σ_{t≥0} γ^t R_{π(s_t)}(s_t, s_{t+1})], γ ∈ [0,1].
- Braid notation (p. 13): w(β) writhe, n(β) number of strands, c(β̂) crossing number of the braid closure β̂.

## Numbered statements
**Conjecture 1.1 (p. 3).** For knots K and K′, we have u(K#K′) = u(K) + u(K′). (Open; additivity conjecture. Not disproved here.)

**Conjecture 1.2 (p. 4).** In any collection of unknotting crossing arcs for K#K′, there is one arc that can be isotoped to be disjoint from the 2-sphere specifying the connected sum. *Status:* the paper shows 1.2 ⇒ 1.1 (p. 17, induction on u(K#K′)) and **disproves 1.2**: "We have found 20 counterexamples to Conjecture 1.2" (p. 17).
Proof idea (1.2 ⇒ 1.1, p. 17): an arc α1 disjoint from the sphere lies on K′ side; changing it gives K#K″ with u(K#K″) = n − 1; induct, and u(K″) ≥ u(K′) − 1 gives u(K#K′) ≥ u(K)+u(K′).

**Theorem 1.3 (p. 4, restated p. 17–18; proved here).** Suppose that the prime knots K1 and K2 in S³ are not 2-bridge. Suppose that, for i ∈ {1,2}, there is a set of u(Ki) crossing changes to Ki taking it to the unknot, with the property that changing any one of these crossings does not produce the connected sum of Ki and a non-trivial knot. Furthermore, assume that u(K1) > 1 or u(K2) > 1. Then there is a diagram of K1#K2 and a set C of unknotting crossings of size u(K1) + u(K2) such that changing any crossing in C results in a prime knot.
Proof idea: unknotting crossings of each summand are made consecutive along a straight sub-arc a_i; finger moves of crossings c1, c2, d2 across the other summand's crossings make every crossing change in C split K into two prime (generalised) tangles via the connected-sum sphere; Lickorish's theorem (Thm 4.4) then gives primality (pp. 18–21).

**Definition 4.1 (p. 17).** (inter-/in-component; see Notation.)

**Definition 4.2 (p. 18).** A generalised tangle is a pair (B, t), where B is a 3-ball and t is a 1-manifold properly embedded in B that intersects ∂B in 4 points. … When t has no simple closed curve components, it is a tangle. A tangle is trivial when there is a homeomorphism from B to D² × I taking t to {p1, p2} × I, where p1 and p2 are two points in the interior of D².

**Definition 4.3 (p. 18; due to Lickorish for tangles).** A generalised tangle (B, t) is prime if (1) any 2-sphere in B which meets t transversely in 2 points bounds a 3-ball intersecting t in an unknotted arc; (2) it is not a trivial tangle.

**Theorem 4.4 (p. 18; Lickorish [22] for tangles, extension stated without proof).** If two prime generalised tangles are glued via a homeomorphism between their boundary spheres that identifies the intersections with 1-manifolds, the result is a prime link.

**Remark 4.5 (p. 21; conjecture).** We conjecture that Theorem 1.3 also holds without the extra assumption that K1 and K2 are not 2-bridge.

## Key equations and quantitative claims outside numbered statements
- p. 1: Taniyama: for any K and n ∈ ℕ there is a diagram D of K with u(D) ≥ n (quoted).
- p. 2: 10_8 has unique minimal diagram D with u(D) = 3 but u(10_8) = 2 (quoted example).
- p. 2: "Of the 2978 knots with at most 12 crossings, 660 have unknown unknotting number, including 9 knots with crossing number 10. Of the remaining 2318 knots, only 25 have u(D) > u(K) for their minimal crossing number diagram D in KnotInfo."
- p. 2–3: Brittenham–Hermiller: at least one of 12n288, 12n491, 12n501, 13n3370 violates the Bernhard–Jablan conjecture; u(13n3370) ≤ 2 (13n3370 is the closure of a 20-crossing braid; one change gives 11n21, u = 1).
- p. 3: Kronheimer–Mrowka: u(T_{p,q}) = (p − 1)(q − 1)/2. Scharlemann: u(K#K′) ≥ 2 if K, K′ ≠ U. Alishahi–Eftekhary: u(K#T_{p,q}) ≥ p − 1 for 0 < p < q.
- p. 4: open whether u(T_{2,3} # −T_{2,5}) = u(T_{2,3}) + u(T_{2,5}).
- p. 4: for an n-crossing diagram, u(D) ≤ n/2; 2^{n−1} candidate unknotting subsets up to complement.
- p. 8: imitation-learning expert data from brute-forced minimal unknotting sets of random knots up to 30 crossings; unknotting numbers of diagrams range 1–8.
- p. 9: supervised accuracy 84.6%–88.1% (predict whether a crossing lies in a minimal unknotting set); baseline 50.1% (crossing 2 is in a minimal unknotting set for 50.1% of diagrams). Best: hidden layers [1024,1024,1024], lr 0.01, all features. Polynomial features (3) only, same architecture: 87.97%.
- p. 10: saliency: evaluations of V_K(t) and V′_K(t) near 1 most important.
- p. 11: disallowing revisiting the same Alexander or Jones polynomial decreased unsolved diagrams for 50–100-crossing knots from 0.49% to 0.05% (agent using both polynomials). Alexander-only policy 10× faster than Jones. Running agent 10 times per diagram "substantially increased performance".
- p. 12 (Fig. 3): random-knot dataset, Jones agent better on 71,699 diagrams, equal 29,232, Alexander better 7,069.
- p. 12 (Fig. 4): baselines compared on a test set of 100,000 diagrams; Jones RL agent unknots more knots and gives shorter sequences (bar heights only, no numbers printed).
- p. 13: Jones polynomial computation exponential time; polynomial for bounded braid index [Morton–Short] but too slow for RL beyond braid index 6–8, so braids of at most 8 strands.
- p. 13: slice–Bennequin: |w(β)| − n(β) + 1 ≤ 2u(β̂) ≤ c(β̂) + 1 − n(β). "Our RL agent obtained statistically better bounds on the unknotting number than the slice–Bennequin bounds."
- p. 13: β1 σ_{k1} β2 closure = β̂1 # β̂2; 7 identity braid words inserted for mixing.
- p. 13: transformer braid-word agent: works on ≤ 60 crossings, 3–8 strands; struggles on larger braids.
- p. 14: dataset S: u(K) obtained for 31k random knots (10–60 crossings) and 26k quasipositive knots (10–50 crossings) in SnapPy-simplified diagrams with large |σ(K)| where RL upper bound = knot Floer lower bound (σ, τ, |ν(±K)|). Appendix A: 31,380 random + 26,473 quasipositive. Plus torus knots and ≤12-crossing KnotInfo knots with known u.
- p. 14: in ~100k cases overlay sums further mixed with random Reidemeister moves; agent limit ~200 crossings; overlay sums of 3 knots with ≤12 crossings, crossing number up to 120.
- p. 16: forced 2–5 inter-component crossings on a dataset of 60 million knots, agent run 10 times each: in 25% of cases found unknotting set of size u(K)+u(K′) containing the specified crossings; 2% no unknotting set found in the prescribed steps.
- p. 17: 20 counterexamples to Conjecture 1.2 (checked that inter-component crossings stay inter-component).
- p. 21–22: 43 knots with c ≤ 12 and unknown u get u (assuming additivity), all equal to KnotInfo upper bound (Table 1). All except 12a898, 12a916, 12a981, 12a999 have a crossing change in their KnotInfo diagram giving K0#K1 with u(D) = u(K0)+u(K1) − 1.
- p. 23: hand-found 14-crossing diagram of 12a981 where two crossing changes give T_{2,5}#−T_{2,7}; KnotInfo u(12a981) ∈ {2,3}; assuming additivity u(12a981) = 3. Changing the two encircled crossings gives hyperbolic 14n20178 and 14n20981.
- p. 23–24: hard unknots: 5,873,958 diagrams with trivial Jones polynomial that SnapPy 'level' could not simplify (25 attempts each); verified unknots via Seifert genus (knot Floer). 5,364,424 verified hard (exhaustive R3 enumeration, R1/R2 check, 2-minute timeout); timed out 101,339; not hard 408,195; 2,623,203 distinct (Gauss code); 2,464,461 R3-equivalence classes. 382 'really hard' diagrams not simplified by 10^6 independent or 10^5 subsequent SnapPy 'global' attempts.
- p. 6: dataset includes H, J, Culprit, Goeritz from [7] (9, 9, 10, 11 crossings); 10 of the 21 diagrams collected in [7] "are not actually hard according to our definition". Next known hard diagram reduced Ochiai II has 35 crossings.
- p. 25: Fig. 17 hard unknot: 42 crossings, 6225 R3-equivalent diagrams, survived 10^4 subsequent simplification attempts / 10000 'global' calls; PD code printed on p. 25.

## Methods / algorithms
**A. Supervised / imitation learning (behavioural cloning), pp. 8–10**
1. Target: per-crossing probability of lying in a minimal unknotting set (threshold 0.5). Expert data: brute-forced minimal unknotting sets of random knots ≤ 30 crossings.
2. Features (computed with SnapPy), one-step lookahead: (1) signature, determinant, writhe, alternating?; (2) number/lengths of twist regions + crossing signs; (3) Alexander Δ_K(t) and Jones V_K(t): coefficients, min/max degrees, evaluations (incl. some roots of unity) of polynomial and first three derivatives; (4) knot_floer_homology invariants (τ, ν, ϵ, Seifert genus, fibred, L-space, ranks, modulus, total rank); (5) hyperbolic volume, longitudinal translation, natural slope. (4),(5) dropped: fail ≥ 20% or slow ≥ 100 crossings; focus on (1) and (3). Adding sum of |coefficients| of Alexander polynomial improved performance.
3. MLPs hidden [256,256], [1024,1024,1024], [2048,2048,2048]; 10k steps; lr 0.01 or 0.005; momentum 0.9; batch 2048.

**B. RL unknotting agent, pp. 10–12 (Fig. 2)**
1. Algorithm: IMPALA (distributed actor–learner, V-trace off-policy correction).
2. State/observation: vector of invariants of current diagram (typically Alexander + Jones features) and of all one-crossing-change neighbours; boolean "calculation failed" flag per invariant; large-range features (esp. Jones evaluations) clipped.
3. Architecture (Fig. 2): value network on current-knot invariants → predicted value; shared policy network applied per neighbour i → action probabilities over crossing indices.
4. Action: crossing index to switch in the fixed diagram D. Repeated crossings counted mod 2; optionally disallow revisiting the same Alexander or Jones polynomial.
5. Reward: +1 if unknot reached, else 0. Episode ends at unknot or max steps (fixed budget of crossing changes).
6. Training data: KnotInfo knots with known u, torus knots, quasipositive knots, random knots with large signature, and connected sums; sampled randomly from classes.
7. Diagram sizes: works up to c(D) ≈ 200. Evaluation: initially on brute-forced dataset, later against agent-found sets.
8. Baselines (p. 11–12): random crossing switching; Bayesian-Optimisation random agent over action categories {R1, R1⁻¹, R2, R2⁻¹, R3, crossing switch} with integer weights 1–100, reward −1 per crossing change (optimised weights: simplifying/neutral ≈100, complicating/switch ≈1); Simplify (random) = SnapPy simplify then random switch; Simplify (min. crossing) = switch the crossing minimising crossings after simplification. Test set 100,000 diagrams.
9. Braid variant (p. 13): connected sums of braid closures β1 σ_{k1} β2 mixed with 7 identity words; ≤ 8 strands. Separate transformer agent on raw braid words (integer sequence → distribution over crossings).

**C. Search for additivity counterexamples, pp. 13–17**
1. Build S (known u; mirror so σ ≥ 0). 2. Form K # −K′ by overlay (Fig. 7), optionally random Reidemeister mixing (~100k cases), 3-summand overlays, braid mixing. 3. Run Jones agent; success would be u(K)+u(K′) − 1 changes. 4. Forced inter-component experiments (60M knots, 2–5 forced, 10 runs). 5. Counterexamples to Conj. 1.2: from diagrams with several hyperbolic inter-component crossings, perform all in-component changes in the unknotting set.

**D. New u values assuming additivity, pp. 21–22:** from counterexample diagrams D to Conj. 1.2, change u(D) − 4 or u(D) − 5 crossings of a precomputed unknotting set, simplify to D′, brute-force all unknotting trajectories from D′; collect ≤12-crossing knots on them.

**E. Hard-unknot verification, pp. 23–24:** candidate = trivial Jones polynomial + SnapPy 'level' fails 25×; unknottedness via Seifert genus from knot_floer_homology; hardness = enumerate all R3-equivalent diagrams (2-min timeout) and check none admits R1/R2 simplification; dedupe by Gauss code; R3-classes; 'really hard' = fails 10^6 independent and 10^5 iterated 'global' simplifications.

## Tables
**Table 1 (p. 22).** "At most 12-crossings knots with unknown unknotting numbers that we found on minimal (assuming the additivity of the unknotting number) unknotting trajectories of connected sums K#K′ where u(K) and u(K′) are known."

| | | | | | | | | |
|---|---|---|---|---|---|---|---|---|
| 12a824 | 12a835 | 12a878 | 12a898 | 12a916 | 12a981 | 12a999 | 12n80 | 12n71 |
| 12n82 | 12n87 | 12n106 | 12n113 | 12n115 | 12n132 | 12n154 | 12n159 | 12n170 |
| 12n190 | 12n192 | 12n195 | 12n210 | 12n214 | 12n233 | 12n235 | 12n238 | 12n241 |
| 12n246 | 12n309 | 12n315 | 12n346 | 12n437 | 12n500 | 12n548 | 12n670 | 12n673 |
| 12n675 | 12n678 | 12n681 | 12n690 | 12n695 | 12n721 | 12n723 | | |

(43 entries; verified against page image.)

## Figures
- **Fig. 1 (p. 9)** — "The distribution of the percentage of crossings that lie in a minimal unknotting set for diagrams in the dataset." *What it shows:* histogram, x = percentage of valid crossings (0–1), y = probability (up to ~0.07). Image: ../figures/Applebaum24/p09.png
- **Fig. 2 (p. 10)** — "The architecture of the RL agent. Input features are invariants of the current diagram, together with invariants of all neighbouring diagrams." *What it shows:* value network on current-knot invariants; copies of a policy network on invariants after switching crossing i = 1…6 producing action probabilities; agent–environment loop. Image: ../figures/Applebaum24/p10.png
- **Fig. 3 (p. 12)** — "Comparison of the performance of the Alexander and the Jones RL agents on a dataset of random knot diagrams." *What it shows:* bars: Jones better 71,699; equal 29,232; Alexander better 7,069. Image: ../figures/Applebaum24/p12.png
- **Fig. 4 (p. 12)** — "Comparison of the performance of different unknotting strategies. (A) shows the mean diagram unknotting number estimated by the different strategies for solved knots. (B) shows the percentage of knots each strategy was unable to unknot." *What it shows:* bars for Simplify (random), Simplify (min. crossing), BO, Jones. Read off (approx., no printed values): (A) ≈ 11.8, 11.4, 12.0, 9.8; (B) ≈ 0.065, 0.31, 0.19, 0.03 (axis "Unsolved Percentage", 0–0.30). Jones best on both. Image: ../figures/Applebaum24/p12.png
- **Fig. 5 (p. 13)** — "One can mix a diagram of a connected sum of two braid closures by inserting identity braid words. The inter-component crossings that yield hyperbolic knots are shown in red." *What it shows:* long braid diagram (~8 strands) with red and blue crossings. Image: ../figures/Applebaum24/p13.png
- **Fig. 6 (p. 14)** — "The distribution of random knots K in our dataset by SnapPy simplified crossing number, by u(K), and by σ(K)." *What it shows:* crossing number histogram peaked ~15–22 (range ~10–60); u(K) histogram peaked at ~2–4 (max count ~10000), long tail; signature histogram mostly near small values. Image: ../figures/Applebaum24/p14.png
- **Fig. 7 (p. 15)** — "An overlaid diagram of a connected sum that can be unknotted by the inter-component crossings 13, 14, 48, and 50." *What it shows:* grid-like overlaid diagram (two colours, ~96 numbered crossings), crossings 13, 14, 48, 50 circled red. Image: ../figures/Applebaum24/p15.png
- **Fig. 8 (p. 16)** — "The performance of the RL agent based on the Jones polynomial on connected sums and no forced inter-component crossing changes. The four dashed lines indicate a difference of 3, 6, 9, and 12, respectively, between the diagram unknotting number found by the agent and the unknotting number expected assuming additivity." *What it shows:* heat map, x = expected unknotting number 6–12, y = agent's unknotting number (1–20, plus "Unsolved"). No entries below the diagonal (agent never beat additivity). Counts (verified at 220 dpi; blank = no entry):

| Agent \ Expected | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|
| Unsolved | | 1 | 2 | 3 | 10 | 28 | 41 |
| 6 | 15302 | | | | | | |
| 7 | 5375 | 20990 | | | | | |
| 8 | 2684 | 8713 | 23302 | | | | |
| 9 | 948 | 4912 | 9772 | 24865 | | | |
| 10 | 337 | 1860 | 5814 | 10047 | 24548 | | |
| 11 | 95 | 719 | 2188 | 6450 | 9630 | 20391 | |
| 12 | 34 | 193 | 917 | 2554 | 6543 | 7586 | 12628 |
| 13 | 3 | 69 | 331 | 1082 | 2441 | 5990 | 4351 |
| 14 | 3 | 25 | 128 | 403 | 1248 | 2191 | 3855 |
| 15 | 1 | 4 | 40 | 146 | 512 | 1198 | 1451 |
| 16 | | 2 | 16 | 60 | 197 | 435 | 871 |
| 17 | | | 9 | 24 | 68 | 245 | 319 |
| 18 | | | 1 | 6 | 33 | 90 | 174 |
| 19 | | | | 5 | 19 | 48 | 53 |
| 20 | | | 1 | 1 | 7 | 17 | 45 |

  Image: ../figures/Applebaum24/p16.png
- **Fig. 9 (p. 19)** — "The knots K_i with the vertical arcs a_i, unknotting set of crossings C_i, and connected sum points p_i for i ∈ {1, 2}." *What it shows:* schematic of two summands with crossings stacked along vertical arcs. Image: ../figures/Applebaum24/p19.png
- **Fig. 10 (p. 19)** — "Upper left: the diagram D of the connected sum K1#K2. Upper right: the diagram D′ after performing finger moves on the crossings c1 and c2. Bottom left: the diagram near the connected sum sphere after changing one of the crossings in C2′. Bottom right: after changing one of the crossings in C1′. In the bottom row, there might be additional under-arcs across a+ that are not shown." *What it shows:* four-panel construction diagrams for the proof of Thm 1.3. Image: ../figures/Applebaum24/p19.png
- **Fig. 11 (p. 19)** — "The result of changing the crossing c1′." Image: ../figures/Applebaum24/p19.png
- **Fig. 12 (p. 20)** — "The left shows the link L2′ obtained from T2 by adding a trivial tangle. The right shows the tangle A." *What it shows:* tangle diagrams; A has a closed unknot component linking a crossing.
- **Fig. 13 (p. 22)** — "The left shows the link L2 obtained from the tangle T2 by adding a trivial tangle. The right shows L2 after the isotopy of the unknot component into a neighbourhood of the crossing d2 of K2." Image: ../figures/Applebaum24/p22.png
- **Fig. 14 (p. 22)** — "A 14-crossing diagram of the knot 12a981. We can obtain T2,5# − T2,7 by changing the two encircled crossings." *What it shows:* knot diagram with two red-circled crossings. Image: ../figures/Applebaum24/p22.png
- **Fig. 15 (p. 23)** — "The crossing number distribution of the hard unknot candidates." *What it shows:* histogram of crossings (~13 to ~50), peak ≈ 245,000 at ~18 crossings, long right tail. Image: ../figures/Applebaum24/p23.png
- **Fig. 16 (p. 24)** — "The dataset of hard unknot candidates." *What it shows:* bars: Total 5.87·10^6, Hard 5.36·10^6, Distinct hard 2.62·10^6, Timed out 1.01·10^5, Not hard 4.08·10^5. Image: ../figures/Applebaum24/p24.png
- **Fig. 17 (p. 25)** — "A 42-crossing hard unknot diagram with 6225 R3-equivalent diagrams that we have not been able to simplify by calling SnapPy's 'global' heuristic 10000 times." *What it shows:* the diagram; PD code given in text. Image: ../figures/Applebaum24/p25.png

## Stated limitations, open problems, future work
- p. 4/16: "even after running the agent on millions of connected sums, we have not found a counterexample to the additivity of the unknotting number."
- p. 15: interpretations: evidence for the conjecture; or "a stochastic search might not be sufficient to come across a counterexample, if one exists" (cf. difficulty of finding a u = 2 diagram of 13n3370); or "our RL agent was not good enough to find a minimal unknotting set".
- p. 15: alternative: train an RL agent that searches for non-trivial unknotting crossing arcs in a fixed diagram (cf. [12]; a Bayesian random walker outperformed all their RL architectures).
- p. 6: initial attempt to construct hard unknots with setter/solver RL had "little success".
- p. 9: invariants (4),(5) failed (≥ 20%) or slow (≥ 100 crossings).
- p. 13: transformer braid agent struggled on large braids; "Future work could investigate invariant-free unknotting agents further." Unexplored: imitation learning on braid-agent trajectories with augmentation.
- p. 10: Jones polynomial "contains yet unobserved unknotting information" — not explained by algebraic unknotting number.
- p. 21: Remark 4.5 (drop 2-bridge assumption). p. 24: SnapPy 'global' could miss simplifications after crossing-number-preserving pass moves.

## References worth following
- [5] Brittenham, Hermiller, A counterexample to the Bernhard–Jablan unknotting conjecture, Exp. Math. 30(4) 2021.
- [7] Burton, Chang, Löffler, Maria, de Mesmay, Schleimer, Sedgwick, Spreer, Hard diagrams of the unknot, Experimental Mathematics, 2023.
- [8] Culler, Dunfield, Goerner, Weeks, SnapPy.
- [9] Davies et al., Advancing mathematics by guiding human intuition with AI, Nature 600 (2021).
- [10] Espeholt et al., IMPALA, ICML 2018.
- [12] Gukov, Halverson, Manolescu, Ruehle, Searching for ribbon knots with machine learning, arXiv:2304.09304 (2023).
- [13] Gukov, Halverson, Ruehle, Sułkowski, Learning to unknot, Mach. Learn.: Sci. Technol. 2 (2021).
- [1] Alishahi, Eftekhary, Knot Floer homology and the unknotting number, Geom. Topol. 24 (2020).
- [22] Lickorish, Prime knots and tangles, Trans. AMS 267 (1981).
- [25] Menasco, Closed incompressible surfaces in alternating knot and link complements, Topology 23 (1984).
- [34] Rudolph, Quasipositivity as an obstruction to sliceness, Bull. AMS 29 (1993).
- [35] Scharlemann, Unknotting number one knots are prime, Invent. Math. 82 (1985).
- [30] Petronio, Zanellati, Algorithmic simplification of knot diagrams, JKTR 25 (2016).
- [24] KnotInfo (Livingston, Moore).

## Extraction notes
- ⚠ p. 23: printed "u(T_{2,3}# − T_{2,7}) = u(T_{2,5}) + u(T_{2,7}) = 2 + 3 = 5" — left side says T_{2,3} although context (Fig. 14, surrounding text) is T_{2,5}#−T_{2,7}; transcribed as printed.
- ⚠ Count wording: abstract says "2.6 million distinct hard unknot diagrams"; p. 6 says "2.46 million of these are indeed hard and are not related by a sequence of R3 moves" and "approximately 5.9 million"; Section 5 gives 2,623,203 distinct and 2,464,461 R3-classes; Appendix A releases 2,464,461. Consistent if 2.6M = distinct by Gauss code, 2.46M = R3-classes.
- ⚠ p. 14 "57k knots" (abstract) = 31k random + 26k quasipositive (31,380 + 26,473 = 57,853 per App. A).
- Compute resources (hardware, training time, number of actors) are not stated in the paper; IMPALA hyperparameters (learning rate, network sizes for RL, max episode steps) not given.
- Appendix B (pp. 27–30): PD codes, τ lower bounds (τ(K1) = −8, τ(K2) = 7 ⇒ u ≥ 15 for 12a898 trajectory; τ = −4, 5 ⇒ u ≥ 9 for 12a916 and 12a999), minimal unknotting sequences [49,0,20,1,57,76,66,85,84,79,56,96,67,65,69] (12a898) and [10,44,46,47,53,33,42,7,36] (12a916/12a999) — PD codes not retranscribed here; see PDF pp. 27–30. Note B.2 and B.3 print identical initial PD codes for K1#K2 and identical summands; they differ after simplification.
- Table 1 and Fig. 8 cell values verified against page images. Fig. 4 values are eyeballed.
- Datasets released at gs://gdm-unknotting (App. A).
