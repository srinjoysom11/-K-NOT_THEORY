/-
  Len52.Coloring — a certificate-checked test that every Fox 7-colouring of a diagram is constant.

  For a regular diagram with crossings `cs` (c = cs.length) and Fox matrix R = foxRows cs, an
  unverified Gaussian elimination mod 7 produces a matrix L with c - 1 rows.  A simple checker then
  verifies that, for k = 1 .. c-1, row k-1 of L·R is congruent mod 7 to e_k - e_0 (entrywise).  If x is
  a colouring (R x = 0 mod 7) then x_k - x_0 = (L·R x)_k = L (R x) = 0 mod 7, so x is constant.

  Only the checker is part of the soundness argument; the elimination routine may be wrong without
  affecting soundness (it can only make the test fail).
-/
import Len52.Diagram

namespace Len52
namespace Col

/-! ## Vector operations used by the checker -/

/-- recursive dot product (truncating to the shorter list) -/
def dotR : List Int → List Nat → Int
  | a :: as, b :: bs => a * (b : Int) + dotR as bs
  | _, _ => 0

/-- `a * r + acc`, padding the shorter list with zeros -/
def axpy (a : Int) : List Int → List Int → List Int
  | u :: us, v :: vs => (a * u + v) :: axpy a us vs
  | [], vs => vs
  | u :: us, [] => (a * u) :: axpy a us []

/-- `acc + Σ_r ls_r * R_r` (zip of `ls` with the rows `R`) -/
def lin : List Int → List (List Int) → List Int → List Int
  | a :: ls, r :: rs, acc => lin ls rs (axpy a r acc)
  | _, _, acc => acc

/-- `Σ_r ls_r * (R_r · x)` -/
def sumD : List Int → List (List Int) → List Nat → Int
  | a :: ls, r :: rs, x => a * dotR r x + sumD ls rs x
  | _, _, _ => 0

/-- the unit vector e_k of length n -/
def ek : Nat → Nat → List Int
  | 0, _ => []
  | n + 1, 0 => 1 :: List.replicate n 0
  | n + 1, k + 1 => 0 :: ek n k

/-- two lists of the same length that are entrywise congruent mod 7 -/
def congL : List Int → List Int → Bool
  | a :: as, b :: bs => (a - b) % 7 == 0 && congL as bs
  | [], [] => true
  | _, _ => false

/-- row number j of `L` (counted from `k - 1`): `(L_j · R) + e_0 ≡ e_{k+j}` -/
def checkRows (R : List (List Int)) (c : Nat) : List (List Int) → Nat → Bool
  | [], _ => true
  | l :: L, k => congL (axpy 1 (ek c 0) (lin l R [])) (ek c k) && checkRows R c L (k + 1)

/-- the certificate check -/
def checkCert (R L : List (List Int)) (c : Nat) : Bool :=
  L.length == c - 1 && checkRows R c L 1

/-! ## The (unverified) elimination routine producing the certificate -/

def md7 (a : Int) : Int := a % 7

def inv7 (a : Int) : Int :=
  match a % 7 with
  | 1 => 1 | 2 => 4 | 3 => 5 | 4 => 2 | 5 => 3 | 6 => 6 | _ => 0

/-- Gauss-Jordan elimination mod 7 of `[R | I]`; returns the rows ℓ_k (k = 1..c-1) with
    ℓ_k · R ≡ e_k - e_0, or `none` if the rank is not c - 1. -/
