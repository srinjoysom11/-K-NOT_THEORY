---
name: The knot 5₂ needs 36 steps
description: An engraved atlas. One specimen, drawn as a copperplate engraving, followed down a folio of plates.
colors:
  paper: "#e6e9e0"
  paper-lit: "#eff1ea"
  paper-deep: "#d8dcd2"
  indigo-ink: "#17204a"
  indigo-soft: "#434c76"
  ink-rule: "rgba(23, 32, 74, .34)"
  ink-hair: "rgba(23, 32, 74, .16)"
  vermilion: "#c2321f"
  vermilion-deep: "#9c2313"
  on-vermilion: "#f4f2ea"
  viridian: "#2d7d5b"
  gamboge: "#a97a08"
  violet: "#6b3fa0"
  sepia: "#8c5a36"
  cerulean: "#23799f"
  olive: "#5d6b2e"
  machine-ground: "#141b40"
  machine-ground-lit: "#1a2350"
  machine-line: "#e6e9e0"
  machine-line-soft: "#b3bad3"
  machine-vermilion: "#f0705b"
  machine-vermilion-soft: "#f58f7d"
  machine-viridian: "#6fc79d"
typography:
  display:
    fontFamily: "Old Standard TT, Spectral, Georgia, serif"
    fontSize: "clamp(2.9rem, 7.1vw, 6rem)"
    fontWeight: 400
    lineHeight: 0.98
    letterSpacing: "-0.012em"
  headline:
    fontFamily: "Old Standard TT, Spectral, Georgia, serif"
    fontSize: "clamp(2.15rem, 4.3vw, 3.7rem)"
    fontWeight: 400
    lineHeight: 1.04
    letterSpacing: "-0.01em"
  theorem:
    fontFamily: "Old Standard TT, Spectral, Georgia, serif"
    fontSize: "clamp(1.7rem, 3.3vw, 2.9rem)"
    fontWeight: 400
    lineHeight: 1.15
  subhead:
    fontFamily: "Old Standard TT, Spectral, Georgia, serif"
    fontSize: "1.5rem"
    fontWeight: 400
    lineHeight: 1.2
  lede:
    fontFamily: "Spectral, STIX Two Text, Georgia, serif"
    fontSize: "clamp(1.18rem, 1.5vw, 1.34rem)"
    fontWeight: 400
    lineHeight: 1.5
  body:
    fontFamily: "Spectral, STIX Two Text, Georgia, serif"
    fontSize: "1.125rem"
    fontWeight: 400
    lineHeight: 1.6
  small:
    fontFamily: "Spectral, STIX Two Text, Georgia, serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.5
  note:
    fontFamily: "Spectral, STIX Two Text, Georgia, serif"
    fontSize: "0.95rem"
    fontWeight: 400
    lineHeight: 1.55
  furniture:
    fontFamily: "Spectral SC, Spectral, Georgia, serif"
    fontSize: "0.8rem"
    fontWeight: 400
    letterSpacing: "0.16em"
  plate-number:
    fontFamily: "Spectral SC, Spectral, Georgia, serif"
    fontSize: "0.8rem"
    fontWeight: 400
    letterSpacing: "0.24em"
  math:
    fontFamily: "STIX Two Text, Spectral, Times New Roman, serif"
    fontSize: "0.9rem"
    fontWeight: 400
  code:
    fontFamily: "ui-monospace, SF Mono, Menlo, Consolas, monospace"
    fontSize: "0.86em"
    fontWeight: 400
rounded:
  square: "0px"
spacing:
  bar: "3.25rem"
  gutter: "clamp(1.25rem, 4.2vw, 4rem)"
  plate-block: "clamp(4.5rem, 12vh, 9rem)"
  column-gap: "clamp(2rem, 5.5vw, 6rem)"
  plate-offset: "5px"
  plate-mark: "20px"
  measure: "34rem"
components:
  begin:
    backgroundColor: "{colors.vermilion}"
    textColor: "{colors.on-vermilion}"
    typography: "{typography.furniture}"
    rounded: "{rounded.square}"
    padding: "0.78rem 1.6rem 0.74rem"
  begin-hover:
    backgroundColor: "{colors.vermilion-deep}"
  chip:
    textColor: "{colors.indigo-ink}"
    typography: "{typography.furniture}"
    rounded: "{rounded.square}"
    padding: "0.45rem 0.9rem 0.42rem"
  chip-hover:
    backgroundColor: "{colors.indigo-ink}"
    textColor: "{colors.paper-lit}"
  chip-pressed:
    backgroundColor: "{colors.vermilion}"
    textColor: "{colors.on-vermilion}"
  readout:
    textColor: "{colors.indigo-soft}"
    typography: "{typography.small}"
  plate-frame:
    backgroundColor: "{colors.paper-lit}"
    textColor: "{colors.indigo-ink}"
    rounded: "{rounded.square}"
  index-link:
    textColor: "{colors.indigo-soft}"
    typography: "{typography.furniture}"
  index-link-current:
    textColor: "{colors.vermilion-deep}"
  machine-band:
    backgroundColor: "{colors.machine-ground}"
    textColor: "{colors.machine-line}"
