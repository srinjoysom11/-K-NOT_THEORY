/-
  Lean42.Knot -- `KnotClass` as a theorem.

  Phase 2 of PLAN.md.  The 5_2 proof (research/exact/lean/Len52/Spec.lean) took the structure
  `KnotClass T` (rotation, reversal, lattice symmetries, corner flips and U-turn removals preserve
  the class `T` of words) as a hypothesis.  Here the class is *defined* from the polygon of a
  target knot and all six fields are proved.

  `KnotType P w`: the word `w` is a lattice polygon (`IsPolygon`) and the polygon of `w` is `Equiv`alent
  (Delta-moves, rotation, reversal, translation) to the image of the target polygon `P` under some
  lattice symmetry `symMat f`, `f` with `IsSym f`.

  Why the class is saturated under the 48 lattice symmetries (decision of this development).
  The class of the knot K and its mirror image is `{w : polygon of w ~ P_K or ~ mirror P_K}`.  For
  `KnotClass.sym` we need: if `w` is in the class then so is `w.map f`.  Since `w ~ P_K` gives
  `w.map f ~ σ(P_K)` (σ = `symMat f`; Delta-moves commute with injective linear maps, `Equiv.map`),
  this needs `σ(P_K) ~ P_K` or `~ mirror P_K`.  For a rotation σ by 90 degrees that is true (σ is
  isotopic to the identity) but its proof by Delta-moves needs a general-position argument
  (small steps, free thin triangles) that we do not carry out.  We avoid it: the class is the union
  of the classes of the 48 concrete polygons `σ(P_K)`.  It contains `P_K` (σ = id) and `mirror P_K`
  (σ = the symmetry z ↦ -z), so it is *larger* than "K or mirror K"; a theorem "no word of length
  ≤ n lies in the class" is therefore stronger than the same statement for K and its mirror image.
  Mathematically the two classes coincide (each σ(P_K) is K or its mirror image), but that is not
  used.  Later phases must therefore compute their invariants on the 48 images `σ(P_K)` of each
  target (a finite computation on concrete polygons) instead of invoking invariance under
  rotations.
-/
import Lean42.Flip

namespace Lean42
open Lean42.Spec

/-- the class of words whose polygon is equivalent to a lattice-symmetric image of `P` -/
def KnotType (P : List Pt) (w : List ℕ) : Prop :=
  IsPolygon w ∧ ∃ f, IsSym f ∧ Equiv (wpoly w) (P.map (symMat f))

/-! ## Decomposing words -/

theorem decomp2 (w : List ℕ) (i : ℕ) (h1 : 1 ≤ i) (h2 : i < w.length) :
    w = w.take (i - 1) ++ dir w (i - 1) :: dir w i :: w.drop (i + 1) ∧
      (w.take (i - 1)).length = i - 1 := by
  have hl : i - 1 < w.length := by omega
  refine ⟨?_, by simp; omega⟩
  have e : i - 1 + 1 = i := by omega
  conv_lhs => rw [← List.take_append_drop (i - 1) w]
  rw [List.drop_eq_getElem_cons hl, e, List.drop_eq_getElem_cons h2]
  simp [dir, List.getD_eq_getElem?_getD, hl, h2]

theorem decomp3 (w : List ℕ) (i : ℕ) (h : i + 3 ≤ w.length) :
    w = w.take i ++ dir w i :: dir w (i + 1) :: dir w (i + 2) :: w.drop (i + 3) ∧
      (w.take i).length = i := by
  refine ⟨?_, by simp; omega⟩
  conv_lhs => rw [← List.take_append_drop i w]
  rw [List.drop_eq_getElem_cons (by omega : i < w.length),
    List.drop_eq_getElem_cons (by omega : i + 1 < w.length),
    List.drop_eq_getElem_cons (by omega : i + 2 < w.length)]
  simp [dir, List.getD_eq_getElem?_getD, show i + 1 < w.length by omega, show i + 2 < w.length by omega,
    show i < w.length by omega]

theorem dir_split0 (pre : List ℕ) (a b : ℕ) (post : List ℕ) :
    dir (pre ++ a :: b :: post) pre.length = a := by
  induction pre with
  | nil => simp [dir]
  | cons x pre ih => simpa [dir] using ih

theorem dir_split1 (pre : List ℕ) (a b : ℕ) (post : List ℕ) :
    dir (pre ++ a :: b :: post) (pre.length + 1) = b := by
  induction pre with
  | nil => simp [dir]
  | cons x pre ih => simpa [dir] using ih

theorem swap_split (pre : List ℕ) (a b : ℕ) (post : List ℕ) :
    swapAt (pre ++ a :: b :: post) (pre.length + 1) = pre ++ b :: a :: post := by
  induction pre with
  | nil => simp [swapAt, dir]
  | cons x pre ih =>
    simp only [swapAt, dir, List.length_cons, List.cons_append, Nat.add_sub_cancel,
      List.getD_cons_succ, List.set_cons_succ] at ih ⊢
    rw [ih]

theorem axis_ne {a b : ℕ} (ha : a < 6) (hb : b < 6) (h : axis a ≠ axis b) : ax a ≠ ax b := by
  intro h'
  apply h
  have := ax_inj ha hb h'
  simpa [axis] using this

theorem mem_wpoly_iff (w : List ℕ) (x : V3) : toPt x ∈ wpoly w ↔ x ∈ vset w := by
  rw [← vset_map]
  exact List.mem_map_of_injective toPt_inj

/-! ## The six fields -/

