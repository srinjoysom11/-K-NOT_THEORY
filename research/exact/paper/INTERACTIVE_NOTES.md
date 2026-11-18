# Notes for the interactive version of len52.pdf

The interactive page (`research/exact/site/`) follows the paper section by section. Each static
figure becomes an interactive one, as listed below. Data come from the same sources as the PDF
figures (`paper/figs/make_figs.py`, `site/build_data.py`).

| Paper figure | Interactive version |
|---|---|
| Fig. 1 polygon w36 and its diagram | Orbitable 3D polygon (drag to rotate, scroll to zoom). A "project" control animates the view to D = (1,-1,4) and fades into the diagram; the arcs keep their Fox colours. Hovering an arc highlights it in both views. |
| Fig. 2 Delta-move | Drag the point c; the triangle turns red when another strand pierces it (the move is no longer allowed). Slider slides the edge across the triangle. |
| Fig. 3 crossing rule, trefoil 3-colouring | Click an arc to cycle its colour; each crossing shows a tick or a cross for 2a = b + c (mod p). Switch p between 3 and 7. |
| Fig. 4 segment and square | 3D square with a unit segment snapped to the lattice; drag it, and the intersection (empty / corner / side) is shown live. |
| Fig. 5 flip and U-turn as two Delta-moves | Step-through: before, first Delta-move, second Delta-move, with the shaded triangle at each step. |
| Fig. 6 potential psi_Z | Small polygon with live vertex heights and running psi_Z; click a flippable corner to flip it and see psi_Z drop. |
| Fig. 7 curtain lemma | Step-through of the k-1 flips and the U-turn removal, k adjustable (2-5). |
| Fig. 8 four corner patterns | Four small 3D panels; each animates v_i moving to v' and shows the change in psi_Z or psi_Y. |
| Fig. 9 DMON4 | Toggle the direction of travel; the first and last letters and the DMON4 verdict update. |
| Fig. 10-12 obligations, reach, span | A replay of the actual search on a short word (n = 24): the walk grows step by step, obligations appear as open sites, discharged sites turn solid, and the reach/span budgets are shown as bars against the remaining steps. |
| Table 1, Fig. 13 growth | Plot with log/linear toggle, hover values, the fitted laws, and the per-two-steps growth factor. |
| Fig. 14 standard 5_2 | Hover a crossing X_k to highlight its four edge ends in the PD tuple; click an arc to try colours; the 49 solutions a(1,1,1,1,1)+b(0,1,3,4,2) can be browsed with sliders a, b. |
| Fig. 15 certificate example | The matrices F, L, LF with hover links between matrix rows and crossings in the diagram. |
| Fig. 16 PD comparison | Side-by-side diagrams; a "switch crossings" toggle and a "+6 relabel" toggle show the code becoming the KnotInfo code row by row. |
| Table 2 dependencies | Clickable dependency list: each result links to its section and to its Lean source on GitHub. |
