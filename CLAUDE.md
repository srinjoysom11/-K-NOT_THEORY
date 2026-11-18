# CLAUDE.md

## Writing proofs, papers and expositions in this repository

These rules come from a line-by-line review of the paper `research/exact/paper/len52.tex` by the
author. Follow them from the first draft so that the reader never has to ask for them.

**Proofs, not outlines.**
- Write the proof, never "proof idea", "sketch", "the heart of the proof" or "the other cases are
  similar". If a case is analogous, say which substitution makes it so and still state its result.
- Never write "direct consequence", "clearly" or "it is easy to see" in place of an argument.
  Write the argument, even if it is two lines.
- A textbook theorem may be quoted instead of proved, but quote it precisely (book, chapter) and say
  exactly where it is used. Never call a quoted theorem "proved in the text".

**Define before use, and motivate.**
- Every term gets a precise definition before its first use, with one sentence of intuition (what it
  looks like, why it is there). Examples: a Delta-move needs its definition, a picture, and the
  reason it cannot change the knot.
- Every condition in a list gets its own name and its own meaning. Do not merge two conditions into
  one line ("C1-C2: w is a polygon word").
- Before introducing a mechanism (an obligation, a test, a potential), say what problem it solves.
- Explain every symbol in a formula: what each term means, what the minimum is taken over, why the
  sum measures what it claims to measure.
- Notation should name what it measures (`psi_Z`, `psi_Y`, not `psi`, `psi_2`).

**Be explicit; never leave the reader to fill a gap.**
- No "the three other cases", "the fourth corner of its square", "more legibly": list the cases,
  draw the square, and say concretely why one choice is better than another.
- If a statement can be proved by a short computation, give the computation (e.g. solve the linear
  system step by step, show the relabelling crossing by crossing).
- When a group or structure is used (D_7, a presentation), write its generators and relations and
  define every map on it explicitly.

**Figures.**
- A geometric argument needs a picture: one panel per step (before / after, each Delta-move, each
  flip), with every point that the text names labelled in the picture.
- Figures must not be crowded: no point where many strands or colours meet, no label on a line, no
  arrow drawn over a box. Choose views (projection directions) that separate the features, and say
  in the text why that view was chosen.
- A figure appears after the text that first refers to it (use `flafter`).
- A diagram that supports a claim (e.g. "this PD code is the standard 5_2") must let the reader
  check the claim from the picture alone: label edges and crossings exactly as in the code.
- Captions explain what to look at. A plot that looks like a straight line on a log scale must say
  whether it really is one, give the fitted law, and cite the theory behind the expected growth.
- Drop any figure that does not add understanding (e.g. a box-and-arrow chart); replace it by a
  table of results, their Lean names and their dependencies.

**Tone and credibility.**
- Plain, simplified technical English. Short sentences. No marketing.
- Do not undercut the paper by mentioning superseded or unverified side computations; state what is
  needed and how it is proved.
- Format for arXiv (plain `article`), with no ACM classification or magazine styling.
- Acknowledgements: thank Professor K. V. Srikanth. Credit Claude (Anthropic) for the diagrams,
  not for the text.

**Naming in the 5_2 paper.** The normal-form conditions are the DMON tests (Dynamic Midwalk
Obligation Neutralizer), DMON1-DMON7; the completeness theorem of the search is the PanDMONium
theorem. Each search test is tagged with the DMON tests it implements.

## Interactive version

`research/exact/site/` holds the interactive web version of the paper (it supersedes the old Plates
slideshow). It follows the paper section by section; static figures become interactive 3D or
step-through views. `research/exact/paper/INTERACTIVE_NOTES.md` lists, figure by figure, what the
interactive version shows. Keep the paper and the page in sync when either changes.
