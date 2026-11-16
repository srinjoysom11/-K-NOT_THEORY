import Len52.Spec

namespace Len52

theorem V3.ext' {a b : V3} (hx : a.x = b.x) (hy : a.y = b.y) (hz : a.z = b.z) : a = b := by
  cases a; cases b; simp_all

/-- prove an identity between points coordinatewise -/
macro "len52_v3_ext" : tactic => `(tactic| (apply V3.ext' <;> (try simp) <;> omega))

theorem V3.eq_iff (a b : V3) : a = b ↔ a.x = b.x ∧ a.y = b.y ∧ a.z = b.z := by
  constructor
  · intro h; subst h; exact ⟨rfl, rfl, rfl⟩
  · intro ⟨h1, h2, h3⟩; exact V3.ext' h1 h2 h3

theorem unit_x (d : Nat) : (unit d).x = if d = 0 then 1 else if d = 1 then -1 else 0 := by
  match d with
  | 0 => rfl
  | 1 => rfl
  | 2 => rfl
  | 3 => rfl
  | 4 => rfl
  | d + 5 => simp [unit]

theorem unit_y (d : Nat) : (unit d).y = if d = 2 then 1 else if d = 3 then -1 else 0 := by
  match d with
  | 0 => rfl
  | 1 => rfl
  | 2 => rfl
  | 3 => rfl
  | 4 => rfl
  | d + 5 => simp [unit]

theorem unit_z (d : Nat) : (unit d).z = if d = 4 then 1 else if 5 ≤ d then -1 else 0 := by
  match d with
  | 0 => rfl
  | 1 => rfl
  | 2 => rfl
  | 3 => rfl
  | 4 => rfl
  | d + 5 => simp [unit]

theorem length_vertsFrom (v : V3) (l : List Nat) : (vertsFrom v l).length = l.length + 1 := by
  induction l generalizing v with
  | nil => rfl
  | cons d ds ih => simp [vertsFrom, ih]

theorem length_verts (w : List Nat) : (verts w).length = w.length + 1 := length_vertsFrom 0 w

theorem vertsFrom_getD_zero (v : V3) (l : List Nat) : (vertsFrom v l).getD 0 0 = v := by
  cases l <;> rfl

theorem vertsFrom_getD_succ (v : V3) (l : List Nat) (j : Nat) (hj : j < l.length) :
    (vertsFrom v l).getD (j + 1) 0 = (vertsFrom v l).getD j 0 + unit (l.getD j 0) := by
  induction l generalizing v j with
  | nil => simp at hj
  | cons d ds ih =>
    cases j with
    | zero =>
      show (vertsFrom (v + unit d) ds).getD 0 0 = v + unit d
      exact vertsFrom_getD_zero _ _
    | succ j =>
      simp only [List.length_cons] at hj
      have := ih (v + unit d) j (by omega)
      simpa [vertsFrom] using this

@[simp] theorem vtx_zero (w : List Nat) : vtx w 0 = 0 := vertsFrom_getD_zero 0 w

theorem vtx_succ (w : List Nat) (j : Nat) (hj : j < w.length) :
    vtx w (j + 1) = vtx w j + unit (dir w j) := vertsFrom_getD_succ 0 w j hj

theorem vtx_one (w : List Nat) (hn : 1 ≤ w.length) : vtx w 1 = unit (dir w 0) := by
  rw [vtx_succ w 0 (by omega), vtx_zero]; apply V3.ext' <;> simp

/-- the vertex function is determined by the recurrence -/
theorem vtx_eq_of_rec (w : List Nat) (g : Nat → V3) (h0 : g 0 = 0)
    (hs : ∀ j, j < w.length → g (j + 1) = g j + unit (dir w j)) :
    ∀ j, j ≤ w.length → vtx w j = g j := by
  intro j
  induction j with
  | zero => intro _; simp [h0]
  | succ j ih =>
    intro hj
    rw [vtx_succ w j (by omega), hs j (by omega), ih (by omega)]

theorem length_vset (w : List Nat) : (vset w).length = w.length := by
  simp [vset, length_verts]

theorem vset_getElem (w : List Nat) (j : Nat) (hj : j < (vset w).length) :
    (vset w)[j] = vtx w j := by
  have hj' : j < (verts w).length := by rw [length_verts]; rw [length_vset] at hj; omega
  simp only [vset, List.getElem_take, vtx]
  rw [List.getD_eq_getElem?_getD, List.getElem?_eq_getElem hj']
  rfl

theorem mem_vset (w : List Nat) (p : V3) : p ∈ vset w ↔ ∃ j, j < w.length ∧ vtx w j = p := by
  rw [List.mem_iff_getElem]
  constructor
  · rintro ⟨j, hj, h⟩
    refine ⟨j, by rw [length_vset] at hj; exact hj, ?_⟩
    rw [← vset_getElem w j hj]; exact h
  · rintro ⟨j, hj, h⟩
    have hj' : j < (vset w).length := by rw [length_vset]; exact hj
    exact ⟨j, hj', by rw [vset_getElem w j hj']; exact h⟩

theorem vtx_mem_vset (w : List Nat) (j : Nat) (hj : j < w.length) : vtx w j ∈ vset w :=
  (mem_vset w _).2 ⟨j, hj, rfl⟩

theorem nodup_vset (w : List Nat) :
    (vset w).Nodup ↔ ∀ i j, i < w.length → j < w.length → vtx w i = vtx w j → i = j := by
  unfold List.Nodup
  rw [List.pairwise_iff_getElem]
  constructor
  · intro h i j hi hj he
    have hi' : i < (vset w).length := by rw [length_vset]; exact hi
    have hj' : j < (vset w).length := by rw [length_vset]; exact hj
    have := h i j hi' hj'
    have := h j i hj' hi'
    rw [vset_getElem, vset_getElem] at *
    rcases Nat.lt_trichotomy i j with c | c | c
    · exact absurd he (by simp_all)
    · exact c
    · exact absurd he.symm (by simp_all)
  · intro h i j hi hj hij he
    rw [vset_getElem, vset_getElem] at he
    rw [length_vset] at hi hj
    have := h i j hi hj he
    omega

end Len52
