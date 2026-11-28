/-
  Lean42.Diagram -- the diagram of a polygon for a fixed projection, and quandle colourings.

  Phase 3/4 (definitions, step A and the definition of step B of the merged route in PLAN.md).
  Sources: Burde-Zieschang, Knots (2nd ed.), 1.C (Definition 1.11, regular projection) and Chapter 3
  (colourings); Lickorish, Chapter 1 and 3.

  The projection.  `proj (x,y,z) = (x + pa z, y + pb z)` with `pa = 0.4142`, `pb = 0.2360`.  Its kernel
  is spanned by `(-pa, -pb, 1)`, so the height of a point above the plane is its z-coordinate:
  of two points with the same projection, the one with larger z is *over*.  The numbers were chosen
  by computation (research/exact/lean42/STATUS.md, section on the quandles): for them all 59,072 words
  of the n = 42 survivor list, and the seed polygons, are generic.

  Generic (B-Z Def. 1.11).  `genericB L`: for every pair of edges
    * non-adjacent and not parallel in projection: the projected segments are either disjoint or meet
      in one point that is interior to both (transversal double point; no vertex on an edge);
    * non-adjacent and parallel in projection: the projected segments are disjoint;
    * adjacent: not parallel in projection, or continuing in the same direction (a vertex in the
      interior of a straight edge);
    * no two crossings on one edge at the same parameter (no triple point).
  Then every crossing is a double point and the crossings along each edge are linearly ordered.

  Events.  A crossing of the edges i < j gives two events, one on each edge: `over` marks the strand
  that is higher, `par` the position along the edge, `cid = (i, j)` names the crossing, and `pos` is
  the sign of the crossing: `true` iff (direction of the over strand, direction of the under strand) is
  a positive basis of the plane.  The events along the polygon (sorted by edge, then parameter) cut
  the polygon into `N` pieces, the piece `k` being the one *after* event `k`; pieces are numbered
  cyclically.  (A crossing is traversed twice, as over and as under; arcs of the usual definition are
  maximal unions of pieces not separated by an under-event.)

  Colourings by a quandle Q (Mathlib `Quandle`, notation `x ◃ y`, the action of x on y).  A colouring
  assigns an element of Q to every piece such that
    * at an over-event the colour does not change;
    * at an under-event with sign `+`, the colour after is `o ◃ (colour before)`, and with sign `-`,
      the colour before is `o ◃ (colour after)`, where `o` is the colour of the over strand of the
      same crossing.
  `col Q L` is the number of colourings (`|Q|` if there are no crossings).  This is the usual
  count of arc colourings: the arcs are the pieces glued along the over-events.
-/
import Lean42.Polygon
import Mathlib.Algebra.Quandle

namespace Lean42
open Quandles

/-! ## Projection -/

def pa : ℚ := 4142 / 10000
def pb : ℚ := 2360 / 10000

/-- the fixed projection to the plane -/
def proj (p : Pt) : ℚ × ℚ := (p 0 + pa * p 2, p 1 + pb * p 2)

/-! ## Crossings -/

structure Ev where
  edge : ℕ
  par : ℚ
  over : Bool
  cid : ℕ × ℕ
  pos : Bool
deriving DecidableEq, Inhabited

