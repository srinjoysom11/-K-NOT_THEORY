# Klotz26pearl — Pearl necklace knots with fewer vertices than an equivalent FCC lattice knot
- **Authors:** Alexander R. Klotz (Department of Physics and Astronomy, California State University, Long Beach)
- **Venue / year / identifiers:** arXiv:2608.19441v1 [math.GT] 19 Aug 2026 (as printed in the margin of p. 1)
- **File:** papers/3_analytic_bounds/Klotz_2026_Pearl_necklace_vs_FCC_lattice_knots_2608.19441.pdf   **Pages:** 9
- **Text layer:** ok (appendix coordinate lists are two-column and partly interleaved in the text layer)

## Abstract
The pearl necklace number, N_P, of a knot is the smallest number of unit spheres required to construct a knot if each sphere is tangent to two neighbors and no sphere overlaps with another. It has been speculated that the pearl necklace number is equal to the minimum number of lattice sites required to embed a knot on a face centered cubic (FCC) lattice N_L, implying that a trefoil knot cannot be constructed from fewer than 15 spheres. A large language model (LLM) was prompted to find configurations of knot for which N_P < N_L, and this manuscript describes its findings, attempts at validating them, and their implications. No 14-vertex example was found for the trefoil knot, but examples with N_P = N_L − 1 were found for all knots from 5 to 7 crossings as well as 8_19, and 10_124. One example, 8_1, could be constructed with N_P = N_L − 2.

## Notation and conventions
- **Pearl necklace knot** (p. 1): "an equilateral polygonal knot constructed from spheres of equal radius (taken to be 1) such that each sphere is tangent to its two neighbors, with no overlaps between non-adjacent spheres." So consecutive centres are at distance exactly 2, non-adjacent centres at distance ≥ 2 (p. 2: "adjacent vertices must be separated by a distance of exactly 2, and non-adjacent vertices must be separated by at least 2").
- **N_P** (p. 1): "the minimum number of spheres required to construct a given knot. Exact values for N_P are unknown. A lower bound on N_P is the stick number of the knot and the upper bound is the minimum number of sites required to embed the knot on a face-centered cubic (FCC) lattice."
- **N_L**: FCC lattice number — minimum number of FCC lattice sites to embed the knot; computed for up to 10 crossings by Janse van Rensburg–Rechnitzer [1]; trefoil N_L = 15 (p. 1).
- **Minimum clearance** (p. 2): "the smallest distance above 2 between non-adjacent spheres".
- **MD energy** (p. 1): minimum distance energy of a polygonal knot, "which increases as the line segments of polygonal knots approach each other."
- C = crossing number (p. 3–4).
- No ropelength convention is defined in this paper; the only ropelength statement is the LLM-claimed bound on p. 4 (see below), whose convention is not stated.

## Numbered statements
None (no theorems/lemmas). The paper contains two hypothesised scaling relations (Eqs. 1–2), transcribed below, explicitly stated "in the absence of data".

## Key equations and quantitative claims outside numbered statements
- p. 1 (quoted): Maehara and collaborators [3–5] established a lower bound for the pearl necklace number of the trefoil "(at 11)" via MD energy. Open problem [2] (Baykur–Kirby–Ruberman problem list): can a trefoil be constructed from 14 or fewer tangent spheres?
- p. 1 (numerical, LLM): 14-sphere trefoil search unsuccessful; minimum distance between non-adjacent spheres 1.98579138665 (< 2).
- p. 1–2 (numerical, LLM-generated, author-validated): N_P ≤ N_L − 1 configurations for 5_1, 5_2, 6_1–6_3, 7_1–7_7, 8_19, 10_124; 8_1 with 32 vertices vs N_L = 34 (N_P ≤ N_L − 2). Full list Table I. These are upper bounds on N_P (constructions), not exact values.
- p. 2: two-vertex-removal search (8–10 crossings) was non-exhaustive: checked 8_19, 9_1, and 10-crossing knots 1, 20, 55, 82, 100, 124, 127, 135, 146, 153; found only 8_1.
- p. 2: initial LLM configurations had edge-length deviations from 2 "on the order of 10^{−13}". After human refinement, deviation "effectively zero or within the uncertainty of a float variable, 2^{−52}"; e.g. 8_1 configuration has seven edges of length 2 − 2.22·10^{−16}, three of 2 + 4.44·10^{−16}, rest exactly 2. Refinement displacements are "a billionth of the typical clearance".
- p. 2: Many minimum clearances ≈ 0.0299, "likely arises because target was only a non-overlapping configuration, not one that maximizes this parameter".
- p. 2–3: Exact algebraic scheme (Appendix B): edge vectors as harmonic functions of rational multiples of π, "with the fractions having numerators and denominators of order 1000" (Table II actually shows 4-digit numerators/denominators).
- p. 3 (numerical, LLM): partial-lattice configurations: 6_1 with 16 of 26 sites on FCC lattice (Fig. 2); 8_1 with 26 of 33 sites; 10_124 with 22 of 32 sites.
- p. 3 (heuristic / hypothesis, no data): assuming N_L scales with C like ropelength: N_L ∝ C (alternating), N_L ∝ C^{3/4} (non-alternating); surface sites ∝ N_L^{2/3}; hence hypothesised
  - Eq. (1): (N_L − N_P) ∝ C^{2/3} (alternating)
  - Eq. (2): (N_L − N_P) ∝ C^{1/2} (non-alternating)
