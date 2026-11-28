/-
  Lean42.FM -- a verified decision procedure for finite systems of linear inequalities over ℚ.

  Why it is here.  Phase 1 asks for intersection predicates on rational segments and triangles
  that can be evaluated by a program (`decide`/compiled code) and are proved equivalent to the
  geometric definitions.  Every such predicate has the form
        "there are parameters t, s, u, v, ... in ℚ such that finitely many linear
         equalities and (strict or non-strict) inequalities hold",
  for instance "x ∈ seg p q ∩ seg p' q'" is "∃ t s, 0 ≤ t ≤ 1, 0 ≤ s ≤ 1, p + t(q-p) = p' + s(q'-p')".
  Instead of treating the many degenerate positions (parallel, collinear, touching, empty
  triangle) one by one, we decide the existence of the parameters by Fourier-Motzkin elimination,
  once and for all, and prove it correct here.

  The system.  A constraint in k variables is `∑ coef i * x i + const ≤ 0` (`strict = false`) or
  `< 0` (`strict = true`).  An equation is two constraints.

  Fourier-Motzkin step (`fm`).  Eliminate variable 0.  Split the constraints by the sign of the
  coefficient c0 of x0:
    * c0 = 0: keep the constraint, forgetting x0.
    * c0 > 0 (an upper bound  x0 ⋈ -P/c0, where P is the rest of the form): `pos`.
    * c0 < 0 (a lower bound   x0 ⋈ N/(-c0)): `neg`.
  Some x0 exists iff every lower bound is below every upper bound (strictly if either bound is
  strict); for a pair (p, n) this says  (-n0) * P + p0 * N ⋈ 0, a constraint without x0
  (`combine p n`).  `fm_correct` proves "∃ x, all hold ↔ ∃ y, all of fm cs hold"; the proof of
  "←" picks x0 between the largest lower and the smallest upper bound (`exists_between`).
  Iterating until no variable is left leaves constants, which are checked directly.
-/
import Lean42.Prelude

namespace Lean42

/-- A linear constraint `∑ coef i * x i + const ≤ 0` (`<` if `strict`) in `k` variables. -/
structure Con (k : ℕ) where
  coef : Fin k → ℚ
  const : ℚ
  strict : Bool

namespace Con

/-- the value of the affine form at x -/
def val {k : ℕ} (c : Con k) (x : Fin k → ℚ) : ℚ := ∑ i, c.coef i * x i + c.const

/-- x satisfies the constraint -/
def Holds {k : ℕ} (c : Con k) (x : Fin k → ℚ) : Prop :=
  if c.strict then c.val x < 0 else c.val x ≤ 0

/-- the constraint without the variable 0 -/
def tail {k : ℕ} (c : Con (k + 1)) : Con k := ⟨fun i => c.coef i.succ, c.const, c.strict⟩

theorem val_split {k : ℕ} (c : Con (k + 1)) (x : Fin (k + 1) → ℚ) :
    c.val x = c.coef 0 * x 0 + c.tail.val (Fin.tail x) := by
  simp only [val, tail, Fin.sum_univ_succ, Fin.tail]
  ring

/-- the constraint obtained by adding `(-n0) * p` and `p0 * n`, where p has coefficient
    p0 > 0 and n has coefficient n0 < 0 at the variable 0: the variable 0 cancels. -/
def combine {k : ℕ} (p n : Con (k + 1)) : Con k :=
  ⟨fun i => (-n.coef 0) * p.coef i.succ + p.coef 0 * n.coef i.succ,
   (-n.coef 0) * p.const + p.coef 0 * n.const, p.strict || n.strict⟩

theorem val_combine {k : ℕ} (p n : Con (k + 1)) (y : Fin k → ℚ) :
    (combine p n).val y = (-n.coef 0) * p.tail.val y + p.coef 0 * n.tail.val y := by
  simp only [val, combine, tail, add_mul, Finset.sum_add_distrib, mul_assoc, ← Finset.mul_sum]
  ring

end Con

/-- one step of Fourier-Motzkin elimination of the variable 0 -/
def fm {k : ℕ} (cs : List (Con (k + 1))) : List (Con k) :=
  (cs.filter (fun c => c.coef 0 = 0)).map Con.tail ++
    ((cs.filter (fun c => 0 < c.coef 0)).flatMap fun p =>
      (cs.filter (fun c => c.coef 0 < 0)).map (Con.combine p))

