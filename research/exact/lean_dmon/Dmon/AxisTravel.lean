/-
  Dmon.AxisTravel — soundness of the search test D2 ("axis-ordered travel", flags -aot, -aotm, -aotc of
  enum_dmon.cpp / enum_bidir.cpp; DMON_RESULTS.md section D2).

  What the test says.  A two-ended prefix of the word w = p ++ q ++ t consists of the head letters p (from the
  root to the head end h) and the tail letters t (from the tail end e to the root); the middle part q, which is
  still missing, is a walk from h to e.  (The one-ended search of enum_dmon.cpp is the case t = [], e = root = 0;
  enum_bidir.cpp, used for n = 40 and n = 42, is the general case.)  Let c_A be the number of letters of p ++ t
  along axis A.  The middle part must (i) visit every "single site" (a point that must still become a vertex),
  (ii) visit one site of every "multi-site obligation", (iii) take at least `cdef A` letters along A (with -aotc:
  the plane crossings still owed on A).  Hence along every axis A it takes at least t_A letters, where t_A is the
  length of the shortest 1-dimensional walk from the coordinate of h that visits the extreme values and ends at
  the coordinate of e.  The final counts are even and ordered z <= y <= x (the axis rule), so the total length is
  at least z' + y' + x' with z' = L_z, y' = max(L_y, z'), x' = max(L_x, y'), L_A = (c_A + t_A) rounded up to an
  even number.  The test rejects the prefix if that sum exceeds N.

  `AotOk` below is that test, written as in `aot_ok` / `axis_need` of enum_bidir.cpp (and, for t = [], e = 0, of
  enum_dmon.cpp).  `aot_sound` says: if the prefix can be completed to a polygon word of length N that satisfies
  the axis rule, whose middle part visits the sites and takes `cdef A` letters along A, then the test accepts.
  So the test never removes a word of the search.

  Inputs that are NOT proved here (they are properties of the obligations produced by the rest of the search,
  and appear as hypotheses): (i)-(iii).  In particular `cdef` is only assumed to be a lower bound
  for the number of future letters along A (for -aotc it is the plane-crossing debt of PROOF.md Lemma 3, a
  topological statement valid for -prime / -stair).  The variants -aotx and -aott are not covered.
-/
import Dmon.Walk

namespace Dmon
open Len52

/-! ## Visits -/

theorem head_mem (h : V3) (q : List Nat) : h ∈ vertsFrom h q := by
  cases q <;> simp [vertsFrom]

theorem end_mem (q : List Nat) : ∀ h : V3, endpt h q ∈ vertsFrom h q := by
  induction q with
  | nil => intro h; simp [vertsFrom, endpt]
  | cons d ds ih =>
    intro h
    have e : endpt h (d :: ds) = endpt (h + unit d) ds := rfl
    rw [e]; simp only [vertsFrom]; exact List.mem_cons_of_mem _ (ih _)

theorem visit_split (q : List Nat) : ∀ (h s : V3), s ∈ vertsFrom h q →
    ∃ q1 q2, q = q1 ++ q2 ∧ endpt h q1 = s := by
  induction q with
  | nil =>
    intro h s hs
    simp only [vertsFrom, List.mem_singleton] at hs
    exact ⟨[], [], rfl, by simp [endpt, hs]⟩
  | cons d ds ih =>
    intro h s hs
    simp only [vertsFrom, List.mem_cons] at hs
    rcases hs with hs | hs
    · exact ⟨[], d :: ds, rfl, by simp [endpt, hs]⟩
    · obtain ⟨q1, q2, e, hq⟩ := ih _ _ hs
      exact ⟨d :: q1, q2, by simp [e], hq⟩

/-- two visited points are visited one after the other -/
theorem two_visits (q : List Nat) (h u v : V3) (hu : u ∈ vertsFrom h q) (hv : v ∈ vertsFrom h q) :
    ∃ a b c, q = a ++ b ++ c ∧
      ((endpt h a = u ∧ endpt h (a ++ b) = v) ∨ (endpt h a = v ∧ endpt h (a ++ b) = u)) := by
  obtain ⟨q1, q2, e1, hu'⟩ := visit_split q h u hu
  obtain ⟨r1, r2, e2, hv'⟩ := visit_split q h v hv
  have e : q1 ++ q2 = r1 ++ r2 := e1.symm.trans e2
  rcases List.append_eq_append_iff.mp e with ⟨a', hr1, hq2⟩ | ⟨c', hq1, hr2⟩
  · refine ⟨q1, a', r2, ?_, Or.inl ⟨hu', ?_⟩⟩
    · rw [e1, hq2]; simp
    · rw [← hr1]; exact hv'
  · refine ⟨r1, c', q2, ?_, Or.inr ⟨hv', ?_⟩⟩
    · rw [e2, hr2]; simp
    · rw [← hq1]; exact hu'

