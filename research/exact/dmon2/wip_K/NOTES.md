# K_stairg notes (copied into the repository by the coordinator)

enum_s3.cpp = enum_v.cpp + patch.py + patch2.py. Flags: -stairg K (0/1/9), -arcmin M, -nos3leaf, -dumpcand F, -dumpclosed F.
arcinj.cpp L K: arc enumeration + injectivity + certificates (moves). L <= 15 has 0 certificate failures, so -arcmin 16 is valid.
py/: l3lib.py, cert.py (independent checks), task1*.py, recheck.py, arc_check.py (Python agrees with C++ for L <= 12).
Results: ./table.sh; out/*.log. G2m16 output = F at 24..30, G1m16 output = F0.
Running: matrix.sh (N = 32), arcinj 16 then 17 (arc/arc16.log).
Next: finish N = 32, then write the report.

Update 28 Nov: matrix finished (N = 24..32, table.sh). L = 16: 14 arcs failed the default certificate search
(20000 states, +4 edges). With CLIM=400000 CEXT=6 (CERTFILE mode of arcinj) all 14 are certified, so L* = 16 and
-arcmin 17 is valid (N <= 34). arc17 was killed by the reboot. retime.sh re-times F0, F, G1, G2 and G2k0 at N = 28..32 on a quiet machine.

Round 2 (28 Nov): enum_s3b = enum_s3.cpp + -onemax (S5, Lemma M debt plus Lemma M in l3s_arc). The gap runs
(gG2m*, no onemax) and onemax runs (oG*) are finished, out/*.log. arcinj2 = arcinj + one-max certificate (much faster);
arcinj2s = arcinj2 with sharding (SHARD=i/S, SHD=depth). L <= 16 certified with arcinj2 (arc/m_arc*.log).
Running: arcinj2 17 then 18 (arc/m_arc17.log, m_arc18.log). Estimate for L = 18: 3-6 h on one core.

Wrap-up (28 Nov):
Measured: S4 below its threshold (N > 2M) recovers about 5 % (gG2m*). -onemax alone recovers 86.5 / 86.5 / 79.2 % at
N = 28 / 30 / 32 (oG2m0); with -arcmin 16 at N = 32 it recovers 100.7 %. Outputs equal F (G2) and F0 (G1).
L* = 17 certified (arc/m_arc17.log, 1511 s, 0 failures) -> M = 18 valid for N <= 36.
Running: nohup loop "./arcinj2 18 3 m > arc/m_arc18.log" (estimated 3-6 h, 1 core).
Next step: when arc/m_arc18.log has its t= line and cert_fail=0, M = 19 is valid (N <= 38); then run
G2 = run.sh enum_s3b N tag -plane4 -tauz 1 -stairg 1 -onemax -arcmin 19 at N = 34..38 against F.
