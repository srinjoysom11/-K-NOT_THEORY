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