/-- A point between a family of lower bounds and a family of upper bounds.  A bound is a pair
    (value, strict?). -/
theorem exists_between (ups los : List (ℚ × Bool))
    (h : ∀ u ∈ ups, ∀ l ∈ los, l.1 < u.1 ∨ (l.1 = u.1 ∧ l.2 = false ∧ u.2 = false)) :
    ∃ x : ℚ, (∀ u ∈ ups, x < u.1 ∨ (x = u.1 ∧ u.2 = false)) ∧
             (∀ l ∈ los, l.1 < x ∨ (l.1 = x ∧ l.2 = false)) := by
  by_cases hu : ups = []
  · by_cases hl : los = []
    · exact ⟨0, by simp [hu], by simp [hl]⟩
    · obtain ⟨l0, hl0, hmax⟩ := Finset.exists_max_image los.toFinset (fun l => l.1)
        ((List.toFinset_nonempty_iff _).2 hl)
      refine ⟨l0.1 + 1, by simp [hu], fun l hlm => Or.inl ?_⟩
      have := hmax l (List.mem_toFinset.2 hlm)
      linarith
  · obtain ⟨u0, hu0, hmin⟩ := Finset.exists_min_image ups.toFinset (fun u => u.1)
      ((List.toFinset_nonempty_iff _).2 hu)
    have hu0' := List.mem_toFinset.1 hu0
    by_cases hl : los = []
    · refine ⟨u0.1 - 1, fun u hum => Or.inl ?_, by simp [hl]⟩
      have := hmin u (List.mem_toFinset.2 hum)
      linarith
    · obtain ⟨l0, hl0, hmax⟩ := Finset.exists_max_image los.toFinset (fun l => l.1)
        ((List.toFinset_nonempty_iff _).2 hl)
      have hl0' := List.mem_toFinset.1 hl0
      rcases h u0 hu0' l0 hl0' with hlt | ⟨heq, hl2, hu2⟩
      · refine ⟨(l0.1 + u0.1) / 2, fun u hum => Or.inl ?_, fun l hlm => Or.inl ?_⟩
        · have := hmin u (List.mem_toFinset.2 hum); simp only at this; linarith
        · have := hmax l (List.mem_toFinset.2 hlm); simp only at this; linarith
      · refine ⟨u0.1, fun u hum => ?_, fun l hlm => ?_⟩
        · have hm := hmin u (List.mem_toFinset.2 hum)
          simp only at hm
          rcases lt_or_eq_of_le hm with hlt | heq'
          · exact Or.inl hlt
          · right
            refine ⟨heq', ?_⟩
            rcases h u hum l0 hl0' with h1 | ⟨_, _, h3⟩
            · exfalso; linarith
            · exact h3
        · have hm := hmax l (List.mem_toFinset.2 hlm)
          simp only at hm
          rcases lt_or_eq_of_le hm with hlt | heq'
          · exact Or.inl (by linarith)
          · right
            refine ⟨by linarith, ?_⟩
            rcases h u0 hu0' l hlm with h1 | ⟨_, h2, _⟩
            · exfalso; linarith
            · exact h2

theorem holds_iff {k : ℕ} (c : Con k) (x : Fin k → ℚ) :
    c.Holds x ↔ (c.strict = true ∧ c.val x < 0) ∨ (c.strict = false ∧ c.val x ≤ 0) := by
  unfold Con.Holds
  cases h : c.strict <;> simp

