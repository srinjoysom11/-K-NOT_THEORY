---
name: The knot 5₂ needs 36 steps
description: One set of live exhibits shown in three switchable worlds (Cabinet of Models, Plates, Explainer).
colors:
  cabinet-hall-black: "#0b110f"
  cabinet-hall-green: "#1b2a24"
  cabinet-bone: "#ede5d1"
  cabinet-bone-soft: "#b9b09a"
  cabinet-brass: "#c9a45c"
  cabinet-brass-bright: "#e2c27f"
  cabinet-cinnabar: "#d1492e"
  cabinet-brass-rule: "rgba(201, 164, 92, .28)"
  cabinet-label-paper: "#ece4cf"
  cabinet-label-ink: "#231d14"
  cabinet-label-soft: "#5a4f3c"
  cabinet-label-ochre: "#8a5d14"
  cabinet-madder: "#b8553d"
  cabinet-smalt: "#5b7aa8"
  cabinet-verdigris: "#5f8f68"
  cabinet-yellow-ochre: "#c79a46"
  cabinet-mauve: "#8d6f9e"
  cabinet-umber: "#a2734b"
  cabinet-pewter: "#8a979a"
  plates-grey-green-paper: "#e4e8e1"
  plates-paper-light: "#eef1ea"
  plates-indigo-ink: "#1d2752"
  plates-indigo-soft: "#46507a"
  plates-vermilion: "#c8382a"
  plates-vermilion-deep: "#a42619"
  plates-ink-rule: "rgba(29, 39, 82, .35)"
  plates-viridian: "#2d7d5b"
  plates-gamboge: "#b8860b"
  plates-violet: "#6b3fa0"
  plates-sepia: "#8c5a36"
  plates-cerulean: "#2f86ad"
  plates-olive: "#5d6b2e"
  canon-navy: "#0d1018"
  canon-navy-lit: "#151a26"
  canon-chalk: "#ece9e4"
  canon-chalk-soft: "#a7adba"
  canon-blue: "#58c4dd"
  canon-blue-light: "#8bd8ea"
  canon-red: "#fc6255"
  canon-rose: "#e8728a"
  canon-amber: "#f2b84b"
  canon-chalk-rule: "rgba(236, 233, 228, .14)"
  canon-green: "#83c167"
  canon-purple: "#b48ad6"
  canon-orange: "#e07a3f"
  canon-teal: "#5cd0b3"
typography:
  cabinet-display:
    fontFamily: "Bodoni Moda, Didot, serif"
    fontSize: "clamp(2.6rem, 5.6vw, 5.25rem)"
    fontWeight: 600
    lineHeight: 1.04
    letterSpacing: "-0.02em"
  cabinet-headline:
    fontFamily: "Bodoni Moda, Didot, serif"
    fontSize: "clamp(2rem, 3.6vw, 3.3rem)"
    fontWeight: 600
    lineHeight: 1.04
    letterSpacing: "-0.02em"
  cabinet-body:
    fontFamily: "EB Garamond, Garamond, serif"
    fontSize: "1.0625rem"
    fontWeight: 400
    lineHeight: 1.55
  cabinet-label:
    fontFamily: "Barlow Condensed, Arial Narrow, sans-serif"
    fontSize: "0.86rem"
    fontWeight: 400
    letterSpacing: "0.04em"
  cabinet-catalogue:
    fontFamily: "Barlow Condensed, Arial Narrow, sans-serif"
    fontSize: "0.78rem"
    fontWeight: 400
    letterSpacing: "0.14em"
  plates-display:
    fontFamily: "Spectral, Georgia, serif"
    fontSize: "clamp(2.6rem, 5.6vw, 5.25rem)"
    fontWeight: 300
    lineHeight: 1.04
    letterSpacing: "-0.025em"
  plates-headline:
    fontFamily: "Spectral, Georgia, serif"
    fontSize: "clamp(2rem, 3.6vw, 3.3rem)"
    fontWeight: 300
    lineHeight: 1.04
    letterSpacing: "-0.025em"
  plates-body:
    fontFamily: "Spectral, Georgia, serif"
    fontSize: "1.0625rem"
    fontWeight: 400
    lineHeight: 1.55
  plates-label:
    fontFamily: "Spectral SC, Spectral, serif"
    fontSize: "0.86rem"
    fontWeight: 400
    letterSpacing: "0.04em"
  plates-plate-number:
    fontFamily: "Spectral SC, Spectral, serif"
    fontSize: "0.9rem"
    fontWeight: 400
    letterSpacing: "0.22em"
  canon-display:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "clamp(2.6rem, 5.6vw, 5.25rem)"
    fontWeight: 700
    lineHeight: 1.04
    letterSpacing: "-0.03em"
  canon-headline:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "clamp(1.9rem, 3.2vw, 3rem)"
    fontWeight: 700
    lineHeight: 1.04
    letterSpacing: "-0.03em"
  canon-body:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "1.0625rem"
    fontWeight: 400
    lineHeight: 1.55
  canon-label:
    fontFamily: "Source Sans 3, system-ui, sans-serif"
    fontSize: "0.86rem"
    fontWeight: 400
    letterSpacing: "0.04em"
  canon-math:
    fontFamily: "STIX Two Text, Times New Roman, serif"
    fontSize: "1.4rem"
    fontWeight: 400
