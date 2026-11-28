/-
  Lean42.Moves -- the corner flip and the U-turn removal as Delta-moves.

  Phase 2 of research/exact/lean42/PLAN.md.

  Corner flip.  Let `A, B, C` be three consecutive vertices of a lattice polygon with `AB ⟂ BC`; the
  unit lattice square has the fourth corner `D = A + (C - B)`.  If `D` is not a vertex, the flip
  replaces `A B C` by `A D C`.  Two Delta-moves do it:
     1. `A B C … → A C …`: remove `B` (inverse of the Delta-move with apex `B` over the edge `AC`),
        free triangle `ACB`, half of the square;
     2. `A C … → A D C …`: Delta-move with apex `D` over the edge `AC`, free triangle `ACD`, the
        other half of the square.
  The triangles are free because the other edges of the polygon (`T`, below) are unit lattice
  edges that do not end in `B` or `D`; by `free_flip` they meet the square only in `A` or `C`,
  which are endpoints of the edge `AC`.  Also the new polygons are simple: `AC` meets `T` only in
  `A`, `C`, and `AD`, `DC` meet each other only in `D` (`AD_DC_inter`) and meet `T` only in `A`, `C`.

  U-turn.  `A B C D` consecutive vertices with `D = A + (C - B)` (the polygon goes round three sides
  of the square).  Two Delta-moves remove `B` and `C`:  `A B C D … → A C D … → A D …`; the free
  triangles are `ACB` and `ADC`.  Here `T` (the rest of the polygon) avoids `B`, `C` and, since the
  polygon has at least 5 vertices, does not contain the side `DA` (`free_uturn`).
-/
import Lean42.Square

namespace Lean42

theorem PairOK.symm {e e' : Pt × Pt} (h : PairOK e e') : PairOK e' e :=
  fun x h1 h2 => ⟨(h x h2 h1).2, (h x h2 h1).1⟩