/-! ## The one-dimensional travel bound -/

/-- the cost of the one-dimensional walk from c0 that visits l (lowest) and H (highest) and ends at ct,
    in the two possible orders; l <= c0, l <= ct, c0 <= H, ct <= H -/
def travel (c0 ct l H : Int) : Int := min ((c0 - l) + (H - l) + (H - ct)) ((H - c0) + (H - l) + (ct - l))

theorem travel_two (A : Nat) (hA : A < 3) (q : List Nat) (hq : ∀ d ∈ q, d < 6) (h u v : V3)
    (hu : u ∈ vertsFrom h q) (hv : v ∈ vertsFrom h q) :
    (((coord A h - coord A u).natAbs + (coord A u - coord A v).natAbs +
        (coord A v - coord A (endpt h q)).natAbs : Nat) ≤ countAxis A q) ∨
    (((coord A h - coord A v).natAbs + (coord A v - coord A u).natAbs +
        (coord A u - coord A (endpt h q)).natAbs : Nat) ≤ countAxis A q) := by
  obtain ⟨a, b, c, e, h12⟩ := two_visits q h u v hu hv
  subst e
  have ha : ∀ d ∈ a, d < 6 := fun d hd => hq d (by simp [hd])
  have hb : ∀ d ∈ b, d < 6 := fun d hd => hq d (by simp [hd])
  have hc : ∀ d ∈ c, d < 6 := fun d hd => hq d (by simp [hd])
  have e3 : endpt h (a ++ b ++ c) = endpt (endpt h (a ++ b)) c := endpt_append h (a ++ b) c
  have e2 : endpt h (a ++ b) = endpt (endpt h a) b := endpt_append h a b
  have c3 : countAxis A (a ++ b ++ c) = countAxis A a + countAxis A b + countAxis A c := by
    rw [countAxis_append, countAxis_append]
  obtain ⟨a1, a2, _⟩ := coord_bound A hA a h ha
  obtain ⟨b1, b2, _⟩ := coord_bound A hA b (endpt h a) hb
  obtain ⟨c1, c2, _⟩ := coord_bound A hA c (endpt h (a ++ b)) hc
  rw [← e2] at b1 b2
  rw [← e3] at c1 c2
  rw [c3]
  rcases h12 with ⟨r1, r2⟩ | ⟨r1, r2⟩
  · left
    have x1 : coord A (endpt h a) = coord A u := by rw [r1]
    have x2 : coord A (endpt h (a ++ b)) = coord A v := by rw [r2]
    omega
  · right
    have x1 : coord A (endpt h a) = coord A v := by rw [r1]
    have x2 : coord A (endpt h (a ++ b)) = coord A u := by rw [r2]
    omega

/-- a walk that starts at h, ends on coordinate ct, and visits points with coordinates l and H
    needs at least `travel (coord h) ct l H` letters along A -/
theorem extreme_bound (A : Nat) (hA : A < 3) (q : List Nat) (hq : ∀ d ∈ q, d < 6) (h : V3)
    (ct l H : Int) (hl : ∃ u ∈ vertsFrom h q, coord A u = l) (hH : ∃ v ∈ vertsFrom h q, coord A v = H)
    (h0 : coord A (endpt h q) = ct) (hlc : l ≤ coord A h) (hlt : l ≤ ct)
    (hHc : coord A h ≤ H) (hHt : ct ≤ H) :
    travel (coord A h) ct l H ≤ (countAxis A q : Int) := by
  obtain ⟨u, hu, ul⟩ := hl
  obtain ⟨v, hv, vH⟩ := hH
  unfold travel
  rcases travel_two A hA q hq h u v hu hv with t | t
  · rw [h0, ul, vH] at t; omega
  · rw [h0, ul, vH] at t; omega

/-! ## Minimum and maximum over the sites are attained at visited points -/

