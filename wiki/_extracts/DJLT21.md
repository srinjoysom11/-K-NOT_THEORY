# DJLT21 — The signature and cusp geometry of hyperbolic knots
- **Authors:** Alex Davies (DeepMind), András Juhász (Oxford), Marc Lackenby (Oxford), Nenad Tomasev (DeepMind) (affiliations as in the original paper; not printed on pages read — ⚠ not checked)
- **Venue / year / identifiers:** arXiv:2111.15323v3 [math.GT], 11 Oct 2022
- **File:** papers/5_ml_rl/Davies-Juhasz-Lackenby-Tomasev_2021_Signature_cusp_geometry_2111.15323.pdf   **Pages:** 28
- **Text layer:** ok (some fraction/subscript formulas garbled; theorem statements read from text and cross-checked against context)

## Abstract
We introduce a new real-valued invariant called the natural slope of a hyperbolic knot in the 3-sphere, which is defined in terms of its cusp geometry. We show that twice the knot signature and the natural slope differ by at most a constant times the hyperbolic volume divided by the cube of the injectivity radius. This inequality was discovered using machine learning to detect relationships between various knot invariants. It has applications to Dehn surgery and to 4-ball genus. We also show a refined version of the inequality where the upper bound is a linear function of the volume, and the slope is corrected by terms corresponding to short geodesics that link the knot an odd number of times.

## Notation and conventions
- (p. 1) Cusp torus of hyperbolic knot K ≅ C/Λ; meridian µ, longitude λ generate Λ. "slope(K) = Re(λ/µ)". Natural slope: geodesic perpendicular to meridian returns after going "along a longitude minus some number s of meridians"; s = slope(K) (not nec. an integer).
- (p. 7) Definition 2.1: Identify ∂N (maximal cusp boundary) with C/Λ so the longitude lifts to a segment 0→λ ∈ R_{>0} ("longitudinal translation") and the meridian to 0→µ with Im(µ) > 0 ("meridional translation"). |µ| ≤ 6 and |µ| ≥ 1 (p. 7). Note: Re(µ) in KnotInfo (≤ 12 crossings) is listed without signs; SnapPy computes signs.
- (p. 8) Definition 2.3: µ^⊥ unit vector orthogonal to µ; some multiple of µ^⊥ equals λ − sµ for s ∈ R; slope(K) := s.
- σ(K) = knot signature (signature of V+V^T for a Seifert matrix V) (p. 13). vol(K) = hyperbolic volume of S^3∖K. inj(K) = inf{inj_x(S^3∖K) : x ∈ (S^3∖K)∖N}, N a maximal cusp (p. 3). ε_3 = 3-dimensional Margulis constant (< 0.775 per p. 22 discussion).
- (p. 3–4) Definition 1.2 (twisting parameter): γ a geodesic with complex length cl(γ), Im cl(γ) ∈ (−π, π]; tw(γ) = (tw_p(γ), tw_q(γ)) = the pair (p,q) of coprime integers with p even, q odd and non-negative, minimising |cl(γ)p + 2πiq|, lexicographic ties. OddGeo(ε/2) = geodesics of length < ε/2 with odd linking number with K. κ(p,q) = −σ(T(p,q)) − pq/2 for torus knot T(p,q).
- (p. 5) length ℓ(s) of slope s = q/p: length of geodesic representative of pλ + qµ on maximal cusp boundary. g_4, g_4^top: smooth/topological 4-ball genus.
- (p. 13) Goeritz matrix G_F of unoriented surface F, normal Euler number e(F) = −lk(K,K′).

## Numbered statements
**Theorem 1.1 (p. 2, proved Sec. 4) — proved here.** There exists a constant c_1 such that, for any hyperbolic knot K, |2σ(K) − slope(K)| ≤ c_1 vol(K) inj(K)^{−3}. Experimental evidence suggests c_1 ≈ 0.3 suffices; the largest observed value of |2σ−slope| inj³/vol is 0.234 (p. 3; Fig. 10) and it is conjectured to be ≤ 0.3 (p. 25). In the proof (p. 13) the constant c_2 := 2c_1 + 3(1.82)³/2.0298 < 2c_1 + 8.92 is obtained, using inj(K) ≤ 1.82 and vol(K) > 2.0298 (figure-eight smallest, Cao–Meyerhoff).
Proof idea: build a spanning surface F with |χ(F)| ≤ c_1 vol inj^{−3} and boundary slope n/1 (n even closest to slope) (Theorem 1.7); apply Gordon–Litherland (Theorem 4.1): σ(K) = σ(G_F) + e(F)/2; |σ(G_F)| ≤ b_1(F).

