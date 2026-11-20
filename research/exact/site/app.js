// Interactive edition of "The knot 5_2 needs 36 steps on the cubic lattice".
// Every widget is built from data.js (build_data.py), which uses the paper's own figure code.
import { DATA } from './data.js';

const COL = ['#0072b2', '#d55e00', '#009e73', '#cc79a7', '#7a5230', '#56b4e9', '#7f7f7f'];
const INK = '#14171b', INK2 = '#4b525c', RULE = 'rgba(20,23,27,.16)', BAD = '#c0281b', GOOD = '#00805c';
const NS = 'http://www.w3.org/2000/svg';
const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
const U = { e: [1, 0, 0], w: [-1, 0, 0], n: [0, 1, 0], s: [0, -1, 0], u: [0, 0, 1], d: [0, 0, -1] };
const REV = { e: 'w', w: 'e', n: 's', s: 'n', u: 'd', d: 'u' };
const AXIS = { e: 0, w: 0, n: 1, s: 1, u: 2, d: 2 };
const mod = (a, p) => ((a % p) + p) % p;
const fmt = (x) => x.toLocaleString('en-US').replace(/,/g, ' ');

// ---------------------------------------------------------------------------------------- helpers
function S(tag, attrs = {}, parent) {
  const e = document.createElementNS(NS, tag);
  for (const [k, v] of Object.entries(attrs)) if (v != null) e.setAttribute(k, v);
  if (parent) parent.appendChild(e);
  return e;
}
function H(tag, attrs = {}, ...kids) {
  const e = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs)) {
    if (k === 'class') e.className = v; else if (k === 'html') e.innerHTML = v;
    else if (k.startsWith('on')) e.addEventListener(k.slice(2), v); else if (v != null) e.setAttribute(k, v);
  }
  for (const k of kids) if (k != null) e.append(k);
  return e;
}
const btn = (label, on, attrs = {}) => H('button', { class: 'btn', type: 'button', onclick: on, ...attrs }, label);
function seg(options, value, onchange) {
  const box = H('div', { class: 'seg', role: 'group' });
  const bs = options.map(([v, label]) => {
    const b = btn(label, () => { set(v); onchange(v); }, { 'aria-pressed': String(v === value) });
    b.dataset.v = v; box.append(b); return b;
  });
  function set(v) { bs.forEach((b) => b.setAttribute('aria-pressed', String(b.dataset.v === String(v)))); }
  box.set = set; return box;
}
function svgFit(svg, pts, pad = 0.6, flipY = true) {
  const xs = pts.map((p) => p[0]), ys = pts.map((p) => (flipY ? -p[1] : p[1]));
  const x0 = Math.min(...xs) - pad, x1 = Math.max(...xs) + pad, y0 = Math.min(...ys) - pad, y1 = Math.max(...ys) + pad;
  svg.setAttribute('viewBox', `${x0} ${y0} ${x1 - x0} ${y1 - y0}`);
  return { x0, y0, w: x1 - x0, h: y1 - y0 };
}
const P = (p) => `${p[0].toFixed(4)},${(-p[1]).toFixed(4)}`;   // math coords -> svg (y up)
const pathOf = (pts) => 'M' + pts.map(P).join('L');
function check(g, x, y, ok, r) {   // drawn tick or cross in a ring
  const c = ok ? GOOD : BAD;
  S('circle', { cx: x, cy: y, r, fill: '#fff', stroke: c, 'stroke-width': r * 0.22 }, g);
  if (ok) S('path', { d: `M${x - r * .45},${y}l${r * .32},${r * .34}l${r * .6},${-r * .7}`, fill: 'none', stroke: c, 'stroke-width': r * .26, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, g);
  else S('path', { d: `M${x - r * .4},${y - r * .4}l${r * .8},${r * .8}M${x + r * .4},${y - r * .4}l${-r * .8},${r * .8}`, fill: 'none', stroke: c, 'stroke-width': r * .26, 'stroke-linecap': 'round' }, g);
}
function panes(widget, n, labels = []) {
  const st = H('div', { class: 'stage' }); const ps = H('div', { class: 'panes', style: `--cols:${n}` });
  const out = [];
  for (let i = 0; i < n; i++) { const p = H('div', { class: 'pane' }); if (labels[i]) p.append(H('span', { class: 'pane-label' }, labels[i])); ps.append(p); out.push(p); }
  st.append(ps); widget.append(st); return out;
}
const ctlRow = (widget) => { const c = H('div', { class: 'ctl' }); widget.append(c); return c; };
const vadd = (a, b, s = 1) => [a[0] + s * b[0], a[1] + s * b[1], a[2] + s * b[2]];
const key = (p) => p.join(',');
function walk(word) { const V = [[0, 0, 0]]; for (const ch of word) V.push(vadd(V[V.length - 1], U[ch])); return V; }

let glMod = null;
async function gl() {
  if (glMod === false) return null;
  if (!glMod) { try { const m = await import('./gl.js'); glMod = m.hasGL() ? m : false; } catch (e) { glMod = false; } }
  return glMod || null;
}

// --------------------------------------------------------------- projected polygon diagrams (2D)
/** draw a polygon diagram from orthographic coordinates and pieces; switched: cut over-strands instead */
function drawPolyDiagram(svg, blk, opts = {}) {
  const { colour = () => INK, width = 0.16, gap = 0.33, switched = false, group } = opts;
  const P2 = blk.orth, n = P2.length, g = group || S('g', {}, svg);
  g.innerHTML = '';
  const cuts = {};
  for (const c of blk.crossings) { const [e, t] = switched ? c.over : c.under; (cuts[e] = cuts[e] || []).push(t); }
  const segs = [];
  for (let i = 0; i < n; i++) {
    const p = P2[i], q = P2[(i + 1) % n], L = Math.hypot(q[0] - p[0], q[1] - p[1]);
    const ts = [0, ...(cuts[i] || []).sort((a, b) => a - b), 1];
    for (let k = 0; k + 1 < ts.length; k++) {
      let a = ts[k], b = ts[k + 1];
      if (k > 0) a += gap / L; if (k + 2 < ts.length) b -= gap / L;
      if (b <= a) continue;
      // arc of this piece (by the under-passage structure, never switched)
      const mid = (a + b) / 2;
      const piece = blk.pieces.find((pc) => pc[0] === i && pc[1] <= mid && mid <= pc[2]);
      const A = [p[0] + a * (q[0] - p[0]), p[1] + a * (q[1] - p[1])], B = [p[0] + b * (q[0] - p[0]), p[1] + b * (q[1] - p[1])];
      const l = S('line', { x1: A[0], y1: -A[1], x2: B[0], y2: -B[1], stroke: colour(piece ? piece[3] : 0), 'stroke-width': width, 'stroke-linecap': 'round' }, g);
      l.dataset.arc = piece ? piece[3] : 0; l.dataset.edge = i; segs.push(l);
    }
  }
  return segs;
}
const crossPoint = (blk, c) => { const [i, t] = c.under; const p = blk.orth[i], q = blk.orth[(i + 1) % blk.orth.length]; return [p[0] + t * (q[0] - p[0]), p[1] + t * (q[1] - p[1])]; };
function arcLabelPoints(blk) {   // on each arc, the point farthest from the crossings and from earlier labels
  const X = blk.crossings.map((c) => crossPoint(blk, c)), used = [], out = {};
  const n = blk.orth.length;
  const arcs = [...new Set(blk.pieces.map((p) => p[3]))].sort((a, b) => a - b);
  for (const arc of arcs) {
    let best = null, bs = -1;
    for (const [i, a, b, ar] of blk.pieces) {
      if (ar !== arc) continue;
      const p = blk.orth[i], q = blk.orth[(i + 1) % n];
      for (let k = 1; k < 8; k++) {
        const t = a + (b - a) * k / 8, c = [p[0] + t * (q[0] - p[0]), p[1] + t * (q[1] - p[1])];
        let d = Math.min(...X.map((x) => Math.hypot(x[0] - c[0], x[1] - c[1])));
        for (const u of used) d = Math.min(d, Math.hypot(u[0] - c[0], u[1] - c[1]));
        if (d > bs) { bs = d; best = c; }
      }
    }
    used.push(best); out[arc] = [0, best];
  }
  return out;
}

function placeNear(blk, pts, r) {   // for each point, the spot at distance r farthest from the drawn polygon
  const S2 = []; const P2 = blk.orth, n = P2.length;
  for (let i = 0; i < n; i++) { const p = P2[i], q = P2[(i + 1) % n]; for (let k = 0; k < 8; k++) S2.push([p[0] + k / 8 * (q[0] - p[0]), p[1] + k / 8 * (q[1] - p[1])]); }
  const used = [];
  return pts.map((x) => {
    let best = null, bs = -1;
    for (let k = 0; k < 16; k++) { const a = k / 16 * 2 * Math.PI; const c = [x[0] + r * Math.cos(a), x[1] + r * Math.sin(a)];
      let d = Math.min(...S2.map((s) => Math.hypot(s[0] - c[0], s[1] - c[1]))); for (const u of used) d = Math.min(d, 0.8 * Math.hypot(u[0] - c[0], u[1] - c[1]));
      if (d > bs) { bs = d; best = c; } }
    used.push(best); return best;
  });
}

// ------------------------------------------------------------------------------------- masthead
function masthead() {
  const svg = document.getElementById('mastKnot'); if (!svg) return;
  const b = DATA.w36; const box = svgFit(svg, b.orth, 0.7);
  S('rect', { x: box.x0, y: box.y0, width: box.w, height: box.h, fill: 'none' }, svg);
  drawPolyDiagram(svg, b, { colour: () => '#fff', width: 0.2, gap: 0.42 });
  const o = b.orth[0]; S('circle', { cx: o[0], cy: -o[1], r: 0.2, fill: '#fff' }, svg);
}

// ============================================================================== Figure 1: w36
async function wPolygon(w) {
  const b = DATA.w36, col = (arc) => COL[b.colouring[arc]];
  const [p3, p2] = panes(w, 2, ['(a) the polygon in space', '(b) its diagram along D = (1, −1, 4)']);
  const svg = S('svg', { role: 'img', 'aria-label': 'Diagram of the 36-step polygon along (1,-1,4); five crossings; arcs coloured by the Fox colouring 0,1,3,4,2' }, p2);
  svgFit(svg, b.orth, 0.9);
  const segs = drawPolyDiagram(svg, b, { colour: col });
  for (const c of b.crossings) { const x = crossPoint(b, c); S('circle', { cx: x[0], cy: -x[1], r: 0.36, fill: 'none', stroke: INK2, 'stroke-width': 0.035, 'stroke-dasharray': '0.11 0.08' }, svg); }
  const lab = arcLabelPoints(b), lg = S('g', {}, svg);
  for (const [arc, [, x]] of Object.entries(lab)) {
    const g = S('g', { class: 'hit', tabindex: 0, 'data-arc': arc, role: 'button', 'aria-label': `arc ${arc}, colour ${b.colouring[arc]}` }, lg);
    S('circle', { cx: x[0], cy: -x[1], r: 0.27, fill: col(+arc) }, g);
    const t = S('text', { x: x[0], y: -x[1] + 0.11, 'text-anchor': 'middle', 'font-size': 0.32, 'font-weight': 700, fill: b.colouring[arc] === 3 || b.colouring[arc] === 5 ? INK : '#fff' }, g); t.textContent = b.colouring[arc];
  }
  const o = b.orth[0]; S('circle', { cx: o[0], cy: -o[1], r: 0.17, fill: INK }, svg);
  const c = ctlRow(w); const read = H('span', { class: 'readout grow' });
  let view = null;
  const G = await gl();
  if (G) {
    const canvas = H('canvas', { class: 'gl', 'aria-label': 'Interactive 3D view of the 36-step polygon; drag to turn' }); p3.append(canvas);
    view = new G.LatticeView(canvas, { verts: b.verts, pieces: b.pieces, colourOf: col });
    view.onUser = () => mode.set('free');
  } else { p3.parentNode.style.setProperty('--cols', '1'); p3.remove(); }   // without WebGL: the interactive diagram (b) alone
  const mode = seg([['free', 'Free view'], ['proj', 'View along D = (1, −1, 4)']], 'free', (v) => {
    if (!view) return;
    if (v === 'proj') { view.viewAlong(b.D); read.innerHTML = 'Seen along <b>D</b>, the polygon <b>is</b> its diagram (b): the same five crossings, the same arcs.'; }
    else { view.viewAlong([1, -1.35, 0.95]); read.innerHTML = 'Drag to turn the polygon. Point at an arc label in (b) to find that arc in space.'; }
  });
  c.append(mode, read);
  read.innerHTML = view ? 'Drag to turn the polygon. Point at an arc label in (b) to find that arc in space.' : 'Interactive 3D needs WebGL; the diagram (b) is fully interactive.';
  const hl = (arc) => { segs.forEach((s) => s.setAttribute('opacity', arc == null || s.dataset.arc == arc ? 1 : 0.18)); view && view.highlight(arc == null ? null : +arc); };
  lg.querySelectorAll('g').forEach((g) => {
    const a = g.dataset.arc;
    g.addEventListener('pointerenter', () => hl(a)); g.addEventListener('pointerleave', () => hl(null));
    g.addEventListener('focus', () => hl(a)); g.addEventListener('blur', () => hl(null));
  });
}

// ============================================================================ Figure 2: Delta-move
function wDelta(w) {
  const [pane] = panes(w, 1);
  const svg = S('svg', { viewBox: '0 0 640 300', role: 'img', 'aria-label': 'A Delta-move: drag c, the other strand, and slide the edge' }, pane);
  const a = [190, 205], b = [430, 205];
  let c = [320, 80], q = [520, 95], t = 0;
  S('path', { d: 'M40,265 C100,250 150,215 190,205', fill: 'none', stroke: INK, 'stroke-width': 4, 'stroke-linecap': 'round' }, svg);
  S('path', { d: 'M430,205 C480,195 540,160 590,110', fill: 'none', stroke: INK, 'stroke-width': 4, 'stroke-linecap': 'round' }, svg);
  const tri = S('path', { fill: 'rgba(0,114,178,.12)', stroke: 'rgba(0,114,178,.4)', 'stroke-width': 1 }, svg);
  const ghost = S('line', { x1: a[0], y1: a[1], x2: b[0], y2: b[1], stroke: INK2, 'stroke-width': 1.2, 'stroke-dasharray': '5 5' }, svg);
  const edge = S('path', { fill: 'none', stroke: INK, 'stroke-width': 4, 'stroke-linejoin': 'round', 'stroke-linecap': 'round' }, svg);
  for (const [p, l] of [[a, 'a'], [b, 'b']]) { S('circle', { cx: p[0], cy: p[1], r: 6, fill: INK }, svg); const tx = S('text', { x: p[0], y: p[1] + 30, 'text-anchor': 'middle', 'font-size': 20, 'font-style': 'italic', fill: INK }, svg); tx.textContent = l; }
  const cg = S('g', { class: 'drag', tabindex: 0, role: 'slider', 'aria-label': 'point c, drag to move' }, svg);
  const cc = S('circle', { r: 10, fill: '#fff', stroke: INK, 'stroke-width': 2.5 }, cg); const ct = S('text', { 'font-size': 20, 'font-style': 'italic', fill: INK }, cg); ct.textContent = 'c';
  const qg = S('g', { class: 'drag', tabindex: 0, role: 'slider', 'aria-label': 'another strand of the knot, perpendicular to the page; drag to move' }, svg);
  const qc = S('circle', { r: 11, fill: '#fff', stroke: COL[1], 'stroke-width': 3 }, qg); const qd = S('circle', { r: 3.5, fill: COL[1] }, qg);
  const qt = S('text', { 'font-size': 17, fill: INK2 }, qg); qt.textContent = 'another strand';
  const read = H('span', { class: 'readout grow' });
  const inTri = (p, A, B, C) => { const s = (P1, P2, P3) => (P1[0] - P3[0]) * (P2[1] - P3[1]) - (P2[0] - P3[0]) * (P1[1] - P3[1]); const d1 = s(p, A, B), d2 = s(p, B, C), d3 = s(p, C, A); return !((d1 < 0 || d2 < 0 || d3 < 0) && (d1 > 0 || d2 > 0 || d3 > 0)); };
  const m = [(a[0] + b[0]) / 2, (a[1] + b[1]) / 2];
  const slider = H('input', { type: 'range', min: 0, max: 100, value: 0, 'aria-label': 'slide the edge across the triangle' });
  function draw() {
    const pierced = inTri(q, a, b, c);
    let tt = t;
    if (pierced) { // stop where the moving edge meets the strand
      for (let k = 0; k <= 100; k++) { const s = k / 100 * t; const cs = [m[0] + s * (c[0] - m[0]), m[1] + s * (c[1] - m[1])]; if (inTri(q, a, b, cs)) { tt = Math.max(0, s - 0.01); break; } }
    }
    const ct_ = [m[0] + tt * (c[0] - m[0]), m[1] + tt * (c[1] - m[1])];
    tri.setAttribute('d', `M${a}L${b}L${c}Z`); tri.setAttribute('fill', pierced ? 'rgba(192,40,27,.12)' : 'rgba(0,114,178,.12)');
    tri.setAttribute('stroke', pierced ? 'rgba(192,40,27,.5)' : 'rgba(0,114,178,.4)');
    edge.setAttribute('d', `M${a}L${ct_}L${b}`); ghost.setAttribute('opacity', t > 0.02 ? 1 : 0);
    cc.setAttribute('cx', c[0]); cc.setAttribute('cy', c[1]); ct.setAttribute('x', c[0] + 14); ct.setAttribute('y', c[1] - 10);
    qc.setAttribute('cx', q[0]); qc.setAttribute('cy', q[1]); qd.setAttribute('cx', q[0]); qd.setAttribute('cy', q[1]); const rgt = q[0] > 440; qt.setAttribute('x', rgt ? q[0] - 18 : q[0] + 18); qt.setAttribute('text-anchor', rgt ? 'end' : 'start'); qt.setAttribute('y', q[1] + 6);
    read.innerHTML = pierced
      ? `<span class="no">Not a Δ-move.</span> Another strand of the knot passes through the triangle <i>abc</i>; sliding the edge would drag it through that strand${t > tt + 0.02 ? ' (the slide stops where they meet)' : ''}.`
      : `<span class="ok">A Δ-move.</span> The triangle <i>abc</i> meets the knot only in the edge [<i>a</i>,<i>b</i>]. Slide the edge onto [<i>a</i>,<i>c</i>] ∪ [<i>c</i>,<i>b</i>].`;
  }
  function dragger(g, setp) {
    g.addEventListener('pointerdown', (ev) => {
      g.setPointerCapture(ev.pointerId);
      const mv = (e) => { const pt = svg.createSVGPoint(); pt.x = e.clientX; pt.y = e.clientY; const p = pt.matrixTransform(svg.getScreenCTM().inverse()); setp([Math.max(20, Math.min(620, p.x)), Math.max(20, Math.min(285, p.y))]); draw(); };
      const up = () => { g.removeEventListener('pointermove', mv); g.removeEventListener('pointerup', up); };
      g.addEventListener('pointermove', mv); g.addEventListener('pointerup', up);
    });
    g.addEventListener('keydown', (e) => { const d = { ArrowLeft: [-10, 0], ArrowRight: [10, 0], ArrowUp: [0, -10], ArrowDown: [0, 10] }[e.key]; if (d) { e.preventDefault(); setp(null, d); draw(); } });
  }
  dragger(cg, (p, d) => { c = p || [c[0] + d[0], c[1] + d[1]]; if (c[1] > 190) c[1] = 190; });
  dragger(qg, (p, d) => { q = p || [q[0] + d[0], q[1] + d[1]]; });
  slider.addEventListener('input', () => { t = slider.value / 100; draw(); });
  const ctl = ctlRow(w);
  ctl.append(H('label', { class: 'range' }, 'Slide the edge', slider), btn('Put the strand inside', () => { q = [m[0] * 0.5 + c[0] * 0.5 + 10, (m[1] + c[1]) / 2 + 20]; draw(); }), btn('Move it away', () => { q = [540, 95]; draw(); }));
  w.append(H('p', { class: 'hint' }, 'Drag c and the other strand (a strand perpendicular to the page; the dot is where it crosses the plane of the triangle).'), read);
  draw();
}

// ============================================================ Figure 3: crossing rule and trefoil
function wTrefoil(w) {
  const T = DATA.trefoil;
  const [pane] = panes(w, 1);
  const svg = S('svg', { role: 'img', 'aria-label': 'Trefoil diagram; click an arc to change its colour' }, pane);
  const all = T.arcs.flat(); svgFit(svg, all, 0.9);
  let p = 3, x = [0, 1, 2];
  const arcs = T.arcs.map((pts, e) => {
    const g = S('g', { class: 'hit', tabindex: 0, role: 'button' }, svg);
    S('path', { d: pathOf(pts), fill: 'none', stroke: 'transparent', 'stroke-width': 0.5 }, g);
    const path = S('path', { d: pathOf(pts), fill: 'none', 'stroke-width': 0.16, 'stroke-linecap': 'round' }, g);
    const mid = pts[Math.floor(pts.length / 2)]; const r = Math.hypot(...mid); const lp = [mid[0] * (1 + 0.5 / r), mid[1] * (1 + 0.5 / r)];
    const lc = S('circle', { cx: lp[0], cy: -lp[1], r: 0.3 }, g); const lt = S('text', { x: lp[0], y: -lp[1] + 0.12, 'text-anchor': 'middle', 'font-size': 0.36, 'font-weight': 700 }, g);
    const act = () => { x[e] = mod(x[e] + 1, p); draw(); };
    g.addEventListener('click', act); g.addEventListener('keydown', (ev) => { if (ev.key === 'Enter' || ev.key === ' ') { ev.preventDefault(); act(); } });
    return { path, lc, lt, g };
  });
  const marks = S('g', {}, svg);
  const read = H('div', { class: 'readout' });
  function count() { let k = 0; const c = x.length; const rows = T.crossings.map((cr) => cr); const rec = (i, v) => { if (i === c) { if (rows.every((cr) => mod(2 * v[cr.overArc] - v[mod(cr.e - 1, c)] - v[cr.e], p) === 0)) k++; return; } for (let a = 0; a < p; a++) { v[i] = a; rec(i + 1, v); } }; rec(0, []); return k; }
  function draw() {
    arcs.forEach((A, e) => { const cl = COL[x[e]]; A.path.setAttribute('stroke', cl); A.lc.setAttribute('fill', cl); A.lt.textContent = x[e]; A.lt.setAttribute('fill', x[e] === 3 || x[e] === 5 ? INK : '#fff'); A.g.setAttribute('aria-label', `arc ${e}, colour ${x[e]}; press to change`); });
    marks.innerHTML = ''; let okAll = true; const lines = [];
    T.crossings.forEach((cr, k) => {
      const o = x[cr.overArc], i = x[mod(cr.e - 1, x.length)], u = x[cr.e];
      const ok = mod(2 * o - i - u, p) === 0; okAll = okAll && ok;
      check(marks, cr.p[0] * 0.62, -cr.p[1] * 0.62, ok, 0.2);
      lines.push(`2·${o} ${ok ? '≡' : '≢'} ${i} + ${u}`);
    });
    const constant = x.every((v) => v === x[0]);
    read.innerHTML = `<b>p = ${p}.</b> At the three crossings (ticks near the centre): ${lines.join(';  ')} (mod ${p}). ` +
      (okAll ? `<span class="ok">This is a Fox ${p}-colouring${constant ? ' (a constant one)' : ', and it is not constant'}.</span>` : `<span class="no">Not a colouring.</span> Click an arc to change its colour.`) +
      ` This diagram has <b>${count()}</b> ${p}-colourings in all${p === 7 ? ': only the 7 constant ones' : ''}.`;
  }
  const ctl = ctlRow(w);
  ctl.append(seg([['3', 'p = 3'], ['7', 'p = 7']], '3', (v) => { p = +v; x = x.map((a) => mod(a, p)); draw(); }), btn('Constant colouring', () => { x = [0, 0, 0]; draw(); }), btn('Colours 0, 1, 2', () => { x = [0, 1, 2]; draw(); }));
  w.append(H('p', { class: 'hint' }, 'Click an arc to add 1 to its colour (mod p). At each crossing, twice the over-arc must equal the sum of the two under-arcs.'), read);
  draw();
}

// ======================================================================= Figure 4: segment and square
function wSegSquare(w) {
  const [pane] = panes(w, 1);
  const svg = S('svg', { viewBox: '-190 -170 380 290', role: 'img', 'aria-label': 'A unit segment and a unit square' }, pane);
  const s = 95, iso = (x, y, z) => [(x - y) * 0.866 * s, (x + y) * 0.5 * s - z * s];
  const grid = S('g', {}, svg);
  for (let i = -1; i <= 2; i++) { const a = iso(i, -1, 0), b = iso(i, 2, 0), c = iso(-1, i, 0), d = iso(2, i, 0); S('line', { x1: a[0], y1: a[1], x2: b[0], y2: b[1], stroke: RULE }, grid); S('line', { x1: c[0], y1: c[1], x2: d[0], y2: d[1], stroke: RULE }, grid); }
  const sq = [[0, 0, 0], [1, 0, 0], [1, 1, 0], [0, 1, 0]].map((p) => iso(...p));
  S('path', { d: 'M' + sq.join('L') + 'Z', fill: 'rgba(0,114,178,.16)', stroke: COL[0], 'stroke-width': 1.5 }, svg);
  sq.forEach((p) => S('circle', { cx: p[0], cy: p[1], r: 3, fill: COL[0] }, svg));
  const tq = S('text', { class: 'lbl', x: iso(0.5, 0.15, 0)[0] + 6, y: iso(0.5, 0.15, 0)[1] + 4 }, svg); tq.textContent = 'Q';
  const segG = S('g', {}, svg), hit = S('g', {}, svg);
  let p = [1, 1, 0], ax = 2;
  const read = H('div', { class: 'readout' });
  function inter() {
    const q = p.slice(); q[ax] += 1;
    if (ax === 2) { if (p[2] <= 0 && 0 <= q[2] && p[0] >= 0 && p[0] <= 1 && p[1] >= 0 && p[1] <= 1) return ['corner', [[p[0], p[1], 0]]]; return ['empty', []]; }
    if (p[2] !== 0) return ['empty', []];
    const o = 1 - ax; // other horizontal axis
    if (p[o] < 0 || p[o] > 1) return ['empty', []];
    const lo = Math.max(p[ax], 0), hi = Math.min(q[ax], 1);
    if (hi < lo) return ['empty', []];
    const A = p.slice(), B = p.slice(); A[ax] = lo; B[ax] = hi;
    return hi > lo ? ['side', [A, B]] : ['corner', [A]];
  }
  function draw() {
    segG.innerHTML = ''; hit.innerHTML = '';
    const q = p.slice(); q[ax] += 1; const A = iso(...p), B = iso(...q);
    S('line', { x1: A[0], y1: A[1], x2: B[0], y2: B[1], stroke: INK, 'stroke-width': 5, 'stroke-linecap': 'round' }, segG);
    S('circle', { cx: A[0], cy: A[1], r: 5, fill: INK }, segG); S('circle', { cx: B[0], cy: B[1], r: 5, fill: INK }, segG);
    const [kind, pts] = inter();
    if (kind === 'side') { const a = iso(...pts[0]), b = iso(...pts[1]); S('line', { x1: a[0], y1: a[1], x2: b[0], y2: b[1], stroke: COL[1], 'stroke-width': 8, 'stroke-linecap': 'round', opacity: .85 }, hit); }
    if (kind === 'corner') { const a = iso(...pts[0]); S('circle', { cx: a[0], cy: a[1], r: 9, fill: 'none', stroke: COL[1], 'stroke-width': 3 }, hit); }
    read.innerHTML = `Segment from (${p.join(', ')}) to (${q.join(', ')}). <b>E ∩ Q is ${kind === 'empty' ? 'empty' : kind === 'side' ? 'a whole side' : 'a corner'}.</b> Whatever you try, the segment never meets an interior point of the square.`;
  }
  const ctl = ctlRow(w);
  ctl.append(seg([['0', 'along x'], ['1', 'along y'], ['2', 'along z']], '2', (v) => { ax = +v; draw(); }));
  const mv = H('div', { class: 'seg', role: 'group', 'aria-label': 'move the segment one step' });
  for (const l of 'ewnsud') mv.append(btn(l, () => { p = vadd(p, U[l]); p = p.map((v) => Math.max(-2, Math.min(3, v))); draw(); }, { 'aria-label': `move ${l}` }));
  ctl.append(H('span', { class: 'readout' }, 'Move:'), mv);
  w.append(read); draw();
}

// ========================================================== Figure 5: flip and U-turn as Delta-moves
function wFlipDelta(w) {
  const [pane] = panes(w, 1);
  const svg = S('svg', { viewBox: '-1.4 -1.75 3.9 2.75', role: 'img', 'aria-label': 'A corner flip or U-turn removal as two Delta-moves' }, pane);
  let mode = 'flip', step = 0;
  const read = H('div', { class: 'readout' });
  const T = {
    flip: { pts: { a: [0, 0], vi: [0, 1], b: [1, 1], vp: [1, 0] }, names: { a: 'v_{i−1}', vi: 'v_i', b: 'v_{i+1}', vp: "v′" },
      ext: [[[0, -0.7], [0, 0]], [[1, 1], [1.7, 1]]],
      path: [['a', 'vi', 'b'], ['a', 'b'], ['a', 'vp', 'b']], tri: [null, ['a', 'vi', 'b'], ['a', 'vp', 'b']],
      solid: [['a', 'vi', 'b'], ['a', 'b'], ['a', 'vp', 'b']],
      text: ['The corner at v<sub>i</sub>. The fourth corner v′ of the square is not a vertex, so the square meets the polygon only in the two edges at v<sub>i</sub>.',
        'First Δ-move: across the triangle v<sub>i−1</sub>v<sub>i</sub>v<sub>i+1</sub>, the two edges at v<sub>i</sub> become the diagonal.',
        'Second Δ-move: across the triangle v<sub>i−1</sub>v′v<sub>i+1</sub>, the diagonal becomes the two edges through v′. This is the flipped word.'] },
    uturn: { pts: { a: [0, 0], vi: [0, 1], b: [1, 1], vp: [1, 0] }, names: { a: 'v_i', vi: 'v_{i+1}', b: 'v_{i+2}', vp: 'v_{i+3}' },
      ext: [[[0, -0.7], [0, 0]], [[1, 0], [1, -0.7]]],
      path: [['a', 'vi', 'b', 'vp'], ['a', 'b', 'vp'], ['a', 'vp']], tri: [null, ['a', 'vi', 'b'], ['a', 'b', 'vp']],
      solid: [['a', 'vi', 'b', 'vp'], ['a', 'b', 'vp'], ['a', 'vp']],
      text: ['A U-turn a, b, −a. All four corners of the square are vertices; its fourth side is not an edge (that would need n = 4).',
        'First Δ-move: across the triangle v<sub>i</sub>v<sub>i+1</sub>v<sub>i+2</sub>, two edges become the diagonal.',
        'Second Δ-move: across the triangle v<sub>i</sub>v<sub>i+2</sub>v<sub>i+3</sub>, the diagonal and the last edge become one edge. The polygon is two steps shorter.'] },
  };
  const sub = (s) => s.replace(/_\{([^}]*)\}|_(\w)/g, (m, a, b) => `<tspan baseline-shift="sub" font-size="0.12">${a || b}</tspan>`);
  function draw() {
    const M = T[mode], pt = M.pts; svg.innerHTML = '';
    S('path', { d: 'M0,0L1,0L1,-1L0,-1Z', fill: 'none', stroke: INK2, 'stroke-width': .012, 'stroke-dasharray': '.04 .04' }, svg);
    if (M.tri[step]) S('path', { d: 'M' + M.tri[step].map((k) => P(pt[k])).join('L') + 'Z', fill: step === 1 ? 'rgba(0,114,178,.18)' : 'rgba(213,94,0,.18)' }, svg);
    for (const e of M.ext) S('path', { d: pathOf(e), stroke: INK, 'stroke-width': .045, fill: 'none', 'stroke-linecap': 'round' }, svg);
    S('path', { d: 'M' + M.path[step].map((k) => P(pt[k])).join('L'), stroke: INK, 'stroke-width': .045, fill: 'none', 'stroke-linejoin': 'round' }, svg);
    for (const k of Object.keys(pt)) {
      const on = M.solid[step].includes(k);
      S('circle', { cx: pt[k][0], cy: -pt[k][1], r: .045, fill: on ? INK : '#fff', stroke: INK, 'stroke-width': .015 }, svg);
      const off = { a: [-.12, .1], vi: [-.12, -.07], b: [.08, -.07], vp: [.08, .13] }[k];
      const t = S('text', { x: pt[k][0] + off[0], y: -pt[k][1] + off[1], 'font-size': .15, 'text-anchor': off[0] < 0 ? 'end' : 'start', fill: INK }, svg);
      t.innerHTML = sub(M.names[k]);
    }
    read.innerHTML = `<b>Step ${step + 1} of 3.</b> ${M.text[step]}`;
    back.disabled = step === 0; next.disabled = step === 2;
  }
  const back = btn('Back', () => { step--; draw(); }), next = btn('Next', () => { step++; draw(); });
  const ctl = ctlRow(w);
  ctl.append(seg([['flip', 'Corner flip'], ['uturn', 'U-turn removal']], 'flip', (v) => { mode = v; step = 0; draw(); }), back, next);
  w.append(read); draw();
}

