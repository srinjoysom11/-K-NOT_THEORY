/-
  Lean42.Words -- lattice words as polygons.

  Phase 1 (embedding of lattice words) and the groundwork of Phase 2 of PLAN.md.

  A word `w : List Nat` over the directions 0..5 = e, w, n, s, u, d (Spec.lean, copied) describes the
  closed walk `v_0 = 0, v_1, ..., v_n = 0`.  Its polygon is the closed polygon with the lattice
  vertices v_0, ..., v_{n-1}:
      `wpoly w = ptwalk 0 w : List Pt`.
  `ptwalk v w` lists the n points `v, v + u_{w_0}, ..., v + u_{w_0} + ... + u_{w_{n-2}}`, where
  `upt d = unit d` seen in Q^3.

  Main results of this file.
    * `isPolygon_iff`: `IsPolygon w` (Spec.lean) is the same as: n ≥ 4, letters < 6, the walk closes
      (`usum w = 0`) and the list `wpoly w` has no repeated point.
    * `latPoly_wpoly`: for `IsPolygon w`, `wpoly w` is a lattice polygon (`LatPoly`), hence by
      `latPoly_simple` a simple closed polygon.
    * `symMat f`: the linear map of Q^3 induced by a lattice symmetry `f` (a signed permutation of
      the axes, `IsSym f`); it is injective (`isAffInj_symMat`) and carries `upt d` to `upt (f d)`.
-/
import Lean42.Spec
import Lean42.Delta
import Lean42.Lat

namespace Lean42
open Lean42.Spec

/-! ## Directions as vectors of Q^3 -/

/-- an integer point of Z^3 as a point of Q^3 -/
def toPt (v : V3) : Pt := ![(v.x : ℚ), (v.y : ℚ), (v.z : ℚ)]

/-- the unit vector of direction d, in Q^3 -/
def upt (d : ℕ) : Pt := toPt (unit d)

theorem toPt_add (a b : V3) : toPt (a + b) = toPt a + toPt b := by
  ext i; fin_cases i <;> simp [toPt]

theorem toPt_zero : toPt 0 = 0 := by
  ext i; fin_cases i <;> simp [toPt]

theorem toPt_inj : Function.Injective toPt := by
  intro a b h
  have h0 := congrFun h 0
  have h1 := congrFun h 1
  have h2 := congrFun h 2
  simp [toPt] at h0 h1 h2
  cases a; cases b
  simp [h0, h1, h2]

theorem isLat_toPt (v : V3) : IsLat (toPt v) := by
  intro j; fin_cases j
  · exact ⟨v.x, by simp [toPt]⟩
  · exact ⟨v.y, by simp [toPt]⟩
  · exact ⟨v.z, by simp [toPt]⟩

theorem isLat_upt (d : ℕ) : IsLat (upt d) := isLat_toPt _

/-- the axis of a direction as an element of `Fin 3` -/
def ax (d : ℕ) : Fin 3 := ⟨d / 2 % 3, Nat.mod_lt _ (by norm_num)⟩

theorem upt_eq {d : ℕ} (hd : d < 6) :
    ∃ s : ℚ, (s = 1 ∨ s = -1) ∧ upt d = s • e3 (ax d) := by
  interval_cases d
  · exact ⟨1, Or.inl rfl, by ext i; fin_cases i <;> simp [upt, toPt, unit, ax, e3_apply]⟩
  · exact ⟨-1, Or.inr rfl, by ext i; fin_cases i <;> simp [upt, toPt, unit, ax, e3_apply]⟩
  · exact ⟨1, Or.inl rfl, by ext i; fin_cases i <;> simp [upt, toPt, unit, ax, e3_apply]⟩
  · exact ⟨-1, Or.inr rfl, by ext i; fin_cases i <;> simp [upt, toPt, unit, ax, e3_apply]⟩
  · exact ⟨1, Or.inl rfl, by ext i; fin_cases i <;> simp [upt, toPt, unit, ax, e3_apply]⟩
  · exact ⟨-1, Or.inr rfl, by ext i; fin_cases i <;> simp [upt, toPt, unit, ax, e3_apply]⟩

theorem ax_inj {a b : ℕ} (ha : a < 6) (hb : b < 6) (h : ax a = ax b) : a / 2 = b / 2 := by
  have : a / 2 % 3 = b / 2 % 3 := congrArg Fin.val h
  omega

theorem upt_rev {d : ℕ} (hd : d < 6) : upt (rev d) = - upt d := by
  interval_cases d <;> (ext i; fin_cases i <;> simp [upt, toPt, unit, rev])

theorem upt_ustep {d : ℕ} (hd : d < 6) (p : Pt) : UStep p (p + upt d) := by
  obtain ⟨s, hs, h⟩ := upt_eq hd
  exact ⟨ax d, s, hs, by rw [h]⟩

