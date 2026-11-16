census_from_survivors.py -- flip + symmetry census seeded by a list of lattice words
=====================================================================================

USAGE
  python3 census_from_survivors.py WORDS_FILE [--alex "1,-3,1"] [--limit 2000000]

  WORDS_FILE   one word per line (letters e w n s u d = +x -x +y -y +z -z).
               Blank lines and lines starting with '#' are skipped; if a line has
               several fields the word is the last field.
  --alex       keep only words whose Alexander polynomial equals the list (lowest
               degree first) up to reversal and overall sign. Computed with
               identify_words.alexander_of (research/exact/identify_words.py).
  --limit      abort if the flip closure exceeds this many polygons.

  Reuses canon, flips, group, apply_g, word_to_verts, verts_to_word and
  is_closed_saw from research/exact/check/crosscheck.py. Single-threaded.

STEPS
  1. Read words; closed self-avoiding polygons are kept, others are reported and dropped.
  2. Optional Alexander filter; all kept words must have the same length n.
  3. Corner-flip BFS on canon values from the kept polygons (up to translation).
  4. Apply all 48 elements of G to the closure, canon each image.
  5. Statistics and a 200-polygon check that the G-union is closed under flips.
  6. Summary block.

WHAT THE NUMBERS MEAN
  n            length of the words (all kept words must share it)
  kept         input words that survived the filters (duplicates counted)
  distinct seeds  number of distinct canon values among the kept words
  F            size of the flip closure of the seeds (set of canon values)
  flip classes inside F   connected components of the flip graph on F
                          (= flip classes of the seeds); size distribution given
  T_rot        number of distinct canon values obtained by applying the 24
               rotations (det +1) to the flip closure F
  T            same with all 48 signed permutations (the symmetry-closed set)
  flip_classes_of_T   connected components of the flip graph restricted to T
                      (T is flip-closed, so these are its full flip classes)
  G-orbits     number of orbits of G on T, with the orbit-size distribution
  achiral      polygons P such that some rotation image of P equals some
               mirror (det -1) image of P, up to translation
  flip closure check   200 random polygons of T, all corner flips computed;
                       "0 outside T" confirms T is closed under flips

TEST (n24_psi.txt: 50 words, all trefoils, n = 24)

  Command 1:  python3 census_from_survivors.py /home/user/-K-NOT_THEORY/research/exact/out/n24_psi.txt
  Command 2:  python3 census_from_survivors.py /home/user/-K-NOT_THEORY/research/exact/out/n24_psi.txt --alex "1,-1,1"

--- output of command 1 ---
read 50 words from /home/user/-K-NOT_THEORY/research/exact/out/n24_psi.txt (0 lines skipped: not made of e/w/n/s/u/d)
no Alexander filter
kept words = 50, distinct seeds (canon) = 50, n = 24
flip closure F = 2592
flip classes inside F = 24; size distribution (size: count) = {1: 8, 18: 8, 305: 8}
T_rot (24 rotations applied to F) = 3328
T (48 symmetries applied to F)    = 3328
flip classes of the full set T = 80; size distribution (size: count) = {1: 24, 18: 48, 305: 8}
flip-closure check on 200 random polygons of T: 873 flip results, 0 outside T (closed)
G-orbits in final set = 75; orbit-size distribution (size: count) = {8: 1, 16: 2, 24: 7, 48: 65}
achiral polygons (mirror image equals a rotation image) = 0 of 3328
T equals union of disjoint orbits: True

elapsed 5.3 s

=== SUMMARY ===
n=24  kept=50  F=2592  flip_classes=24  T_rot=3328  T=3328  G_orbits=75  flip_classes_of_T=80

--- output of command 2 (--alex "1,-1,1") ---
read 50 words from /home/user/-K-NOT_THEORY/research/exact/out/n24_psi.txt (0 lines skipped: not made of e/w/n/s/u/d)
Alexander filter [1, -1, 1] (up to reversal and sign): kept 50 of 50 words
kept words = 50, distinct seeds (canon) = 50, n = 24
flip closure F = 2592
flip classes inside F = 24; size distribution (size: count) = {1: 8, 18: 8, 305: 8}
T_rot (24 rotations applied to F) = 3328
T (48 symmetries applied to F)    = 3328
flip classes of the full set T = 80; size distribution (size: count) = {1: 24, 18: 48, 305: 8}
flip-closure check on 200 random polygons of T: 873 flip results, 0 outside T (closed)
G-orbits in final set = 75; orbit-size distribution (size: count) = {8: 1, 16: 2, 24: 7, 48: 65}
achiral polygons (mirror image equals a rotation image) = 0 of 3328
T equals union of disjoint orbits: True

elapsed 5.8 s

=== SUMMARY ===
n=24  kept=50  F=2592  flip_classes=24  T_rot=3328  T=3328  G_orbits=75  flip_classes_of_T=80

RESULT
  T = 3328 and 75 G-orbits are reproduced. The full set T has 80 flip classes
  (8 of size 305, 48 of size 18, 24 of size 1), as expected.
  From the 50 seeds alone, the flip closure F has 2592 polygons in 24 classes
  (8 of size 305, 8 of size 18, 8 of size 1). The remaining 736 polygons of T
  are not reachable from these seeds by flips.
  Runtime: about 5 s per run.
  A filter that keeps no words (e.g. --alex "1,-3,1") stops with an error.