// ============================================================ Figure 6: the potential psi_Z
function wPsi(w) {
  const [pane] = panes(w, 1);
  const svg = S('svg', { viewBox: '-1 -3.2 5.2 4.3', role: 'img', 'aria-label': 'A polygon in the xz-plane; click a highlighted vertex to flip its corner' }, pane);
  const start = 'eeeuwuwwdd'.split('');
  let word = start.slice();
  const read = H('div', { class: 'readout' });
  const xz = (v) => [v[0], v[2]];
  function flips(V) {
    const n = word.length, out = [], set = new Set(V.slice(0, n).map(key));
    for (let i = 1; i < n; i++) { const p = word[i - 1], d = word[i]; if (AXIS[p] === AXIS[d]) continue; const vp = vadd(V[i - 1], U[d]); if (!set.has(key(vp))) out.push({ i, vp }); }
    return out;
  }
  const psi = (V) => { const z = V.slice(0, word.length).map((v) => v[2]); const m = Math.min(...z); return [z.reduce((a, b) => a + b - m, 0), z.map((v) => v - m)]; };
  function patternName(i) { const p = word[i - 1], d = word[i]; if (p === 'u') return 'up, then horizontal: v′ is one unit lower'; if (d === 'd') return 'horizontal, then down: v′ is one unit lower'; if (p === 'd') return 'down, then horizontal: v′ is one unit higher'; if (d === 'u') return 'horizontal, then up: v′ is one unit higher'; return ''; }
  function draw(note) {
    svg.innerHTML = ''; const V = walk(word.join('')), n = word.length;
    for (let x = -1; x <= 4; x++) S('line', { x1: x, y1: .8, x2: x, y2: -3, stroke: RULE, 'stroke-width': .01 }, svg);
    for (let z = 0; z <= 3; z++) S('line', { x1: -.8, y1: -z, x2: 4, y2: -z, stroke: RULE, 'stroke-width': .01 }, svg);
    S('path', { d: pathOf(V.map(xz)) + 'Z', fill: 'none', stroke: INK, 'stroke-width': .06, 'stroke-linejoin': 'round' }, svg);
    const [ps, hs] = psi(V);
    V.slice(0, n).forEach((v, k) => { S('circle', { cx: v[0], cy: -v[2], r: .07, fill: INK }, svg); const t = S('text', { x: v[0] - .17, y: -v[2] - .1, 'font-size': .17, fill: INK2, 'text-anchor': 'end' }, svg); t.textContent = hs[k]; });
    for (const f of flips(V)) {
      const vi = V[f.i], g = S('g', { class: 'hit', tabindex: 0, role: 'button', 'aria-label': `flip the corner at vertex ${f.i}` }, svg);
      const dz = f.vp[2] - vi[2];
      S('path', { d: `M${vi[0]},${-vi[2]}L${f.vp[0]},${-f.vp[2]}`, stroke: dz < 0 ? COL[2] : COL[1], 'stroke-width': .035, 'stroke-dasharray': '.06 .05' }, g);
      S('circle', { cx: f.vp[0], cy: -f.vp[2], r: .1, fill: '#fff', stroke: dz < 0 ? COL[2] : COL[1], 'stroke-width': .035 }, g);
      S('circle', { cx: vi[0], cy: -vi[2], r: .16, fill: 'transparent', stroke: dz < 0 ? COL[2] : COL[1], 'stroke-width': .04 }, g);
      const act = () => { [word[f.i - 1], word[f.i]] = [word[f.i], word[f.i - 1]]; draw(`Flipped the corner at v<sub>${f.i}</sub> (${patternName(f.i)}): ψ<sub>Z</sub> ${dz < 0 ? 'drops' : 'rises'} by 1.`); };
      g.addEventListener('click', act); g.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); act(); } });
      g.addEventListener('pointerenter', () => { read.querySelector('.ph').innerHTML = `Corner at v<sub>${f.i}</sub>: ${patternName(f.i)}.`; });
    }
    read.innerHTML = `<b>ψ<sub>Z</sub> = ${hs.join(' + ')} = ${ps}.</b> Word: <code>${word.join('')}</code>. <span class="ph">${note || 'Rings mark the corners that can be flipped: green lowers the vertex, orange raises it. Click one.'}</span>`;
  }
  const ctl = ctlRow(w); ctl.append(btn('Reset', () => { word = start.slice(); draw(); }));
  w.append(H('p', { class: 'hint' }, 'The small numbers are the heights z(vᵢ) − z_min; ψ_Z is their sum.'), read); draw();
}

