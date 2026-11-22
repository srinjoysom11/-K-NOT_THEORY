// Section 4 as animatics: the search building the 24-step trefoil, with its obligations (flat style).
//   figObligation  Figure 10: a curtain closes, its interior points become one obligation, and a later step discharges it
//   figReach       Figure 11: (a) head -> site -> origin fits in the steps left; (b) the site has two free neighbours
//   figSpan        Figure 12: on each axis the cheaper of the two orders, and the three axes together
//   figInvariant   Web figure: every pending obligation keeps a witness v_m ahead of the head (m >= i + 2)
import { DATA } from './data.js';
import { player, Flat, PAS, INK, seg, out3, inout, pop, lerp } from './anim.js';

const T = DATA.trace, V = T.verts, WORD = T.word, n = V.length;
const U = { e: [1, 0, 0], w: [-1, 0, 0], n: [0, 1, 0], s: [0, -1, 0], u: [0, 0, 1], d: [0, 0, -1] };
const add = (a, b, s = 1) => [a[0] + s * b[0], a[1] + s * b[1], a[2] + s * b[2]];
const key = (p) => p.join(',');
const IDX = new Map(V.map((p, i) => [key(p), i]));
const l1 = (p, q = [0, 0, 0]) => Math.abs(p[0] - q[0]) + Math.abs(p[1] - q[1]) + Math.abs(p[2] - q[2]);
const HEAD = PAS.pink;

function stageOf(w, aspect = '16 / 10') {
  const st = document.createElement('div'); st.className = 'stage anim-stage';
  const box = document.createElement('div'); box.className = 'anim-box'; box.style.aspectRatio = aspect;
  st.append(box); w.append(st);
  const ctl = document.createElement('div'); ctl.className = 'ctl'; w.append(ctl);
  return { box, ctl };
}
// a walk drawn up to a fractional number of steps p (0..n), ending in a bead
function walkTo(F, p, { tone, dashed = false, from = 0 } = {}) {
  const e = Math.floor(p), f = p - e, segs = [];
  for (let i = from; i < Math.min(e, n); i++) segs.push({ a: V[i], b: V[(i + 1) % n], tone });
  if (e < n && f > 0.001) segs.push({ a: V[e], b: lerp(V[e], V[(e + 1) % n], f), tone });
  if (dashed) { segs.forEach((s) => { const [x1, y1] = F.pr(s.a), [x2, y2] = F.pr(s.b); F.line2(x1, y1, x2, y2, { 'stroke-width': 5 * F.k, 'stroke-dasharray': `${2 * F.k} ${11 * F.k}` }); }); return; }
  F.rods(segs);
}
const tip = (p) => (p >= n ? V[0] : lerp(V[Math.floor(p)], V[(Math.floor(p) + 1) % n], p - Math.floor(p)));
const tick = (F, x, y, s, ok = true) => {
  if (s <= 0) return; const r = 24 * pop(s);
  F.el('circle', { cx: x, cy: y, r, fill: ok ? PAS.green : PAS.red, stroke: INK, 'stroke-width': 3 });
  F.el('path', ok ? { d: `M${x - r * 0.42},${y + r * 0.02} L${x - r * 0.1},${y + r * 0.36} L${x + r * 0.46},${y - r * 0.34}`, fill: 'none', stroke: INK, 'stroke-width': 5, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }
    : { d: `M${x - r * 0.35},${y - r * 0.35} L${x + r * 0.35},${y + r * 0.35} M${x + r * 0.35},${y - r * 0.35} L${x - r * 0.35},${y + r * 0.35}`, fill: 'none', stroke: INK, 'stroke-width': 5, 'stroke-linecap': 'round' });
};
// a row of tokens: the steps that are left
function tokens(F, x0, y, total, used, { w = 26, gap = 6, fill = PAS.verm, label } = {}) {
  for (let k = 0; k < total; k++) {
    const on = k < used, x = x0 + k * (w + gap);
    F.el('rect', { x, y: y - w / 2, width: w, height: w, fill: on ? fill : PAS.paper, stroke: INK, 'stroke-width': 3 });
  }
  if (label) F.el('text', { x: x0 - 14, y, 'font-size': 24, 'font-weight': 800, 'text-anchor': 'end', 'dominant-baseline': 'central', fill: INK, class: 'flat-t' }).innerHTML = label;
}

