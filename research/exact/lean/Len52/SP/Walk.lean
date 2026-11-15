/-
  Len52.SP.Walk — facts about the walk of a word: steps, distances, total variation.
-/
import Len52.SP.Basic

namespace Len52.SP
open Len52 Len52.Search

theorem vertsFrom_length (v : V3) (l : List Nat) : (vertsFrom v l).length = l.length + 1 := by
  induction l generalizing v with
  | nil => rfl
  | cons d ds ih => simp [vertsFrom, ih]

theorem vertsFrom_getD_zero (v : V3) (l : List Nat) : (vertsFrom v l).getD 0 0 = v := by
  cases l <;> rfl

theorem vertsFrom_getD_succ : ∀ (l : List Nat) (v : V3) (j : Nat), j < l.length →
    (vertsFrom v l).getD (j + 1) 0 = (vertsFrom v l).getD j 0 + unit (l.getD j 0)
  | [], _, _, h => absurd h (by simp)
  | d :: ds, v, 0, _ => by
    simp only [vertsFrom, List.getD_cons_succ, List.getD_cons_zero, vertsFrom_getD_zero]
  | d :: ds, v, j + 1, h => by
    simp only [vertsFrom, List.getD_cons_succ]
    exact vertsFrom_getD_succ ds _ j (by simp at h; omega)

theorem vtx_zero (w : List Nat) : vtx w 0 = 0 := vertsFrom_getD_zero _ _

theorem vtx_succ {w : List Nat} {j : Nat} (h : j < w.length) :
    vtx w (j + 1) = vtx w j + unit (dir w j) :=
  vertsFrom_getD_succ w 0 j h

theorem verts_length (w : List Nat) : (verts w).length = w.length + 1 := vertsFrom_length _ _

theorem dir_lt {w : List Nat} (h6 : ∀ d ∈ w, d < 6) (j : Nat) : dir w j < 6 := by
  unfold dir
  rw [List.getD_eq_getElem?_getD]
  cases h : w[j]? with
  | none => simp
  | some a => simp only [Option.getD_some]; exact h6 a (List.mem_of_getElem? h)

theorem vset_length (w : List Nat) : (vset w).length = w.length := by
  unfold vset; simp [verts_length]

theorem vset_getElem (w : List Nat) (a : Nat) (h : a < (vset w).length) :
    (vset w)[a] = vtx w a := by
  unfold vset vtx
  rw [List.getElem_take, List.getD_eq_getElem?_getD, List.getElem?_eq_getElem]
  · rfl

theorem mem_vset {w : List Nat} {v : V3} : v ∈ vset w ↔ ∃ m, m < w.length ∧ vtx w m = v := by
  rw [List.mem_iff_getElem]
  constructor
  · rintro ⟨i, hi, rfl⟩
    exact ⟨i, by rw [vset_length] at hi; exact hi, (vset_getElem w i hi).symm⟩
  · rintro ⟨m, hm, rfl⟩
    exact ⟨m, by rw [vset_length]; exact hm, vset_getElem w m _⟩

theorem vtx_mem_vset {w : List Nat} {m : Nat} (h : m < w.length) : vtx w m ∈ vset w :=
  mem_vset.2 ⟨m, h, rfl⟩

theorem vtx_inj {w : List Nat} (hnd : (vset w).Nodup) {a b : Nat} (ha : a < w.length)
    (hb : b < w.length) (h : vtx w a = vtx w b) : a = b := by
  have hp := List.pairwise_iff_getElem.1 (List.nodup_iff_pairwise_ne.1 hnd)
  rcases Nat.lt_trichotomy a b with hab | hab | hab
  · exact absurd (by rw [vset_getElem, vset_getElem]; exact h) (hp a b (by rw [vset_length]; exact ha)
      (by rw [vset_length]; exact hb) hab)
  · exact hab
  · exact absurd (by rw [vset_getElem, vset_getElem]; exact h.symm) (hp b a (by rw [vset_length]; exact hb)
      (by rw [vset_length]; exact ha) hab)

/-- the l1 distance between vertices is at most the number of steps between them -/
theorem vtx_dist {w : List Nat} (a : Nat) : ∀ k, a + k ≤ w.length →
    ((vtx w (a + k)).x - (vtx w a).x).natAbs + ((vtx w (a + k)).y - (vtx w a).y).natAbs +
      ((vtx w (a + k)).z - (vtx w a).z).natAbs ≤ k
  | 0, _ => by simp
  | k + 1, h => by
    have ih := vtx_dist (w := w) a k (by omega)
    rw [← Nat.add_assoc, vtx_succ (w := w) (by omega)]
    have hu := n1_unit (dir w (a + k))
    simp only [V3.add_x, V3.add_y, V3.add_z]
    omega

theorem vtx_dist' {w : List Nat} {a b : Nat} (hab : a ≤ b) (hb : b ≤ w.length) :
    ((vtx w b).x - (vtx w a).x).natAbs + ((vtx w b).y - (vtx w a).y).natAbs +
      ((vtx w b).z - (vtx w a).z).natAbs ≤ b - a := by
  have := vtx_dist (w := w) a (b - a) (by omega)
  rwa [show a + (b - a) = b by omega] at this