// ======================================================================== Figure 7: the curtain lemma
function wCurtain(w) {
  const [pane] = panes(w, 1);
  const svg = S('svg', { role: 'img', 'aria-label': 'The curtain lemma: flips slide the step a until a U-turn can be removed' }, pane);
  let k = 3, t = 0;
  const read = H('div', { class: 'readout' });
  function pts() {
    if (t === k) return [[0, 0], [k, 0]];
    const out = [[0, 0]]; for (let j = 1; j <= t; j++) out.push([j, 0]); for (let j = t; j <= k; j++) out.push([j, 1]); out.push([k, 0]); return out;
  }
  function draw() {
    svg.setAttribute('viewBox', `-1.2 -1.75 ${k + 2.4} 2.6`); svg.innerHTML = '';
    for (let x = -1; x <= k + 1; x++) S('line', { x1: x, y1: .6, x2: x, y2: -1.5, stroke: RULE, 'stroke-width': .01 }, svg);
    S('line', { x1: -1.1, y1: 0, x2: 0, y2: 0, stroke: INK2, 'stroke-width': .02, 'stroke-dasharray': '.06 .05' }, svg);
    S('line', { x1: k, y1: 0, x2: k + 1.1, y2: 0, stroke: INK2, 'stroke-width': .02, 'stroke-dasharray': '.06 .05' }, svg);
    const ps = pts(); S('path', { d: pathOf(ps), fill: 'none', stroke: INK, 'stroke-width': .06, 'stroke-linejoin': 'round' }, svg);
    ps.forEach((p) => S('circle', { cx: p[0], cy: -p[1], r: .06, fill: INK }, svg));
    for (let j = t + 1; j <= k - 1; j++) if (t < k) S('circle', { cx: j, cy: 0, r: .08, fill: '#fff', stroke: INK, 'stroke-width': .025 }, svg);
    if (t === k - 1) S('path', { d: `M${k - 1},0L${k - 1},-1L${k},-1L${k},0`, fill: 'rgba(213,94,0,.14)', stroke: 'none' }, svg);
    const lbl = (x, y, s) => { const e = S('text', { x, y, 'font-size': .2, fill: INK2, 'text-anchor': 'middle' }, svg); e.textContent = s; };
    if (t < k) { lbl(t - .2, -.45, 'a'); lbl(k + .25, -.45, '−a'); }
    const letters = t === k ? Array.from({ length: k }, (_, j) => `s${j + 1}`) : [...Array.from({ length: t }, (_, j) => `s${j + 1}`), 'a', ...Array.from({ length: k - t }, (_, j) => `s${t + j + 1}`), '−a'];
    read.innerHTML = (t === 0 ? `<b>A curtain with k = ${k}.</b> The open dots are its interior points v<sub>j</sub> − a (2 ≤ j ≤ k), assumed not to be vertices.`
      : t < k ? `<b>After ${t} flip${t > 1 ? 's' : ''}.</b> Each flip moved the step a one place to the right, through an open dot.${t === k - 1 ? ' The letters a, s<sub>k</sub>, −a now form a U-turn (shaded).' : ''}`
        : `<b>U-turn removed.</b> The polygon is two steps shorter: this contradicts minimality, so a shortest polygon has no such curtain (DMON6).`) +
      ` Letters: ${letters.join(', ')}.`;
    back.disabled = t === 0; next.disabled = t === k;
  }
  const back = btn('Back', () => { t--; draw(); }), next = btn(`Next step`, () => { t++; draw(); });
  const ctl = ctlRow(w);
  ctl.append(H('span', { class: 'readout' }, 'k ='), seg([['2', '2'], ['3', '3'], ['4', '4'], ['5', '5']], '3', (v) => { k = +v; t = 0; draw(); }), back, next);
  w.append(read); draw();
}

