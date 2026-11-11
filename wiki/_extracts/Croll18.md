# Croll18 — The BiEntropy of Some Knots on the Simple Cubic Lattice
- **Authors:** Grenville J. Croll
- **Venue / year / identifiers:** arXiv:1802.03772 (file version "v3.11", © 2018 Grenville J. Croll; no journal reference printed)
- **File:** papers/1_core_lattice_length/Croll_2018_BiEntropy_knots_simple_cubic_lattice_1802.03772.pdf   **Pages:** 11
- **Text layer:** ok (tables/figure axes flattened; Table 1B read from image and text)

## Abstract
Binary representations of the trefoil and other knots of up to ten crossings in the simple cubic lattice were created. The BiEntropy of each knot was computed using a variety of binary encodings and compared against controls. This showed that binary encoded knots are highly disordered information objects. The BiEntropy of knots on the simple cubic lattice increases slightly as the number of crossings and length of encoding increases. We show that the non-alternating knots of nine and ten crossings are more disordered than the alternating knots of nine and ten crossings.

## Notation and conventions
- (p. 1) Shannon entropy of binary string s with P(s_i=1)=p: H(p) = −p log₂p − (1−p) log₂(1−p).
- (p. 2) Binary derivative: d_1(s) = XOR of adjacent digits. Linear strings: length n−1. **Knot (cyclic) version**: first binary knot derivative has length n, XORing adjacent pairs "including the last and the first"; d_k = derivative of d_{k−1}; "infinitely many in the knot version of which we use the first n−1". p(k) = fraction of 1s in d_k; p(0) fraction of 1s in s. s periodic iff d_{n−1}(s)=0; aperiodic if d_{n−1} = all 1s.
- (p. 2) Weighting methods: BiEn (weights 2^k, "good"), TBiEn ("Tres Bien", log weights), LBiEn (linear), PBiEn (zero).
- (p. 3) BiEn(s) = (1/(2^{n−1}−1)) Σ_{k=0}^{n−2} H(p(k)) 2^k; TBiEn(s) = (Σ_{k=0}^{n−2} H(p(k)) log₂(k+2)) / (Σ_{k=0}^{n−2} log₂(k+2)). d_{n−1} not used. BiEn suitable for n ≲ 32. **KTBiEn** = logarithmic knot BiEntropy (TBiEn with the cyclic derivative); used exclusively (min knot length 24 × 3 = 72 bits).
- (p. 4) NEWSUD string = sequence of letters from {N,E,W,S,U,D} (North, East, West, South, Up, Down edge directions in the cubic lattice). Canonical-form labels (e.g. 2-50) are those of Scharein et al. 2009 (75 canonical minimal trefoils); trefoil "2-50" = DDDEEUUSWWWNNEEDSSSUUNNW.
- (p. 5) 8-bit encodings: each of N,E,W,S,U,D assigned a random distinct 8-bit number; ENCODING_A and ENCODING_B each = 256 random such assignments. A 24-step trefoil → 24·8 = 192 bits; a knot of up to 64 steps → 512 bits (p. 6).
- Data sets (p. 6): TREF_N = 75 canonical trefoils (Scharein Table 6); SOME_N = one (suspected or, in 3 cases, proven minimal) NEWSUD word per knot 3_1…10_165, 249 knots (Scharein Table 7), excluding unknot, granny, square knots; TREF_A/TREF_B and SOME_A/SOME_B = random NEWSUD controls of same letter distribution (length 24 for TREF; 24–64 for SOME), not self-avoiding. ⚠ "Table 6/7 of Scharein et al." numbering as cited here differs from the numbering in the Scharein09 extract (Tables A1–A3); keep as printed.

## Numbered statements
No theorems or numbered claims. Experimental findings are listed under quantitative claims below.

