/-
  Lean42.Gauss -- signed Gauss codes, colourings by a quandle, and the Reidemeister moves on them.

  Step 1 of the merged Phase 3/4 route (PLAN.md).  Sources: Burde-Zieschang Ch. 3 (colourings and
  Reidemeister moves), Lickorish Ch. 1, 3.

  The combinatorial diagram.  A *signed Gauss code* is a cyclic list of events.  Each event has a
  crossing name `cid`, says whether the strand passes `over` or under there, and carries the sign `pos`
  of the crossing.  Every crossing occurs twice, once over and once under.

  The count of colourings, as a trace.  For a quandle Q with the action `x ◃ y` (Mathlib `Quandle`)
  write `ac true o x = o ◃ x` and `ac false o x = o ◃⁻¹ x`.  A colouring of the diagram gives each
  crossing `c` the colour `oc c` of its over strand and each piece of the polygon (the part between two
  events) a colour of Q, such that
    * at an over event of c the colour does not change and equals `oc c`;
    * at an under event of c with sign `pos` the colour before, x, and the colour after, y, satisfy
      `y = ac pos (oc c) x` (that is, `y = o ◃ x` for a positive crossing, `x = o ◃ y` for a negative
      one).
  For fixed `oc`, give each event the 0-1 matrix `evMat oc e` indexed by Q x Q with entry 1 at
  (colour before, colour after) when the event allows that pair.  The colourings with the given `oc`
  are the closed paths, so their number is the trace of the product of the matrices along the cycle:
        `gtr oc G = trace (prod (G.map (evMat oc)))`.
  The number of colourings is `colG G = sum over oc of gtr oc G`, the sum taken over all assignments of
  a colour to each crossing name occurring in G (`sumOver`).

  Why this form.  Rotation of the cyclic list is `trace_mul_comm`.  Renaming crossings is a change of
  summation variable.  The Reidemeister moves are identities between sums of products of the matrices
  `Pm o` (the over event: the diagonal projector on the colour o), `Um ε o` (an under event); they
  follow from the quandle axioms (`ac_self`, `ac_ac_inv`, `ac_hom`).
-/
import Lean42.Prelude

namespace Lean42
open Quandles Matrix

set_option linter.unusedSectionVars false

/-! ## Events and codes -/

structure GEv (ν : Type) where
  cid : ν
  over : Bool
  pos : Bool
deriving DecidableEq

/-! ## The signed action of a quandle -/

section ac
variable {Q : Type} [Quandle Q]

theorem inv_act (o y : Q) : o ◃⁻¹ (o ◃ y) = y := Rack.left_inv o y
theorem act_inv (o y : Q) : o ◃ (o ◃⁻¹ y) = y := Rack.right_inv o y

/-- `ac true o x = o ◃ x`, `ac false o x = o ◃⁻¹ x` -/
def ac (ε : Bool) (o x : Q) : Q := if ε then o ◃ x else o ◃⁻¹ x

theorem ac_true (o x : Q) : ac true o x = o ◃ x := rfl
theorem ac_false (o x : Q) : ac false o x = o ◃⁻¹ x := rfl

theorem ac_self (ε : Bool) (o : Q) : ac ε o o = o := by
  cases ε
  · rw [ac_false]
    have h : o ◃ o = o := Quandle.fix
    have := inv_act o o
    rw [h] at this
    exact this
  · rw [ac_true]; exact Quandle.fix

theorem ac_ac_inv (ε : Bool) (o x : Q) : ac (!ε) o (ac ε o x) = x := by
  cases ε
  · exact act_inv o x
  · exact inv_act o x

theorem ac_inj (ε : Bool) (o : Q) {x y : Q} (h : ac ε o x = ac ε o y) : x = y := by
  have := congrArg (ac (!ε) o) h
  rwa [ac_ac_inv, ac_ac_inv] at this

theorem ac_eq_iff (ε : Bool) (o x y : Q) : y = ac ε o x ↔ x = ac (!ε) o y := by
  constructor
  · intro h; rw [h, ac_ac_inv]
  · intro h
    have := ac_ac_inv (!ε) o y
    rw [Bool.not_not] at this
    rw [h, this]

theorem ac_surj (ε : Bool) (o y : Q) : ∃ x, ac ε o x = y := ⟨ac (!ε) o y, by
  have := ac_ac_inv (!ε) o y
  rwa [Bool.not_not] at this⟩

theorem ac_hom_true (ε : Bool) (o p q : Q) :
    ac ε o (p ◃ q) = (ac ε o p) ◃ (ac ε o q) := by
  cases ε
  · rw [ac_false, ac_false, ac_false]
    have hp : p = o ◃ (o ◃⁻¹ p) := (act_inv o p).symm
    have hq : q = o ◃ (o ◃⁻¹ q) := (act_inv o q).symm
    conv_lhs => rw [hp, hq]
    rw [← Shelf.self_distrib, inv_act]
  · exact Shelf.self_distrib

