# HNO14links — Links with small lattice stick numbers
- **Authors:** Kyungpyo Hong, Sungjong No, Seungsang Oh
- **Venue / year / identifiers:** arXiv:1402.1642v1 [math.GT], 7 Feb 2014 (PACS 02.10.Kn, 82.35.Pq, 02.40.Sf)
- **File:** papers/4_links/Hong-No-Oh_2014_Links_small_lattice_stick_numbers_1402.1642.pdf   **Pages:** 9
- **Text layer:** partly garbled (link names with sub/superscripts such as 2^2_1 come out as "212"/"221"; resolved from page images p. 1-3)

## Abstract
Knots and links have been considered to be useful models for structural analysis of molecular chains such as DNA and proteins. One quantity that we are interested on molecular links is the minimum number of monomers necessary to realize them. In this paper we consider every link in the cubic lattice. Lattice stick number s_L(L) of a link L is defined to be the minimal number of sticks required to construct a polygonal representation of the link in the cubic lattice. Huh and Oh found all knots whose lattice stick numbers are at most 14. They proved that only the trefoil knot 3_1 and the figure-8 knot 4_1 have lattice stick numbers 12 and 14, respectively. In this paper we find all links with more than one component whose lattice stick numbers are at most 14. Indeed we prove combinatorically that s_L(2^2_1) = 8, s_L(2^2_1 ♯ 2^2_1) = s_L(6^3_2) = s_L(6^3_3) = 12, s_L(4^2_1) = 13, s_L(5^2_1) = 14 and any other non-split links have stick numbers at least 15.

## Notation and conventions
- Lattice link: polygonal link in the cubic lattice Z³ = (R×Z×Z) ∪ (Z×R×Z) ∪ (Z×Z×R) (p. 1). Stick = straight segment; s_L(L) = minimal number of sticks of a polygonal representation of L in Z³ (p. 1). A stick may have any integer length: this is NOT lattice step length, and no ropelength is involved.
- Total curvature of a lattice link = (π/2)·s_L(L), since every angle between adjacent sticks is π/2 (p. 2).
- Link names c^n_k (c crossings, n components): 2^2_1 (Hopf), 4^2_1, 5^2_1, 6^3_2, 6^3_3, 2^2_1♯2^2_1 (Fig. 1, p. 3).
- Equivalent lattice links = ambient isotopic in R³; L reducible if an equivalent lattice link has fewer sticks, else irreducible (p. 2).
- |L| = number of sticks; |L|_x = number of x-sticks; (L) := (|L|_x, |L|_y, |L|_z) (p. 2-3). x-level k = yz-plane with x-coordinate k; an x-stick with endpoints on x-levels i, j has length |i−j| (p. 3).
- Properly leveled (wrt x): each x-level contains exactly two endpoints of x-sticks; properly leveled = for each coordinate. Extended properly leveled (wrt x): each x-level contains either exactly two endpoints of x-sticks or exactly one component L^i of L; extended properly leveled = for each coordinate (p. 3).
- L^i planar: contained in a plane P^i; P^i_b, P^i_u = bounded and unbounded components of P^i \ L^i (p. 4).

