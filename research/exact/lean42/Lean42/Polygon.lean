/-
  Lean42.Polygon -- closed simple polygons in Q^3.

  Phase 1 of research/exact/lean42/PLAN.md.  Source: Burde-Zieschang, Knots (2nd ed.), Chapter 1,
  section A-B (a knot is a simple closed polygon); Lickorish, Chapter 1.

  A closed polygon is a *cyclic list of vertices* `L = [v_0, ..., v_{n-1}]`.  Its edges are the
  segments `[v_i, v_{i+1}]` for i < n - 1 and the closing edge `[v_{n-1}, v_0]`.  We store an edge as
  the pair of its endpoints.  Consecutive collinear vertices are allowed (a vertex in the interior of
  a straight edge): that is exactly what the lattice words produce.

  `Simple L` ("L is a simple closed polygon") says
    * `3 ≤ n` and the vertices are pairwise distinct;
    * any two different edges meet at most in common endpoints (`PairOK`).
  Because the vertices are distinct, two consecutive edges have exactly one common endpoint (the
  shared vertex) and two non-consecutive edges have none; so `Simple L` says that consecutive edges
  meet only in their shared vertex and non-consecutive edges are disjoint.  This is the definition
  of a polygonal knot (Burde-Zieschang 1.1-1.3) with the closed segments in place of arcs.

  The conditions are stated with the quantifier "for all edges e, e'" over lists, and the
  geometric part (`PairOK`) is an existence statement of linear-programming type, so it is
  decidable; the program is in `Lean42.Decide`.
-/
import Lean42.Geom

namespace Lean42

/-- The consecutive pairs `(l_0,l_1), (l_1,l_2), ...` of a list. -/
def chain : List Pt → List (Pt × Pt)
  | a :: b :: R => (a, b) :: chain (b :: R)
  | _ => []

/-- The edges of the closed polygon with vertex list `L`: the consecutive pairs and the
    closing pair. -/
def edges (L : List Pt) : List (Pt × Pt) := chain (L ++ L.take 1)

/-- The point set of the polygon: the union of its closed edges. -/
def pset (L : List Pt) : Set Pt := {x | ∃ e ∈ edges L, x ∈ seg e.1 e.2}