/-- every `ac ε o` is an automorphism of the quandle structure, for both signs of the operation -/
theorem ac_hom (ε δ : Bool) (o p q : Q) :
    ac ε o (ac δ p q) = ac δ (ac ε o p) (ac ε o q) := by
  cases δ
  · rw [ac_false, ac_false]
    have hq : q = p ◃ (p ◃⁻¹ q) := (act_inv p q).symm
    conv_rhs => rw [hq, ac_hom_true]
    rw [inv_act]
  · exact ac_hom_true ε o p q

end ac

/-! ## The matrices of the events -/

section mats
variable {Q : Type} [Quandle Q] [Fintype Q] [DecidableEq Q]

/-- an over event of a crossing whose over strand has colour `o` -/
def Pm (o : Q) : Matrix Q Q ℕ := Matrix.of fun x y => if x = o ∧ y = o then 1 else 0

/-- an under event, with sign `ε`, below an over strand of colour `o` -/
def Um (ε : Bool) (o : Q) : Matrix Q Q ℕ := Matrix.of fun x y => if y = ac ε o x then 1 else 0

theorem Pm_mul_Pm (o o' : Q) : Pm o * Pm o' = if o = o' then Pm o else 0 := by
  ext x z
  simp only [Matrix.mul_apply, Pm, Matrix.of_apply]
  by_cases h : o = o'
  · subst h
    simp only [if_true]
    rw [Finset.sum_eq_single o]
    · by_cases hx : x = o <;> by_cases hz : z = o <;> simp [hx, hz]
    · intro b _ hb; simp [hb]
    · simp
  · simp only [h, if_false]
    apply Finset.sum_eq_zero
    intro y _
    by_cases h1 : y = o <;> by_cases h2 : y = o' <;> simp_all

theorem Pm_comm (o o' : Q) : Pm o * Pm o' = Pm o' * Pm o := by
  rw [Pm_mul_Pm, Pm_mul_Pm]
  by_cases h : o = o'
  · subst h; simp
  · simp [h, Ne.symm h]

theorem Um_mul_Um_inv (ε : Bool) (o : Q) : Um ε o * Um (!ε) o = 1 := by
  ext x z
  simp only [Matrix.mul_apply, Um, Matrix.of_apply, Matrix.one_apply]
  rw [Finset.sum_eq_single (ac ε o x)]
  · simp only [if_true, ac_ac_inv]
    by_cases h : x = z <;> simp [h, eq_comm]
  · intro b _ hb; simp [hb]
  · simp

theorem Pm_mul_Um (ε : Bool) (o : Q) : Pm o * Um ε o = Pm o := by
  ext x z
  simp only [Matrix.mul_apply, Pm, Um, Matrix.of_apply]
  rw [Finset.sum_eq_single o]
  · by_cases hx : x = o <;> by_cases hz : z = o <;> simp [hx, hz, ac_self]
  · intro b _ hb; simp [hb]
  · simp

theorem Um_mul_Pm (ε : Bool) (o : Q) : Um ε o * Pm o = Pm o := by
  ext x z
  simp only [Matrix.mul_apply, Pm, Um, Matrix.of_apply]
  rw [Finset.sum_eq_single o]
  · by_cases hx : x = o <;> by_cases hz : z = o <;> simp [hx, hz, ac_self]
    -- x ≠ o, z = o : o = ac ε o x is impossible
    intro h
    exact hx (ac_inj ε o (by rw [ac_self]; exact h.symm))
  · intro b _ hb; simp [hb]
  · simp

theorem sum_Pm : ∑ o : Q, Pm o = 1 := by
  ext x z
  simp only [Matrix.sum_apply, Pm, Matrix.of_apply, Matrix.one_apply]
  rw [Finset.sum_eq_single x]
  · by_cases h : x = z <;> simp [h, eq_comm]
  · intro b _ hb; simp [Ne.symm hb]
  · simp

end mats

/-! ## Codes, traces and sums over the colours of the crossings -/

section code
variable {ν : Type} [DecidableEq ν] {Q : Type} [Quandle Q] [Fintype Q] [DecidableEq Q]

/-- the matrix of an event for given colours of the over strands -/
def evMat (oc : ν → Q) (e : GEv ν) : Matrix Q Q ℕ :=
  if e.over then Pm (oc e.cid) else Um e.pos (oc e.cid)

/-- the trace of the product of the event matrices along the cycle -/
def gtr (oc : ν → Q) (G : List (GEv ν)) : ℕ := Matrix.trace ((G.map (evMat oc)).prod)

/-- the sum over the colours of the crossing names in a list -/
def sumOver (F : (ν → Q) → ℕ) : List ν → (ν → Q) → ℕ
  | [], oc => F oc
  | c :: cs, oc => ∑ o : Q, sumOver F cs (Function.update oc c o)

/-- the crossing names of a code, each once -/
def names (G : List (GEv ν)) : List ν := (G.map GEv.cid).dedup

/-- the number of colourings of a signed Gauss code by the quandle `Q` -/
def colG (R : Type) [Quandle R] [Fintype R] [DecidableEq R] [Inhabited R] (G : List (GEv ν)) : ℕ :=
  sumOver (fun oc : ν → R => gtr oc G) (names G) (fun _ => default)

theorem sumOver_swap (F : (ν → Q) → ℕ) {a b : ν} (hab : a ≠ b) (l : List ν) (oc : ν → Q) :
    sumOver F (a :: b :: l) oc = sumOver F (b :: a :: l) oc := by
  simp only [sumOver]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl; intro p _
  apply Finset.sum_congr rfl; intro o _
  rw [Function.update_comm hab]

theorem sumOver_perm (F : (ν → Q) → ℕ) {l l' : List ν} (h : l.Perm l') (hl : l.Nodup) :
    ∀ oc, sumOver F l oc = sumOver F l' oc := by
  induction h with
  | nil => intro oc; rfl
  | cons x h ih =>
    intro oc
    simp only [sumOver]
    apply Finset.sum_congr rfl; intro o _
    exact ih (List.nodup_cons.1 hl).2 _
  | swap x y l =>
    intro oc
    have hxy : y ≠ x := by
      intro e; subst e; simp at hl
    exact sumOver_swap F hxy l oc
  | trans h1 h2 ih1 ih2 =>
    intro oc
    exact (ih1 hl oc).trans (ih2 (h1.nodup_iff.1 hl) oc)

theorem gtr_append_comm (oc : ν → Q) (A B : List (GEv ν)) :
    gtr oc (A ++ B) = gtr oc (B ++ A) := by
  unfold gtr
  simp only [List.map_append, List.prod_append]
  exact Matrix.trace_mul_comm _ _

theorem gtr_rotate (oc : ν → Q) (G : List (GEv ν)) (k : ℕ) : gtr oc (G.rotate k) = gtr oc G := by
  rw [List.rotate_eq_drop_append_take_mod]
  conv_rhs => rw [← List.take_append_drop (k % G.length) G]
  exact gtr_append_comm oc _ _

theorem names_perm_rotate (G : List (GEv ν)) (k : ℕ) : (names (G.rotate k)).Perm (names G) := by
  unfold names
  apply List.perm_of_nodup_nodup_toFinset_eq (List.nodup_dedup _) (List.nodup_dedup _)
  ext c
  simp [List.mem_rotate]

/-- **Rotation of the cyclic code does not change the number of colourings.** -/
theorem colG_rotate [Inhabited Q] (G : List (GEv ν)) (k : ℕ) :
    colG Q (G.rotate k) = colG Q G := by
  unfold colG
  have h1 : (fun oc : ν → Q => gtr oc (G.rotate k)) = fun oc => gtr oc G :=
    funext fun oc => gtr_rotate oc G k
  rw [h1]
  exact sumOver_perm _ (names_perm_rotate G k) (List.nodup_dedup _) _

theorem sumOver_sum_comm (F : (ν → Q) → ℕ) {c : ν} (l : List ν) (hc : c ∉ l) (oc : ν → Q) :
    ∑ o : Q, sumOver F l (Function.update oc c o) =
      sumOver (fun oc' => ∑ o : Q, F (Function.update oc' c o)) l oc := by
  induction l generalizing oc with
  | nil => rfl
  | cons x l ih =>
    have hcx : c ≠ x := fun h => hc (by simp [h])
    have hcl : c ∉ l := fun h => hc (by simp [h])
    simp only [sumOver]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl; intro p _
    rw [← ih hcl (Function.update oc x p)]
    apply Finset.sum_congr rfl; intro o _
    rw [Function.update_comm hcx]

theorem evMat_update_of_ne (oc : ν → Q) {c : ν} (o : Q) {e : GEv ν} (h : e.cid ≠ c) :
    evMat (Function.update oc c o) e = evMat oc e := by
  simp [evMat, Function.update_of_ne h]

theorem map_evMat_update (oc : ν → Q) {c : ν} (o : Q) {L : List (GEv ν)} (h : ∀ e ∈ L, e.cid ≠ c) :
    L.map (evMat (Function.update oc c o)) = L.map (evMat oc) :=
  List.map_congr_left fun e he => evMat_update_of_ne oc o (h e he)

theorem tr_sum_Pm (A B : Matrix Q Q ℕ) : ∑ o : Q, Matrix.trace (A * Pm o * B) = Matrix.trace (A * B) := by
  have : ∑ o : Q, A * Pm o * B = A * B := by
    rw [← Finset.sum_mul, ← Finset.mul_sum, sum_Pm, mul_one]
  rw [← Matrix.trace_sum, this]

theorem names_mem (G : List (GEv ν)) (c : ν) : c ∈ names G ↔ ∃ e ∈ G, e.cid = c := by
  simp [names]

/-- **R1.** Removing an adjacent over/under pair of one crossing does not change the count. -/
theorem R1 [Inhabited Q] (X Y : List (GEv ν)) (e1 e2 : GEv ν) (hc : e1.cid = e2.cid)
    (ho : e1.over ≠ e2.over) (hX : ∀ e ∈ X ++ Y, e.cid ≠ e1.cid) :
    colG Q (X ++ e1 :: e2 :: Y) = colG Q (X ++ Y) := by
  set c := e1.cid with hcdef
  have hnot : c ∉ names (X ++ Y) := by
    rw [names_mem]; rintro ⟨e, he, h⟩; exact hX e he h
  have hperm : (names (X ++ e1 :: e2 :: Y)).Perm (c :: names (X ++ Y)) := by
    apply List.perm_of_nodup_nodup_toFinset_eq (List.nodup_dedup _)
      (List.nodup_cons.2 ⟨hnot, List.nodup_dedup _⟩)
    ext n
    simp only [List.mem_toFinset]
    show n ∈ names _ ↔ n ∈ c :: names _
    rw [names_mem, List.mem_cons, names_mem]
    constructor
    · rintro ⟨e, he, rfl⟩
      simp only [List.mem_append, List.mem_cons] at he
      rcases he with he | rfl | rfl | he
      · exact Or.inr ⟨e, List.mem_append.2 (Or.inl he), rfl⟩
      · exact Or.inl rfl
      · exact Or.inl hc.symm
      · exact Or.inr ⟨e, List.mem_append.2 (Or.inr he), rfl⟩
    · rintro (rfl | ⟨e, he, rfl⟩)
      · exact ⟨e1, by simp, rfl⟩
      · exact ⟨e, by simp only [List.mem_append, List.mem_cons] at he ⊢; tauto, rfl⟩
  unfold colG
  rw [sumOver_perm _ hperm (List.nodup_dedup _)]
  simp only [sumOver]
  rw [sumOver_sum_comm _ _ hnot]
  have key : ∀ oc' : ν → Q, ∑ o : Q, gtr (Function.update oc' c o) (X ++ e1 :: e2 :: Y) =
      gtr oc' (X ++ Y) := by
    intro oc'
    have hXn : ∀ e ∈ X, e.cid ≠ c := fun e he => hX e (List.mem_append.2 (Or.inl he))
    have hYn : ∀ e ∈ Y, e.cid ≠ c := fun e he => hX e (List.mem_append.2 (Or.inr he))
    have hmid : ∀ o : Q, (evMat (Function.update oc' c o) e1 * evMat (Function.update oc' c o) e2)
        = Pm o := by
      intro o
      have h1 : (Function.update oc' c o) e1.cid = o := Function.update_self _ _ _
      have h2 : (Function.update oc' c o) e2.cid = o := by rw [← hc]; exact Function.update_self _ _ _
      simp only [evMat, h1, h2]
      by_cases h : e1.over = true
      · have : e2.over = false := by
          cases h2' : e2.over
          · rfl
          · exact absurd (h.trans h2'.symm) ho
        simp [h, this, Pm_mul_Um]
      · have h' : e1.over = false := by simpa using h
        have : e2.over = true := by
          cases h2' : e2.over
          · exact absurd (h'.trans h2'.symm) ho
          · rfl
        simp [h', this, Um_mul_Pm]
    unfold gtr
    have hl : ∀ o : Q, ((X ++ e1 :: e2 :: Y).map (evMat (Function.update oc' c o))).prod =
        (X.map (evMat oc')).prod * Pm o * (Y.map (evMat oc')).prod := by
      intro o
      simp only [List.map_append, List.map_cons, List.prod_append, List.prod_cons]
      rw [map_evMat_update oc' o hXn, map_evMat_update oc' o hYn, ← mul_assoc (evMat _ e1),
        hmid o]
      simp only [mul_assoc]
    simp only [hl]
    rw [tr_sum_Pm]
    simp only [List.map_append, List.prod_append]
  simp only [key]

theorem R2_core (PX PY PZ : Matrix Q Q ℕ) (B1 B2 : Q → Q → Matrix Q Q ℕ)
    (h : ∀ o, B1 o o * B2 o o = 1) :
    ∑ o1 : Q, ∑ o2 : Q, Matrix.trace (PX * (Pm o1 * (Pm o2 * (PY * (B1 o1 o2 * (B2 o1 o2 * PZ)))))) =
      Matrix.trace (PX * (PY * PZ)) := by
  have step : ∀ o1 o2 : Q, Matrix.trace (PX * (Pm o1 * (Pm o2 * (PY * (B1 o1 o2 * (B2 o1 o2 * PZ)))))) =
      if o1 = o2 then Matrix.trace (PX * (Pm o1 * (PY * (B1 o1 o1 * (B2 o1 o1 * PZ))))) else 0 := by
    intro o1 o2
    rw [← mul_assoc (Pm o1) (Pm o2), Pm_mul_Pm]
    by_cases hh : o1 = o2
    · subst hh; simp
    · simp [hh]
  simp only [step, Finset.sum_ite_eq, Finset.mem_univ, if_true]
  have : ∀ o : Q, Matrix.trace (PX * (Pm o * (PY * (B1 o o * (B2 o o * PZ))))) =
      Matrix.trace (PX * Pm o * (PY * PZ)) := by
    intro o
    rw [← mul_assoc (B1 o o), h o, one_mul, mul_assoc PX]
  simp only [this]
  rw [tr_sum_Pm]

/-- **R2.** Two over events of two crossings, adjacent on one strand, and the two under events of the
    same crossings, adjacent on another strand (in either order), with opposite signs: the four events
    can be removed. -/
theorem R2 [Inhabited Q] (X Y Z : List (GEv ν)) (a1 a2 b1 b2 : GEv ν)
    (ha1 : a1.over = true) (ha2 : a2.over = true) (hb1 : b1.over = false) (hb2 : b2.over = false)
    (hc12 : a1.cid ≠ a2.cid)
    (hb : (b1.cid = a1.cid ∧ b2.cid = a2.cid) ∨ (b1.cid = a2.cid ∧ b2.cid = a1.cid))
    (hs : b1.pos ≠ b2.pos)
    (hrest : ∀ e ∈ X ++ (Y ++ Z), e.cid ≠ a1.cid ∧ e.cid ≠ a2.cid) :
    colG Q (X ++ a1 :: a2 :: (Y ++ b1 :: b2 :: Z)) = colG Q (X ++ (Y ++ Z)) := by
  set c1 := a1.cid with hc1
  set c2 := a2.cid with hc2
  have h1n : c1 ∉ names (X ++ (Y ++ Z)) := by
    rw [names_mem]; rintro ⟨e, he, h⟩; exact (hrest e he).1 h
  have h2n : c2 ∉ names (X ++ (Y ++ Z)) := by
    rw [names_mem]; rintro ⟨e, he, h⟩; exact (hrest e he).2 h
  have hperm : (names (X ++ a1 :: a2 :: (Y ++ b1 :: b2 :: Z))).Perm
      (c1 :: c2 :: names (X ++ (Y ++ Z))) := by
    apply List.perm_of_nodup_nodup_toFinset_eq (List.nodup_dedup _)
      (List.nodup_cons.2 ⟨by simp [hc12, h1n], List.nodup_cons.2 ⟨h2n, List.nodup_dedup _⟩⟩)
    ext n
    simp only [List.mem_toFinset]
    show n ∈ names _ ↔ n ∈ c1 :: c2 :: names _
    rw [names_mem, List.mem_cons, List.mem_cons, names_mem]
    constructor
    · rintro ⟨e, he, rfl⟩
      simp only [List.mem_append, List.mem_cons] at he
      rcases he with he | rfl | rfl | he | rfl | rfl | he
      · exact Or.inr (Or.inr ⟨e, by simp [he], rfl⟩)
      · exact Or.inl rfl
      · exact Or.inr (Or.inl rfl)
      · exact Or.inr (Or.inr ⟨e, by simp [he], rfl⟩)
      · rcases hb with hb | hb
        · exact Or.inl hb.1
        · exact Or.inr (Or.inl hb.1)
      · rcases hb with hb | hb
        · exact Or.inr (Or.inl hb.2)
        · exact Or.inl hb.2
      · exact Or.inr (Or.inr ⟨e, by simp [he], rfl⟩)
    · rintro (rfl | rfl | ⟨e, he, rfl⟩)
      · exact ⟨a1, by simp, rfl⟩
      · exact ⟨a2, by simp, rfl⟩
      · exact ⟨e, by simp only [List.mem_append, List.mem_cons] at he ⊢; tauto, rfl⟩
  unfold colG
  rw [sumOver_perm _ hperm (List.nodup_dedup _)]
  simp only [sumOver]
  -- the inner sum over c2, then the outer over c1
  have e1 : ∀ o1 : Q, ∑ o2 : Q, sumOver (fun oc => gtr oc (X ++ a1 :: a2 :: (Y ++ b1 :: b2 :: Z)))
        (names (X ++ (Y ++ Z))) (Function.update (Function.update (fun _ : ν => (default : Q)) c1 o1) c2 o2)
      = sumOver (fun oc' => ∑ o2 : Q, gtr (Function.update oc' c2 o2)
          (X ++ a1 :: a2 :: (Y ++ b1 :: b2 :: Z))) (names (X ++ (Y ++ Z)))
          (Function.update (fun _ : ν => (default : Q)) c1 o1) :=
    fun o1 => sumOver_sum_comm _ _ h2n _
  simp only [e1]
  rw [sumOver_sum_comm _ _ h1n]
  have key : ∀ oc' : ν → Q, ∑ o1 : Q, ∑ o2 : Q,
      gtr (Function.update (Function.update oc' c1 o1) c2 o2)
        (X ++ a1 :: a2 :: (Y ++ b1 :: b2 :: Z)) = gtr oc' (X ++ (Y ++ Z)) := by
    intro oc'
    set ocu : Q → Q → ν → Q := fun o1 o2 => Function.update (Function.update oc' c1 o1) c2 o2
      with hocu
    have hu1 : ∀ o1 o2, ocu o1 o2 c1 = o1 := fun o1 o2 => by
      simp [hocu, Function.update_of_ne hc12]
    have hu2 : ∀ o1 o2, ocu o1 o2 c2 = o2 := fun o1 o2 => by simp [hocu]
    have hmap : ∀ (L : List (GEv ν)), (∀ e ∈ L, e.cid ≠ c1 ∧ e.cid ≠ c2) → ∀ o1 o2,
        L.map (evMat (ocu o1 o2)) = L.map (evMat oc') := by
      intro L hL o1 o2
      simp only [hocu]
      rw [map_evMat_update (Function.update oc' c1 o1) o2 (fun e he => (hL e he).2),
        map_evMat_update oc' o1 (fun e he => (hL e he).1)]
    have hXr : ∀ e ∈ X, e.cid ≠ c1 ∧ e.cid ≠ c2 := fun e he =>
      hrest e (List.mem_append.2 (Or.inl he))
    have hYr : ∀ e ∈ Y, e.cid ≠ c1 ∧ e.cid ≠ c2 := fun e he =>
      hrest e (List.mem_append.2 (Or.inr (List.mem_append.2 (Or.inl he))))
    have hZr : ∀ e ∈ Z, e.cid ≠ c1 ∧ e.cid ≠ c2 := fun e he =>
      hrest e (List.mem_append.2 (Or.inr (List.mem_append.2 (Or.inr he))))
    have ea1 : ∀ o1 o2, evMat (ocu o1 o2) a1 = Pm o1 := fun o1 o2 => by
      simp [evMat, ha1, ← hc1, hu1]
    have ea2 : ∀ o1 o2, evMat (ocu o1 o2) a2 = Pm o2 := fun o1 o2 => by
      simp [evMat, ha2, ← hc2, hu2]
    have hp2 : b2.pos = !b1.pos := by
      cases h1 : b1.pos <;> cases h2 : b2.pos <;> simp_all
    have hB : ∀ o : Q, evMat (ocu o o) b1 * evMat (ocu o o) b2 = 1 := by
      intro o
      have c1' : ocu o o b1.cid = o := by
        rcases hb with ⟨h1, _⟩ | ⟨h1, _⟩ <;> simp [h1, hu1, hu2]
      have c2' : ocu o o b2.cid = o := by
        rcases hb with ⟨_, h2⟩ | ⟨_, h2⟩ <;> simp [h2, hu1, hu2]
      simp only [evMat, hb1, hb2, c1', c2', hp2]
      simp only [Bool.false_eq_true, if_false]
      exact Um_mul_Um_inv _ o
    have core := R2_core (X.map (evMat oc')).prod (Y.map (evMat oc')).prod
      (Z.map (evMat oc')).prod (fun o1 o2 => evMat (ocu o1 o2) b1)
      (fun o1 o2 => evMat (ocu o1 o2) b2) hB
    have lhs : ∀ o1 o2, gtr (ocu o1 o2) (X ++ a1 :: a2 :: (Y ++ b1 :: b2 :: Z)) =
        Matrix.trace ((X.map (evMat oc')).prod * (Pm o1 * (Pm o2 * ((Y.map (evMat oc')).prod *
          (evMat (ocu o1 o2) b1 * (evMat (ocu o1 o2) b2 * (Z.map (evMat oc')).prod)))))) := by
      intro o1 o2
      unfold gtr
      simp only [List.map_append, List.map_cons, List.prod_append, List.prod_cons,
        hmap X hXr, hmap Y hYr, hmap Z hZr, ea1, ea2]
    simp only [hocu] at lhs
    simp only [lhs]
    rw [core]
    simp only [gtr, List.map_append, List.prod_append, mul_assoc]
  simp only [key]

end code

/-! ## R3: the tensor identities -/

section r3
variable {Q : Type} [Quandle Q] [Fintype Q] [DecidableEq Q]

theorem UP_apply (e : Bool) (a o b0 b1 : Q) :
    (Um e a * Pm o) b0 b1 = if b1 = o ∧ ac e a b0 = o then 1 else 0 := by
  simp only [Matrix.mul_apply, Um, Pm, Matrix.of_apply]
  rw [Finset.sum_eq_single (ac e a b0)]
  · by_cases h1 : b1 = o <;> by_cases h2 : ac e a b0 = o <;> simp [h1, h2]
  · intro b _ hb; simp [hb]
  · simp

theorem PU_apply (e : Bool) (a o b0 b1 : Q) :
    (Pm o * Um e a) b0 b1 = if b0 = o ∧ b1 = ac e a o then 1 else 0 := by
  simp only [Matrix.mul_apply, Um, Pm, Matrix.of_apply]
  rw [Finset.sum_eq_single o]
  · by_cases h1 : b0 = o <;> by_cases h2 : b1 = ac e a o <;> simp [h1, h2]
  · intro b _ hb; simp [hb]
  · simp

theorem UU_apply (e f : Bool) (a o c0 c2 : Q) :
    (Um e a * Um f o) c0 c2 = if c2 = ac f o (ac e a c0) then 1 else 0 := by
  simp only [Matrix.mul_apply, Um, Matrix.of_apply]
  rw [Finset.sum_eq_single (ac e a c0)]
  · simp
  · intro b _ hb; simp [hb]
  · simp

/-- the matrix of the pair of events on the middle strand: under at x (sign `εx`, over colour `α`),
    over at z (colour `oz`), in this order if `Bf`, in the other order otherwise -/
def XB (Bf : Bool) (εx : Bool) (α oz : Q) : Matrix Q Q ℕ :=
  if Bf then Um εx α * Pm oz else Pm oz * Um εx α

/-- the matrix of the pair of events on the lower strand: under at y (sign `εy`, over colour `α`) and
    under at z (sign `εz`, over colour `oz`), y first if `Cf` -/
def YC (Cf : Bool) (εy εz : Bool) (α oz : Q) : Matrix Q Q ℕ :=
  if Cf then Um εy α * Um εz oz else Um εz oz * Um εy α

theorem tensor_key1 (εx εy εz : Bool) (h : εx = εy) (α b0 c0 : Q) :
    ac εz (ac εx α b0) (ac εy α c0) = ac εy α (ac εz b0 c0) := by
  rw [ac_hom εy εz α b0 c0, h]

theorem tensor_key2 (εx εy εz : Bool) (h : εy = !εx) (α b0 c0 : Q) :
    ac εy α (ac εz (ac εx α b0) c0) = ac εz b0 (ac εy α c0) := by
  rw [ac_hom εy εz α (ac εx α b0) c0, h, ac_ac_inv]

/-- **The identity behind R3.**  Swapping the two events on each of the two strands does not change the
    sum over the colour `oz` of the crossing of these two strands, as a tensor. -/
theorem R3_tensor (Bf Cf εx εy εz : Bool) (hs : (εx = εy) ↔ (Bf = Cf)) (α : Q) (b0 b1 c0 c2 : Q) :
    ∑ oz : Q, XB Bf εx α oz b0 b1 * YC Cf εy εz α oz c0 c2 =
      ∑ oz : Q, XB (!Bf) εx α oz b0 b1 * YC (!Cf) εy εz α oz c0 c2 := by
  have e1 : (εx = εy) → εx = εy := id
  cases Bf <;> cases Cf
  · -- Bf = false, Cf = false : εx = εy
    have h : εx = εy := hs.2 rfl
    simp only [XB, YC, Bool.not_false, if_true, Bool.false_eq_true, if_false, PU_apply, UP_apply,
      UU_apply]
    rw [Finset.sum_eq_single b0, Finset.sum_eq_single b1]
    · by_cases hb : b1 = ac εx α b0
      · subst hb
        simp only [and_self, if_true, one_mul, true_and]
        have := tensor_key1 εx εy εz h α b0 c0
        simp [this]
      · simp [hb, eq_comm]
    · intro o _ ho; by_cases h1 : b0 = o <;> by_cases h2 : b1 = o <;> simp_all [eq_comm]
    · simp
    · intro o _ ho; by_cases h1 : b0 = o <;> by_cases h2 : b1 = o <;> simp_all [eq_comm]
    · simp
  · -- Bf = false, Cf = true : εy = !εx
    have h : εy = !εx := by
      have : ¬ (εx = εy) := fun h' => by simpa using hs.1 h'
      cases εx <;> cases εy <;> simp_all
    simp only [XB, YC, Bool.not_false, Bool.not_true, if_true, Bool.false_eq_true, if_false,
      PU_apply, UP_apply, UU_apply]
    rw [Finset.sum_eq_single b0, Finset.sum_eq_single b1]
    · by_cases hb : b1 = ac εx α b0
      · subst hb
        simp only [and_self, if_true, one_mul, true_and]
        have := tensor_key2 εx εy εz h α b0 c0
        simp [this]
      · simp [hb, eq_comm]
    · intro o _ ho; by_cases h1 : b0 = o <;> by_cases h2 : b1 = o <;> simp_all [eq_comm]
    · simp
    · intro o _ ho; by_cases h1 : b0 = o <;> by_cases h2 : b1 = o <;> simp_all [eq_comm]
    · simp
  · -- Bf = true, Cf = false : εy = !εx
    have h : εy = !εx := by
      have : ¬ (εx = εy) := fun h' => by simpa using hs.1 h'
      cases εx <;> cases εy <;> simp_all
    simp only [XB, YC, Bool.not_false, Bool.not_true, if_true, Bool.false_eq_true, if_false,
      PU_apply, UP_apply, UU_apply]
    rw [Finset.sum_eq_single b1, Finset.sum_eq_single b0]
    · by_cases hb : b1 = ac εx α b0
      · subst hb
        simp only [and_self, if_true, one_mul, true_and]
        have := tensor_key2 εx εy εz h α b0 c0
        simp [this]
      · simp [hb, eq_comm]
    · intro o _ ho; by_cases h1 : b0 = o <;> by_cases h2 : b1 = o <;> simp_all [eq_comm]
    · simp
    · intro o _ ho; by_cases h1 : b0 = o <;> by_cases h2 : b1 = o <;> simp_all [eq_comm]
    · simp
  · -- Bf = true, Cf = true : εx = εy
    have h : εx = εy := hs.2 rfl
    simp only [XB, YC, Bool.not_false, Bool.not_true, if_true, Bool.false_eq_true, if_false,
      PU_apply, UP_apply, UU_apply]
    rw [Finset.sum_eq_single b1, Finset.sum_eq_single b0]
    · by_cases hb : b1 = ac εx α b0
      · subst hb
        simp only [and_self, if_true, one_mul, true_and]
        have := tensor_key1 εx εy εz h α b0 c0
        simp [this]
      · simp [hb, eq_comm]
    · intro o _ ho; by_cases h1 : b0 = o <;> by_cases h2 : b1 = o <;> simp_all [eq_comm]
    · simp
    · intro o _ ho; by_cases h1 : b0 = o <;> by_cases h2 : b1 = o <;> simp_all [eq_comm]
    · simp

theorem trace_expand (N M1 X Y : Matrix Q Q ℕ) :
    Matrix.trace (N * X * M1 * Y) =
      ∑ l, ∑ k, ∑ j, ∑ i, N l i * M1 j k * (X i j * Y k l) := by
  simp only [Matrix.trace, Matrix.diag_apply, Matrix.mul_apply, Finset.sum_mul]
  apply Finset.sum_congr rfl; intro l _
  apply Finset.sum_congr rfl; intro k _
  apply Finset.sum_congr rfl; intro j _
  apply Finset.sum_congr rfl; intro i _
  ring

theorem tensor_trace {ι : Type} [Fintype ι] (M0 M1 M2 : Matrix Q Q ℕ)
    (Xf Yf Xf' Yf' : ι → Matrix Q Q ℕ)
    (h : ∀ i j k l, ∑ z, Xf z i j * Yf z k l = ∑ z, Xf' z i j * Yf' z k l) :
    ∑ z, Matrix.trace (M0 * Xf z * M1 * Yf z * M2) =
      ∑ z, Matrix.trace (M0 * Xf' z * M1 * Yf' z * M2) := by
  have cyc : ∀ X Y : Matrix Q Q ℕ, Matrix.trace (M0 * X * M1 * Y * M2) =
      ∑ l, ∑ k, ∑ j, ∑ i, (M2 * M0) l i * M1 j k * (X i j * Y k l) := by
    intro X Y
    rw [← trace_expand, Matrix.trace_mul_comm]
    simp only [mul_assoc]
  have step : ∀ (Xg Yg : ι → Matrix Q Q ℕ), ∑ z, Matrix.trace (M0 * Xg z * M1 * Yg z * M2) =
      ∑ l, ∑ k, ∑ j, ∑ i, (M2 * M0) l i * M1 j k * ∑ z, (Xg z i j * Yg z k l) := by
    intro Xg Yg
    simp only [cyc, Finset.mul_sum]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl; intro l _
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl; intro k _
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl; intro j _
    rw [Finset.sum_comm]
  rw [step Xf Yf, step Xf' Yf']
  simp only [h]


theorem R3_core (M0 : Q → Matrix Q Q ℕ) (PZ : Matrix Q Q ℕ) (Bf Cf εx εy εz : Bool)
    (hs : (εx = εy) ↔ (Bf = Cf)) :
    ∑ ox : Q, ∑ oy : Q, ∑ oz : Q, Matrix.trace
      ((if ox = oy then M0 ox else 0) * XB Bf εx ox oz * PZ * YC Cf εy εz oy oz * 1) =
    ∑ ox : Q, ∑ oy : Q, ∑ oz : Q, Matrix.trace
      ((if ox = oy then M0 ox else 0) * XB (!Bf) εx ox oz * PZ * YC (!Cf) εy εz oy oz * 1) := by
  have step : ∀ (Bm : Q → Q → Matrix Q Q ℕ) (Cm : Q → Q → Matrix Q Q ℕ) (ox oy oz : Q),
      Matrix.trace ((if ox = oy then M0 ox else 0) * Bm ox oz * PZ * Cm oy oz * 1) =
      if ox = oy then Matrix.trace (M0 ox * Bm ox oz * PZ * Cm ox oz * 1) else 0 := by
    intro Bm Cm ox oy oz
    by_cases h : ox = oy
    · subst h; simp
    · simp [h]
  simp only [step]
  apply Finset.sum_congr rfl; intro ox _
  rw [Finset.sum_comm]
  conv_rhs => rw [Finset.sum_comm]
  simp only [Finset.sum_ite_eq, Finset.mem_univ, if_true]
  apply tensor_trace
  intro i j k l
  exact R3_tensor Bf Cf εx εy εz hs ox i j k l

end r3

end Lean42
