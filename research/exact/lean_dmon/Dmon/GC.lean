/-
  Dmon.GC — the generalized curtain lemma (D1, "GC"; DMON_RESULTS.md section D1).

  Statement.  Let P be a polygon with n >= 6 edges and v_0, v_1 = v_0 + a, v_2, ..., v_m, v_{m+1} = v_m - a
  (m >= 2, a a unit vector) consecutive vertices; the steps v_1 -> ... -> v_m are arbitrary.  Let Q =
  {v_1,...,v_m} and R = V(P) \ Q = {v_0, v_{m+1}, ..., v_{n-1}}.  If none of v_j - a (2 <= j <= m-1) lies in R
  ("the window is not closed up"), then P' = v_0, v_2 - a, ..., v_{m-1} - a, v_{m+1}, ..., v_{n-1} is a
  polygon of the same knot type with n - 2 edges.

  What is proved here (in Lean, standard axioms only, no unproved steps):
    * `gc_polygon`: P' is a polygon (closed, self-avoiding, n - 2 >= 4 edges).  This is the combinatorial half.
    * `gc_shortest`: a shortest word of a class T that is closed under rotation (KnotClass) and under the
      GC replacement (`GCStep T`) satisfies the GC condition at every cyclic window (`GCOK`) -- i.e. the search
      may reject every word that violates it.
  What is NOT proved in Lean: the topological half, `GCStep T`: replacing a polygon by P' does not change
  its knot type.  It is the isotopy H_t of DMON_RESULTS.md section D1 and has the same status as the
  `flip` and `uturn` fields of `KnotClass` (Len52.Spec).  It is an explicit hypothesis here.

  In words/indices.  The window starting at letter i0 of the cyclic word is, after rotating the word i0 times,
  `a :: (mid ++ rev a :: rest)`: letter a, then the m - 1 letters `mid` of the steps v_1 -> ... -> v_m, then
  the letter -a, then the letters `rest` (v_{m+1} -> ... -> v_n = v_0).  P' is the word `mid ++ rest`.
-/
import Dmon.AxisTravel
import Dmon.Nodup

namespace Dmon
open Len52

theorem V3_ext {a b : V3} (hx : a.x = b.x) (hy : a.y = b.y) (hz : a.z = b.z) : a = b := by
  cases a; cases b; simp only at hx hy hz; simp [hx, hy, hz]

theorem V3_add_sub (p u : V3) : p + u - u = p := V3_ext (by simp) (by simp) (by simp)

theorem V3_add_cancel {p q u : V3} (h : p + u = q + u) : p = q := by
  have := congrArg (fun x => x - u) h
  simp only [V3_add_sub] at this
  exact this

theorem V3_add_assoc (p u v : V3) : p + u + v = p + (u + v) :=
  V3_ext (by simp; omega) (by simp; omega) (by simp; omega)

theorem V3_add_zero (p : V3) : p + 0 = p := V3_ext (by simp) (by simp) (by simp)

theorem unit_rev (a : Nat) (ha : a < 6) : unit a + unit (rev a) = 0 := by
  have h : a = 0 ∨ a = 1 ∨ a = 2 ∨ a = 3 ∨ a = 4 ∨ a = 5 := by omega
  rcases h with rfl | rfl | rfl | rfl | rfl | rfl <;> decide

/-- the word of a window at the start: a, mid, -a, rest -/
def gcw (a : Nat) (mid rest : List Nat) : List Nat := a :: (mid ++ rev a :: rest)

/-- the window is closed up: some v_j - a (2 <= j <= m - 1, m - 1 = |mid|) is a vertex of R =
    {v_0} ∪ {v_{m+1}, ..., v_{n-1}} (indices k = 0 or m + 1 <= k < n) -/
def GCClosed (a : Nat) (mid rest : List Nat) : Prop :=
  ∃ j, 2 ≤ j ∧ j ≤ mid.length ∧ ∃ k, (k = 0 ∨ (mid.length + 2 ≤ k ∧ k < (gcw a mid rest).length)) ∧
    vtx (gcw a mid rest) k = vtx (gcw a mid rest) j - unit a

