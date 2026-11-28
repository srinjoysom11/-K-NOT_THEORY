/-
  Lean42.Decide -- decidable versions of the intersection conditions.

  Phase 1 of PLAN.md.  The geometric conditions of `Simple` and of `DeltaMove` quantify over points
  of Q^3 (`PairOK`: "every common point of two edges is an endpoint of both"; "the triangle meets the
  polygon only in the edge").  Here they are turned into programs.

  Method.  A common point of two segments has parameters (t, s); a point of a segment and a triangle
  has parameters (t, u, v).  "There is a bad point" is then "there are parameters satisfying finitely
  many linear equalities and strict or non-strict inequalities", decided by `feasible` (FM.lean).
  * Two edges (p,q), (p',q') with p ≠ q, p' ≠ q' have a common point that is not an endpoint of both
    iff there are t, s ∈ [0,1] with p + t(q-p) = p' + s(q'-p') and 0 < t < 1, or the same with
    0 < s < 1: a point x = p + t(q-p) is an endpoint of [p,q] iff t ∈ {0,1}, because p ≠ q.
    (`not_pairOK_iff`, `pairOKb`, `simple_iff`.)
  * A point x of the triangle abc and of an edge e lies outside {a, b} iff for some coordinates i, j
    and signs x_i ≠ a_i and x_j ≠ b_j strictly; that is 36 linear systems in (t,u,v)
    (`freeB`, `freeB_iff`, `deltaMove_iff`).  For a simple polygon this is the condition of the
    Delta-move, because another edge meets the edge [a,b] only in a common endpoint.
-/
import Lean42.Polygon
import Lean42.FM
import Lean42.Lat
import Lean42.Delta

namespace Lean42

/-! ## Two segments -/

/-- the constraint `a t + b s + c ≤ 0` (`< 0` if `st`) in the two variables (t, s) -/
def c2 (a b c : ℚ) (st : Bool) : Con 2 := ⟨![a, b], c, st⟩

theorem c2_holds (a b c : ℚ) (st : Bool) (v : Fin 2 → ℚ) :
    (c2 a b c st).Holds v ↔
      (if st then a * v 0 + b * v 1 + c < 0 else a * v 0 + b * v 1 + c ≤ 0) := by
  unfold Con.Holds Con.val c2
  simp [Fin.sum_univ_two]

/-- the parameters (t, s) of a common point of two segments: 0 ≤ t, s ≤ 1 and the coordinates agree -/
def segSegSys (p q p' q' : Pt) : List (Con 2) :=
  [c2 (-1) 0 0 false, c2 1 0 (-1) false, c2 0 (-1) 0 false, c2 0 1 (-1) false] ++
  (List.finRange 3).flatMap fun i =>
    [c2 (q i - p i) (-(q' i - p' i)) (p i - p' i) false,
     c2 (-(q i - p i)) (q' i - p' i) (-(p i - p' i)) false]

theorem segSegSys_holds (p q p' q' : Pt) (v : Fin 2 → ℚ) :
    (∀ c ∈ segSegSys p q p' q', c.Holds v) ↔
      (0 ≤ v 0 ∧ v 0 ≤ 1 ∧ 0 ≤ v 1 ∧ v 1 ≤ 1 ∧
        ∀ i, p i + v 0 * (q i - p i) = p' i + v 1 * (q' i - p' i)) := by
  simp only [segSegSys, List.forall_mem_append, List.mem_cons, List.mem_flatMap,
    List.mem_finRange, true_and, forall_eq_or_imp, List.not_mem_nil, or_false,
    forall_exists_index, and_imp]
  have key : ∀ a b c : ℚ, (c2 a b c false).Holds v ↔ a * v 0 + b * v 1 + c ≤ 0 := by
    intro a b c; rw [c2_holds]; simp
  constructor
  · rintro ⟨⟨h1, h2, h3, h4⟩, h5⟩
    have h4' := h4 _ rfl
    rw [key] at h1 h2 h3 h4'
    refine ⟨by linarith, by linarith, by linarith, by linarith, fun i => ?_⟩
    have a := h5 _ i (Or.inl rfl)
    have b := h5 _ i (Or.inr rfl)
    rw [key] at a b
    linarith
  · rintro ⟨h1, h2, h3, h4, h5⟩
    refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_⟩
    · rw [key]; linarith
    · rw [key]; linarith
    · rw [key]; linarith
    · intro a ha; subst ha; rw [key]; linarith
    · intro x i hx
      have := h5 i
      rcases hx with rfl | rfl <;> rw [key] <;> linarith

/-- a common point of the segments with 0 < t < 1 -/
def sysA (p q p' q' : Pt) : List (Con 2) :=
  segSegSys p q p' q' ++ [c2 (-1) 0 0 true, c2 1 0 (-1) true]

/-- a common point of [p,q] and [p',q'] lying strictly inside [p,q] (in the parameter of the first
    segment) -/
def FeasA (p q p' q' : Pt) : Prop :=
  ∃ t s : ℚ, 0 < t ∧ t < 1 ∧ 0 ≤ s ∧ s ≤ 1 ∧
    ∀ i, p i + t * (q i - p i) = p' i + s * (q' i - p' i)

theorem feasA_iff (p q p' q' : Pt) : feasible 2 (sysA p q p' q') = true ↔ FeasA p q p' q' := by
  rw [feasible_iff]
  have key : ∀ (a b c : ℚ) (v : Fin 2 → ℚ), (c2 a b c true).Holds v ↔ a * v 0 + b * v 1 + c < 0 := by
    intro a b c v; rw [c2_holds]; simp
  constructor
  · rintro ⟨v, hv⟩
    have h1 := (segSegSys_holds p q p' q' v).1
      (fun c hc => hv c (by simp only [sysA, List.mem_append]; exact Or.inl hc))
    have h2 := hv (c2 (-1) 0 0 true) (by simp [sysA])
    have h3 := hv (c2 1 0 (-1) true) (by simp [sysA])
    rw [key] at h2 h3
    obtain ⟨-, -, a, b, e⟩ := h1
    exact ⟨v 0, v 1, by linarith, by linarith, a, b, e⟩
  · rintro ⟨t, s, ht0, ht1, hs0, hs1, h⟩
    refine ⟨![t, s], ?_⟩
    have h1 := (segSegSys_holds p q p' q' ![t, s]).2
      ⟨by simpa using ht0.le, by simpa using ht1.le, by simpa using hs0, by simpa using hs1,
        by simpa using h⟩
    intro c hc
    simp only [sysA, List.mem_append, List.mem_cons, List.not_mem_nil, or_false] at hc
    rcases hc with hc | rfl | rfl
    · exact h1 c hc
    · rw [key]; simp; linarith
    · rw [key]; simp; linarith

theorem not_end_of_mid {p q : Pt} {t : ℚ} (hpq : p ≠ q) (ht0 : 0 < t) (ht1 : t < 1) :
    p + t • (q - p) ≠ p ∧ p + t • (q - p) ≠ q := by
  constructor
  · intro h
    have h' : t • (q - p) = 0 := by simpa using h
    rcases smul_eq_zero.1 h' with h0 | h0
    · linarith
    · exact hpq (sub_eq_zero.1 h0).symm
  · intro h
    have h' : (1 - t) • (q - p) = 0 := by
      ext i
      have := congrFun h i
      simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul] at this ⊢
      simp only [Pi.zero_apply]
      linarith
    rcases smul_eq_zero.1 h' with h0 | h0
    · linarith
    · exact hpq (sub_eq_zero.1 h0).symm

theorem not_pairOK_iff {p q p' q' : Pt} (hpq : p ≠ q) (hpq' : p' ≠ q') :
    ¬ PairOK (p, q) (p', q') ↔ FeasA p q p' q' ∨ FeasA p' q' p q := by
  constructor
  · intro h
    unfold PairOK at h
    push_neg at h
    obtain ⟨x, hx, hx', hbad⟩ := h
    obtain ⟨t, ht0, ht1, rfl⟩ := mem_seg.1 hx
    obtain ⟨s, hs0, hs1, hxs⟩ := mem_seg.1 hx'
    have heq : ∀ i, p i + t * (q i - p i) = p' i + s * (q' i - p' i) := fun i => by
      have := congrFun hxs i
      simpa using this
    by_cases ht : 0 < t ∧ t < 1
    · exact Or.inl ⟨t, s, ht.1, ht.2, hs0, hs1, heq⟩
    · by_cases hs : 0 < s ∧ s < 1
      · exact Or.inr ⟨s, t, hs.1, hs.2, ht0, ht1, fun i => (heq i).symm⟩
      · exfalso
        have hx1 : (p + t • (q - p) = p ∨ p + t • (q - p) = q) := by
          rcases lt_or_eq_of_le ht0 with h | h
          · have : t = 1 := by
              by_contra hne
              exact ht ⟨h, lt_of_le_of_ne ht1 hne⟩
            right; rw [this]; simp
          · left; rw [← h]; simp
        have hx2 : (p + t • (q - p) = p' ∨ p + t • (q - p) = q') := by
          rw [hxs]
          rcases lt_or_eq_of_le hs0 with h | h
          · have : s = 1 := by
              by_contra hne
              exact hs ⟨h, lt_of_le_of_ne hs1 hne⟩
            right; rw [this]; simp
          · left; rw [← h]; simp
        exact (hbad hx1).1 (by rcases hx2 with h | h; exact h; exact absurd h (hbad hx1).2)
  · intro h hP
    rcases h with ⟨t, s, ht0, ht1, hs0, hs1, e⟩ | ⟨t, s, ht0, ht1, hs0, hs1, e⟩
    · have hx : p + t • (q - p) ∈ seg p q := mem_seg.2 ⟨t, ht0.le, ht1.le, rfl⟩
      have hx' : p + t • (q - p) ∈ seg p' q' := mem_seg.2 ⟨s, hs0, hs1, by
        ext i; simpa using e i⟩
      have := (hP _ hx hx').1
      have h2 := not_end_of_mid hpq ht0 ht1
      rcases this with h | h
      · exact h2.1 h
      · exact h2.2 h
    · have hx : p' + t • (q' - p') ∈ seg p' q' := mem_seg.2 ⟨t, ht0.le, ht1.le, rfl⟩
      have hx' : p' + t • (q' - p') ∈ seg p q := mem_seg.2 ⟨s, hs0, hs1, by
        ext i; simpa using e i⟩
      have := (hP _ hx' hx).2
      have h2 := not_end_of_mid hpq' ht0 ht1
      rcases this with h | h
      · exact h2.1 h
      · exact h2.2 h

/-- the decision procedure for `PairOK` of two edges with distinct endpoints -/
def pairOKb (p q p' q' : Pt) : Bool :=
  !(feasible 2 (sysA p q p' q') || feasible 2 (sysA p' q' p q))

theorem pairOKb_iff {p q p' q' : Pt} (hpq : p ≠ q) (hpq' : p' ≠ q') :
    pairOKb p q p' q' = true ↔ PairOK (p, q) (p', q') := by
  have := not_pairOK_iff hpq hpq'
  rw [← feasA_iff, ← feasA_iff] at this
  unfold pairOKb
  simp only [Bool.not_eq_true', Bool.or_eq_false_iff]
  constructor
  · intro h
    by_contra hc
    rcases this.1 hc with h1 | h1
    · simp [h1] at h
    · simp [h1] at h
  · intro h
    constructor
    · by_contra hc
      simp only [Bool.not_eq_false] at hc
      exact this.2 (Or.inl hc) h
    · by_contra hc
      simp only [Bool.not_eq_false] at hc
      exact this.2 (Or.inr hc) h

/-- decision procedure for `Simple` -/
def simpleB (L : List Pt) : Bool :=
  decide (3 ≤ L.length) && decide L.Nodup &&
    (edges L).all fun e => (edges L).all fun e' => decide (e = e') || pairOKb e.1 e.2 e'.1 e'.2

/-- **`Simple` is decidable**: the program `simpleB` decides it. -/
theorem simple_iff (L : List Pt) : Simple L ↔ simpleB L = true := by
  unfold Simple simpleB
  simp only [Bool.and_eq_true, decide_eq_true_eq, List.all_eq_true, Bool.or_eq_true]
  constructor
  · rintro ⟨h3, hnd, hp⟩
    refine ⟨⟨h3, hnd⟩, fun e he e' he' => ?_⟩
    by_cases hee : e = e'
    · exact Or.inl hee
    · right
      exact (pairOKb_iff (fun h => edges_no_swap hnd h3 he he h h.symm)
        (fun h => edges_no_swap hnd h3 he' he' h h.symm)).2 (hp e he e' he' hee)
  · rintro ⟨⟨h3, hnd⟩, h⟩
    refine ⟨h3, hnd, fun e he e' he' hne => ?_⟩
    rcases h e he e' he' with h | h
    · exact absurd h hne
    · exact (pairOKb_iff (fun h => edges_no_swap hnd h3 he he h h.symm)
        (fun h => edges_no_swap hnd h3 he' he' h h.symm)).1 h

instance : DecidablePred Simple := fun L => decidable_of_iff _ (simple_iff L).symm

/-! ## A triangle and an edge -/

/-- the constraint `a t + b u + c v + d ≤ 0` (`< 0` if `st`) in the variables (t, u, v) -/
def c3 (a b c d : ℚ) (st : Bool) : Con 3 := ⟨![a, b, c], d, st⟩

theorem c3_holds (a b c d : ℚ) (st : Bool) (w : Fin 3 → ℚ) :
    (c3 a b c d st).Holds w ↔
      (if st then a * w 0 + b * w 1 + c * w 2 + d < 0 else a * w 0 + b * w 1 + c * w 2 + d ≤ 0) := by
  unfold Con.Holds Con.val c3
  simp [Fin.sum_univ_three]

/-- parameters (t, u, v): the point `p + t (q - p)` of the segment `[p,q]` (0 ≤ t ≤ 1) is the point
    `a + u (b - a) + v (c - a)` of the triangle (u, v ≥ 0, u + v ≤ 1) -/
def triSegSys (a b c p q : Pt) : List (Con 3) :=
  [c3 (-1) 0 0 0 false, c3 1 0 0 (-1) false, c3 0 (-1) 0 0 false, c3 0 0 (-1) 0 false,
   c3 0 1 1 (-1) false] ++
  (List.finRange 3).flatMap fun i =>
    [c3 (q i - p i) (-(b i - a i)) (-(c i - a i)) (p i - a i) false,
     c3 (-(q i - p i)) (b i - a i) (c i - a i) (-(p i - a i)) false]

/-- the strict condition `x_i < r_i` (`sgn = false`) or `x_i > r_i` (`sgn = true`) for
    `x = p + t (q - p)` -/
def neC (p q r : Pt) (i : Fin 3) (sgn : Bool) : Con 3 :=
  if sgn then c3 (-(q i - p i)) 0 0 (r i - p i) true else c3 (q i - p i) 0 0 (p i - r i) true

theorem neC_holds (p q r : Pt) (i : Fin 3) (sgn : Bool) (w : Fin 3 → ℚ) :
    (neC p q r i sgn).Holds w ↔
      (if sgn then r i < p i + w 0 * (q i - p i) else p i + w 0 * (q i - p i) < r i) := by
  unfold neC
  cases sgn <;> simp only [c3_holds, if_true, Bool.false_eq_true, if_false] <;>
    constructor <;> intro h <;> linarith

theorem triSegSys_holds (a b c p q : Pt) (w : Fin 3 → ℚ) :
    (∀ k ∈ triSegSys a b c p q, k.Holds w) ↔
      (0 ≤ w 0 ∧ w 0 ≤ 1 ∧ 0 ≤ w 1 ∧ 0 ≤ w 2 ∧ w 1 + w 2 ≤ 1 ∧
        ∀ i, p i + w 0 * (q i - p i) = a i + w 1 * (b i - a i) + w 2 * (c i - a i)) := by
  simp only [triSegSys, List.forall_mem_append, List.mem_cons, List.mem_flatMap,
    List.mem_finRange, true_and, forall_eq_or_imp, List.not_mem_nil, or_false,
    forall_exists_index]
  have key : ∀ x y z d : ℚ, (c3 x y z d false).Holds w ↔ x * w 0 + y * w 1 + z * w 2 + d ≤ 0 := by
    intro x y z d; rw [c3_holds]; simp
  constructor
  · rintro ⟨⟨h1, h2, h3, h4, h5⟩, h6⟩
    have h5' := h5 _ rfl
    rw [key] at h1 h2 h3 h4 h5'
    refine ⟨by linarith, by linarith, by linarith, by linarith, by linarith, fun i => ?_⟩
    have a1 := h6 _ i (Or.inl rfl)
    have b1 := h6 _ i (Or.inr rfl)
    rw [key] at a1 b1
    linarith
  · rintro ⟨h1, h2, h3, h4, h5, h6⟩
    refine ⟨⟨?_, ?_, ?_, ?_, ?_⟩, ?_⟩
    · rw [key]; linarith
    · rw [key]; linarith
    · rw [key]; linarith
    · rw [key]; linarith
    · intro k hk; subst hk; rw [key]; linarith
    · intro x i hx
      have := h6 i
      rcases hx with rfl | rfl <;> rw [key] <;> linarith

/-- the directions of the strict inequalities -/
def choices : List (Fin 3 × Bool) := (List.finRange 3).flatMap fun i => [(i, false), (i, true)]

theorem mem_choices (i : Fin 3) (s : Bool) : (i, s) ∈ choices := by
  cases s <;> simp [choices]

/-- there is a point of the triangle `abc` and of the segment `[p,q]` different from `a` and `b` -/
def badB (a b c p q : Pt) : Bool :=
  choices.any fun c1 => choices.any fun c2 =>
    feasible 3 (triSegSys a b c p q ++ [neC p q a c1.1 c1.2, neC p q b c2.1 c2.2])

theorem badB_iff (a b c p q : Pt) :
    badB a b c p q = true ↔ ∃ x, x ∈ tri a b c ∧ x ∈ seg p q ∧ x ≠ a ∧ x ≠ b := by
  unfold badB
  simp only [List.any_eq_true, decide_eq_true_eq, feasible_iff]
  constructor
  · rintro ⟨c1, -, c2, -, w, hw⟩
    have hbase := (triSegSys_holds a b c p q w).1
      (fun k hk => hw k (List.mem_append.2 (Or.inl hk)))
    have h1 := hw (neC p q a c1.1 c1.2) (by simp)
    have h2 := hw (neC p q b c2.1 c2.2) (by simp)
    rw [neC_holds] at h1 h2
    obtain ⟨t0, t1, u0, v0, uv, heq⟩ := hbase
    refine ⟨p + w 0 • (q - p), mem_tri.2 ⟨w 1, w 2, u0, v0, uv, ?_⟩,
      mem_seg.2 ⟨w 0, t0, t1, rfl⟩, ?_, ?_⟩
    · ext i; simpa using heq i
    · intro h
      have := congrFun h c1.1
      simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul] at this
      cases hs : c1.2 <;> rw [hs] at h1 <;> simp at h1 <;> linarith
    · intro h
      have := congrFun h c2.1
      simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul] at this
      cases hs : c2.2 <;> rw [hs] at h2 <;> simp at h2 <;> linarith
  · rintro ⟨x, hx, hx', hxa, hxb⟩
    obtain ⟨u, v, hu, hv, huv, hxe⟩ := mem_tri.1 hx
    obtain ⟨t, ht0, ht1, hxt⟩ := mem_seg.1 hx'
    obtain ⟨i, hi⟩ := Function.ne_iff.1 hxa
    obtain ⟨j, hj⟩ := Function.ne_iff.1 hxb
    have hxi : x i = p i + t * (q i - p i) := by rw [hxt]; simp
    have hxj : x j = p j + t * (q j - p j) := by rw [hxt]; simp
    refine ⟨(i, decide (a i < x i)), mem_choices _ _, (j, decide (b j < x j)), mem_choices _ _,
      ![t, u, v], ?_⟩
    have hbase : ∀ k ∈ triSegSys a b c p q, k.Holds ![t, u, v] := by
      rw [triSegSys_holds]
      refine ⟨by simpa using ht0, by simpa using ht1, by simpa using hu, by simpa using hv,
        by simpa using huv, fun k => ?_⟩
      have := congrFun (hxt.symm.trans hxe) k
      simpa using this
    intro k hk
    rw [List.mem_append] at hk
    rcases hk with hk | hk
    · exact hbase k hk
    · simp only [List.mem_cons, List.not_mem_nil, or_false] at hk
      rcases hk with rfl | rfl
      · rw [neC_holds]
        simp only [Matrix.cons_val_zero]
        by_cases h : a i < x i
        · simp [h]; linarith
        · simp [h]; exact lt_of_le_of_ne (not_lt.1 h) hi |> fun h' => by linarith
      · rw [neC_holds]
        simp only [Matrix.cons_val_zero]
        by_cases h : b j < x j
        · simp [h]; linarith
        · simp [h]; exact lt_of_le_of_ne (not_lt.1 h) hj |> fun h' => by linarith

/-- the triangle `abc` meets the edge `e` at most in `a`, `b` -/
def freeB (a b c : Pt) (e : Pt × Pt) : Bool := !badB a b c e.1 e.2

theorem freeB_iff (a b c : Pt) (e : Pt × Pt) :
    freeB a b c e = true ↔ ∀ x, x ∈ tri a b c → x ∈ seg e.1 e.2 → x = a ∨ x = b := by
  unfold freeB
  rw [Bool.not_eq_true', ← Bool.not_eq_true, badB_iff]
  constructor
  · intro h x hx hx'
    by_contra hc
    push_neg at hc
    exact h ⟨x, hx, hx', hc.1, hc.2⟩
  · rintro h ⟨x, hx, hx', h1, h2⟩
    rcases h x hx hx' with h | h
    · exact h1 h
    · exact h2 h

/-- the decision procedure for the Delta-move of the first edge: both polygons are simple and the
    triangle meets every other edge only in `a`, `b`. -/
def deltaB (a b c : Pt) (R : List Pt) : Bool :=
  simpleB (a :: b :: R) && simpleB (a :: c :: b :: R) &&
    (edges (a :: b :: R)).all fun e => decide (e = (a, b)) || freeB a b c e

theorem deltaMove_cons_iff (a b c : Pt) (R : List Pt) :
    DeltaMove (a :: b :: R) (a :: c :: b :: R) ↔
      Simple (a :: b :: R) ∧ Simple (a :: c :: b :: R) ∧
        tri a b c ∩ pset (a :: b :: R) = seg a b := by
  constructor
  · rintro ⟨a', b', c', R', h1, h2, hP, hQ, hT⟩
    simp only [List.cons.injEq] at h1 h2
    obtain ⟨rfl, rfl, rfl⟩ := h1
    obtain ⟨-, rfl, -⟩ := h2
    exact ⟨hP, hQ, hT⟩
  · rintro ⟨hP, hQ, hT⟩
    exact ⟨a, b, c, R, rfl, rfl, hP, hQ, hT⟩

/-- **The Delta-move is decidable**: for the polygon `a :: b :: R` and the apex `c`, the move
    `a :: b :: R → a :: c :: b :: R` of `DeltaMove` is decided by the program `deltaB`. -/
theorem deltaMove_iff (a b c : Pt) (R : List Pt) :
    DeltaMove (a :: b :: R) (a :: c :: b :: R) ↔ deltaB a b c R = true := by
  rw [deltaMove_cons_iff]
  unfold deltaB
  simp only [Bool.and_eq_true, List.all_eq_true, Bool.or_eq_true, decide_eq_true_eq,
    ← simple_iff]
  have hab : (a, b) ∈ edges (a :: b :: R) := by rw [edges_cons_cons]; simp
  constructor
  · rintro ⟨hP, hQ, hT⟩
    refine ⟨⟨hP, hQ⟩, fun e he => ?_⟩
    by_cases hee : e = (a, b)
    · exact Or.inl hee
    · right
      rw [freeB_iff]
      intro x hx hxe
      have hxP : x ∈ tri a b c ∩ pset (a :: b :: R) := ⟨hx, e, he, hxe⟩
      rw [hT] at hxP
      exact (hP.2.2 (a, b) hab e he (Ne.symm hee) x hxP hxe).1
  · rintro ⟨⟨hP, hQ⟩, h⟩
    refine ⟨hP, hQ, ?_⟩
    ext x
    constructor
    · rintro ⟨hx, e, he, hxe⟩
      rcases h e he with h | h
      · rw [h] at hxe; exact hxe
      · rcases (freeB_iff a b c e).1 h x hx hxe with h' | h'
        · rw [h']; exact left_mem_seg a b
        · rw [h']; exact right_mem_seg a b
    · intro hx
      exact ⟨seg_subset_tri_ab a b c hx, (a, b), hab, hx⟩

#print axioms simple_iff
#print axioms deltaMove_iff
#print axioms feasible_iff

end Lean42
