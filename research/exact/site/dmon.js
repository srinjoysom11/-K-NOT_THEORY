// Web figure: the seven DMON tests, one wordless animatic each, on the 36-step polygon |w36|.
// Whole polygons are cel-shaded 3D (DMON1, 2, 3, 6, 7); local pictures are flat axonometric (DMON4, 5).
import { DATA } from './data.js';
import { Studio, THREE, HULL_MAT, pointAt, hasGL } from './studio.js';
import { player, Flat, PAS, INK, seg, out3, inout, pop, lerp, axisTone } from './anim.js';

const U = { e: [1, 0, 0], w: [-1, 0, 0], n: [0, 1, 0], s: [0, -1, 0], u: [0, 0, 1], d: [0, 0, -1] };
const AXI = { e: 0, w: 0, n: 1, s: 1, u: 2, d: 2 };
const add = (a, b, s = 1) => [a[0] + s * b[0], a[1] + s * b[1], a[2] + s * b[2]];
const key = (p) => p.join(',');
const V = DATA.w36.verts, WORD = DATA.w36.word, n = V.length;
const IDX = new Map(V.map((p, i) => [key(p), i]));
const VIEW = [1, -1.68, 1.05];   // the flat drawings' view direction, so the two styles agree
const R = 0.1;

function H(tag, attrs = {}, ...kids) {
  const e = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs)) { if (k === 'class') e.className = v; else if (v != null) e.setAttribute(k, v); }
  for (const k of kids) if (k != null) e.append(k); return e;
}

// ---------------------------------------------------------------- cel helpers
function stick(st, parent, color, r = R) {   // one rod whose ends move every frame
  const cyl = new THREE.CylinderGeometry(r, r, 1, 20, 1, true), up = new THREE.Vector3(0, 1, 0);
  const m = new THREE.Mesh(cyl, st.material(color)), h = new THREE.Mesh(cyl, HULL_MAT), k = 1 + st.hullW / r;
  parent.add(h, m);
  return {
    mat: m.material,
    set(a, b) {
      const A = new THREE.Vector3(...a), B = new THREE.Vector3(...b), L = A.distanceTo(B);
      m.visible = h.visible = L > 1e-4; if (!m.visible) return;
      m.scale.set(1, L, 1); h.scale.set(k, L, k); m.position.copy(A).add(B).multiplyScalar(0.5); h.position.copy(m.position);
      m.quaternion.setFromUnitVectors(up, B.clone().sub(A).normalize()); h.quaternion.copy(m.quaternion);
    },
    hide() { m.visible = h.visible = false; },
  };
}
function cone(st, parent, color, r = 0.2, len = 0.42) {   // an arrow head that sits at tip, pointing along dir
  const g = new THREE.Group(), geo = new THREE.ConeGeometry(1, 1, 24);
  const m = new THREE.Mesh(geo, st.material(color)); m.scale.set(r, len, r);
  const h = new THREE.Mesh(geo, HULL_MAT); h.scale.set(r + st.hullW * 1.3, len + st.hullW * 2.6, r + st.hullW * 1.3);
  g.add(h, m); parent.add(g); const up = new THREE.Vector3(0, 1, 0);
  return { g, set(tip, dir, s = 1) { g.visible = s > 0.01; g.scale.setScalar(Math.max(0.001, s)); const d = new THREE.Vector3(...dir).normalize(); g.quaternion.setFromUnitVectors(up, d); g.position.set(...tip).addScaledVector(d, -len * 0.5 * s); } };
}
function quadMesh(st, parent, color, opacity = 0.6) {   // a face whose corners move every frame
  const g = new THREE.BufferGeometry(); g.setAttribute('position', new THREE.Float32BufferAttribute(new Array(18).fill(0), 3));
  const m = new THREE.Mesh(g, new THREE.MeshBasicMaterial({ color, transparent: true, opacity, side: THREE.DoubleSide, depthWrite: false }));
  parent.add(m);
  return { m, set(c, op) { const P = [c[0], c[1], c[2], c[0], c[2], c[3]].flat(); g.attributes.position.array.set(P); g.attributes.position.needsUpdate = true; g.computeBoundingSphere(); if (op != null) m.material.opacity = op; m.visible = op == null || op > 0.01; } };
}
function burst(st) {   // an ink ring that grows and fades, facing the viewer
  const m = new THREE.Mesh(new THREE.TorusGeometry(1, 0.05, 10, 64), new THREE.MeshBasicMaterial({ color: INK, transparent: true }));
  m.userData.billboard = true; m.visible = false; st.world.add(m);
  return (p, k, r0 = 0.25, r1 = 1.0) => { m.visible = k > 0 && k < 1; if (!m.visible) return; m.position.set(...p); m.scale.setScalar(r0 + (r1 - r0) * out3(k)); m.material.opacity = 1 - k; m.geometry.parameters; };
}
const tone = (a, b) => axisTone(a, b);
function polyRods(st, parent, pts, { r = R, color, closed = true } = {}) {
  const out = []; const m = closed ? pts.length : pts.length - 1;
  for (let i = 0; i < m; i++) { const a = pts[i], b = pts[(i + 1) % pts.length]; out.push(st.rod([a, b], { color: color || tone(a, b), radius: r, parent })); }
  return out;
}
function celStage(stage, label, pts, margin = 1.06) {
  const st = new Studio(stage, { cel: true, aspect: '1 / 1', label, hull: 0.038, fov: 22 });
  st.frame(pts, VIEW, margin);
  return st;
}
const bead = (st, p, color, r = 0.17) => st.ball(p, { color, radius: r });
const setK = (o, k) => { o.visible = k > 0.01; o.scale.setScalar(Math.max(0.001, pop(k))); };

