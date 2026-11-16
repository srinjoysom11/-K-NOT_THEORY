# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

Static HTML/CSS/JS, no build step, committed to research/exact/site (suitable for GitHub Pages). Libraries only from a CDN with pinned versions if needed.

## Users

Layered readership. First: curious, motivated readers who learn visually (students, science readers) and want to understand what was proved and why the proof is trustworthy, starting from pictures and plain words. Second, one level deeper on every chapter: mathematicians, knot theorists and formal-methods people who want the precise statements, the conditions C1–C7, and the Lean theorem names.

## Product Purpose

A visual explainer of the proof that the knot 5_2 needs exactly 36 unit steps on the cubic lattice (Len(5_2) = 36), and of how that proof was achieved. Success: a reader can explain, after reading, (1) what a lattice knot and its minimal length are, (2) why one cannot simply enumerate all short polygons, (3) how square moves and the normal form shrink the search, (4) why no 5_2 can hide in a pruned branch, (5) how Fox 7-colourings rule out every candidate, and (6) what the Lean formalisation checks and what remains trusted.

## Positioning

The only explanation of this result. Its distinctive mechanism: a pruned exhaustive search whose every pruning rule is a kernel-checked theorem, and a 49-versus-7 colouring certificate that a reader can verify by hand.

## Content and evidence (must stay true)

- Theorem: Len(5_2) = 36. Upper bound: the polygon eeennuwwwwssseennwuueedddnnuuswsswdd (36 steps), whose projection along (5,-5,11) or (1,-19,40) is the standard 5-crossing 5_2 diagram; Fox colouring (0,1,3,4,2).
- Previously known exact values: Len(3_1) = 24 (Diao 1993); Len(4_1) = 30 and Len(5_1) = 34 reported by Scharein et al. 2009.
- Stage 1 normal form (conditions C1–C7, square moves: corner flip, U-turn removal, curtain lemma, pushed-down normal form, canonical position). Stage 2 search (obligations; tests: self-avoidance, no U-turns, axis counts, reach, span, closing). Stage 3 Fox 7-colourings: every 5_2 diagram has 49, every returned word only 7, with a checked matrix certificate.
- Lean 4 (no Mathlib, ~4500 lines): exists_survivor, search_complete, colorCheck_sound, w52_pd, no_short; axioms propext, Classical.choice, Quot.sound only.
- Computation: 1358 parts (checkpart), local container + GitHub Actions; C++ cross-check node for node; numbers from research/exact/out/lean (COMPCERT.txt, parts logs). Do not invent numbers.
- Making-of facts: adversarial review in two rounds; the corner-index bug caught by node counts; the plane-crossing and arc lemmas were dropped to remove trust; provenance hashes.

## Accessibility

Must work without WebGL (static fallback image), keyboard navigable, readable at phone width, respects prefers-reduced-motion, sufficient contrast in light and dark.
