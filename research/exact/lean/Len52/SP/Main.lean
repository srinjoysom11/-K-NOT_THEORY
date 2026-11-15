/-
  Len52.SP.Main — the induction over the depth-first search.
-/
import Len52.SP.Leaf
import Len52.SP.Code

namespace Len52.SP
open Len52 Len52.Search

/-- the arguments of `dfs` at prefix length i along w -/
def Canon (w : List Nat) (i : Nat) (occ : Array Bool) (revPos revDirs : List Nat) (last first : Axes)
    (c : Cnt) (pend : List Ob) : Prop :=
  occ.size = NS ∧ OccOK w occ i ∧ revPos = rpos (P w) i ∧ revDirs = (w.take i).reverse ∧
    last = axesOf (lastAx w i) ∧ first = axesOf (firstAx w i) ∧ c = cntOf w i ∧
    ∀ ob ∈ pend, Gd w (i + 1) ob

theorem first_none {w : List Nat} (h6 : ∀ d ∈ w, d < 6) (i : Nat)
    (h : (axesOf (firstAx w i)).get (axis (dir w i)) = none) :
    (axesOf (firstAx w i)).set (axis (dir w i)) (some (i, dir w i)) = axesOf (firstAx w (i + 1)) := by
  have := axesOf_set_first h6 i
  rw [h] at this
  exact this

theorem first_some {w : List Nat} (h6 : ∀ d ∈ w, d < 6) (i : Nat) {p : Nat × Nat}
    (h : (axesOf (firstAx w i)).get (axis (dir w i)) = some p) :
    axesOf (firstAx w i) = axesOf (firstAx w (i + 1)) := by
  have := axesOf_set_first h6 i
  rw [h] at this
  exact this

section
variable {w : List Nat} (hS : Survive w) (hN : w.length ≤ 34)
include hS hN

theorem occ_set {occ : Array Bool} {k : Nat} (hsz : occ.size = NS) (hocc : OccOK w occ k)
    (hk : k + 1 ≤ w.length) : OccOK w (occ.set! (P w (k + 1)) true) (k + 1) := by
  have hi := vtx_inB hS hN hk
  intro v hv
  rw [occAt_set (by rw [hsz]; exact pk_lt hi)]
  by_cases h : pk v = P w (k + 1)
  · have := pk_inj hv hi h
    subst this
    simp only [h, if_true, true_iff]
    exact ⟨k + 1, Nat.le_refl _, rfl⟩
  · rw [if_neg h, hocc v hv]
    constructor
    · rintro ⟨t, ht, he⟩; exact ⟨t, by omega, he⟩
    · rintro ⟨t, ht, he⟩
      refine ⟨t, ?_, he⟩
      by_cases htk : t = k + 1
      · subst htk; exact absurd (by rw [← he]; rfl) h
      · omega

theorem occ_last {occ : Array Bool} (hocc : OccOK w occ (w.length - 1)) : OccOK w occ w.length := by
  have hN4 := S_len hS
  intro v hv
  rw [hocc v hv]
  constructor
  · rintro ⟨t, ht, he⟩; exact ⟨t, by omega, he⟩
  · rintro ⟨t, ht, he⟩
    by_cases htN : t = w.length
    · subst htN; rw [S_close hS, ← vtx_zero w] at he; exact ⟨0, by omega, he⟩
    · exact ⟨t, by omega, he⟩