theorem foldl_min_attained (A : Nat) (V : List V3) (S : List V3) (hS : ∀ s ∈ S, s ∈ V) :
    ∀ init : Int, (∃ v ∈ V, coord A v = init) →
      (∃ v ∈ V, coord A v = S.foldl (fun m s => min m (coord A s)) init) ∧
      S.foldl (fun m s => min m (coord A s)) init ≤ init := by
  induction S with
  | nil => intro init hi; exact ⟨hi, Int.le_refl _⟩
  | cons s ss ih =>
    intro init hi
    have hs : s ∈ V := hS s (List.mem_cons_self ..)
    have hss : ∀ t ∈ ss, t ∈ V := fun t ht => hS t (List.mem_cons_of_mem _ ht)
    have hi' : ∃ v ∈ V, coord A v = min init (coord A s) := by
      by_cases hle : init ≤ coord A s
      · rw [Int.min_eq_left hle]; exact hi
      · rw [Int.min_eq_right (by omega)]; exact ⟨s, hs, rfl⟩
    obtain ⟨r1, r2⟩ := ih hss _ hi'
    exact ⟨r1, by simp only [List.foldl] at r2 ⊢; omega⟩

theorem foldl_max_attained (A : Nat) (V : List V3) (S : List V3) (hS : ∀ s ∈ S, s ∈ V) :
    ∀ init : Int, (∃ v ∈ V, coord A v = init) →
      (∃ v ∈ V, coord A v = S.foldl (fun m s => max m (coord A s)) init) ∧
      init ≤ S.foldl (fun m s => max m (coord A s)) init := by
  induction S with
  | nil => intro init hi; exact ⟨hi, Int.le_refl _⟩
  | cons s ss ih =>
    intro init hi
    have hs : s ∈ V := hS s (List.mem_cons_self ..)
    have hss : ∀ t ∈ ss, t ∈ V := fun t ht => hS t (List.mem_cons_of_mem _ ht)
    have hi' : ∃ v ∈ V, coord A v = max init (coord A s) := by
      by_cases hle : init ≤ coord A s
      · rw [Int.max_eq_right hle]; exact ⟨s, hs, rfl⟩
      · rw [Int.max_eq_left (by omega)]; exact hi
    obtain ⟨r1, r2⟩ := ih hss _ hi'
    exact ⟨r1, by simp only [List.foldl] at r2 ⊢; omega⟩

theorem foldl_min_le {α : Type} (f : α → Int) (xs : List α) :
    ∀ (init : Int) (x : α), x ∈ xs → xs.foldl (fun m a => min m (f a)) init ≤ f x := by
  induction xs with
  | nil => intro init x hx; simp at hx
  | cons y ys ih =>
    intro init x hx
    simp only [List.foldl]
    rcases List.mem_cons.mp hx with rfl | hx
    · have key : ∀ (zs : List α) (m : Int), zs.foldl (fun m a => min m (f a)) m ≤ m := by
        intro zs; induction zs with
        | nil => intro m; exact Int.le_refl _
        | cons z zs ih2 => intro m; simp only [List.foldl]; exact Int.le_trans (ih2 _) (Int.min_le_left _ _)
      exact Int.le_trans (key ys _) (Int.min_le_right _ _)
    · exact ih _ x hx

theorem foldl_max_le {α : Type} (f : α → Int) (xs : List α) (K : Int) :
    (∀ x ∈ xs, f x ≤ K) → ∀ init : Int, init ≤ K → xs.foldl (fun m a => max m (f a)) init ≤ K := by
  induction xs with
  | nil => intro _ init hi; exact hi
  | cons y ys ih =>
    intro hx init hi
    simp only [List.foldl]
    exact ih (fun x hx' => hx x (List.mem_cons_of_mem _ hx')) _
      (Int.max_le.mpr ⟨hi, hx y (List.mem_cons_self ..)⟩)

/-! ## The test as in enum_bidir.cpp (`axis_need`, `aot_ok`) -/

/-- lowest / highest coordinate along A of the single sites and the tail end (coordinate ct) -/
def loA (A : Nat) (ct : Int) (S : List V3) : Int := S.foldl (fun m s => min m (coord A s)) ct
def hiA (A : Nat) (ct : Int) (S : List V3) : Int := S.foldl (fun m s => max m (coord A s)) ct