**Definition 1.2 (pp. 3–4)** — see Notation.

**Theorem 1.3 (pp. 4, 19) — proved here.** Let ε_3 be the Margulis constant, and let ε ∈ (0, ε_3). Then there is a constant c_4 (depending on ε) such that for any hyperbolic knot K, the quantities σ(K) and slope(K)/2 − Σ_{γ∈OddGeo(ε/2)} κ(tw_p(γ), tw_q(γ)) differ by at most c_4 vol(K). (If ε = ε_3/2, c_4 becomes a universal constant, p. 19.)

**Lemma 1.4 (p. 5) — proved here (p. 8).** If K is a hyperbolic knot, then the length of the slope q/p satisfies ℓ(q/p) ≥ |p·slope(K) + q|. Hence, if q/p is exceptional, then q/p ∈ [−slope(K) − 6/p, −slope(K) + 6/p]. (Uses Agol–Lackenby: ℓ(s) > 6 ⇒ s not exceptional.) Example (p. 5): (−2,3,7)-pretzel knot 12n242: signature −8, slope ≈ −18.215, 7 exceptional slopes 16, 17, 18, 37/2, 19, 20 (⚠ text lists "7 exceptional slopes" but names six values: 16, 17, 18, 37/2, 19, 20; as printed). Also |p| ≤ 8 (Lackenby–Meyerhoff).

**Corollary 1.5 (p. 5).** If K is a hyperbolic knot and q/p is a slope satisfying |q/p + 2σ(K)| > 6/|p| + c_1 vol(K) inj(K)^{−3} or |p| > 8, then the manifold K(q/p) obtained by q/p Dehn surgery along K is hyperbolic.

**Corollary 1.6 (p. 6).** The topological 4-ball genus of a hyperbolic knot K satisfies g_4^top(K) ≥ |slope(K)|/4 − (c_1/4) vol(K) inj(K)^{−3}. (Follows from Thm 1.1 and g_4^top ≥ |σ|/2.)

**Theorem 1.7 (p. 6, proved Sec. 3) — proved here.** There is a constant c_3 such that every hyperbolic knot K in S^3 has an unoriented spanning surface F satisfying |χ(F)| ≤ c_3 vol(K) inj(K)^{−3}. Moreover, the boundary slope of this surface is n/1, where n is an even integer that is closest to slope(K).

**Proposition 2.5 (p. 8) — proved here.** If K is a hyperbolic knot in S^3, then |slope(K)|/(4π) + 1/2 ≤ g(K) (Seifert genus). Proof: |λ| ≤ 4πg(K) − 2π (2.2) and |µ| ≥ 1 give |slope| ≤ |λ|.

**Lemma 2.4 (p. 8).** slope(K) = Re(λ/µ) = λ Re(µ)/|µ|².

**Proposition 3.1 (p. 9) — proved here.** There is a constant c_1 such that, for every hyperbolic knot K in S^3 with embedded cusp neighbourhood N, there is a triangulation T of M := S^3∖(K ∪ int(N)) with: (1) number of tetrahedra t ≤ c_1 vol(K) inj(K)^{−3}; (2) if n is a closest even integer to slope(K), then ν := λ − nµ is a normal curve in ∂M that intersects each edge at most once.

