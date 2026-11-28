/-
  Lean42.Square -- the unit lattice square: where it meets the lattice edges.

  Phase 2 of research/exact/lean42/PLAN.md.  This is the geometry behind the corner flip and the
  U-turn removal of `KnotClass`.

  A *frame* `F = (A, k1, k2, s1, s2)` describes a unit square of the lattice with corners
        A = A,   B = A + s1 e_{k1},   C = A + s1 e_{k1} + s2 e_{k2},   D = A + s2 e_{k2}
  (k1 ≠ k2 axes, s1, s2 = ±1, A in Z^3), in cyclic order A, B, C, D.  `F.Sq` is the closed square
  `{A + σ s1 e_{k1} + τ s2 e_{k2} : 0 ≤ σ, τ ≤ 1}`.

  Main result `lat_edge_square`: let [p,q] be a unit lattice edge and x a point of [p,q] ∩ F.Sq.
  Then either x is a corner of the square and an endpoint of the edge, or [p,q] is one of the four
  sides of the square (in either direction).
  Proof.  Write x = A + σ s1 e_{k1} + τ s2 e_{k2}.  If σ, τ ∈ {0,1}, x is a corner, a lattice point,
  hence an endpoint of the edge (`lat_pt_on_edge`).  Otherwise one of them, say σ, lies strictly
  between 0 and 1; then the k1-coordinate of x is not an integer, so the edge runs along k1; the
  k2-coordinate of x is that of an endpoint of the edge, an integer, so τ ∈ {0,1}; hence x lies on the
  side [A + τ s2 e_{k2}, A + τ s2 e_{k2} + s1 e_{k1}], and `edge_det` says that the edge is this
  side.  The case τ strictly between 0 and 1 is the same with the two axes exchanged.

  The remaining lemmas compute, in the coordinates k1, k2, how the sides, the diagonal and the two
  half-squares meet: they are used to check that the Delta-move triangles are free.
-/
import Lean42.Lat

namespace Lean42

structure Frame where
  A : Pt
  k1 : Fin 3
  k2 : Fin 3
  s1 : ℚ
  s2 : ℚ

namespace Frame

def B (F : Frame) : Pt := F.A + F.s1 • e3 F.k1
def D (F : Frame) : Pt := F.A + F.s2 • e3 F.k2
def C (F : Frame) : Pt := F.A + F.s1 • e3 F.k1 + F.s2 • e3 F.k2

/-- the frame describes a unit lattice square -/
structure Ok (F : Frame) : Prop where
  ne : F.k1 ≠ F.k2
  h1 : F.s1 = 1 ∨ F.s1 = -1
  h2 : F.s2 = 1 ∨ F.s2 = -1
  lat : IsLat F.A

/-- the closed square -/
def Sq (F : Frame) : Set Pt :=
  {x | ∃ σ τ : ℚ, 0 ≤ σ ∧ σ ≤ 1 ∧ 0 ≤ τ ∧ τ ≤ 1 ∧
    x = F.A + σ • (F.s1 • e3 F.k1) + τ • (F.s2 • e3 F.k2)}

/-- the four sides, in both directions -/
def IsSide (F : Frame) (p q : Pt) : Prop :=
  (p = F.A ∧ q = F.B) ∨ (p = F.B ∧ q = F.A) ∨ (p = F.B ∧ q = F.C) ∨ (p = F.C ∧ q = F.B) ∨
  (p = F.C ∧ q = F.D) ∨ (p = F.D ∧ q = F.C) ∨ (p = F.D ∧ q = F.A) ∨ (p = F.A ∧ q = F.D)

end Frame

theorem isLat_smul_e3 {s : ℚ} (hs : s = 1 ∨ s = -1) (k : Fin 3) : IsLat (s • e3 k) := by
  intro j
  rcases hs with rfl | rfl <;> by_cases h : j = k <;> simp [e3_apply, h]
  · exact ⟨1, by simp⟩
  · exact ⟨0, by simp⟩
  · exact ⟨-1, by simp⟩
  · exact ⟨0, by simp⟩

theorem Frame.Ok.latB {F : Frame} (h : F.Ok) : IsLat F.B := isLat_add h.lat (isLat_smul_e3 h.h1 _)
theorem Frame.Ok.latD {F : Frame} (h : F.Ok) : IsLat F.D := isLat_add h.lat (isLat_smul_e3 h.h2 _)
theorem Frame.Ok.latC {F : Frame} (h : F.Ok) : IsLat F.C :=
  isLat_add h.latB (isLat_smul_e3 h.h2 _) |> fun h' => by
    simpa [Frame.B, Frame.C, add_assoc] using h'