// ======================================================================== Figure 8: corner patterns
function wCorners(w) {
  const [pane] = panes(w, 1);
  const box = H('div', { style: 'display:grid;grid-template-columns:repeat(auto-fit,minmax(11rem,1fr));' }); pane.append(box);
  const lower = [
    { t: '(1) up, then horizontal', a: [0, 0], vi: [0, 1], b: [1, 1], vp: [1, 0], ax: ['z', 'h'], eff: 'ψ_Z drops by 1' },
    { t: '(2) horizontal, then down', a: [0, 1], vi: [1, 1], b: [1, 0], vp: [0, 0], ax: ['z', 'h'], eff: 'ψ_Z drops by 1' },
    { t: '(3) north, then east or west', a: [0, 0], vi: [0, 1], b: [1, 1], vp: [1, 0], ax: ['y', 'x'], eff: 'same height; ψ_Y drops by 1' },
    { t: '(4) east or west, then south', a: [0, 1], vi: [1, 1], b: [1, 0], vp: [0, 0], ax: ['y', 'x'], eff: 'same height; ψ_Y drops by 1' }];
  const raise = [
    { t: 'down, then horizontal', a: [0, 1], vi: [0, 0], b: [1, 0], vp: [1, 1], ax: ['z', 'h'], eff: 'ψ_Z rises by 1: not used' },
    { t: 'horizontal, then up', a: [0, 0], vi: [1, 0], b: [1, 1], vp: [0, 1], ax: ['z', 'h'], eff: 'ψ_Z rises by 1: not used' },
    { t: 'south, then east or west', a: [0, 1], vi: [0, 0], b: [1, 0], vp: [1, 1], ax: ['y', 'x'], eff: 'ψ_Y rises by 1: not used' },
    { t: 'east or west, then north', a: [0, 0], vi: [1, 0], b: [1, 1], vp: [0, 1], ax: ['y', 'x'], eff: 'ψ_Y rises by 1: not used' }];
  let set = lower, played = false;
  function draw() {
    box.innerHTML = '';
    for (const c of set) {
      const cell = H('div', { style: 'padding:12px 12px 8px;border-right:1px solid ' + RULE });
      const svg = S('svg', { viewBox: '-0.75 -1.6 2.6 2.1', role: 'img', 'aria-label': c.t }, cell);
      const pos = played ? c.vp : c.vi;
      S('path', { d: `M${P(c.a)}L${P(c.vi)}L${P(c.b)}L${P(c.vp)}Z`, fill: 'rgba(0,114,178,.12)' }, svg);
      const ext = (p, q) => [p[0] + (p[0] - q[0]) * .55, p[1] + (p[1] - q[1]) * .55];
      S('path', { d: `M${P(ext(c.a, c.vi))}L${P(c.a)}L${P(pos)}L${P(c.b)}L${P(ext(c.b, c.vi))}`, fill: 'none', stroke: INK, 'stroke-width': .05, 'stroke-linejoin': 'round', style: 'transition: d .7s cubic-bezier(.16,1,.3,1)' }, svg);
      S('path', { d: `M${P(c.vi)}L${P(c.vp)}`, stroke: set === lower ? COL[2] : COL[1], 'stroke-width': .03, 'stroke-dasharray': '.06 .05' }, svg);
      S('circle', { cx: c.a[0], cy: -c.a[1], r: .05, fill: INK }, svg); S('circle', { cx: c.b[0], cy: -c.b[1], r: .05, fill: INK }, svg);
      S('circle', { cx: (played ? c.vi : c.vp)[0], cy: -(played ? c.vi : c.vp)[1], r: .06, fill: '#fff', stroke: INK, 'stroke-width': .02 }, svg);
      S('circle', { cx: pos[0], cy: -pos[1], r: .06, fill: INK, style: 'transition: cx .7s cubic-bezier(.16,1,.3,1), cy .7s cubic-bezier(.16,1,.3,1)' }, svg);
      const ax = S('g', {}, svg); S('path', { d: 'M1.5,0.2L1.5,-0.25M1.5,0.2L1.95,0.2', stroke: INK2, 'stroke-width': .015, fill: 'none' }, ax);
      const t1 = S('text', { x: 1.47, y: -.3, 'font-size': .14, fill: INK2 }, ax); t1.textContent = c.ax[0]; const t2 = S('text', { x: 1.98, y: .25, 'font-size': .14, fill: INK2 }, ax); t2.textContent = c.ax[1];
      cell.append(H('div', { class: 'readout', html: `<b>${c.t}</b><br>${c.eff.replace(/ψ_(\w)/g, 'ψ<sub>$1</sub>')}` }));
      box.append(cell);
    }
  }
  const ctl = ctlRow(w);
  const play = btn('Flip all four', () => { played = !played; play.textContent = played ? 'Undo the flips' : 'Flip all four'; draw(); });
  ctl.append(play, seg([['lower', 'The four DMON7 patterns'], ['raise', 'The other four']], 'lower', (v) => { set = v === 'lower' ? lower : raise; draw(); }));
  draw();
}