/-- Soundness of the elimination step: a solution of the system gives one of `fm`. -/
theorem fm_sound {k : ℕ} (cs : List (Con (k + 1))) (x : Fin (k + 1) → ℚ)
    (hx : ∀ c ∈ cs, c.Holds x) : ∀ c ∈ fm cs, c.Holds (Fin.tail x) := by
  intro c hc
  simp only [fm, List.mem_append, List.mem_map, List.mem_filter, List.mem_flatMap,
    decide_eq_true_eq] at hc
  rcases hc with ⟨c0, ⟨hc0, hz⟩, rfl⟩ | ⟨p, ⟨hp, hpp⟩, n, ⟨hn, hnn⟩, rfl⟩
  · have h := hx c0 hc0
    have hv := Con.val_split c0 x
    rw [hz, zero_mul, zero_add] at hv
    rw [holds_iff] at h ⊢
    rw [← hv]
    exact h
  · have hP := hx p hp
    have hN := hx n hn
    rw [holds_iff] at hP hN ⊢
    have hpv := Con.val_split p x
    have hnv := Con.val_split n x
    rw [Con.val_combine]
    have key : (-n.coef 0) * p.tail.val (Fin.tail x) + p.coef 0 * n.tail.val (Fin.tail x)
        = (-n.coef 0) * p.val x + p.coef 0 * n.val x := by
      rw [hpv, hnv]; ring
    rw [key]
    have h1 : 0 < -n.coef 0 := by linarith
    simp only [Con.combine, Bool.or_eq_true]
    rcases hP with ⟨hs1, hv1⟩ | ⟨hs1, hv1⟩ <;> rcases hN with ⟨hs2, hv2⟩ | ⟨hs2, hv2⟩
    · left; refine ⟨by simp [hs1], ?_⟩; nlinarith
    · left; refine ⟨by simp [hs1], ?_⟩; nlinarith
    · left; refine ⟨by simp [hs2], ?_⟩; nlinarith
    · right; refine ⟨by simp [hs1, hs2], ?_⟩; nlinarith