rounded:
  square: "0px"
  card: "2px"
  key: "3px"
  code: "4px"
  vitrine: "6px"
  pill: "999px"
spacing:
  bar: "3.5rem"
  foot: "3.75rem"
  exhibit-inset: "1rem"
  control-band: "5.6rem"
  control-band-plates: "6rem"
  control-band-phone: "6.6rem"
  plate-offset: "5px"
  label-measure: "34rem"
components:
  flavour-option:
    textColor: "{colors.cabinet-bone-soft}"
    typography: "{typography.cabinet-label}"
    rounded: "{rounded.pill}"
    padding: "0.28rem 0.8rem"
  flavour-option-selected:
    backgroundColor: "{colors.cabinet-brass}"
    textColor: "{colors.cabinet-hall-black}"
    rounded: "{rounded.pill}"
  flavour-option-plates-selected:
    backgroundColor: "{colors.plates-vermilion}"
    textColor: "{colors.plates-grey-green-paper}"
    rounded: "{rounded.square}"
  chip:
    textColor: "{colors.cabinet-bone}"
    typography: "{typography.cabinet-label}"
    rounded: "{rounded.pill}"
    padding: "0.38rem 0.9rem"
  chip-pressed:
    backgroundColor: "{colors.cabinet-brass}"
    textColor: "{colors.cabinet-hall-black}"
    rounded: "{rounded.pill}"
  chip-plates:
    textColor: "{colors.plates-indigo-ink}"
    typography: "{typography.plates-label}"
    rounded: "{rounded.square}"
    padding: "0.38rem 0.9rem"
  readout:
    textColor: "{colors.cabinet-bone-soft}"
    rounded: "{rounded.pill}"
    padding: "0.3rem 0.75rem"
  begin-button:
    backgroundColor: "{colors.cabinet-brass}"
    textColor: "{colors.cabinet-hall-black}"
    rounded: "{rounded.pill}"
    padding: "0.6rem 1.4rem"
  begin-button-hover:
    backgroundColor: "{colors.cabinet-brass-bright}"
  nav-button:
    textColor: "{colors.cabinet-bone}"
    rounded: "{rounded.pill}"
    size: "2.6rem"
  specimen-label:
    backgroundColor: "{colors.cabinet-label-paper}"
    textColor: "{colors.cabinet-label-ink}"
    rounded: "{rounded.card}"
    padding: "1.6rem 1.7rem 1.3rem"
  shadow-card:
    backgroundColor: "{colors.cabinet-label-paper}"
    textColor: "{colors.cabinet-label-ink}"
    rounded: "{rounded.card}"
    width: "min(30%, 15rem)"
  vitrine:
    rounded: "{rounded.vitrine}"
  plate-frame:
    textColor: "{colors.plates-indigo-ink}"
    rounded: "{rounded.square}"
---

# Design System: The knot 5₂ needs 36 steps

## Overview

**Creative North Star: "One Collection, Three Rooms"**

The site is a single collection of working exhibits (a polygon you turn, a corner you flip, a colouring you try) hung in three rooms that the visitor switches between with one control. The Cabinet of Models is a dark museum hall: green-black ground, brass wire, cream specimen labels, catalogue numbers. Plates is an engraved knot-table page: cool grey-green paper, indigo ink, a double-ruled plate frame, roman plate numbers, vermilion kept for what is wrong or chosen. The Explainer is a dark navy chalkboard: chalk-white strokes, blue, amber and teal diagram roles, and no frame at all. The exhibits, chapter grammar, layout and motion are identical in all three; each room changes the material of the ground, the ink, the type and the frame.

