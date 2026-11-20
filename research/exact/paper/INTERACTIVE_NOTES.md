# Notes for the interactive version of len52.pdf

The interactive page (`research/exact/site/`) follows the paper section by section. Each static
figure becomes an interactive one, as listed below. Data come from the same sources as the PDF
figures (`paper/figs/make_figs.py`, `site/build_data.py`).

| Paper figure | Interactive version |
|---|---|
| (all 3D figures) | One "lattice studio" (`site/studio.js`): lit tubes, a lattice floor that catches the real shadow of the knot (so the shadow is a diagram), labels pinned to 3D points, click to act, drag to turn. The wheel never zooms; it scrolls the page. Without WebGL the flat versions in `app.js` are used. |
| Fig. 1 polygon w36 and its diagram | 3D polygon with its shadow, and (b) the diagram along D = (1,-1,4) (orthographic view, casings at the gaps, crossings ringed). "Look along D" turns the camera until (a) is (b). Pointing at an arc in either panel finds it in the other; click pins it. |
| Fig. 2 Delta-move | 3D: the edge [a, b], the triangle abc and another strand. Move c until the triangle reaches the strand (it turns red: not a Delta-move); "Play the move" sweeps the edge across the triangle. |
| Theorem 2.4 (web only) | The proof step by step in 3D: Q, the bipyramid B with e+ and e-, the four triangles of f with m sliding to c, coning. |
| Fig. 3 crossing rule, trefoil colouring | Inset (a): the rule at one crossing. (b) A trefoil tube; click a strand to add 1 to its colour; a badge on each crossing checks 2 over = in + out (mod p); p = 3 or 7; the number of colourings is counted. |
| Fig. 4 segment and square | 3D lattice, the square Q and a unit segment E moved by lattice steps along any axis; E ∩ Q (empty / corner / side) is drawn and named. |
| Fig. 5 flip and U-turn as two Delta-moves | 3D step-through of both lemmas: each Delta-move is animated across its half-square, with the proof's labels; the outer edges leave the square in other directions. |
| Fig. 6 potential psi_Z | The paper's polygon eeeuwuwwdd in 3D with vertex heights; rings mark allowed flips (green lowers psi_Z); a click animates the flip and logs psi_Z. |
| Fig. 7 curtain lemma | 3D curtain with k = 2..5 and turning sideways steps; the k-1 flips are animated with the proof's labels v_j and v_j - a, then the U-turn is removed. |
| Fig. 8 four corner patterns | The four patterns side by side in 3D with their squares; "Flip all four" animates v_i to v'; the other four patterns can be shown for comparison. |
| Fig. 9 DMON4 | w36 in 3D with the plane through v0; a bead travels in the chosen direction; first and last letters and the DMON4 verdict. |
| Fig. 10 obligations | The real search (n = 24) at each step that closes a curtain or makes a DMON7 corner: the curtain is shaded with its steps a and -a, its interior points become one obligation (rings), the rest of the walk is dashed. |
| Fig. 11 reach | The real search state in 3D; click a site ring: its lattice route head -> s -> origin, the count against the steps left, and its free neighbours. |
| Lemma 4.4 (web only) | Arrow-key stepper along the real search: pending obligations as rings, each witness v_m labelled, and a timeline (bars from creation to removal, witness dots right of the line i + 2). |
| Fig. 12 span | The real search state in 3D with the single sites and the box [l, h] on all three axes; a table gives c, l, h, a1, a2 and min per axis and compares the sum with the steps left (the numbers equal the search's own). |
| Table 1, Fig. 13 growth | Log/linear plot; the fits are drawn on their fit range (shaded) and the node fit continues dashed to short lengths, with the reason the short lengths are left out. |
| Fig. 14 standard 5_2 | 3D tube whose shadow is the KnotInfo diagram; edge and crossing labels; pointing at X_k shows its PD tuple; sliders a, b browse the 49 colourings with the five crossing checks. |
| Theorem 5.1 (web only) | The heptagon: choose over-colour b, in-colour a and a corner t; step through r_b, r_a, r_b and compare with the single reflection r_{2b-a}; ends with the Fox rule. |
| Fig. 15 certificate example | 3D polygon and its diagram along (7,13,31); rows of F linked to the ringed crossing; L and LF. |
| Fig. 16 PD comparison | The diagram of w36 drawn with the same renderer as Fig. 1, labels +6 as in the caption, an arrow for the direction of travel; "switch all crossings" turns every row into a KnotInfo crossing. |
| Table 2 dependencies | Clickable dependency list: each result links to its section and to its Lean source on GitHub. |