/-- the multi-site bound (-aotm): the cheapest choice of the site of the obligation `ob` -/
def bestA (A : Nat) (c0 ct l H : Int) (ob : List V3) : Int :=
  ob.foldl (fun m s => min m (travel c0 ct (min (coord A s) l) (max (coord A s) H))) 1048576

/-- lower bound t_A for the number of letters of the middle part along A (`axis_need`, plus -aotc).
    h = head end, ct = coordinate of the tail end, `cd` = cdef[A], `useM` = -aotm, `useC` = -aotc. -/
def tA (A : Nat) (h : V3) (ct : Int) (S : List V3) (multis : List (List V3)) (cd : Int)
    (useM useC : Bool) : Int :=
  let c0 := coord A h
  let l := min (loA A ct S) c0
  let H := max (hiA A ct S) c0
  let t0 := travel c0 ct l H
  let t1 := if useM then multis.foldl (fun t ob => max t (bestA A c0 ct l H ob)) t0 else t0
  if useC then max t1 cd else t1

/-- the test: true = the prefix survives.  N = target length, p = head letters, t = tail letters,
    e = tail end (the vertex where the tail letters start), S = single sites, multis = multi-site
    obligations, cdef = plane-crossing debts per axis (0 = x, 1 = y, 2 = z).
    (One-ended search: t = [], e = 0.) -/
def AotOk (p t : List Nat) (e : V3) (N : Nat) (S : List V3) (multis : List (List V3))
    (cdef : Nat → Int) (useM useC : Bool) : Prop :=
  let h := endpt 0 p
  let L := fun A : Nat =>
    let f := ((countAxis A p + countAxis A t : Nat) : Int) + tA A h (coord A e) S multis (cdef A) useM useC
    f + f % 2
  let z := L 2
  let y := max (L 1) z
  let x := max (L 0) y
  x + y + z ≤ (N : Int)

instance (p t : List Nat) (e : V3) (N : Nat) (S : List V3) (multis : List (List V3))
    (cdef : Nat → Int) (useM useC : Bool) : Decidable (AotOk p t e N S multis cdef useM useC) := by
  unfold AotOk; infer_instance

/-! ## Soundness, axis by axis -/