---

# Design System: The knot 5₂ needs 36 steps

## Overview

**Creative North Star: "One theorem, every branch within reach."**

The site is an atlas of one theorem, in the manner of the engraved knot tables of the 1870s and 1880s: cool laid paper, indigo ink, small-cap furniture, roman plate numbers. It is a tree of pages, not a sequence of slides. The title page carries the engraved specimen (the 36-step polygon as a real 3D model drawn as a copperplate engraving), the five ways into the proof in full (the paper, the Lean proof, the computation record, the code, the lab), a bracket chart of the whole atlas read from the theorem outwards, and the abstract.

The tree: Background (sticks, known values, scale) · Methodology (upper bound; Stage 1 normal form with moves, curtain, lowest polygon, rules; Stage 2 search; Stage 3 colourings; Lean) · Knot-move lab · Enumerations · Tables · Code · Paper & references · Making of. Every page sits in the tree; branch pages explain their stage and list their children; leaf pages pair one argument with one live exhibit and end in "Go deeper" links to the Lean file, the data, the paper section or the lab.

**Key characteristics**
- Hash routes (`#/proof/normal-form/curtain`), one view visible at a time; the old chapter hashes (`#curtain`) still resolve.
- The paper, the Lean proof and the repository are in the running head on every page; the paper is the one filled control.
- An outline of the tree beside every page (opens as a drawer below 1100px), breadcrumbs above, previous and next below.
- The knot-move lab (`lab.js`, three.js): the reader flips corners, cuts U-turns and pushes edges out on a 3D lattice knot; the shadow is drawn as the knot's diagram and its Fox colouring count never changes. Four scripted demonstrations, and a puzzle mode with undo, hint and auto-untangle.
- The engraved specimen (`stage.js`, raw WebGL2): hatch lines that swell with the shade, mitred sticks, a hatched cast shadow, real gaps at crossings; an SVG figure without WebGL2 (`?nogl`).
- The Enumerations page is set in ink with paper for line, the one inverted page.
- Every number comes from `data.js` or `tables.js`; every claim that the theorem is proved is gated on `data-proof`.

## Colors

Restrained and committed at once: paper and one ink carry the page, vermilion is rationed, and one band is drenched.

### Primary
- **Indigo Ink** (indigo-ink): text, every engraved line, plate rules, colour 0 of the colouring palette. **Indigo Soft** for secondary text, captions and readouts.

### Secondary
- **Vermilion** (vermilion): the origin bead of the model, the current plate in the index, the Begin control, a pressed chip, blocked corners and broken crossing rules, the "Making of." lead, link underlines. **Vermilion Deep** for hover and for vermilion text on paper.

### Tertiary: the seven inks (`--c0`..`--c6`, by colour number)
Indigo Ink (0), Viridian (1), Gamboge (2), Violet (3), Sepia (4), Cerulean (5), Olive (6). Printer's inks starting from the plate's own indigo; no red. Viridian also marks what the search accepts and the parts checked on GitHub Actions.

### Neutral
- **Paper** (paper) with a fine indigo grain; **Paper Lit** inside a plate frame; **Paper Deep** for the scrollbar track. **Ink Rule** and **Ink Hair** for rules and lattice lines.
- **Machine Ground** with **Machine Line**: the inverted band. Inside `.machine` the same role variables are redefined, so every component works unchanged; vermilion lightens to **Machine Vermilion** to keep contrast.

### Named rules
**The Red Means Wrong Or Chosen Rule.** Vermilion never colours a knot's own strokes. A vermilion mark on a figure is the origin, a blocked corner or a broken rule; in the furniture it is the one thing selected.

**The Ink Arrives By Weight Rule.** Tone is made by line weight, not by opacity or grey: shade is denser hatching, a shadow is hatching, a vast quantity is an open hatched bar.

## Typography

**Display:** Old Standard TT, italic, for the title and every chapter heading; roman for the theorem and for table numerals. It is the modern face of late nineteenth-century scientific journals, which is where knot tables were first printed.
**Body:** Spectral, with STIX Two Text behind it for mathematical glyphs.
**Furniture:** Spectral SC, letterspaced, for plate numbers, chips, the index, note toggles and labels.