/-! ## Walks -/

/-- the n points `v, v + u_{w_0}, v + u_{w_0} + u_{w_1}, ...` (without the end point) -/
def ptwalk : Pt → List ℕ → List Pt
  | _, [] => []
  | v, d :: ds => v :: ptwalk (v + upt d) ds

/-- the displacement of the whole word -/
def usum (l : List ℕ) : Pt := (l.map upt).sum

/-- the polygon of a lattice word: the closed polygon with vertices v_0, ..., v_{n-1} -/
def wpoly (w : List ℕ) : List Pt := ptwalk 0 w

@[simp] theorem usum_nil : usum [] = 0 := by simp [usum]
@[simp] theorem usum_cons (d : ℕ) (l : List ℕ) : usum (d :: l) = upt d + usum l := by simp [usum]
theorem usum_append (l l' : List ℕ) : usum (l ++ l') = usum l + usum l' := by
  simp [usum, List.sum_append]

@[simp] theorem ptwalk_nil (v : Pt) : ptwalk v [] = [] := rfl
@[simp] theorem ptwalk_cons (v : Pt) (d : ℕ) (l : List ℕ) :
    ptwalk v (d :: l) = v :: ptwalk (v + upt d) l := rfl

theorem ptwalk_length (v : Pt) (l : List ℕ) : (ptwalk v l).length = l.length := by
  induction l generalizing v with
  | nil => simp
  | cons d l ih => simp [ih]