## Key equations and quantitative claims outside numbered statements
- p. 4: (quoted) Diao [1993]: minimal number of steps for any knot on the simple cubic lattice is 24, only the trefoil attains it; minimal lengths for 4_1 and 5_1 of 30 and 34 "recently proven as outlined in Scharein et al." Other minimal lengths are heuristic.
- p. 4: Scharein et al. show 75 canonical minimum trefoil forms "in three distinct groups".
- p. 5: 8!/(8−6)! = 20,160 ways of allocating 3-bit codes to the 6 letters; 256!/250! = 2.65E14 ways of choosing an 8-bit NEWSUD encoding; "after some experimentation with 3 and 4 bit encodings we settled on an 8 bit encoding".
- p. 6: Scharein Table 7 knot 3_1 entry was only 23 characters long (initial "D" omitted, typographical error) — corrected by the author.
- p. 6: computations in C: ten minutes (trefoils) and one hour (knots to 10 crossings) on a 4 GHz single-core Pentium; every trefoil/knot examined under each of the 256 encodings of ENCODING_A and ENCODING_B.
- p. 6: the Knot version of BiEntropy gives identical values for all 8 rotations of an 8-bit string, so no random start point is needed for NEWSUD strings.
- p. 7 (numerical): BiEntropies computed with ENCODING_A and ENCODING_B are almost identical (Adj R² = 0.998, N = 75 for trefoils, Fig. 3; Adj R² = 0.998, N = 249 for knots, Fig. 4); same for random controls.
- p. 7: BiEntropy of all knots high (> 0.979): "relatively disordered binary objects". Lowest BiEntropy among trefoils: canonical form 2-50 (three-fold symmetry). Controls' BiEntropies are higher than all knots' by ≈0.3% (p < 0.001).
- p. 8–9: mean BiEntropy increases slightly with crossing number (Fig. 6, mean ≈ 0.988 to ≈ 0.994 from the axis range) and with NEWSUD encoding length (Fig. 7, 24–64 characters); sample-size uncertainty for complex knots.
- p. 9: non-alternating vs alternating knots: 9 crossings p < 0.01, 10 crossings p < 0.001; non-alternating knots have higher BiEntropy ("more disordered", abstract). Alternating/non-alternating distinguished by Dowker encoding signs (all positive for alternating).
- p. 10: summary: 2-50 trefoil has the lowest BiEntropy of all knots examined.

## Methods / algorithms
1. Take NEWSUD words from Scharein et al. (75 trefoils; 249 single-instance knots) (pp. 4–6).
2. Assign random 8-bit codes to the six letters (256 encodings per set; two sets A, B); concatenate to a binary string (192–512 bits).
3. Compute binary knot derivatives d_1…d_{n−2}, p(k) and KTBiEn (Table 1A worked example).
4. Repeat on random controls with matched letter distributions; compare means (t-test p-values as quoted); compare encodings A vs B by regression (Figs 3–4).
5. Summarise by crossing number, encoding length, alternating vs non-alternating (Figs 5–9).

## Tables
**Table 1A (p. 3)** — "Computing the Logarithmic Knot BiEntropy (KTBiEn) of an 8-bit string." Worked example for s = 10101110 (verified against the image):

| k | derivative d_k | # of 1's | Len(n) | p | −p·log₂p | −(1−p)·log₂(1−p) | BiEn (=H) | log₂(k+2) | BiEn·log₂(k+2) |
|---|---|---|---|---|---|---|---|---|---|
| 0 | 10101110 | 5 | 8 | 0.63 | 0.42 (as printed: 0.38 under "(1−p)", 0.42, 0.53) | 0.53 | 0.95 | 1.0 | 0.95 |
| 1 | 11110011 | 6 | 8 | 0.75 | 0.31 (printed (1−p)=0.25) | 0.50 | 0.81 | 1.6 | 1.29 |
| 2 | 00010100 | 2 | 8 | 0.25 | 0.50 ((1−p)=0.75) | 0.31 | 0.81 | 2.0 | 1.62 |
| 3 | 00111100 | 4 | 8 | 0.50 | 0.50 | 0.50 | 1.00 | 2.3 | 2.32 |
| 4 | 01000100 | 2 | 8 | 0.25 | 0.50 ((1−p)=0.75) | 0.31 | 0.81 | 2.6 | 2.10 |
| 5 | 11001100 | 4 | 8 | 0.50 | 0.50 | 0.50 | 1.00 | 2.8 | 2.81 |
| 6 | 01010101 | 4 | 8 | 0.50 | 0.50 | 0.50 | 1.00 | 3.0 | 3.00 |

