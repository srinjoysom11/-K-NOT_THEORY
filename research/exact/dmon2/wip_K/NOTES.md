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
