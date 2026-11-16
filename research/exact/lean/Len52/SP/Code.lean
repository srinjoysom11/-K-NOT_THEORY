/-
  Len52.SP.Code — equation lemmas for the search program, and the frame properties of `dfs`
  (it returns its occupancy array unchanged, and its output only grows).
-/
import Len52.SP.Basic

namespace Len52.SP
open Len52 Len52.Search

/-- the body of the fold in `dfs` (verbatim) -/
def stepF (cfg : Cfg) (fuel i : Nat) (revPos revDirs : List Nat) (last first : Axes) (c : Cnt)
    (pend : List Ob) (sa : Array Bool × Acc) (d : Nat) : Array Bool × Acc :=
    let cur := revPos.headD 0
    let p1 := Len52.rev (revDirs.headD 0)
    let p2 : Option Nat := match revDirs with | _ :: q :: _ => some (Len52.rev q) | _ => none
      let occ := sa.1
      let acc := sa.2
      if d == p1 || p2 == some d then (occ, acc)
      else
        let nx := mv cur d
        let A := axis d
        if fuel == 0 then
          -- last step: must close the walk at the origin
          if nx != ORG || Len52.rev d ≤ revDirs.getLast?.getD 0 then (occ, acc)
          else
            let acc := { acc with nodes := acc.nodes + 1 }
            let revDirs' := d :: revDirs
            let last' := last.set A (some (i, d))
            let first' := match first.get A with | none => first.set A (some (i, d)) | _ => first
            match update occ pend i d nx (nx :: revPos) revDirs.head? (last.get A) 0 with
            | none => (occ, acc)
            | some _ =>
              if leafOk occ cfg.N revPos.reverse revDirs'.reverse last' first' (c.inc A) then
                (occ, { acc with out := revDirs'.reverse :: acc.out })
              else (occ, acc)
        else if occAt occ nx || !allowed nx || fuel < dist0 nx then (occ, acc)
        else
          let c' := c.inc A
          if cfg.N < 2 * max c'.y c'.z + c'.z || c'.y + fuel < c'.z || c'.x + fuel < c'.y then (occ, acc)
          else
            let acc := { acc with nodes := acc.nodes + 1 }
            let occ1 := occ.set! nx true
            let revPos' := nx :: revPos
            let revDirs' := d :: revDirs
            let last' := last.set A (some (i, d))
            let first' := match first.get A with | none => first.set A (some (i, d)) | _ => first
            let res :=
              match update occ1 pend i d nx revPos' revDirs.head? (last.get A) fuel with
              | none => (occ1, acc)
              | some nw =>
                if i + 1 == cfg.split && key revDirs' % cfg.M != cfg.r then (occ1, acc)
                else dfs cfg fuel occ1 (i + 1) revPos' revDirs' last' first' c' nw acc
            (res.1.set! nx false, res.2)

theorem dfs_succ (cfg : Cfg) (fuel : Nat) (occ : Array Bool) (i : Nat) (revPos revDirs : List Nat)
    (last first : Axes) (c : Cnt) (pend : List Ob) (acc : Acc) :
    dfs cfg (fuel + 1) occ i revPos revDirs last first c pend acc =
      [0, 1, 2, 3, 4, 5].foldl (stepF cfg fuel i revPos revDirs last first c pend) (occ, acc) := by
  rfl

/-! ## The top level loop as a fold -/

theorem run_forIn {β γ : Type} (L : List Nat) (init : β) (F : Nat → β → Id (ForInStep β))
    (G : β → Id γ) (g : β → Nat → β) (hF : ∀ d b, F d b = pure (.yield (g b d))) :
    Id.run (forIn L init F >>= G) = Id.run (G (L.foldl g init)) := by
  induction L generalizing init with
  | nil => rfl
  | cons d L ih => rw [List.forIn_cons, hF]; exact ih _

/-- the body of the loop in `searchPart` -/
def topF (N s M r : Nat) (st : MProd Acc (Array Bool)) (d : Nat) : MProd Acc (Array Bool) :=
  if (!allowed (mv ORG d) || d == 4) = true then st
  else
    let res := dfs ⟨N, s, M, r⟩ (N - 1) (st.snd.set! (mv ORG d) true) 1 [mv ORG d, ORG] [d]
      ((⟨none, none, none⟩ : Axes).set (axis d) (some (0, d)))
      ((⟨none, none, none⟩ : Axes).set (axis d) (some (0, d)))
      ((⟨0, 0, 0⟩ : Cnt).inc (axis d)) []
      { nodes := st.fst.nodes + 1, out := st.fst.out }
    ⟨res.snd, res.fst.set! (mv ORG d) false⟩

theorem searchPart_eq (N s M r : Nat) : searchPart N s M r =
    ([0, 1, 2, 3, 4, 5].foldl (topF N s M r) ⟨⟨0, []⟩, (Array.replicate NS false).set! ORG true⟩).fst := by
  unfold searchPart
  rw [run_forIn (g := topF N s M r)]
  · generalize List.foldl _ _ _ = x
    cases x
    rfl
  · intro d b
    show (if (!allowed (mv ORG d) || d == 4) = true then
      (pure (ForInStep.yield (⟨b.fst, b.snd⟩ : MProd Acc (Array Bool))) : Id _) else _) = _
    unfold topF
    by_cases h : (!allowed (mv ORG d) || d == 4) = true
    · rw [if_pos h, if_pos h]
    · rw [if_neg h, if_neg h]
      rfl

/-! ## Frame properties of `dfs` -/

theorem stepF_fst (cfg : Cfg) (fuel i : Nat) (revPos revDirs : List Nat) (last first : Axes) (c : Cnt)
    (pend : List Ob) (sa : Array Bool × Acc) (d : Nat)
    (ih : ∀ occ i rp rd l f c p acc, (dfs cfg fuel occ i rp rd l f c p acc).1 = occ) :
    (stepF cfg fuel i revPos revDirs last first c pend sa d).1 = sa.1 := by
  unfold stepF
  lift_lets
  intro cur p1 p2 occ acc nx A acc' rd' l' f' c' occ1 rp' f'' res
  split
  · rfl
  · split
    · split
      · rfl
      · split
        · rfl
        · split <;> rfl
    · split
      · rfl
      · split
        · rfl
        · rename_i h1 h2 h3 h4
          have hres : res.fst = occ1 := by
            simp only [res]
            split
            · rfl
            · split
              · rfl
              · exact ih _ _ _ _ _ _ _ _ _
          have hocc : occAt occ nx = false := by
            simp only [Bool.or_eq_true, not_or] at h3
            simpa using h3.1.1
          show res.fst.set! nx false = occ
          rw [hres]
          exact set_restore hocc

theorem foldl_inv {α β : Type} (f : β → α → β) (P : β → Prop) (h : ∀ b a, P b → P (f b a)) :
    ∀ (l : List α) (init : β), P init → P (l.foldl f init)
  | [], _, hi => hi
  | a :: l, init, hi => foldl_inv f P h l (f init a) (h init a hi)

theorem dfs_fst (cfg : Cfg) : ∀ fuel occ i rp rd l f c p acc,
    (dfs cfg fuel occ i rp rd l f c p acc).1 = occ
  | 0, _, _, _, _, _, _, _, _, _ => rfl
  | fuel + 1, occ, i, rp, rd, l, f, c, p, acc => by
    rw [dfs_succ]
    exact foldl_inv _ (fun sa => sa.1 = occ)
      (fun b a hb => (stepF_fst cfg fuel i rp rd l f c p b a (dfs_fst cfg fuel)).trans hb) _ (occ, acc) rfl

theorem stepF_out (cfg : Cfg) (fuel i : Nat) (revPos revDirs : List Nat) (last first : Axes) (c : Cnt)
    (pend : List Ob) (sa : Array Bool × Acc) (d : Nat) (x : List Nat)
    (ih : ∀ occ i rp rd l f c p (acc : Acc), x ∈ acc.out → x ∈ (dfs cfg fuel occ i rp rd l f c p acc).2.out)
    (hx : x ∈ sa.2.out) :
    x ∈ (stepF cfg fuel i revPos revDirs last first c pend sa d).2.out := by
  unfold stepF
  lift_lets
  intro cur p1 p2 occ acc nx A acc' rd' l' f' c' occ1 rp' f'' res
  split
  · exact hx
  · split
    · split
      · exact hx
      · split
        · exact hx
        · split
          · exact List.mem_cons_of_mem _ hx
          · exact hx
    · split
      · exact hx
      · split
        · exact hx
        · show x ∈ res.snd.out
          simp only [res]
          split
          · exact hx
          · split
            · exact hx
            · exact ih _ _ _ _ _ _ _ _ _ hx

theorem dfs_out (cfg : Cfg) (x : List Nat) : ∀ fuel occ i rp rd l f c p (acc : Acc), x ∈ acc.out →
    x ∈ (dfs cfg fuel occ i rp rd l f c p acc).2.out
  | 0, _, _, _, _, _, _, _, _, _, hx => hx
  | fuel + 1, occ, i, rp, rd, l, f, c, p, acc, hx => by
    rw [dfs_succ]
    exact foldl_inv _ (fun sa => x ∈ sa.2.out)
      (fun b a hb => stepF_out cfg fuel i rp rd l f c p b a x (dfs_out cfg x fuel) hb) _ (occ, acc) hx

/-- a fold that keeps an invariant, keeps a member, and adds it at the step `d` -/
theorem foldl_mem {α β : Type} (f : β → α → β) (P : β → Prop) (Q : β → Prop)
    (hP : ∀ b a, P b → P (f b a)) (hQ : ∀ b a, P b → Q b → Q (f b a)) (d : α)
    (hd : ∀ b, P b → Q (f b d)) : ∀ (l : List α) (init : β), d ∈ l → P init → Q (l.foldl f init)
  | [], _, h, _ => absurd h (List.not_mem_nil)
  | a :: l, init, h, hi => by
    rw [List.foldl_cons]
    rcases List.mem_cons.1 h with rfl | h'
    · exact foldl_inv f (fun b => P b ∧ Q b) (fun b a hb => ⟨hP b a hb.1, hQ b a hb.1 hb.2⟩) l _
        ⟨hP _ _ hi, hd init hi⟩ |>.2
    · exact foldl_mem f P Q hP hQ d hd l _ h' (hP _ _ hi)

end Len52.SP
