# Lemma 3* and Lemma 5*: a primeness-free replacement for -stair (agent K, 28 Nov 2026)

## Result
With the length lemma S4 (`-arcmin 16`) the primeness-free rules recover all of `-stair`'s pruning at
n = 28, 30, 32, with the same output. Lemma 3* alone recovers only 1-4 %.

| n | F0 nodes / s | F nodes / s | G1 nodes / s | G2 nodes / s |
|---|---|---|---|---|
| 28 | 4,047,401 / 12.6 | 1,100,295 / 3.29 | 1,156,176 / 3.72 | 1,075,873 / 3.42 |
| 30 | 19,319,928 / 71.9 | 5,255,109 / 19.1 | 5,494,521 / 20.3 | 5,183,413 / 19.2 |
| 32 | 70,877,286 / 309 | 18,903,418 / 89.1 | 19,716,904 / 91.0 | 18,652,919 / 85.1 |

F0 = F without `-stair`; G1 = F0 + `-stairg 1 -arcmin 16`; G2 = F with `-stair` replaced by
`-stairg 1 -arcmin 16`. G2 output = F, G1 output = F0, at n = 24..32. `-threads 1`, quiet machine.

## Where -stair's gain comes from
Almost all of it is `-prime`'s interior rule (a plane with two occupied levels on each side needs 4
crossings). The outer stair rule, `-plane4` (Lemma F2) and `-tauz` already hold for every knot type.

## Lemmas
* **Lemma 3*.** If a lattice mid-plane is crossed exactly twice by a shortest polygon of any knot type,
  and a side alpha (with the two half-edges down to the plane) projects injectively to the plane along
  some direction v with positive normal component, then alpha is a geodesic. Proof: the curtain from
  alpha to the plane is an embedded disk that meets the polygon only in alpha, so alpha moves to the
  geodesic b' relative to its ends; minimality forces |alpha| = |b'|.
* **Lemma 5* (computer lemma).** Every non-geodesic arc in a half-space with at most L* edges, no reversal
  and no U-turn (also with the two crossing letters) can be moved inside the open half-space, ends
  fixed, by corner flips and +-2 moves (Delta-moves over unit squares in the open half-space) to an arc
  injective along one of 129 directions (a, b, c), |a|, |b| <= 3, 1 <= c <= 3, gcd 1. Verified for
  L* = 15 (17,969,728 non-geodesic arcs at L = 15; 128,931 needed moves, at most 4) and L* = 16
  (68,995,889 arcs; 14 needed a larger search, all certified). L* <= 18 always (knotted 19-edge arcs).
* **Corollary.** A non-geodesic side of a twice-crossed plane of a shortest polygon has >= L* + 1 edges.
* **Rule S4 (`-arcmin M`, M = L* + 1).** Plane p needs 4 crossings if both sides are surely non-geodesic and
  N - 2 < 2M, or if a surely non-geodesic side has fewer than M edges left. For N <= 2M + 2 this is
  exactly `-prime`'s interior rule.

## Range
M = 16 is valid for N <= 32 as a full replacement, M = 17 for N <= 34. At N = 42 even L* = 18 gives
2M + 2 = 40 < 42, so S4 there is the weaker "side left fewer than M edges" form: to be measured.

## Soundness checks
Every closed walk that the new rules remove (from F0 or weaker bases, n = 20..26) was re-checked in
Python: each is justified by Lemma 3*, Lemma 5* (Python-found certificate) or F2. An independent Python
enumeration agrees with the C++ arc counts and certificates for L <= 12.

Files: enum_s3.cpp (= enum_v.cpp + patch.py + patch2.py; flags -stairg K, -arcmin M, -nos3leaf,
-dumpcand, -dumpclosed), arcinj.cpp (arc enumeration and certificates), py/ (checks), logs/.

## Round 2 (28 Nov): the n = 42 regime, Lemma M, L* = 17

* **S4 is all-or-nothing.** It fires only for N <= 2M. With slack s = N - 2M = 2, 4, 6 (N = 42 with
  M = 19 has s = 4) it recovers only 4.6-6.3 % of `-stair`'s node gain at N = 30, 32.
* **Lemma M (one maximum, no length bound).** If a mid-plane is crossed exactly twice and a side alpha
  (with its half-edges) has normal height that rises weakly and then falls weakly (one top plateau),
  then alpha is isotopic rel ends inside the open half-space to the geodesic: tilt the plateaus by less
  than 1/2, then sweep down level by level with Delta-moves across triangles spanned by the two points of
  alpha on consecutive vertex levels (each triangle lies in its slab and in the open half-space). So in a
  shortest polygon of any knot type such a side is a geodesic, and a non-geodesic side has a valley,
  hence a plane inside it crossed at least 4 times.
* **Rule S5 (`-onemax`):** with levels mn..mx (mx - mn >= 2), one of the planes {mn, mn+1} and one of
  {mx-2, mx-1} must be crossed at least 4 times; the debt is charged to the cheapest choice; sound when
  the level range widens (each new plane owes 2 and has 0).
* **Measured (G2 = F with -stair replaced by -stairg 1 -onemax), output = F at every N:**

| N | M | slack | without -onemax: recovered | with -onemax: nodes / s / recovered |
|---|---|---|---|---|
| 30 | 13 | 4 | 5.1 % | 7,157,466 / 28.2 / 86.5 % |
| 32 | 16 | 0 | 100.5 % | 18,534,422 / 85.8 / 100.7 % |
| 32 | 14 | 4 | 5.5 % | 29,665,894 / 161.5 / 79.3 % |

  `-onemax` alone (no S4): 86.5 % (N = 28), 86.5 % (30), 79.2 % (32). Expected at N = 42: under 80 %,
  i.e. about 1.2-1.3x the nodes of `-stair`, not measured.
* **Certificates:** `arcinj2` counts one-maximum arcs as certified (10-13x faster). L = 17: 268,344,581
  non-geodesic arcs, 0 uncertified, so L* = 17, M = 18 (N <= 36). L = 18 (about 1e9 arcs, 3-6 h on one
  core) was started locally; if it certifies, M = 19 covers N <= 38.
* Every removed closed walk at n = 20..26 (weak bases) was re-checked in Python: justified by Lemma M,
  Lemma 3* or F2.
