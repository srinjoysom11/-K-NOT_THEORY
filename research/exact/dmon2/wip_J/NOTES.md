# J_next: enum_u.cpp (from dmon2/enum_v.cpp), working notes

Final source: enum_u_final.cpp (= enum_u.cpp). Base flags F: F.sh (walk 8 N/2). Best: F + `-gwv 1 -walkc 2 -pre1 -w3ent 2 -w3nb 3 -w3inc 1 -walk 8 N/2+2`.
Reference words (from enum_v, F): N=24 21 words sha256 12be80af..., 26: 26 / 3e80935c..., 28: 12 / 2f08cf5e...,
30: 52 / 2afd0fae..., 32: 248 / 1673400e..., 34 (F = best): 467 / c78546f6.... All variants byte-identical.

Final timings (user s, idle machine, results2.txt, Z_* rows): N=28 F 3.06-3.22 / best 1.00-1.07; N=30 F 18.6-18.9 /
best 4.96-5.41; N=32 F 83.6-85.0 / best 20.7-21.5; N=34 (loaded machine, older binary) F 301 / best 79.
Nodes F -> best: 1.10M -> 0.395M, 5.26M -> 1.84M, 18.9M -> 6.90M, 70.6M -> 26.2M.

Nothing running. Next step: per-state cost of w3_dfsc (now ~46% of time), GW3 prep (16%), setup (14%).
Copied into the repository by the coordinator (dmon2/enum_u.cpp, dmon2/wip_J/).