theorem flip_equiv {F : Frame} (hF : F.Ok) {R : List Pt}
    (hP : LatPoly (F.A :: F.B :: F.C :: R)) (hD : F.D ∉ F.A :: F.B :: F.C :: R) :
    Equiv (F.A :: F.B :: F.C :: R) (F.A :: F.D :: F.C :: R) := by
  have hPs := latPoly_simple hP
  obtain ⟨h4, hnd, hlat, hunit⟩ := hP
  have hE : edges (F.A :: F.B :: F.C :: R) =
      (F.A, F.B) :: (F.B, F.C) :: chain (F.C :: (R ++ [F.A])) := by
    simp [edges_cons_cons, chain]
  set T := chain (F.C :: (R ++ [F.A])) with hT
  have hTP : ∀ e ∈ T, e ∈ edges (F.A :: F.B :: F.C :: R) := fun e he => by
    rw [hE]; simp [he]
  have hnd' := hnd
  simp only [List.nodup_cons, List.mem_cons, not_or] at hnd'
  obtain ⟨⟨hAB, hAC, hAR⟩, ⟨hBC, hBR⟩, hCR, hRnd⟩ := hnd'
  simp only [List.mem_cons, not_or] at hD
  obtain ⟨hDA, hDB, hDC, hDR⟩ := hD
  have hBn : F.B ∉ F.C :: (R ++ [F.A]) := by
    simp only [List.mem_cons, List.mem_append, List.mem_singleton, not_or]
    exact ⟨hBC, hBR, fun h => hAB h.symm⟩
  have hDn : F.D ∉ F.C :: (R ++ [F.A]) := by
    simp only [List.mem_cons, List.mem_append, List.mem_singleton, not_or]
    exact ⟨hDC, hDR, hDA⟩
  have hTfree : ∀ e ∈ T, ∀ x, x ∈ seg e.1 e.2 → x ∈ F.Sq →
      (x = F.A ∨ x = F.C) ∧ (x = e.1 ∨ x = e.2) := by
    intro e he x hx hS
    have hm := chain_mem _ he
    exact free_flip hF (hunit e (hTP e he)) (hlat _ (mem_edges_fst (hTP e he)))
      (fun h => hBn (h ▸ hm.1)) (fun h => hDn (h ▸ hm.1))
      (fun h => hBn (h ▸ hm.2)) (fun h => hDn (h ▸ hm.2)) hx hS
  -- the polygon with B removed
  have hE1 : edges (F.A :: F.C :: R) = (F.A, F.C) :: T := by
    simp [edges_cons_cons, hT]
  have hAC_T : ∀ e ∈ T, PairOK (F.A, F.C) e := by
    intro e he x hx hx'
    have h := hTfree e he x hx' (seg_AC_sub F hx)
    exact ⟨h.1, h.2⟩
  have hQ1 : Simple (F.A :: F.C :: R) := by
    refine ⟨?_, ?_, ?_⟩
    · simp at h4 ⊢; omega
    · simp only [List.nodup_cons, List.mem_cons, not_or]
      exact ⟨⟨hAC, hAR⟩, hCR, hRnd⟩
    · rw [hE1]
      intro e he e' he' hne
      simp only [List.mem_cons] at he he'
      rcases he with rfl | he <;> rcases he' with rfl | he'
      · exact absurd rfl hne
      · exact hAC_T e' he'
      · exact (hAC_T e he).symm
      · exact hPs.2.2 e (hTP e he) e' (hTP e' he') hne
  -- step 1
  have d1 : DeltaMove (F.A :: F.C :: R) (F.A :: F.B :: F.C :: R) := by
    refine deltaMove_mk hQ1 hPs ?_
    intro x hx hxp
    obtain ⟨e, he, hxe⟩ := hxp
    rw [hE1] at he
    simp only [List.mem_cons] at he
    rcases he with rfl | he
    · exact hxe
    · have h := hTfree e he x hxe (tri_ACB_sub F hx)
      rcases h.1 with rfl | rfl
      · exact left_mem_seg _ _
      · exact right_mem_seg _ _
  -- the polygon with D inserted
  have hE2 : edges (F.A :: F.D :: F.C :: R) = (F.A, F.D) :: (F.D, F.C) :: T := by
    simp [edges_cons_cons, chain, hT]
  have hAD_T : ∀ e ∈ T, PairOK (F.A, F.D) e := by
    intro e he x hx hx'
    have h := hTfree e he x hx' (seg_AD_sub F hx)
    refine ⟨?_, h.2⟩
    rcases h.1 with h1 | h1
    · exact Or.inl h1
    · exfalso; exact C_notin_AD hF (h1 ▸ hx)
  have hDC_T : ∀ e ∈ T, PairOK (F.D, F.C) e := by
    intro e he x hx hx'
    have h := hTfree e he x hx' (seg_DC_sub F hx)
    refine ⟨?_, h.2⟩
    rcases h.1 with h1 | h1
    · exfalso; exact A_notin_DC hF (h1 ▸ hx)
    · exact Or.inr h1
  have hAD_DC : PairOK (F.A, F.D) (F.D, F.C) := by
    intro x hx hx'
    have := AD_DC_inter hF hx hx'
    exact ⟨Or.inr this, Or.inl this⟩
  have hQ2 : Simple (F.A :: F.D :: F.C :: R) := by
    refine ⟨?_, ?_, ?_⟩
    · simp at h4 ⊢; omega
    · simp only [List.nodup_cons, List.mem_cons, not_or]
      exact ⟨⟨Ne.symm hDA, hAC, hAR⟩, ⟨hDC, hDR⟩, hCR, hRnd⟩
    · rw [hE2]
      intro e he e' he' hne
      simp only [List.mem_cons] at he he'
      rcases he with rfl | rfl | he <;> rcases he' with rfl | rfl | he'
      · exact absurd rfl hne
      · exact hAD_DC
      · exact hAD_T e' he'
      · exact hAD_DC.symm
      · exact absurd rfl hne
      · exact hDC_T e' he'
      · exact (hAD_T e he).symm
      · exact (hDC_T e he).symm
      · exact hPs.2.2 e (hTP e he) e' (hTP e' he') hne
  have d2 : DeltaMove (F.A :: F.C :: R) (F.A :: F.D :: F.C :: R) := by
    refine deltaMove_mk hQ1 hQ2 ?_
    intro x hx hxp
    obtain ⟨e, he, hxe⟩ := hxp
    rw [hE1] at he
    simp only [List.mem_cons] at he
    rcases he with rfl | he
    · exact hxe
    · have h := hTfree e he x hxe (tri_ACD_sub F hx)
      rcases h.1 with rfl | rfl
      · exact left_mem_seg _ _
      · exact right_mem_seg _ _
  exact (Equiv.of_delta d1).symm.trans (Equiv.of_delta d2)