// ======================================================================== Figure 9: DMON4
function wOrigin(w) {
  const [pane] = panes(w, 1);
  const svg = S('svg', { viewBox: '-2.3 -1.75 5.0 2.35', role: 'img', 'aria-label': 'The two edges at the origin and the two directions of travel' }, pane);
  let fwd = true;
  const read = H('div', { class: 'readout' });
  function draw() {
    svg.innerHTML = '';
    const o = [0, 0], e = [1, 0], u = [0, 1];
    S('path', { d: 'M1,0 C2.4,-0.1 2.2,-1.9 0,-1', fill: 'none', stroke: INK, 'stroke-width': .045, 'stroke-dasharray': '.09 .06' }, svg);
    S('path', { d: 'M0,-1L0,0L1,0', fill: 'none', stroke: INK, 'stroke-width': .045, 'stroke-linejoin': 'round' }, svg);
    [o, e, u].forEach((p) => S('circle', { cx: p[0], cy: -p[1], r: .055, fill: INK }, svg));
    const t = S('text', { x: -.12, y: .3, 'font-size': .14, 'text-anchor': 'end', fill: INK }, svg); t.textContent = 'v₀ = 0, the lowest vertex';
    const arrow = (a, b, c) => { const g = S('g', {}, svg); S('path', { d: `M${P(a)}L${P(b)}`, stroke: c, 'stroke-width': .04 }, g); const d = [b[0] - a[0], b[1] - a[1]], L = Math.hypot(...d), ux = d[0] / L, uy = d[1] / L; S('path', { d: `M${b[0]},${-b[1]}l${-ux * .14 - uy * .08},${uy * .14 - ux * .08}l${uy * .16},${ux * .16}Z`, fill: c }, g); };
    if (fwd) { arrow([.15, -.13], [.85, -.13], COL[1]); arrow([-.13, .85], [-.13, .15], COL[1]); }
    else { arrow([-.13, .15], [-.13, .85], COL[1]); arrow([.85, -.13], [.15, -.13], COL[1]); }
    const w0 = fwd ? 'e' : 'u', last = fwd ? 'd' : 'w', ml = REV[last];
    const L1 = S('text', { x: .5, y: .38, 'font-size': .15, 'text-anchor': 'middle', fill: COL[1] }, svg); L1.textContent = fwd ? 'w₀ = e' : 'w₂₃… arrives: w';
    const order = 'ewnsud'; const ok = order.indexOf(w0) < order.indexOf(ml);
    read.innerHTML = `Reading <b>${fwd ? 'forwards' : 'backwards'}</b>: the word starts with <code>w₀ = ${w0}</code> and its last step is <code>w<sub>n−1</sub> = ${last}</code>, so −w<sub>n−1</sub> = <code>${ml}</code>. ` +
      `In the order e < w < n < s < u < d, ${w0} ${ok ? '<' : '>'} ${ml}: ${ok ? '<span class="ok">DMON4 holds.</span>' : '<span class="no">DMON4 fails.</span>'} ` +
      `This is the polygon w<sub>36</sub>, whose word ${fwd ? 'is <code>eee…sswdd</code>' : 'read backwards is <code>uue…wwww</code>'}.`;
    L1.textContent = '';
  }
  const ctl = ctlRow(w);
  ctl.append(seg([['f', 'Read forwards'], ['b', 'Read backwards']], 'f', (v) => { fwd = v === 'f'; draw(); }));
  w.append(read); draw();
}

// ============================================================ Figure 10: obligations, a replay
async function wReplay(w) {
  const T = DATA.trace, n = T.verts.length;
  const [p3, side] = panes(w, 2, ['the walk in space', null]);
  side.classList.add('side');
  const G = await gl();
  let view = null;
  if (G) {
    const canvas = H('canvas', { class: 'gl', 'aria-label': 'Replay of the search along a 24-step word; drag to turn' }); p3.append(canvas);
    view = new G.LatticeView(canvas, { verts: T.verts, pieces: T.verts.map((_, i) => [i, 0, 1, 0]), colourOf: () => INK, radius: .085 });
  } else p3.append(H('p', { class: 'hint', style: 'padding:24px' }, 'The 3D replay needs WebGL; the step log on the right is complete.'));
  const head = H('h5', {}, ''); const info = H('div', { class: 'readout' }); const bars = H('div', { class: 'bars' }); const log = H('ol', { class: 'log' });
  side.append(head, info, bars, log);
  T.steps.forEach((s) => {
    const ev = s.events.map((e) => e.kind === 'curtain' ? `curtain from step ${e.j} (k = ${e.k}): ${e.result === 'new' ? 'new obligation' : e.result === 'satisfied' ? 'an interior point is a vertex' : 'dead end'}` : `corner: ${e.result === 'new' ? 'new obligation' : 'v′ is a vertex'}`);
    if (s.discharged.length) ev.unshift(`visits a site: ${s.discharged.length} obligation${s.discharged.length > 1 ? 's' : ''} discharged`);
    log.append(H('li', { 'data-i': s.i, html: `<b>${s.i + 1}. ${s.letter}</b> ${ev.join('; ') || '<span style="color:' + INK2 + '">no event</span>'}` }));
  });
  let i = 0, timer = null;
  const slider = H('input', { type: 'range', min: 1, max: n, value: 1, 'aria-label': 'step' });
  function draw() {
    const s = T.steps[i - 1];
    head.textContent = `Step ${i} of ${n}: letter ${s.letter}`;
    info.innerHTML = `Steps left after this one: <b>${s.R1}</b>. Pending obligations: <b>${s.pending.length}</b>.` + (s.span != null ? ` Span test needs <b>${s.span}</b> ≤ ${s.R1}.` : '');
    bars.innerHTML = '';
    s.pending.forEach((ob, k) => {
      const r = s.reach[k];
      bars.append(H('div', { class: 'bar', style: `--sc:${ob.length === 1 ? COL[0] : COL[1]}`, html: `<span>${ob.length === 1 ? 'corner / single' : 'curtain, ' + ob.length + ' sites'}</span><i><b style="width:${Math.min(100, r / Math.max(1, s.R1) * 100)}%"></b></i><span>${r} ≤ ${s.R1}</span>` }));
    });
    if (!s.pending.length) bars.append(H('div', { class: 'readout' }, i === n ? 'The walk is closed and no obligation is pending: the word is returned.' : 'No pending obligation.'));
    log.querySelectorAll('li').forEach((li) => li.classList.toggle('now', +li.dataset.i === i - 1));
    const now = log.querySelector('li.now'); if (now) now.scrollIntoView({ block: 'nearest' });
    if (view) {
      view.showUpTo(i);
      const mk = [{ p: s.head, kind: 'head', colour: COL[1] }];
      s.pending.forEach((ob) => ob.forEach((p) => mk.push({ p, kind: 'site', colour: ob.length === 1 ? COL[0] : COL[1] })));
      s.discharged.forEach((ob) => ob.forEach((p) => { if (key(p) === key(s.head)) mk.push({ p, kind: 'done', colour: COL[2] }); }));
      view.setMarkers(mk);
    }
    slider.value = i;
  }
  const go = (k) => { i = Math.max(1, Math.min(n, k)); draw(); };
  const play = btn('Play', () => {
    if (timer) { clearInterval(timer); timer = null; play.textContent = 'Play'; return; }
    if (i >= n) i = 0; play.textContent = 'Pause';
    timer = setInterval(() => { if (i >= n) { clearInterval(timer); timer = null; play.textContent = 'Play'; return; } go(i + 1); }, reduced ? 1600 : 700);
  });
  slider.addEventListener('input', () => go(+slider.value));
  const ctl = ctlRow(w);
  ctl.append(play, btn('Back', () => go(i - 1)), btn('Next', () => go(i + 1)), H('label', { class: 'range' }, 'Step', slider),
    H('span', { class: 'readout grow', html: `The search walking along <code>${T.word}</code>. Rings: sites of pending obligations (orange: curtain, blue: single site). Bars: the reach test, distance to a site and home versus the steps left.` }));
  go(9);
}

// ======================================================================== Figure 11: reach test
function wReach(w) {
  const [a, b] = panes(w, 2, ['(a) distance', '(b) room to pass through']);
  const svg = S('svg', { viewBox: '-0.8 -5.6 8.6 6.6', role: 'img', 'aria-label': 'Reach test: drag the site s' }, a);
  let s = [5, 2], head = [1, 4], R1 = 13;
  const read = H('div', { class: 'readout', style: 'padding:0 12px 12px' }); a.append(read);
  function draw() {
    svg.innerHTML = '';
    for (let x = 0; x <= 7; x++) S('line', { x1: x, y1: .3, x2: x, y2: -5.3, stroke: RULE, 'stroke-width': .02 }, svg);
    for (let y = 0; y <= 5; y++) S('line', { x1: -.3, y1: -y, x2: 7.3, y2: -y, stroke: RULE, 'stroke-width': .02 }, svg);
    const d = Math.abs(head[0] - s[0]) + Math.abs(head[1] - s[1]) + Math.abs(s[0]) + Math.abs(s[1]);
    const ok = d <= R1;
    S('path', { d: `M${P(head)}L${s[0]},${-head[1]}L${P(s)}L0,${-s[1]}L0,0`, fill: 'none', stroke: ok ? INK2 : BAD, 'stroke-width': .05, 'stroke-dasharray': '.12 .08' }, svg);
    S('circle', { cx: 0, cy: 0, r: .14, fill: INK }, svg); const to = S('text', { x: .2, y: .45, 'font-size': .32, fill: INK }, svg); to.textContent = 'origin';
    S('circle', { cx: head[0], cy: -head[1], r: .16, fill: COL[1] }, svg); const th = S('text', { x: head[0], y: -head[1] - .3, 'font-size': .32, 'text-anchor': 'middle', fill: INK }, svg); th.textContent = 'head';
    const g = S('g', { class: 'drag', tabindex: 0, role: 'slider', 'aria-label': 'site s; drag or use the arrow keys' }, svg);
    S('circle', { cx: s[0], cy: -s[1], r: .2, fill: '#fff', stroke: COL[1], 'stroke-width': .07 }, g); const ts = S('text', { x: s[0] + .3, y: -s[1] + .12, 'font-size': .34, fill: INK }, g); ts.textContent = 's';
    g.addEventListener('pointerdown', (ev) => { g.setPointerCapture(ev.pointerId); const mv = (e) => { const pt = svg.createSVGPoint(); pt.x = e.clientX; pt.y = e.clientY; const p = pt.matrixTransform(svg.getScreenCTM().inverse()); const ns = [Math.max(0, Math.min(7, Math.round(p.x))), Math.max(0, Math.min(5, Math.round(-p.y)))]; if (key(ns) !== key(s)) { s = ns; draw(); } }; const up = () => { window.removeEventListener('pointermove', mv); window.removeEventListener('pointerup', up); }; window.addEventListener('pointermove', mv); window.addEventListener('pointerup', up); });
    g.addEventListener('keydown', (e) => { const dd = { ArrowLeft: [-1, 0], ArrowRight: [1, 0], ArrowUp: [0, 1], ArrowDown: [0, -1] }[e.key]; if (dd) { e.preventDefault(); s = [Math.max(0, Math.min(7, s[0] + dd[0])), Math.max(0, Math.min(5, s[1] + dd[1]))]; draw(); svg.querySelector('.drag').focus(); } });
    read.innerHTML = `|head − s|₁ + |s|₁ = ${Math.abs(head[0] - s[0]) + Math.abs(head[1] - s[1])} + ${Math.abs(s[0]) + Math.abs(s[1])} = <b>${d}</b>; steps left R − 1 = <b>${R1}</b>. ${ok ? '<span class="ok">Passes.</span>' : '<span class="no">Fails: no completion can visit s in time.</span>'}`;
  }
  const sl = H('input', { type: 'range', min: 4, max: 16, value: R1, 'aria-label': 'steps left' });
  sl.addEventListener('input', () => { R1 = +sl.value; draw(); });
  a.append(H('div', { class: 'ctl', style: 'padding:0 12px 12px' }, H('label', { class: 'range' }, 'Steps left', sl)));
  // (b) neighbours
  const svg2 = S('svg', { viewBox: '-1.9 -1.7 3.8 3.4', role: 'img', 'aria-label': 'The six neighbours of the site; click to occupy or free' }, b);
  const iso = (x, y, z) => [(x - y) * 0.75, -((x + y) * 0.42 + z * 0.95)];
  const nb = [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]];
  const occ = [true, true, true, true, true, false];
  const read2 = H('div', { class: 'readout', style: 'padding:0 12px 12px' }); b.append(read2);
  function draw2() {
    svg2.innerHTML = '';
    nb.forEach((d, k) => { const q = iso(...d); S('line', { x1: 0, y1: 0, x2: q[0], y2: q[1], stroke: RULE, 'stroke-width': .03 }, svg2); });
    nb.forEach((d, k) => {
      const q = iso(...d), g = S('g', { class: 'hit', tabindex: 0, role: 'button', 'aria-label': `neighbour ${'ewnsud'[k]}: ${occ[k] ? 'occupied' : 'free'}; press to change` }, svg2);
      S('circle', { cx: q[0], cy: q[1], r: .16, fill: occ[k] ? INK : '#fff', stroke: INK, 'stroke-width': .04 }, g);
      const t = S('text', { x: q[0] + .2, y: q[1] - .15, 'font-size': .2, fill: INK2 }, g); t.textContent = 'ewnsud'[k];
      const act = () => { occ[k] = !occ[k]; draw2(); svg2.querySelectorAll('g')[k].focus(); };
      g.addEventListener('click', act); g.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); act(); } });
    });
    S('circle', { cx: 0, cy: 0, r: .17, fill: '#fff', stroke: COL[1], 'stroke-width': .06 }, svg2);
    const free = occ.filter((o) => !o).length;
    read2.innerHTML = `Usable neighbours of s (free, the head, or the origin): <b>${free}</b>. ${free >= 2 ? '<span class="ok">Passes: the walk can enter s by one and leave by another.</span>' : '<span class="no">Fails: s can be entered but not left.</span>'} Click a neighbour to occupy or free it.`;
  }
  draw(); draw2();
}

