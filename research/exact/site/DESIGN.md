---
name: The knot 5₂ needs 36 steps: interactive edition
description: The paper set as a Swiss grid programme; the page grid is the lattice and the seven Fox colours are the colour programme.
colors:
  lattice-blue: "#0072b2"
  vermilion: "#d55e00"
  vermilion-deep: "#b34f00"
  green: "#009e73"
  green-deep: "#00805c"
  pink: "#cc79a7"
  umber: "#7a5230"
  sky: "#56b4e9"
  grey: "#7f7f7f"
  grey-deep: "#6b6b6b"
  ground: "#f5f6f7"
  sheet: "#ffffff"
  ink: "#14171b"
  ink-soft: "#4b525c"
  rule: "rgba(20, 23, 27, .16)"
  rule-strong: "rgba(20, 23, 27, .32)"
  bad: "#c0281b"
  good: "#00805c"
typography:
  display:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "clamp(2.4rem, 5.2vw, 4.6rem)"
    fontWeight: 800
    lineHeight: 1.0
    letterSpacing: "-0.025em"
    fontVariation: "'wdth' 108"
  headline:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "clamp(1.7rem, 2.6vw, 2.25rem)"
    fontWeight: 750
    lineHeight: 1.12
    letterSpacing: "-0.015em"
  title:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "1.28rem"
    fontWeight: 700
    lineHeight: 1.25
  body:
    fontFamily: "Source Serif 4, Iowan Old Style, Georgia, serif"
    fontSize: "1.09rem"
    fontWeight: 400
    lineHeight: 1.62
  caption:
    fontFamily: "Source Serif 4, Iowan Old Style, Georgia, serif"
    fontSize: "0.95rem"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "Archivo, Helvetica Neue, Arial, sans-serif"
    fontSize: "0.82rem"
    fontWeight: 600
    lineHeight: 1
    letterSpacing: "0.015em"
  math:
    fontFamily: "STIX Two Math, math"
    fontSize: "1.04em"
  code:
    fontFamily: "JetBrains Mono, ui-monospace, Menlo, monospace"
    fontSize: "0.84em"
rounded:
  none: "0px"
spacing:
  u: "8px"
  gutter: "40px"
  measure: "40rem"
  wide: "58rem"
  rail: "15.5rem"
components:
  button:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.ink}"
    typography: "{typography.label}"
    rounded: "{rounded.none}"
    padding: "9px 14px"
  button-pressed:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.sheet}"
  masthead-link:
    backgroundColor: "{colors.lattice-blue}"
    textColor: "{colors.sheet}"
    typography: "{typography.label}"
    rounded: "{rounded.none}"
    padding: "10px 16px"
  masthead-link-hover:
    backgroundColor: "{colors.sheet}"
    textColor: "{colors.lattice-blue}"
---

# Design System: The knot 5₂ needs 36 steps, interactive edition

## Overview

**Creative North Star: "The lattice is the grid."** The interactive edition of the paper is set as a Swiss grid programme in the tradition of Müller-Brockmann and Gerstner. Every module, rule and figure snaps to one 8px unit, the same lattice the knot lives on, and the colour programme is the seven Fox colours of Z/7, identical to the colours in the paper's figures. The world owns the frame (masthead, contents rail, section openers, figure frames and controls); the reading column stays calm: a serif reading face at a 40rem measure with real contrast.

Key characteristics:
- A full-width masthead in lattice blue on a visible 32px grid, the title in heavy Archivo, and the 36-step polygon drawn in white with crossing gaps.
- A sticky contents rail; each section has a colour square, colour (n − 1) mod 7, repeated at the section opener.
- The paper's own text, statements and proofs (converted from LaTeX, MathML in STIX Two Math), numbered exactly as in the PDF.
- Every figure is an instrument: a white sheet framed by a 2px ink rule above and a hairline below, controls as square outlined buttons, a live readout, then the paper's caption.
- At 1240px and wider, each section's numeral hangs large (9rem Archivo, 20% tint of its colour) in the band right of the reading column, sticky as the section scrolls: the Swiss margin.

## Colors

Full palette, committed to one programme: the seven Fox colours carry every chromatic role, on a cool neutral ground.

### Primary
- **Lattice Blue** (lattice-blue, colour 0): the masthead field, section 1 and 8, focus rings, link underlines.

### Secondary: the Z/7 programme
- **Vermilion** (1), **Green** (2), **Pink** (3), **Umber** (4), **Sky** (5), **Grey** (6), by colour number. They mark sections, arcs of a Fox colouring, and figure states. Where small white numerals sit on a colour (contents squares, section openers), the deep variants **Vermilion Deep**, **Green Deep**, **Grey Deep** keep 4.5:1; pink and sky take ink numerals.