theorem not_int_of_mid {a : ℤ} {σ s : ℚ} (h0 : 0 < σ) (h1 : σ < 1) (hs : s = 1 ∨ s = -1)
    (z : ℤ) : (a : ℚ) + σ * s ≠ z := by
  intro h
  rcases hs with rfl | rfl
  · have a1 : (a : ℚ) < z := by linarith
    have a2 : (z : ℚ) < a + 1 := by linarith
    have b1 : a < z := by exact_mod_cast a1
    have b2 : z < a + 1 := by exact_mod_cast a2
    omega
  · have a1 : (z : ℚ) < a := by linarith
    have a2 : (a : ℚ) - 1 < z := by linarith
    have b1 : z < a := by exact_mod_cast a1
    have b2 : a - 1 < z := by exact_mod_cast a2
    omega

theorem eq01_of_int {a z : ℤ} {τ s : ℚ} (h0 : 0 ≤ τ) (h1 : τ ≤ 1) (hs : s = 1 ∨ s = -1)
    (h : (a : ℚ) + τ * s = z) : τ = 0 ∨ τ = 1 := by
  by_contra hne
  push_neg at hne
  have hp : 0 < τ := lt_of_le_of_ne h0 (Ne.symm hne.1)
  have hl : τ < 1 := lt_of_le_of_ne h1 hne.2
  exact not_int_of_mid hp hl hs z h

/-- the side case: σ strictly inside -/
theorem side_case {A p x : Pt} {k1 k2 : Fin 3} {s1 s2 σ τ : ℚ} (hk : k1 ≠ k2)
    (hs1 : s1 = 1 ∨ s1 = -1) (hs2 : s2 = 1 ∨ s2 = -1) (hA : IsLat A) (hp : IsLat p)
    {k : Fin 3} {s : ℚ} (hs : s = 1 ∨ s = -1)
    (hxe : x ∈ seg p (p + s • e3 k)) (hσ0 : 0 < σ) (hσ1 : σ < 1) (hτ0 : 0 ≤ τ) (hτ1 : τ ≤ 1)
    (hx : x = A + σ • (s1 • e3 k1) + τ • (s2 • e3 k2)) :
    (τ = 0 ∧ ((p = A ∧ p + s • e3 k = A + s1 • e3 k1) ∨
              (p = A + s1 • e3 k1 ∧ p + s • e3 k = A))) ∨
    (τ = 1 ∧ ((p = A + s2 • e3 k2 ∧ p + s • e3 k = A + s2 • e3 k2 + s1 • e3 k1) ∨
              (p = A + s2 • e3 k2 + s1 • e3 k1 ∧ p + s • e3 k = A + s2 • e3 k2))) := by
  have hx1 : ∀ i, x i = A i + σ * s1 * (if i = k1 then 1 else 0)
      + τ * s2 * (if i = k2 then 1 else 0) := by
    intro i; rw [hx]; simp [e3_apply]
  obtain ⟨a, ha⟩ := hA k1
  obtain ⟨a2, ha2⟩ := hA k2
  have hxk1 : x k1 = a + σ * s1 := by rw [hx1 k1]; simp [hk, ha]
  have hxk2 : x k2 = a2 + τ * s2 := by rw [hx1 k2]; simp [hk.symm, ha2]
  have hnon : ∀ z : ℤ, x k1 ≠ z := fun z => by rw [hxk1]; exact not_int_of_mid hσ0 hσ1 hs1 z
  obtain ⟨l, hl0, hl1, hxl⟩ := seg_ustep hxe
  have hkk : k = k1 := by
    by_contra hne
    obtain ⟨z, hz⟩ := hp k1
    apply hnon z
    rw [hxl k1, if_neg (Ne.symm hne), hz]; ring
  have hk2 : k2 ≠ k := by rw [hkk]; exact hk.symm
  obtain ⟨z2, hz2⟩ := hp k2
  have hτ : τ = 0 ∨ τ = 1 := by
    apply eq01_of_int hτ0 hτ1 hs2 (a := a2) (z := z2)
    rw [← hxk2, hxl k2, if_neg hk2, hz2]; ring
  have hlatside : ∀ τ0 : ℚ, (τ0 = 0 ∨ τ0 = 1) → IsLat (A + τ0 • (s2 • e3 k2)) := by
    intro τ0 hτ0'
    apply isLat_add hA
    rcases hτ0' with rfl | rfl
    · simpa using isLat_zero
    · simpa using isLat_smul_e3 hs2 k2
  rcases hτ with rfl | rfl
  · left
    refine ⟨rfl, ?_⟩
    have hxs : x ∈ seg A (A + s1 • e3 k1) := by
      rw [mem_seg]
      refine ⟨σ, hσ0.le, hσ1.le, ?_⟩
      rw [hx]; ext i; simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]; ring
    exact edge_det hp hA ⟨k, s, hs, rfl⟩ ⟨k1, s1, hs1, rfl⟩ hxe hxs k1 hnon
  · right
    refine ⟨rfl, ?_⟩
    have hL := hlatside 1 (Or.inr rfl)
    have hxs : x ∈ seg (A + s2 • e3 k2) (A + s2 • e3 k2 + s1 • e3 k1) := by
      rw [mem_seg]
      refine ⟨σ, hσ0.le, hσ1.le, ?_⟩
      rw [hx]; ext i; simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]; ring
    have hL' : IsLat (A + s2 • e3 k2) := by simpa using hL
    exact edge_det hp hL' ⟨k, s, hs, rfl⟩ ⟨k1, s1, hs1, rfl⟩ hxe hxs k1 hnon

