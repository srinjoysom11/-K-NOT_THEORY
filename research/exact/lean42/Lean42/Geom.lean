/-
  Lean42.Geom -- points of Q^3, closed segments, closed triangles, injective affine maps.

  Phase 1 of research/exact/lean42/PLAN.md.  Sources: Burde-Zieschang, Knots (2nd ed.), Chapter 1,
  section B (Definition 1.6, Delta-move; Definition 1.7, combinatorial equivalence); Lickorish,
  An Introduction to Knot Theory, Chapter 1.

  * `Pt` is Q^3 (functions `Fin 3 → ℚ`), a vector space over ℚ.
  * `seg a b` is the closed segment, the convex hull of {a, b}; `tri a b c` is the closed triangle,
    the convex hull of {a, b, c}.  Both are allowed to be degenerate (a = b, or a, b, c collinear),
    exactly as Burde-Zieschang allow in the Remark after Definition 1.6.
  * `mem_seg`, `mem_tri` give the parametrisations that every later computation uses.
  * `IsAffInj φ`: φ is x ↦ M x + t for an injective linear map M.  Such maps (the lattice
    symmetries, the mirror image, translations) carry segments to segments and triangles to
    triangles; this is the only property of them used in the transport of Delta-moves.
-/
import Lean42.Prelude

namespace Lean42

/-- Points of ℚ³. -/
abbrev Pt := Fin 3 → ℚ

/-- The closed segment [a, b]: the convex hull of the two points. -/
def seg (a b : Pt) : Set Pt := convexHull ℚ {a, b}

/-- The closed triangle abc: the convex hull of the three points. -/
def tri (a b c : Pt) : Set Pt := convexHull ℚ {a, b, c}