theorem vtx_zero (w : List Nat) : vtx w 0 = 0 := by
  rw [vtx_eq_endpt w 0 (Nat.zero_le _)]; rfl

theorem length_gcw (a : Nat) (mid rest : List Nat) :
    (gcw a mid rest).length = mid.length + rest.length + 2 := by simp [gcw]; omega

/-- vertices of P' before the window's far end: v_{k+1} = v'_k + a -/
theorem gc_vtx_small (a : Nat) (mid rest : List Nat) (k : Nat) (hk : k ≤ mid.length) :
    vtx (gcw a mid rest) (k + 1) = vtx (mid ++ rest) k + unit a := by
  have e1 : vtx (gcw a mid rest) (k + 1) = endpt 0 ((gcw a mid rest).take (k + 1)) :=
    vtx_eq_endpt _ _ (by rw [length_gcw]; omega)
  have e2 : vtx (mid ++ rest) k = endpt 0 ((mid ++ rest).take k) :=
    vtx_eq_endpt _ _ (by simp; omega)
  rw [e1, e2, List.take_append_of_le_length hk]
  have : (gcw a mid rest).take (k + 1) = a :: mid.take k := by
    simp [gcw, List.take_succ_cons, List.take_append_of_le_length hk]
  rw [this]
  show endpt (0 + unit a) (mid.take k) = endpt 0 (mid.take k) + unit a
  exact endpt_add 0 (unit a) _

/-- after the window: v_{k+2} = v'_k -/
theorem gc_vtx_large (a : Nat) (ha : a < 6) (mid rest : List Nat) (k : Nat)
    (h1 : mid.length ≤ k) (h2 : k ≤ mid.length + rest.length) :
    vtx (gcw a mid rest) (k + 2) = vtx (mid ++ rest) k := by
  have e1 : vtx (gcw a mid rest) (k + 2) = endpt 0 ((gcw a mid rest).take (k + 2)) :=
    vtx_eq_endpt _ _ (by rw [length_gcw]; omega)
  have e2 : vtx (mid ++ rest) k = endpt 0 ((mid ++ rest).take k) :=
    vtx_eq_endpt _ _ (by simp; omega)
  have t1 : (gcw a mid rest).take (k + 2) = a :: (mid ++ (rev a :: rest.take (k - mid.length))) := by
    have : k + 2 - 1 = k + 1 := by omega
    simp only [gcw, List.take_succ_cons, List.take_append]
    rw [List.take_of_length_le (by omega : mid.length ≤ k + 1)]
    have : k + 1 - mid.length = (k - mid.length) + 1 := by omega
    rw [this, List.take_succ_cons]
  have t2 : (mid ++ rest).take k = mid ++ rest.take (k - mid.length) := by
    rw [List.take_append, List.take_of_length_le h1]
  rw [e1, e2, t1, t2]
  show endpt (0 + unit a) (mid ++ (rev a :: rest.take (k - mid.length))) = _
  simp only [endpt_append]
  show endpt (endpt (0 + unit a) mid + unit (rev a)) _ = endpt (endpt 0 mid) _
  rw [endpt_add 0 (unit a) mid, V3_add_assoc, unit_rev a ha, V3_add_zero]