/-! ## Total variation of a coordinate -/

def tv (g : Nat → Int) (a : Nat) : Nat → Int
  | 0 => 0
  | n + 1 => tv g a n + ((g (a + n + 1) - g (a + n)).natAbs : Int)

theorem tv_add (g : Nat → Int) (a m : Nat) : ∀ n, tv g a (m + n) = tv g a m + tv g (a + m) n
  | 0 => by simp [tv]
  | n + 1 => by
    rw [← Nat.add_assoc, tv, tv, tv_add g a m n, show a + (m + n) = a + m + n by omega]
    omega

theorem tv_bound (g : Nat → Int) (a : Nat) : ∀ n,
    g (a + n) - g a ≤ tv g a n ∧ g a - g (a + n) ≤ tv g a n
  | 0 => by simp [tv]
  | n + 1 => by
    have ih := tv_bound g a n
    rw [tv, show a + (n + 1) = a + n + 1 by omega]
    omega

/-- going through t1 and then t2 costs at least the three distances -/
theorem tv_path (g : Nat → Int) {a t1 t2 n : Nat} (h1 : a ≤ t1) (h2 : t1 ≤ t2) (h3 : t2 ≤ a + n) :
    ((g t1 - g a).natAbs : Int) + ((g t2 - g t1).natAbs : Int) + ((g (a + n) - g t2).natAbs : Int)
      ≤ tv g a n := by
  obtain ⟨p, rfl⟩ : ∃ p, t1 = a + p := ⟨t1 - a, by omega⟩
  obtain ⟨q, rfl⟩ : ∃ q, t2 = a + p + q := ⟨t2 - (a + p), by omega⟩
  obtain ⟨r, rfl⟩ : ∃ r, n = p + q + r := ⟨n - (p + q), by omega⟩
  rw [tv_add g a (p + q) r, tv_add g a p q]
  have b1 := tv_bound g a p
  have b2 := tv_bound g (a + p) q
  have b3 := tv_bound g (a + (p + q)) r
  rw [show a + (p + q) = a + p + q by omega] at b3
  rw [show a + (p + q + r) = a + p + q + r by omega, show a + (p + q) = a + p + q by omega]
  omega

/-- the three coordinates together change by exactly one per step -/
theorem tv_sum {w : List Nat} (a : Nat) : ∀ n, a + n ≤ w.length →
    tv (fun t => (vtx w t).x) a n + tv (fun t => (vtx w t).y) a n + tv (fun t => (vtx w t).z) a n = n
  | 0, _ => by simp [tv]
  | n + 1, h => by
    have ih := tv_sum (w := w) a n (by omega)
    simp only [tv]
    rw [vtx_succ (w := w) (j := a + n) (by omega)]
    have hu := n1_unit (dir w (a + n))
    simp only [V3.add_x, V3.add_y, V3.add_z]
    omega

/-! ## Vertices of a word with Survive lie in a small box -/

/-- the box containing every vertex -/
def VB (v : V3) : Prop := v.x.natAbs + v.y.natAbs + v.z.natAbs ≤ 17 ∧ 0 ≤ v.z

theorem VB.inB {v : V3} (h : VB v) : InB v := by unfold VB at h; unfold InB; omega

theorem VB.inB_add {v : V3} (h : VB v) (d : Nat) : InB (v + unit d) := by
  unfold VB at h; unfold InB
  have := n1_unit d
  simp only [V3.add_x, V3.add_y, V3.add_z]; omega

theorem VB.inB_sub {v : V3} (h : VB v) (d : Nat) : InB (v - unit d) := by
  unfold VB at h; unfold InB
  have := n1_unit d
  simp only [V3.sub_x, V3.sub_y, V3.sub_z]; omega

theorem vtx_VB {w : List Nat} (hS : Survive w) (hN : w.length ≤ 34) {m : Nat} (hm : m ≤ w.length) :
    VB (vtx w m) := by
  obtain ⟨⟨h4, _, hclose, _⟩, hlex, _⟩ := hS
  have d1 := vtx_dist' (w := w) (Nat.zero_le m) hm
  have d2 := vtx_dist' (w := w) hm (Nat.le_refl _)
  rw [vtx_zero] at d1
  rw [hclose] at d2
  simp only [V3.zero_x, V3.zero_y, V3.zero_z, Int.sub_zero, Int.zero_sub, Int.natAbs_neg] at d1 d2
  refine ⟨by omega, ?_⟩
  by_cases h0 : m = 0
  · subst h0; rw [vtx_zero]; simp
  by_cases hN' : m = w.length
  · subst hN'; rw [hclose]; simp
  have := hlex m (by omega) (by omega)
  unfold LexPos at this; omega

theorem allowed_vtx {w : List Nat} (hS : Survive w) (hN : w.length ≤ 34) {m : Nat} (h1 : 1 ≤ m)
    (h2 : m < w.length) : allowed (pk (vtx w m)) = true := by
  have hv := vtx_VB hS hN (Nat.le_of_lt h2)
  apply allowed_pk hv.inB (hS.2.1 m h1 h2) <;> (unfold VB at hv; omega)

end Len52.SP
