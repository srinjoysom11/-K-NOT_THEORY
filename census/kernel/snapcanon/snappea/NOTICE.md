# Origin and license of the files in this directory

The C sources under `kernel_code/`, `addl_code/` and `headers/` are copied unmodified from the SnapPea
kernel as shipped in SnapPy, `src/snappy/extensions/SnapPy/kernel/`, repository
https://github.com/3-manifolds/SnapPy at commit `8b4e86feb4c326b3f24367f6011da91d78775910`
(checked out 2026-11-13), except where a line is marked `/* SNAPCANON: ... */`.
`snapcanon_shims.c` and `snapcanon_rand.h` are new glue written for this project.

License of the copied code: Copyright 2007-present Marc Culler, Nathan Dunfield, Matthias Goerner,
Jeff Weeks and others. Released under the GNU General Public License, version 2, or (at your option)
any later version (statement taken from SnapPy's README, https://github.com/3-manifolds/SnapPy).
The individual source files do not carry a license header; this notice records it. Anything linked with
this code, including `libsnapcanon.a` and `snapcanon_cli`, is therefore GPL-2.0-or-later.