/-- Parametrisation of a segment: x = a + t (b - a) with 0 ≤ t ≤ 1. -/
theorem mem_seg {a b x : Pt} :
    x ∈ seg a b ↔ ∃ t : ℚ, 0 ≤ t ∧ t ≤ 1 ∧ x = a + t • (b - a) := by
  unfold seg
  rw [convexHull_pair, segment_eq_image']
  constructor
  · rintro ⟨t, ⟨h0, h1⟩, rfl⟩
    exact ⟨t, h0, h1, rfl⟩
  · rintro ⟨t, h0, h1, rfl⟩
    exact ⟨t, ⟨h0, h1⟩, rfl⟩

/-- Parametrisation of a triangle: x = a + u (b - a) + v (c - a) with u, v ≥ 0 and u + v ≤ 1.
    (u, v are the barycentric coordinates of x for b and c.) -/
theorem mem_tri {a b c x : Pt} :
    x ∈ tri a b c ↔
      ∃ u v : ℚ, 0 ≤ u ∧ 0 ≤ v ∧ u + v ≤ 1 ∧ x = a + u • (b - a) + v • (c - a) := by
  unfold tri
  rw [convexHull_insert (by simp), convexHull_pair, mem_convexJoin]
  constructor
  · rintro ⟨a', ha', y, hy, hx⟩
    rw [Set.mem_singleton_iff] at ha'
    subst ha'
    have hy' := mem_seg.1 (show y ∈ seg b c from by unfold seg; rw [convexHull_pair]; exact hy)
    obtain ⟨ν, hν0, hν1, rfl⟩ := hy'
    rw [segment_eq_image'] at hx
    obtain ⟨μ, ⟨hμ0, hμ1⟩, rfl⟩ := hx
    refine ⟨μ * (1 - ν), μ * ν, by nlinarith, by nlinarith, by nlinarith, ?_⟩
    ext i
    simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]
    ring
  · rintro ⟨u, v, hu, hv, huv, rfl⟩
    refine ⟨a, Set.mem_singleton a, ?_⟩
    by_cases h : u + v = 0
    · have hu0 : u = 0 := by linarith
      have hv0 : v = 0 := by linarith
      subst hu0; subst hv0
      refine ⟨b, ?_, ?_⟩
      · exact left_mem_segment ℚ b c
      · rw [segment_eq_image']
        exact ⟨0, ⟨le_refl _, zero_le_one⟩, by simp⟩
    · have hpos : 0 < u + v := lt_of_le_of_ne (by linarith) (Ne.symm h)
      refine ⟨b + (v / (u + v)) • (c - b), ?_, ?_⟩
      · rw [segment_eq_image']
        exact ⟨v / (u + v), ⟨by positivity, by rw [div_le_one hpos]; linarith⟩, rfl⟩
      · rw [segment_eq_image']
        refine ⟨u + v, ⟨by linarith, huv⟩, ?_⟩
        ext i
        simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]
        field_simp
        ring

theorem left_mem_seg (a b : Pt) : a ∈ seg a b := by
  rw [mem_seg]; exact ⟨0, le_refl _, zero_le_one, by simp⟩

theorem right_mem_seg (a b : Pt) : b ∈ seg a b := by
  rw [mem_seg]; exact ⟨1, zero_le_one, le_refl _, by simp⟩

theorem seg_subset_tri_ab (a b c : Pt) : seg a b ⊆ tri a b c := by
  intro x hx
  obtain ⟨t, h0, h1, rfl⟩ := mem_seg.1 hx
  exact mem_tri.2 ⟨t, 0, h0, le_refl _, by linarith, by simp⟩

theorem left_mem_tri (a b c : Pt) : a ∈ tri a b c := seg_subset_tri_ab a b c (left_mem_seg a b)
theorem mid_mem_tri (a b c : Pt) : b ∈ tri a b c := seg_subset_tri_ab a b c (right_mem_seg a b)
theorem right_mem_tri (a b c : Pt) : c ∈ tri a b c :=
  mem_tri.2 ⟨0, 1, le_refl _, zero_le_one, by norm_num, by simp⟩

/-- A triangle does not depend on the order of its last two vertices. -/
theorem tri_swap_bc (a b c : Pt) : tri a b c = tri a c b := by
  ext x
  rw [mem_tri, mem_tri]
  constructor
  · rintro ⟨u, v, hu, hv, huv, rfl⟩
    refine ⟨v, u, hv, hu, by linarith, ?_⟩
    ext i
    simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]
    ring
  · rintro ⟨u, v, hu, hv, huv, rfl⟩
    refine ⟨v, u, hv, hu, by linarith, ?_⟩
    ext i
    simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]
    ring

/-! ## Injective affine maps -/

/-- φ is `x ↦ M x + t` with `M` an injective ℚ-linear map. -/
def IsAffInj (φ : Pt → Pt) : Prop :=
  ∃ (M : Pt →ₗ[ℚ] Pt) (t : Pt), Function.Injective M ∧ ∀ x, φ x = M x + t

theorem IsAffInj.injective {φ : Pt → Pt} (h : IsAffInj φ) : Function.Injective φ := by
  obtain ⟨M, t, hM, hφ⟩ := h
  intro x y hxy
  rw [hφ, hφ] at hxy
  exact hM (add_right_cancel hxy)

theorem IsAffInj.seg_image {φ : Pt → Pt} (h : IsAffInj φ) (a b : Pt) :
    φ '' seg a b = seg (φ a) (φ b) := by
  obtain ⟨M, t, hM, hφ⟩ := h
  ext y
  constructor
  · rintro ⟨x, hx, rfl⟩
    obtain ⟨s, h0, h1, rfl⟩ := mem_seg.1 hx
    refine mem_seg.2 ⟨s, h0, h1, ?_⟩
    simp only [hφ, map_add, map_smul, map_sub]
    ext i; simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]; ring
  · intro hy
    obtain ⟨s, h0, h1, rfl⟩ := mem_seg.1 hy
    refine ⟨a + s • (b - a), mem_seg.2 ⟨s, h0, h1, rfl⟩, ?_⟩
    simp only [hφ, map_add, map_smul, map_sub]
    ext i; simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]; ring

theorem IsAffInj.tri_image {φ : Pt → Pt} (h : IsAffInj φ) (a b c : Pt) :
    φ '' tri a b c = tri (φ a) (φ b) (φ c) := by
  obtain ⟨M, t, hM, hφ⟩ := h
  ext y
  constructor
  · rintro ⟨x, hx, rfl⟩
    obtain ⟨u, v, hu, hv, huv, rfl⟩ := mem_tri.1 hx
    refine mem_tri.2 ⟨u, v, hu, hv, huv, ?_⟩
    simp only [hφ, map_add, map_smul, map_sub]
    ext i; simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]; ring
  · intro hy
    obtain ⟨u, v, hu, hv, huv, rfl⟩ := mem_tri.1 hy
    refine ⟨a + u • (b - a) + v • (c - a), mem_tri.2 ⟨u, v, hu, hv, huv, rfl⟩, ?_⟩
    simp only [hφ, map_add, map_smul, map_sub]
    ext i; simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul]; ring

end Lean42
