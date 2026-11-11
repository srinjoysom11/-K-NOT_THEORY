# JvRP95 — Minimal Knots in the Cubic Lattice
- **Authors:** E. J. Janse van Rensburg, S. D. Promislow (Department of Mathematics and Statistics, York University, North York, Ontario)
- **Venue / year / identifiers:** Journal of Knot Theory and Its Ramifications, Vol. 4, No. 1 (1995) 115–130; received 3 January 1994; © World Scientific Publishing Company
- **File:** papers/vanrensburg1995.pdf   **Pages:** 16 (PDF page k = printed page k + 114; printed 115 = PDF 1)
- **Text layer:** scan (no text layer; transcribed from page images; all statements and both tables read from images at normal resolution)

## Abstract
How many edges are necessary and sufficient to construct a knot of type K in the cubic lattice? Define the minimal edge number of a knot to be this number of edges. To what extend does the minimal edge number measure the complexity of a knot? What is the behaviour of the minimal edge number under the connected sum of knots, and what is its limiting behaviour? We consider these questions and show that the minimal edge number may be computed using simulated annealing.

*Keywords:* Knotted Polygons, Cubic Lattice, Knot Complexity, Simulated Annealing.

## Notation and conventions
- (p. 1) Z³ = cubic lattice, vertices = integer points of R³, edges between vertices differing in one coordinate. A **polygon** = "unlabeled vertex-avoiding closed path of edges (or a cycle)"; "Define two polygons to be equivalent if they can be made identical by a translation in Z³" — counted up to translation only. Girth of Z³ is 4, so the unknot polygon with fewest edges has length 4.
- (p. 1) **Minimal edge number** M(K) = "the (cubic) minimal edge number of knot-type K" = minimum number of edges (steps) of a lattice polygon of type K. Lattice-dependent (e.g. 3_1 needs 16 edges in the face-centred cubic lattice, conjectured minimal, [4]). Stick number: 3_1 needs 6 sticks [5].
- (p. 2) 𝒫 = set of lattice polygons; 𝒦 = tame PL knots; i* = isomorphism between knot types in 𝒦 and in 𝒫; 𝒫* = set of knot types of lattice knots. Concatenation of two polygons: after lexicographic ordering of edges and a translation/rotation so that the "rightmost" edge of one has midpoint with first coordinate exactly one less than that of the "leftmost" edge of the other, delete these edges and replace them by two joining edges (Fig. 1); concatenation corresponds to connected sum #, and 𝒫* is a semigroup isomorphic to knot types.
- (p. 3) K^n = connected sum of n copies of K; compound knot = connected sum of two knots; ∅ denotes the unknot (so M(∅) = 4).
- (p. 4) **Minimal edge index** μ_K = lim_{n→∞} M(K^n)/n (Theorem 3).
- bridge number b(K) (bridge index, Schubert [8]); c(K) = infimum of total curvature of K in its knot type; c(K) = 2π b(K) (as printed: "b(K) = c(K)/2π"); C(P) = curvature of polygon P; successive lattice edges turn by 0 or π/2, so a polygon with curvature C(P) has ≥ 2C(P)/π edges (p. 4). c_p(K) = minimum curvature that a polygon of knot type K can attain in the lattice Z^d (p. 12), c_p(K) ≥ c(K).
- 𝐌(K) = M(K) − 4 (Theorem 4).
- Weak measure of knot complexity (Definition 5).
- (p. 11) Tight knot (knotted ball-pair): lattice neighbourhood N(ω) = union of dual 3-cubes centred on vertices of walk ω; ω′ = walk with first and last steps deleted; if N(ω′) is a 3-ball and the pair (N(ω′), N(ω′) ∩ ω) is knotted, ω is a *tight knot*; **Kesten property**: three copies can be concatenated endpoint-to-endpoint to give a tight knot containing the original tight knot exactly three times. Knot type of a tight knot by taking rays from its endpoints to infinity (a knot in S³).
- Simulated annealing parameters: see Methods. BFACF parameter β (called β, with critical value β_c ≈ 0.213475).
- q(n) = number of distinct knot types K with M(K) = n (n even); Q(n) = Σ_{m≤n} q(m) (p. 9).