// ===================================================================== Figure 10: an obligation
export function figObligation(w) {
  const ev = T.steps[6].events[0], i = 6, j = ev.j, a = U[WORD[j]];   // the step w at 6 closes the curtain begun by e at 2
  const sites = ev.sites, hit = Math.min(...sites.map((p) => IDX.get(key(p))));   // the vertex that later discharges it
  const { box, ctl } = stageOf(w, '16 / 10');
  const F = new Flat(box, { W: 640, H: 400, label: 'The search closes a curtain; its interior points become one obligation, which a later step discharges' });
  F.fit(V.concat(sites.map((p) => add(p, [0, 0, 0.3]))), 34);
  const draw = (t) => {
    F.clear();
    const grow = (i + 1) * seg(t, 0.2, 2.6);                         // the walk up to the head
    const sheet = out3(seg(t, 2.9, 3.9)), ringK = seg(t, 4.0, 4.5), bundle = seg(t, 4.7, 5.2);
    const rest = i + 1 + (n - i - 1) * inout(seg(t, 5.6, 10.6));     // the rest of the walk (dashed)
    const done = rest >= hit, closed = rest >= n - 0.001;
    // the curtain: the stretch from v_j to the head, and the face below it, unrolling along -a
    for (let q = j + 1; q < i; q++) F.quad([V[q], V[q + 1], add(V[q + 1], a, -sheet), add(V[q], a, -sheet)], { fill: PAS.green, opacity: sheet > 0.01 ? 0.75 : 0, sw: 2.5 });
    if (rest > i + 1) walkTo(F, rest, { dashed: true, from: i + 1 });
    walkTo(F, Math.min(grow, i + 1));
    if (sheet > 0) F.rods([{ a: V[j], b: V[j + 1], tone: PAS.verm2, w: 1.15 }, { a: V[i], b: V[i + 1], tone: PAS.verm2, w: 1.15 }]);
    // one obligation: the interior points, bundled
    if (bundle > 0 && !done) {
      const P = sites.map((p) => F.pr(p));
      F.el('path', { d: 'M' + P.map((p) => p.join(',')).join('L'), fill: 'none', stroke: '#d8c6ea', 'stroke-width': 54 * F.k * pop(bundle), 'stroke-linecap': 'round', 'stroke-linejoin': 'round', opacity: 0.9 });
    }
    sites.forEach((p, k) => {
      const filled = done && IDX.get(key(p)) === hit;
      if (filled) F.bead(p, { fill: PAS.green, r: 13, k: seg(rest, hit, hit + 0.4) || 1 });
      else F.ring(p, { r: 12 * pop(seg(t, 4.0 + k * 0.15, 4.5 + k * 0.15)), opacity: ringK > 0 ? (done ? 0.35 : 1) : 0 });
    });
    if (done) F.burst(V[hit], seg(rest, hit, hit + 1.2));
    F.bead(V[0], { fill: INK, r: 11 });
    F.bead(tip(Math.min(grow, i + 1) < i + 1 ? grow : rest), { fill: HEAD, r: 12, opacity: closed ? 0 : 1 });
    if (closed) F.burst(V[0], seg(t, 10.6, 11.6));
  };
  player(box, { T: 11.8, draw, bar: ctl });
}