- p. 3–4: 5_1 pearl necklace knot MD energy "near 144, which could be minimized to 133". "the number of vertices that minimizes MD energy for a knot appears to be close to N_L and N_P."
- p. 4 (LLM claim, NOT verified): LLM "purported a stronger constant for Buck's three-quarter coefficient of 1.105 [9], allegedly proving that the ropelength of a knot with crossing number C must be at least (4π/4.724)^{3/4} C^{3/4} ≈ 2.08 C^{3/4}. I have not evaluated the rigor of this claim". (Ropelength convention unspecified.)
- p. 4 (LLM negative result): LLM did not find a non-trivial knot with trivial Jones polynomial.

## Methods / algorithms
LLM role (as stated): ChatGPT "version GPT-5.6 Pro" (p. 1) found the configurations; author supplied target vertex counts and knot choices; author validated and refined. Acknowledgements (p. 4): "In addition to finding the actual results of this research, the LLM was used to produce LaTeX tables but was not involved in the writing of the manuscript." Transcript rendering, two LLM scripts, and a screenshot about ropelength bounds are in ancillary files (p. 4).
1. (p. 1–2) Prompts: 14-sphere trefoil (failed); 32-vertex 10_124 (N_L = 33, success); 8_19 (N_L = 28, success); 4_1 (failed); then, pointed to Rechnitzer's website [7] lattice coordinates (all knots ≤10 crossings), all knots ≤7 crossings with one fewer vertex (all successful). Author chose non-alternating torus knots first because they "typically have the smallest ropelength at a given crossing number".
2. (p. 2) LLM's described method: remove a vertex from the lattice configuration and evolve towards an equilateral state while preserving topology. P. 3: "Most of the methods used by the LLM appear to be based on gradient descent towards an equilateral configuration". LLM's own summary (p. 4): FCC lattice embeddings and standard torus-knot parametrizations as seeds, relaxed off-lattice by constrained nonlinear optimization; candidates evaluated by edge-length error, minimum non-neighbour sphere clearance, nonadjacent-edge separation, preservation of knot type.
3. (p. 2) Validity checks: (i) topology unchanged — Alexander polynomial evaluation of each configuration; (ii) adjacent distance exactly 2; (iii) non-adjacent distance ≥ 2 — checked directly provided minimum distance not close enough to 2 to suspect rounding.
4. (p. 2) Human refinement procedure: (a) compute unit vectors n̂_i between r⃗_i and r⃗_{i+1} (cyclic); (b) rebuild r⃗_{i+1} = r⃗_i + 2n̂_i for i > 1, pushing all error into the closing edge; (c) P⃗ = midpoint of r⃗_1 and r⃗_{N_P−1}, |v| their distance, v̂ unit vector between them; (d) δ = v̂·(r⃗_{N_P} − P⃗), subtract along v̂ so the last vertex lies in the bisecting plane; (e) v̂_2 = unit vector from P⃗ to new r⃗_{N_P}; (f) h = √(4 − |v|²/4); (g) r⃗_{N_P} = b⃗ + h v̂_2 (⚠ b⃗ undefined; presumably P⃗). A final non-overlap check is needed.
5. (p. 2–3, App. B) Exact construction (LLM-produced): E_i(a_i,b_i) = ⟨2cos(πa_i)cos(πb_i), 2sin(πa_i)cos(πb_i), 2sin(πb_i)⟩ (B1); R_19 = −Σ_{i=1}^{19} E_i (B2); W = (E_20 − E_21)/2 (B3); U = W − (W·R/R·R) R, λ = √((4 − ¼ R·R)/(U·U)) (B4); E_20 = R/2 + λU, E_21 = R/2 − λU (B5); vertices = cumulative sums from origin.
6. (p. 3) LLM-produced replication scripts: Python version "too slow to validate on my computer"; MATLAB version "tested on a few knots but did not produce non-overlapping configurations during my attempts at validation."
7. (p. 4) Author's own prior attempts (crankshaft moves; energy minimization with penalties) were unsuccessful.

