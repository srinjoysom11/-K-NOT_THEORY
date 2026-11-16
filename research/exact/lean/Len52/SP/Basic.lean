/-
  Len52.SP.Basic — the packing of points into natural numbers, and the occupancy array.
-/
import Len52.Search

namespace Len52.SP
open Len52 Len52.Search

theorem V3.ext' {a b : V3} (hx : a.x = b.x) (hy : a.y = b.y) (hz : a.z = b.z) : a = b := by
  cases a; cases b; simp_all

/-! ## Directions -/

theorem rev_lt {d : Nat} (h : d < 6) : rev d < 6 := by unfold rev; split <;> omega
theorem rev_rev {d : Nat} : rev (rev d) = d := by unfold rev; split <;> split <;> omega
theorem rev_ne {d : Nat} : rev d ≠ d := by unfold rev; split <;> omega
theorem axis_rev {d : Nat} : axis (rev d) = axis d := by unfold rev axis; split <;> omega
theorem axis_lt {d : Nat} (h : d < 6) : axis d < 3 := by unfold axis; omega
/-- two directions on the same axis are equal or opposite -/
theorem axis_eq {d e : Nat} (h : axis d = axis e) : d = e ∨ d = rev e := by
  unfold axis at h; unfold rev; split <;> omega

theorem six_cases {d : Nat} (h : d < 6) : d = 0 ∨ d = 1 ∨ d = 2 ∨ d = 3 ∨ d = 4 ∨ d = 5 := by omega

theorem unit_rev (v : V3) {d : Nat} (h : d < 6) : v + unit (rev d) = v - unit d := by
  rcases six_cases h with rfl|rfl|rfl|rfl|rfl|rfl <;>
    apply V3.ext' <;> simp [unit, rev] <;> omega

theorem add_sub_unit (v : V3) (d : Nat) : v + unit d - unit d = v := by
  apply V3.ext' <;> simp <;> omega

theorem sub_add_unit (v : V3) (d : Nat) : v - unit d + unit d = v := by
  apply V3.ext' <;> simp <;> omega

/-- the l1 norm -/
def n1 (v : V3) : Nat := v.x.natAbs + v.y.natAbs + v.z.natAbs

theorem n1_unit (d : Nat) : (unit d).x.natAbs + (unit d).y.natAbs + (unit d).z.natAbs = 1 := by
  unfold unit; split <;> simp

/-! ## Packing -/

def pk (v : V3) : Nat := (v.x + 32).toNat + 64 * (v.y + 32).toNat + 4096 * (v.z + 3).toNat

/-- the range in which the packing is faithful -/
def InB (v : V3) : Prop := -30 ≤ v.x ∧ v.x ≤ 30 ∧ -30 ≤ v.y ∧ v.y ≤ 30 ∧ -2 ≤ v.z ∧ v.z ≤ 27

theorem cx_pk {v : V3} (h : InB v) : cx (pk v) = v.x := by unfold cx pk InB at *; omega
theorem cy_pk {v : V3} (h : InB v) : cy (pk v) = v.y := by unfold cy pk InB at *; omega
theorem cz_pk {v : V3} (h : InB v) : cz (pk v) = v.z := by unfold cz pk InB at *; omega

theorem pk_inj {a b : V3} (ha : InB a) (hb : InB b) (h : pk a = pk b) : a = b := by
  unfold pk InB at *; apply V3.ext' <;> omega

theorem pk_lt {v : V3} (h : InB v) : pk v < NS := by unfold pk NS InB at *; omega

theorem ORG_eq : ORG = pk 0 := by
  have h1 : pk 0 = 14368 := by unfold pk; simp
  have h2 : ORG = 14368 := by unfold ORG; rfl
  rw [h1, h2]

theorem mv_pk {v : V3} (h : InB v) {d : Nat} (hd : d < 6) : mv (pk v) d = pk (v + unit d) := by
  unfold InB at h
  rcases six_cases hd with rfl|rfl|rfl|rfl|rfl|rfl
  · show pk v + 1 = _; simp only [pk, unit, V3.add_x, V3.add_y, V3.add_z]; omega
  · show pk v - 1 = _; simp only [pk, unit, V3.add_x, V3.add_y, V3.add_z]; omega
  · show pk v + 64 = _; simp only [pk, unit, V3.add_x, V3.add_y, V3.add_z]; omega
  · show pk v - 64 = _; simp only [pk, unit, V3.add_x, V3.add_y, V3.add_z]; omega
  · show pk v + 4096 = _; simp only [pk, unit, V3.add_x, V3.add_y, V3.add_z]; omega
  · show pk v - 4096 = _; simp only [pk, unit, V3.add_x, V3.add_y, V3.add_z]; omega

