# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

Static HTML/CSS/JS with no build step, committed to research/exact/site and published by
.github/workflows/pages.yml. One vendored library is allowed: three.js (MIT, in `vendor/`) for the
interactive 3D figures. Everything else is plain DOM, SVG and canvas. Math is typeset with plain
HTML/Unicode (no TeX runtime).

## Users

Layered readership. First: curious, motivated readers who learn visually (students, science readers)
and want to understand what was proved and why the proof is trustworthy, starting from pictures and
plain words. Second, one level deeper in every section: mathematicians, knot theorists and
formal-methods people who want the precise statements, the full proofs, the DMON tests and the Lean
theorem names.

## Product Purpose

The interactive edition of the paper "The knot 5_2 needs 36 steps on the cubic lattice"
(research/exact/paper/len52.pdf). It follows the paper section by section, with the same
definitions, statements and proofs, and replaces each static figure by an interactive one
(research/exact/paper/INTERACTIVE_NOTES.md). Success: a reader can explain, after reading, (1) what a
lattice knot and its minimal length are, (2) what a Delta-move is and why square moves keep the knot,
(3) how pushing the polygon down gives the DMON tests, (4) how obligations make the search fast and why
the PanDMONium theorem means no 5_2 hides in a pruned branch, (5) how Fox 7-colourings and matrix
certificates rule out every candidate, and (6) what Lean checks and what remains trusted.

## Positioning

The only explanation of this result, written to the standard of the paper: proofs, not outlines;
plain technical English; every figure checkable.

## Content and evidence (must stay true)

- Theorem: Len(5_2) = 36. Upper bound: w36 = eeennuwwwwssseennwuueedddnnuuswsswdd. Its projection
  along D = (1,-1,4) (drawn) and along (1,-19,40) (certificate list) has five crossings and the PD
  code [10,3,1,4],[6,1,7,2],[2,7,3,8],[4,9,5,10],[8,5,9,6]; switching all crossings and adding 6 to
  every label gives the KnotInfo code of 5_2. Fox colouring (0,1,3,4,2).
- Previously known: Len(3_1) = 24 (Diao 1993); Len(4_1) = 30, Len(5_1) = 34 (Scharein et al. 2009).
  The search gives a new computational proof that every non-trivial lattice knot needs >= 24 steps.
- Stage 1: square moves (corner flip, U-turn removal) as two Delta-moves; potentials psi_Z, psi_Y;
  curtain lemma (DMON6); corner lemma (DMON7); normal form (DMON1-DMON7, the Dynamic Midwalk
  Obligation Neutralizer tests). Stage 2: search with obligations; tests tagged with DMONs; the
  PanDMONium theorem (completeness). Stage 3: Fox 7-colourings; 5_2 has 49; certificates L F = E.
- Numbers: 33000 words; 2.27e12 nodes; 1358 parts; table of runs from figs/growth_table.tex (via
  data.js). Do not invent numbers.
- Lean 4.25, no Mathlib: exists_survivor, search_complete, colorCheck_sound, no_short, w52_pd,
  fig_pd_eq, fig_relabel, wTre_pd; axioms propext, Classical.choice, Quot.sound only.
- Trusted: definitions; E1 (proved), E2 Wirtinger (quoted), E3 (naming only); compiled evaluation;
  GitHub job logs.
- Acknowledgements: Professor K. V. Srikanth; diagrams prepared with the help of Claude.

## Accessibility

Works without WebGL (static SVG/PNG fallbacks for every 3D figure; `?nogl` forces it), keyboard
navigable, readable at phone width, respects prefers-reduced-motion, sufficient contrast.