/-- the combinatorial half of GC: P' is a polygon -/
theorem gc_polygon (a : Nat) (ha : a < 6) (mid rest : List Nat)
    (hpoly : IsPolygon (gcw a mid rest)) (hm : 1 ≤ mid.length)
    (hn : 6 ≤ (gcw a mid rest).length) (hno : ¬ GCClosed a mid rest) :
    IsPolygon (mid ++ rest) := by
  obtain ⟨_, hw6, hcl, hnd⟩ := hpoly
  have hlen := length_gcw a mid rest
  have hnd' := (vset_nodup_iff _).mp hnd
  refine ⟨by simp; omega, ?_, ?_, ?_⟩
  · intro d hd
    apply hw6 d
    simp only [gcw, List.mem_cons, List.mem_append] at hd ⊢
    rcases hd with h | h
    · exact Or.inr (Or.inl h)
    · exact Or.inr (Or.inr (Or.inr h))
  · -- closed
    have := gc_vtx_large a ha mid rest (mid ++ rest).length (by simp) (by simp)
    rw [← this]
    have e : (mid ++ rest).length + 2 = (gcw a mid rest).length := by rw [hlen]; simp
    rw [e]; exact hcl
  · rw [vset_nodup_iff]
    intro i j hij hj
    simp only [List.length_append] at hj
    intro heq
    by_cases hjl : j ≤ mid.length
    · -- both before the far end
      have s1 := gc_vtx_small a mid rest i (by omega)
      have s2 := gc_vtx_small a mid rest j hjl
      have := hnd' (i + 1) (j + 1) (by omega) (by omega)
      apply this
      rw [s1, s2, heq]
    · by_cases hil : mid.length ≤ i
      · have l1 := gc_vtx_large a ha mid rest i hil (by omega)
        have l2 := gc_vtx_large a ha mid rest j (by omega) (by omega)
        have := hnd' (i + 2) (j + 2) (by omega) (by omega)
        apply this
        rw [l1, l2, heq]
      · -- i < |mid| < j
        have s1 := gc_vtx_small a mid rest i (by omega)
        have l2 := gc_vtx_large a ha mid rest j (by omega) (by omega)
        by_cases hi0 : i = 0
        · subst hi0
          have h0 : vtx (mid ++ rest) 0 = 0 := vtx_zero _
          have := hnd' 0 (j + 2) (by omega) (by omega)
          apply this
          have h00 : vtx (gcw a mid rest) 0 = 0 := vtx_zero _
          rw [h00, l2, ← heq, h0]
        · apply hno
          refine ⟨i + 1, by omega, by omega, j + 2, Or.inr ⟨by omega, by omega⟩, ?_⟩
          rw [l2, ← heq, s1, V3_add_sub]

/-! ## Use in the search: a shortest word satisfies GC at every cyclic window -/

def rotN : Nat → List Nat → List Nat
  | 0, w => w
  | i + 1, w => rotN i (rotate1 w)

theorem length_rotate1 (w : List Nat) : (rotate1 w).length = w.length := by
  cases w <;> simp [rotate1]

theorem length_rotN (i : Nat) : ∀ w : List Nat, (rotN i w).length = w.length := by
  induction i with
  | zero => intro w; rfl
  | succ i ih => intro w; simp only [rotN]; rw [ih, length_rotate1]

/-- the GC condition of the search, at every cyclic window of w -/
def GCOK (w : List Nat) : Prop :=
  ∀ i a mid rest, i < w.length → rotN i w = gcw a mid rest → 1 ≤ mid.length → rest ≠ [] →
    GCClosed a mid rest

/-- the topological input of GC (for the class T of words of the knot types in question): a polygon that
    has a window which is not closed up can be replaced by P' = mid ++ rest, which is again in T. -/
def GCStep (T : List Nat → Prop) : Prop :=
  ∀ a mid rest, T (gcw a mid rest) → IsPolygon (mid ++ rest) → ¬ GCClosed a mid rest → T (mid ++ rest)

theorem gc_shortest (T : List Nat → Prop) (hK : KnotClass T) (hg : GCStep T) (w : List Nat)
    (hw : T w) (h6 : 6 ≤ w.length) (hmin : ∀ w', T w' → w.length ≤ w'.length) : GCOK w := by
  intro i a mid rest hi hrot hm hrest
  refine Classical.byContradiction (fun hno => ?_)
  have hT : ∀ n, ∀ w, T w → T (rotN n w) := by
    intro n
    induction n with
    | zero => intro w h; exact h
    | succ n ih => intro w h; exact ih _ (hK.rot w h)
  have hTi : T (gcw a mid rest) := by rw [← hrot]; exact hT i w hw
  have hlen : (gcw a mid rest).length = w.length := by rw [← hrot, length_rotN]
  have hpoly := hK.polygon _ hTi
  have ha : a < 6 := by
    have := hpoly.2.1 a (by simp [gcw])
    exact this
  have hP' := gc_polygon a ha mid rest hpoly hm (by omega) hno
  have hT' := hg a mid rest hTi hP' hno
  have := hmin _ hT'
  have l2 := length_gcw a mid rest
  simp only [List.length_append] at this
  omega

end Dmon