Every chapter is one stage, not a scrolling page: an exhibit on one side, a label on the other, the expert layer folded inside the label, and the making-of thread as a margin note beneath it. Density is low and deliberate: one exhibit, one heading, two short paragraphs, then optional depth. The exhibit always demonstrates the claim in the label; nothing is decorative.

The worlds were rolled and picked (Cabinet assigned, Plates picked, Explainer kept as the standing exit). Each room is committed to its own materials rather than averaged into a neutral theme.

**Key Characteristics:**
- Three token sets on `[data-theme="cabinet" | "plates" | "canon"]`, one shared component and layout grammar; every component reads only the role variables (`--ground`, `--ink`, `--accent`, `--alert`, `--rule`, `--paper`, `--c0`..`--c6`, the four font roles).
- One frame per world is the signature move: the lit vitrine, the engraved double-ruled plate, or nothing.
- A seven-colour exhibit palette per world (`--c0`..`--c6`), indexed by Fox colour number, separate from the accent.
- Chapter-by-chapter presentation: 15 stations, arrow keys, rail, hash URLs; all claims about the proof are gated on the live data.
- Labels use the world's numeral/label face (condensed grotesque, small caps, or the sans) for every piece of furniture: rail tips, chips, readouts, catalogue and plate numbers, the note toggle.

## Colors

Three committed palettes over one set of roles: a lit-brass hall, an inked plate, a chalk diagram.

### Primary
- **Museum Brass** (cabinet-brass): the Cabinet accent. The WebGL wire model's material (`0xc9a45c`), the selected flavour, pressed chips, the current rail station, Begin on the hero, the catalogue number, figure highlights. Brightens to **Polished Brass** (cabinet-brass-bright) on hover.
- **Indigo Ink** (plates-indigo-ink): the Plates ink. Body text, knot strokes, vertices, the double plate rule, plate numbers, and colour 0 of the colouring palette. In Plates, ink is the primary voice; the accent is not.
- **Diagram Blue** (canon-blue): the Explainer accent, vertices, selected states, note toggle; also colour 1 of its palette. **Light Diagram Blue** (canon-blue-light) on hover.

### Secondary
- **Vermilion** (plates-vermilion): the Plates accent and the Plates alert at once. Rule-breaking crossings, blocked corners, the origin vertex, the current rail tick, the selected flavour and pressed chip, the note toggle and the "Making of." lead. **Deep Vermilion** (plates-vermilion-deep) on hover.
- **Cabinet Cinnabar** (cabinet-cinnabar): the Cabinet alert and origin vertex (the red bead at the start of the brass model). The one saturated red in the hall.
- **Chalk Red** (canon-red): the Explainer alert only. **Chalk Rose** (canon-rose) is colour 0 of its palette, so a coloured arc never reads as a broken crossing. **Chalk Amber** (canon-amber) is the origin and doubles as colour 3.

### Tertiary: the colouring palettes (`--c0`..`--c6`, by colour number)
- **Cabinet pigments:** Madder (0), Smalt (1), Verdigris (2), Yellow Ochre (3), Mauve (4), Raw Umber (5), Pewter (6). Muted earth pigments, so a painted arc reads as a tinted specimen rather than a signal and the saturated Cinnabar stays unambiguous.
- **Plates inks:** Indigo Ink (0), Viridian (1), Gamboge (2), Violet (3), Sepia (4), Cerulean (5), Olive (6). Printer's inks starting from the plate's own indigo; no red.
- **Explainer roles:** Chalk Red (0), Diagram Blue (1), Green (2), Chalk Amber (3), Purple (4), Orange (5), Teal (6). Bright diagram colours on navy.
- The same palette also colours the Lean dependency nodes (kernel 2, search 3, colour 1, topology 0) and the "checked on GitHub Actions" cells (2).

### Neutral
- **Hall Black** (cabinet-hall-black) lit to **Hall Green** (cabinet-hall-green) by a radial pool of light at 38% 30%: the Cabinet ground. **Bone** (cabinet-bone) and **Bone Soft** (cabinet-bone-soft) for text on it. **Brass Rule** (cabinet-brass-rule) for hairlines.
- **Label Paper** (cabinet-label-paper) with **Label Ink**, **Label Soft** and **Label Ochre**: the Cabinet's specimen cards. Ochre replaces brass on paper, where brass would fail contrast (note toggle, "Making of." lead, rule numbers, link underlines).
- **Grey-Green Paper** (plates-grey-green-paper) to **Paper Light** (plates-paper-light) from the top: the Plates ground. **Indigo Soft** for secondary text, **Ink Rule** for hairlines.
- **Navy** (canon-navy) lit to **Navy Lit** (canon-navy-lit): the Explainer ground. **Chalk** and **Chalk Soft** for text, **Chalk Rule** for hairlines.

