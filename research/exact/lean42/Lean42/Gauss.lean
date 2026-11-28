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

end code

end Lean42