## Tables
**Table I (p. 2).** "Knots found with N_P < N_L." (Best N_P = vertex count of the constructed configuration.)

| Knot | N_L | Best N_P | Minimum clearance |
|---|---|---|---|
| 5_1 | 22 | 21 | 0.000741768 |
| 5_2 | 23 | 22 | 0.029976777 |
| 6_1 | 27 | 26 | 0.029980437 |
| 6_2 | 27 | 26 | 0.029920813 |
| 6_3 | 28 | 27 | 0.029972539 |
| 7_1 | 29 | 28 | 0.029959263 |
| 7_2 | 30 | 29 | 0.029900448 |
| 7_3 | 30 | 29 | 0.029860976 |
| 7_4 | 30 | 29 | 0.009917403 |
| 7_5 | 31 | 30 | 0.029966925 |
| 7_6 | 31 | 30 | 0.029969891 |
| 7_7 | 31 | 30 | 0.029952571 |
| 8_1 | **34** | **32** | 0.014334921 |
| 8_19 | 28 | 27 | 0.020367894 |
| 10_124 | 33 | 32 | 0.012391365 |

**Table II (p. 9).** "Rational angle coefficients for the exact 21-vertex 5_1 construction. The final two sets may be used to satisfy the equilateral closure constraint." (a_i = a_i^num / a_i^den, b_i = b_i^num / b_i^den.)

| i | a_i^num | a_i^den | b_i^num | b_i^den |
|---|---|---|---|---|
| 1 | 7789 | 9814 | 812 | 9033 |
| 2 | -9548 | 9991 | -1590 | 9641 |
| 3 | 911 | 1264 | -1047 | 6352 |
| 4 | 9118 | 9385 | 413 | 4597 |
| 5 | -4952 | 8253 | 1243 | 6499 |
| 6 | -1069 | 5090 | 145 | 4586 |
| 7 | -1207 | 3877 | -2699 | 8089 |
| 8 | -2911 | 8182 | 91 | 2371 |
| 9 | 128 | 3117 | 1307 | 7894 |
| 10 | 3733 | 8221 | 233 | 3432 |
| 11 | 3851 | 8964 | -1217 | 3984 |
| 12 | 791 | 1411 | 197 | 6934 |
| 13 | 2896 | 3281 | 1653 | 7487 |
| 14 | -6956 | 8745 | 38 | 1345 |
| 15 | -6094 | 9171 | -1097 | 3589 |
| 16 | -4728 | 6863 | 667 | 9851 |
| 17 | -1327 | 4808 | 1371 | 8285 |
| 18 | 1161 | 9601 | 162 | 4207 |
| 19 | 508 | 6619 | -2493 | 7474 |
| 20 | -65 | 2617 | 256 | 8083 |
| 21 | 2886 | 7903 | 1889 | 9867 |

**Appendix A (pp. 6–8), coordinate lists (not a numbered table).** Sphere-centre coordinates "determined by the LLM", "equilaterall to approximately 12 decimal places": 5_1 (21 vertices), 5_2 (22), 6_1 (26), 6_2 (26), 6_3 (27), 7_1 (28), 7_2 (29), 7_3 (29), 7_4 (29), 7_5 (30), 7_6 (30), 7_7 (30), 8_1 (32), 8_19 (27), 10_124 (32); partial-lattice configurations: 6_1 (26 vertices, 2–9, 16–23 on lattice), 8_1 (33 vertices, 1–3, 7–21, 26–33 on lattice), 10_124 (32 vertices, 1–2, 6–11, 15–23, 28–32 on lattice). Not transcribed here (see Extraction notes). *Full coordinates in `wiki/data/Klotz26pearl_appendixA_coordinates.csv` (2026-11-12).*