theorem step_mem (M r : Nat) (hr : w.length ≤ 9 ∨ r = key ((w.take 9).reverse) % M)
    (fuel i : Nat) (hfi : fuel + 1 + i = w.length) (hi : 1 ≤ i)
    (occ : Array Bool) (revPos revDirs : List Nat) (last first : Axes) (c : Cnt) (pend : List Ob)
    (hC : Canon w i occ revPos revDirs last first c pend)
    (hrec : 0 < fuel → ∀ occ' rp rd l f c' p (acc : Acc), Canon w (i + 1) occ' rp rd l f c' p →
      w ∈ (dfs ⟨w.length, 9, M, r⟩ fuel occ' (i + 1) rp rd l f c' p acc).2.out)
    (sa : Array Bool × Acc) (hsa : sa.1 = occ) :
    w ∈ (stepF ⟨w.length, 9, M, r⟩ fuel i revPos revDirs last first c pend sa (dir w i)).2.out := by
  obtain ⟨hsz, hocc, rfl, rfl, rfl, rfl, rfl, hpend⟩ := hC
  have h6 := S_six hS
  have hN4 := S_len hS
  have hiN : i < w.length := by omega
  have hd6 := dir_lt h6 i
  have hrevi : (w.take i).reverse = dir w (i - 1) :: (w.take (i - 1)).reverse := by
    have := take_rev_succ (w := w) (i := i - 1) (by omega)
    rwa [show i - 1 + 1 = i by omega] at this
  unfold stepF
  lift_lets
  intro cur p1 p2 occ0 acc0 nx A acc' rd' l' f' c' occ1 rp' f'' res
  have hocc0 : occ0 = occ := hsa
  have hA : A = axis (dir w i) := rfl
  have hnx : nx = P w (i + 1) := by
    show mv ((rpos (P w) i).headD 0) (dir w i) = _
    rw [rpos_headD]; unfold P
    rw [mv_pk (vtx_inB hS hN (by omega)) hd6, vtx_succ hiN]
  have c1 : ¬ (dir w i == p1 || p2 == some (dir w i)) = true := by
    have hp1 : p1 = rev (dir w (i - 1)) := by
      show rev ((w.take i).reverse.headD 0) = _
      rw [hrevi]; rfl
    have hp2 : p2 ≠ some (dir w i) := by
      by_cases hi2 : 2 ≤ i
      · have hrev2 : (w.take i).reverse = dir w (i - 1) :: dir w (i - 2) :: (w.take (i - 2)).reverse := by
          rw [hrevi]
          have := take_rev_succ (w := w) (i := i - 2) (by omega)
          rw [show i - 2 + 1 = i - 1 by omega] at this
          rw [this]
        have : p2 = some (rev (dir w (i - 2))) := by
          simp only [p2]; rw [hrev2]
        rw [this]; intro h
        apply S2c hS (j := i - 2) (by omega)
        rw [show i - 2 + 2 = i by omega, Nat.mod_eq_of_lt hiN]
        exact (Option.some.inj h).symm
      · have hrev1 : (w.take i).reverse = [dir w 0] := by
          rw [hrevi, show i - 1 = 0 by omega]; rfl
        have : p2 = none := by
          simp only [p2]; rw [hrev1]
        rw [this]; simp
    rw [hp1]
    simp only [Bool.or_eq_true, beq_iff_eq, not_or]
    exact ⟨S1 hS hi hiN, hp2⟩
  rw [if_neg c1]
  have hhead : (List.take i w).reverse.head? = some (dir w (i - 1)) := by rw [hrevi]; rfl
  have hlg : (axesOf (lastAx w i)).get A = lastAx w i (axis (dir w i)) := axesOf_get _ (axis_lt hd6)
  have hl' : l' = axesOf (lastAx w (i + 1)) := axesOf_set_last h6 i
  have hfirst : (match (axesOf (firstAx w i)).get A with
      | none => (axesOf (firstAx w i)).set A (some (i, dir w i))
      | _ => axesOf (firstAx w i)) = axesOf (firstAx w (i + 1)) := by
    split
    · rename_i heq; exact first_none h6 i heq
    · rename_i x hx
      cases hg : (axesOf (firstAx w i)).get (axis (dir w i)) with
      | none => exact absurd hg hx
      | some p => exact first_some h6 i hg
  have hf' : f' = axesOf (firstAx w (i + 1)) := hfirst
  have hf'' : f'' = axesOf (firstAx w (i + 1)) := hfirst
  have hc' : c' = cntOf w (i + 1) := cntOf_succ h6 hiN
  have hrd : rd' = (w.take (i + 1)).reverse := (take_rev_succ hiN).symm
  by_cases hf0 : fuel = 0
  · -- the last step
    have hiN' : i + 1 = w.length := by omega
    rw [if_pos (by simp [hf0])]
    have c2 : ¬ (nx != ORG || decide (rev (dir w i) ≤ (List.take i w).reverse.getLast?.getD 0)) = true := by
      have e1 : nx = ORG := by rw [hnx, ORG_eq, hiN']; unfold P; rw [S_close hS]
      have e2 : (List.take i w).reverse.getLast? = some (dir w 0) := by
        rw [List.getLast?_reverse, List.head?_take, if_neg (by omega), List.head?_eq_getElem?,
          getElem?_dir (by omega)]
      have c4 := hS.2.2.1
      rw [e1, e2]
      rw [show w.length - 1 = i by omega] at c4
      simp only [bne_self_eq_false, Option.getD_some, Bool.false_or, decide_eq_true_eq]
      omega
    rw [if_neg c2]
    obtain ⟨nw, hu, -⟩ := update_ok hS hN i hi (by omega) occ
      (by rw [hiN']; exact occ_last hS hN (by rw [show w.length - 1 = i by omega]; exact hocc)) pend hpend
    rw [show w.length - i - 1 = 0 by omega] at hu
    have hu' : update occ0 pend i (dir w i) nx (nx :: rpos (P w) i) (List.take i w).reverse.head?
        ((axesOf (lastAx w i)).get A) 0 = some nw := by
      rw [hocc0, hnx, hhead, hlg]; exact hu
    rw [hu']
    have hleaf : leafOk occ0 w.length (rpos (P w) i).reverse rd'.reverse l' f' ((cntOf w i).inc A) = true := by
      have := leaf_ok hS hN (occ := occ) (by rw [show w.length - 1 = i by omega]; exact hocc)
      rw [hocc0, hrd, hl', hf', show (cntOf w i).inc A = cntOf w (i + 1) from hc', hiN',
        List.reverse_reverse, List.take_length, show i = w.length - 1 by omega]
      exact this
    show w ∈ (if leafOk occ0 w.length (rpos (P w) i).reverse rd'.reverse l' f' ((cntOf w i).inc A) = true then
        (occ0, { nodes := acc'.nodes, out := rd'.reverse :: acc'.out }) else (occ0, acc')).snd.out
    rw [if_pos hleaf, hrd, show i + 1 = w.length from hiN', List.reverse_reverse, List.take_length]
    exact List.mem_cons_self
  · -- a step that is not the last
    have hi1N : i + 1 < w.length := by omega
    rw [if_neg (by simp [hf0])]
    have hv1 := vtx_inB hS hN (m := i + 1) (by omega)
    have c3 : ¬ (occAt occ0 nx || !allowed nx || decide (fuel < dist0 nx)) = true := by
      have o1 : occAt occ (P w (i + 1)) = false := by
        cases h : occAt occ (P w (i + 1)) with
        | false => rfl
        | true =>
          obtain ⟨t, ht, he⟩ := (hocc _ hv1).1 h
          rcases vtx_eq_idx hS (a := t) (b := i + 1) (by omega) hi1N he with h' | h' <;> omega
      have a1 : allowed (P w (i + 1)) = true := allowed_vtx hS hN (m := i + 1) (by omega) hi1N
      have d1 : dist0 (P w (i + 1)) ≤ fuel := by
        unfold P; rw [dist0_pk hv1]
        have := vtx_dist' (w := w) (a := i + 1) (b := w.length) (by omega) (Nat.le_refl _)
        rw [S_close hS] at this
        simp only [V3.zero_x, V3.zero_y, V3.zero_z, Int.zero_sub, Int.natAbs_neg] at this
        unfold n1; omega
      rw [hocc0, hnx, o1, a1]
      simp only [Bool.not_true, Bool.false_or, decide_eq_true_eq]
      omega
    rw [if_neg c3]
    have c4 : ¬ (decide (w.length < 2 * max c'.y c'.z + c'.z) || decide (c'.y + fuel < c'.z) ||
        decide (c'.x + fuel < c'.y)) = true := by
      rw [hc']
      have c5 := hS.2.2.2.1
      have sx := countAxis_split 0 w (i + 1)
      have sy := countAxis_split 1 w (i + 1)
      have sz := countAxis_split 2 w (i + 1)
      have sd := countAxis_sum (w.drop (i + 1)) (fun d hd => h6 d (List.mem_of_mem_drop hd))
      have st := countAxis_sum w h6
      simp only [List.length_drop] at sd
      simp only [cntOf, Bool.or_eq_true, decide_eq_true_eq, not_or]
      omega
    show w ∈ (if (decide (w.length < 2 * max c'.y c'.z + c'.z) || decide (c'.y + fuel < c'.z) ||
        decide (c'.x + fuel < c'.y)) = true then (occ0, acc0) else (res.fst.set! nx false, res.snd)).snd.out
    rw [if_neg c4]
    show w ∈ res.snd.out
    simp only [res]
    have hocc1 : OccOK w occ1 (i + 1) := by
      show OccOK w (occ0.set! nx true) (i + 1)
      rw [hocc0, hnx]; exact occ_set hS hN hsz hocc (by omega)
    obtain ⟨nw, hu, hg⟩ := update_ok hS hN i hi (by omega) occ1 hocc1 pend hpend
    have hu' : update occ1 pend i (dir w i) nx rp' (List.take i w).reverse.head?
        ((axesOf (lastAx w i)).get A) fuel = some nw := by
      have hrp : rp' = rpos (P w) (i + 1) := by show nx :: rpos (P w) i = _; rw [hnx]; rfl
      rw [hrp, hnx, hhead, hlg, show fuel = w.length - i - 1 by omega]; exact hu
    rw [hu']
    show w ∈ (if (i + 1 == 9 && key rd' % M != r) = true then (occ1, acc')
      else dfs ⟨w.length, 9, M, r⟩ fuel occ1 (i + 1) rp' rd' l' f'' c' nw acc').snd.out
    have c6 : ¬ (i + 1 == 9 && key rd' % M != r) = true := by
      simp only [Bool.and_eq_true, beq_iff_eq, bne_iff_ne, ne_eq, not_and, Decidable.not_not]
      intro h9
      rcases hr with hr | hr
      · omega
      · rw [hrd, h9, hr]
    rw [if_neg c6]
    apply hrec (by omega)
    refine ⟨?_, hocc1, ?_, hrd, hl', hf'', hc', hg⟩
    · show (occ0.set! nx true).size = NS
      rw [size_set, hocc0, hsz]
    · show nx :: rpos (P w) i = _; rw [hnx]; rfl

theorem dfs_mem (M r : Nat) (hr : w.length ≤ 9 ∨ r = key ((w.take 9).reverse) % M) :
    ∀ (fuel i : Nat) (occ : Array Bool) (revPos revDirs : List Nat) (last first : Axes) (c : Cnt)
      (pend : List Ob) (acc : Acc), fuel + 1 + i = w.length → 1 ≤ i →
      Canon w i occ revPos revDirs last first c pend →
      w ∈ (dfs ⟨w.length, 9, M, r⟩ (fuel + 1) occ i revPos revDirs last first c pend acc).2.out := by
  intro fuel
  induction fuel with
  | zero =>
    intro i occ revPos revDirs last first c pend acc hfi hi hC
    rw [dfs_succ]
    have hd6 := dir_lt (S_six hS) i
    exact foldl_mem _ (fun sa => sa.1 = occ) (fun sa => w ∈ sa.2.out)
      (fun b a hb => (stepF_fst _ 0 i revPos revDirs last first c pend b a (dfs_fst _ 0)).trans hb)
      (fun b a _ hq => stepF_out _ 0 i revPos revDirs last first c pend b a w (dfs_out _ w 0) hq)
      (dir w i)
      (fun b hb => step_mem hS hN M r hr 0 i hfi hi occ revPos revDirs last first c pend hC
        (fun h => absurd h (Nat.lt_irrefl 0)) b hb)
      [0, 1, 2, 3, 4, 5] (occ, acc) (by rcases six_cases hd6 with h | h | h | h | h | h <;> simp [h]) rfl
  | succ f ih =>
    intro i occ revPos revDirs last first c pend acc hfi hi hC
    rw [dfs_succ]
    have hd6 := dir_lt (S_six hS) i
    exact foldl_mem _ (fun sa => sa.1 = occ) (fun sa => w ∈ sa.2.out)
      (fun b a hb => (stepF_fst _ (f + 1) i revPos revDirs last first c pend b a (dfs_fst _ _)).trans hb)
      (fun b a _ hq => stepF_out _ (f + 1) i revPos revDirs last first c pend b a w (dfs_out _ w _) hq)
      (dir w i)
      (fun b hb => step_mem hS hN M r hr (f + 1) i hfi hi occ revPos revDirs last first c pend hC
        (fun _ occ' rp rd l f' c' p acc hC' => ih (i + 1) occ' rp rd l f' c' p acc (by omega) (by omega) hC')
        b hb)
      [0, 1, 2, 3, 4, 5] (occ, acc) (by rcases six_cases hd6 with h | h | h | h | h | h <;> simp [h]) rfl

end

theorem mv_ne (p a : Nat) (hp : 4096 ≤ p) : mv p a ≠ p := by
  match a with
  | 0 => show p + 1 ≠ p; omega
  | 1 => show p - 1 ≠ p; omega
  | 2 => show p + 64 ≠ p; omega
  | 3 => show p - 64 ≠ p; omega
  | 4 => show p + 4096 ≠ p; omega
  | a + 5 => show p - 4096 ≠ p; omega

theorem ORG_lt : ORG < NS := by unfold ORG NS; omega

theorem size_occ0 : ((Array.replicate NS false).set! ORG true).size = NS := by
  rw [size_set, Array.size_replicate]

theorem occAt_occ0 (q : Nat) : occAt ((Array.replicate NS false).set! ORG true) q = (q == ORG) := by
  rw [occAt_set (by rw [Array.size_replicate]; exact ORG_lt), occAt_replicate]
  by_cases h : q = ORG <;> simp [h]

theorem occ0_mv (a : Nat) : occAt ((Array.replicate NS false).set! ORG true) (mv ORG a) = false := by
  rw [occAt_occ0]
  simp only [beq_eq_false_iff_ne]
  exact mv_ne _ _ (by unfold ORG; omega)

theorem topF_snd (N M r : Nat) (O : Array Bool) (hO : ∀ a, occAt O (mv ORG a) = false)
    (b : MProd Acc (Array Bool)) (a : Nat) (hb : b.snd = O) : (topF N 9 M r b a).snd = O := by
  unfold topF
  split
  · exact hb
  · lift_lets
    intro res
    show res.fst.set! (mv ORG a) false = _
    rw [show res.fst = b.snd.set! (mv ORG a) true from dfs_fst _ _ _ _ _ _ _ _ _ _ _, hb]
    exact set_restore (hO a)

theorem topF_out (N M r : Nat) (x : List Nat) (b : MProd Acc (Array Bool)) (a : Nat)
    (hx : x ∈ b.fst.out) : x ∈ (topF N 9 M r b a).fst.out := by
  unfold topF
  split
  · exact hx
  · lift_lets
    intro res
    exact dfs_out _ x _ _ _ _ _ _ _ _ _ _ hx

theorem occ0_ok {w : List Nat} : OccOK w ((Array.replicate NS false).set! ORG true) 0 := by
  intro v hv
  rw [occAt_occ0]
  by_cases h : pk v = ORG
  · rw [ORG_eq] at h
    have := pk_inj hv (by unfold InB; simp) h
    subst this
    simp only [ORG_eq, beq_self_eq_true, true_iff]
    exact ⟨0, Nat.le_refl _, vtx_zero w⟩
  · simp only [beq_iff_eq, h, false_iff, not_exists, not_and]
    intro t ht he
    rw [show t = 0 by omega, vtx_zero] at he
    subst he
    exact h ORG_eq.symm

section
variable {w : List Nat} (hS : Survive w) (hN : w.length ≤ 34)
include hS hN

theorem first_letter : dir w 0 ≠ 4 := by
  intro h
  have h6 := S_six hS
  have hN4 := S_len hS
  have c4 := hS.2.2.1
  rw [h] at c4
  have hr6 := rev_lt (dir_lt h6 (w.length - 1))
  have e : dir w (w.length - 1) = 4 := by
    have : rev (dir w (w.length - 1)) = 5 := by omega
    rw [← rev_rev (d := dir w (w.length - 1)), this]; rfl
  have hv := vtx_succ (w := w) (j := w.length - 1) (by omega)
  rw [show w.length - 1 + 1 = w.length by omega, S_close hS, e] at hv
  have hz := congrArg V3.z hv
  have hl := hS.2.1 (w.length - 1) (by omega) (by omega)
  unfold LexPos at hl
  simp [unit] at hz
  omega

theorem search_complete_aux (M r : Nat) (hr : w.length ≤ 9 ∨ r = key ((w.take 9).reverse) % M) :
    w ∈ (searchPart w.length 9 M r).out := by
  have h6 := S_six hS
  have hN4 := S_len hS
  rw [searchPart_eq]
  have hd6 := dir_lt h6 0
  have hmv : mv ORG (dir w 0) = P w 1 := by
    unfold P
    rw [ORG_eq, mv_pk (by unfold InB; simp) hd6, vtx_succ (by omega), vtx_zero]
  have hmem : dir w 0 ∈ [0, 1, 2, 3, 4, 5] := by
    rcases six_cases hd6 with h | h | h | h | h | h <;> simp [h]
  generalize [0, 1, 2, 3, 4, 5] = L at hmem ⊢
  have hO1 := occ0_mv
  have hO2 := size_occ0
  have hO3 : OccOK w ((Array.replicate NS false).set! ORG true) 0 := occ0_ok
  generalize (Array.replicate NS false).set! ORG true = O0 at hO1 hO2 hO3 ⊢
  refine foldl_mem (topF w.length 9 M r) (fun b => b.snd = O0)
    (fun b => w ∈ b.fst.out) (fun b a hb => topF_snd _ _ _ O0 hO1 b a hb)
    (fun b a _ hq => topF_out _ _ _ _ b a hq) (dir w 0) ?_ L ⟨⟨0, []⟩, O0⟩ hmem rfl
  intro b hb
  unfold topF
  have c0 : ¬ (!allowed (mv ORG (dir w 0)) || dir w 0 == 4) = true := by
    rw [hmv]
    have a1 : allowed (P w 1) = true := allowed_vtx hS hN (m := 1) (Nat.le_refl _) (by omega)
    rw [a1]
    simp [first_letter hS hN]
  rw [if_neg c0]
  lift_lets
  intro res
  show w ∈ res.snd.out
  simp only [res]
  rw [hb, show w.length - 1 = (w.length - 2) + 1 by omega, hmv]
  have hlf : lastAx w 1 = firstAx w 1 := by
    funext A; simp [lastAx, firstAx]
  have hax : (⟨none, none, none⟩ : Axes).set (axis (dir w 0)) (some (0, dir w 0)) = axesOf (lastAx w 1) :=
    axesOf_set_last h6 0
  apply dfs_mem hS hN M r hr (w.length - 2) 1 _ _ _ _ _ _ _ _ (by omega) (Nat.le_refl _)
  refine ⟨?_, occ_set hS hN hO2 hO3 (by omega), ?_, ?_, hax, ?_, ?_, ?_⟩
  · rw [size_set, hO2]
  · show [P w 1, ORG] = [P w 1, P w 0]
    unfold P; rw [vtx_zero, ← ORG_eq]
  · have := take_rev_succ (w := w) (i := 0) (by omega)
    rw [this]; rfl
  · rw [hax, hlf]
  · exact cntOf_zero_inc w h6 (by omega)
  · intro ob hob; exact absurd hob List.not_mem_nil

end

end Len52.SP