### Named Rules
**The Red Means Wrong Rule.** The knot's own strokes and its colouring palette never borrow the alert red as an ordinary colour. Plates starts its colour roles from indigo and carries no red at all; the Cabinet's colour 0 is a muted madder, not the cinnabar alert. A saturated red mark on a knot means a broken crossing rule, a blocked corner, or the origin. The Explainer follows the same rule: its colour 0 is Chalk Rose, and Chalk Red is kept for alerts.

**The Ochre On Paper Rule.** Brass is for the dark hall. On cream specimen paper the same role switches to Label Ochre, so the accent stays legible on both grounds.

**The Pigment Rule.** Cabinet exhibit colours are pigments (desaturated, earthy, 40-60% lightness); they tint specimens, they do not glow.

## Typography

**Cabinet:** Bodoni Moda display, EB Garamond body and math, Barlow Condensed for numerals and labels.
**Plates:** Spectral throughout (light italic display), Spectral SC for numerals and labels.
**Explainer:** Source Sans 3 for display, body and labels; STIX Two Text for theorem statements.

**Character:** The Cabinet pairs a high-contrast Didone with a bookish Garamond and a narrow museum-label grotesque. Plates is one engraver's family set in light italic for titles and small caps for every caption. The Explainer is a plain, heavy sans with a proper math serif for the theorem.

### Hierarchy
- **Display** (h1, hero title only; world weight 600 / 300 / 700, `clamp(2.6rem, 5.6vw, 5.25rem)`, line-height 1.04, balanced): "The knot 5₂ needs 36 steps". Phones: `clamp(2.2rem, 10vw, 3.2rem)`.
- **Headline** (h2, one per chapter; `clamp(2rem, 3.6vw, 3.3rem)`, Explainer `clamp(1.9rem, 3.2vw, 3rem)`, phones `clamp(1.75rem, 8vw, 2.4rem)`). Italic in Plates.
- **Lede** (1.22rem): the opening paragraph of a hero chapter.
- **Theorem** (math face, 1.4rem): the finale's statement.
- **Body** (1.0625rem / 1.55, paragraphs max 62ch, label column max 34rem). Expert-note text .97rem, margin note .92rem, both in the soft ink.
- **Label** (numeral face, .78-.92rem, tracking .03-.06em): rail tips, chips, readouts, the where-indicator, the note toggle. Readouts use tabular numerals; `readout big` grows to `clamp(1.05rem, 1.6vw, 1.35rem)`.
- **Catalogue / plate number** (Cabinet .78rem, .14em, uppercase "CAT. 5₂ · 08"; Plates .9rem, .22em, small caps "PLATE XI"): world wayfinding attached to the exhibit frame, never above a heading.
- **Code** (ui-monospace, .86em): Lean names and theorem signatures only.

### Named Rules
**The Furniture Face Rule.** Everything that is not prose (numbers, chips, readouts, captions, rail tips, frame numbers) is set in the world's `--font-num`. Prose never uses it; furniture never uses the body face.

**The Note Name Rule.** The expert disclosure is the same element in every world but carries the world's name: "Curator's note" (Cabinet), "Commentary" (Plates), "For the expert" (Explainer).

## Layout

The page is a fixed stage, not a scroll. A 3.5rem top bar (brand at left, the 15-station rail centred, the flavour switch at right) and a 3.75rem footer (prev, "n / 15 title", next) are fixed; the deck fills the space between. Each chapter is an absolutely positioned grid that cross-fades in.

- **Chapter grid:** exhibit `minmax(0, 1.45fr)` beside label `minmax(19rem, 1fr)`; gap `clamp(1.5rem, 3vw, 3.5rem)`; padding `clamp(.75rem, 2vh, 1.75rem) clamp(1rem, 3.5vw, 3rem)`. The label is vertically centred and scrolls internally if it must.
- **Hero chapters** (Start, Thirty-six) reverse the order: label `minmax(19rem, .9fr)` on the left, exhibit `minmax(0, 1.5fr)` on the right, so the exhibit takes about 56% of the width.
- **Exhibit interior:** figures fill the exhibit absolutely. When an exhibit has a control band, the figure stops above it: height `calc(100% - 5.6rem)`, 6rem in Plates (the plate number hangs below), 6.6rem on phones. Panel controls sit 1rem from the sides and 1.1rem from the bottom, centred and wrapping. Overlays (word line, equations readout, Lean box, tray, wall, timeline) are inset 1-1.2rem.
- **Plates** add 2.6rem of bottom padding to each chapter so the plate number has room under the frame.
- **At 860px and below:** one column; the exhibit row is an explicit `56vh`, the label follows; the chapter scrolls vertically. The rule tray becomes 2 × 4. The equations readout and the footer title hide. Row gap 1.6rem (3.2rem in Plates, for the plate number).
- **At 520px and below:** the rail hides; the brand and the switch sit at the ends of the bar.