theorem uturn_equiv {F : Frame} (hF : F.Ok) {R : List Pt} (hR : R ≠ [])
    (hP : LatPoly (F.A :: F.B :: F.C :: F.D :: R)) :
    Equiv (F.A :: F.B :: F.C :: F.D :: R) (F.A :: F.D :: R) := by
  obtain ⟨r0, R', rfl⟩ := List.exists_cons_of_ne_nil hR
  have hPs := latPoly_simple hP
  obtain ⟨h4, hnd, hlat, hunit⟩ := hP
  have hE : edges (F.A :: F.B :: F.C :: F.D :: r0 :: R') =
      (F.A, F.B) :: (F.B, F.C) :: (F.C, F.D) :: chain (F.D :: (r0 :: R' ++ [F.A])) := by
    simp [edges_cons_cons, chain]
  set T := chain (F.D :: (r0 :: R' ++ [F.A])) with hT
  have hTP : ∀ e ∈ T, e ∈ edges (F.A :: F.B :: F.C :: F.D :: r0 :: R') := fun e he => by
    rw [hE]; simp [he]
  have hnd' := hnd
  simp only [List.nodup_cons, List.mem_cons, not_or] at hnd'
  obtain ⟨⟨hAB, hAC, hAD, hAr, hAR⟩, ⟨hBC, hBD, hBr, hBR⟩, ⟨hCD, hCr, hCR⟩, ⟨hDr, hDR⟩,
    hrR, hRnd⟩ := hnd'
  have hT1 : ∀ e ∈ T, e.1 ∈ F.D :: r0 :: R' ∧ e.2 ∈ r0 :: R' ++ [F.A] := by
    intro e he
    have h1 : e.1 ∈ (T.map Prod.fst) := List.mem_map_of_mem he
    have h2 : e.2 ∈ (T.map Prod.snd) := List.mem_map_of_mem he
    rw [hT, chain_fst] at h1
    rw [hT, chain_snd] at h2
    refine ⟨?_, by simpa using h2⟩
    have : (F.D :: (r0 :: R' ++ [F.A])).dropLast = F.D :: r0 :: R' := by
      simp [List.dropLast_cons_of_ne_nil]
    rw [this] at h1; exact h1
  have hBn1 : F.B ∉ F.D :: r0 :: R' := by
    simp only [List.mem_cons, not_or]; exact ⟨hBD, hBr, hBR⟩
  have hCn1 : F.C ∉ F.D :: r0 :: R' := by
    simp only [List.mem_cons, not_or]; exact ⟨hCD, hCr, hCR⟩
  have hBn2 : F.B ∉ r0 :: R' ++ [F.A] := by
    simp only [List.mem_cons, List.mem_append, List.mem_singleton, not_or]
    exact ⟨hBr, hBR, fun h => hAB h.symm⟩
  have hCn2 : F.C ∉ r0 :: R' ++ [F.A] := by
    simp only [List.mem_cons, List.mem_append, List.mem_singleton, not_or]
    exact ⟨hCr, hCR, fun h => hAC h.symm⟩
  have hAn1 : F.A ∉ F.D :: r0 :: R' := by
    simp only [List.mem_cons, not_or]; exact ⟨hAD, hAr, hAR⟩
  have hT5 : ∀ e ∈ T, ¬ (e.1 = F.D ∧ e.2 = F.A) := by
    intro e he ⟨h1, h2⟩
    have hT' : T = (F.D, r0) :: chain (r0 :: (R' ++ [F.A])) := by simp [hT, chain]
    rw [hT'] at he
    simp only [List.mem_cons] at he
    rcases he with rfl | he
    · exact hAr (by simpa using h2.symm)
    · have h1' : e.1 ∈ (chain (r0 :: (R' ++ [F.A]))).map Prod.fst := List.mem_map_of_mem he
      rw [chain_fst] at h1'
      have : (r0 :: (R' ++ [F.A])).dropLast = r0 :: R' := by
        simp [List.dropLast_cons_of_ne_nil]
      rw [this, h1] at h1'
      simp only [List.mem_cons] at h1'
      rcases h1' with h | h
      · exact hDr h
      · exact hDR h
  have hTfree : ∀ e ∈ T, ∀ x, x ∈ seg e.1 e.2 → x ∈ F.Sq →
      (x = F.A ∨ x = F.D) ∧ (x = e.1 ∨ x = e.2) := by
    intro e he x hx hS
    have hm := hT1 e he
    exact free_uturn hF (hunit e (hTP e he)) (hlat _ (mem_edges_fst (hTP e he)))
      (fun h => hBn1 (h ▸ hm.1)) (fun h => hCn1 (h ▸ hm.1))
      (fun h => hBn2 (h ▸ hm.2)) (fun h => hCn2 (h ▸ hm.2))
      (hT5 e he) (fun ⟨h1, _⟩ => hAn1 (h1 ▸ hm.1)) hx hS
  -- Q1 = A C D R
  have hE1 : edges (F.A :: F.C :: F.D :: r0 :: R') = (F.A, F.C) :: (F.C, F.D) :: T := by
    simp [edges_cons_cons, chain, hT]
  have hAC_T : ∀ e ∈ T, PairOK (F.A, F.C) e := by
    intro e he x hx hx'
    have h := hTfree e he x hx' (seg_AC_sub F hx)
    refine ⟨?_, h.2⟩
    rcases h.1 with h1 | h1
    · exact Or.inl h1
    · exfalso; exact D_notin_AC hF (h1 ▸ hx)
  have hCD_T : ∀ e ∈ T, PairOK (F.C, F.D) e := by
    intro e he x hx hx'
    have h := hTfree e he x hx' (seg_CD_sub F hx)
    refine ⟨?_, h.2⟩
    rcases h.1 with h1 | h1
    · exfalso; exact A_notin_CD hF (h1 ▸ hx)
    · exact Or.inr h1
  have hAC_CD : PairOK (F.A, F.C) (F.C, F.D) := by
    intro x hx hx'
    have := AC_CD_inter hF hx hx'
    exact ⟨Or.inr this, Or.inl this⟩
  have hQ1 : Simple (F.A :: F.C :: F.D :: r0 :: R') := by
    refine ⟨?_, ?_, ?_⟩
    · simp
    · simp only [List.nodup_cons, List.mem_cons, not_or]
      exact ⟨⟨hAC, hAD, hAr, hAR⟩, ⟨hCD, hCr, hCR⟩, ⟨hDr, hDR⟩, hrR, hRnd⟩
    · rw [hE1]
      intro e he e' he' hne
      simp only [List.mem_cons] at he he'
      rcases he with rfl | rfl | he <;> rcases he' with rfl | rfl | he'
      · exact absurd rfl hne
      · exact hAC_CD
      · exact hAC_T e' he'
      · exact hAC_CD.symm
      · exact absurd rfl hne
      · exact hCD_T e' he'
      · exact (hAC_T e he).symm
      · exact (hCD_T e he).symm
      · exact hPs.2.2 e (hTP e he) e' (hTP e' he') hne
  -- step 1: remove B
  have d1 : DeltaMove (F.A :: F.C :: F.D :: r0 :: R') (F.A :: F.B :: F.C :: F.D :: r0 :: R') := by
    refine deltaMove_mk hQ1 hPs ?_
    intro x hx hxp
    obtain ⟨e, he, hxe⟩ := hxp
    rw [hE1] at he
    simp only [List.mem_cons] at he
    rcases he with rfl | rfl | he
    · exact hxe
    · exact (triACB_CD_inter hF hx hxe) ▸ right_mem_seg _ _
    · have h := hTfree e he x hxe (tri_ACB_sub F hx)
      rcases h.1 with rfl | rfl
      · exact left_mem_seg _ _
      · exfalso; rw [tri_swap_bc] at hx; exact D_notin_triABC hF hx
  -- Q2 = A D R
  have hE2 : edges (F.A :: F.D :: r0 :: R') = (F.A, F.D) :: T := by
    simp [edges_cons_cons, hT]
  have hAD_T : ∀ e ∈ T, PairOK (F.A, F.D) e := by
    intro e he x hx hx'
    have h := hTfree e he x hx' (seg_AD_sub F hx)
    exact ⟨h.1, h.2⟩
  have hQ2 : Simple (F.A :: F.D :: r0 :: R') := by
    refine ⟨?_, ?_, ?_⟩
    · simp
    · simp only [List.nodup_cons, List.mem_cons, not_or]
      exact ⟨⟨hAD, hAr, hAR⟩, ⟨hDr, hDR⟩, hrR, hRnd⟩
    · rw [hE2]
      intro e he e' he' hne
      simp only [List.mem_cons] at he he'
      rcases he with rfl | he <;> rcases he' with rfl | he'
      · exact absurd rfl hne
      · exact hAD_T e' he'
      · exact (hAD_T e he).symm
      · exact hPs.2.2 e (hTP e he) e' (hTP e' he') hne
  have d2 : DeltaMove (F.A :: F.D :: r0 :: R') (F.A :: F.C :: F.D :: r0 :: R') := by
    refine deltaMove_mk hQ2 hQ1 ?_
    intro x hx hxp
    obtain ⟨e, he, hxe⟩ := hxp
    rw [hE2] at he
    simp only [List.mem_cons] at he
    rcases he with rfl | he
    · exact hxe
    · have h := hTfree e he x hxe (tri_ADC_sub F hx)
      rcases h.1 with rfl | rfl
      · exact left_mem_seg _ _
      · exact right_mem_seg _ _
  exact (Equiv.of_delta d1).symm.trans ((Equiv.of_delta d2).symm)

end Lean42
