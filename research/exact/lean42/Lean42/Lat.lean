/-
  Lean42.Lat -- unit edges of the cubic lattice and lattice polygons.

  Phase 2 of research/exact/lean42/PLAN.md: the lattice facts behind `KnotClass`.

  * `IsLat p`: all three coordinates of p are integers.
  * `UStep p q`: q = p ± e_k for an axis k (a *unit lattice edge* from p to q).
  * `edge_det`: two unit lattice edges that share a point with a non-integer coordinate are the same
    edge.  (A point of a unit lattice edge has at most one non-integer coordinate, the one along the
    edge, and the edge is then the segment between the two integers next to that coordinate.)
  * `lat_pt_on_edge`: a lattice point on a unit lattice edge is one of its two endpoints.
  * `LatPoly L`: a polygon with ≥ 4 distinct lattice vertices and unit lattice edges.
  * `latPoly_simple`: **a lattice polygon is simple** (two different edges meet only in common
    endpoints).  Proof: a common point x of two different edges is either a lattice point, hence an
    endpoint of both (`lat_pt_on_edge`), or has a non-integer coordinate, and then the two edges
    coincide as unordered pairs (`edge_det`); two edges (u,v), (v,u) cannot both occur in a cyclic
    list of ≥ 3 distinct vertices.
-/
import Lean42.Polygon

namespace Lean42

/-- the k-th unit vector -/
def e3 (k : Fin 3) : Pt := Pi.single k 1

theorem e3_apply (k i : Fin 3) : e3 k i = if i = k then 1 else 0 := by
  simp [e3, Pi.single_apply]

/-- a point of the integer lattice -/
def IsLat (p : Pt) : Prop := ∀ j, ∃ z : ℤ, p j = z

/-- `q` is a unit lattice step from `p`: q = p + s e_k with s = ±1. -/
def UStep (p q : Pt) : Prop := ∃ (k : Fin 3) (s : ℚ), (s = 1 ∨ s = -1) ∧ q = p + s • e3 k

theorem isLat_add {p q : Pt} (hp : IsLat p) (hq : IsLat q) : IsLat (p + q) := by
  intro j
  obtain ⟨a, ha⟩ := hp j
  obtain ⟨b, hb⟩ := hq j
  exact ⟨a + b, by simp [ha, hb]⟩

theorem isLat_zero : IsLat 0 := fun j => ⟨0, by simp⟩

/-- coordinates of a point of a unit edge -/
theorem seg_ustep {p x : Pt} {k : Fin 3} {s : ℚ} (hx : x ∈ seg p (p + s • e3 k)) :
    ∃ l : ℚ, 0 ≤ l ∧ l ≤ 1 ∧ ∀ i, x i = p i + (if i = k then l * s else 0) := by
  obtain ⟨t, h0, h1, rfl⟩ := mem_seg.1 hx
  refine ⟨t, h0, h1, fun i => ?_⟩
  simp only [Pi.add_apply, Pi.smul_apply, Pi.sub_apply, smul_eq_mul, e3_apply]
  split_ifs <;> ring