def elim (R : List (List Int)) (c : Nat) : Option (List (List Int)) := Id.run do
  let m := R.length
  let wd := c + m
  let mut M : Array (Array Int) := #[]
  for i in [0:m] do
    let row := (R.getD i []).toArray
    let mut a : Array Int := Array.replicate wd 0
    for j in [0:c] do
      a := a.set! j (md7 (row.getD j 0))
    a := a.set! (c + i) 1
    M := M.push a
  let mut pivots : Array Nat := #[]
  let mut r := 0
  for col in [0:c] do
    if r < m then
      let mut p := m
      for i in [r:m] do
        if p == m && (M[i]!)[col]! != 0 then p := i
      if p < m then
        let rowP := M[p]!
        let rowR := M[r]!
        M := M.set! p rowR
        let iv := inv7 rowP[col]!
        let pr := rowP.map (fun v => md7 (v * iv))
        M := M.set! r pr
        for i in [0:m] do
          if i != r then
            let ri := M[i]!
            let f := ri[col]!
            if f != 0 then
              M := M.set! i (Array.zipWith (fun a b => md7 (a - f * b)) ri pr)
        pivots := pivots.push col
        r := r + 1
  if r + 1 != c then return none
  let mut L : Array (List Int) := #[]
  for k in [1:c] do
    let mut l : Array Int := Array.replicate m 0
    for t in [0:r] do
      let pc := pivots[t]!
      let coef : Int := (if pc == k then 1 else 0) - (if pc == 0 then 1 else 0)
      if coef != 0 then
        let T := M[t]!
        for j in [0:m] do
          l := l.set! j (md7 (l[j]! + coef * T[c + j]!))
    L := L.push l.toList
  return some L.toList

/-! ## Lemmas -/

theorem dotR_nil_right (l : List Int) : dotR l [] = 0 := by
  cases l <;> rfl

theorem foldl_zip (r : List Int) (x : List Nat) (acc : Int) :
    (List.zipWith (fun (a : Int) (b : Nat) => a * (b : Int)) r x).foldl (· + ·) acc
      = acc + dotR r x := by
  induction r generalizing x acc with
  | nil => simp [dotR]
  | cons a as ih =>
    cases x with
    | nil => simp [dotR]
    | cons b bs =>
      simp only [List.zipWith_cons_cons, List.foldl_cons, dotR]
      rw [ih]
      omega

theorem dotI_eq (r : List Int) (x : List Nat) : dotI r x = dotR r x := by
  unfold dotI
  rw [foldl_zip]
  omega

theorem dotR_axpy (a : Int) (r acc : List Int) (x : List Nat) :
    dotR (axpy a r acc) x = a * dotR r x + dotR acc x := by
  induction r generalizing acc x with
  | nil => simp [axpy, dotR]
  | cons u us ih =>
    cases acc with
    | nil =>
      cases x with
      | nil => simp [axpy, dotR]
      | cons y ys =>
        simp only [axpy, dotR]
        rw [ih]
        simp only [Int.mul_add, Int.mul_assoc]
        cases ys <;> simp [dotR] <;> omega
    | cons v vs =>
      cases x with
      | nil => simp [axpy, dotR]
      | cons y ys =>
        simp only [axpy, dotR]
        rw [ih]
        simp only [Int.mul_add, Int.add_mul, Int.mul_assoc]
        omega

theorem dotR_lin (ls : List Int) (R : List (List Int)) (acc : List Int) (x : List Nat) :
    dotR (lin ls R acc) x = dotR acc x + sumD ls R x := by
  induction ls generalizing R acc with
  | nil => cases R <;> simp [lin, sumD]
  | cons a as ih =>
    cases R with
    | nil => simp [lin, sumD]
    | cons r rs =>
      simp only [lin, sumD]
      rw [ih, dotR_axpy]
      omega

theorem sumD_mod (ls : List Int) (R : List (List Int)) (x : List Nat)
    (h : ∀ r ∈ R, dotR r x % 7 = 0) : sumD ls R x % 7 = 0 := by
  induction ls generalizing R with
  | nil => cases R <;> simp [sumD]
  | cons a as ih =>
    cases R with
    | nil => simp [sumD]
    | cons r rs =>
      simp only [sumD]
      have h1 : dotR r x % 7 = 0 := h r (by simp)
      have h2 : sumD as rs x % 7 = 0 := ih rs (fun r' hr' => h r' (by simp [hr']))
      rw [Int.add_emod, Int.mul_emod, h1, h2]
      simp