### Named Rules
**The Explicit Height Rule.** Exhibit content is absolutely positioned, so every exhibit container must get its height from the grid (a `1fr` row on desktop, an explicit `56vh` row on phones), never from its content. An exhibit in an auto-height row collapses to zero.

**The Control Band Rule.** A figure never runs under its own chips and readouts; it ends where the control band begins.

## Elevation & Depth

Depth is a property of the world, not of components. The Cabinet is layered and lit; Plates is flat ink on paper; the Explainer is flat chalk on a dark board.

### Shadow Vocabulary
- **Vitrine** (Cabinet exhibit; `inset 0 1px 0 rgba(255,245,220,.10), inset 0 0 0 1px rgba(201,164,92,.10), 0 30px 60px -30px rgba(0,0,0,.8)` over a top-lit radial glow): a glass case standing in a dark hall.
- **Specimen card** (Cabinet label; `0 18px 40px -18px rgba(0,0,0,.75), 0 2px 6px rgba(0,0,0,.35)`): a paper card resting on the case.
- **Shadow card** (Cabinet hero; `0 14px 30px -14px rgba(0,0,0,.8), 0 2px 5px rgba(0,0,0,.35)`): the drawn shadow propped in the vitrine.
- **Begin lift** (`0 8px 18px -10px rgba(0,0,0,.55)`): the one raised button, removed in Plates and on Cabinet paper.

The Cabinet hero is real 3D: a three.js brass tube model on a cream plinth, lit by a single directional light exactly along the projection direction, so the cast shadow is the knot diagram.

### Named Rules
**The Flat Plate Rule.** Plates has no shadows. Its depth is a 1px ink border plus a 1px ink outline offset 5px (the engraved double rule) on a 28% white wash.

**The Bare Board Rule.** The Explainer has no frame and no shadow; the diagram floats on the navy ground.

## Shapes

Rounded pills in the dark rooms, square corners on the plate. The Cabinet and Explainer use pills (999px) for the flavour switch, chips, readouts and Begin, circles for the nav buttons, a 6px vitrine and 2px paper cards. Plates overrides every one of those to square corners (0px): switch, options, chips, readouts, nav buttons and Begin. Rail stations are 6px dots in the dark rooms and 1px × 10px engraved ticks in Plates; the current station is a 1.4rem bar in the accent. Knot strokes have round caps; crossings show a real gap in the under-strand. The brand mark is an authored lattice-path SVG in the accent.

## Components

### Flavour switch
Character: a three-way radiogroup that changes the room, not a settings menu.
- **Shape:** 1px rule border, 3px padding, pill (999px) or square in Plates.
- **Options:** furniture face .84rem, soft ink; hover goes to full ink; selected fills with the accent and takes the ground colour as text.
- **Behaviour:** switching runs an iris view transition (a circle clip-path growing from the pressed button, 700ms, ease-out) and remembers the choice; `?style=` selects a world by URL.

### Chips (exhibit controls)
- **Style:** furniture face .86rem, 1px rule border, ground at 78% over the exhibit; Plates uses square corners on a 45% white wash.
- **State:** hover turns the border to the accent; `aria-pressed="true"` fills with the accent (white text in Plates). Focus is a 2px accent outline at 2px offset.
- Chips name their action ("Align with the 5₂ diagram", "Show another way", "Count every way").

### Readouts
- **Style:** furniture face .92rem, tabular numerals, soft ink with the live number in bold full ink, on ground at 82%. Pill in the dark rooms, square in Plates.
- **Variants:** `big` for the main sentence of an exhibit; `eqs`, a right-aligned stack of the crossing equations at top right (hidden on phones).
- Every number comes from the data file; none is typed into the page.