// ---------------------------------------------------------------- DMON1: the walk closes up
function dmon1(stage) {
  const st = celStage(stage, 'DMON1: the walk returns to its start', V);
  const g = new THREE.Group(); st.world.add(g);
  const rods = polyRods(st, g, V);
  const part = stick(st, g, PAS.blue);
  const head = bead(st, V[0], PAS.pink, 0.21);
  st.ball(V[0], { color: INK, radius: 0.19 });
  const ring = burst(st);
  return (t) => {
    const p = n * inout(seg(t, 0.4, 6.4)), e = Math.floor(p), f = p - e;
    rods.forEach((r, i) => { r.visible = i < e; });
    if (e < n) { const a = V[e], b = V[(e + 1) % n]; part.mat.color.set(tone(a, b)); part.set(a, lerp(a, b, f)); head.visible = true; head.position.set(...lerp(a, b, f)); }
    else { part.hide(); head.visible = false; }
    ring(V[0], seg(t, 6.4, 7.4), 0.25, 1.3);
    st.request();
  };
}

// ---------------------------------------------------------------- DMON2: every vertex is visited once
function dmon2(stage) {
  const st = celStage(stage, 'DMON2: no vertex is visited twice', V);
  const g = new THREE.Group(); st.world.add(g);
  polyRods(st, g, V, { color: PAS.grey, r: 0.085 });
  const dots = V.map((p) => { const b = bead(st, p, PAS.green, 0.15); b.visible = false; return b; });
  const head = bead(st, V[0], PAS.pink, 0.22);
  // the tempting wrong step: from vertex gv, a lattice step to a vertex visited long before
  let gv = 0, gq = null;
  outer: for (let i = Math.floor(n / 2); i < n - 1; i++) for (const d of Object.values(U)) { const q = add(V[i], d), j = IDX.get(key(q)); if (j != null && j < i - 2) { gv = i; gq = j; break outer; } }
  const ghost = stick(st, g, PAS.red, 0.09), ghostTip = cone(st, g, PAS.red, 0.17, 0.34);
  const cross = new THREE.Group(); st.world.add(cross);
  const T1 = 4.6, T2 = 6.8;
  const sOf = (t) => (t < T1 ? gv * seg(t, 0.4, T1) : t < T2 ? gv : gv + (n - gv) * seg(t, T2, 10));
  return (t) => {
    const s = sOf(t);
    dots.forEach((b, j) => { const k = seg(s, j - 0.001, j + 0.35); setK(b, j === 0 ? Math.max(k, 1) : k); b.material.color.set(j === gq && t > T1 + 0.9 && t < T2 - 0.3 ? PAS.red : PAS.green); });
    head.position.set(...pointAt(V, s % n)); head.visible = s < n - 0.02;
    const k = t < T1 ? 0 : t < T1 + 0.8 ? out3(seg(t, T1, T1 + 0.8)) * 0.72 : t < T2 - 0.6 ? 0.72 : 0.72 * (1 - seg(t, T2 - 0.6, T2 - 0.1));
    const a = V[gv], b = V[gq];
    if (k > 0.01) { const tip = lerp(a, b, k); ghost.set(a, tip); ghostTip.set(tip, add(b, a, -1), 1); } else { ghost.hide(); ghostTip.set(a, [0, 0, 1], 0); }
    st.request();
  };
}