theorem congL_dot (v t : List Int) (x : List Nat) (h : congL v t = true) :
    (dotR v x - dotR t x) % 7 = 0 := by
  induction v generalizing t x with
  | nil =>
    cases t with
    | nil => simp [dotR]
    | cons _ _ => simp [congL] at h
  | cons a as ih =>
    cases t with
    | nil => simp [congL] at h
    | cons b bs =>
      simp only [congL, Bool.and_eq_true, beq_iff_eq] at h
      cases x with
      | nil => simp [dotR]
      | cons y ys =>
        simp only [dotR]
        have h1 := ih bs ys h.2
        have h2 : ((a - b) * (y : Int)) % 7 = 0 := by
          rw [Int.mul_emod, h.1]; simp
        have e : a * (y : Int) + dotR as ys - (b * (y : Int) + dotR bs ys)
            = (a - b) * (y : Int) + (dotR as ys - dotR bs ys) := by
          rw [Int.sub_mul]; omega
        rw [e, Int.add_emod, h1, h2]
        simp

theorem dotR_replicate (n : Nat) (x : List Nat) : dotR (List.replicate n 0) x = 0 := by
  induction n generalizing x with
  | zero => rfl
  | succ n ih =>
    cases x with
    | nil => rfl
    | cons y ys => simp [List.replicate_succ, dotR, ih]

theorem dotR_ek (n k : Nat) (x : List Nat) (hk : k < n) (hx : k < x.length) :
    dotR (ek n k) x = (x[k] : Int) := by
  induction n generalizing k x with
  | zero => omega
  | succ n ih =>
    cases x with
    | nil => simp at hx
    | cons y ys =>
      cases k with
      | zero => simp [ek, dotR, dotR_replicate]
      | succ k =>
        simp only [ek, dotR]
        rw [ih k ys (by omega) (by simp at hx; omega)]
        simp

theorem checkRows_get (R : List (List Int)) (c : Nat) (L : List (List Int)) (k : Nat)
    (h : checkRows R c L k = true) :
    ∀ j (hj : j < L.length), congL (axpy 1 (ek c 0) (lin L[j] R [])) (ek c (k + j)) = true := by
  induction L generalizing k with
  | nil => intro j hj; simp at hj
  | cons l L ih =>
    simp only [checkRows, Bool.and_eq_true] at h
    intro j hj
    cases j with
    | zero => simpa using h.1
    | succ j =>
      have := ih (k + 1) h.2 j (by simp at hj; omega)
      simpa [Nat.add_assoc, Nat.add_comm 1 j] using this