// ========================================================================= Figure 12: span test
function wSpan(w) {
  const [pane] = panes(w, 1); pane.append(H('span', { class: 'pane-label static' }, 'One axis, as in the caption: drag the head c and the two sites'));
  const svg = S('svg', { viewBox: '-8.6 -3.2 17.2 4.6', role: 'img', 'aria-label': 'Span test on one axis' }, pane);
  let c = 2, s1 = -4, s2 = 5;
  const read = H('div', { class: 'readout', style: 'padding:0 12px 12px' }); pane.append(read);
  function draw() {
    svg.innerHTML = '';
    S('line', { x1: -8, y1: 0, x2: 8, y2: 0, stroke: INK, 'stroke-width': .05 }, svg);
    for (let x = -7; x <= 7; x++) { S('line', { x1: x, y1: -.1, x2: x, y2: .1, stroke: INK, 'stroke-width': .03 }, svg); }
    const l = Math.min(0, c, s1, s2), h = Math.max(0, c, s1, s2);
    const a1 = (c - l) + (h - l) + h, a2 = (h - c) + (h - l) - l;
    const route = (pts, y0, col) => { let d = ''; pts.forEach((x, k) => { d += (k ? 'L' : 'M') + `${x},${y0 - k * .28}`; if (k + 1 < pts.length) d += `L${x},${y0 - (k + 1) * .28}`; }); S('path', { d, fill: 'none', stroke: col, 'stroke-width': .07, 'stroke-linejoin': 'round' }, svg); S('circle', { cx: pts[0], cy: y0, r: .12, fill: col }, svg); };
    route([c, l, h, 0], -.6, a1 <= a2 ? COL[1] : 'rgba(213,94,0,.35)');
    route([c, h, l, 0], -1.9, a2 < a1 ? COL[0] : 'rgba(0,114,178,.35)');
    const mark = (x, lab, draggable, setter) => {
      const g = S('g', draggable ? { class: 'drag', tabindex: 0, role: 'slider', 'aria-label': `${lab}; drag or use the arrow keys` } : {}, svg);
      S('circle', { cx: x, cy: 0, r: .22, fill: draggable ? '#fff' : INK, stroke: INK, 'stroke-width': .05 }, g);
      const t = S('text', { x, y: .75, 'font-size': .42, 'text-anchor': 'middle', fill: INK }, g); t.textContent = lab;
      if (draggable) {
        g.addEventListener('pointerdown', (ev) => { g.setPointerCapture(ev.pointerId); const mv = (e) => { const pt = svg.createSVGPoint(); pt.x = e.clientX; pt.y = e.clientY; const p = pt.matrixTransform(svg.getScreenCTM().inverse()); const v = Math.max(-7, Math.min(7, Math.round(p.x))); if (v !== x) { setter(v); draw(); } }; const up = () => { window.removeEventListener('pointermove', mv); window.removeEventListener('pointerup', up); }; window.addEventListener('pointermove', mv); window.addEventListener('pointerup', up); });
        g.addEventListener('keydown', (e) => { const d = { ArrowLeft: -1, ArrowRight: 1 }[e.key]; if (d) { e.preventDefault(); setter(Math.max(-7, Math.min(7, x + d))); draw(); } });
      }
    };
    mark(0, '0', false); mark(c, 'c (head)', true, (v) => { c = v; }); mark(s1, 'site', true, (v) => { s1 = v; }); mark(s2, 'site', true, (v) => { s2 = v; });
    read.innerHTML = `l = ${l}, h = ${h}. Reaching l first costs <b style="color:${COL[1]}">a₁ = ${a1}</b> steps on this axis; reaching h first costs <b style="color:${COL[0]}">a₂ = ${a2}</b>. The rest of the walk uses at least <b>min(a₁, a₂) = ${Math.min(a1, a2)}</b> steps on this axis. Drag the head and the two sites.`;
  }
  draw();
}

// ============================================================ Table 1 and Figure 13: the runs
function wRuns(w) {
  const t = H('table', {}, H('thead', {}, H('tr', {}, ...['n', 'parts', 'nodes', 'words'].map((x) => H('th', { style: x === 'n' || x === 'parts' ? '' : 'text-align:right' }, x)))));
  const tb = H('tbody'); t.append(tb);
  for (const r of DATA.runs) tb.append(H('tr', {}, H('td', {}, r.n), H('td', {}, r.parts), H('td', { style: 'text-align:right' }, fmt(r.nodes)), H('td', { style: 'text-align:right' + (r.words ? '' : `;color:${INK2}`) }, fmt(r.words))));
  tb.append(H('tr', {}, H('td', { style: 'font-weight:700' }, 'all'), H('td', { style: 'font-weight:700' }, DATA.totals.parts), H('td', { style: 'text-align:right;font-weight:700' }, fmt(DATA.totals.nodes)), H('td', { style: 'text-align:right;font-weight:700' }, fmt(DATA.totals.words))));
  w.append(H('div', { class: 'tablewrap' }, t));
}
function wGrowth(w) {
  const [a, b] = panes(w, 2, ['(a) nodes and words per length', '(b) growth per two steps']);
  const runs = DATA.runs.filter((r) => r.n >= 6), F = DATA.fits;
  let logScale = true;
  const svg = S('svg', { viewBox: '0 0 420 300', role: 'img', 'aria-label': 'Search nodes and returned words per length' }, a);
  const tip = H('div', { class: 'readout', style: 'padding:0 12px 12px;min-height:2.9em' }, 'Point at a dot to read its value.'); a.append(tip);
  function draw() {
    svg.innerHTML = '';
    const X = (n) => 46 + (n - 6) / 28 * 350, ymax = 2e12;
    const Y = logScale ? (v) => 262 - Math.log10(Math.max(v, 1)) / Math.log10(ymax) * 236 : (v) => 262 - v / ymax * 236;
    for (let n = 6; n <= 34; n += 4) { S('line', { x1: X(n), y1: 26, x2: X(n), y2: 262, stroke: RULE }, svg); const t = S('text', { x: X(n), y: 280, 'text-anchor': 'middle', class: 'lbl-s' }, svg); t.textContent = n; }
    const ticks = logScale ? [1, 1e2, 1e4, 1e6, 1e8, 1e10, 1e12] : [0, 5e11, 1e12, 1.5e12, 2e12];
    ticks.forEach((v) => { S('line', { x1: 46, y1: Y(v), x2: 396, y2: Y(v), stroke: RULE }, svg); const t = S('text', { x: 40, y: Y(v) + 4, 'text-anchor': 'end', class: 'lbl-s' }, svg); if (logScale) t.innerHTML = v === 1 ? '1' : `10<tspan dy="-5" font-size="8">${Math.log10(v)}</tspan>`; else t.textContent = v === 0 ? '0' : `${v / 1e12}·10¹²`; });
    const tl = S('text', { x: 221, y: 297, 'text-anchor': 'middle', class: 'lbl-s' }, svg); tl.textContent = 'length n';
    const fitPath = ([C, q, n0, n1]) => { let d = ''; for (let n = n0; n <= n1; n += 0.25) d += (d ? 'L' : 'M') + `${X(n)},${Y(C * q ** n)}`; return d; };
    // the fits use only the long runs (nodes: n = 20..34; words: n = 24..34, the lengths with knotted words);
    // the dashed continuation shows how far the short runs fall from the fitted law
    S('path', { d: fitPath([F.nodes[0], F.nodes[1], 6, F.nodes[2]]), fill: 'none', stroke: COL[0], 'stroke-width': 1.2, 'stroke-dasharray': '4 3', opacity: .6 }, svg);
    S('path', { d: fitPath(F.nodes), fill: 'none', stroke: COL[0], 'stroke-width': 1.6, opacity: .8 }, svg);
    S('path', { d: fitPath(F.words), fill: 'none', stroke: COL[1], 'stroke-width': 1.6, opacity: .8 }, svg);
    S('rect', { x: X(F.nodes[2]), y: 26, width: X(34) - X(F.nodes[2]), height: 236, fill: COL[0], opacity: 0.05 }, svg);
    const fr = S('text', { x: X(F.nodes[2]) + 4, y: 256, class: 'lbl-s' }, svg); fr.textContent = `fit range n ≥ ${F.nodes[2]}`;
    const dot = (n, v, col, what, sq) => { const g = S('g', { class: 'hit', tabindex: 0, role: 'img', 'aria-label': `n = ${n}: ${fmt(v)} ${what}` }, svg); S('circle', { cx: X(n), cy: Y(v), r: 11, fill: 'transparent' }, g); sq ? S('rect', { x: X(n) - 4, y: Y(v) - 4, width: 8, height: 8, fill: col }, g) : S('circle', { cx: X(n), cy: Y(v), r: 4.5, fill: col }, g); const show = () => { tip.innerHTML = `n = <b>${n}</b>: <b>${fmt(v)}</b> ${what}.`; }; g.addEventListener('pointerenter', show); g.addEventListener('focus', show); };
    runs.forEach((r) => dot(r.n, r.nodes, COL[0], 'search nodes'));
    runs.filter((r) => r.words).forEach((r) => dot(r.n, r.words, COL[1], 'words returned', true));
    const lg = S('g', {}, svg);
    [[COL[0], `nodes ≈ ${(F.nodes[0] / 10 ** Math.floor(Math.log10(F.nodes[0]))).toFixed(2)}·10${String(Math.floor(Math.log10(F.nodes[0]))).replace('-', '⁻').replace(/\d/g, (d) => '⁰¹²³⁴⁵⁶⁷⁸⁹'[d])} · ${F.nodes[1].toFixed(3)}ⁿ`], [COL[1], `words ≈ ${(F.words[0] / 10 ** Math.floor(Math.log10(F.words[0]))).toFixed(2)}·10${String(Math.floor(Math.log10(F.words[0]))).replace('-', '⁻').replace(/\d/g, (d) => '⁰¹²³⁴⁵⁶⁷⁸⁹'[d])} · ${F.words[1].toFixed(3)}ⁿ`]].forEach(([c, t], k) => { S('rect', { x: 56, y: 34 + k * 18, width: 10, height: 10, fill: c }, lg); const e = S('text', { x: 72, y: 43 + k * 18, class: 'lbl-s' }, lg); e.textContent = t; });
  }
  const svg2 = S('svg', { viewBox: '0 0 300 300', role: 'img', 'aria-label': 'Ratio nodes(n)/nodes(n-2)' }, b);
  const rat = runs.slice(1).map((r, k) => [r.n, r.nodes / runs[k].nodes]);
  const X2 = (n) => 44 + (n - 8) / 26 * 236, Y2 = (v) => 262 - (v - 4.8) / 2.2 * 236;
  for (let v = 5; v <= 7; v += 0.5) { S('line', { x1: 44, y1: Y2(v), x2: 280, y2: Y2(v), stroke: RULE }, svg2); const t = S('text', { x: 38, y: Y2(v) + 4, 'text-anchor': 'end', class: 'lbl-s' }, svg2); t.textContent = v.toFixed(1); }
  for (let n = 8; n <= 32; n += 6) { const t = S('text', { x: X2(n), y: 280, 'text-anchor': 'middle', class: 'lbl-s' }, svg2); t.textContent = n; }
  const q2 = F.nodes[1] ** 2; S('line', { x1: 44, y1: Y2(q2), x2: 280, y2: Y2(q2), stroke: COL[0], 'stroke-dasharray': '4 3' }, svg2);
  const tq = S('text', { x: 50, y: Y2(q2) - 6, class: 'lbl-s' }, svg2); tq.textContent = `fitted factor ${q2.toFixed(2)}`;
  S('path', { d: 'M' + rat.map(([n, v]) => `${X2(n)},${Y2(v)}`).join('L'), fill: 'none', stroke: COL[0], 'stroke-width': 1.5 }, svg2);
  rat.forEach(([n, v]) => S('circle', { cx: X2(n), cy: Y2(v), r: 3.5, fill: COL[0] }, svg2));
  b.append(H('div', { class: 'readout', style: 'padding:0 12px 12px' }, `Not a constant: the factor rises from ${rat[0][1].toFixed(1)} to ${rat[rat.length - 1][1].toFixed(1)}.`));
  const ctl = ctlRow(w); ctl.append(seg([['log', 'Logarithmic scale'], ['lin', 'Linear scale']], 'log', (v) => { logScale = v === 'log'; draw(); }),
    H('span', { class: 'readout grow' }, `Solid lines: least-squares fits of log(count) against n on the shaded range (nodes from n = ${F.nodes[2]}, words from n = ${F.words[2]}, the first length with knotted words). The dashed line continues the node fit to short lengths: there the counts lie above it, because the growth factor per step is still rising (panel b), so these lengths are left out of the fit.`));
  draw();
}