### Neutral
- **Ground** (cool white page), **Sheet** (pure white figure stages and definitions), **Ink** and **Ink Soft** (text), **Rule** and **Rule Strong** (hairlines, scrollbar).
- **Good** and **Bad** for verdicts in figure readouts ("passes", "fails", "balanced").

### Named rules
**The One Programme Rule.** A colour on the page always means the same as in the paper: the arc colour of a Fox colouring, or the section it belongs to. No decorative colour outside Z/7.

**The Square Carries The Number Rule.** A section's colour appears as a solid square holding its number (rail and opener) and as the tint of its theorem blocks, never as a stripe or border on content.

## Typography

**Display and labels:** Archivo (variable, width 108% for the title and the theorem line). **Reading:** Source Serif 4 with optical sizing. **Math:** STIX Two Math (MathML). **Code:** JetBrains Mono, only for Lean names and lattice words.

### Hierarchy
- **Display** (title, 800, clamp(2.4rem, 5.2vw, 4.6rem), 1.0): the masthead only.
- **Headline** (section opener h2, 750, clamp(1.7rem, 2.6vw, 2.25rem)) beside its 56px colour square.
- **Title** (subsection h3, 700, 1.28rem), number in the section colour.
- **Body** (1.09rem / 1.62, measure 40rem); run-in paragraph heads in Archivo 700.
- **Caption** (0.95rem, ink soft) with a bold Archivo "Figure n".
- **Label** (0.82rem Archivo 600): buttons, pane labels, readouts.

## Layout

- One 8px unit. Page max 84rem, gutter 40px; grid of a 15.5rem rail and the document column; reading measure 40rem, figures up to 58rem.
- Figures: panes side by side (2 columns) separated by a hairline; each 3D pane is square.
- Below 860px: one column; the rail becomes a sticky "Contents" disclosure under the masthead; panes stack; the page never scrolls sideways.
- Long display formulas are split into short display lines on the page (build_page.py, `WEB` list); a display that still overflows scrolls inside its own box, with edge shadows whose covers use the surface colour (`--mbg`: ground, theorem tint, or sheet). Inline math stays inline.
- Code breaks only after underscores (`<wbr>`), never with hyphens; long lattice words break every 6 letters.
- Below 600px: the masthead diagram is 60% wide; tables in figures stack, each cell labelled by its column head.

## Elevation & Depth

Flat. Depth exists only inside the 3D figures (three.js, lit tubes). Everything else is separated by rules and by the sheet/ground contrast. No shadows.

## Shapes

Square corners everywhere (buttons, squares, frames). Round only where the geometry is round: lattice vertices, crossing rings, the origin bead.

## Components

### Buttons and segmented controls
Square, 1px ink border, white; hover tints the sheet; pressed (`aria-pressed="true"`) inverts to ink. Segmented groups join borders. Labels name the action ("Switch all crossings", "View along D = (1, −1, 4)").

### Figure instrument
Stage (sheet, 2px ink rule above, hairline below) → controls row → readout (Archivo, verdict words coloured good/bad) → caption. Every figure keeps a static fallback (`figs/*.svg`) for no-script, and a no-WebGL path.

### The lattice studio (3D figures)
Every figure about a knot in space is a real 3D scene (`studio.js`): matte lit tubes on a pale studio ground, and a lattice floor that receives the knot's true shadow, so the shadow is a knot diagram. Labels are HTML pinned to 3D points (Archivo, white chip). Picking is a click on an object; dragging turns the scene; the wheel always scrolls the page. Camera moves and object moves are eased (exponential out) and skipped under reduced motion. The camera fits the drawn points exactly. 2D diagrams use one renderer (`knot2d`): orthographic view along D, round joins, a white casing at each gap, crossings ringed, labels placed clear of strands.

### Byline
The two co-first authors alternate: the masthead lists Chaitanya Chhabra first, the footer Srinjoy Som first, with a note (the PDF alternates by page).

### Contents rail
Numbered colour squares; the current section scales its square and bolds its name.

### Theorem blocks
A 7% tint of the section colour with a hairline outline; the name in Archivo. Definitions, examples and remarks sit on the white sheet.

## Do's and Don'ts

### Do
- Do draw every figure from `data.js` (built by `build_data.py` with the paper's figure code) so the page and the PDF agree.
- Do keep numbering, statements and proofs identical to the paper (`build_page.py` checks theorem numbers against `len52.aux`).
- Do snap spacing to the 8px unit and colour to the Z/7 programme.

### Don't
- Don't add a colour outside the programme, a shadow, a gradient or a rounded corner.
- Don't put a label above a heading, or use glyphs as icons (verdicts are words; ticks are drawn in SVG).
- Don't let figure content or math widen the page on a phone.