// ---------------------------------------------------------------- DMON3: the lowest vertex is the start
function dmon3(stage) {
  const zMin = Math.min(...V.map((p) => p[2])), onPlane = V.filter((p) => p[2] === zMin);
  const yMin = Math.min(...onPlane.map((p) => p[1])), onLine = onPlane.filter((p) => p[1] === yMin);
  const xMin = Math.min(...onLine.map((p) => p[0])), O = [xMin, yMin, zMin];
  const X0 = -2, X1 = 4.4, Y0 = -1.8, Y1 = 3.8;
  const st = celStage(stage, 'DMON3: the start is the lowest vertex', V.concat([[X0, Y0, zMin], [X1, Y0, zMin], [X1, Y1, zMin], [X0, Y1, zMin]]), 1.02);
  const g = new THREE.Group(); st.world.add(g);
  polyRods(st, g, V);
  const box = new THREE.BoxGeometry(1, 1, 1);
  const slab = new THREE.Group(), slabM = st.material(PAS.sky), slabH = HULL_MAT.clone(); slabH.transparent = true;
  { const a = new THREE.Mesh(box, slabM); a.scale.set(X1 - X0, Y1 - Y0, 0.05); const b = new THREE.Mesh(box, slabH); b.scale.set(X1 - X0 + 0.09, Y1 - Y0 + 0.09, 0.14); slab.add(b, a); }
  const strip = new THREE.Group(), stripM = st.material(PAS.verm), stripH = HULL_MAT.clone(); stripH.transparent = true;
  { const a = new THREE.Mesh(box, stripM); a.scale.set(X1 - X0, 0.42, 0.07); const b = new THREE.Mesh(box, stripH); b.scale.set(X1 - X0 + 0.09, 0.51, 0.16); strip.add(b, a); }
  st.world.add(slab, strip);
  const planeBeads = onPlane.map((p) => ({ p, b: bead(st, p, PAS.verm, 0.19) }));
  const slider = bead(st, O, PAS.pink, 0.27);
  const origin = st.ball(O, { color: INK, radius: 0.21 });
  const ring = burst(st);
  const axes = [[[1, 0, 0], PAS.verm], [[0, 1, 0], PAS.green], [[0, 0, 1], PAS.blue3]].map(([d, c]) => ({ d, s: stick(st, g, c, 0.15), c: cone(st, g, c, 0.28, 0.5) }));
  return (t) => {
    const rise = out3(seg(t, 0.7, 2.5)), fade = 1 - inout(seg(t, 7.0, 8.0));
    const pz = zMin - 3.2 * (1 - rise) - R - 0.03;
    slab.position.set((X0 + X1) / 2, (Y0 + Y1) / 2, pz - 0.025); slab.visible = seg(t, 0.7, 1.1) * fade > 0.01;
    slabM.opacity = slabH.opacity = seg(t, 0.7, 1.1) * fade;
    const ly = Y0 + (yMin - Y0) * out3(seg(t, 3.1, 4.6)), la = seg(t, 3.1, 3.4) * fade;
    strip.position.set((X0 + X1) / 2, ly, zMin - R - 0.02); strip.visible = la > 0.01; stripM.opacity = stripH.opacity = la;
    const lit = seg(t, 2.5, 2.8), litL = seg(t, 4.6, 4.9), axK = out3(seg(t, 7.2, 8.4));
    for (const { p, b } of planeBeads) {
      const onL = p[1] === yMin, k = onL ? lit * (1 - axK) * (p[0] === xMin && t > 6.4 ? 0 : 1) : lit * (1 - litL);
      setK(b, k); b.material.color.set(onL && litL > 0 ? PAS.green : PAS.verm);
    }
    const sx = X0 + (xMin - X0) * out3(seg(t, 5.2, 6.4));
    slider.visible = seg(t, 5.2, 5.4) > 0 && t < 6.45; slider.position.set(sx, yMin, zMin);
    setK(origin, seg(t, 6.4, 6.8)); ring(O, seg(t, 6.4, 7.2), 0.3, 1.1);
    axes.forEach(({ d, s, c }) => { const L = 1.5 * axK; if (axK > 0.01) { const tip = add(O, d, L); s.set(O, tip); c.set(add(tip, d, 0.27), d, 1); } else { s.hide(); c.set(O, d, 0); } });
    st.request();
  };
}