/-- Two edges meet at most in common endpoints: every common point is an endpoint of both. -/
def PairOK (e e' : Pt × Pt) : Prop :=
  ∀ x, x ∈ seg e.1 e.2 → x ∈ seg e'.1 e'.2 → (x = e.1 ∨ x = e.2) ∧ (x = e'.1 ∨ x = e'.2)

/-- `L` is a simple closed polygon. -/
def Simple (L : List Pt) : Prop :=
  3 ≤ L.length ∧ L.Nodup ∧ ∀ e ∈ edges L, ∀ e' ∈ edges L, e ≠ e' → PairOK e e'

/-! ## Elementary facts about `chain` and `edges` -/

theorem chain_cons_cons (a b : Pt) (R : List Pt) : chain (a :: b :: R) = (a, b) :: chain (b :: R) := rfl

theorem edges_cons_cons (a b : Pt) (R : List Pt) :
    edges (a :: b :: R) = (a, b) :: chain (b :: (R ++ [a])) := by
  simp [edges, chain]

theorem chain_append_pair (l : List Pt) (a h : Pt) :
    chain (l ++ [a, h]) = chain (l ++ [a]) ++ [(a, h)] := by
  induction l with
  | nil => simp [chain]
  | cons x l ih =>
    cases l with
    | nil => simp [chain]
    | cons y l' =>
      simp only [List.cons_append, chain] at ih ⊢
      rw [ih]

theorem chain_map {φ : Pt → Pt} (l : List Pt) :
    chain (l.map φ) = (chain l).map (Prod.map φ φ) := by
  induction l with
  | nil => simp [chain]
  | cons a l ih =>
    cases l with
    | nil => simp [chain]
    | cons b l' =>
      simp only [List.map_cons, chain] at ih ⊢
      rw [ih]
      rfl

theorem edges_map (φ : Pt → Pt) (L : List Pt) :
    edges (L.map φ) = (edges L).map (Prod.map φ φ) := by
  unfold edges
  rw [← chain_map, List.map_append, List.map_take]

theorem chain_mem (l : List Pt) {e : Pt × Pt} (h : e ∈ chain l) : e.1 ∈ l ∧ e.2 ∈ l := by
  induction l with
  | nil => simp [chain] at h
  | cons a l ih =>
    cases l with
    | nil => simp [chain] at h
    | cons b l' =>
      simp only [chain, List.mem_cons] at h
      rcases h with rfl | h
      · simp
      · have := ih h
        simp only [List.mem_cons] at this ⊢
        tauto

theorem chain_fst (l : List Pt) : (chain l).map Prod.fst = l.dropLast := by
  induction l with
  | nil => simp [chain]
  | cons a l ih =>
    cases l with
    | nil => simp [chain]
    | cons b l' =>
      simp only [chain, List.map_cons] at ih ⊢
      rw [ih]
      simp [List.dropLast]

theorem chain_snd (l : List Pt) : (chain l).map Prod.snd = l.tail := by
  induction l with
  | nil => simp [chain]
  | cons a l ih =>
    cases l with
    | nil => simp [chain]
    | cons b l' =>
      simp only [chain, List.map_cons] at ih ⊢
      rw [ih]
      simp

/-- the edges of a polygon are the pairs (vertex, next vertex) -/
theorem edges_eq_zip (L : List Pt) : edges L = L.zip (L.rotate 1) := by
  cases L with
  | nil => simp [edges, chain]
  | cons a L' =>
    cases L' with
    | nil => simp [edges, chain]
    | cons b R =>
      rw [edges_cons_cons]
      -- (a::b::R).rotate 1 = b :: (R ++ [a])
      have hr : (a :: b :: R).rotate 1 = b :: (R ++ [a]) := by simp [List.rotate_cons_succ]
      rw [hr]
      -- zip (a :: b :: R) (b :: (R ++ [a])) = (a,b) :: zip (b :: R) (R ++ [a]) and the chain is the zip
      have key : ∀ (b : Pt) (R : List Pt) (a : Pt),
          chain (b :: (R ++ [a])) = (b :: R).zip (R ++ [a]) := by
        intro b R
        induction R generalizing b with
        | nil => intro a; simp [chain]
        | cons c R ih =>
          intro a
          simp only [List.cons_append, chain, List.zip_cons_cons]
          rw [← ih c a]
      rw [key b R a]
      rfl

theorem edges_perm_rotate (L : List Pt) : (edges (L.rotate 1)).Perm (edges L) := by
  cases L with
  | nil => simp [edges, chain]
  | cons a L' =>
    cases L' with
    | nil => simp [edges, chain]
    | cons h t =>
      have hr : (a :: h :: t).rotate 1 = h :: (t ++ [a]) := by simp [List.rotate_cons_succ]
      rw [hr, edges_cons_cons]
      have : edges (h :: (t ++ [a])) = chain (h :: t ++ [a]) ++ [(a, h)] := by
        unfold edges
        have h1 : (h :: (t ++ [a])) ++ (h :: (t ++ [a])).take 1 = (h :: t) ++ [a, h] := by simp
        rw [h1, chain_append_pair]
      rw [this]
      have h2 : chain (h :: t ++ [a]) = chain (h :: (t ++ [a])) := by simp
      rw [h2]
      exact (List.perm_append_singleton _ _)

theorem mem_edges_rotate {L : List Pt} {e : Pt × Pt} : e ∈ edges (L.rotate 1) ↔ e ∈ edges L :=
  (edges_perm_rotate L).mem_iff

theorem mem_edges_rotate_iter {L : List Pt} {e : Pt × Pt} (k : ℕ) :
    e ∈ edges (L.rotate k) ↔ e ∈ edges L := by
  induction k generalizing L with
  | zero => simp
  | succ k ih =>
    rw [← List.rotate_rotate, mem_edges_rotate, ih]

theorem edges_fst (L : List Pt) : (edges L).map Prod.fst = L := by
  rw [edges_eq_zip]
  simp [List.map_fst_zip]

theorem mem_edges_fst {L : List Pt} {e : Pt × Pt} (h : e ∈ edges L) : e.1 ∈ L := by
  rw [← edges_fst L]; exact List.mem_map_of_mem h

theorem mem_edges_snd {L : List Pt} {e : Pt × Pt} (h : e ∈ edges L) : e.2 ∈ L := by
  rw [edges_eq_zip] at h
  have := List.of_mem_zip h
  exact (List.mem_rotate).1 this.2

/-- For a polygon without repeated vertices, two edges with the same first vertex are equal. -/
theorem edges_fst_inj {L : List Pt} (hL : L.Nodup) {e e' : Pt × Pt} (he : e ∈ edges L)
    (he' : e' ∈ edges L) (h : e.1 = e'.1) : e = e' := by
  have hnd : ((edges L).map Prod.fst).Nodup := by rw [edges_fst]; exact hL
  exact (List.inj_on_of_nodup_map hnd he he' h)

end Lean42