## Figures
- **Fig. 1 (p. 1)** — "An 8_1 knot embedded on an FCC lattice with 34 sites (left) and constructed from 32 tangent spheres (right). Top images show a ball-and-stick visualization, bottom images show space-filling spheres color-coded by index." *What it shows:* tube rendering of 8_1 at top, ball-and-stick FCC (34) vs pearl necklace (32), and space-filling sphere renderings. Image: ../figures/Klotz26pearl/p01.png
- **Fig. 2 (p. 3)** — "A 6_1 pearl necklace knot in which 16 of 26 sites (with larger markers) lie on an FCC lattice. 27 sites are required to fully embed the same knot on the lattice." *What it shows:* projected polygon drawing; large dots (lattice sites) form the lower twisted region, small dots the off-lattice clasp at top. Image: ../figures/Klotz26pearl/p03.png

## Stated limitations, open problems, future work
- p. 3: "the 14-pearl trefoil conjecture remains open."
- p. 3: Two reasons results might not show N_P < N_L: (1) numerical imprecision significant — "I deem this unlikely after the knots survive the refinement procedure, and exact lengths can be proscribed with the harmonic parameterization"; (2) N_L actually smaller than reported in [1] — possible at higher crossing number "but I do not suspect it to be so for the simpler knots (those with up to 8 crossings...)". Alternative check: exhaustively enumerate every self-avoiding polygon of length 21 (5_1, N_L = 22).
- p. 3: Open: whether N_L − N_P stays 1–2 or grows with crossing number; limited because N_L only computed to 10 crossings. Eqs. (1)–(2) hypothesised "in the absence of data".
- p. 3: Alternative generation strategy: crankshaft moves until three consecutive vertices form an equilateral triangle, then remove the centre one; "The LLM was unable to find a sequence of moves that would allow this."
- p. 4: Pathway to proofs: derive MD-energy minimum for equilateral knots and compare to global minimum at given vertex count.
- p. 4: "Could I have eventually found such configurations without using an LLM? I do not know." LLM ropelength-bound claim "I have not evaluated the rigor of this claim".

## References worth following
- [1] E.J. Janse van Rensburg and A. Rechnitzer, Minimal knotted polygons in cubic lattices, J. Stat. Mech. 2011(09):P09008, 2011.
- [2] R. Baykur, R. Kirby, D. Ruberman, K3: A new problem list in low-dimensional topology, Math. Surveys and Monographs vol. 295, AMS, 2026.
- [3] H. Maehara and A. Oshiro, On knotted necklaces of pearls, European J. Combin. 20(5):411–420, 1999.
- [4] H. Maehara and A. Oshiro, On knotted necklaces of pearls and Simon's energies, Yokohama Math. J. 47(2):177–185, 2000.
- [5] H. Maehara, On configurations of solid balls in 3-space: chromatic numbers and knotted cycles, Graphs Combin. 23(Suppl 1):307–320, 2007.
- [7] A. Rechnitzer, Minimal knots on cubic lattices, https://personal.math.ubc.ca/~andrewr/knots.html.
- [8] Y. Diao and C. Ernst, The complexity of lattice knots, Topology Appl. 90(1–3):1–9, 1998.
- [9] G. Buck and J. Simon, Thickness and crossing number of knots, Topology Appl. 91(3):245–257, 1999.

## Extraction notes
- Pages 1–4, 8–9 viewed as images; Table I and Table II checked cell-by-cell against images. Pages 5–7 (references + coordinate lists) read from text layer only.
- Appendix A coordinate lists (pp. 6–8) transcribed in full (2026-11-12) into `wiki/data/Klotz26pearl_appendixA_coordinates.csv` (18 sets: 15 off-lattice + 3 partial-lattice; every set matches its stated vertex count, and every consecutive edge of every closed polygon has length exactly 2.0, a strong check on the transcription). Source text: `pdftotext -raw`.
- ⚠ p. 2 refinement step: "plane passing through p⃗" (lower-case p) and final placement "r⃗_{N_P} = b⃗ + h v̂_2" — b⃗ is never defined (P⃗ intended?). Transcribed as printed.
- ⚠ p. 2–3 says fractions have numerators/denominators "of order 1000", while Table II entries are mostly 4-digit (up to 9991).
- ⚠ p. 3 text: "an 8_1 in which 26 of 33 sites lay on the lattice" — the stated on-lattice index ranges for 8_1 (1–3, 7–21, 26–33) count 3+15+8 = 26 (consistent). 10_124 ranges (1–2, 6–11, 15–23, 28–32) count 2+6+9+5 = 22 (consistent). 6_1 ranges (2–9, 16–23) = 16 (consistent).
- The LLM-claimed ropelength bound ≈ 2.08 C^{3/4} is explicitly unverified by the author.