theorem tA_le (A : Nat) (hA : A < 3) (h : V3) (q : List Nat) (hq : ∀ d ∈ q, d < 6) (ct : Int)
    (hend : coord A (endpt h q) = ct)
    (S : List V3) (multis : List (List V3)) (cd : Int) (useM useC : Bool)
    (hS : ∀ s ∈ S, s ∈ vertsFrom h q)
    (hM : ∀ ob ∈ multis, ∃ s ∈ ob, s ∈ vertsFrom h q)
    (hC : cd ≤ countAxis A q) :
    tA A h ct S multis cd useM useC ≤ (countAxis A q : Int) := by
  have hendv : ∃ v ∈ vertsFrom h q, coord A v = ct := ⟨endpt h q, end_mem q h, hend⟩
  have hhead : ∃ v ∈ vertsFrom h q, coord A v = coord A h := ⟨h, head_mem h q, rfl⟩
  obtain ⟨loAtt, loLe⟩ := foldl_min_attained A (vertsFrom h q) S hS ct hendv
  obtain ⟨hiAtt, hiGe⟩ := foldl_max_attained A (vertsFrom h q) S hS ct hendv
  have lAtt : ∃ v ∈ vertsFrom h q, coord A v = min (loA A ct S) (coord A h) := by
    by_cases hle : loA A ct S ≤ coord A h
    · rw [Int.min_eq_left hle]; exact loAtt
    · rw [Int.min_eq_right (by omega)]; exact hhead
  have HAtt : ∃ v ∈ vertsFrom h q, coord A v = max (hiA A ct S) (coord A h) := by
    by_cases hle : hiA A ct S ≤ coord A h
    · rw [Int.max_eq_right hle]; exact hhead
    · rw [Int.max_eq_left (by omega)]; exact hiAtt
  have loLe' : loA A ct S ≤ ct := loLe
  have hiGe' : ct ≤ hiA A ct S := hiGe
  have t0 : travel (coord A h) ct (min (loA A ct S) (coord A h)) (max (hiA A ct S) (coord A h)) ≤
      (countAxis A q : Int) :=
    extreme_bound A hA q hq h ct _ _ lAtt HAtt hend (Int.min_le_right _ _)
      (Int.le_trans (Int.min_le_left _ _) loLe') (Int.le_max_right _ _)
      (Int.le_trans hiGe' (Int.le_max_left _ _))
  unfold tA
  simp only []
  have t1 : (if useM then multis.foldl (fun t ob => max t (bestA A (coord A h) ct (min (loA A ct S) (coord A h))
        (max (hiA A ct S) (coord A h)) ob))
          (travel (coord A h) ct (min (loA A ct S) (coord A h)) (max (hiA A ct S) (coord A h)))
      else travel (coord A h) ct (min (loA A ct S) (coord A h)) (max (hiA A ct S) (coord A h))) ≤
      (countAxis A q : Int) := by
    by_cases hm : useM
    · simp only [hm, if_true]
      apply foldl_max_le _ _ _ _ _ t0
      intro ob hob
      obtain ⟨s, hs, hsV⟩ := hM ob hob
      have hbest : bestA A (coord A h) ct (min (loA A ct S) (coord A h)) (max (hiA A ct S) (coord A h)) ob ≤
          travel (coord A h) ct (min (coord A s) (min (loA A ct S) (coord A h)))
            (max (coord A s) (max (hiA A ct S) (coord A h))) :=
        foldl_min_le (fun s => travel (coord A h) ct (min (coord A s) (min (loA A ct S) (coord A h)))
            (max (coord A s) (max (hiA A ct S) (coord A h)))) ob 1048576 s hs
      refine Int.le_trans hbest ?_
      have l2 : ∃ v ∈ vertsFrom h q, coord A v = min (coord A s) (min (loA A ct S) (coord A h)) := by
        by_cases hle : coord A s ≤ min (loA A ct S) (coord A h)
        · rw [Int.min_eq_left hle]; exact ⟨s, hsV, rfl⟩
        · rw [Int.min_eq_right (by omega)]; exact lAtt
      have H2 : ∃ v ∈ vertsFrom h q, coord A v = max (coord A s) (max (hiA A ct S) (coord A h)) := by
        by_cases hle : coord A s ≤ max (hiA A ct S) (coord A h)
        · rw [Int.max_eq_right hle]; exact HAtt
        · rw [Int.max_eq_left (by omega)]; exact ⟨s, hsV, rfl⟩
      have m1 := Int.min_le_right (coord A s) (min (loA A ct S) (coord A h))
      have m2 := Int.min_le_left (loA A ct S) (coord A h)
      have m3 := Int.min_le_right (loA A ct S) (coord A h)
      have M1 := Int.le_max_right (coord A s) (max (hiA A ct S) (coord A h))
      have M2 := Int.le_max_left (hiA A ct S) (coord A h)
      have M3 := Int.le_max_right (hiA A ct S) (coord A h)
      have m4 := Int.min_le_left (coord A s) (min (loA A ct S) (coord A h))
      have M4 := Int.le_max_left (coord A s) (max (hiA A ct S) (coord A h))
      exact extreme_bound A hA q hq h ct _ _ l2 H2 hend (by omega) (by omega) (by omega) (by omega)
    · simp only [hm]; exact t0
  by_cases hc : useC
  · simp only [hc, if_true]; exact Int.max_le.mpr ⟨t1, by exact_mod_cast hC⟩
  · simp only [hc]; exact t1

/-! ## Closed words: parity and the sum of the three axis counts -/

theorem coord_zero (A : Nat) : coord A (0 : V3) = 0 := by
  by_cases h0 : A = 0 <;> by_cases h1 : A = 1 <;> simp [coord, h0, h1]

theorem getD_vertsFrom (w : List Nat) : ∀ (v : V3) (i : Nat), i ≤ w.length →
    (vertsFrom v w).getD i 0 = endpt v (w.take i) := by
  induction w with
  | nil => intro v i hi; have : i = 0 := by simp at hi; omega
           subst this; simp [vertsFrom, endpt]
  | cons d ds ih =>
    intro v i hi
    cases i with
    | zero => simp [vertsFrom, endpt]
    | succ i =>
      have hi' : i ≤ ds.length := by simp at hi; omega
      simp only [vertsFrom, List.getD_cons_succ, List.take_succ_cons]
      exact ih _ _ hi'

theorem vtx_eq_endpt (w : List Nat) (i : Nat) (hi : i ≤ w.length) : vtx w i = endpt 0 (w.take i) :=
  getD_vertsFrom w 0 i hi

theorem count_even (A : Nat) (hA : A < 3) (w : List Nat) (hw : ∀ d ∈ w, d < 6)
    (hclosed : endpt 0 w = 0) : countAxis A w % 2 = 0 := by
  obtain ⟨_, _, h3⟩ := coord_bound A hA w 0 hw
  rw [hclosed, coord_zero] at h3
  omega

theorem count_sum (w : List Nat) (hw : ∀ d ∈ w, d < 6) :
    countAxis 0 w + countAxis 1 w + countAxis 2 w = w.length := by
  induction w with
  | nil => simp [countAxis]
  | cons d ds ih =>
    have hd : d < 6 := hw d (List.mem_cons_self ..)
    have ih := ih (fun e he => hw e (List.mem_cons_of_mem _ he))
    simp only [countAxis_cons, List.length_cons]
    have h3 : axis d = 0 ∨ axis d = 1 ∨ axis d = 2 := by unfold axis; omega
    rcases h3 with h | h | h <;> simp [h] <;> omega

/-! ## Soundness of the test -/

/-- If w = p ++ q ++ t is a polygon word of length N with ordered axis counts, whose middle part q (from the
    head end h = endpt 0 p to the tail end e) visits the single sites, one site of every multi-site
    obligation, and has at least cdef A letters along A, then the test accepts the prefix (p, t). -/
theorem aot_sound (p q t : List Nat) (N : Nat) (S : List V3) (multis : List (List V3))
    (cdef : Nat → Int) (useM useC : Bool)
    (hpoly : IsPolygon (p ++ q ++ t)) (hN : (p ++ q ++ t).length = N)
    (hax : countAxis 2 (p ++ q ++ t) ≤ countAxis 1 (p ++ q ++ t) ∧
           countAxis 1 (p ++ q ++ t) ≤ countAxis 0 (p ++ q ++ t))
    (hS : ∀ s ∈ S, s ∈ vertsFrom (endpt 0 p) q)
    (hM : ∀ ob ∈ multis, ∃ s ∈ ob, s ∈ vertsFrom (endpt 0 p) q)
    (hC : ∀ A, A < 3 → cdef A ≤ (countAxis A q : Int)) :
    AotOk p t (endpt (endpt 0 p) q) N S multis cdef useM useC := by
  obtain ⟨_, hw6, hcl, _⟩ := hpoly
  have hq6 : ∀ d ∈ q, d < 6 := fun d hd => hw6 d (by simp [hd])
  have hclosed : endpt 0 (p ++ q ++ t) = 0 := by
    have := vtx_eq_endpt (p ++ q ++ t) (p ++ q ++ t).length (Nat.le_refl _)
    rw [List.take_length] at this
    rw [← this]; exact hcl
  have key : ∀ A, A < 3 →
      (((countAxis A p + countAxis A t : Nat) : Int) +
          tA A (endpt 0 p) (coord A (endpt (endpt 0 p) q)) S multis (cdef A) useM useC) +
        (((countAxis A p + countAxis A t : Nat) : Int) +
          tA A (endpt 0 p) (coord A (endpt (endpt 0 p) q)) S multis (cdef A) useM useC) % 2 ≤
        (countAxis A (p ++ q ++ t) : Int) := by
    intro A hA
    have tl := tA_le A hA (endpt 0 p) q hq6 _ rfl S multis (cdef A) useM useC hS hM
      (by have := hC A hA; omega)
    have ev := count_even A hA (p ++ q ++ t) hw6 hclosed
    rw [countAxis_append, countAxis_append] at ev ⊢
    omega
  have k0 := key 0 (by omega)
  have k1 := key 1 (by omega)
  have k2 := key 2 (by omega)
  have sum := count_sum (p ++ q ++ t) hw6
  unfold AotOk
  dsimp only
  omega

/-! ## Sanity: the test is not vacuous -/

-- one-ended prefix p = eee, N = 4 (e = tail end = the head end's partner 0): cannot return in time
example : ¬ AotOk [0, 0, 0] [] 0 4 [] [] (fun _ => 0) false false := by
  simp [AotOk, tA, travel, loA, hiA, endpt, countAxis, axis, coord, unit]
  omega

-- p = e, N = 4: fine (e then w then ... closes a square after two more steps)
example : AotOk [0] [] 0 4 [] [] (fun _ => 0) false false := by
  simp [AotOk, tA, travel, loA, hiA, endpt, countAxis, axis, coord, unit]
  omega

end Dmon
