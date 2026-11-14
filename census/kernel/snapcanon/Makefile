# snapcanon: canonical identity strings of knot complements (SnapPea kernel + Regina).
#
# Build:   make                 -> libsnapcanon.a and snapcanon_cli
# Needs:   gcc, g++ with C++20, Regina 7.4 built in REGINA_BUILD (libregina-engine),
#          and the libraries Regina itself links against (gmp, gmpxx, xml2, z, bz2,
#          tokyocabinet).  Override paths with e.g.  make REGINA_BUILD=/path/to/build/engine
# See README.md for the kernel file list and the SNAPCANON changes.

CC           ?= gcc
CXX          ?= g++
# Point these at your Regina 7.4.1 checkout and its build (see ../../BUILD.md); no default on purpose.
ifndef REGINA_SRC
$(error set REGINA_SRC=/path/to/regina/src/engine)
endif
ifndef REGINA_BUILD
$(error set REGINA_BUILD=/path/to/regina/build/engine)
endif

KDIR  := snappea
BUILD := build

# Kernel sources: exactly the files selected by the link-driven closure, plus the shims.
KFILES := snappea/kernel_code/Dehn_coefficients.c snappea/kernel_code/canonize_part_1.c snappea/kernel_code/canonize_part_2.c snappea/kernel_code/canonize_result.c snappea/kernel_code/change_peripheral_curves.c snappea/kernel_code/chern_simons.c snappea/kernel_code/choose_generators.c snappea/kernel_code/close_cusps.c snappea/kernel_code/complex.c snappea/kernel_code/core_geodesics.c snappea/kernel_code/current_curve_basis.c snappea/kernel_code/cusp_cross_sections.c snappea/kernel_code/cusp_neighborhoods.c snappea/kernel_code/cusp_shapes.c snappea/kernel_code/cusps.c snappea/addl_code/dilog.c snappea/kernel_code/edge_classes.c snappea/kernel_code/filling.c snappea/kernel_code/find_cusp.c snappea/kernel_code/finite_vertices.c snappea/kernel_code/gcd.c snappea/kernel_code/gluing_equations.c snappea/kernel_code/holonomy.c snappea/kernel_code/hyperbolic_structure.c snappea/kernel_code/identify_solution_type.c snappea/kernel_code/intersection_numbers.c snappea/kernel_code/link_complement.c snappea/kernel_code/my_malloc.c snappea/kernel_code/o31_matrices.c snappea/kernel_code/orb_cusp_area.c snappea/kernel_code/orb_cusps.c snappea/kernel_code/orb_hyperbolic_structure.c snappea/kernel_code/orb_identify_solution_type.c snappea/kernel_code/orb_tetrahedron_development.c snappea/kernel_code/orb_tilts.c snappea/kernel_code/orb_volume.c snappea/kernel_code/orient.c snappea/kernel_code/peripheral_curves.c snappea/kernel_code/positioned_tet.c snappea/kernel_code/precision.c snappea/kernel_code/shortest_cusp_basis.c snappea/kernel_code/simplify_triangulation.c snappea/kernel_code/solve_equations.c snappea/kernel_code/string.c snappea/kernel_code/subdivide.c snappea/kernel_code/tables.c snappea/kernel_code/tet_shapes.c snappea/kernel_code/tidy_peripheral_curves.c snappea/kernel_code/transcendentals.c snappea/kernel_code/triangulations.c snappea/kernel_code/update_shapes.c snappea/kernel_code/volume.c $(KDIR)/snapcanon_shims.c
KOBJS  := $(patsubst %.c,$(BUILD)/kernel/%.o,$(KFILES))

KCFLAGS := -O2 -std=gnu99 -fPIC -w \
           -I$(KDIR)/headers -I$(KDIR)/headers/precision/double \
           -I$(KDIR)/addl_code -I$(KDIR)/kernel_code -I$(KDIR) \
           -include $(KDIR)/snapcanon_rand.h

CXXFLAGS := -O3 -std=c++20 -fPIC -Wall -Wextra -I. -Isrc -isystem $(REGINA_SRC) -isystem $(REGINA_BUILD)
LDLIBS   := -L$(REGINA_BUILD) -lregina-engine -Wl,-rpath,$(REGINA_BUILD) \
            -lgmp -lgmpxx -lxml2 -lz -lbz2 -ltokyocabinet -lm

BRIDGE_OBJ := $(BUILD)/bridge/kernel_bridge.o
CPP_OBJS   := $(BUILD)/snapcanon.o
LIB_OBJS   := $(KOBJS) $(BRIDGE_OBJ) $(CPP_OBJS)

all: libsnapcanon.a snapcanon_cli

libsnapcanon.a: $(LIB_OBJS)
	ar rcs $@ $(LIB_OBJS)

snapcanon_cli: $(BUILD)/snapcanon_cli.o libsnapcanon.a
	$(CXX) -O3 -std=c++20 -o $@ $(BUILD)/snapcanon_cli.o -Wl,--start-group libsnapcanon.a -Wl,--end-group $(LDLIBS)

$(BUILD)/kernel/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c $(KCFLAGS) $< -o $@

$(BRIDGE_OBJ): src/kernel_bridge.c src/kernel_bridge.h
	@mkdir -p $(dir $@)
	$(CC) -c $(KCFLAGS) src/kernel_bridge.c -o $@

$(CPP_OBJS): src/snapcanon.cpp snapcanon.h src/kernel_bridge.h
	@mkdir -p $(dir $@)
	$(CXX) -c $(CXXFLAGS) src/snapcanon.cpp -o $@

$(BUILD)/snapcanon_cli.o: src/snapcanon_cli.cpp snapcanon.h
	@mkdir -p $(dir $@)
	$(CXX) -c $(CXXFLAGS) src/snapcanon_cli.cpp -o $@

clean:
	rm -rf $(BUILD) libsnapcanon.a snapcanon_cli

.PHONY: all clean