theorem Frame.C_eq {F : Frame} : F.C = F.A + F.s2 • e3 F.k2 + F.s1 • e3 F.k1 := by
  simp only [Frame.C]; abel

theorem lat_edge_square {F : Frame} (hF : F.Ok) {p q x : Pt} (hp : IsLat p) (hu : UStep p q)
    (hx : x ∈ seg p q) (hxS : x ∈ F.Sq) :
    ((x = F.A ∨ x = F.B ∨ x = F.C ∨ x = F.D) ∧ (x = p ∨ x = q)) ∨ F.IsSide p q := by
  obtain ⟨σ, τ, hσ0, hσ1, hτ0, hτ1, hxeq⟩ := hxS
  obtain ⟨k, s, hs, rfl⟩ := hu
  by_cases hσ : σ = 0 ∨ σ = 1
  · by_cases hτ : τ = 0 ∨ τ = 1
    · -- x is a corner
      have hcorner : (x = F.A ∨ x = F.B ∨ x = F.C ∨ x = F.D) ∧ IsLat x := by
        rcases hσ with rfl | rfl <;> rcases hτ with rfl | rfl
        · have : x = F.A := by rw [hxeq]; simp
          exact ⟨Or.inl this, by rw [this]; exact hF.lat⟩
        · have : x = F.D := by rw [hxeq]; simp [Frame.D]
          exact ⟨Or.inr (Or.inr (Or.inr this)), by rw [this]; exact hF.latD⟩
        · have : x = F.B := by rw [hxeq]; simp [Frame.B]
          exact ⟨Or.inr (Or.inl this), by rw [this]; exact hF.latB⟩
        · have : x = F.C := by rw [hxeq]; simp [Frame.C]
          exact ⟨Or.inr (Or.inr (Or.inl this)), by rw [this]; exact hF.latC⟩
      exact Or.inl ⟨hcorner.1, lat_pt_on_edge hp ⟨k, s, hs, rfl⟩ hx hcorner.2⟩
    · push_neg at hτ
      have hτp : 0 < τ := lt_of_le_of_ne hτ0 (Ne.symm hτ.1)
      have hτl : τ < 1 := lt_of_le_of_ne hτ1 hτ.2
      have hx' : x = F.A + τ • (F.s2 • e3 F.k2) + σ • (F.s1 • e3 F.k1) := by
        rw [hxeq]; abel
      right
      rcases side_case hF.ne.symm hF.h2 hF.h1 hF.lat hp hs hx hτp hτl hσ0 hσ1 hx' with
        ⟨_, h | h⟩ | ⟨_, h | h⟩
      · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr ⟨h.1, h.2⟩))))))
      · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ⟨h.1, h.2⟩))))))
      · exact Or.inr (Or.inr (Or.inl ⟨h.1, by rw [h.2]; rfl⟩))
      · exact Or.inr (Or.inr (Or.inr (Or.inl ⟨by rw [h.1]; rfl, h.2⟩)))
  · push_neg at hσ
    have hσp : 0 < σ := lt_of_le_of_ne hσ0 (Ne.symm hσ.1)
    have hσl : σ < 1 := lt_of_le_of_ne hσ1 hσ.2
    right
    rcases side_case hF.ne hF.h1 hF.h2 hF.lat hp hs hx hσp hσl hτ0 hτ1 hxeq with
      ⟨_, h | h⟩ | ⟨_, h | h⟩
    · exact Or.inl ⟨h.1, h.2⟩
    · exact Or.inr (Or.inl ⟨h.1, h.2⟩)
    · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ⟨h.1, by rw [h.2, Frame.C_eq]⟩)))))
    · exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl ⟨by rw [h.1, Frame.C_eq], h.2⟩))))