theorem int_adj (m m' : ℤ) (y : ℚ) (h1 : (m : ℚ) < y) (h2 : y < m + 1) (h3 : (m' : ℚ) < y)
    (h4 : y < m' + 1) : m = m' := by
  have a1 : (m : ℚ) < m' + 1 := by linarith
  have a2 : (m' : ℚ) < m + 1 := by linarith
  have b1 : m < m' + 1 := by exact_mod_cast a1
  have b2 : m' < m + 1 := by exact_mod_cast a2
  omega

theorem vec_eq_of {u v : Pt} (j : Fin 3) (h1 : ∀ i, i ≠ j → u i = v i) (h2 : u j = v j) :
    u = v := by
  funext i
  by_cases hi : i = j
  · subst hi; exact h2
  · exact h1 i hi

/-- Two unit lattice edges through a common point with a non-integer coordinate are equal as
    unordered pairs of endpoints. -/
theorem edge_det {p q p' q' x : Pt} (hp : IsLat p) (hp' : IsLat p')
    (h : UStep p q) (h' : UStep p' q') (hx : x ∈ seg p q) (hx' : x ∈ seg p' q')
    (j : Fin 3) (hj : ∀ z : ℤ, x j ≠ z) :
    (p = p' ∧ q = q') ∨ (p = q' ∧ q = p') := by
  obtain ⟨k, s, hs, rfl⟩ := h
  obtain ⟨k', s', hs', rfl⟩ := h'
  obtain ⟨l, hl0, hl1, hxl⟩ := seg_ustep hx
  obtain ⟨l', hl0', hl1', hxl'⟩ := seg_ustep hx'
  have hjk : j = k := by
    by_contra hne
    obtain ⟨z, hz⟩ := hp j
    apply hj z
    rw [hxl j, if_neg hne, hz]; ring
  have hjk' : j = k' := by
    by_contra hne
    obtain ⟨z, hz⟩ := hp' j
    apply hj z
    rw [hxl' j, if_neg hne, hz]; ring
  subst hjk
  subst hjk'
  obtain ⟨m, hm⟩ := hp j
  obtain ⟨m', hm'⟩ := hp' j
  have hxj : x j = p j + l * s := by rw [hxl j]; simp
  have hxj' : x j = p' j + l' * s' := by rw [hxl' j]; simp
  -- strictness of the parameters
  have hlpos : 0 < l := by
    rcases lt_or_eq_of_le hl0 with h | h
    · exact h
    · exfalso; apply hj m; rw [hxj, ← h, hm]; ring
  have hllt : l < 1 := by
    rcases lt_or_eq_of_le hl1 with h | h
    · exact h
    · exfalso
      rcases hs with rfl | rfl
      · apply hj (m + 1); rw [hxj, h, hm]; push_cast; ring
      · apply hj (m - 1); rw [hxj, h, hm]; push_cast; ring
  have hlpos' : 0 < l' := by
    rcases lt_or_eq_of_le hl0' with h | h
    · exact h
    · exfalso; apply hj m'; rw [hxj', ← h, hm']; ring
  have hllt' : l' < 1 := by
    rcases lt_or_eq_of_le hl1' with h | h
    · exact h
    · exfalso
      rcases hs' with rfl | rfl
      · apply hj (m' + 1); rw [hxj', h, hm']; push_cast; ring
      · apply hj (m' - 1); rw [hxj', h, hm']; push_cast; ring
  have hoff : ∀ i, i ≠ j → p i = p' i := by
    intro i hi
    have a := hxl i
    have b := hxl' i
    rw [if_neg hi] at a b
    linarith
  rcases hs with rfl | rfl <;> rcases hs' with rfl | rfl
  · have : m = m' := int_adj m m' (x j) (by rw [hxj, hm]; linarith) (by rw [hxj, hm]; linarith)
      (by rw [hxj', hm']; linarith) (by rw [hxj', hm']; linarith)
    subst this
    have hpp : p = p' := vec_eq_of j hoff (by rw [hm, hm'])
    left; exact ⟨hpp, by rw [hpp]⟩
  · have : m + 1 = m' := by
      have := int_adj m (m' - 1) (x j) (by rw [hxj, hm]; linarith) (by rw [hxj, hm]; linarith)
        (by rw [hxj', hm']; push_cast; linarith) (by rw [hxj', hm']; push_cast; linarith)
      omega
    subst this
    right
    have hp' : p' = p + (1 : ℚ) • e3 j := vec_eq_of j
      (fun i hi => by simp [e3_apply, hi, (hoff i hi).symm]) (by simp [e3_apply, hm, hm'])
    constructor
    · rw [hp']; ext i; simp [e3_apply]
    · rw [hp']
  · have : m - 1 = m' := by
      have := int_adj (m - 1) m' (x j) (by rw [hxj, hm]; push_cast; linarith)
        (by rw [hxj, hm]; push_cast; linarith)
        (by rw [hxj', hm']; linarith) (by rw [hxj', hm']; linarith)
      omega
    subst this
    right
    have hp' : p' = p + (-1 : ℚ) • e3 j := vec_eq_of j
      (fun i hi => by simp [e3_apply, hi, (hoff i hi).symm]) (by simp [e3_apply, hm, hm']; ring)
    constructor
    · rw [hp']; ext i; simp [e3_apply]
    · rw [hp']
  · have : m = m' := by
      have := int_adj (m - 1) (m' - 1) (x j) (by rw [hxj, hm]; push_cast; linarith)
        (by rw [hxj, hm]; push_cast; linarith)
        (by rw [hxj', hm']; push_cast; linarith) (by rw [hxj', hm']; push_cast; linarith)
      omega
    subst this
    have hpp : p = p' := vec_eq_of j hoff (by rw [hm, hm'])
    left; exact ⟨hpp, by rw [hpp]⟩

/-- A lattice point of a unit lattice edge is an endpoint. -/
theorem lat_pt_on_edge {p q x : Pt} (hp : IsLat p) (h : UStep p q) (hx : x ∈ seg p q)
    (hxl : IsLat x) : x = p ∨ x = q := by
  obtain ⟨k, s, hs, rfl⟩ := h
  obtain ⟨l, hl0, hl1, hxl'⟩ := seg_ustep hx
  obtain ⟨z, hz⟩ := hxl k
  obtain ⟨m, hm⟩ := hp k
  have hk : x k = p k + l * s := by rw [hxl' k]; simp
  have hw : l * s = ((z - m : ℤ) : ℚ) := by push_cast; linarith
  have hl : l = 0 ∨ l = 1 := by
    rcases hs with rfl | rfl
    · have h0 : (0 : ℚ) ≤ ((z - m : ℤ) : ℚ) := by rw [← hw]; linarith
      have h1 : ((z - m : ℤ) : ℚ) ≤ 1 := by rw [← hw]; linarith
      have a : (0 : ℤ) ≤ z - m := by exact_mod_cast h0
      have b : z - m ≤ (1 : ℤ) := by exact_mod_cast h1
      rcases (by omega : z - m = 0 ∨ z - m = 1) with e | e
      · left; rw [e] at hw; simpa using hw
      · right; rw [e] at hw; simpa using hw
    · have h0 : ((z - m : ℤ) : ℚ) ≤ 0 := by rw [← hw]; linarith
      have h1 : (-1 : ℚ) ≤ ((z - m : ℤ) : ℚ) := by rw [← hw]; linarith
      have a : z - m ≤ (0 : ℤ) := by exact_mod_cast h0
      have b : (-1 : ℤ) ≤ z - m := by exact_mod_cast h1
      rcases (by omega : z - m = 0 ∨ z - m = -1) with e | e
      · left; rw [e] at hw; simpa using hw
      · right; rw [e] at hw; simp at hw; linarith
  rcases hl with rfl | rfl
  · left; funext i; rw [hxl' i]; simp
  · right; funext i; rw [hxl' i]; simp [e3_apply]

/-! ## Lattice polygons -/

/-- A lattice polygon: at least four distinct vertices, all in Z^3, consecutive vertices
    (including the closing pair) at unit distance along an axis. -/
def LatPoly (L : List Pt) : Prop :=
  4 ≤ L.length ∧ L.Nodup ∧ (∀ v ∈ L, IsLat v) ∧ ∀ e ∈ edges L, UStep e.1 e.2

theorem LatPoly.rotate {L : List Pt} (h : LatPoly L) (k : ℕ) : LatPoly (L.rotate k) := by
  obtain ⟨h4, hnd, hl, hu⟩ := h
  refine ⟨by simpa using h4, (List.nodup_rotate).2 hnd, fun v hv => hl v ((List.mem_rotate).1 hv),
    fun e he => hu e ((mem_edges_rotate_iter k).1 he)⟩

theorem succ_mod (j n : ℕ) (hj : j < n) : (j + 1) % n = if j + 1 < n then j + 1 else 0 := by
  split_ifs with h
  · exact Nat.mod_eq_of_lt h
  · have : j + 1 = n := by omega
    simp [this]

/-- in a cyclic list of ≥ 3 distinct vertices, (u,v) and (v,u) are not both edges -/
theorem edges_no_swap {L : List Pt} (hL : L.Nodup) (h3 : 3 ≤ L.length) {e e' : Pt × Pt}
    (he : e ∈ edges L) (he' : e' ∈ edges L) (h1 : e.1 = e'.2) (h2 : e.2 = e'.1) : False := by
  rw [edges_eq_zip] at he he'
  obtain ⟨i, hi, rfl⟩ := List.mem_iff_getElem.1 he
  obtain ⟨j, hj, rfl⟩ := List.mem_iff_getElem.1 he'
  simp only [List.getElem_zip, List.getElem_rotate] at h1 h2
  have hn : i < L.length := by simp at hi; omega
  have hn' : j < L.length := by simp at hj; omega
  have e1 := (hL.getElem_inj_iff).1 h1
  have e2 := (hL.getElem_inj_iff).1 h2
  rw [succ_mod i _ hn] at e2
  rw [succ_mod j _ hn'] at e1
  split_ifs at e1 e2 <;> omega

/-- **A lattice polygon is simple.** -/
theorem latPoly_simple {L : List Pt} (h : LatPoly L) : Simple L := by
  obtain ⟨h4, hnd, hl, hu⟩ := h
  refine ⟨by omega, hnd, ?_⟩
  intro e he e' he' hne x hx hx'
  have hle : IsLat e.1 := hl _ (mem_edges_fst he)
  have hle' : IsLat e'.1 := hl _ (mem_edges_fst he')
  have hue := hu e he
  have hue' := hu e' he'
  have hxe : x ∈ seg e.1 (e.2) := hx
  by_cases hint : ∀ j, ∃ z : ℤ, x j = z
  · -- a lattice point of both edges
    exact ⟨lat_pt_on_edge hle hue hx hint, lat_pt_on_edge hle' hue' hx' hint⟩
  · exfalso
    push_neg at hint
    obtain ⟨j, hj⟩ := hint
    rcases edge_det hle hle' hue hue' hx hx' j hj with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · exact hne (Prod.ext h1 h2)
    · exact edges_no_swap hnd (by omega) he he' h1 h2

end Lean42