// ---------------------------------------------------------------- DMON6: every curtain has a vertex inside
function dmon6(stage) {
  const j = 4, i = 10, a = U[WORD[j]], k = i - j - 1;   // n, then u w w w w, then s: a curtain with k = 5
  const st = celStage(stage, 'DMON6: a curtain and its interior points', V);
  const g = new THREE.Group(); st.world.add(g);
  polyRods(st, g, V, { color: PAS.grey, r: 0.085 });
  const hi = []; for (let q = j; q <= i; q++) hi.push(st.rod([V[q], V[q + 1]], { color: q === j || q === i ? PAS.verm2 : PAS.verm, radius: 0.13, parent: g }));
  const sheets = []; for (let q = j + 1; q < i; q++) sheets.push({ q, m: quadMesh(st, g, PAS.green, 0.55), edge: stick(st, g, PAS.green2, 0.05) });
  const pts = []; for (let t = 2; t <= k; t++) pts.push(add(V[j + t], a, -1));
  const rings = pts.map((p) => ({ p, r: st.ball(p, { color: INK, radius: 0.2, hollow: true }), f: bead(st, p, PAS.green, 0.2), v: IDX.has(key(p)) }));
  const ring = burst(st);
  const firstV = rings.find((x) => x.v);
  return (t) => {
    hi.forEach((r, m) => { r.visible = t > 0.35 + m * 0.08; });
    const h = out3(seg(t, 1.4, 2.8));
    sheets.forEach(({ q, m, edge }) => { const A = V[q], B = V[q + 1]; m.set([A, B, add(B, a, -h), add(A, a, -h)], h > 0.01 ? 0.55 : 0); if (h > 0.01) edge.set(add(A, a, -h), add(B, a, -h)); else edge.hide(); });
    rings.forEach((x, m) => { const k2 = seg(t, 3.0 + m * 0.18, 3.5 + m * 0.18); setK(x.r, k2); setK(x.f, x.v ? seg(t, 4.2 + m * 0.25, 4.6 + m * 0.25) : 0); });
    if (firstV) ring(firstV.p, seg(t, 4.2, 5.0), 0.25, 0.9);
    st.request();
  };
}

