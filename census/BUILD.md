# Building the census tools

Tested on Linux x86-64 (Ubuntu 24.04), gcc/g++ 13, Python 3.13, 4 cores, 15 GB RAM.

## 1. Regina's C++ engine (not bundled; build it once)
The pip wheel of Regina has no headers and links its engine statically into a Python module, so the C++ kernels
need the engine built from source:

    sudo apt-get install cmake libgmp-dev libxml2-dev libbz2-dev zlib1g-dev libtokyocabinet-dev pkg-config
    git clone --depth 1 --branch regina-7.4.1 https://github.com/regina-normal/regina.git
    mkdir regina/build && cd regina/build
    cmake ../ -DCMAKE_BUILD_TYPE=Release -DDISABLE_GUI=1 -DDISABLE_PYTHON=1 -DDISABLE_UTILS=1 -DREGINA_INSTALL_TYPE=XDG
    make -j4 regina-engine

## 2. Python environment
    python3 -m venv .venv && . .venv/bin/activate
    pip install snappy regina numpy scipy scikit-learn      # torch only for census/ml (pip install torch)

## 3. Native kernels
    export REGINA_SRC=/path/to/regina/src/engine REGINA_BUILD=/path/to/regina/build/engine
    bash census/build_native.sh        # builds kernel/{gen,shadows,bfsclose,search,unknot,expert,r3close,pass}
                                       # and kernel/snapcanon/{libsnapcanon.a,snapcanon_cli}

## 4. Run
    cd census
    KNOT_DATA=data_run python -m knotml.build3 3 13        # exact census, levels 3..13 (about 2 min on 4 cores)
    KNOT_DATA=data_run python -m knotml.build3 14 14       # level 14 (about 13 min); needs ~10 GB RAM headroom
    KNOT_DATA=data_run python -m knotml.verify 14          # independent duplicate-id check over all levels <= 14
    kernel/pass --H 3 --paths 8 < ml/unknots/all_unknots.txt   # the published hard unknot diagrams