theorem back_pk {v : V3} (h : InB v) {d : Nat} (hd : d < 6) : back (pk v) d = pk (v - unit d) := by
  unfold back; rw [mv_pk h (rev_lt hd), unit_rev v hd]

theorem pk_mod {v : V3} (h : InB v) : pk v % 64 = (v.x + 32).toNat := by unfold pk InB at *; omega
theorem pk_div_mod {v : V3} (h : InB v) : pk v / 64 % 64 = (v.y + 32).toNat := by
  unfold pk InB at *; omega
theorem pk_div {v : V3} (h : InB v) : pk v / 4096 = (v.z + 3).toNat := by unfold pk InB at *; omega

theorem mdist_pk {a b : V3} (ha : InB a) (hb : InB b) :
    mdist (pk a) (pk b) = (a.x - b.x).natAbs + (a.y - b.y).natAbs + (a.z - b.z).natAbs := by
  unfold mdist
  rw [pk_mod ha, pk_mod hb, pk_div_mod ha, pk_div_mod hb, pk_div ha, pk_div hb]
  unfold InB at ha hb
  unfold absd
  split <;> split <;> split <;> omega

theorem dist0_pk {a : V3} (ha : InB a) : dist0 (pk a) = n1 a := by
  unfold dist0; rw [ORG_eq, mdist_pk ha (by unfold InB; simp)]; simp [n1]

/-! ## The table of allowed points -/

theorem allowed_eq {p : Nat} (h : p < NS) : allowed p = allowedB p := by
  unfold allowed allowedTab
  rw [Array.getD_eq_getD_getElem?, Array.getElem?_ofFn, dif_pos h]
  rfl

theorem allowed_pk {v : V3} (h : InB v) (hl : LexPos v) (hx : v.x.natAbs ≤ 24) (hy : v.y.natAbs ≤ 24)
    (hz : v.z ≤ 24) : allowed (pk v) = true := by
  rw [allowed_eq (pk_lt h)]
  unfold allowedB
  rw [cx_pk h, cy_pk h, cz_pk h]
  unfold LexPos at hl
  simp only [Bool.and_eq_true, Bool.or_eq_true, decide_eq_true_eq]
  exact ⟨⟨⟨⟨pk_lt h, hl⟩, hx⟩, hy⟩, hz⟩

/-! ## The occupancy array -/

theorem occAt_set {occ : Array Bool} {p : Nat} (hp : p < occ.size) (b : Bool) (q : Nat) :
    occAt (occ.set! p b) q = if q = p then b else occAt occ q := by
  unfold occAt
  rw [Array.set!_eq_setIfInBounds, Array.getD_eq_getD_getElem?, Array.getElem?_setIfInBounds,
    Array.getD_eq_getD_getElem?]
  by_cases h : p = q
  · subst h; simp [hp]
  · simp [h, Ne.symm h]

theorem size_set (occ : Array Bool) (p : Nat) (b : Bool) : (occ.set! p b).size = occ.size := by
  rw [Array.set!_eq_setIfInBounds, Array.size_setIfInBounds]

theorem occAt_replicate (n q : Nat) : occAt (Array.replicate n false) q = false := by
  unfold occAt
  rw [Array.getD_eq_getD_getElem?, Array.getElem?_replicate]
  split <;> rfl

theorem set_restore {occ : Array Bool} {p : Nat} (h : occAt occ p = false) :
    (occ.set! p true).set! p false = occ := by
  unfold occAt at h
  rw [Array.set!_eq_setIfInBounds, Array.set!_eq_setIfInBounds]
  rw [Array.getD_eq_getD_getElem?] at h
  apply Array.ext_getElem?
  intro i
  rw [Array.getElem?_setIfInBounds, Array.getElem?_setIfInBounds, Array.size_setIfInBounds]
  by_cases hi : p = i
  · subst hi
    by_cases hp : p < occ.size
    · simp only [hp, if_true]
      rw [Array.getElem?_eq_getElem hp] at h ⊢
      simp at h; simp [h]
    · simp only [hp, if_false]; rw [Array.getElem?_eq_none (by omega)]; simp
  · simp [hi]

end Len52.SP