// ===================================================================== Figure 11: the reach test
export function figReach(w) {
  const step = T.steps[15], head = step.head, left = step.R1, s = [2, 0, 1];
  const occ = new Set(V.slice(0, 17).map(key));
  const path = [head]; { let c = head.slice(); for (const ax of [0, 1, 2]) while (c[ax] !== s[ax]) { c = c.slice(); c[ax] += Math.sign(s[ax] - c[ax]); path.push(c); } }
  const k1 = path.length - 1; { let c = s.slice(); for (const ax of [0, 1, 2]) while (c[ax] !== 0) { c = c.slice(); c[ax] -= Math.sign(c[ax]); path.push(c); } }
  const need = path.length - 1;   // = |head - s|_1 + |s|_1
  const nbrs = Object.values(U).map((d) => { const q = add(s, d); return { q, free: !occ.has(key(q)) || key(q) === key(head) || key(q) === '0,0,0' }; });
  const enter = V[18], leave = V[20];   // where the real walk enters and leaves s
  const { box, ctl } = stageOf(w, '16 / 11');
  const F = new Flat(box, { W: 640, H: 440, label: 'The reach test: head to site to origin within the steps left; and two free neighbours of the site' });
  F.fit(V.concat([add(s, [0, 0, 1.2]), add(s, [0, -1.2, 0])]), 30, [0, 0, 640, 360]);
  const draw = (t) => {
    F.clear();
    const A = t < 6.6, u = A ? t : t - 6.6;
    F.rods(V.slice(0, 16).map((p, k) => ({ a: p, b: V[k + 1] })), { opacity: 0.9 });
    F.bead(V[0], { fill: INK, r: 11 });
    if (A) {   // (a) the shortest lattice route head -> s -> origin, one token per step
      const p = need * inout(seg(u, 0.6, 4.4)), e = Math.floor(p);
      const segs = []; for (let k = 0; k < Math.min(e, need); k++) segs.push({ a: path[k], b: path[k + 1], tone: PAS.verm });
      if (e < need) segs.push({ a: path[e], b: lerp(path[e], path[e + 1], p - e), tone: PAS.verm });
      F.rods(segs, { w: 11, core: 6 });
      F.ring(s, { r: 13 });
      F.bead(head, { fill: HEAD, r: 12 });
      tokens(F, 120, 404, left, Math.min(need, Math.ceil(p - 1e-6)), { label: `${left}` });
      tick(F, 120 + left * 32 + 26, 404, seg(u, 4.6, 5.0), need <= left);
    } else {   // (b) the six neighbours of s: at least two must be free, one to enter by and one to leave by
      F.bead(head, { fill: HEAD, r: 12 });
      F.ring(s, { r: 13 });
      nbrs.forEach(({ q, free }, k) => { const kk = seg(u, 0.3 + k * 0.12, 0.6 + k * 0.12); F.bead(q, { fill: free ? PAS.green : PAS.red, r: 9, k: kk }); });
      const ar = out3(seg(u, 1.6, 2.6)), ar2 = out3(seg(u, 2.4, 3.4));
      F.arrow(enter, lerp(enter, s, 0.62), { fill: PAS.green2, k: ar, w: 9, head: 20 });
      F.arrow(s, lerp(s, leave, 0.62), { fill: PAS.green2, k: ar2, w: 9, head: 20 });
      const nf = nbrs.filter((x) => x.free).length;
      for (let k = 0; k < 6; k++) F.el('circle', { cx: 170 + k * 34, cy: 404, r: 11, fill: k < nf ? PAS.green : PAS.red, stroke: INK, 'stroke-width': 3, opacity: seg(u, 0.3 + k * 0.12, 0.6 + k * 0.12) });
      tick(F, 170 + 6 * 34 + 22, 404, seg(u, 3.6, 4.0), nf >= 2);
    }
    F.el('text', { x: 24, y: 30, 'font-size': 24, 'font-weight': 800, fill: INK, class: 'flat-t' }).textContent = A ? '(a)' : '(b)';
  };
  player(box, { T: 12, draw, bar: ctl });
}