// ---------------------------------------------------------------- DMON7: the fourth corner is a vertex
function dmon7(stage) {
  const CASES = [6, 22, 17];   // up then west; east then down; north then west
  const st = celStage(stage, 'DMON7: at a corner pattern, the fourth corner is a vertex', V);
  const g = new THREE.Group(); st.world.add(g);
  polyRods(st, g, V, { color: PAS.grey, r: 0.085 });
  const cs = CASES.map((i) => {
    const A = V[i - 1], B = V[i], C = V[i + 1], P = add(A, U[WORD[i]]);
    const grp = new THREE.Group(); g.add(grp);
    const corner = st.rod([A, B, C], { color: PAS.verm, radius: 0.13, parent: grp });
    const sq = quadMesh(st, grp, PAS.green, 0.55);
    const ar = stick(st, grp, PAS.green2, 0.07), tip = cone(st, grp, PAS.green2, 0.16, 0.32);
    const rg = st.ball(P, { color: INK, radius: 0.2, hollow: true }), fill = bead(st, P, PAS.green, 0.2);
    return { A, B, C, P, grp, corner, sq, ar, tip, rg, fill };
  });
  const ring = burst(st);
  const D = 3.3;
  return (t) => {
    cs.forEach((c, m) => {
      const last = m === cs.length - 1, u = t - 0.3 - m * D, on = u > 0 && (u < D || last);
      c.grp.visible = on; c.rg.visible = c.fill.visible = on;
      if (!on) return;
      const fade = last ? 1 : 1 - seg(u, D - 0.45, D - 0.05);
      c.corner.visible = u > 0.15 && (last || u < D - 0.3);
      c.sq.set([c.A, c.B, c.C, c.P], 0.55 * Math.min(seg(u, 0.4, 0.9), fade));
      setK(c.rg, Math.min(seg(u, 0.6, 1.0), fade));
      const k = out3(seg(u, 1.0, 1.8)) * 0.62 * fade;
      if (k > 0.01) { const e = lerp(c.B, c.P, k); c.ar.set(c.B, e); c.tip.set(lerp(c.B, c.P, k + 0.12), add(c.P, c.B, -1), fade); } else { c.ar.hide(); c.tip.set(c.B, [0, 0, 1], 0); }
      setK(c.fill, Math.min(seg(u, 1.9, 2.3), fade));
      ring(c.P, seg(u, 1.9, 2.6), 0.25, 0.9);
    });
    st.request();
  };
}

