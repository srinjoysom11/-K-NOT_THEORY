/-
  Lean42.Ops -- the word operations of `KnotClass` on polygons.

  Phase 2 of PLAN.md.  For each operation of Spec.lean (`rotate1`, `revWord`, `w.map f`, `swapAt`,
  `removeUturn`) we compute the polygon of the new word from the polygon of the old word, show that
  the new word is again a `IsPolygon`, and show that the two polygons are `Equiv`alent
  (rotation and reversal and translation for the first two, an injective linear map for the third,
  the Delta-moves of `Lean42.Moves` for the last two).
-/
import Lean42.Words
import Lean42.Moves

namespace Lean42
open Lean42.Spec

/-! ## Lattice symmetries -/

theorem symMat_add (f : ℕ → ℕ) (x y : Pt) : symMat f (x + y) = symMat f x + symMat f y := by
  simp only [symMat, Pi.add_apply, add_smul]; abel

theorem symMat_smul (f : ℕ → ℕ) (c : ℚ) (x : Pt) : symMat f (c • x) = c • symMat f x := by
  simp only [symMat, Pi.smul_apply, smul_eq_mul, smul_add, smul_smul]

theorem symMat_zero (f : ℕ → ℕ) : symMat f 0 = 0 := by simp [symMat]

theorem ax_ne_of_sym {f : ℕ → ℕ} (hf : IsSym f) {i j : ℕ} (hi : i < 6) (hj : j < 6)
    (hij : i / 2 ≠ j / 2) : ax (f i) ≠ ax (f j) := by
  intro h
  have h1 := ax_inj (hf.1 i hi) (hf.1 j hj) h
  have h2 : f j = f i ∨ f j = rev (f i) := by
    have := hf.1 i hi
    have := hf.1 j hj
    unfold rev; split_ifs <;> omega
  rcases h2 with h2 | h2
  · exact hij (by rw [hf.2.1 j i hj hi h2])
  · rw [← hf.rev_eq hi] at h2
    have h3 := hf.2.1 j (rev i) hj (by unfold rev; split_ifs <;> omega) h2
    apply hij
    rw [h3]; unfold rev; split_ifs <;> omega