/-- the main property of a certificate: every colouring is constant -/
theorem cert_sound (R L : List (List Int)) (c : Nat) (hcert : checkCert R L c = true)
    (x : List Nat) (hx : x.length = c) (h7 : ∀ a ∈ x, a < 7)
    (hcol : ∀ r ∈ R, dotR r x % 7 = 0) (hc : 0 < c) :
    ∀ k (hk : k < x.length), x[k] = x[0]'(by omega) := by
  simp only [checkCert, Bool.and_eq_true, beq_iff_eq] at hcert
  obtain ⟨hlen, hrows⟩ := hcert
  intro k hk
  cases k with
  | zero => rfl
  | succ k =>
    have hj : k < L.length := by omega
    have hcg := checkRows_get R c L 1 hrows k hj
    have hd := congL_dot _ _ x hcg
    rw [dotR_axpy, dotR_lin, dotR_ek c 0 x hc (by omega),
      dotR_ek c (1 + k) x (by omega) (by omega)] at hd
    have hs := sumD_mod L[k] R x hcol
    have hnil : dotR [] x = 0 := rfl
    rw [hnil] at hd
    have a0 := h7 (x[0]'(by omega)) (List.getElem_mem _)
    have ak := h7 (x[k+1]) (List.getElem_mem _)
    have e1 : x[1 + k]'(by omega) = x[k+1] := by simp [Nat.add_comm]
    rw [e1] at hd
    omega

end Col

open Col

/-! ## The test for one direction -/

/-- true only if the diagram of w under D is regular and every Fox 7-colouring is constant -/
def colorCheckD (D : V3) (w : List Nat) : Bool :=
  match diagram D w with
  | none => false
  | some cs =>
    let R := foxRows cs
    let c := cs.length
    if c = 0 then true
    else
      match elim R c with
      | none => false
      | some L => checkCert R L c

theorem colorCheckD_isSome (D : V3) (w : List Nat) (h : colorCheckD D w = true) :
    (diagram D w).isSome := by
  unfold colorCheckD at h
  split at h
  · simp at h
  · rename_i cs hcs; simp [hcs]

theorem colorCheckD_sound (D : V3) (w : List Nat) :
    colorCheckD D w = true → ¬ HasNontrivialColoring D w := by
  intro h hcol
  obtain ⟨cs, hcs, x, hlen, h7, hrows, i, j, hi, hj, hne⟩ := hcol
  unfold colorCheckD at h
  rw [hcs] at h
  simp only at h
  split at h
  · rename_i hc0
    omega
  · rename_i hc0
    split at h
    · simp at h
    · rename_i L _
      have hcol' : ∀ r ∈ foxRows cs, dotR r x % 7 = 0 := by
        intro r hr; rw [← dotI_eq]; exact hrows r hr
      have key := cert_sound (foxRows cs) L cs.length h x hlen h7 hcol' (by omega)
      exact hne ((key i hi).trans (key j hj).symm)

/-! ## Trying several directions -/

/-- the projection directions tried by `colorCheck` -/
def colorDirs : List V3 :=
  [⟨7, 13, 31⟩, ⟨-28, -45, 32⟩, ⟨1, -19, 40⟩, ⟨11, -37, 12⟩, ⟨5, 17, 23⟩, ⟨-3, 29, 19⟩]

/-- true only if, for one of the fixed directions D, the diagram of w is regular and has only constant
    Fox 7-colourings -/
def colorCheck (w : List Nat) : Bool := colorDirs.any (fun D => colorCheckD D w)

theorem colorCheck_sound (w : List Nat) :
    colorCheck w = true → ∃ D, (diagram D w).isSome ∧ ¬ HasNontrivialColoring D w := by
  intro h
  obtain ⟨D, _, hD⟩ := List.any_eq_true.mp h
  exact ⟨D, colorCheckD_isSome D w hD, colorCheckD_sound D w hD⟩

/-! ## A kernel-reducible version of the Fox rows

`List.mergeSort` (used by `underSorted`) is defined by well-founded recursion, which the kernel does
not evaluate.  `msF` is the same algorithm with fuel (structural recursion); `msF_eq` shows that it
computes exactly `List.mergeSort`, so `foxRowsK = foxRows`. -/

namespace Col

/-- `List.merge` with fuel (structural recursion, so the kernel can evaluate it) -/
def mergeF {α : Type} (le : α → α → Bool) : Nat → List α → List α → List α
  | 0, xs, ys => xs ++ ys
  | _ + 1, [], ys => ys
  | _ + 1, x :: xs, [] => x :: xs
  | f + 1, x :: xs, y :: ys =>
    if le x y then x :: mergeF le f xs (y :: ys) else y :: mergeF le f (x :: xs) ys

theorem mergeF_eq {α : Type} (le : α → α → Bool) (f : Nat) (xs ys : List α)
    (h : xs.length + ys.length ≤ f) : mergeF le f xs ys = List.merge xs ys le := by
  induction f generalizing xs ys with
  | zero =>
    cases xs with
    | nil => cases ys with
      | nil => simp [mergeF]
      | cons _ _ => simp at h
    | cons _ _ => simp at h
  | succ f ih =>
    cases xs with
    | nil => simp [mergeF]
    | cons x xs =>
      cases ys with
      | nil => simp [mergeF]
      | cons y ys =>
        rw [List.cons_merge_cons]
        simp only [mergeF]
        split
        · rw [ih xs (y :: ys) (by simp at h ⊢; omega)]
        · rw [ih (x :: xs) ys (by simp at h ⊢; omega)]

/-- `List.mergeSort` with fuel -/
def msF {α : Type} (le : α → α → Bool) : Nat → List α → List α
  | 0, xs => xs
  | f + 1, xs =>
    match xs with
    | [] => []
    | [a] => [a]
    | a :: b :: rest =>
      mergeF le (rest.length + 2) (msF le f ((a :: b :: rest).take ((rest.length + 3) / 2)))
        (msF le f ((a :: b :: rest).drop ((rest.length + 3) / 2)))

theorem msF_eq {α : Type} (le : α → α → Bool) (f : Nat) (xs : List α) (h : xs.length ≤ f) :
    msF le f xs = List.mergeSort xs le := by
  induction f generalizing xs with
  | zero =>
    cases xs with
    | nil => simp [msF]
    | cons _ _ => simp at h
  | succ f ih =>
    match xs with
    | [] => simp [msF]
    | [a] => simp [msF]
    | a :: b :: rest =>
      rw [List.mergeSort]
      simp only [msF, List.MergeSort.Internal.splitInTwo_fst, List.MergeSort.Internal.splitInTwo_snd]
      simp only [List.length_cons] at h
      have e : (a :: b :: rest).length + 1 = rest.length + 3 := by simp
      rw [e, ih _ (by simp; omega), ih _ (by simp; omega), mergeF_eq]
      rw [List.length_mergeSort, List.length_mergeSort, ← List.length_append,
        List.take_append_drop]
      simp


def underSortedK (cs : List Crossing) : List EPt :=
  msF (fun p q => !(EPt.lt q p)) cs.length (cs.map (·.under))

theorem underSorted_eq (cs : List Crossing) : underSorted cs = underSortedK cs := by
  unfold underSorted underSortedK
  rw [msF_eq _ _ _ (by simp)]

/-- `foxRows` with `underSortedK` in place of `underSorted` -/
def foxRowsK (cs : List Crossing) : List (List Int) :=
  let us := underSortedK cs
  let c := cs.length
  cs.map fun cr =>
    let e := idxOf us cr.under
    let o := arcAt us cr.over
    bump c o 2 (bump c ((e + c - 1) % c) (-1) (bump c e (-1) (List.replicate c 0)))

theorem foxRows_eq (cs : List Crossing) : foxRows cs = foxRowsK cs := by
  unfold foxRows foxRowsK
  rw [underSorted_eq]

end Col

/-! ## A witness of a non-constant colouring -/

def hasColoringWitness (D : V3) (w : List Nat) (x : List Nat) : Bool :=
  match diagram D w with
  | none => false
  | some cs =>
    x.length == cs.length && x.all (· < 7) && (foxRows cs).all (fun r => dotI r x % 7 == 0) &&
      x.any (· != x.headD 0)

/-- the same test, with `foxRowsK` (evaluated by the kernel) -/
def hasColoringWitnessK (D : V3) (w : List Nat) (x : List Nat) : Bool :=
  match diagram D w with
  | none => false
  | some cs =>
    x.length == cs.length && x.all (· < 7) && (Col.foxRowsK cs).all (fun r => dotI r x % 7 == 0) &&
      x.any (· != x.headD 0)

theorem hasColoringWitness_eq (D : V3) (w x : List Nat) :
    hasColoringWitness D w x = hasColoringWitnessK D w x := by
  unfold hasColoringWitness hasColoringWitnessK
  split <;> simp [Col.foxRows_eq]

theorem hasColoringWitness_sound (D : V3) (w x : List Nat) :
    hasColoringWitness D w x = true → HasNontrivialColoring D w := by
  intro h
  unfold hasColoringWitness at h
  split at h
  · simp at h
  · rename_i cs hcs
    simp only [Bool.and_eq_true, beq_iff_eq, List.all_eq_true, decide_eq_true_eq,
      List.any_eq_true, bne_iff_ne, ne_eq] at h
    obtain ⟨⟨⟨hlen, h7⟩, hrows⟩, a, ha, hne⟩ := h
    refine ⟨cs, hcs, x, hlen, h7, hrows, ?_⟩
    obtain ⟨i, hi, hxi⟩ := List.mem_iff_getElem.mp ha
    cases x with
    | nil => simp at ha
    | cons y ys =>
      refine ⟨i, 0, hi, by simp, ?_⟩
      simp only [List.headD_cons] at hne
      simpa [hxi] using hne

/-! ## Kernel-checked facts -/

/-- `IsPolygon` is decidable (local instance, evaluated by the kernel) -/
local instance decIsPolygon : DecidablePred IsPolygon := fun w => by
  unfold IsPolygon; infer_instance

/-- all words of length 4 over 0..5 -/
def words4 : List (List Nat) :=
  (List.range 6).flatMap fun a => (List.range 6).flatMap fun b =>
    (List.range 6).flatMap fun c => (List.range 6).map fun d => [a, b, c, d]

theorem mem_words4 (w : List Nat) (hl : w.length = 4) (h6 : ∀ d ∈ w, d < 6) : w ∈ words4 := by
  match w, hl with
  | [a, b, c, d], _ =>
    have ha := h6 a (by simp)
    have hb := h6 b (by simp)
    have hc := h6 c (by simp)
    have hd := h6 d (by simp)
    simp only [words4, List.mem_flatMap, List.mem_map, List.mem_range]
    exact ⟨a, ha, b, hb, c, hc, d, hd, rfl⟩

theorem words4_ok : ∀ w ∈ words4, IsPolygon w → colorCheck w = true := by
  decide +kernel

/-- every lattice square passes the colouring test -/
theorem square_ok : ∀ w : List Nat, w.length = 4 → IsPolygon w → colorCheck w = true := by
  intro w hl hp
  exact words4_ok w (mem_words4 w hl hp.2.1) hp

/-- the 5_2 certificate polygon "eeennuwwwwssseennwuueedddnnuuswsswdd" (e w n s u d = 0..5) -/
def w52 : List Nat :=
  [0, 0, 0, 2, 2, 4, 1, 1, 1, 1, 3, 3, 3, 0, 0, 2, 2, 1, 4, 4, 0, 0, 5, 5, 5, 2, 2, 4, 4, 3, 1, 3,
   3, 1, 5, 5]

/-- letters e w n s u d to 0..5 -/
def letterCode : Char → Nat
  | 'e' => 0 | 'w' => 1 | 'n' => 2 | 's' => 3 | 'u' => 4 | _ => 5

theorem w52_eq : "eeennuwwwwssseennwuueedddnnuuswsswdd".toList.map letterCode = w52 := by
  decide +kernel

def D52 : V3 := ⟨1, -19, 40⟩

/-- a non-constant 7-colouring of the 5-crossing diagram of w52 under D52 -/
def x52 : List Nat := [0, 1, 3, 4, 2]

theorem w52_length : w52.length = 36 := by decide

theorem w52_polygon : IsPolygon w52 := by decide +kernel

theorem w52_crossings : (diagram D52 w52).map List.length = some 5 := by decide +kernel

theorem w52_witness : hasColoringWitness D52 w52 x52 = true := by
  rw [hasColoringWitness_eq]; decide +kernel

/-- sanity check: the diagram of the 5_2 polygon has a non-constant 7-colouring -/
theorem w52_coloring : HasNontrivialColoring D52 w52 :=
  hasColoringWitness_sound D52 w52 x52 w52_witness

/-- consistently, the colouring test fails for it -/
theorem w52_colorCheckD : colorCheckD D52 w52 = false := by
  cases h : colorCheckD D52 w52
  · rfl
  · exact absurd w52_coloring (colorCheckD_sound D52 w52 h)


end Len52