// ============================================================ Figure 14: the standard diagram of 5_2
function wStd52(w) {
  const D = DATA.std52, VEC = [0, 1, 3, 4, 2];
  const [pane, side] = panes(w, 2, ['(a) edges and crossings', null]); side.classList.add('side');
  const svg = S('svg', { role: 'img', 'aria-label': 'Standard diagram of 5_2 with the KnotInfo edge labels' }, pane);
  svgFit(svg, D.arcs.flat(), 0.55);
  let a = 0, b = 1;
  const arcPaths = D.arcs.map((pts) => S('path', { d: pathOf(pts), fill: 'none', 'stroke-width': .1, 'stroke-linecap': 'round' }, svg));
  const edgeHL = S('g', {}, svg);
  D.edgeLabels.forEach((e) => { const t = S('text', { x: e.p[0], y: -e.p[1] + .06, 'text-anchor': 'middle', 'font-size': .17, fill: INK, 'font-weight': 600 }, svg); t.textContent = e.label; });
  const xg = S('g', {}, svg);
  D.crossings.forEach((c, k) => {
    const g = S('g', { class: 'hit', tabindex: 0, role: 'button', 'aria-label': `crossing X${D.crossNames[k]}` }, xg);
    S('circle', { cx: c.p[0], cy: -c.p[1], r: .2, fill: 'transparent' }, g);
    S('circle', { cx: c.p[0], cy: -c.p[1], r: .045, fill: BAD }, g);
    const lp = D.crossLabels[k]; const t = S('text', { x: lp[0], y: -lp[1] + .06, 'text-anchor': 'middle', 'font-size': .18, fill: BAD, 'font-weight': 700 }, g);
    t.innerHTML = `X<tspan baseline-shift="sub" font-size=".12">${D.crossNames[k]}</tspan>`;
    const show = () => { focusX(k); }; g.addEventListener('pointerenter', show); g.addEventListener('focus', show);
  });
  const nameIdx = { A: 0, B: 1, C: 2, D: 3, E: 4 };
  const head = H('h5', {}, 'The KnotInfo code'); const codeBox = H('div', { class: 'readout' }); const eqs = H('div', { class: 'readout', style: 'margin-top:8px' });
  side.append(head, codeBox, eqs);
  function colours() { return D.arcNames.map((nm) => mod(a + b * VEC[nameIdx[nm]], 7)); }
  function focusX(k) {
    const X = D.pd[D.crossNames[k] - 1]; edgeHL.innerHTML = '';
    D.edges.filter((e) => X.includes(e.label)).forEach((e) => S('path', { d: pathOf(e.pts), fill: 'none', stroke: 'rgba(86,180,233,.55)', 'stroke-width': .26, 'stroke-linecap': 'round' }, edgeHL));
    codeBox.innerHTML = D.pd.map((X2, j) => `<div style="${j === D.crossNames[k] - 1 ? 'font-weight:700;color:' + INK : ''}">X<sub>${j + 1}</sub>[${X2.join(', ')}]</div>`).join('') +
      `<p style="margin:.6em 0 0">At X<sub>${D.crossNames[k]}</sub> the under-strand runs from edge ${X[0]} to edge ${X[2]}; the over-strand is edges ${X[1]} and ${X[3]} (highlighted).</p>`;
  }
  function draw() {
    const cs = colours(); arcPaths.forEach((p, e) => p.setAttribute('stroke', COL[cs[e]]));
    const v = [0, 1, 2, 3, 4].map((k) => mod(a + b * VEC[k], 7)); const [A, B, C, Dd, E] = v;
    const rows = [['2B', 'E + A', 2 * B, E + A], ['2D', 'A + B', 2 * Dd, A + B], ['2E', 'B + C', 2 * E, B + C], ['2A', 'C + D', 2 * A, C + Dd], ['2C', 'D + E', 2 * C, Dd + E]];
    eqs.innerHTML = `<b>(A, B, C, D, E) = a(1,1,1,1,1) + b(0,1,3,4,2) = (${v.join(', ')})</b><br>` + rows.map(([l, r, x, y]) => `${l} = ${mod(x, 7)}, ${r} = ${mod(y, 7)} ${mod(x - y, 7) === 0 ? '<span class="ok">balanced</span>' : '<span class="no">unbalanced</span>'}`).join('<br>') + `<br>${b === 0 ? 'b = 0: a constant colouring.' : 'Non-constant: every crossing still balances.'}`;
  }
  const sa = H('input', { type: 'range', min: 0, max: 6, value: a, 'aria-label': 'a' }), sb = H('input', { type: 'range', min: 0, max: 6, value: b, 'aria-label': 'b' });
  sa.addEventListener('input', () => { a = +sa.value; draw(); }); sb.addEventListener('input', () => { b = +sb.value; draw(); });
  const ctl = ctlRow(w);
  ctl.append(H('label', { class: 'range' }, 'a', sa), H('label', { class: 'range' }, 'b', sb), H('span', { class: 'readout grow' }, 'All 49 colourings: move a and b. Point at a crossing to read its PD tuple.'));
  focusX(0); draw();
}

// ============================================================ Figure 15: the worked certificate
async function wCertex(w) {
  const C = DATA.cert, ac = [COL[0], COL[1], COL[2]];
  const [p3, p2] = panes(w, 2, ['(a) the polygon', '(b) its diagram along (7, 13, 31)']);
  const G = await gl();
  let view = null;
  if (G) { const canvas = H('canvas', { class: 'gl', 'aria-label': '3D view of the 24-step trefoil polygon' }); p3.append(canvas); view = new G.LatticeView(canvas, { verts: C.verts, pieces: C.pieces, colourOf: (k) => ac[k] }); }
  else p3.append(H('img', { class: 'fallback', src: 'figs/certex.svg', alt: 'The polygon and its diagram' }));
  const svg = S('svg', { role: 'img', 'aria-label': 'Diagram with three crossings' }, p2);
  svgFit(svg, C.orth, 0.9);
  const segs = drawPolyDiagram(svg, C, { colour: (k) => ac[k], width: .13, gap: .3 });
  const ring = S('g', {}, svg);
  const ulp = placeNear(C, C.crossings.map((c) => crossPoint(C, c)), .5);
  C.crossings.forEach((c, k) => { const x = ulp[k]; const t = S('text', { x: x[0], y: -x[1] + .1, 'text-anchor': 'middle', 'font-size': .3, fill: INK }, svg); t.innerHTML = `u<tspan baseline-shift="sub" font-size=".2">${c.e}</tspan>`; });
  const lab = arcLabelPoints(C);
  for (const [arc, [, x]] of Object.entries(lab)) { S('circle', { cx: x[0], cy: -x[1], r: .22, fill: ac[arc] }, svg); const t = S('text', { x: x[0], y: -x[1] + .09, 'text-anchor': 'middle', 'font-size': .26, 'font-weight': 700, fill: '#fff' }, svg); t.textContent = arc; }
  const o = C.orth[0]; S('circle', { cx: o[0], cy: -o[1], r: .14, fill: INK }, svg);
  const mats = H('div', { class: 'matrow' });
  const mat = (M, cls) => { const m = H('span', { class: 'mat ' + cls, style: `grid-template-columns:repeat(${M[0].length},auto)` }); M.forEach((r, i) => r.forEach((v) => m.append(H('span', { 'data-r': i }, v)))); return m; };
  const F = mat(C.F, 'F'), Fm = mat(C.F.map((r) => r.map((v) => mod(v, 7))), 'Fm'), L = mat(C.L, 'L'), LF = mat(C.LF, 'LF');
  mats.append('F =', F, '≡', Fm, '  L =', L, '  LF ≡', LF, '(mod 7)');
  w.querySelector('.stage').append(mats);
  const read = H('div', { class: 'readout' }); w.append(read);
  function row(r) {
    w.querySelectorAll('.mat span').forEach((s) => s.classList.toggle('hl', s.parentNode.classList.contains('F') || s.parentNode.classList.contains('Fm') ? +s.dataset.r === r : false));
    const c = C.crossings.find((cc) => cc.e === r); ring.innerHTML = '';
    if (c) { const x = crossPoint(C, c); S('circle', { cx: x[0], cy: -x[1], r: .38, fill: 'none', stroke: COL[5], 'stroke-width': .08 }, ring); }
    const inn = mod(r - 1, 3);
    read.innerHTML = `Row ${r + 1} of F is the crossing with under-passage u<sub>${r}</sub>: over-arc ${c.overArc}, incoming under-arc ${inn}, outgoing ${r}, so 2x<sub>${c.overArc}</sub> − x<sub>${inn}</sub> − x<sub>${r}</sub> ≡ 0. Rows of LF are e<sub>1</sub> − e<sub>0</sub> and e<sub>2</sub> − e<sub>0</sub>: only constant colourings.`;
  }
  w.querySelectorAll('.mat.F span, .mat.Fm span').forEach((s) => { s.addEventListener('pointerenter', () => row(+s.dataset.r)); });
  const ctl = ctlRow(w); [0, 1, 2].forEach((r) => ctl.append(btn(`Row ${r + 1}`, () => row(r))));
  row(0);
}

