#!/usr/bin/env bash
# Lead 1 queue: all lengths 28..34 with -prime, in resumable parts. Safe to start again at any time.
cd "$(dirname "$0")"
export ENUM_OPTS=-prime TAG=prime
./run_parts.sh 28 2 0 1
./run_parts.sh 30 8 $(seq 0 7)
./run_parts.sh 32 32 $(seq 0 31)
./run_parts.sh 34 128 $(seq 0 127)