// ---------------------------------------------------------------- DMON4: the direction of travel (flat)
function dmon4(stage) {
  const F = new Flat(stage, { W: 600, H: 600, label: 'DMON4: the first step comes before the reverse of the last step in the order e, w, n, s, u, d' });
  const O = V[0], E1 = V[1], E2 = V[2], Z1 = V[n - 1], Z2 = V[n - 2];   // the origin, its e-neighbour and its u-neighbour
  const tailA = add(E2, U.e, 0.7), tailB = add(Z2, U.u, 0.7);
  F.fit([O, E2, Z2, tailA, tailB, [-0.6, 0, -0.4]], 40, [40, 10, 560, 400]);
  const order = 'ewnsud';
  const slotX = (k) => 62 + k * 95, slotY = 492;
  return (t) => {
    F.clear();
    const fwd = t < 6.2, u = fwd ? t : t - 6.2;
    const first = fwd ? 'e' : 'u', back = fwd ? 'u' : 'e';
    // the polygon near the origin: two edges each way, tails dashed
    F.path([tailA, E2, E1, O, Z1, Z2, tailB].slice(1, 6), {});
    F.line2(...F.pr(E2), ...F.pr(tailA), { 'stroke-dasharray': '3 9', 'stroke-width': 4 });
    F.line2(...F.pr(Z2), ...F.pr(tailB), { 'stroke-dasharray': '3 9', 'stroke-width': 4 });
    F.bead(O, { fill: INK, r: 12 });
    // the reading: a bead leaves along the first step and comes home along the last
    const go = seg(u, 0.4, 1.6), home = seg(u, 2.0, 3.2);
    const out1 = add(O, U[first], 1), out2 = add(O, U[back], 1);
    if (go > 0 && go < 1) F.bead(lerp(O, add(O, U[first], 2), go), { fill: PAS.pink, r: 12 });
    if (home > 0 && home < 1) F.bead(lerp(add(O, U[back], 2), O, home), { fill: PAS.pink, r: 12 });
    F.arrow(O, add(O, U[first], 0.95), { fill: PAS.verm, k: out3(seg(u, 0.4, 1.2)), w: 12, head: 26 });
    F.arrow(O, add(O, U[back], 0.95), { fill: PAS.blue3, k: out3(seg(u, 2.6, 3.4)), w: 12, head: 26 });
    // the order e < w < n < s < u < d as six little arrows
    const rk = seg(u, 3.4, 3.9);
    order.split('').forEach((l, k) => {
      const d = U[l], q = [d[0] * 0.94 + d[1] * 0.56, -(d[0] * -0.34 + d[1] * 0.42 + d[2])], m = Math.hypot(q[0], q[1]);
      const cx = slotX(k), L = 24, ux = q[0] / m, uy = q[1] / m;
      const hl = (l === first ? PAS.verm : l === back ? PAS.blue3 : null);
      if (hl && rk > 0) F.el('circle', { cx, cy: slotY, r: 33 * pop(rk), fill: hl, stroke: INK, 'stroke-width': 4 });
      F.line2(cx - ux * L, slotY - uy * L, cx + ux * (L - 14), slotY + uy * (L - 14), { 'stroke-width': 8 });
      F.el('polygon', { points: `${cx + ux * (L + 4)},${slotY + uy * (L + 4)} ${cx + ux * (L - 16) - uy * 12},${slotY + uy * (L - 16) + ux * 12} ${cx + ux * (L - 16) + uy * 12},${slotY + uy * (L - 16) - ux * 12}`, fill: INK, stroke: INK, 'stroke-width': 2, 'stroke-linejoin': 'round' });
      if (k < 5) F.el('text', { x: cx + 47.5, y: slotY + 2, 'font-size': 26, 'font-weight': 800, 'text-anchor': 'middle', 'dominant-baseline': 'central', fill: INK, class: 'flat-t' }).textContent = '<';
    });
    // the verdict: an arrow from the first step's slot to the last step's slot; right is good
    const vk = out3(seg(u, 4.1, 4.9));
    if (vk > 0) {
      const a = slotX(order.indexOf(first)), b = slotX(order.indexOf(back)), y = slotY + 66, xe = a + (b - a) * vk;
      F.line2(a, y, xe, y, { 'stroke-width': 8 });
      const dir = Math.sign(b - a);
      F.el('polygon', { points: `${xe + dir * 18},${y} ${xe - dir * 4},${y - 14} ${xe - dir * 4},${y + 14}`, fill: INK });
      const okk = seg(u, 4.9, 5.3);
      if (okk > 0) {
        const mx = 545, my = 78, s = pop(okk);
        F.el('circle', { cx: mx, cy: my, r: 30 * s, fill: fwd ? PAS.green : PAS.red, stroke: INK, 'stroke-width': 3 });
        if (fwd) F.el('path', { d: `M${mx - 13 * s},${my + 1 * s} L${mx - 3 * s},${my + 11 * s} L${mx + 15 * s},${my - 11 * s}`, fill: 'none', stroke: INK, 'stroke-width': 6, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' });
        else F.el('path', { d: `M${mx - 11 * s},${my - 11 * s} L${mx + 11 * s},${my + 11 * s} M${mx + 11 * s},${my - 11 * s} L${mx - 11 * s},${my + 11 * s}`, fill: 'none', stroke: INK, 'stroke-width': 6, 'stroke-linecap': 'round' });
      }
    }
  };
}

// ---------------------------------------------------------------- DMON5: sorted axes (flat)
function dmon5(stage) {
  const F = new Flat(stage, { W: 600, H: 600, label: 'DMON5: at most as many z-steps as y-steps, and at most as many y-steps as x-steps' });
  F.fit(V, 20, [0, 40, 380, 560]);
  const edges = V.map((a, i) => ({ a, b: V[(i + 1) % n], q: AXI[WORD[i]] }));
  const counts = [0, 0, 0]; edges.forEach((e) => { e.slot = counts[e.q]++; });
  const colX = { 2: 420, 1: 492, 0: 564 }, base = 520, gap = 25, half = 24;   // columns z, y, x from left to right
  const target = (e) => [[colX[e.q] - half, base - e.slot * gap], [colX[e.q] + half, base - e.slot * gap]];
  const toneQ = ['#a9d0ec', '#84bbe2', '#5f9fd1'];
  const order = edges.map((e, i) => i).sort((p, q) => edges[p].q - edges[q].q || edges[p].slot - edges[q].slot);
  const startOf = new Map(order.map((i, r) => [i, r]));
  return (t) => {
    F.clear();
    const fly = (i) => { const r = startOf.get(i), go = inout(seg(t, 0.9 + r * 0.075, 1.8 + r * 0.075)), back = inout(seg(t, 7.6 + (n - r) * 0.035, 8.4 + (n - r) * 0.035)); return go * (1 - back); };
    const rest = edges.filter((e, i) => fly(i) < 0.001);
    F.rods(rest.map((e) => ({ a: e.a, b: e.b })));
    // column letters and counts
    const lk = seg(t, 0.5, 1.0);
    ['x', 'y', 'z'].forEach((l, q) => { if (lk > 0) F.el('text', { x: colX[q], y: base + 42, 'font-size': 30, 'font-style': 'italic', 'font-weight': 600, 'text-anchor': 'middle', 'dominant-baseline': 'central', fill: INK, opacity: lk, class: 'flat-m' }).textContent = l; });
    F.line2(388, base + 18, 596, base + 18, { 'stroke-width': 3, opacity: lk });
    edges.forEach((e, i) => {
      const k = fly(i); if (k < 0.001) return;
      const [p1, p2] = [F.pr(e.a), F.pr(e.b)], [t1, t2] = target(e);
      const A = [p1[0] + (t1[0] - p1[0]) * k, p1[1] + (t1[1] - p1[1]) * k], B = [p2[0] + (t2[0] - p2[0]) * k, p2[1] + (t2[1] - p2[1]) * k];
      F.line2(A[0], A[1], B[0], B[1], { 'stroke-width': 18 * Math.max(F.k * (1 - k) + k * 1, 0.5) });
      F.line2(A[0], A[1], B[0], B[1], { stroke: toneQ[e.q], 'stroke-width': 11 * Math.max(F.k * (1 - k) + k * 1, 0.5) });
    });
    const ck = seg(t, 4.6, 5.1) * (1 - seg(t, 7.3, 7.7));
    if (ck > 0) {
      const ty = base - Math.max(...counts) * gap - 34;
      [2, 1, 0].forEach((q) => F.el('text', { x: colX[q], y: ty, 'font-size': 30, 'font-weight': 800, 'text-anchor': 'middle', 'dominant-baseline': 'central', fill: INK, opacity: ck, class: 'flat-t' }).textContent = counts[q]);
      [[2, 1], [1, 0]].forEach(([p, q]) => F.el('text', { x: (colX[p] + colX[q]) / 2, y: ty, 'font-size': 30 * pop(ck), 'font-weight': 800, 'text-anchor': 'middle', 'dominant-baseline': 'central', fill: INK, class: 'flat-t' }).textContent = '≤');
    }
  };
}

// ---------------------------------------------------------------- the gallery
const TILES = [
  ['1', 9.2, dmon1, true], ['2', 10.8, dmon2, true], ['3', 9.6, dmon3, true], ['4', 12.4, dmon4, false],
  ['5', 9.9, dmon5, false], ['6', 7.6, dmon6, true], ['7', 10.6, dmon7, true],
];
export function figDmon(w) {
  const grid = H('div', { class: 'dm-grid' }); w.append(grid);
  const gl = hasGL();
  for (const [num, T, build, needsGL] of TILES) {
    const tile = H('div', { class: 'dm-tile' }), stage = H('div', { class: 'dm-stage' });
    const row = H('div', { class: 'dm-row' }, H('a', { class: 'dm-name dmon', href: '#def:dmon' }, 'DMON' + num));
    tile.append(stage, row); grid.append(tile);
    if (needsGL && !gl) { stage.classList.add('dm-nogl'); continue; }
    const draw = build(stage);
    player(stage, { T, draw, bar: row });
  }
}