## Numbered statements
- **Theorem 1 (p. 2).** There are only 6 links (with more than one component) whose lattice stick number is less than or equal to 14. These links are 2^2_1, 2^2_1♯2^2_1, 6^3_2, 6^3_3, 4^2_1 and 5^2_1. Furthermore, it is known that s_L(2^2_1) = 8, s_L(2^2_1♯2^2_1) = s_L(6^3_2) = s_L(6^3_3) = 12, s_L(4^2_1) = 13 and we have further shown here that s_L(5^2_1) = 14. *Proved here (p. 4-8); upper bounds from the six lattice links of Fig. 1; s_L(4^2_1) = 13 is described as "known" (Adams et al. [2], p. 2).* ⚠ p. 4 says "we can easily prove that s_L(2^2_1) = 8 and s_L(2^2_1♯2^2_1) = s_L(6^3_2) = s_L(6^3_3) = 12" while p. 6 re-derives that 4^2_1 is the only link with s_L = 13, so "known" vs "shown here" is blurred.
- **Lemma 2 (p. 3).** For a lattice link L, there is an extended properly leveled lattice link L′ equivalent to L so that |L′| = |L| (indeed, the numbers of x, y and z-sticks have remained unchanged). *Proved here (following Lemma 2.1 of Huh–Oh [7]).* Proof idea: at z-level m with p whole components and q partial pieces, insert p+q−1 new z-levels between levels m and m+1, lift the pieces so each new level holds exactly one, extend attached z-sticks; repeat for every level and for x, y.
- **Proposition 3 (p. 4).** Suppose that L is a non-split link with at most 14 sticks which is neither 2^2_1 nor 2^2_1♯2^2_1. Suppose that L^i is planar for some i where P^i is perpendicular to the z-axis, for example. Then L has exactly four z-sticks, and furthermore two z-sticks pass through P^i_b and the other two z-sticks pass through P^i_u. *Proved here.* ⚠ Statement printed as "neither 221 nor 212♯212" in the text layer (normalised here); preceding text excludes "221 and 212♯221". Proof idea: if no z-stick passes through P^i_b, L^i splits off; if only one, L^i shrinks to a point (L is 2^2_1 or has a 2^2_1 summand); so ≥ 2 z-sticks through each of P^i_b, P^i_u; ≥ 6 z-sticks gives |L \ L^i| ≥ 12, contradicting |L| ≤ 14; exactly 5 forces |L| ≥ 15.
- No other numbered statements (no corollaries, conjectures or open problems).

## Key equations and quantitative claims outside numbered statements
- p. 1 (quoted): Negami s(K) ≤ 2c(K) for nontrivial K (ordinary stick number); Huh–Oh [9] s(K) ≤ (3/2)(c(K)+1), and s(K) ≤ (3/2)c(K) for non-alternating prime K.
- p. 2 (quoted): s_L(trivial knot) = 4; Janse van Rensburg–Promislow [11]: s_L(K) ≥ 12 for any nontrivial knot; Huh–Oh [7,8]: s_L(3_1) = 12, s_L(4_1) = 14, s_L(K) ≥ 15 for any other nontrivial knot (proper levelness).
- p. 2 (quoted from Adams et al. [2], "announced"): s_L(8_20) = s_L(8_21) = s_L(9_46) = 18, s_L(4^2_1) = 13, s_L(T_{p,p+1}) = 6p for p ≥ 2 ((p,p+1)-torus knot); uses s_L(K) ≥ 6b(K) (b = bridge number), proved in [11].
- p. 2 (quoted): Diao–Ernst [4]: s_L(K) ≥ 3√(c(K)+1) + 3 for nontrivial K (image-checked). Hong–No–Oh [6]: s_L(K) ≤ 3c(K)+2, and ≤ 3c(K) − 4 for non-alternating prime K.
- p. 4: components: "|L^i|_x = 1, |L^i|_x ≤ |L^i|/2 and also |L^i| = 4 or |L^i| ≥ 6" (⚠ text layer as printed, likely "≥ 1"; not image-verified). So each component has 4 or ≥ 6 sticks.
- p. 4: since s_L(nontrivial knot) ≥ 12 and |L| ≤ 14, all components are trivial knots (two or three).
- p. 4-8 case results (rigorous, combinatorial): Case 1 (all components non-planar): (L) ∈ {(4,4,4),(4,4,5),(4,4,6),(4,5,5)}; yields nothing new (building 4^2_1 from the 8-crossing projection would need 14 sticks, contradicting s_L(4^2_1) ≤ 13). Case 2 (one planar component): |L| ≤ 12 ⇒ c(L) ≤ 2; |L| = 13 ⇒ c(L) ≤ 4, 4^2_1 the only link with s_L = 13; |L| = 14 ⇒ c(L) ≤ 5, 5^2_1 the only link with s_L = 14. Case 3 (≥ 2 planar components): 2 components need |L| ≥ 16 (impossible); 3 components give 6^3_3 (Fig. 4(b)) or 6^3_2 (Fig. 4(c)), else reducible or split.
- p. 8 (Conclusion): results "obtained by purely analytic calculations instead of numerical calculations".
- p. 2: cites [15] (Plunkett et al.) numerical scaling of total curvature vs polygon length, knots up to six crossings; [17] (Scharein et al.) as another numerical estimate of s_L.