theorem isAffInj_symMat {f : ℕ → ℕ} (hf : IsSym f) : IsAffInj (symMat f) := by
  refine ⟨{ toFun := symMat f, map_add' := symMat_add f, map_smul' := symMat_smul f }, 0, ?_, ?_⟩
  · obtain ⟨sa, hsa, ea⟩ := upt_eq (hf.1 0 (by norm_num))
    obtain ⟨sb, hsb, eb⟩ := upt_eq (hf.1 2 (by norm_num))
    obtain ⟨sc, hsc, ec⟩ := upt_eq (hf.1 4 (by norm_num))
    have nab : ax (f 0) ≠ ax (f 2) := ax_ne_of_sym hf (by norm_num) (by norm_num) (by norm_num)
    have nac : ax (f 0) ≠ ax (f 4) := ax_ne_of_sym hf (by norm_num) (by norm_num) (by norm_num)
    have nbc : ax (f 2) ≠ ax (f 4) := ax_ne_of_sym hf (by norm_num) (by norm_num) (by norm_num)
    have key : ∀ x : Pt, x 0 = (symMat f x (ax (f 0))) * sa ∧
        x 1 = (symMat f x (ax (f 2))) * sb ∧ x 2 = (symMat f x (ax (f 4))) * sc := by
      intro x
      simp only [symMat, ea, eb, ec, Pi.add_apply, Pi.smul_apply, smul_eq_mul, e3_apply]
      simp [nab, nac, nbc, nab.symm, nac.symm, nbc.symm]
      rcases hsa with rfl | rfl <;> rcases hsb with rfl | rfl <;> rcases hsc with rfl | rfl <;>
        simp
    intro x y hxy
    have hxy' : symMat f x = symMat f y := hxy
    ext i
    fin_cases i
    · have a := (key x).1; have b := (key y).1; simp only [hxy'] at a; simpa [a] using b.symm ▸ a
    · have a := (key x).2.1; have b := (key y).2.1; simp only [hxy'] at a; simpa [a] using b.symm ▸ a
    · have a := (key x).2.2; have b := (key y).2.2; simp only [hxy'] at a; simpa [a] using b.symm ▸ a
  · intro x; simp

theorem IsSym.comp {f g : ℕ → ℕ} (hf : IsSym f) (hg : IsSym g) : IsSym (g ∘ f) := by
  refine ⟨fun d hd => hg.1 _ (hf.1 d hd), fun a b ha hb h => hf.2.1 a b ha hb
    (hg.2.1 _ _ (hf.1 a ha) (hf.1 b hb) h), fun d hd => ?_⟩
  simp only [Function.comp]
  rw [hf.rev_eq hd, hg.rev_eq (hf.1 d hd)]

theorem symMat_comp {f g : ℕ → ℕ} (hf : IsSym f) (hg : IsSym g) (x : Pt) :
    symMat g (symMat f x) = symMat (g ∘ f) x := by
  conv_lhs => rw [show symMat f x = x 0 • upt (f 0) + x 1 • upt (f 2) + x 2 • upt (f 4) from rfl]
  rw [symMat_add, symMat_add, symMat_smul, symMat_smul, symMat_smul,
    symMat_upt hg (hf.1 0 (by norm_num)), symMat_upt hg (hf.1 2 (by norm_num)),
    symMat_upt hg (hf.1 4 (by norm_num))]
  rfl

theorem isLat_usum (l : List ℕ) : IsLat (usum l) := by
  induction l with
  | nil => simpa using isLat_zero
  | cons d l ih => simpa using isLat_add (isLat_upt d) ih

theorem usum_map {f : ℕ → ℕ} (hf : IsSym f) (w : List ℕ) (hw : ∀ d ∈ w, d < 6) :
    usum (w.map f) = symMat f (usum w) := by
  induction w with
  | nil => simp [symMat_zero]
  | cons d w ih =>
    simp only [List.map_cons, usum_cons, symMat_add]
    rw [symMat_upt hf (hw d (by simp)), ih (fun d' h => hw d' (by simp [h]))]

theorem ptwalk_map {f : ℕ → ℕ} (hf : IsSym f) (w : List ℕ) (hw : ∀ d ∈ w, d < 6) (v : Pt) :
    ptwalk (symMat f v) (w.map f) = (ptwalk v w).map (symMat f) := by
  induction w generalizing v with
  | nil => simp
  | cons d w ih =>
    simp only [List.map_cons, ptwalk_cons]
    rw [← symMat_upt hf (hw d (by simp)), ← symMat_add,
      ih (fun d' h => hw d' (by simp [h]))]

theorem wpoly_map {f : ℕ → ℕ} (hf : IsSym f) (w : List ℕ) (hw : ∀ d ∈ w, d < 6) :
    wpoly (w.map f) = (wpoly w).map (symMat f) := by
  unfold wpoly
  rw [← ptwalk_map hf w hw 0, symMat_zero]

theorem isPolygon_map {f : ℕ → ℕ} (hf : IsSym f) {w : List ℕ} (h : IsPolygon w) :
    IsPolygon (w.map f) := by
  have hw := h
  rw [isPolygon_iff] at h ⊢
  obtain ⟨h4, hl, hc, hnd⟩ := h
  refine ⟨by simpa using h4, ?_, ?_, ?_⟩
  · intro d hd
    obtain ⟨d', hd', rfl⟩ := List.mem_map.1 hd
    exact hf.1 d' (hl d' hd')
  · rw [usum_map hf w hl, hc, symMat_zero]
  · rw [wpoly_map hf w hl]
    exact hnd.map (isAffInj_symMat hf).injective

/-! ## Rotation -/

theorem wpoly_rotate1 (d : ℕ) (ds : List ℕ) (hc : usum (d :: ds) = 0) :
    wpoly (rotate1 (d :: ds)) = ((wpoly (d :: ds)).rotate 1).map (· + -upt d) := by
  have h1 : usum ds = -upt d := by
    rw [usum_cons] at hc
    exact eq_neg_of_add_eq_zero_right hc
  have h2 : wpoly (ds ++ [d]) = (ptwalk (upt d) ds).map (· + -upt d) ++ [-upt d] := by
    unfold wpoly
    rw [ptwalk_append, h1]
    have : (0 : Pt) = upt d + -upt d := by simp
    simp only [ptwalk_cons, ptwalk_nil, zero_add]
    rw [this, ptwalk_translate]
    simp
  have h3 : wpoly (d :: ds) = 0 :: ptwalk (upt d) ds := by simp [wpoly]
  simp only [rotate1]
  rw [h2, h3]
  simp [List.rotate_cons_succ]

theorem isPolygon_rotate1 {w : List ℕ} (h : IsPolygon w) : IsPolygon (rotate1 w) := by
  have hw := h
  rw [isPolygon_iff] at h ⊢
  obtain ⟨h4, hl, hc, hnd⟩ := h
  cases w with
  | nil => simp at h4
  | cons d ds =>
    simp only [rotate1]
    refine ⟨by simpa using h4, ?_, ?_, ?_⟩
    · intro d' hd'
      simp only [List.mem_append, List.mem_singleton] at hd'
      rcases hd' with h' | h'
      · exact hl d' (by simp [h'])
      · exact h' ▸ hl d (by simp)
    · rw [usum_append, usum_cons] at *
      simpa [add_comm] using hc
    · have := wpoly_rotate1 d ds hc
      simp only [rotate1] at this
      rw [this]
      exact ((List.nodup_rotate).2 hnd).map (add_left_injective _)

theorem equiv_rotate1 {w : List ℕ} (h : IsPolygon w) : Equiv (wpoly w) (wpoly (rotate1 w)) := by
  have hw := h
  rw [isPolygon_iff] at h
  obtain ⟨h4, hl, hc, hnd⟩ := h
  cases w with
  | nil => simp at h4
  | cons d ds =>
    rw [wpoly_rotate1 d ds hc]
    exact (Equiv.of_step (Step.rot _)).trans (Equiv.translate _ _)

/-! ## Reversal -/

/-- all `n + 1` points of the closed walk, including the end point -/
def pfull (v : Pt) (l : List ℕ) : List Pt := ptwalk v l ++ [v + usum l]

theorem pfull_cons (v : Pt) (d : ℕ) (l : List ℕ) :
    pfull v (d :: l) = v :: pfull (v + upt d) l := by
  simp [pfull, add_assoc]

theorem pfull_append_single (s : Pt) (l : List ℕ) (z : ℕ) :
    pfull s (l ++ [z]) = pfull s l ++ [s + usum l + upt z] := by
  simp [pfull, ptwalk_append, usum_append, add_assoc]

theorem revWord_snoc (l : List ℕ) (z : ℕ) : revWord (l ++ [z]) = rev z :: revWord l := by
  simp [revWord, List.reverse_append]

theorem pfull_rev (w : List ℕ) (hw : ∀ d ∈ w, d < 6) (v : Pt) :
    pfull v (revWord w) = (pfull (v - usum w) w).reverse := by
  induction w using List.reverseRecOn generalizing v with
  | nil => simp [revWord, pfull]
  | append_singleton l z ih =>
    have hz : z < 6 := hw z (by simp)
    have hl : ∀ d ∈ l, d < 6 := fun d h => hw d (by simp [h])
    rw [revWord_snoc, pfull_cons, upt_rev hz, ← sub_eq_add_neg, ih hl, pfull_append_single,
      usum_append]
    have e1 : v - upt z - usum l = v - (usum l + upt z) := by abel
    have e2 : v - (usum l + upt z) + usum l + upt z = v := by abel
    simp only [usum_cons, usum_nil, add_zero]
    rw [e1, e2, List.reverse_append]
    simp

theorem usum_rev (w : List ℕ) (hw : ∀ d ∈ w, d < 6) : usum (revWord w) = - usum w := by
  induction w using List.reverseRecOn with
  | nil => simp [revWord]
  | append_singleton l z ih =>
    have hz : z < 6 := hw z (by simp)
    have hl : ∀ d ∈ l, d < 6 := fun d h => hw d (by simp [h])
    rw [revWord_snoc, usum_cons, upt_rev hz, ih hl, usum_append]
    simp only [usum_cons, usum_nil, add_zero]
    abel

theorem wpoly_rev {w : List ℕ} (hw : ∀ d ∈ w, d < 6) (hc : usum w = 0) (d : ℕ) (ds : List ℕ)
    (hdd : w = d :: ds) :
    wpoly (revWord w) = (wpoly w).reverse.rotate (w.length - 1) := by
  have h1 : wpoly (revWord w) = ((pfull 0 w).reverse).dropLast := by
    have := pfull_rev w hw 0
    rw [hc, sub_zero] at this
    unfold wpoly
    rw [← this]
    simp [pfull, hc, usum_rev w hw]
  have h2 : pfull 0 w = wpoly w ++ [0] := by simp [pfull, wpoly, hc]
  have h3 : wpoly w = 0 :: ptwalk (upt d) ds := by simp [wpoly, hdd]
  rw [h1, h2, h3, hdd]
  simp only [List.reverse_append, List.reverse_cons, List.reverse_singleton, List.singleton_append,
    List.cons_append, List.length_cons, Nat.add_sub_cancel]
  rw [List.dropLast_cons_of_ne_nil (by simp)]
  rw [List.dropLast_concat]
  have : (ptwalk (upt d) ds).reverse.length = ds.length := by simp [ptwalk_length]
  rw [← this, List.rotate_append_length_eq]
  simp

theorem isPolygon_rev {w : List ℕ} (h : IsPolygon w) : IsPolygon (revWord w) := by
  have hw := h
  rw [isPolygon_iff] at h
  obtain ⟨h4, hl, hc, hnd⟩ := h
  obtain ⟨d, ds, hdd⟩ : ∃ d ds, w = d :: ds := by
    cases w with
    | nil => simp at h4
    | cons d ds => exact ⟨d, ds, rfl⟩
  rw [isPolygon_iff]
  refine ⟨by simpa [revWord] using h4, ?_, ?_, ?_⟩
  · intro x hx
    simp only [revWord, List.mem_reverse, List.mem_map] at hx
    obtain ⟨d', hd', rfl⟩ := hx
    have := hl d' hd'
    unfold rev; split_ifs <;> omega
  · rw [usum_rev w hl, hc]; simp
  · rw [wpoly_rev hl hc d ds hdd]
    exact ((List.nodup_reverse).2 hnd |> (List.nodup_rotate).2)

theorem equiv_rev {w : List ℕ} (h : IsPolygon w) : Equiv (wpoly w) (wpoly (revWord w)) := by
  have hw := h
  rw [isPolygon_iff] at h
  obtain ⟨h4, hl, hc, hnd⟩ := h
  obtain ⟨d, ds, hdd⟩ : ∃ d ds, w = d :: ds := by
    cases w with
    | nil => simp at h4
    | cons d ds => exact ⟨d, ds, rfl⟩
  rw [wpoly_rev hl hc d ds hdd]
  exact (Equiv.reverse _).trans (Equiv.rotate _ _)

end Lean42