## Numbered statements
- **Lemma 1 (p. 3 [117]).** Suppose that K_1 and K_2 are arbitrary knots, then M(K_1#K_2) ≤ M(K_1) + M(K_2). ("the minimal edge number is subadditive with respect to the connected sum".) *Proved:* concatenate minimal polygons P_1, P_2 to get a polygon of M(K_1)+M(K_2) edges.
- **Lemma 2 (p. 3).** If K_1 and K_2 are arbitrary knots, then there exist constants α_{K_1} ≥ 0 and α_{K_2} ≥ 0 such that M(K_1#K_2) ≥ α_{K_1} + α_{K_2}, and M(K_1^n) ≥ nα_{K_1}, where K_1^n is the connected sum of n knots all of type K_1. If K is not the unknot, then α_K > 0. *Proof idea (p. 4):* take α_K = 4(b(K) − 1), additive under connected sum since b(K_1)+b(K_2)−1 = b(K_1#K_2); c(K) = 2πb(K) and C(K) ≥ c(K); a polygon in Z³ with curvature C(P) has ≥ 2C(P)/π edges; M(K) ≥ 2C(K)/π ≥ 2c(K)/π = 4b(K) ≥ α_K.
- **Theorem 3 (p. 4 [118]).** Let K be an arbitrary knot. Then the following limit exists, and we call it the minimal edge index of K: lim_{n→∞} M(K^n)/n = μ_K. In addition, M(K^n) ≥ nμ_K. Moreover, μ_K > 0 if K is not the unknot. *Proof:* subadditivity (Lemma 1) and Lemma 2, then the theory of subadditive functions (Hille [10]).
- **Theorem 4 (p. 5 [119]).** Define 𝐌(K) = M(K) − 4. Then (i) 𝐌(∅) = 0; (ii) 𝐌(K) > 0 if K is not the unknot; (iii) there exist constants A_K > 0 and B_K ≥ 0 such that 𝐌(K_1^n # K_2) > nA_{K_1} + B_{K_2} for any knot K_1 ≠ ∅, K_2 an arbitrary knot, and any integer n ≥ 0. *Proof (paper):* (i) M(∅)=4. (ii) uses Diao [1,2]: M(K)=24 iff K=3_1, and if M(K)<24 then K is the unknot, so 𝐌(K) ≥ 20 for non-trivial K (alternatively by the curvature argument: total curvature of any non-trivial knot exceeds 4π [Milnor 11], so M(K) ≥ 2C(K)/π > 8). (iii) from Lemma 2 take A_K = B_K = α_K.
- **Definition 5 (p. 5).** A map F(K) → R (R = real numbers), for every PL knot K ∈ 𝒦*, is a *weak measure of knot complexity* if F(∅) = 0; if there exists a positive constant C_K such that F(K^n) < C_K n for every non-trivial knot K; and if there exist invariants A_K and B_K (B_K = 0 only if K = ∅) such that for every pair of knots K_1 ≠ ∅ and K_2 we get F(K_1^n # K_2) > A_{K_1} n + B_{K_2}. (A *good* measure in the sense of Soteros et al. [6]: F(∅)=0 and there exists K such that for any knot K and L, F(K^n#L) ≥ nF(K) > 0.)
- **Theorem 6 (p. 6 [120]).** Let K be any piecewise linear knot. Then the minimal edge index of K has the following properties: (i) μ_K = 0 ⇔ K = ∅; (ii) μ_{K^n} = nμ_K; (iii) μ_{K_1#K_2} ≤ μ_{K_1} + μ_{K_2}, where K_1 and K_2 are non-trivial piecewise linear knots; (iv) there exist invariants A_K > 0 and B_K ≥ 0 such that if K_1 is a non-trivial knot and K_2 is an arbitrary knot, then μ_{K_1^n#K_2} ≥ A_{K_1} n + B_{K_2}. In fact, B_K = 0 ⇔ K = ∅ and A_K > 4 and B_K > 4 if K is not the unknot. *Proof (paper):* (iv) by the methods of Lemma 2 and Theorem 4: μ_{K_1^n#K_2} ≥ lim_m 4(nm c(K_1)+m c(K_2) − 2π(nm+m−1))/mπ, with c(K) ≥ 4π [Milnor], giving ≥ 4n+4+4/m → 4n+4.  Remarks (p. 6): μ is a weak measure of complexity but not a good one because of (iii).
- **Conjecture 7 (p. 6).** Let K_1 and K_2 be arbitrary knots. Then μ_{K_1#K_2} = μ_{K_1} + μ_{K_2}. (Authors: "seems hard to prove"; holds when K_1 = K_2 by Thm 6(ii).)
- **Theorem 8 (p. 7 [121]) [quoted from [14] = Janse van Rensburg & Whittington 1991].** The ergodicity classes of the BFACF algorithm when applied to polygons in the cubic lattice, are the knot types of the polygons. (In our notation, the set 𝒫*.)
- **Theorem 9 (p. 9 [123]).** Every knot other than 3_1 has M(K) > 24. *Proof:* corollary of two theorems of Diao [1,2]: at least 24 edges are necessary to tie a knot in the lattice, and every knot K with M(K) = 24 is 3_1.
- **Theorem 10 (p. 10 [124]).** Let Q(n) be defined as above. Then there exists a constant 𝒬 such that lim_{n→∞} [log Q(n)]/n = log 𝒬. Moreover, Q(n) ≤ 𝒬^n. *Proof idea:* number of polygons rises exponentially [16] so q(n) rises at most exponentially; Q(n)Q(m) ≤ Q(n+m) since every knot of type K with M(K)=n can be concatenated with a knot K′ with M(K′)=m to give a compound knot with max{n,m} < M(K#K′) ≤ n+m (prime knots not counted); hence Q is supermultiplicative and the limit exists [10].
- **Corollary 11 (p. 10).** The number of distinct knot types with minimal edge number equal to n rises exponentially with n.
- **Lemma 12 (p. 11 [125]) [quoted from [6] = Soteros, Sumners, Whittington 1992].** Let K be any knot, then there exists a tight knot with the Kesten property which has knot type K.
- **Theorem 13 (p. 12 [126]).** Let ω be a tight knot of type K with |ω| edges. If ω has the Kesten property, then μ_K ≤ |ω|. *Proof (paper):* concatenate copies of the last vertex to first to get an infinite string of tight knots in the lattice; take N copies, arrange four such strings into a square with m extra edges for 4 "corners": 4N tight knots, 4N|ω|+m edges; divide by 4N, N → ∞.
- **Theorem 14 (p. 14 [128]).** For any knot K ≠ ∅, M_K ≥ 2c_p(K)/π ≥ 10, and μ_K ≥ liminf_{n→∞} 2c_p(K^n)/(πn) ≥ 4, where c_p(K) is the minimum curvature that a polygon of knot-type K may attain in the lattice Z^d. (⚠ The paper writes M_K here but M(K) elsewhere; the ≥ 10 bound is weaker than the proved M(K) ≥ 24 of Theorem 9.)

## Key equations and quantitative claims outside numbered statements
- p. 1: Diao [1]: at least 24 edges are needed for a non-trivial polygon; the only knot type with 24 edges is 3_1 [2] (quoted, rigorous).
- p. 3 (via Lemma 2 proof): α_K = 4(b(K) − 1).
- p. 7 (Sect. 3): Metropolis-style BFACF implementation: pick an edge ω_{i−1}ω_i with uniform probability and a perpendicular unit vector u, move the edge parallel to itself in direction u inserting two new edges, erase double edges. With χ(ω′) the indicator that ω′ is a polygon: if |ω′| = n+2 accept with probability χ(ω′)β²; if |ω′| = n−2 (or n) accept with probability χ(ω′); rejection keeps ω.
- p. 8 (Eq. 3.1): invariant limit distribution P_β(ω, 𝒦) = Z(β)^{-1} |ω| β^{|ω|} χ_𝒦(ω), with χ_𝒦(ω) = 1 if ω has knot type 𝒦, 0 otherwise. "It is widely believed (but unproven!)" number of polygons of knot type 𝒦 and length n equals μ^{n+o(n)} with μ ≈ 4.6844 independent of knot type; critical β_c ≈ 0.213475 (heuristic/numerical, beyond which the mean length diverges).
- p. 8 (annealing parameters, numerical): start at β ≈ 0.21 (close to critical point), successive lowerings in β of 0.01, "separated … by 10⁶ attempted BFACF moves"; each run repeated 3 times with different initial polygons, and for more complicated knots varied cooling rates. Quoted: "Upper bounds (which we believe to be good) were computed on all prime knots up to 8 crossings … as well as a selected number of simple compound knots and a selected few knots with 9 or more crossings: 9_1, 9_2, 9_42, 9_47, 10_1 and 10_161" (p. 8).
- p. 9: no correspondence between M(K) and crossing number except that M tends to increase with crossing number; since a polygon with M edges has at most M(M−3)/2 crossings in a regular projection, a lower bound is M ≥ √(2C) (C minimal crossing number). Every knot with minimal crossing number 6 has M(K) = 40 (numerical); 8-crossing knots spread from 42 to 54; 8_19 (the (3,4)-torus knot T_{3,4}), the first non-alternating knot, has anomalously low M(K); 8_20 and 8_21 also low; 9_42, 9_47, 10_161 low. By Theorem 3 the Table I estimates are upper bounds on minimal edge indices of listed knots (⚠ as printed; formally Theorem 3 gives M(K^n) ≥ nμ_K, so M(K) ≥ μ_K, i.e. the table values are upper bounds *of M* only if annealing finds minimal polygons; the claim "upper bounds on the minimal edge indices" follows from μ_K ≤ M(K)).
- p. 10: lower bound on Q from Table I: "If we count chiral knots as one, then 𝒬 ≥ 1.073" (numerical, from the table).
- p. 10–11: torus knots T_{2,k}, k = 3,5,7,9 (3_1, 5_1, 7_1, 9_1): M = 24, 34, 44, 54 (steps of 10). Construction (Fig. 3: twisting two strands): increases of M(T_{2,2k+1}) are 10 edges per twist except 2 more edges every eighth repetition ⇒ average 10.25 edges per twist; hence limsup_{k→∞} M(T_{2,2k+1})/k ≤ 10.25 (limit existence not obvious). Twist-knot sequences: 4_1, 6_1, 8_1 and 5_2, 7_2, 9_2 also increase by units of 10 (3_1 "does not fit the pattern").
- p. 12: a tight trefoil with 17 edges (Fig. 4: joining tight trefoils in a string) gives μ_{3_1} ≤ 17 (rigorous via Theorem 13, assuming the 17-edge tight trefoil has the Kesten property as claimed). Numerical (Table II): M(3_1^n)/n best value 17.4 (n = 10), "slightly worse than the theoretical bound proven in theorem 13"; linear fit M(3_1^n) ≈ 16.8n + 6.8 ("about 16.8 edges are needed per trefoil, and about 6.8 edges to close the tight knots"); (M − 6.8)/n stable around 16.7; authors believe estimates are over-estimates of μ.
- p. 13: increases of 50 in M(3_1^n) for n = 2,5,8 (40→90→140); regular spacings 34 for n = 3,5,7,9 (56, 90, 124, 158) and 50 for n = 1,4,7,10 (24, 74, 124, 174) (arithmetic subsequences observed in Table II).
- p. 14 (Discussion): stick number of 3_1 is 6 [5] and of 4_1 at least 7 [18]. Moffatt's energy [19]: for a flux tube of axial length L and volume V, E = mΦ²V^{−1/3}, m depends only on topology; in Z³ a natural flux tube is the union of the 3-cells centred at the polygon's vertices in the dual lattice. DNA application: knot types appearing at a given DNA length can be read from Table I.

## Methods / algorithms
Numerical estimation of M(K) by simulated annealing on BFACF (p. 7–8):
1. State space: all polygons (modulo translation) of a fixed knot type 𝒦 (the Markov chain preserves knot type by Thm 8).
2. Moves: choose edge ω_{i−1}ω_i uniformly; choose unit vector u perpendicular to it; translate the edge in direction u, adding two new edges; delete double edges. Moves are length-preserving (Fig. 2a) or length-changing by ±2 (Fig. 2b).
3. Acceptance (Metropolis): length n+2 accepted with probability χ(ω′)β²; length n−2 accepted with probability χ(ω′); χ = 1 if ω′ is a self-avoiding polygon.
4. Limit distribution P_β(ω,𝒦) ∝ |ω|β^{|ω|} (Eq. 3.1); β_c ≈ 0.213475 = 1/μ with μ ≈ 4.6844; β → 0 favours short polygons.
5. Annealing: start at β ≈ 0.21; lower β in steps of 0.01, with 10⁶ attempted BFACF moves between lowerings; record shortest polygon of type 𝒦 found = upper bound on M(K).
6. Consistency: each run repeated 3 times with different initial polygons; slower or different cooling rates for harder knots. Results not rigorous ("one cannot be sure that the final bound is equal to M(K)").
7. Same procedure applied to K^n for n = 1…10 (Table II).

## Tables
**Table I (p. 9 [123])** — "M(K) Estimated by Simulated Annealing" (grouped by M(K); chirality signs as printed):

| M(K) | K |
|---|---|
| 4 | 0_1 |
| 24 | 3_1 |
| 30 | 4_1 |
| 34 | 5_1 |
| 36 | 5_2 |
| 40 | 6_1, 6_2, 6_3, 3_1^−#3_1^−, 3_1^+#3_1^− |
| 42 | 8_19 |
| 44 | 7_1, 7_3, 7_7 |
| 46 | 7_2, 7_4, 7_5, 7_6, 8_20, 8_21, 3_1#4_1 |
| 48 | 8_7, 9_42 |
| 50 | 8_1, 8_2, 8_4, 8_5, 8_6, 8_9, 8_13, 9_47, 10_161 |
| 52 | 8_3, 8_8, 8_10, 8_11, 8_15, 8_16, 8_17, 8_18 |
| 54 | 8_12, 8_14, 9_1 |
| 56 | 9_2, 3_1^−#3_1^−#3_1^− |
| 60 | 10_1 |

(Checked on page image. Total listed: 8_k for k = 1…21 all present (8_1,8_2,8_3,8_4,8_5,8_6,8_7,8_8,8_9,8_10,8_11,8_12,8_13,8_14,8_15,8_16,8_17,8_18,8_19,8_20,8_21); 7_1…7_7 all present; 3_1#4_1 printed without chirality signs; the compound entries at 40 are printed as 3̄_1#3̄_1 and 3_1^+#3̄_1 — rendered here as 3_1^−#3_1^− and 3_1^+#3_1^−.) ⚠ Text on p. 9 says "every knot with minimal crossing number 6 has M(K) = 40"; consistent with table (6_1, 6_2, 6_3 at 40).

**Table II (p. 13 [127])** — "M(3_1^n) Estimated by Simulated Annealing"

| n | M(3_1^n) | M(3_1^n)/n | (M(3_1^n) − 6.8)/n |
|---|---|---|---|
| 1 | 24 | 24.0 | 17.2 |
| 2 | 40 | 20.0 | 16.6 |
| 3 | 56 | 18.7 | 16.4 |
| 4 | 74 | 18.5 | 16.8 |
| 5 | 90 | 18.0 | 16.6 |
| 6 | 110 | 18.4 | 17.2 |
| 7 | 124 | 17.8 | 16.7 |
| 8 | 140 | 17.5 | 16.7 |
| 9 | 158 | 17.6 | 16.8 |
| 10 | 174 | 17.4 | 16.7 |

(⚠ Arithmetic check: 110/6 = 18.33 (printed 18.4); 124/7 = 17.71 (printed 17.8); all other entries consistent with the M column — printed as is. Note the 3_1^n compounds are with the same chirality (written 3_1^n); the table text says "compounded left-handed trefoils 3_1^n".)

## Figures
- **Fig. 1 (p. 2 [116])** — "Concatenation of two polygons." *What it shows:* two rectilinear polygons joined by deleting facing edges (dashed) and inserting two connecting edges. Image: ../figures/JvRP95/p02.png
- **Fig. 2 (p. 7 [121])** — "The elementary moves of the BFACF algorithm". *Shows:* (a) length-preserving corner flip, (b) length-changing ±2 spike move. Image: ../figures/JvRP95/p07.png
- **Fig. 3 (p. 11 [125])** — "Twisting two strands." *Shows:* basic unit of the repeated pattern used to add twists between two strands. Image: ../figures/JvRP95/p11.png
- **Fig. 4 (p. 12 [126])** — "Joining tight trefoils in a string." *Shows:* three 17-edge tight trefoils linked end-to-end (dashed joining segments). Image: ../figures/JvRP95/p12.png
- Table pages: ../figures/JvRP95/p09.png (Table I), ../figures/JvRP95/p13.png (Table II)

## Stated limitations, open problems, future work
- p. 6: Conjecture 7 "seems hard to prove"; proof would need "some detailed geometric information on exactly how the minimal knots change when they are concatenated".
- p. 8: numerical M(K) upper bounds cannot be proven to be minimal; slow cooling makes the global minimum "almost surely" found.
- p. 9: "It seems hard to make precise statements about these observations."
- p. 10: "it would be misleading to accept that this [steps of 10 for torus knots] will continue indefinitely".
- p. 13: "Can it be proven that there exist infinite arithmetic subsequences? If not, would one observe finite arithmetic subsequences with differences equal to a given number (say 34) with positive density?"
- p. 13: improving bounds "seems a hard problem"; suggested "knots from knots" construction to obtain tighter bounds; estimates in Table II "are overestimates of μ_K".
- p. 14: stick index analogue; DNA applications.

## References worth following
- [1] Diao Y 1993, Minimal knotted polygons on the cubic lattice, JKTR 2, 413–425.
- [2] Diao Y 1994, The number of smallest knots on the cubic lattice, J. Stat. Phys. 74, 1247–1254.
- [6] Soteros, Sumners, Whittington 1992, Entanglement complexity of graphs in Z³, Math. Proc. Camb. Phil. Soc. 111, 75–91 (source of Lemma 12).
- [14] Janse van Rensburg & Whittington 1991, The BFACF algorithm and knotted polygons, J. Phys. A 24, 5553 (Theorem 8).
- [4] Janse van Rensburg & Whittington 1990, The knot probability in lattice polygons, J. Phys. A 23, 3573 (FCC trefoil with 16 edges).
- [11] Milnor 1953, On the total curvature of closed space curves, Math. Scand. 1, 289–296.
- [16] Hammersley 1961, The number of polygons on a lattice.
- [19] Moffatt 1990, The energy spectrum of knots and links, Nature 347.

## Extraction notes
- No text layer: all pages read as images (pp. 1–16 of PDF). Statements, both tables, both figure captions verified directly on the images. Equations were read as printed; the ⚠ marks above note small inconsistencies (Table II arithmetic, M_K vs M(K) in Thm 14, Theorem 3 phrasing) and are not corrections.
- In Theorem 6(iv) proof the expression "4(nm·c(K_1)+m·c(K_2) − 2π(nm+m−1))/mπ" is transcribed as read; its exact parenthesisation could not be confirmed beyond the image.
- Figure pages rendered: 2, 7, 9, 11, 12, 13.