### Hierarchy
- **Display** (h1, italic, `clamp(2.9rem, 7.1vw, 6rem)`, line-height .98): the title only.
- **Headline** (h2, italic, `clamp(2.15rem, 4.3vw, 3.7rem)`): one per chapter. `5₂` is set with a true subscript.
- **Theorem** (roman, `clamp(1.7rem, 3.3vw, 2.9rem)`): the closing statement.
- **Subhead** (roman, 1.5rem): timeline entries and knot names.
- **Lede** (`clamp(1.18rem, 1.5vw, 1.34rem)`), **Body** (1.125rem / 1.6, measure 34rem), **Small** (1rem: readouts, commentary), **Note** (.95rem: margin notes, captions).
- **Furniture** (.74–.86rem small caps, tracking .1–.24em). Prose never uses it; furniture never uses the body face.
- **Code** (monospace, .86em): Lean names and statements only.

## Layout

A fixed 3.25rem running head: mark at left, the six sections (Methodology, Lab, Enumerations, Tables, Code, References), then the Paper, Lean and GitHub pills. Below it, a 16rem outline column and the page. The title page drops the outline and runs full width.

- **Leaf pages**: text 5fr beside a sticky figure 7fr; "Go deeper" in two columns below; previous / next at the foot.
- **Branch pages**: the stage's argument 7fr beside a sticky "In this branch" outline 4fr.
- **The lab**: a full-width bench (canvas, move markers, the diagram inset, captions) beside a 21rem control panel.
- **Reference pages** (Tables, Code, References): a single column of sections with an in-page index.
- **Below 1100px** the section links and the outline become a Contents drawer and the bracket chart becomes an outline. **Below 860px** every split stacks, figures first on the title page. **Below 560px** frames go square and the Lean and GitHub pills give way to the Paper pill alone.

### Named rules
**The Proof In Reach Rule.** The paper and the Lean proof are one click from every page, in the running head, and are the first two of the five ways in on the title page.

**The Every Page Is A Node Rule.** A page that is not in the tree does not exist; the outline, the breadcrumbs and previous / next are all read from the one tree in `app.js`.

**The Clear Caption Rule.** A specimen never runs under its own plate foot.

## Elevation & Depth

There are no drop shadows. Depth is drawn: the model's own hatching, its cast shadow, and the paper margin where one stick passes another. A framed plate is a 1px ink border with a second 1px rule 5px outside it, on Paper Lit, surrounded by a 20px plate mark (a lighter pressed margin with a hairline edge).

## Shapes

Square corners everywhere. Sticks are round in section and mitred at corners. Hit targets on figures are rings (corners) and hatched squares (U-turns). The mark in the running head is a lattice path.

## Components

### Running head and index
Fifteen links in furniture small caps; the current one is vermilion with a 2px bar that grows from the left; the chapter name appears as an ink tip on hover or focus. `←` `→` step between plates; each plate has a hash URL.

### Plate foot
Under every figure, in one row: the plate number, a readout (italic, soft, live numbers in upright ink with tabular figures), then the chips, pushed to the right.

### Chips
1px ink border, square, small caps. Hover fills with ink; `aria-pressed="true"` fills with vermilion. Chips name their action.

### Chapter text
Heading, one or two paragraphs, an optional italic "try" line, the commentary (`details`, toggle in small caps with a vermilion chevron) and optionally a margin note led by "Making of." in vermilion small caps.

### The specimen (`createStage`)
Items are posed by `{x, y, scale, az, el, build, radius, solid, shadow, grid, colMix}`; the stage draws lattice, shadow, clear margin, sticks and the origin bead in that order. Angles come from `anglesOf(direction)`, so a view along an integer direction shows exactly the diagram the Lean definitions use.

### Motion
- Scroll-bound poses in the acts, eased with a cubic in-out.
- Easing elsewhere is `cubic-bezier(.16, 1, .3, 1)`: 300–450ms for states, 900–1500ms for staged reveals (scale bars, timeline rows, the arrival of 36 in the knot table).
- A lightly damped spring for a flipped corner.
- **Reduced motion:** transitions drop to 1ms, models do not turn on their own, the acts snap between their resting poses, and the lattice search advances slowly.

## Do's and Don'ts

### Do
- **Do** write components against the role variables (`--paper`, `--paper-lit`, `--ink`, `--ink-soft`, `--rule`, `--hair`, `--alert`, `--c0`..`--c6`) so they work on paper and in the machine band.
- **Do** make tone with line weight and hatching.
- **Do** draw a stick as two contours with a clear middle.
- **Do** give every figure a plate foot with its plate number.
- **Do** fill every number from `data.js` and gate "proved" on `data-proof="done"` (`.when-done` / `.when-open`).
- **Do** keep a working SVG path for every pose the WebGL stage can take (`?nogl` forces it).

### Don't
- **Don't** colour a knot stroke vermilion.
- **Don't** add drop shadows, rounded corners, gradients for tone, or a second accent.
- **Don't** put a label above a heading; plate numbers belong to the figure's foot.
- **Don't** let the specimen run under its caption.
- **Don't** add a theme or a deck mode. three.js is used by the lab only, loaded when the lab is first opened; the title specimen stays raw WebGL2.