/-- Completeness of the elimination step: a solution of `fm` extends to one of the system. -/
theorem fm_complete {k : ℕ} (cs : List (Con (k + 1))) (y : Fin k → ℚ)
    (hy : ∀ c ∈ fm cs, c.Holds y) : ∃ x : Fin (k + 1) → ℚ, ∀ c ∈ cs, c.Holds x := by
  let pos := cs.filter (fun c => 0 < c.coef 0)
  let neg := cs.filter (fun c => c.coef 0 < 0)
  let ups : List (ℚ × Bool) := pos.map fun p => (-(p.tail.val y) / p.coef 0, p.strict)
  let los : List (ℚ × Bool) := neg.map fun n => (n.tail.val y / (-(n.coef 0)), n.strict)
  have hcomb : ∀ p ∈ pos, ∀ n ∈ neg, (Con.combine p n).Holds y := by
    intro p hp n hn
    apply hy
    simp only [fm, List.mem_append, List.mem_flatMap]
    exact Or.inr ⟨p, hp, List.mem_map.2 ⟨n, hn, rfl⟩⟩
  have hpos : ∀ p ∈ pos, 0 < p.coef 0 := fun p hp => by
    simpa using (List.mem_filter.1 hp).2
  have hneg : ∀ n ∈ neg, n.coef 0 < 0 := fun n hn => by
    simpa using (List.mem_filter.1 hn).2
  have hb : ∀ u ∈ ups, ∀ l ∈ los, l.1 < u.1 ∨ (l.1 = u.1 ∧ l.2 = false ∧ u.2 = false) := by
    intro u hu l hl
    obtain ⟨p, hp, rfl⟩ := List.mem_map.1 hu
    obtain ⟨n, hn, rfl⟩ := List.mem_map.1 hl
    have h := hcomb p hp n hn
    rw [holds_iff, Con.val_combine] at h
    have h0 := hpos p hp
    have h1 := hneg n hn
    have h2 : 0 < -n.coef 0 := by linarith
    simp only [Con.combine, Bool.or_eq_true]  at h
    have e1 : n.tail.val y / (-n.coef 0) < -p.tail.val y / p.coef 0 ↔
        (-n.coef 0) * p.tail.val y + p.coef 0 * n.tail.val y < 0 := by
      rw [div_lt_div_iff₀ h2 h0]
      constructor <;> intro h <;> nlinarith
    have e2 : n.tail.val y / (-n.coef 0) ≤ -p.tail.val y / p.coef 0 ↔
        (-n.coef 0) * p.tail.val y + p.coef 0 * n.tail.val y ≤ 0 := by
      rw [div_le_div_iff₀ h2 h0]
      constructor <;> intro h <;> nlinarith
    rcases h with ⟨hs, hv⟩ | ⟨hs, hv⟩
    · left; exact e1.2 hv
    · have hs' : p.strict = false ∧ n.strict = false := by simpa using hs
      rcases lt_or_eq_of_le (e2.2 hv) with hlt | heq
      · left; exact hlt
      · right; exact ⟨heq, hs'.2, hs'.1⟩
  obtain ⟨x0, hup, hlo⟩ := exists_between ups los hb
  refine ⟨Fin.cons x0 y, fun c hc => ?_⟩
  have hsplit := Con.val_split c (Fin.cons x0 y : Fin (k + 1) → ℚ)
  simp only [Fin.cons_zero, Fin.tail_cons] at hsplit
  rcases lt_trichotomy (c.coef 0) 0 with hlt | heq | hgt
  · -- lower bound
    have hcn : c ∈ neg := List.mem_filter.2 ⟨hc, by simpa using hlt⟩
    have := hlo (c.tail.val y / (-(c.coef 0)), c.strict) (List.mem_map.2 ⟨c, hcn, rfl⟩)
    rw [holds_iff, hsplit]
    have h2 : 0 < -c.coef 0 := by linarith
    simp only at this
    rcases this with hl | ⟨hl, hs⟩
    · rw [div_lt_iff₀ h2] at hl
      cases hs : c.strict
      · right; exact ⟨rfl, by nlinarith⟩
      · left; exact ⟨rfl, by nlinarith⟩
    · rw [div_eq_iff h2.ne'] at hl
      right; exact ⟨hs, by nlinarith⟩
  · have hct : c.tail ∈ fm cs := by
      simp only [fm, List.mem_append, List.mem_map, List.mem_filter]
      exact Or.inl ⟨c, ⟨hc, by simpa using heq⟩, rfl⟩
    have h := hy _ hct
    rw [holds_iff] at h ⊢
    rw [hsplit, heq, zero_mul, zero_add]
    simpa [Con.tail] using h
  · have hcp : c ∈ pos := List.mem_filter.2 ⟨hc, by simpa using hgt⟩
    have := hup (-(c.tail.val y) / c.coef 0, c.strict) (List.mem_map.2 ⟨c, hcp, rfl⟩)
    rw [holds_iff, hsplit]
    simp only at this
    rcases this with hl | ⟨hl, hs⟩
    · rw [lt_div_iff₀ hgt] at hl
      cases hs : c.strict
      · right; exact ⟨rfl, by nlinarith⟩
      · left; exact ⟨rfl, by nlinarith⟩
    · rw [eq_div_iff hgt.ne'] at hl
      right; exact ⟨hs, by nlinarith⟩

/-- **Fourier-Motzkin decision procedure**: the program `feasible k cs` returns `true` exactly when
    the system `cs` of linear constraints in `k` variables has a rational solution. -/
def feasible : (k : ℕ) → List (Con k) → Bool
  | 0, cs => cs.all fun c => if c.strict then decide (c.const < 0) else decide (c.const ≤ 0)
  | k + 1, cs => feasible k (fm cs)

theorem feasible_iff : ∀ (k : ℕ) (cs : List (Con k)),
    feasible k cs = true ↔ ∃ x : Fin k → ℚ, ∀ c ∈ cs, c.Holds x := by
  intro k
  induction k with
  | zero =>
    intro cs
    simp only [feasible, List.all_eq_true]
    constructor
    · intro h
      refine ⟨fun i => i.elim0, fun c hc => ?_⟩
      have := h c hc
      simp only [Con.Holds, Con.val, Finset.univ_eq_empty, Finset.sum_empty, zero_add]
      cases hs : c.strict <;> simpa [hs] using this
    · rintro ⟨x, hx⟩ c hc
      have := hx c hc
      simp only [Con.Holds, Con.val, Finset.univ_eq_empty, Finset.sum_empty, zero_add] at this
      cases hs : c.strict <;> simpa [hs] using (by simpa [hs] using this)
  | succ k ih =>
    intro cs
    simp only [feasible]
    rw [ih]
    constructor
    · rintro ⟨y, hy⟩
      exact fm_complete cs y hy
    · rintro ⟨x, hx⟩
      exact ⟨Fin.tail x, fm_sound cs x hx⟩

/-- The existence of a rational solution of a finite linear system is decidable. -/
instance decidableSolvable (k : ℕ) (cs : List (Con k)) :
    Decidable (∃ x : Fin k → ℚ, ∀ c ∈ cs, c.Holds x) :=
  decidable_of_iff _ (feasible_iff k cs)

end Lean42
