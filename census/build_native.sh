#!/usr/bin/env bash
# Build every native kernel.  Requires REGINA_SRC and REGINA_BUILD (see BUILD.md).
set -euo pipefail
: "${REGINA_SRC:?set REGINA_SRC=/path/to/regina/src/engine}"
: "${REGINA_BUILD:?set REGINA_BUILD=/path/to/regina/build/engine}"
cd "$(dirname "$0")/kernel"
LIBS="-L$REGINA_BUILD -lregina-engine -Wl,-rpath,$REGINA_BUILD -lgmp -lgmpxx -lxml2 -lz -lbz2 -ltokyocabinet"
for k in gen bfsclose search unknot expert r3close; do
  g++ -O3 -march=native -std=c++20 -I"$REGINA_SRC" -I"$REGINA_BUILD" $k.cpp -o $k $LIBS
done
g++ -O3 -march=native -std=c++20 shadows.cpp -o shadows          # no Regina needed
g++ -O2 -std=c++20 -Wall -Wextra pass.cpp -o pass                # standard library only
make -C snapcanon REGINA_SRC="$REGINA_SRC" REGINA_BUILD="$REGINA_BUILD"
echo "built: gen shadows bfsclose search unknot expert r3close pass snapcanon/snapcanon_cli"