theorem ptwalk_append (v : Pt) (l l' : List ℕ) :
    ptwalk v (l ++ l') = ptwalk v l ++ ptwalk (v + usum l) l' := by
  induction l generalizing v with
  | nil => simp
  | cons d l ih => simp [ih, add_assoc]

theorem ptwalk_translate (v t : Pt) (l : List ℕ) :
    ptwalk (v + t) l = (ptwalk v l).map (· + t) := by
  induction l generalizing v with
  | nil => simp
  | cons d l ih =>
    simp only [ptwalk_cons, List.map_cons]
    rw [add_right_comm, ih]

theorem ptwalk_lat {v : Pt} (hv : IsLat v) (l : List ℕ) : ∀ x ∈ ptwalk v l, IsLat x := by
  induction l generalizing v with
  | nil => simp
  | cons d l ih =>
    intro x hx
    simp only [ptwalk_cons, List.mem_cons] at hx
    rcases hx with rfl | hx
    · exact hv
    · exact ih (isLat_add hv (isLat_upt d)) x hx

/-! ## Link with `IsPolygon` of Spec.lean -/

theorem vset_aux (v : V3) (w : List ℕ) :
    ((vertsFrom v w).take w.length).map toPt = ptwalk (toPt v) w := by
  induction w generalizing v with
  | nil => simp [vertsFrom]
  | cons d ds ih =>
    simp only [vertsFrom, List.length_cons, List.take_succ_cons, List.map_cons, ptwalk_cons]
    rw [ih, toPt_add]; rfl

theorem vset_map (w : List ℕ) : (vset w).map toPt = wpoly w := by
  unfold vset verts wpoly
  rw [vset_aux, toPt_zero]

theorem vtx_aux (v : V3) (w : List ℕ) (j : ℕ) (hj : j ≤ w.length) :
    toPt ((vertsFrom v w).getD j 0) = toPt v + usum (w.take j) := by
  induction w generalizing v j with
  | nil =>
    have : j = 0 := by simpa using hj
    subst this; simp [vertsFrom]
  | cons d ds ih =>
    cases j with
    | zero => simp [vertsFrom]
    | succ j =>
      simp only [vertsFrom, List.getD_cons_succ, List.take_succ_cons, usum_cons]
      rw [ih _ _ (by simpa using hj), toPt_add, add_assoc]

theorem toPt_vtx (w : List ℕ) (j : ℕ) (hj : j ≤ w.length) :
    toPt (vtx w j) = usum (w.take j) := by
  unfold vtx verts
  rw [vtx_aux _ _ _ hj, toPt_zero, zero_add]

theorem isPolygon_iff (w : List ℕ) :
    IsPolygon w ↔ 4 ≤ w.length ∧ (∀ d ∈ w, d < 6) ∧ usum w = 0 ∧ (wpoly w).Nodup := by
  unfold IsPolygon
  have h1 : vtx w w.length = 0 ↔ usum w = 0 := by
    have := toPt_vtx w w.length le_rfl
    rw [List.take_length] at this
    constructor
    · intro h; rw [← this, h, toPt_zero]
    · intro h; apply toPt_inj; rw [this, h, toPt_zero]
  have h2 : (vset w).Nodup ↔ (wpoly w).Nodup := by
    rw [← vset_map]
    exact ⟨fun h => h.map toPt_inj, fun h => List.Nodup.of_map _ h⟩
  rw [h1, h2]

/-! ## The polygon of a lattice word is a lattice polygon -/

theorem chain_ptwalk_unit (w : List ℕ) (hw : ∀ d ∈ w, d < 6) :
    ∀ (v : Pt) (e : Pt × Pt), e ∈ chain (ptwalk v w ++ [v + usum w]) → UStep e.1 e.2 := by
  induction w with
  | nil => intro v e he; simp [chain] at he
  | cons d ds ih =>
    intro v e he
    have hd : d < 6 := hw d (by simp)
    have hds : ∀ d' ∈ ds, d' < 6 := fun d' h => hw d' (by simp [h])
    cases ds with
    | nil =>
      simp [chain] at he
      subst he
      simpa using upt_ustep hd v
    | cons d' ds' =>
      have e1 : ptwalk v (d :: d' :: ds') ++ [v + usum (d :: d' :: ds')] =
          v :: (ptwalk (v + upt d) (d' :: ds') ++ [(v + upt d) + usum (d' :: ds')]) := by
        simp [add_assoc]
      rw [e1] at he
      have e2 : ptwalk (v + upt d) (d' :: ds') ++ [(v + upt d) + usum (d' :: ds')] =
          (v + upt d) :: (ptwalk (v + upt d + upt d') ds' ++ [(v + upt d + upt d') + usum ds']) := by
        simp [add_assoc]
      rw [e2] at he
      simp only [chain, List.mem_cons] at he
      rcases he with rfl | he
      · exact upt_ustep hd v
      · exact ih hds (v + upt d) e (by rw [e2]; exact he)

theorem edges_wpoly_unit {w : List ℕ} (hw : ∀ d ∈ w, d < 6) (hc : usum w = 0) (hne : w ≠ []) :
    ∀ e ∈ edges (wpoly w), UStep e.1 e.2 := by
  intro e he
  have h1 : (wpoly w).take 1 = [0] := by
    cases w with
    | nil => exact absurd rfl hne
    | cons d ds => simp [wpoly]
  unfold edges at he
  rw [h1] at he
  have h2 : (0 : Pt) = 0 + usum w := by rw [hc]; simp
  have := chain_ptwalk_unit w hw 0 e (by rw [← h2]; exact he)
  exact this

theorem latPoly_wpoly {w : List ℕ} (h : IsPolygon w) : LatPoly (wpoly w) := by
  rw [isPolygon_iff] at h
  obtain ⟨h4, hw, hc, hnd⟩ := h
  refine ⟨by unfold wpoly; rw [ptwalk_length]; exact h4, hnd,
    fun v hv => ptwalk_lat isLat_zero w v hv,
    edges_wpoly_unit hw hc (by intro h; simp [h] at h4)⟩

theorem simple_wpoly {w : List ℕ} (h : IsPolygon w) : Simple (wpoly w) :=
  latPoly_simple (latPoly_wpoly h)

/-! ## Lattice symmetries as linear maps -/

/-- the linear map of Q^3 that sends e_x, e_y, e_z to the unit vectors of directions f 0, f 2, f 4 -/
def symMat (f : ℕ → ℕ) (x : Pt) : Pt := x 0 • upt (f 0) + x 1 • upt (f 2) + x 2 • upt (f 4)

theorem IsSym.rev_eq {f : ℕ → ℕ} (hf : IsSym f) {d : ℕ} (hd : d < 6) : f (rev d) = rev (f d) :=
  hf.2.2 d hd

theorem symMat_upt {f : ℕ → ℕ} (hf : IsSym f) {d : ℕ} (hd : d < 6) :
    symMat f (upt d) = upt (f d) := by
  have h0 : (0 : ℕ) < 6 := by norm_num
  have h1 := hf.rev_eq (d := 0) (by norm_num)
  have h3 := hf.rev_eq (d := 2) (by norm_num)
  have h5 := hf.rev_eq (d := 4) (by norm_num)
  have r0 : upt (f 1) = - upt (f 0) := by
    have : f 1 = rev (f 0) := by simpa [rev] using h1
    rw [this, upt_rev (hf.1 0 (by norm_num))]
  have r2 : upt (f 3) = - upt (f 2) := by
    have : f 3 = rev (f 2) := by simpa [rev] using h3
    rw [this, upt_rev (hf.1 2 (by norm_num))]
  have r4 : upt (f 5) = - upt (f 4) := by
    have : f 5 = rev (f 4) := by simpa [rev] using h5
    rw [this, upt_rev (hf.1 4 (by norm_num))]
  interval_cases d <;> simp [symMat, upt, toPt, unit] <;> first | rfl | (simp [r0, r2, r4]) | skip

end Lean42