theorem knotClass (P : List Pt) : KnotClass (KnotType P) where
  polygon := fun _ h => h.1
  rot := by
    rintro w ⟨hw, f, hf, hE⟩
    exact ⟨isPolygon_rotate1 hw, f, hf, (equiv_rotate1 hw).symm.trans hE⟩
  reverse := by
    rintro w ⟨hw, f, hf, hE⟩
    exact ⟨isPolygon_rev hw, f, hf, (equiv_rev hw).symm.trans hE⟩
  sym := by
    rintro f' w hf' ⟨hw, f, hf, hE⟩
    have hl := ((isPolygon_iff w).1 hw).2.1
    refine ⟨isPolygon_map hf' hw, f' ∘ f, hf.comp hf', ?_⟩
    rw [wpoly_map hf' w hl]
    have := Equiv.map (isAffInj_symMat hf') hE
    rw [List.map_map] at this
    have e : (symMat f' ∘ symMat f) = symMat (f' ∘ f) := by
      funext x; exact symMat_comp hf hf' x
    rw [e] at this
    exact this
  flip := by
    intro w i hT h1 h2 hax hD
    obtain ⟨hw, f, hf, hE⟩ := hT
    obtain ⟨hdec, hlen⟩ := decomp2 w i h1 h2
    have hi : i = (w.take (i - 1)).length + 1 := by omega
    have hl := ((isPolygon_iff w).1 hw).2.1
    set pre := w.take (i - 1) with hpre
    set post := w.drop (i + 1) with hpost
    set a := dir w (i - 1) with ha
    set b := dir w i with hb
    have ha6 : a < 6 := hl a (by rw [hdec]; simp)
    have hb6 : b < 6 := hl b (by rw [hdec]; simp)
    have hax' : ax a ≠ ax b := axis_ne ha6 hb6 hax
    have hD' : usum pre + upt b ∉ wpoly (pre ++ a :: b :: post) := by
      rw [← hdec]
      intro hmem
      have e : usum pre + upt b = toPt (vtx w (i - 1) + unit (dir w i)) := by
        rw [toPt_add, toPt_vtx w (i - 1) (by omega)]; rfl
      rw [e, mem_wpoly_iff] at hmem
      exact hD hmem
    have hsw : swapAt w i = pre ++ b :: a :: post := by
      have := swap_split pre a b post
      rw [← hi, ← hdec] at this
      exact this
    rw [hdec] at hw hE
    obtain ⟨hpoly, heq⟩ := flip_wpoly pre post a b hw hax' hD'
    rw [hsw]
    exact ⟨hpoly, f, hf, heq.symm.trans hE⟩
  uturn := by
    intro w i hT h6 h3 hax hrev
    obtain ⟨hw, f, hf, hE⟩ := hT
    obtain ⟨hdec, hlen⟩ := decomp3 w i h3
    have hl := ((isPolygon_iff w).1 hw).2.1
    set pre := w.take i with hpre
    set post := w.drop (i + 3) with hpost
    set a := dir w i with ha
    set b := dir w (i + 1) with hb
    have ha6 : a < 6 := hl a (by rw [hdec]; simp)
    have hb6 : b < 6 := hl b (by rw [hdec]; simp)
    have hax' : ax a ≠ ax b := axis_ne ha6 hb6 (Ne.symm hax)
    have hru : removeUturn w i = pre ++ b :: post := by
      simp [removeUturn, hpre, hpost, hb]
    rw [hrev] at hdec
    have hdec' : w = pre ++ a :: b :: rev a :: post := hdec
    rw [hdec'] at hw hE h6
    obtain ⟨hpoly, heq⟩ := uturn_wpoly pre post a b hw hax' h6
    rw [hru]
    exact ⟨hpoly, f, hf, heq.symm.trans hE⟩

/-! ## The class contains the target and its mirror image -/

theorem isSym_id : IsSym id := ⟨fun d hd => hd, fun _ _ _ _ h => h, fun _ _ => rfl⟩

theorem symMat_id (x : Pt) : symMat id x = x := by
  ext i; fin_cases i <;> simp [symMat, upt, toPt, unit]

/-- the symmetry `z ↦ -z` on direction codes: exchange u (4) and d (5) -/
def zflip (d : ℕ) : ℕ := if d = 4 then 5 else if d = 5 then 4 else d

theorem isSym_zflip : IsSym zflip := by
  refine ⟨fun d hd => ?_, fun a b ha hb h => ?_, fun d hd => ?_⟩
  · unfold zflip; split_ifs <;> omega
  · unfold zflip at h; split_ifs at h <;> omega
  · interval_cases d <;> simp [zflip, rev]

theorem symMat_zflip (x : Pt) : symMat zflip x = mirror x := by
  ext i; fin_cases i <;> simp [symMat, mirror, zflip, upt, toPt, unit]

/-- a polygon equivalent to `P` is in the class of `P` -/
theorem knotType_of_equiv {P : List Pt} {w : List ℕ} (hw : IsPolygon w)
    (h : Equiv (wpoly w) P) : KnotType P w := by
  refine ⟨hw, id, isSym_id, ?_⟩
  have e : P.map (symMat id) = P := by
    rw [List.map_congr_left (fun x _ => symMat_id x)]; exact List.map_id P
  rw [e]; exact h

/-- a polygon equivalent to the mirror image of `P` is in the class of `P` -/
theorem knotType_of_equiv_mirror {P : List Pt} {w : List ℕ} (hw : IsPolygon w)
    (h : Equiv (wpoly w) (P.map mirror)) : KnotType P w := by
  refine ⟨hw, zflip, isSym_zflip, ?_⟩
  have : P.map (symMat zflip) = P.map mirror := List.map_congr_left (fun x _ => symMat_zflip x)
  rw [this]; exact h

#print axioms knotClass

end Lean42