(The printed table also lists d_7 = 11111111, unused. Printed column "(1−p)" values are 0.38, 0.25, 0.75, 0.50, 0.75, 0.50, 0.50; columns −p·log p: 0.42, 0.31, 0.50, 0.50, 0.50, 0.50, 0.50; −(1−p)log(1−p): 0.53, 0.50, 0.31, 0.50, 0.31, 0.50, 0.50. ⚠ my merged columns above are a re-flowing of the flat text; the printed columns are as listed in this note.) Totals printed: Σ BiEn = 6.39; Σk = 21; Σ log₂(k+2) = 15.2992; Σ BiEn·log₂(k+2) = 14.08924; **Knot TBiEn(s) = 0.920913**. (Check: 14.08924/15.2992 = 0.9209 ✓.)

**Table 1B (p. 3)** — "Logarithmic Knot BiEntropy (KTBiEn) of the 4 and 8-bit strings." A 16×16 matrix: an 8-bit string is the concatenation of a row nibble (first 4 bits, label N and its bits) and a column nibble. Column/row order of nibbles N: 0, 15, 5, 10, 3, 6, 9, 12, 1, 2, 4, 7, 8, 11, 13, 14. KTBiEn of the 4-bit string itself (KTBiEn4): N=0:0, 15:0, 5:0.22, 10:0.22, 3,6,9,12: 0.56, N=1,2,4,7,8,11,13,14: 0.96. Matrix entries (row nibble → 16 column nibbles in the same order) as read from the page image / text layer:

| row N (KTBiEn4) | 0 | 15 | 5 | 10 | 3 | 6 | 9 | 12 | 1 | 2 | 4 | 7 | 8 | 11 | 13 | 14 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0 (0) | 0.00 | 0.43 | 0.58 | 0.58 | 0.74 | 0.74 | 0.76 | 0.74 | 0.89 | 0.89 | 0.89 | 0.95 | 0.89 | 0.97 | 0.97 | 0.95 |
| 15 (0) | 0.43 | 0.00 | 0.58 | 0.58 | 0.74 | 0.76 | 0.74 | 0.74 | 0.95 | 0.97 | 0.97 | 0.89 | 0.95 | 0.89 | 0.89 | 0.89 |
| 5 (0.22) | 0.58 | 0.58 | 0.07 | 0.43 | 0.76 | 0.76 | 0.76 | 0.78 | 0.92 | 0.95 | 0.92 | 0.92 | 0.97 | 0.95 | 0.92 | 0.97 |
| 10 (0.22) | 0.58 | 0.58 | 0.43 | 0.07 | 0.78 | 0.76 | 0.76 | 0.76 | 0.97 | 0.92 | 0.95 | 0.97 | 0.92 | 0.92 | 0.95 | 0.92 |
| 3 (0.56) | 0.74 | 0.74 | 0.76 | 0.78 | 0.17 | 0.60 | 0.60 | 0.43 | 0.94 | 0.94 | 0.97 | 0.94 | 0.95 | 0.94 | 0.97 | 0.95 |
| 6 (0.56) | 0.74 | 0.76 | 0.76 | 0.76 | 0.60 | 0.17 | 0.43 | 0.60 | 0.97 | 0.94 | 0.94 | 0.94 | 0.97 | 0.95 | 0.95 | 0.94 |
| 9 (0.56) | 0.76 | 0.74 | 0.76 | 0.76 | 0.60 | 0.43 | 0.17 | 0.60 | 0.94 | 0.95 | 0.95 | 0.97 | 0.94 | 0.94 | 0.94 | 0.97 |
| 12 (0.56) | 0.74 | 0.74 | 0.78 | 0.76 | 0.43 | 0.60 | 0.60 | 0.17 | 0.95 | 0.97 | 0.94 | 0.95 | 0.94 | 0.97 | 0.94 | 0.94 |
| 1 (0.96) | 0.89 | 0.95 | 0.92 | 0.97 | 0.94 | 0.97 | 0.94 | 0.95 | 0.29 | 0.76 | 0.58 | 0.78 | 0.74 | 0.60 | 0.78 | 0.43 |
| 2 (0.96) | 0.89 | 0.97 | 0.95 | 0.92 | 0.94 | 0.94 | 0.95 | 0.97 | 0.76 | 0.29 | 0.76 | 0.60 | 0.58 | 0.76 | 0.43 | 0.78 |
| 4 (0.96) | 0.89 | 0.97 | 0.92 | 0.95 | 0.97 | 0.94 | 0.95 | 0.94 | 0.58 | 0.76 | 0.29 | 0.78 | 0.76 | 0.43 | 0.76 | 0.60 |
| 7 (0.96) | 0.95 | 0.89 | 0.92 | 0.97 | 0.94 | 0.94 | 0.97 | 0.95 | 0.78 | 0.60 | 0.78 | 0.29 | 0.43 | 0.76 | 0.58 | 0.74 |
| 8 (0.96) | 0.89 | 0.95 | 0.97 | 0.92 | 0.95 | 0.97 | 0.94 | 0.94 | 0.74 | 0.58 | 0.76 | 0.43 | 0.29 | 0.78 | 0.60 | 0.78 |
| 11 (0.96) | 0.97 | 0.89 | 0.95 | 0.92 | 0.94 | 0.95 | 0.94 | 0.97 | 0.60 | 0.76 | 0.43 | 0.76 | 0.78 | 0.29 | 0.76 | 0.58 |
| 13 (0.96) | 0.97 | 0.89 | 0.92 | 0.95 | 0.97 | 0.95 | 0.94 | 0.94 | 0.78 | 0.43 | 0.76 | 0.58 | 0.60 | 0.76 | 0.29 | 0.76 |
| 14 (0.96) | 0.95 | 0.89 | 0.97 | 0.92 | 0.95 | 0.94 | 0.97 | 0.94 | 0.43 | 0.78 | 0.60 | 0.74 | 0.78 | 0.58 | 0.76 | 0.29 |

(Matrix is symmetric about the diagonal as the caption text says; ⚠ rows 15 and 3 etc. are symmetric images of the first row/column as printed; the first-row entries "0.74 0.74 0.76 0.74" for columns 3,6,9,12 and the 4th row "0.76 0.76 0.78" etc. were compared with the image at 120 dpi, small colour-coded cells, no discrepancies noticed. Also note the printed Table 1B header row of KTBiEn4 values is "0 0 0.22 0.22 0.56 0.56 0.56 0.56 0.96 …", confirming the nibble values above.)

**Table 2 (p. 5)** — "First four encodings (out of 256) of the NEWSUD characters of ENCODING_A" (decimal 8-bit codes):

| N | E | W | S | U | D |
|---|---|---|---|---|---|
| 44 | 82 | 201 | 21 | 245 | 214 |
| 32 | 231 | 121 | 87 | 252 | 179 |
| 6 | 28 | 80 | 33 | 137 | 77 |
| 111 | 52 | 163 | 120 | 238 | 147 |

**Table 3 (p. 5)** — "First four encodings (out of 256) of the NEWSUD characters of ENCODING_B":

| N | E | W | S | U | D |
|---|---|---|---|---|---|
| 84 | 41 | 102 | 101 | 67 | 222 |
| 43 | 107 | 20 | 118 | 66 | 113 |
| 227 | 111 | 65 | 189 | 142 | 99 |
| 145 | 108 | 159 | 3 | 248 | 240 |

