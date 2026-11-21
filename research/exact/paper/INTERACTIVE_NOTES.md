# Notes for the interactive version of len52.pdf

The interactive page (`research/exact/site/`) follows the paper section by section. Each static
figure becomes an interactive one, as listed below. Data come from the same sources as the PDF
figures (`paper/figs/make_figs.py`, `site/build_data.py`).

| Paper figure | Interactive version |
|---|---|
| Style | Math without words: a figure carries pane labels (a), (b), ..., symbols and numbers, and no sentences; the words are in the caption. Whole polygons are cel-shaded 3D (pastel toon shading, ink outlines; `studio.js` with `cel: true`). Local pictures and search animatics are flat axonometric SVG (`anim.js`, class `Flat`). Animatics autoplay in a loop when visible, with a wordless play/pause button and scrubber; under reduced motion they show the last frame, paused. |
| (all 3D figures) | One "lattice studio" (`site/studio.js`): lit tubes, labels pinned to 3D points, click to act, drag to turn. The wheel never zooms; it scrolls the page. Without WebGL the flat versions in `app.js` are used. |
| Fig. 1 polygon w36 and its diagram | (a) 3D polygon with its shadow, (b) the diagram along D = (1,-1,4). "Look along D" turns the camera until (a) is (b). Pointing at an arc in either panel finds it in the other. |
| Fig. 2 Delta-move | (a)-(c): the edge [a, b], the triangle abc and another strand; sliders c and [a, b]; the triangle turns red when it meets the strand; "Play" sweeps the edge across the triangle. |
| Theorem 2.4 (web figure 1) | The proof in steps Delta, Q, B, f, cone. In the cone step every segment from e+ or e- to a point of Q is drawn (orange) and follows the slider m -> c, so one sees the motion of segments become an isotopy of B; grey points outside B stay put. |
| Fig. 3 crossing rule, trefoil colouring | (a) the rule 2b = a + c (mod p); (b) a trefoil tube, click a strand to add 1; badges check each crossing; the number of colourings is shown. |
| Paper Lemma "segment and square" | Deleted from the paper (now a one-line fact); no figure. |
| Fig. 4 flip and U-turn as two Delta-moves | 3D step-through (a)-(f), each Delta-move animated across its half-square. |
| Fig. 5 potential psi_Z | eeeuwuwwdd in 3D with height chips; psi_Z floats in the scene; a click on a ring animates the flip; the chain of values (9 -> 8 -> ...) grows below. |
| Fig. 6 curtain lemma | k = 2..5; the walk line shows the letters and the length; the k-1 flips are animated, then the U-turn collapses (the two steps shrink into place) instead of vanishing. |
| Fig. 7 four corner patterns | A real 40-step 5_2 (w36 with two bumps added), cel-shaded, with psi_Z and psi_Y floating above it. Green rings (patterns 1, 2) lower psi_Z, blue rings (patterns 3, 4) lower psi_Y; a click flips the corner and pops "-1" on the value. "Push down" flips until no ring is left (DMON7). |
| Definition 3.10 DMON (web figure 2) | A gallery of seven wordless animatics, one per DMON test: DMON1-3, 6, 7 cel-shaded 3D, DMON4-5 flat. |
| Fig. 8 DMON3 and DMON4 at the origin | Cel-shaded w36 on the pastel lowest plane; orange w0 and blue -w_{n-1}; the ruler e < w < n < s < u < d with the verdict; (a) forwards, (b) backwards. |
| Fig. 9 obligations | Flat animatic: the walk grows, the curtain unrolls, its interior points become one obligation, the dashed rest of the walk discharges it. |
| Fig. 10 reach | Flat animatic: (a) the L1 staircase head -> s -> origin spends tokens against the steps left; (b) the free neighbours of s and the enter/leave arrows. |
| Fig. 11 span | Flat animatic: the three axes, the routes l-first (orange) and h-first (blue) with a1, a2, the minimum boxed, then the sum against the steps left. |
| Lemma 4.4 (web figure 3) | Flat animatic along the real n = 24 search: pending obligations, witnesses tied to the head, and a timeline with the line i + 2. |
| Fig. 12 growth | Log/linear plot with the fits; (b) the growth factor per two steps with the fitted 2.493^2. |
| Corollary 4.5 | The proof ends "Since 24-edge trefoils exist, that is the minimal length", with a "Not convinced?" fold that gives the 24-step trefoil. |
| Fig. 13 standard 5_2 | 3D tube; pointing at X_k shows its PD tuple; sliders a, b browse the 49 colourings with the five crossing checks (coloured = / !=). |
| Fig. 14 certificate example | 3D polygon and its diagram along (7,13,31); rows of F linked to the ringed crossing and its equation. |
| Fig. 15 PD comparison | The diagram of w36 with labels +6; "Switch crossings" turns every row into a KnotInfo crossing; a k / 5 count. |
| Table 2 dependencies | Clickable dependency list: each result links to its section and to its Lean source on GitHub. |