// ===================================================================== Figure 12: the span test
export function figSpan(w) {
  const st = T.steps[15], c = st.head, left = st.R1;
  const S = st.pending.filter((o) => o.length === 1).map((o) => o[0]);
  const rows = [0, 1, 2].map((q) => {
    const vals = [c[q], 0, ...S.map((p) => p[q])], l = Math.min(...vals), h = Math.max(...vals), cc = c[q];
    const a1 = (cc - l) + (h - l) + h, a2 = (h - cc) + (h - l) - l;
    return { q, l, h, cc, a1, a2, mn: Math.min(a1, a2), sites: S.map((p) => p[q]) };
  });
  const total = rows.reduce((t, r) => t + r.mn, 0);
  const { box, ctl } = stageOf(w, '16 / 11');
  const F = new Flat(box, { W: 640, H: 440, label: 'The span test on each axis, and the three axes together against the steps left' });
  const X0 = 110, X1 = 430, lo = Math.min(...rows.map((r) => r.l)), hi = Math.max(...rows.map((r) => r.h));
  const X = (v) => X0 + (v - lo) / Math.max(1, hi - lo) * (X1 - X0);
  const rowY = [70, 190, 310], AXN = ['x', 'y', 'z'];
  const zig = (r, order, y, dir, k) => {   // the route c -> first -> second -> 0, one leg per level
    const stops = [r.cc, ...order, 0], pts = [[X(stops[0]), y]];
    for (let m = 1; m < stops.length; m++) { const yy = y + dir * m * 11; pts.push([X(stops[m - 1]), yy], [X(stops[m]), yy]); }
    const L = pts.reduce((t, p, m) => (m ? t + Math.hypot(p[0] - pts[m - 1][0], p[1] - pts[m - 1][1]) : 0), 0);
    return F.el('path', { d: 'M' + pts.map((p) => p.join(',')).join('L'), fill: 'none', stroke: dir < 0 ? PAS.verm2 : PAS.blue3, 'stroke-width': 6, 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-dasharray': `${L}`, 'stroke-dashoffset': `${L * (1 - k)}` });
  };
  const draw = (t) => {
    F.clear();
    rows.forEach((r, m) => {
      const y = rowY[m], t0 = 0.4 + m * 2.4, k1 = inout(seg(t, t0 + 0.2, t0 + 1.2)), k2 = inout(seg(t, t0 + 1.0, t0 + 2.0));
      const on = seg(t, t0 - 0.2, t0 + 0.2);
      F.el('text', { x: 40, y, 'font-size': 30, 'font-style': 'italic', 'font-weight': 600, 'text-anchor': 'middle', 'dominant-baseline': 'central', fill: INK, opacity: 0.3 + 0.7 * on, class: 'flat-m' }).textContent = AXN[r.q];
      F.line2(X0 - 16, y, X1 + 16, y, { 'stroke-width': 3, opacity: 0.3 + 0.7 * on });
      for (let v = lo; v <= hi; v++) F.line2(X(v), y - 6, X(v), y + 6, { 'stroke-width': 2, opacity: 0.4 });
      if (on > 0) {
        zig(r, [r.l, r.h], y, -1, k1); zig(r, [r.h, r.l], y, 1, k2);
        r.sites.forEach((v) => F.el('circle', { cx: X(v), cy: y, r: 9, fill: PAS.blue, stroke: INK, 'stroke-width': 3 }));
        F.el('circle', { cx: X(0), cy: y, r: 9, fill: INK });
        F.el('circle', { cx: X(r.cc), cy: y, r: 10, fill: HEAD, stroke: INK, 'stroke-width': 3 });
        const tx = X1 + 70, mn = seg(t, t0 + 2.0, t0 + 2.3);
        F.el('text', { x: tx, y: y - 22, 'font-size': 24, 'font-weight': 800, 'text-anchor': 'middle', 'dominant-baseline': 'central', fill: '#b34f00', opacity: k1, class: 'flat-t' }).textContent = r.a1;
        F.el('text', { x: tx, y: y + 22, 'font-size': 24, 'font-weight': 800, 'text-anchor': 'middle', 'dominant-baseline': 'central', fill: '#1f5f99', opacity: k2, class: 'flat-t' }).textContent = r.a2;
        if (mn > 0) F.el('rect', { x: tx - 22, y: (r.a1 <= r.a2 ? y - 22 : y + 22) - 17, width: 44, height: 34, fill: 'none', stroke: INK, 'stroke-width': 3.5, opacity: mn });
      }
    });
    // the three minima together, against the steps left
    const sk = seg(t, 7.8, 8.4);
    if (sk > 0) {
      let x = 110; const y = 400;
      rows.forEach((r) => { for (let k = 0; k < r.mn; k++) { F.el('rect', { x, y: y - 13, width: 26, height: 26, fill: [PAS.blue, PAS.blue2, PAS.blue3][r.q], stroke: INK, 'stroke-width': 3, opacity: sk }); x += 32; } });
      for (let k = total; k < left; k++) F.el('rect', { x: 110 + k * 32, y: y - 13, width: 26, height: 26, fill: PAS.paper, stroke: INK, 'stroke-width': 3, 'stroke-dasharray': '5 4', opacity: sk });
      F.el('text', { x: 96, y, 'font-size': 24, 'font-weight': 800, 'text-anchor': 'end', 'dominant-baseline': 'central', fill: INK, opacity: sk, class: 'flat-t' }).textContent = `${total} ≤ ${left}`;
      tick(F, 110 + left * 32 + 24, y, seg(t, 8.6, 9.0), total <= left);
    }
  };
  player(box, { T: 10.2, draw, bar: ctl });
}

// ===================================================================== Web figure: the obligation invariant along the search
export function figInvariant(w) {
  const obs = []; let active = [];
  T.steps.forEach((s, i) => {
    const keys = s.pending.map((ob) => ob.map(key).sort().join('|')), left = active.slice(), now = [];
    keys.forEach((k, j) => { const at = left.findIndex((o) => o.k === k); if (at >= 0) { now.push(left[at]); left.splice(at, 1); } else { const o = { k, sites: s.pending[j], c: i, end: null, one: s.pending[j].length === 1 }; obs.push(o); now.push(o); } });
    left.forEach((o) => { o.end = i; }); active = now;
  });
  active.forEach((o) => { o.end = n; });
  obs.forEach((o) => { o.m = Math.min(...o.sites.map((p) => IDX.get(key(p))).filter((m) => m != null && m >= o.c + 2)); o.col = o.one ? PAS.blue : PAS.verm; o.ink = o.one ? '#1f5f99' : '#b34f00'; });
  const { box, ctl } = stageOf(w, '16 / 13');
  const F = new Flat(box, { W: 640, H: 520, label: 'The search along the trefoil word; every pending obligation keeps a witness vertex at least two steps ahead of the head' });
  F.fit(V, 26, [0, 0, 640, 300]);
  const DT = 0.5, T0 = 0.4, Tn = T0 + n * DT;
  const gx = (s) => 70 + (s / n) * 530, gy = (r) => 330 + r * 22;
  const draw = (t) => {
    F.clear();
    const p = Math.min(n, Math.max(0, (t - T0) / DT)), i = Math.min(n - 1, Math.floor(p));   // step i is being taken
    // the whole word, faint, and the walk so far
    walkTo(F, n, { dashed: true });
    walkTo(F, p);
    F.bead(V[0], { fill: INK, r: 10 });
    const pend = obs.filter((o) => o.c <= i && o.end > i && p >= o.c + 1);
    for (const o of pend) {
      o.sites.forEach((q) => F.ring(q, { r: 10, stroke: o.ink, sw: 3 }));
      F.bead(V[o.m], { fill: o.col, r: 11 });
      const [x1, y1] = F.pr(tip(p)), [x2, y2] = F.pr(V[o.m]);
      F.line2(x1, y1, x2, y2, { stroke: o.ink, 'stroke-width': 2.5, 'stroke-dasharray': '2 6', opacity: 0.8 });
    }
    obs.forEach((o) => { if (p >= o.end && p < o.end + 0.9 && o.end < n) F.burst(V[o.m], (p - o.end) / 0.9, { r0: 10, r1: 34 }); });
    if (p < n) F.bead(tip(p), { fill: HEAD, r: 12 });
    else F.burst(V[0], seg(t, Tn, Tn + 1));
    // the timeline: a bar per obligation from the step that makes it to the step that removes it; the dot is its witness v_m
    F.line2(gx(0), 314, gx(n), 314, { 'stroke-width': 2 });
    for (let s = 0; s <= n; s += 4) { F.line2(gx(s), 309, gx(s), 319, { 'stroke-width': 2 }); F.el('text', { x: gx(s), y: 298, 'font-size': 15, 'font-weight': 700, 'text-anchor': 'middle', fill: '#4b525c', class: 'flat-t' }).textContent = s; }
    obs.forEach((o, r) => {
      const on = o.c <= p && o.end > p, x1 = gx(o.c), x2 = gx(Math.min(o.end, n)), y = gy(r);
      if (p < o.c) return;
      F.el('rect', { x: x1, y: y - 6, width: Math.max(3, (Math.min(p, o.end) >= o.c ? gx(Math.min(p, o.end)) : x1) - x1), height: 12, fill: o.col, stroke: INK, 'stroke-width': 2, opacity: on ? 1 : 0.45 });
      F.el('circle', { cx: gx(o.m), cy: y, r: 7, fill: '#fff', stroke: o.ink, 'stroke-width': 3, opacity: on ? 1 : 0.45 });
    });
    const xi = gx(p), y0 = 314, y1 = gy(obs.length - 1) + 14;
    F.line2(xi, y0, xi, y1, { 'stroke-width': 3 });
    if (p < n - 1) F.line2(gx(Math.min(n, p + 2)), y0, gx(Math.min(n, p + 2)), y1, { stroke: '#00805c', 'stroke-width': 2.5, 'stroke-dasharray': '6 5' });
  };
  player(box, { T: Tn + 1.4, draw, bar: ctl });
}