// ============================================================ Figure 16: PD comparison
function wPdCompare(w) {
  const B = DATA.w36, D = DATA.std52, PD = DATA.pd;
  const [left, right] = panes(w, 2, ['(a) |w36| along (1, −1, 4)', '(b) the KnotInfo diagram']);
  const svg = S('svg', { role: 'img', 'aria-label': 'Diagram of w36 with PD labels' }, left); svgFit(svg, B.orth, 1.0);
  const g = S('g', {}, svg), labG = S('g', {}, svg);
  const svg2 = S('svg', { role: 'img', 'aria-label': 'The KnotInfo diagram of 5_2' }, right); svgFit(svg2, D.arcs.flat(), 0.55);
  D.arcs.forEach((pts) => S('path', { d: pathOf(pts), fill: 'none', stroke: INK, 'stroke-width': .07, 'stroke-linecap': 'round' }, svg2));
  D.edgeLabels.forEach((e) => { const t = S('text', { x: e.p[0], y: -e.p[1] + .06, 'text-anchor': 'middle', 'font-size': .17, fill: INK, 'font-weight': 600 }, svg2); t.textContent = e.label; });
  D.crossings.forEach((c) => S('circle', { cx: c.p[0], cy: -c.p[1], r: .045, fill: BAD }, svg2));
  let sw = false, sh = false;
  const tbl = H('table', {}); const wrap = H('div', { class: 'tablewrap', style: 'padding:12px' }, tbl); w.querySelector('.stage').append(wrap);
  function draw() {
    drawPolyDiagram(svg, B, { colour: () => INK, width: .16, gap: .34, switched: sw, group: g });
    B.crossings.forEach((c) => { const x = crossPoint(B, c); S('circle', { cx: x[0], cy: -x[1], r: .1, fill: BAD }, g); });
    { const p = B.orth[0], q = B.orth[1], m = [(p[0] + q[0]) / 2, (p[1] + q[1]) / 2], d = [q[0] - p[0], q[1] - p[1]], L = Math.hypot(...d), u = [d[0] / L, d[1] / L];
      S('path', { d: `M${m[0] + u[0] * .25},${-(m[1] + u[1] * .25)}l${-u[0] * .4 - u[1] * .22},${u[1] * .4 - u[0] * .22}l${u[1] * .44},${u[0] * .44}Z`, fill: INK }, g);
      S('circle', { cx: p[0], cy: -p[1], r: .14, fill: INK }, g); }
    labG.innerHTML = '';
    B.pdLabels.forEach((e, k) => { const t = S('text', { x: e.p[0], y: -e.p[1] + .12, 'text-anchor': 'middle', 'font-size': .34, fill: INK, 'font-weight': 600 }, labG); t.textContent = sh ? e.label : ((e.label - 1 - 6 + 20) % 10) + 1; });
    const cur = sw ? (sh ? PD.shifted : PD.switched) : (sh ? PD.w36.map((X) => X.map((x) => (x + 5) % 10 + 1)) : PD.w36);
    const stdS = PD.std.map((X) => X.join(','));
    tbl.innerHTML = '<thead><tr><th>code of w36</th><th>now</th><th>KnotInfo</th></tr></thead>';
    const tb = H('tbody'); tbl.append(tb);
    cur.forEach((X, k) => { const j = stdS.indexOf(X.join(',')); tb.append(H('tr', {}, H('td', {}, `[${PD.w36[k].join(', ')}]`), H('td', { style: j >= 0 ? 'font-weight:700' : '' }, `[${X.join(', ')}]`), H('td', { html: j >= 0 ? `<span class="ok">= X<sub>${j + 1}</sub></span>` : '<span style="color:' + INK2 + '">no match</span>' }))); });
    read.innerHTML = sw && sh ? '<span class="ok">Every crossing matches the KnotInfo code.</span> So the diagram of w<sub>36</sub> is the KnotInfo diagram with every crossing switched: a diagram of the mirror image of 5<sub>2</sub>.'
      : 'Switch all crossings and add 6 to every label; each row of the code then becomes a crossing of the KnotInfo code.';
  }
  const read = H('div', { class: 'readout' });
  const ctl = ctlRow(w);
  const b1 = btn('Switch all crossings', () => { sw = !sw; b1.setAttribute('aria-pressed', String(sw)); draw(); }, { 'aria-pressed': 'false' });
  const b2 = btn('Add 6 to every label', () => { sh = !sh; b2.setAttribute('aria-pressed', String(sh)); draw(); }, { 'aria-pressed': 'false' });
  ctl.append(b1, b2); w.append(read); draw();
}

// ============================================================ Table 2: links to the Lean sources
const LEAN = {
  isPolygon_length_even: 'NormalForm.lean', exists_survivor: 'NormalForm.lean', curtainOK_of_min: 'NF/Moves.lean', cornerOK_of_min: 'NF/Moves.lean',
  search_complete: 'SearchProof.lean', search_complete_parts: 'SearchProof.lean', colorCheck_sound: 'Coloring.lean', square_ok: 'Coloring.lean',
  w52_coloring: 'Coloring.lean', w52_polygon: 'Coloring.lean', w52_length: 'Coloring.lean', compCert_of_checks: 'Cert.lean', no_short: 'Main.lean',
  w52_pd: 'PD.lean', w52_pd_eq: 'PD.lean', fig_pd_eq: 'Figure.lean', fig_relabel: 'Figure.lean', fig_coloring: 'Figure.lean', fig_crossings: 'Figure.lean', wTre_pd: 'Figure.lean',
  KnotClass: 'Spec.lean', IsPolygon: 'Spec.lean', LexPos: 'Spec.lean', CurtainOK: 'Spec.lean', CornerOK: 'Spec.lean', Survive: 'Spec.lean',
  TopHyp: 'Statement.lean', CompCert: 'Cert.lean', dfs: 'Search.lean', colorCheck: 'Coloring.lean', checkPart: 'Cert.lean',
};
function stackTables() {   // label every cell with its column head, for the stacked layout on phones
  document.querySelectorAll('.fig > table').forEach((t) => {
    const heads = [...t.querySelectorAll('thead th')].map((th) => th.textContent.trim());
    t.querySelectorAll('tbody tr').forEach((tr) => [...tr.children].forEach((td, k) => td.setAttribute('data-label', heads[k] || '')));
    t.classList.add('stackable');
  });
}
function linkLean() {
  const base = 'https://github.com/srinjoysom11/-K-NOT_THEORY/blob/main/research/exact/lean/Len52/';
  document.querySelectorAll('.doc code').forEach((c) => {
    const name = c.textContent.trim(); if (!LEAN[name] || c.closest('a')) return;
    const a = H('a', { href: base + LEAN[name], title: `${name} in ${LEAN[name]}` }); c.replaceWith(a); a.append(c);
  });
}

// ------------------------------------------------------------------------------- rail, scrollspy
function rail() {
  const links = [...document.querySelectorAll('.toc a')];
  const secs = links.map((a) => document.getElementById(decodeURIComponent(a.getAttribute("href").slice(1)))).filter(Boolean);
  const box = document.querySelector('.rail-box');
  const small = matchMedia('(max-width: 860px)');
  const sync = () => { box.open = !small.matches; };
  sync(); small.addEventListener('change', sync);
  links.forEach((a) => a.addEventListener('click', () => { if (small.matches) box.open = false; }));
  let cur = null;
  const update = () => {
    let k = 0; const y = innerHeight * 0.3;
    secs.forEach((s, i) => { if (s.getBoundingClientRect().top < y) k = i; });
    if (k !== cur) { cur = k; links.forEach((a, i) => a.setAttribute('aria-current', String(i === k))); }
  };
  addEventListener('scroll', update, { passive: true }); update();
}

// ------------------------------------------------------------------------------- boot
// 3D figures (figs3d.js, the lattice studio) replace the flat ones when WebGL is available; the flat
// widgets stay as the fallback. Figures that need no WebGL (the heptagon) always come from figs3d.js.
let F3 = null;
async function f3() {
  if (F3 === null) { try { const st = await import('./studio.js'); F3 = st.hasGL() ? await import('./figs3d.js') : false; } catch (e) { console.error(e); F3 = false; } }
  return F3;
}
const via3d = (name, flat) => async (w) => { const m = await f3(); if (m) m[name](w); else if (flat) flat(w); else w.append(H('p', { class: 'hint' }, 'This interactive figure needs WebGL. The proof above is complete without it.')); };
const WIDGETS = { polygon: via3d('figPolygon', wPolygon), delta: via3d('figDelta', wDelta), trefoil: via3d('figTrefoil', wTrefoil), segsquare: via3d('figSegSquare', wSegSquare),
  flipdelta: via3d('figFlipDelta', wFlipDelta), psi: via3d('figPsi', wPsi), curtain: via3d('figCurtain', wCurtain), corners: via3d('figCorners', wCorners),
  origin: via3d('figOrigin', wOrigin), replay: via3d('figObligation', wReplay), reach: via3d('figReach', wReach), span: async (w) => { await via3d('figSpan', null)(w); wSpan(w); } /* 3D state, then the one-axis picture of the caption */, runs: wRuns, growth: wGrowth,
  std52: via3d('figStd52', wStd52), certex: via3d('figCertex', wCertex), pdcompare: async (w) => (await import('./figs3d.js')).figPdCompare(w),
  deltaproof: via3d('figDeltaProof'), invariant: via3d('figInvariant'), d7: async (w) => (await import('./figs3d.js')).figD7(w), deps: () => {} };
function holdAnchor() {
  let target = null, until = 0, user = false;
  const ro = new ResizeObserver(() => { if (target && !user && performance.now() < until) target.scrollIntoView({ block: 'start', behavior: 'instant' }); });
  ro.observe(document.querySelector('.doc'));
  const stop = () => { user = true; };
  ['wheel', 'touchstart', 'keydown'].forEach((ev) => addEventListener(ev, stop, { passive: true }));
  const go = (id) => {
    const t = document.getElementById(id); if (!t) return;
    target = t; until = performance.now() + 4000; user = false;
    requestAnimationFrame(() => t.scrollIntoView({ block: 'start', behavior: 'instant' }));
  };
  document.addEventListener('click', (e) => {   // in-page links: land on the target and stay there while figures above it build
    const a = e.target.closest('a[href^="#"]'); if (!a) return;
    const id = decodeURIComponent(a.getAttribute('href').slice(1)); if (!document.getElementById(id)) return;
    e.preventDefault(); history.pushState(null, '', '#' + id); go(id);
  });
  addEventListener('popstate', () => go(decodeURIComponent(location.hash.slice(1))));
  if (location.hash) go(decodeURIComponent(location.hash.slice(1)));
}
function boot() {
  masthead(); rail(); linkLean(); stackTables(); holdAnchor();
  // long proofs can be folded (they start open: the page is the paper)
  document.querySelectorAll('.doc .proof').forEach((pf) => {
    if (pf.textContent.length < 1600) return;
    const b = H('button', { class: 'fold', type: 'button', 'aria-expanded': 'true' }, 'Hide the proof');
    b.addEventListener('click', () => { const f = pf.classList.toggle('folded'); b.setAttribute('aria-expanded', String(!f)); b.textContent = f ? 'Show the proof' : 'Hide the proof'; });
    pf.prepend(b);
  });
  const io = new IntersectionObserver((es) => es.forEach((e) => {
    if (!e.isIntersecting) return; io.unobserve(e.target);
    const f = WIDGETS[e.target.dataset.w];
    if (!f) {   // never fail silently: show the paper's own figure
      const ns = e.target.nextElementSibling;
      if (ns && ns.tagName === 'NOSCRIPT') e.target.innerHTML = ns.textContent;
      console.error('no widget for', e.target.dataset.w); return;
    }
    const live = () => e.target.querySelectorAll('.readout').forEach((x) => x.setAttribute('aria-live', 'polite'));   // announce state changes
    try { const r = f && f(e.target); if (r && r.then) r.then(live, (err) => console.error(err)); else live(); } catch (err) { console.error(err); }
  }), { rootMargin: '600px 0px' });
  document.querySelectorAll('.widget[data-w]').forEach((w) => io.observe(w));
}
boot();