**Theorem 1.8 (pp. 6, 15) — proved here.** Let K be a knot in S^3, C_1,…,C_n disjoint simple closed curves in the complement of K bounding disjoint discs, with S^3∖(K ∪ C_1 ∪ … ∪ C_n) hyperbolic. Let K(q_1,…,q_n) be obtained from K by adding q_i full twists to the strings through C_i; ℓ_i = lk(C_i, K). Suppose ℓ_1,…,ℓ_m are even and ℓ_{m+1},…,ℓ_n odd. Then there is a constant k (depending on K and C_i's) such that, provided each |q_i| is sufficiently large: |slope(K(q)) + Σ_{i=1}^n ℓ_i² q_i| ≤ k and |σ(K(q)) + (1/2)Σ_{i=1}^m ℓ_i² q_i + (1/2)Σ_{i=m+1}^n (ℓ_i² − 1) q_i| ≤ k.

**Corollary 5.1 (p. 16) — proved here.** There does not exist a constant c_2 such that |2σ(K) − slope(K)| ≤ c_2 vol(K) for every hyperbolic knot K. Proof: n = 1, ℓ_1 = 3: slope(K(q_1)) ∼ −9q_1 whereas 2σ(K(q_1)) ∼ −8q_1, while vol(K(q_1)) is bounded.

**Theorem 4.1 (p. 13; Gordon–Litherland, quoted).** Let F be an unoriented surface bounding the knot K in S^3. Then σ(K) = σ(G_F) + e(F)/2.

**Definition 4.2 (p. 14) — signature correction κ(p,q).** Recursively for positive integers: (1) if p > 2q and q odd: κ(p,q) = κ(p−2q,q) − 1; (2) if p > 2q and q even: κ(p,q) = κ(p−2q,q); (3) if p = 2q: κ(p,q) = −1; (4) if q ≤ p < 2q and q odd: κ(p,q) = −κ(q,2q−p) − 1; (5) if q ≤ p < 2q and q even: κ(p,q) = −κ(q,2q−p) − 2; (6) if p < q: κ(p,q) = κ(q,p). Extended: κ(−p,q) = κ(p,−q) = −κ(p,q); κ(p,q) = 0 if p or q is zero.

**Theorem 4.3 (p. 14; Gordon–Litherland–Murasugi, quoted).** σ(T(p,q)) = −pq/2 − κ(p,q).
**Lemma 4.4 (p. 14).** For T(p,q) on ∂V with p even, q odd (p = winding number in V), there is a compact unoriented surface F in V with boundary T(p,q), and σ(G_F) = −κ(p,q) for any such F.
**Lemma 4.5 (p. 15).** For non-singular real square A and A^+ obtained by adding a final row and column (non-singular), σ(A^+) = σ(A) ± 1 (Cauchy interlacing).
**Lemma 4.6 (p. 15).** For solid torus V ⊂ S^3, slope λ on ∂V with winding number 1, K the knot on ∂V with slope pλ + qµ (p even, q odd): K bounds a compact unoriented surface F in V with |σ(G_F) + κ(p,q)| ≤ 2.

**Definition 6.1 (p. 19)** canonical longitude of an embedded closed geodesic γ; λ = cosh(r) Re(cl(γ)) + sinh(r) Im(cl(γ)) i (with µ = 2π sinh(r) i, ν length = cosh(r) Re(cl(γ))).
**Lemma 6.2 (p. 19–20).** For hyperbolic 3-manifold M, ε ∈ (0,ε_3), geodesic γ of length < ε/2, T the toral boundary component of M_{(0,3ε/4]} enclosing γ, µ meridian, λ canonical longitude, (p,q) = (tw_p(γ), tw_q(γ)): ℓ(pλ + qµ) ≤ c_5 Area(T) for a constant c_5 depending only on ε.

**Definition 7.1 (p. 26).** The normalised signature of a hyperbolic knot K is σ̄(K) := σ(K)/vol(K).
**Corollary 7.2 (p. 26) — proved here.** There exists a hyperbolic knot K with |σ̄(K)| > 1 [as printed "|σ(K)| > 1"], but with σ(K) and Re(µ(K)) having opposite signs. Proof: highly twisted knots K(q_1,q_2) with ℓ_1 = 2, ℓ_2 = 3, q_1 = 17q, q_2 = −8q: slope ∼ −4·17q + 9·8q = 4q, σ ∼ −2·17q + 4·8q = −2q.
**Conjecture 7.3 (p. 26) — open.** If K is a hyperbolic knot in S^3 with |σ(K)| > 1, then σ(K) and Re(µ(K)) have the same sign asymptotically almost surely.
**Conjecture 7.4 (p. 26) — open.** There are constants b and c such that for any hyperbolic knot K, |2σ(K) − slope(K)| ≤ b vol(K) + c asymptotically almost surely. (Data suggests b < 2 (Fig. 13), then 7.4 ⇒ 7.3 for large volume a.a.s.)

## Key equations and quantitative claims outside numbered statements
- (p. 2) "Experimentally … the natural slope of K is very highly correlated with 2σ(K)" (Fig. 3: signature vs slope for knots up to 16 crossings in the Regina census and for random knots from SnapPy with 10–80 crossings in SnapPy-simplified form).
- (p. 4) Fig. 4: stevedore knot 6_1 (slice): longitude 3.9279, meridian 0.7237 + 1.0160i, natural slope 1.8267, signature 0. Fig. 5: knot 12a52: longitude 27.7228, meridian −1.2838 + 0.5145i, natural slope −18.6064, signature −8.
- (p. 7) Methodology: "We embarked with the aim of discovering new relationships between various 3-dimensional invariants. By using machine learning, we observed an unexpected non-linear relationship between σ(K) and Re(µ), the real part of the meridional translation µ. This led us to define the natural slope, which we observed to have a strong linear correlation with σ(K)." No architecture, dataset sizes, or training details are given in this paper (⚠ ML procedure not described beyond this paragraph and Sec. 7 initial scatter plots).
- (p. 24) Initial scatter plots compared 4-dimensional invariants (signature, Heegaard Floer τ, ν, ε), crossing number, and hyperbolic invariants (volume, meridional and longitudinal translations, Chern–Simons invariant); "the strongest and most surprising correlation was between the signature and the real part of the meridional translation" (Fig. 2).
- (p. 7–8) Geometry bounds: |λ| ≤ 4πg(K) − 2π (2.2); vol(∂N) = 2vol(N) ≤ 2vol(K); vol(∂N) ≤ |λ||µ|; for alternating K, C vol(K) ≤ vol(∂N) (Lackenby–Purcell).
- (p. 25–26) Random-knot heuristics: vol(K) ≤ A c(K) (known); conjecturally a c(K) ≤ vol(K) a.a.s. (fails for twist knots/highly twisted knots); if eigenvalue signs of the Goeritz matrix were independent, E|σ(K)| ≈ C c(K) with C ≈ 2 empirically (p. 26).
- (p. 25) Fig. 11: max and mean of c_1(K) by crossing number (Regina census ≤ 16 crossings); Fig. 12: injectivity radius vs volume scatter for random knots with 10–80 crossings (inj typically not small).

## Methods / algorithms
Pure math proof; steps:
1. Define natural slope from cusp geometry (Sec. 2).
2. Sec. 3: construct a thick triangulation of M = S^3∖(K ∪ int N) via Voronoi diagram of a maximal ε/8-separated set P ∩ ∂M plus interior points ε/4-separated (ε = inj(K)/2); bound |P| by volume; bound tetrahedra per vertex by universal constant; get t ≤ c_1 vol inj^{−3}; find normal curve ν = λ − nµ crossing each edge at most once; build spanning surface with boundary slope n/1 from normal surface theory (|χ(F)| ≤ c_3 vol inj^{−3}).
3. Sec. 4: Gordon–Litherland to compute σ from spanning surface (Theorem 1.1).
4. Sec. 5: twisting analysis (Theorem 1.8, Cor. 5.1).
5. Sec. 6: use geodesics of length < ε/2 with odd linking number; solid-torus pieces; Lemma 4.5, 4.6; counting |OddGeo(ε/2)| ≤ c_8 vol(K)/a_0 (Theorem 1.3).
6. Sec. 7: experimental data and conjectures.

## Tables
None.

## Figures
- **Fig. 1 (p. 2)** — "A geodesic running in the direction µ^⊥ that is perpendicular to the meridian µ. By the time it returns to the meridian, it has travelled one longitude minus some multiple s of the meridian. This real number s is the natural slope of K." Image: ../figures/DJLT21/p02.png
- **Fig. 2 (p. 2)** — "A plot of signature versus the real part of the meridional translation, Re(µ), coloured by longitudinal translation, for a dataset of knots randomly generated by SnapPy." *What it shows:* scatter of σ vs Re(µ) showing non-linear relationship. Image: ../figures/DJLT21/p02.png
- **Fig. 3 (p. 3)** — "A plot of signature versus slope for knots up to 16 crossings in the Regina census (left) and for a dataset of knots randomly generated by SnapPy having 10 to 80 crossings in their SnapPy-simplified form (right)." *What it shows:* near-linear relation σ ≈ slope/2. Image: ../figures/DJLT21/p03.png
- **Fig. 4 (p. 4)** — "Left: The stevedore knot 6_1 … Right: Its cusp torus, as provided by SnapPy. The longitude is 3.9279 and the meridian is 0.7237 + 1.0160i. Its natural slope is 1.8267 and its signature is 0." **Fig. 5 (p. 4)** — "Left: The knot 12a52. Right: Its cusp torus. The longitude is 27.7228 and the meridian is −1.2838 + 0.5145i. Its natural slope is −18.6064 and its signature is −8. Note how far the parallelogram is from being right-angled; this is the defining feature of having very positive or very negative slope." Image: ../figures/DJLT21/p04.png
- **Fig. 6 (p. 8)** — calculation of natural slope in C. **Fig. 7 (p. 11)** — fundamental domain D in ∂N_max with sides µ and ν. **Fig. 8 (p. 17)** — "Each full twist about C_i changes the linking number between γ and K(q_1,…,q_n) by 2ℓ_i." **Fig. 9 (p. 18)** — "The part of the spanning surface in N(C_i) for i ≥ m+1. Here, q_i = 5 or 6."
- **Fig. 10 (p. 24)** — "The distribution of c_1(K) := |2σ(K) − slope(K)| inj(K)³/vol(K) for knots up to 16 crossings in the Regina census." **Fig. 11 (p. 25)** — "The maximum (left) and the mean (right) of c_1(K) as functions of the crossing number…" **Fig. 12 (p. 25)** — "A scatter plot of injectivity radius versus volume for random knots of 10-80 crossings." Image: ../figures/DJLT21/p25.png
- **Fig. 13 (p. 27)** — "The distribution of (2σ(K) − slope(K))/vol(K) for knots up to 16 crossings in the Regina census."

## Stated limitations, open problems, future work
- Conjectures 7.3 and 7.4 open; constant c_1 conjectured ≤ 0.3 but only c_1 existence proved (pp. 3, 25).
- inj(K)^{−3} factor cannot be dropped (Cor. 5.1) in the form |2σ−slope| ≤ c vol; refined Theorem 1.3 removes inj dependence at cost of correction terms.
- "Given the present uncertainty about the precise value of ε_3, we do not specify ε definitively" (p. 19).
- Open question (p. 8): does C vol(K) ≤ vol(∂N) hold for random (non-alternating) knots (asked "based on experimental data").

## References worth following
- Gordon–Litherland (signature from spanning surfaces, [12]); Gordon–Litherland–Murasugi [13] (torus link signature).
- Agol [1], Lackenby [16] (6-theorem); Lackenby–Meyerhoff [17] (≤ 8 exceptional); Cooper–Lackenby [7]; Hass–Rubinstein–Wang [14]; Cao–Meyerhoff [6]; Lackenby–Purcell [18]; Jørgensen/Thurston triangulation [22].
- Davies et al. (DeepMind) "Advancing mathematics by guiding human intuition with AI", Nature 600 (2021) — companion paper (cited elsewhere in the wiki as the ML account); [8] SnapPy; [5] Regina census; [19] KnotInfo.

## Extraction notes
- All 28 pages read from text layer; figures not inspected beyond captions; no tables.
- Lattice relevance: none (hyperbolic geometry/signature), included as an example of ML-guided conjecture discovery whose proof is purely geometric; the machine-learning methodology is not described in this paper.
- ⚠ Corollary 7.2 as printed reads "|σ(K)| > 1" in the statement but Definition 7.1 introduced normalised signature σ̄ = σ/vol (bar lost in text layer); in Conjecture 7.3 "|σ(K)| > 1" is also ambiguous. ⚠ "7 exceptional slopes" vs six listed.
