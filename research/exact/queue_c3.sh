#!/bin/bash
# Local repeat of n = 30 and n = 32 with -tourcap 3, to compare survivors with the
# GitHub Actions runs made with the old cap 3000. Resumable (run_parts.sh skips finished parts).
cd "$(dirname "$0")"
export ENUM_OPTS="-prime -tourcap 3" TAG=primec3
./run_parts.sh 30 8 $(seq 0 7)
./run_parts.sh 32 32 $(seq 0 31)