/-! ## The square meets the lattice edges only at corners or along sides -/

/-- **Free edges.**  Let `T` be a set of unit lattice edges none of whose endpoints is `B` or `D`.
    Every point common to such an edge and the square is `A` or `C` and an endpoint of the edge. -/
theorem free_flip {F : Frame} (hF : F.Ok) {e : Pt × Pt} (hu : UStep e.1 e.2) (hl : IsLat e.1)
    (h1 : e.1 ≠ F.B) (h2 : e.1 ≠ F.D) (h3 : e.2 ≠ F.B) (h4 : e.2 ≠ F.D) {x : Pt}
    (hx : x ∈ seg e.1 e.2) (hS : x ∈ F.Sq) :
    (x = F.A ∨ x = F.C) ∧ (x = e.1 ∨ x = e.2) := by
  rcases lat_edge_square hF hl hu hx hS with ⟨hc, hend⟩ | hside
  · refine ⟨?_, hend⟩
    rcases hc with h | h | h | h
    · exact Or.inl h
    · exfalso; rcases hend with h' | h'
      · exact h1 (h'.symm.trans h)
      · exact h3 (h'.symm.trans h)
    · exact Or.inr h
    · exfalso; rcases hend with h' | h'
      · exact h2 (h'.symm.trans h)
      · exact h4 (h'.symm.trans h)
  · exfalso
    unfold Frame.IsSide at hside
    rcases hside with h | h | h | h | h | h | h | h
    · exact h3 h.2
    · exact h1 h.1
    · exact h1 h.1
    · exact h3 h.2
    · exact h4 h.2
    · exact h2 h.1
    · exact h2 h.1
    · exact h4 h.2

/-- Same for the U-turn: the edges avoid `B` and `C` and are not the side `DA`. -/
theorem free_uturn {F : Frame} (hF : F.Ok) {e : Pt × Pt} (hu : UStep e.1 e.2) (hl : IsLat e.1)
    (h1 : e.1 ≠ F.B) (h2 : e.1 ≠ F.C) (h3 : e.2 ≠ F.B) (h4 : e.2 ≠ F.C)
    (h5 : ¬ (e.1 = F.D ∧ e.2 = F.A)) (h6 : ¬ (e.1 = F.A ∧ e.2 = F.D)) {x : Pt}
    (hx : x ∈ seg e.1 e.2) (hS : x ∈ F.Sq) :
    (x = F.A ∨ x = F.D) ∧ (x = e.1 ∨ x = e.2) := by
  rcases lat_edge_square hF hl hu hx hS with ⟨hc, hend⟩ | hside
  · refine ⟨?_, hend⟩
    rcases hc with h | h | h | h
    · exact Or.inl h
    · exfalso; rcases hend with h' | h'
      · exact h1 (h'.symm.trans h)
      · exact h3 (h'.symm.trans h)
    · exfalso; rcases hend with h' | h'
      · exact h2 (h'.symm.trans h)
      · exact h4 (h'.symm.trans h)
    · exact Or.inr h
  · exfalso
    unfold Frame.IsSide at hside
    rcases hside with h | h | h | h | h | h | h | h
    · exact h3 h.2
    · exact h1 h.1
    · exact h1 h.1
    · exact h3 h.2
    · exact h2 h.1
    · exact h4 h.2
    · exact h5 h
    · exact h6 h

/-! ## Coordinates of the corners and of points of the square -/

section coords
variable {F : Frame} (hF : F.Ok)
include hF

theorem cA1 : F.A F.k1 = F.A F.k1 := rfl
theorem cB1 : F.B F.k1 = F.A F.k1 + F.s1 := by simp [Frame.B, e3_apply]
theorem cB2 : F.B F.k2 = F.A F.k2 := by simp [Frame.B, e3_apply, hF.ne.symm]
theorem cC1 : F.C F.k1 = F.A F.k1 + F.s1 := by simp [Frame.C, e3_apply, hF.ne]
theorem cC2 : F.C F.k2 = F.A F.k2 + F.s2 := by simp [Frame.C, e3_apply, hF.ne.symm]
theorem cD1 : F.D F.k1 = F.A F.k1 := by simp [Frame.D, e3_apply, hF.ne]
theorem cD2 : F.D F.k2 = F.A F.k2 + F.s2 := by simp [Frame.D, e3_apply]

end coords

/-- coordinates of `P + t (Q - P)` -/
theorem seg_coord (P Q : Pt) (t : ℚ) (i : Fin 3) :
    (P + t • (Q - P)) i = P i + t * (Q i - P i) := by
  simp

/-! ### Containments in the square -/

theorem sq_mk {F : Frame} {x : Pt} (σ τ : ℚ) (h0 : 0 ≤ σ) (h1 : σ ≤ 1) (h2 : 0 ≤ τ) (h3 : τ ≤ 1)
    (h : x = F.A + σ • (F.s1 • e3 F.k1) + τ • (F.s2 • e3 F.k2)) : x ∈ F.Sq :=
  ⟨σ, τ, h0, h1, h2, h3, h⟩

theorem seg_AC_sub (F : Frame) : seg F.A F.C ⊆ F.Sq := by
  intro x hx
  obtain ⟨t, h0, h1, rfl⟩ := mem_seg.1 hx
  refine sq_mk t t h0 h1 h0 h1 ?_
  ext i; simp [Frame.C]; ring

theorem seg_AD_sub (F : Frame) : seg F.A F.D ⊆ F.Sq := by
  intro x hx
  obtain ⟨t, h0, h1, rfl⟩ := mem_seg.1 hx
  refine sq_mk 0 t le_rfl zero_le_one h0 h1 ?_
  ext i; simp [Frame.D]

theorem seg_DC_sub (F : Frame) : seg F.D F.C ⊆ F.Sq := by
  intro x hx
  obtain ⟨t, h0, h1, rfl⟩ := mem_seg.1 hx
  refine sq_mk t 1 h0 h1 zero_le_one le_rfl ?_
  ext i; simp [Frame.D, Frame.C]; ring

theorem seg_CD_sub (F : Frame) : seg F.C F.D ⊆ F.Sq := by
  intro x hx
  obtain ⟨t, h0, h1, rfl⟩ := mem_seg.1 hx
  refine sq_mk (1 - t) 1 (by linarith) (by linarith) zero_le_one le_rfl ?_
  ext i; simp [Frame.D, Frame.C]; ring

theorem tri_ACB_sub (F : Frame) : tri F.A F.C F.B ⊆ F.Sq := by
  intro x hx
  obtain ⟨u, v, hu, hv, huv, rfl⟩ := mem_tri.1 hx
  refine sq_mk (u + v) u (by linarith) huv hu (by linarith) ?_
  ext i; simp [Frame.C, Frame.B]; ring

theorem tri_ACD_sub (F : Frame) : tri F.A F.C F.D ⊆ F.Sq := by
  intro x hx
  obtain ⟨u, v, hu, hv, huv, rfl⟩ := mem_tri.1 hx
  refine sq_mk u (u + v) hu (by linarith) (by linarith) huv ?_
  ext i; simp [Frame.C, Frame.D]; ring

theorem tri_ADC_sub (F : Frame) : tri F.A F.D F.C ⊆ F.Sq := by
  intro x hx
  obtain ⟨u, v, hu, hv, huv, rfl⟩ := mem_tri.1 hx
  refine sq_mk v (u + v) hv (by linarith) (by linarith) huv ?_
  ext i; simp [Frame.C, Frame.D]; ring

/-! ### How the pieces of the square meet -/

section facts
variable {F : Frame} (hF : F.Ok)
include hF

/-- `C` is not on the side `AD` -/
theorem C_notin_AD : F.C ∉ seg F.A F.D := by
  intro hx
  obtain ⟨t, _, _, h⟩ := mem_seg.1 hx
  have := congrFun h F.k1
  rw [seg_coord, cC1 hF, cD1 hF] at this
  rcases hF.h1 with h1 | h1 <;> simp [h1] at this <;> linarith

/-- `A` is not on the side `DC` -/
theorem A_notin_DC : F.A ∉ seg F.D F.C := by
  intro hx
  obtain ⟨t, _, _, h⟩ := mem_seg.1 hx
  have := congrFun h F.k2
  rw [seg_coord, cC2 hF, cD2 hF] at this
  rcases hF.h2 with h1 | h1 <;> simp [h1] at this <;> linarith

/-- the sides `AD` and `DC` meet only in `D` -/
theorem AD_DC_inter {x : Pt} (h1 : x ∈ seg F.A F.D) (h2 : x ∈ seg F.D F.C) : x = F.D := by
  obtain ⟨t, _, _, e1⟩ := mem_seg.1 h1
  obtain ⟨r, hr0, hr1, e2⟩ := mem_seg.1 h2
  have := congrFun (e1.symm.trans e2) F.k1
  rw [seg_coord, seg_coord, cD1 hF, cC1 hF] at this
  have hr : r = 0 := by
    rcases hF.h1 with h | h <;> simp [h] at this <;> linarith
  rw [e2, hr]; simp

/-- `D` is not on the diagonal `AC` -/
theorem D_notin_AC : F.D ∉ seg F.A F.C := by
  intro hx
  obtain ⟨t, _, _, h⟩ := mem_seg.1 hx
  have a1 := congrFun h F.k1
  have a2 := congrFun h F.k2
  rw [seg_coord, cC1 hF, cD1 hF] at a1
  rw [seg_coord, cC2 hF, cD2 hF] at a2
  rcases hF.h1 with h1 | h1 <;> rcases hF.h2 with h2 | h2 <;> simp [h1, h2] at a1 a2 <;>
    nlinarith

/-- `A` is not on the side `CD` -/
theorem A_notin_CD : F.A ∉ seg F.C F.D := by
  intro hx
  obtain ⟨t, _, _, h⟩ := mem_seg.1 hx
  have := congrFun h F.k2
  rw [seg_coord, cC2 hF, cD2 hF] at this
  rcases hF.h2 with h1 | h1 <;> simp [h1] at this <;> linarith

/-- the diagonal `AC` and the side `CD` meet only in `C` -/
theorem AC_CD_inter {x : Pt} (h1 : x ∈ seg F.A F.C) (h2 : x ∈ seg F.C F.D) : x = F.C := by
  obtain ⟨t, _, ht1, e1⟩ := mem_seg.1 h1
  obtain ⟨r, hr0, hr1, e2⟩ := mem_seg.1 h2
  have := congrFun (e1.symm.trans e2) F.k2
  rw [seg_coord, seg_coord, cC2 hF, cD2 hF] at this
  have ht : t = 1 := by
    rcases hF.h2 with h | h <;> simp [h] at this <;> linarith
  rw [e1, ht]; simp

/-- `D` is not in the triangle `ABC` -/
theorem D_notin_triABC : F.D ∉ tri F.A F.B F.C := by
  intro hx
  obtain ⟨u, v, hu, hv, huv, h⟩ := mem_tri.1 hx
  have a1 := congrFun h F.k1
  have a2 := congrFun h F.k2
  simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul] at a1 a2
  rw [cD1 hF, cB1 hF, cC1 hF] at a1
  rw [cD2 hF, cB2 hF, cC2 hF] at a2
  rcases hF.h1 with h1 | h1 <;> rcases hF.h2 with h2 | h2 <;> simp [h1, h2] at a1 a2 <;>
    nlinarith

/-- the triangle `ACB` and the side `CD` meet only in `C` -/
theorem triACB_CD_inter {x : Pt} (h1 : x ∈ tri F.A F.C F.B) (h2 : x ∈ seg F.C F.D) :
    x = F.C := by
  obtain ⟨u, v, hu, hv, huv, e1⟩ := mem_tri.1 h1
  obtain ⟨r, hr0, hr1, e2⟩ := mem_seg.1 h2
  have a1 := congrFun (e1.symm.trans e2) F.k1
  have a2 := congrFun (e1.symm.trans e2) F.k2
  simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul] at a1 a2
  rw [cC1 hF, cB1 hF, cD1 hF] at a1
  rw [cC2 hF, cB2 hF, cD2 hF] at a2
  have hr : r = 0 := by
    rcases hF.h1 with h1 | h1 <;> rcases hF.h2 with h2 | h2 <;> simp [h1, h2] at a1 a2 <;>
      nlinarith
  rw [e2, hr]; simp

end facts

end Lean42