/-- the data of the projected edges (e,e') : directions, determinant, offset -/
def pdata (e e' : Pt × Pt) : (ℚ × ℚ) × (ℚ × ℚ) × ℚ × (ℚ × ℚ) :=
  let p := proj e.1; let q := proj e.2; let p' := proj e'.1; let q' := proj e'.2
  let d := (q.1 - p.1, q.2 - p.2); let d' := (q'.1 - p'.1, q'.2 - p'.2)
  (d, d', d.1 * d'.2 - d.2 * d'.1, (p'.1 - p.1, p'.2 - p.2))

/-- the parameters (s, t) of the intersection of the two projected lines (when not parallel) -/
def params (e e' : Pt × Pt) : ℚ × ℚ :=
  let (d, d', den, w) := pdata e e'
  ((w.1 * d'.2 - w.2 * d'.1) / den, (w.1 * d.2 - w.2 * d.1) / den)

/-- the events of the crossing of the edges `i < j` (empty if the projections do not cross) -/
def pairEvents (i j : ℕ) (e e' : Pt × Pt) : List Ev :=
  let (_, _, den, _) := pdata e e'
  if den = 0 then [] else
  let (s, t) := params e e'
  if 0 < s ∧ s < 1 ∧ 0 < t ∧ t < 1 then
    let zi := e.1 2 + s * (e.2 2 - e.1 2)
    let zj := e'.1 2 + t * (e'.2 2 - e'.1 2)
    let sg := decide (0 < den)
    if zj < zi then [⟨i, s, true, (i, j), sg⟩, ⟨j, t, false, (i, j), sg⟩]
    else [⟨i, s, false, (i, j), !sg⟩, ⟨j, t, true, (i, j), !sg⟩]
  else []

/-- two edges (by index) of a polygon with `n` edges are adjacent -/
def adjacentIdx (n i j : ℕ) : Bool := decide (j = i + 1 ∨ (i = 0 ∧ j + 1 = n))

/-- all events, unsorted -/
def allEvents (L : List Pt) : List Ev :=
  let es := edges L
  let n := es.length
  (List.range n).flatMap fun i => (List.range n).flatMap fun j =>
    if i < j ∧ adjacentIdx n i j = false then pairEvents i j es[i]! es[j]! else []

/-- the events in the order in which the polygon meets them -/
def evs (L : List Pt) : List Ev :=
  (allEvents L).mergeSort fun a b => decide (a.edge < b.edge ∨ (a.edge = b.edge ∧ a.par ≤ b.par))

/-! ## Genericity -/

/-- generic pair of non-adjacent edges -/
def okNonAdj (e e' : Pt × Pt) : Bool :=
  let (d, d', den, w) := pdata e e'
  if den = 0 then
    let L := d.1 * d.1 + d.2 * d.2
    let a0 := (w.1 * d.1 + w.2 * d.2) / L
    let a1 := a0 + (d'.1 * d.1 + d'.2 * d.2) / L
    decide (L ≠ 0) && (decide (w.1 * d.2 - w.2 * d.1 ≠ 0) || decide (max a0 a1 < 0) ||
      decide (1 < min a0 a1))
  else
    let (s, t) := params e e'
    decide (¬(0 ≤ s ∧ s ≤ 1 ∧ 0 ≤ t ∧ t ≤ 1) ∨ (0 < s ∧ s < 1 ∧ 0 < t ∧ t < 1))

/-- generic pair of adjacent edges -/
def okAdj (e e' : Pt × Pt) : Bool :=
  let (d, d', den, _) := pdata e e'
  decide (den ≠ 0 ∨ 0 < d.1 * d'.1 + d.2 * d'.2)

/-- every pair of edges is generic -/
def pairsOk (L : List Pt) : Bool :=
  let es := edges L
  let n := es.length
  (List.range n).all fun i => (List.range n).all fun j =>
    if i < j then
      (if adjacentIdx n i j then okAdj es[i]! es[j]! else okNonAdj es[i]! es[j]!)
    else true

/-- the polygon is in general position for the projection (B-Z Def. 1.11) -/
def genericB (L : List Pt) : Bool :=
  pairsOk L && decide (((evs L).map fun e => (e.edge, e.par)).Nodup)

/-! ## Quandle colourings -/

/-- the position of the over event of the crossing `c` -/
def overIdx (E : List Ev) (c : ℕ × ℕ) : ℕ := E.findIdx fun e => e.cid = c && e.over

section col
variable (Q : Type) [Quandle Q] [Fintype Q] [DecidableEq Q]

/-- the colouring conditions for the pieces `f` -/
def Valid (E : List Ev) (h : E.length ≠ 0) (f : Fin E.length → Q) : Prop :=
  let g : ℕ → Q := fun m => f ⟨m % E.length, Nat.mod_lt _ (Nat.pos_of_ne_zero h)⟩
  ∀ k : Fin E.length,
    let ev := E[k.1]!
    let before := g (k.1 + E.length - 1)
    let after := g k.1
    if ev.over then before = after
    else if ev.pos then after = g (overIdx E ev.cid) ◃ before
    else before = g (overIdx E ev.cid) ◃ after

instance (E : List Ev) (h : E.length ≠ 0) (f : Fin E.length → Q) : Decidable (Valid Q E h f) := by
  unfold Valid; infer_instance

/-- the number of colourings of the event list by the quandle `Q` -/
def colE (E : List Ev) : ℕ :=
  if h : E.length = 0 then Fintype.card Q
  else (Finset.univ.filter fun f : Fin E.length → Q => Valid Q E h f).card

/-- the number of colourings of a polygon by `Q` for the fixed projection -/
def col (L : List Pt) : ℕ := colE Q (evs L)

end col

/-! ## The Alexander quandle `Z/n` with `x ◃ y = (1 - t) x + t y`, `t` a unit -/

/-- `Z/n` with the Alexander quandle structure of the unit `t` (inverse `s`). -/
def AlexQ (n : ℕ) (t s : ZMod n) (_h : t * s = 1) : Type := ZMod n

namespace AlexQ
variable {n : ℕ} {t s : ZMod n} {h : t * s = 1}

instance [NeZero n] : Fintype (AlexQ n t s h) := inferInstanceAs (Fintype (ZMod n))
instance : DecidableEq (AlexQ n t s h) := inferInstanceAs (DecidableEq (ZMod n))
instance : Inhabited (AlexQ n t s h) := ⟨(0 : ZMod n)⟩

/-- `x ◃ y = (1 - t) x + t y`: an Alexander quandle (`t` a unit with inverse `s`). -/
instance : Quandle (AlexQ n t s h) where
  act x y := ((1 - t) * (show ZMod n from x) + t * (show ZMod n from y) : ZMod n)
  self_distrib := by
    intro x y z
    show (1 - t) * (show ZMod n from x) + t * ((1 - t) * (show ZMod n from y) + t * (show ZMod n from z))
      = (1 - t) * ((1 - t) * (show ZMod n from x) + t * (show ZMod n from y)) +
        t * ((1 - t) * (show ZMod n from x) + t * (show ZMod n from z))
    ring
  invAct x y := ((1 - s) * (show ZMod n from x) + s * (show ZMod n from y) : ZMod n)
  left_inv := by
    intro x y
    show (1 - s) * (show ZMod n from x) + s * ((1 - t) * (show ZMod n from x) + t * (show ZMod n from y))
      = (show ZMod n from y)
    linear_combination ((show ZMod n from y) - (show ZMod n from x)) * h
  right_inv := by
    intro x y
    show (1 - t) * (show ZMod n from x) + t * ((1 - s) * (show ZMod n from x) + s * (show ZMod n from y))
      = (show ZMod n from y)
    linear_combination ((show ZMod n from y) - (show ZMod n from x)) * h
  fix := by
    intro x
    show (1 - t) * (show ZMod n from x) + t * (show ZMod n from x) = (show ZMod n from x)
    ring

end AlexQ

/-! ## Examples (checked by evaluation against an independent Python computation) -/

/-- a lattice word from letters e w n s u d -/
def letterCode : Char → ℕ
  | 'e' => 0 | 'w' => 1 | 'n' => 2 | 's' => 3 | 'u' => 4 | _ => 5

def strWord (s : String) : List ℕ := s.toList.map letterCode


/-! ## Invariance under translation: the diagram is the same up to the translation of the plane -/

theorem pdata_translate (t : Pt) (e e' : Pt × Pt) :
    pdata (Prod.map (· + t) (· + t) e) (Prod.map (· + t) (· + t) e') = pdata e e' := by
  simp only [pdata, proj, Prod.map, Pi.add_apply, Prod.mk.injEq]
  refine ⟨⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_, ?_, ?_⟩ <;> ring

theorem params_translate (t : Pt) (e e' : Pt × Pt) :
    params (Prod.map (· + t) (· + t) e) (Prod.map (· + t) (· + t) e') = params e e' := by
  unfold params
  rw [pdata_translate]

theorem pairEvents_translate (t : Pt) (i j : ℕ) (e e' : Pt × Pt) :
    pairEvents i j (Prod.map (· + t) (· + t) e) (Prod.map (· + t) (· + t) e') =
      pairEvents i j e e' := by
  unfold pairEvents
  rw [pdata_translate, params_translate]
  simp only [Prod.map, Pi.add_apply]
  have h1 : ∀ s : ℚ, (e.1 2 + t 2) + s * ((e.2 2 + t 2) - (e.1 2 + t 2)) =
      (e.1 2 + s * (e.2 2 - e.1 2)) + t 2 := fun s => by ring
  have h2 : ∀ s : ℚ, (e'.1 2 + t 2) + s * ((e'.2 2 + t 2) - (e'.1 2 + t 2)) =
      (e'.1 2 + s * (e'.2 2 - e'.1 2)) + t 2 := fun s => by ring
  simp only [h1, h2, add_lt_add_iff_right]

theorem getElem!_map' {α β : Type} [Inhabited α] [Inhabited β] (f : α → β) (l : List α) (i : ℕ)
    (hi : i < l.length) : (l.map f)[i]! = f l[i]! := by
  simp [List.getElem!_eq_getElem?_getD, List.getElem?_map, List.getElem?_eq_getElem hi]

theorem allEvents_translate (t : Pt) (L : List Pt) :
    allEvents (L.map (· + t)) = allEvents L := by
  unfold allEvents
  simp only [edges_map, List.length_map]
  apply List.flatMap_congr
  intro i hi
  apply List.flatMap_congr
  intro j hj
  have hi' := List.mem_range.1 hi
  have hj' := List.mem_range.1 hj
  by_cases h : i < j ∧ adjacentIdx (edges L).length i j = false
  · simp only [h, and_self, if_true]
    rw [getElem!_map' _ _ _ hi', getElem!_map' _ _ _ hj']
    exact pairEvents_translate t i j _ _
  · simp only [h, if_false]

theorem evs_translate (t : Pt) (L : List Pt) : evs (L.map (· + t)) = evs L := by
  unfold evs; rw [allEvents_translate]

theorem okAdj_translate (t : Pt) (e e' : Pt × Pt) :
    okAdj (Prod.map (· + t) (· + t) e) (Prod.map (· + t) (· + t) e') = okAdj e e' := by
  unfold okAdj; rw [pdata_translate]

theorem okNonAdj_translate (t : Pt) (e e' : Pt × Pt) :
    okNonAdj (Prod.map (· + t) (· + t) e) (Prod.map (· + t) (· + t) e') = okNonAdj e e' := by
  unfold okNonAdj; rw [pdata_translate, params_translate]

theorem pairsOk_translate (t : Pt) (L : List Pt) : pairsOk (L.map (· + t)) = pairsOk L := by
  unfold pairsOk
  simp only [edges_map, List.length_map]
  rw [Bool.eq_iff_iff]
  simp only [List.all_eq_true, List.mem_range]
  have key : ∀ i < (edges L).length, ∀ j < (edges L).length,
      (if i < j then
        (if adjacentIdx (edges L).length i j then
          okAdj ((edges L).map (Prod.map (· + t) (· + t)))[i]! ((edges L).map (Prod.map (· + t) (· + t)))[j]!
        else okNonAdj ((edges L).map (Prod.map (· + t) (· + t)))[i]! ((edges L).map (Prod.map (· + t) (· + t)))[j]!)
      else true) =
      (if i < j then
        (if adjacentIdx (edges L).length i j then okAdj (edges L)[i]! (edges L)[j]!
        else okNonAdj (edges L)[i]! (edges L)[j]!)
      else true) := by
    intro i hi j hj
    by_cases h : i < j
    · simp only [h, if_true]
      rw [getElem!_map' _ _ _ hi, getElem!_map' _ _ _ hj]
      split_ifs
      · exact okAdj_translate t _ _
      · exact okNonAdj_translate t _ _
    · simp only [h, if_false]
  constructor
  · intro H i hi j hj; rw [← key i hi j hj]; exact H i hi j hj
  · intro H i hi j hj; rw [key i hi j hj]; exact H i hi j hj

/-- genericity is unchanged by translation -/
theorem genericB_translate (t : Pt) (L : List Pt) : genericB (L.map (· + t)) = genericB L := by
  unfold genericB
  rw [evs_translate, pairsOk_translate]

/-- the number of colourings is unchanged by translating the polygon -/
theorem col_translate (Q : Type) [Quandle Q] [Fintype Q] [DecidableEq Q] (t : Pt) (L : List Pt) :
    col Q (L.map (· + t)) = col Q L := by
  unfold col; rw [evs_translate]

/-! ## The invariant: the pair of colouring counts of the two orientations -/

/-- `inv Q L`: the multiset `{col Q L, col Q L.reverse}`; it does not depend on the orientation
    of the polygon, so reversal invariance is automatic. -/
def inv (Q : Type) [Quandle Q] [Fintype Q] [DecidableEq Q] (L : List Pt) : Multiset ℕ :=
  col Q L ::ₘ {col Q L.reverse}

/-- reversal does not change the invariant -/
theorem inv_reverse (Q : Type) [Quandle Q] [Fintype Q] [DecidableEq Q] (L : List Pt) :
    inv Q L.reverse = inv Q L := by
  unfold inv
  rw [List.reverse_reverse]
  have := Multiset.cons_swap (col Q L) (col Q L.reverse) 0
  simpa using this.symm

/-- translation does not change the invariant -/
theorem inv_translate (Q : Type) [Quandle Q] [Fintype Q] [DecidableEq Q] (t : Pt) (L : List Pt) :
    inv Q (L.map (· + t)) = inv Q L := by
  unfold inv
  rw [← List.map_reverse, col_translate, col_translate]

end Lean42