(Text: "the 44 of the N in the first row of ENCODING_A translates to 00101100 and the 3 of the S in the fourth row of ENCODING_B translates to 00000011"; unknot DEUW with first row of ENCODING_B = {222; 41; 67; 102} = 11011110001010010100001101100110.) ⚠ Tables 2/3 values read from a garbled text layer (row grouping inferred from the example sentences: first row of A starts with N=44; first row of B has D=222, E=41, U=67, W=102 consistent with the example). The W, S, U, D columns of rows 2–4 in both tables are the least certain.

## Figures
- **Fig. 1 (p. 4)** — "The Trefoil knot of canonical form 2-50 in the simple cubic lattice. The axis of symmetry is central and near vertical" — photograph of a 3D-printed 24-step trefoil (photographs credited to Pascal Fleck's 3D printing).
- **Fig. 2 (p. 4)** — "Alternative View of Trefoil knot of canonical form 2-50. The axis of symmetry runs from bottom left to top right."
- **Fig. 3 (p. 7)** — "BiEntropy of Trefoil Knots (TREF_N) in the Simple Cubic Lattice" — scatter ENCODING_A (x) vs ENCODING_B (y), values 0.978–0.994, Adj R² = 0.998, N = 75. Image: ../figures/Croll18/p07.png
- **Fig. 4 (p. 7)** — "BiEntropy of Knots up to 10 Crossings (SOME_N) in the Simple Cubic Lattice" — same for 249 knots, axis 0.985–0.995, Adj R² = 0.998.
- **Fig. 5 (p. 8)** — "BiEntropy of the Trefoil Knots" — mean KTBiEn per canonical form (labels 2-50, 2-47, 2-7, 2-39, 2-48, 2-32, 2-24, 2-43, 2-55, 1-9 on x-axis), y 0.97–0.995; 2-50 lowest. Image: ../figures/Croll18/p08.png
- **Fig. 6 (p. 8)** — "Mean BiEntropy of some knots up to 10 crossings" — mean KTBiEn vs crossings 3…10, y ≈ 0.988–0.994, rising.
- **Fig. 7 (p. 8)** — "Mean BiEntropy of some knots up to 10 crossings by NEWSUD encoding length" — x 24–64, y 0.99–0.995, rising.
- **Fig. 8 (p. 9)** — "The BiEntropy of Non-Alternating and Alternating knots of 9 crossings" — knot rank vs mean KTBiEn, two series. Image: ../figures/Croll18/p09.png
- **Fig. 9 (p. 9)** — same for 10 crossings.
- Table 1 page: ../figures/Croll18/p03.png

## Stated limitations, open problems, future work
- p. 4: "determination of the minimum number of steps for knots on the cubic lattice is by heuristic methods and is therefore incomplete and somewhat uncertain" (except 3_1, 4_1, 5_1).
- p. 8: "sample size based uncertainty for the more complex knots"; larger samples might sequence knots by BiEntropy exactly, at significant computational cost.
- p. 10: "constrained by our use of the limited output from a single prior experiment"; points to wider studies of entropy of binary encoded knots.

## References worth following
- Scharein, Ishihara, Arsuaga, Diao, Shimokawa, Vazquez 2009, Bounds for the minimum step number of knots in the simple cubic lattice, J. Phys. A 42, 475006 (data source).
- Diao 1993, Minimal knotted polygons on the cubic lattice, JKTR 2, 413–425.
- Croll 2013, BiEntropy – the approximate entropy of a finite binary string, arXiv:1305.0954.
- Janse van Rensburg & Rechnitzer 2011, Minimal knotted polygons in cubic lattices, J. Stat. Mech. P09008.

## Extraction notes
- Table 1A and 1B checked against the 120-dpi image of p. 3; Tables 2–3 from text layer (group boundaries inferred; ⚠ see above). The column flow of Table 1A's printed numeric columns was reconstructed from text; totals verified arithmetically.
- No theorems; no data tables of results (results only in figures; numbers read off axes are approximate).
- Figure pages rendered: 3, 4, 7, 8, 9.