## Methods / algorithms
Pure-math case analysis.
1. (p. 3) Extended proper levelness; Lemma 2.
2. (p. 4) L non-split, irreducible, n ≥ 2 components, |L| ≤ 14; 2^2_1 and 2^2_1♯2^2_1 handled directly; components are trivial knots with 4 or ≥ 6 sticks.
3. (p. 4) Proposition 3 on planar components.
4. (p. 4-5) Case 1: enumerate xy-projections (Fig. 2) for the possible (L); show not alternating / split / reducible / too few crossings.
5. (p. 5-7) Case 2: enumerate projections of L^2 (Fig. 3), use Prop. 3 to exclude ≥ 5 (|L|=13) or ≥ 6 (|L|=14) crossings.
6. (p. 7-8) Case 3: ≥ 2 planar components with perpendicular planes; analyse passages through bounded regions (Fig. 4).

## Tables
None.

## Figures
- **Fig. 1 (p. 3)** — Six examples of lattice links. *What it shows:* lattice stick realisations of 2^2_1, 4^2_1, 5^2_1 (top) and 2^2_1♯2^2_1, 6^3_2, 6^3_3 (bottom). Image: ../figures/HNO14links/p03.png
- **Fig. 2 (p. 5)** — Two non-planar components. *What it shows:* xy-projections of non-planar components (2 x-sticks, 2 or 3 y-sticks) and of combined links (rows 1-3). Image: ../figures/HNO14links/p05.png
- **Fig. 3 (p. 6)** — One planar and one non-planar components. *What it shows:* configurations of L^2 and the combinations with ≥ 6 crossings. Image: ../figures/HNO14links/p06.png
- **Fig. 4 (p. 7)** — 3-component link cases. *What it shows:* panels (a)-(c): reducible configuration, 6^3_3, 6^3_2. Image: ../figures/HNO14links/p07.png

## Stated limitations, open problems, future work
- p. 8: "For future work, we try to find all links with the lattice stick number 15. In this case we have to handle more diagrams in each case." Proper levelness "doesn't work any more" for links, hence the extension.

## References worth following
- [7] Huh, Oh, The lattice stick numbers of small knots, JKTR 14 (2005) 859-868.
- [8] Huh, Oh, Knots with small lattice stick numbers, J. Phys. A 43 (2010) 265002.
- [11] Janse van Rensburg, Promislow, The curvature of lattice knots, JKTR 8 (1999) 463-490.
- [2] Adams et al., Stick index of knots and links in the cubic lattice, arXiv:1205.5256.
- [4] Diao, Ernst, Total curvature, rope length and crossing number of thick knots, Math. Proc. Camb. Phil. Soc. 143 (2007) 41-55.
- [6] Hong, No, Oh, Upper bound on lattice stick number of knots, Math. Proc. Camb. Phil. Soc. 155 (2013) 173-179.
- [17] Scharein et al., Bounds for the minimum step number of knots in the simple cubic lattice, J. Phys. A 42 (2009) 475006.

## Extraction notes
- Pages 1-7 rendered; link names and the Diao-Ernst formula checked on p. 1-3 images; Figs 2-4 described from captions/text only.
- ⚠ Link notation inconsistent in the original ("623" vs "632", "421" vs "412"); normalised to c^n_k.
- Relevance: lattice STICK number of links (not step number, not ropelength); every other non-split link has s_L ≥ 15.