### Chapter (the grammar)
One exhibit plus one label. The label holds: heading, one or two paragraphs, an optional italic "try" line in soft ink naming the interaction, the expert note, and optionally a margin note.
- **Expert note:** a `details` with a hairline rule above, toggle in the furniture face in the accent with a drawn chevron that turns from -45deg to 45deg on open; body .97rem in soft ink, Lean names in code.
- **Margin note ("Making of."):** .92rem soft ink below a dashed hairline (solid in Plates), lead word bold in the accent.

### Vitrine and specimen label (Cabinet signature)
- **Vitrine:** 6px corners, top-lit glow, the vitrine shadow, catalogue number "CAT. 5₂ · NN" at bottom left in the brass furniture face.
- **Specimen label:** Label Paper card, 2px corners, padding 1.6rem 1.7rem 1.3rem, specimen-card shadow, ink and ochre roles. On hero chapters the label drops the card and sits directly on the hall.
- **Shadow card:** a paper card, `min(30%, 15rem)` wide, ratio 1 : 1.12, bottom right of the hero vitrine, redrawing the live shadow diagram in Label Ink with the caption "THE SHADOW, DRAWN".

### Plate frame (Plates signature)
1px ink border, 1px ink outline offset 5px, 6px margin, 28% white wash; the roman plate number ("PLATE XI") centred 2.15rem below the frame (1.9rem on phones). Headings beside it are light italic.

### Navigation
- **Rail:** 15 buttons of 1.6rem (1.05rem wide on phones), dot or tick marks, current station a 1.4rem accent bar with `aria-current="step"`; the chapter name appears as a tip below on hover or focus.
- **Footer:** 2.6rem circular nav buttons (square in Plates) with authored chevron SVGs, 1px rule border turning to the accent on hover, 30% opacity when disabled; the where-indicator "8 / 15 Rules" in tabular furniture face.
- **Keys:** arrow keys and PageUp/PageDown step, Home/End jump, Space advances outside controls; each chapter has a hash URL.

### Motion
One authored moment per kind of change, all on `cubic-bezier(.16, 1, .3, 1)`:
- **Chapter change** (900ms): opacity with a 6px blur that clears as the chapter arrives.
- **State changes** (420ms): switch, chips, rail marks, note chevron.
- **World change** (700ms): the iris clip-path from the switch.
- **Exhibit motion:** idle turning of the hero model, staged reveals in the scale bars and the timeline, a flowing dash on the Lean graph's main edge.
- **Reduced motion:** every transition and animation drops to 1ms, the chapter blur is removed, models do not idle-spin and staged sequences jump to their end state.

## Do's and Don'ts

### Do:
- **Do** write every new component against the role variables (`--ground`, `--ink`, `--ink-soft`, `--accent`, `--alert`, `--rule`, `--paper`, `--c0`..`--c6`, `--font-display/body/num/math`) so it works in all three worlds without per-world code.
- **Do** give each world's frame its own treatment: vitrine and specimen card in the Cabinet, double-ruled plate with a roman plate number in Plates, nothing in the Explainer.
- **Do** keep vermilion off the knot in Plates except for broken crossings, blocked corners and the origin; colour roles start from Indigo Ink.
- **Do** use the Cabinet pigments (muted madder, smalt, verdigris, ochre, mauve, umber, pewter) for exhibit colours and keep Cinnabar as the only saturated red in the hall.
- **Do** switch brass to Label Ochre on specimen paper.
- **Do** give every absolutely positioned exhibit an explicit height from its grid row (56vh on phones) and stop figures above the control band (5.6rem, 6rem in Plates, 6.6rem on phones).
- **Do** gate every claim that the theorem is proved on `data-proof="done"` (`.when-done` / `.when-open`), and fill every number from the data file.
- **Do** set all furniture (chips, readouts, captions, frame numbers, rail tips) in the world's numeral face with tabular figures for counts.
- **Do** keep Plates square-cornered and shadowless.

### Don't:
- **Don't** paint a knot arc in the alert red in Plates, or use a red as Cabinet colour 0 that could be mistaken for the cinnabar alert.
- **Don't** state Len(5₂) = 36 as proved, or quote a count, outside the `data-proof` gate and the data file.
- **Don't** let a figure run under its chips and readouts, or put an absolutely positioned exhibit in an auto-height row.
- **Don't** add a frame, card or shadow to the Explainer, or a shadow to Plates.
- **Don't** use brass on cream paper; it fails contrast there.
- **Don't** put a label or number above a heading; catalogue and plate numbers belong to the exhibit frame.
- **Don't** add a fourth world by forking components; add a token set on `[data-theme]` and a frame rule.
