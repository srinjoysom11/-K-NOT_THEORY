// The figures of the interactive edition that live in 3D (and the 2D diagram renderer they share).
import { DATA } from './data.js';
import { Studio, THREE, COL, INK, crossingsOf, pointAt, arcPolylines } from './studio.js';

const NS = 'http://www.w3.org/2000/svg';
const GOOD = '#00805c', BAD = '#c0281b', INK2 = '#4b525c', SHEET = '#ffffff';
const U = { e: [1, 0, 0], w: [-1, 0, 0], n: [0, 1, 0], s: [0, -1, 0], u: [0, 0, 1], d: [0, 0, -1] };
const REV = { e: 'w', w: 'e', n: 's', s: 'n', u: 'd', d: 'u' };
const AX = { e: 0, w: 0, n: 1, s: 1, u: 2, d: 2 };
const mod = (a, p) => ((a % p) + p) % p;
const add = (a, b, s = 1) => [a[0] + s * b[0], a[1] + s * b[1], a[2] + s * b[2]];
const key = (p) => p.join(',');
const onText = (c) => (c === COL[3] || c === COL[5] ? INK : '#fff');
function walk(word) { const V = [[0, 0, 0]]; for (const ch of word) V.push(add(V[V.length - 1], U[ch])); return V; }
function S(tag, attrs = {}, parent) { const e = document.createElementNS(NS, tag); for (const [k, v] of Object.entries(attrs)) if (v != null) e.setAttribute(k, v); if (parent) parent.appendChild(e); return e; }
function H(tag, attrs = {}, ...kids) {
  const e = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs)) { if (k === 'class') e.className = v; else if (k === 'html') e.innerHTML = v; else if (k.startsWith('on')) e.addEventListener(k.slice(2), v); else if (v != null) e.setAttribute(k, v); }
  for (const k of kids) if (k != null) e.append(k); return e;
}
const btn = (label, on, attrs = {}) => H('button', { class: 'btn', type: 'button', onclick: on, ...attrs }, label);
function seg(options, value, onchange) {
  const box = H('div', { class: 'seg', role: 'group' });
  const bs = options.map(([v, label]) => { const b = btn(label, () => { set(v); onchange(v); }, { 'aria-pressed': String(v === value) }); b.dataset.v = v; box.append(b); return b; });
  function set(v) { bs.forEach((b) => b.setAttribute('aria-pressed', String(b.dataset.v === String(v)))); }
  box.set = set; return box;
}
function stage(w, cols = 1, cls = '') {
  const st = H('div', { class: 'stage ' + cls }); const ps = H('div', { class: 'panes', style: `--cols:${cols}` });
  const out = []; for (let i = 0; i < cols; i++) { const p = H('div', { class: 'pane' }); ps.append(p); out.push(p); }
  st.append(ps); w.append(st); return out;
}
const ctlRow = (w) => { const c = H('div', { class: 'ctl' }); w.append(c); return c; };
const readout = (w) => { const r = H('div', { class: 'readout' }); w.append(r); return r; };
const hint = (text) => H('p', { class: 'hint' }, text);

// ===================================================================== 2D knot diagrams (SVG)
/** A crisp diagram of a lattice polygon under the paper's projection pi_D (scaled by 1/D_z).
 * Strands are cut at under-passages (or at over-passages if switched), drawn with round joins over
 * a casing in the sheet colour. Returns { svg, arcs: [{arc, path}], P2, crossPts, fit }. */
export function knot2d(host, blk, { colour = () => INK, width = 0.15, gap = 0.3, switched = false, pad = 0.9, svg } = {}) {
  const P2 = blk.orth || blk.proj, n = P2.length;   // the orthographic view along D (what the 3D camera shows)
  if (!svg) svg = S('svg', { role: 'img', class: 'knot2d' }, host);
  svg.innerHTML = '';
  const xs = P2.map((p) => p[0]), ys = P2.map((p) => -p[1]);
  const x0 = Math.min(...xs) - pad, y0 = Math.min(...ys) - pad, W = Math.max(...xs) - x0 + pad, Hh = Math.max(...ys) - y0 + pad;
  svg.setAttribute('viewBox', `${x0} ${y0} ${W} ${Hh}`);
  const at = (s) => { const i = Math.floor(s) % n, f = s - Math.floor(s), p = P2[i], q = P2[(i + 1) % n]; return [p[0] + f * (q[0] - p[0]), p[1] + f * (q[1] - p[1])]; };
  const cuts = blk.crossings.map((c) => (switched ? c.over : c.under)).map(([e, t]) => e + t).sort((a, b) => a - b);
  const arcIdx = (s) => {   // the arc of the paper's data (pieces [edge, t0, t1, arc]) at parameter s
    const i = Math.floor(s) % n, t = s - Math.floor(s);
    const pc = blk.pieces && blk.pieces.find((q) => q[0] === i && q[1] - 1e-9 <= t && t <= q[2] + 1e-9);
    if (pc) return pc[3];
    const u = blk.crossings.map((c) => c.under[0] + c.under[1]).sort((a, b) => a - b); let k = 0; for (const x of u) if (x < s) k++; return (k - 1 + u.length) % u.length;
  };
  const segLen = (s) => { const i = Math.floor(s) % n, p = P2[i], q = P2[(i + 1) % n]; return Math.hypot(q[0] - p[0], q[1] - p[1]); };
  const strands = [];
  for (let k = 0; k < cuts.length; k++) {
    let a = cuts[k], b = cuts[(k + 1) % cuts.length]; if (b <= a) b += n;
    a += gap / segLen(a); b -= gap / segLen(b);
    const pts = [at(a)]; for (let j = Math.floor(a) + 1; j <= Math.floor(b); j++) pts.push(P2[j % n]); pts.push(at(b));
    // colour by the arc in the middle of the strand (for switched strands: the arc structure of the original)
    strands.push({ pts, mid: (a + b) / 2, arc: arcIdx(((a + b) / 2) % n) });
  }
  const d = (pts) => 'M' + pts.map((p) => `${p[0].toFixed(4)},${(-p[1]).toFixed(4)}`).join('L');
  const g = S('g', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', fill: 'none' }, svg);
  const arcs = [];
  for (const s of strands) {
    S('path', { d: d(s.pts), stroke: SHEET, 'stroke-width': width + 0.16 }, g);
    const path = S('path', { d: d(s.pts), stroke: switched ? INK : colour(s.arc), 'stroke-width': width }, g);
    path.dataset.arc = s.arc; arcs.push({ arc: s.arc, path, pts: s.pts });
  }
  const crossPts = blk.crossings.map((c) => at(c.under[0] + c.under[1]));
  return { svg, arcs, P2, crossPts, at, view: [x0, y0, W, Hh] };
}
/** place labels near anchor points, away from strands, crossings and each other */
export function placeLabels(D, anchors, r = 0.45, extraAvoid = []) {
  const pts = []; for (const a of D.arcs) for (let i = 0; i + 1 < a.pts.length; i++) for (let k = 0; k < 6; k++) { const p = a.pts[i], q = a.pts[i + 1]; pts.push([p[0] + k / 6 * (q[0] - p[0]), p[1] + k / 6 * (q[1] - p[1])]); }
  const avoid = [...pts, ...D.crossPts.flatMap((c) => [c, c, c]), ...extraAvoid];
  const used = [];
  return anchors.map((x) => {
    let best = x, bs = -1;
    for (let k = 0; k < 16; k++) { const ang = k / 16 * 2 * Math.PI; for (const rr of [r]) {
      const c = [x[0] + rr * Math.cos(ang), x[1] + rr * Math.sin(ang)];
      let s = Math.min(...avoid.map((p) => Math.hypot(p[0] - c[0], p[1] - c[1])));
      for (const u of used) s = Math.min(s, 0.7 * Math.hypot(u[0] - c[0], u[1] - c[1]));
      if (s > bs) { bs = s; best = c; } } }
    used.push(best); return best;
  });
}
function pill(svg, p, text, fill, size = 0.42) {
  const g = S('g', {}, svg);
  S('circle', { cx: p[0], cy: -p[1], r: size * 0.62, fill }, g);
  const t = S('text', { x: p[0], y: -p[1] + size * 0.24, 'text-anchor': 'middle', 'font-size': size * 0.78, 'font-weight': 700, fill: onText(fill) }, g);
  t.textContent = text; return g;
}
/** midpoint of the longest straight run of each arc */
function arcAnchors(D) {
  const best = {};
  for (const a of D.arcs) for (let i = 0; i + 1 < a.pts.length; i++) {
    const p = a.pts[i], q = a.pts[i + 1], L = Math.hypot(q[0] - p[0], q[1] - p[1]);
    if (!best[a.arc] || L > best[a.arc][0]) best[a.arc] = [L, [(p[0] + q[0]) / 2, (p[1] + q[1]) / 2]];
  }
  return best;
}

// ===================================================================== Figure 1: w36
export function figPolygon(w) {
  const b = DATA.w36, col = (arc) => COL[b.colouring[arc]];
  const [p3, p2] = stage(w, 2);
  p3.append(H('span', { class: 'pane-label' }, '(a) the polygon; its shadow on the floor is the diagram'));
  p2.append(H('span', { class: 'pane-label' }, '(b) the diagram along D = (1, −1, 4)'));
  const st = new Studio(p3, { aspect: '1 / 1', shadowDir: b.D, label: 'The 36-step polygon in 3D; drag to turn',
    onPick: (u) => { if (u.arc != null) hl(u.arc, true); }, onHover: (u) => hl(u && u.arc != null ? u.arc : null) });
  const rods = [];
  const n = b.verts.length;
  for (const [i, a, c, arc] of b.pieces) {
    const p = b.verts[i], q = b.verts[(i + 1) % n];
    const A = add(p, add(q, p, -1), a), B = add(p, add(q, p, -1), c);
    rods.push(st.rod([A, B], { color: col(arc), radius: 0.11, userData: { arc }, pick: true }));
  }
  st.ball(b.verts[0], { color: INK, radius: 0.2 });
  st.frame(b.verts, [1.1, -1.5, 1.05]);
  st.label(add(b.verts[0], [0, 0, -0.55]), 'origin', 'small');
  const D = knot2d(p2, b, { colour: col, width: 0.17, gap: 0.32 });
  const anch = arcAnchors(D), arcsK = Object.keys(anch).map(Number);
  const spots = placeLabels(D, arcsK.map((k) => anch[k][1]), 0.48);
  arcsK.forEach((k, j) => {
    const g = pill(D.svg, spots[j], b.colouring[k], col(k)); g.classList.add('hit'); g.setAttribute('tabindex', '0'); g.setAttribute('role', 'button');
    g.setAttribute('aria-label', `arc ${k}, colour ${b.colouring[k]}`);
    g.addEventListener('pointerenter', () => hl(k)); g.addEventListener('pointerleave', () => hl(null)); g.addEventListener('focus', () => hl(k)); g.addEventListener('blur', () => hl(null));
  });
  D.arcs.forEach((a) => { a.path.classList.add('hit'); a.path.addEventListener('pointerenter', () => hl(a.arc)); a.path.addEventListener('pointerleave', () => hl(null)); });
  D.crossPts.forEach((x) => S('circle', { cx: x[0], cy: -x[1], r: 0.3, fill: 'none', stroke: INK2, 'stroke-width': 0.03, 'stroke-dasharray': '0.08 0.07' }, D.svg));
  const o = D.P2[0]; S('circle', { cx: o[0], cy: -o[1], r: 0.2, fill: INK }, D.svg);
  let pinned = null;
  function hl(arc, pin) {
    if (pin) pinned = pinned === arc ? null : arc;
    const a = arc == null ? pinned : arc;
    D.arcs.forEach((s) => s.path.setAttribute('opacity', a == null || s.arc === a ? 1 : 0.16));
    rods.forEach((r) => r.children.forEach((m) => { m.material.opacity = a == null || r.userData.arc === a ? 1 : 0.15; }));
    st.request();
    read.innerHTML = a == null ? 'Drag (a) to turn the polygon. Point at an arc in either panel to find it in the other; click to pin it.'
      : `Arc with colour <b>${b.colouring[a]}</b>: the same piece of the polygon in space and in the diagram.`;
  }
  const c = ctlRow(w); const read = H('span', { class: 'readout grow' });
  const mode = seg([['free', 'Free view'], ['proj', 'Look along D']], 'free', (v) => {
    if (v === 'proj') st.setDir(b.D, 1200, [0, 1, 0]); else st.setDir([1.1, -1.5, 1.05], 1000);
  });
  st.onUser = () => mode.set('free');
  c.append(mode, read); hl(null);
}

// ===================================================================== Figure 3: Fox colourings of the trefoil (3D)
export function figTrefoil(w) {
  const N = 360, P = [];
  for (let k = 0; k < N; k++) { const t = k / N * 2 * Math.PI; P.push([(Math.sin(t) + 2 * Math.sin(2 * t)) * 0.9, (Math.cos(t) - 2 * Math.cos(2 * t)) * 0.9, -Math.sin(3 * t) * 0.9 + 1.4]); }
  const K = crossingsOf(P), arcs = arcPolylines(P, K.unders, 0);
  const [pane] = stage(w, 1);
  let p = 3, x = [0, 1, 2];
  const st = new Studio(pane, { aspect: '16 / 10', shadowDir: [0, 0, 1], label: 'A trefoil in 3D; click a strand to change its colour',
    onPick: (u) => { if (u.arc != null) { x[u.arc] = mod(x[u.arc] + 1, p); draw(); } } });
  const tubes = arcs.map((pts, e) => st.tube(pts, { closed: false, radius: 0.17, userData: { arc: e }, pick: true, segments: 140 }));
  const inset = H('div', { class: 'inset' });
  inset.innerHTML = `<span class="inset-l">(a) the rule at a crossing</span><svg viewBox="0 0 120 92" role="img" aria-label="A crossing: the over-arc has colour b, the under-arcs have colours a and c, and 2b = a + c mod p">
    <path d="M60,88 L60,56" stroke="${COL[0]}" stroke-width="5" stroke-linecap="round"/><path d="M60,36 L60,6" stroke="${COL[2]}" stroke-width="5" stroke-linecap="round"/>
    <path d="M12,46 L108,46" stroke="${COL[1]}" stroke-width="5" stroke-linecap="round"/>
    <text x="70" y="80" font-size="11" font-weight="700" fill="${COL[0]}">a</text><text x="70" y="18" font-size="11" font-weight="700" fill="${COL[2]}">c</text><text x="98" y="38" font-size="11" font-weight="700" fill="${COL[1]}">b</text>
  </svg><span class="inset-f">2b ≡ a + c (mod p)</span>`;
  pane.append(inset, H('span', { class: 'pane-label', style: 'left:auto;right:12px' }, '(b) a trefoil; its shadow is the diagram'));
  st.frame(P, [0.35, -1.4, 1.25]);
  const badges = K.crossings.map((c) => st.label(pointAt(P, c.so).map((v, i) => (i === 2 ? v + 0.55 : v)), '', 'badge'));
  const read = readout(w);
  function count() { let k = 0; const c = 3; const rec = (i, v) => { if (i === c) { if (K.crossings.every((cr) => mod(2 * v[cr.over] - v[cr.inArc] - v[cr.outArc], p) === 0)) k++; return; } for (let a = 0; a < p; a++) { v[i] = a; rec(i + 1, v); } }; rec(0, []); return k; }
  function draw() {
    tubes.forEach((t, e) => { t.material.color.set(COL[x[e]]); });
    let ok = true;
    K.crossings.forEach((c, k) => {
      const o = x[c.over], i = x[c.inArc], u = x[c.outArc], good = mod(2 * o - i - u, p) === 0; ok = ok && good;
      badges[k].el.className = 'studio-label badge ' + (good ? 'ok' : 'no');
      badges[k].el.innerHTML = `2·${o} ${good ? '≡' : '≢'} ${i} + ${u}`;
    });
    st.request();
    const constant = x.every((v) => v === x[0]);
    read.innerHTML = `<b>p = ${p}.</b> ` + (ok ? `<span class="ok">A Fox ${p}-colouring${constant ? ' (constant)' : ', not constant'}.</span>` : '<span class="no">Not a colouring:</span> a red crossing breaks the rule.') +
      ` Each badge is one crossing: twice the over-arc against the two under-arcs. This diagram has <b>${count()}</b> ${p}-colourings${p === 7 ? ', only the 7 constant ones' : ''}. The floor shows the diagram as the knot's shadow.`;
  }
  const c = ctlRow(w);
  c.append(seg([['3', 'p = 3'], ['7', 'p = 7']], '3', (v) => { p = +v; x = x.map((a) => mod(a, p)); draw(); }), btn('Constant', () => { x = [0, 0, 0]; draw(); }), btn('Colours 0, 1, 2', () => { x = [0, 1, 2]; draw(); }),
    H('span', { class: 'readout grow' }, 'Click a strand to add 1 to its colour. Drag to turn.'));
  draw();
}

// ===================================================================== Figure 4: segment and square (3D)
export function figSegSquare(w) {
  const [pane] = stage(w, 1);
  const st = new Studio(pane, { aspect: '16 / 9', shadowDir: [0.3, -0.4, 1], label: 'A unit square and a unit segment in the lattice' });
  const box = [];
  for (let x = -1; x <= 2; x++) for (let y = -1; y <= 2; y++) for (let z = -1; z <= 1; z++) box.push([x, y, z]);
  // lattice points
  const g = new THREE.BufferGeometry(); g.setAttribute('position', new THREE.Float32BufferAttribute(box.flat(), 3));
  st.world.add(new THREE.Points(g, new THREE.PointsMaterial({ color: 0x5d6570, size: 5, sizeAttenuation: false })));
  const Q = [[0, 0, 0], [1, 0, 0], [1, 1, 0], [0, 1, 0]];
  st.sheet(Q, { color: COL[0], opacity: 0.22 });
  st.line([...Q, Q[0]], { color: COL[0] });
  Q.forEach((q) => st.ball(q, { color: COL[0], radius: 0.06 }));
  st.label([0.5, 0.5, 0], 'Q', 'tag');
  st.frame([[-0.4, -0.4, -1], [1.4, 1.4, 1]], [1.3, -1.7, 1.15], 1.0);
  const segG = new THREE.Group(); st.world.add(segG);
  const eLab = st.label([0, 0, 0], 'E', 'tag strong');
  let p = [1, 1, -1], ax = 2;
  const read = readout(w);
  function inter() {
    const q = p.slice(); q[ax] += 1;
    if (ax === 2) return p[2] <= 0 && 0 <= q[2] && p[0] >= 0 && p[0] <= 1 && p[1] >= 0 && p[1] <= 1 ? ['corner', [[p[0], p[1], 0]]] : ['empty', []];
    if (p[2] !== 0) return ['empty', []];
    const o = 1 - ax; if (p[o] < 0 || p[o] > 1) return ['empty', []];
    const lo = Math.max(p[ax], 0), hi = Math.min(q[ax], 1); if (hi < lo) return ['empty', []];
    const A = p.slice(), B = p.slice(); A[ax] = lo; B[ax] = hi; return hi > lo ? ['side', [A, B]] : ['corner', [A]];
  }
  function draw() {
    st.clear(segG);
    const q = p.slice(); q[ax] += 1;
    st.rod([p, q], { color: INK, radius: 0.06, parent: segG }); eLab.pos.set(...add(p, q, 1).map((v) => v / 2 + 0.18));
    const [kind, pts] = inter();
    if (kind === 'side') st.rod(pts, { color: COL[1], radius: 0.1, parent: segG });
    if (kind === 'corner') st.ball(pts[0], { color: COL[1], radius: 0.15, parent: segG });
    read.innerHTML = `E runs from (${p.join(', ')}) to (${q.join(', ')}). <b>E ∩ Q is ${kind === 'empty' ? 'empty' : kind === 'side' ? 'a whole side' : 'a corner'}.</b> Move E anywhere: it never meets an interior point of Q.`;
  }
  const c = ctlRow(w);
  c.append(seg([['0', 'E along x'], ['1', 'along y'], ['2', 'along z']], '2', (v) => { ax = +v; draw(); }));
  const mv = H('div', { class: 'seg', role: 'group', 'aria-label': 'move the segment one lattice step' });
  for (const l of 'ewnsud') mv.append(btn(l, () => { p = add(p, U[l]).map((v) => Math.max(-1, Math.min(2, v))); draw(); }, { 'aria-label': `move ${l}` }));
  c.append(H('span', { class: 'readout' }, 'Move E:'), mv, H('span', { class: 'readout grow' }, 'Drag to turn.'));
  draw();
}

// ===================================================================== Figure 6: the potential psi_Z (3D)
export function figPsi(w) {
  const start = 'eeeuwuwwdd'.split('');   // the polygon of the paper's figure, in the xz-plane
  const [pane, side] = stage(w, 2, 'stage-side');
  side.classList.add('side');
  let word = start.slice();
  const st = new Studio(pane, { aspect: '1 / 1', shadowDir: [0.2, -0.3, 1], label: 'A lattice polygon with the heights of its vertices; click a ring to flip a corner',
    onPick: (u) => { if (u.flip != null) doFlip(u.flip); } });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame(walk(word.join('')).slice(0, -1).concat([[0, 0, -0.3], [3, 0, 2.5]]), [0.55, -1.7, 0.6]);
  const big = H('div', { class: 'bignum' }); const sub = H('div', { class: 'readout' }); const hist = H('ol', { class: 'log' });
  side.append(H('h5', {}, 'Height potential'), big, sub, H('h5', { style: 'margin-top:14px' }, 'Flips so far'), hist);
  const psiOf = (V) => { const z = V.map((v) => v[2]); const m = Math.min(...z); return [z.reduce((a, v) => a + v - m, 0), m]; };
  function flips(V) {
    const n = word.length, out = [], set = new Set(V.map(key));
    for (let i = 1; i < n; i++) { const pp = word[i - 1], d = word[i]; if (AX[pp] === AX[d]) continue; const vp = add(V[i - 1], U[d]); if (!set.has(key(vp))) out.push({ i, vp }); }
    return out;
  }
  function draw(moving) {
    st.clear(grp); st.clearLabels();
    const V = walk(word.join('')).slice(0, -1);
    if (moving) V[moving.i] = moving.p;
    const [psi, zmin] = psiOf(V);
    st.rod([...V, V[0]], { color: INK, radius: 0.08, parent: grp });
    const zf = st.floorZ != null ? st.floorZ : zmin - 0.7;
    V.forEach((v, k) => {
      const h = Math.round(v[2] - zmin);
      st.ball(v, { color: INK, radius: 0.1, parent: grp });
      st.label(add(v, [0, -0.25, 0.3]), `v<sub>${k}</sub><span class="h">${h}</span>`, 'tag vh');
      if (h > 0) st.line([v, [v[0], v[1], zmin]], { color: COL[0], dashed: true, opacity: 0.7, parent: grp });
    });
    // the floor level z_min
    const xs = V.map((v) => v[0]), ys = V.map((v) => v[1]);
    st.sheet([[Math.min(...xs) - 0.6, Math.min(...ys) - 0.6, zmin], [Math.max(...xs) + 0.6, Math.min(...ys) - 0.6, zmin], [Math.max(...xs) + 0.6, Math.max(...ys) + 0.6, zmin], [Math.min(...xs) - 0.6, Math.max(...ys) + 0.6, zmin]], { color: COL[0], opacity: 0.07, parent: grp });
    if (!moving) for (const f of flips(V)) {
      const down = f.vp[2] < V[f.i][2], same = f.vp[2] === V[f.i][2];
      const c = down ? COL[2] : same ? COL[5] : COL[1];
      st.ball(f.vp, { color: c, radius: 0.16, hollow: true, userData: { flip: f.i }, pick: true, parent: grp });
      st.sheet([V[f.i - 1], V[f.i], V[(f.i + 1) % V.length], f.vp], { color: c, opacity: 0.12, parent: grp });
    }
    big.innerHTML = `ψ<sub>Z</sub> = ${psi}`;
    sub.innerHTML = `The sum of the vertex heights above the lowest level z<sub>min</sub> = ${zmin} (the blue plane). Each ring is the fourth corner v′ of a square at a corner of the polygon where a flip is allowed: <span style="color:${COL[2]};font-weight:700">green</span> moves the vertex down and lowers ψ<sub>Z</sub> by 1, <span style="color:${COL[1]};font-weight:700">orange</span> moves it up, <span style="color:#2b8cc4;font-weight:700">blue</span> sideways. Click a ring to flip.`;
    st.request();
  }
  function doFlip(i) {
    const V = walk(word.join('')).slice(0, -1), from = V[i], to = add(V[i - 1], U[word[i]]);
    const before = psiOf(V)[0];
    st.tween(650, (k) => draw({ i, p: from.map((a, j) => a + k * (to[j] - a)) }), () => {
      [word[i - 1], word[i]] = [word[i], word[i - 1]];
      draw();
      const after = psiOf(walk(word.join('')).slice(0, -1))[0];
      hist.prepend(H('li', { html: `corner at v<sub>${i}</sub>: ψ<sub>Z</sub> ${before} → <b>${after}</b>` }));
    });
  }
  const c = ctlRow(w);
  c.append(btn('Reset', () => { word = start.slice(); hist.innerHTML = ''; draw(); }), H('span', { class: 'readout grow', html: 'Drag to turn. The blue numbers are the vertex heights above z<sub>min</sub>; ψ<sub>Z</sub> is their sum. The paper flips the corner at v<sub>6</sub>.' }));
  draw();
}

// ===================================================================== Figure 7: curtains (3D)
export function figCurtain(w) {
  const [pane, side] = stage(w, 2, 'stage-side'); side.classList.add('side');
  const st = new Studio(pane, { aspect: '1 / 1', shadowDir: [0.2, -0.3, 1], label: 'A curtain in 3D and the flips that remove it' });
  const grp = new THREE.Group(); st.world.add(grp);
  const SIDE = ['e', 'n', 'e', 's', 'e'];
  let k = 3, t = 0;
  const info = H('div', { class: 'readout' }); const walkLine = H('div', { class: 'walkline' });
  side.append(H('h5', {}, 'The curtain lemma, step by step'), info, H('h5', { style: 'margin-top:14px' }, 'The walk now'), walkLine);
  function orig() { const V = [[0, 0, 0]]; V.push([0, 0, 1]); for (let j = 0; j < k; j++) V.push(add(V[V.length - 1], U[SIDE[j]])); V.push(add(V[V.length - 1], U.d)); return V; } // v0..v_{k+2}
  function current(tt) {
    const V = orig(), a = U.u;
    if (tt === k) return [V[0], ...V.slice(2, k + 2).map((v) => add(v, a, -1))].concat([V[k + 2]]).filter((v, i, arr) => i === 0 || key(v) !== key(arr[i - 1]));
    const out = [V[0]]; for (let j = 2; j <= tt + 1; j++) out.push(add(V[j], a, -1)); for (let j = tt + 1; j <= k + 2; j++) out.push(V[j]); return out;
  }
  function draw(moveFrom, moveTo, kk) {
    st.clear(grp); st.clearLabels();
    const V = orig(), a = U.u;
    // the curtain: the vertical strip between the sideways stretch and the points below it
    for (let j = 1; j <= k; j++) st.sheet([V[j], V[j + 1], add(V[j + 1], a, -1), add(V[j], a, -1)], { color: COL[2], opacity: 0.16, parent: grp });
    let path = current(t);
    if (moveFrom) { path = current(t); path = path.map((p) => (key(p) === key(moveFrom) ? moveFrom.map((x, i) => x + kk * (moveTo[i] - x)) : p)); }
    st.line([[-0.6, 0, 0], V[0]], { color: INK2, dashed: true, parent: grp }); st.line([V[k + 2], add(V[k + 2], U.e, 0.6)], { color: INK2, dashed: true, parent: grp });
    st.rod(path, { color: INK, radius: 0.08, parent: grp });
    path.forEach((p) => st.ball(p, { color: INK, radius: 0.1, parent: grp }));
    const visited = new Set(path.map(key));
    for (let j = 2; j <= k; j++) { const q = add(V[j], a, -1); if (!visited.has(key(q))) { st.ball(q, { color: COL[2], radius: 0.13, hollow: true, parent: grp }); st.label(add(q, [0, -0.15, -0.32]), `v<sub>${j}</sub>−a`, 'tag'); } }
    if (t < k) V.forEach((v, j) => { if (j <= t) return; if (visited.has(key(v))) st.label(add(v, [0, 0, 0.32]), `v<sub>${j}</sub>`, 'tag'); });
    st.label(add(V[0], [0, 0, -0.35]), 'v<sub>0</sub>', 'tag');
    const letters = t === k ? Array.from({ length: k }, (_, j) => `s<sub>${j + 1}</sub>`) : [...Array.from({ length: t }, (_, j) => `s<sub>${j + 1}</sub>`), '<b>a</b>', ...Array.from({ length: k - t }, (_, j) => `s<sub>${t + j + 1}</sub>`), '<b>−a</b>'];
    walkLine.innerHTML = letters.join(', ');
    info.innerHTML = t === 0 ? `A curtain with <b>k = ${k}</b>: a = up, then ${k} sideways steps s<sub>1</sub>…s<sub>${k}</sub>, then −a = down. The green rings are its interior points v<sub>j</sub> − a (2 ≤ j ≤ ${k}); suppose none is a vertex.`
      : t < k ? `<b>After ${t} flip${t > 1 ? 's' : ''}.</b> Flip ${t} replaced v<sub>${t}</sub> by v<sub>${t + 1}</sub> − a: allowed, because that ring was free. The step a now sits in position ${t}.` + (t === k - 1 ? ` Now a, s<sub>${k}</sub>, −a form a U-turn.` : '')
        : `<b>U-turn removed.</b> The polygon has two fewer steps and the same knot type. A shortest polygon cannot allow this, so one of the rings must be a vertex: DMON6.`;
    back.disabled = t === 0; next.disabled = t === k; st.request();
  }
  function step(dir) {
    if (dir > 0 && t < k - 1) {      // animate vertex v_{t+1} sliding to v_{t+2} - a
      const V = orig(), from = V[t + 1], to = add(V[t + 2], U.u, -1);
      st.tween(700, (kk) => draw(from, to, kk), () => { t++; draw(); });
    } else { t = Math.max(0, Math.min(k, t + dir)); draw(); }
  }
  st.frame(orig(), [0.9, -1.7, 0.85]);
  const back = btn('Back', () => step(-1)), next = btn('Next step', () => step(1));
  const c = ctlRow(w);
  c.append(H('span', { class: 'readout' }, 'k ='), seg([['2', '2'], ['3', '3'], ['4', '4'], ['5', '5']], '3', (v) => { k = +v; t = 0; st.frame(orig(), [0.9, -1.7, 0.85]); draw(); }), back, next, H('span', { class: 'readout grow' }, 'Drag to turn.'));
  draw();
}

// ===================================================================== Figure 8: the four corner patterns (3D)
export function figCorners(w) {
  const [pane] = stage(w, 1);
  const st = new Studio(pane, { aspect: '5 / 2', shadowDir: [0.2, -0.3, 1], label: 'The four corner patterns of DMON7' });
  const grp = new THREE.Group(); st.world.add(grp);
  // each pattern: previous vertex, v_i, next vertex (v' = prev + next - v_i), in its own spot
  const lower = [
    { t: '(1) up, then horizontal', P: [[0, 0, 0], [0, 0, 1], [1, 0, 1]], eff: 'ψ<sub>Z</sub> − 1' },
    { t: '(2) horizontal, then down', P: [[0, 0, 1], [1, 0, 1], [1, 0, 0]], eff: 'ψ<sub>Z</sub> − 1' },
    { t: '(3) north, then east or west', P: [[0, 0, 0], [0, 1, 0], [1, 1, 0]], eff: 'same height, ψ<sub>Y</sub> − 1' },
    { t: '(4) east or west, then south', P: [[0, 1, 0], [1, 1, 0], [1, 0, 0]], eff: 'same height, ψ<sub>Y</sub> − 1' }];
  const raise = [
    { t: 'down, then horizontal', P: [[0, 0, 1], [0, 0, 0], [1, 0, 0]], eff: 'ψ<sub>Z</sub> + 1: not used' },
    { t: 'horizontal, then up', P: [[0, 0, 0], [1, 0, 0], [1, 0, 1]], eff: 'ψ<sub>Z</sub> + 1: not used' },
    { t: 'south, then east or west', P: [[0, 1, 0], [0, 0, 0], [1, 0, 0]], eff: 'ψ<sub>Y</sub> + 1: not used' },
    { t: 'east or west, then north', P: [[0, 0, 0], [1, 0, 0], [1, 1, 0]], eff: 'ψ<sub>Y</sub> + 1: not used' }];
  let set = lower, kf = 0;
  const offset = (i) => [i * 3.2, 0, 0];
  function draw() {
    st.clear(grp); st.clearLabels();
    set.forEach((c, i) => {
      const o = offset(i), [a, v, b] = c.P.map((p) => add(p, o)), vp = add(add(a, b), v, -1);
      const vNow = v.map((x, j) => x + kf * (vp[j] - x));
      st.sheet([a, v, b, vp], { color: set === lower ? COL[2] : COL[1], opacity: 0.14, parent: grp });
      const ext = (p, q) => add(p, add(p, q, -1), 0.6);
      st.rod([ext(a, v), a, vNow, b, ext(b, v)], { color: INK, radius: 0.07, parent: grp });
      st.ball(a, { color: INK, radius: 0.09, parent: grp }); st.ball(b, { color: INK, radius: 0.09, parent: grp });
      st.ball(vNow, { color: INK, radius: 0.12, parent: grp });
      st.ball(kf < 0.5 ? vp : v, { color: set === lower ? COL[2] : COL[1], radius: 0.13, hollow: true, parent: grp });
      st.label(add(vNow, [0, 0, 0.3]), 'v<sub>i</sub>', 'tag');
    });
    strip.innerHTML = set.map((c) => `<div><b>${c.t}</b><br>${c.eff}</div>`).join('');
    st.request();
  }
  const strip = H('div', { class: 'capstrip' }); pane.append(strip);
  st.frame([[-0.6, -0.2, -0.2], [10.4, 1.2, 1.4]], [0.25, -1.5, 0.75]);
  const ctl = ctlRow(w);
  let flipped = false;
  const play = btn('Flip all four', () => {
    const from = flipped ? 1 : 0, to = flipped ? 0 : 1; flipped = !flipped; play.textContent = flipped ? 'Undo the flips' : 'Flip all four';
    st.tween(800, (k) => { kf = from + (to - from) * k; draw(); });
  });
  ctl.append(play, seg([['lower', 'The four DMON7 patterns'], ['raise', 'The other four']], 'lower', (v) => { set = v === 'lower' ? lower : raise; kf = 0; flipped = false; play.textContent = 'Flip all four'; draw(); }),
    H('span', { class: 'readout grow' }, 'The ring is v′, the fourth corner of the shaded square. Drag to turn.'));
  draw();
}

// ===================================================================== Figure 9: DMON3 and DMON4 at the origin (3D)
export function figOrigin(w) {
  const b = DATA.w36, V = b.verts, n = V.length, word = b.word;
  const [pane] = stage(w, 1);
  const st = new Studio(pane, { aspect: '16 / 9', shadowDir: [0.2, -0.3, 1], label: 'The 36-step polygon, its lowest vertex and the direction of travel' });
  st.rod([...V, V[0]], { color: '#aab2bb', radius: 0.07 });
  st.rod([V[n - 1], V[0], V[1]], { color: COL[1], radius: 0.1 });
  st.ball(V[0], { color: INK, radius: 0.2 });
  const xs = V.map((v) => v[0]), ys = V.map((v) => v[1]);
  st.sheet([[Math.min(...xs) - 0.8, Math.min(...ys) - 0.8, 0], [Math.max(...xs) + 0.8, Math.min(...ys) - 0.8, 0], [Math.max(...xs) + 0.8, Math.max(...ys) + 0.8, 0], [Math.min(...xs) - 0.8, Math.max(...ys) + 0.8, 0]], { color: COL[0], opacity: 0.08 });
  st.frame(V, [1.2, -1.7, 0.7]);
  st.label(add(V[0], [-0.2, 0, -0.45]), 'v<sub>0</sub> = 0, lowest', 'tag');
  const lw0 = st.label(add(V[0], add(U[word[0]], [0, -0.3, 0.25], 1), 0.6), '', 'tag strong');
  const lwl = st.label(add(V[0], add(U[REV[word[n - 1]]], [0, -0.3, 0.25]), 0.6), '', 'tag strong');
  const bead = st.ball(V[0], { color: COL[1], radius: 0.17 });
  let fwd = true, s0 = performance.now();
  st.always = true;
  const tick = () => { const t = ((performance.now() - s0) / 9000) % 1; const sIdx = (fwd ? t : 1 - t) * n; const p = pointAt(V, sIdx % n); bead.position.set(...p); };
  const orig = st.frameLoop.bind(st); st.frameLoop = () => { if (st.visible !== false) tick(); orig(); };
  const read = readout(w);
  const order = 'ewnsud';
  function draw() {
    const w0 = fwd ? word[0] : REV[word[n - 1]], last = fwd ? word[n - 1] : REV[word[0]], ml = REV[last];
    lw0.el.innerHTML = `first step w<sub>0</sub> = ${w0}`; lwl.el.innerHTML = `last step arrives: −w<sub>n−1</sub> = ${ml}`;
    lw0.pos.set(...add(V[0], U[w0], 0.75).map((v, i) => (i === 2 ? v + 0.3 : v))); lwl.pos.set(...add(V[0], U[ml], 0.75).map((v, i) => (i === 2 ? v + 0.3 : v)));
    const ok = order.indexOf(w0) < order.indexOf(ml);
    read.innerHTML = `<b>DMON3:</b> every other vertex is greater than v<sub>0</sub> = 0 in the order “first z, then y, then x”: it lies above the blue plane z = 0, or on it with y > 0, or on it with y = 0 and x > 0. <b>DMON4:</b> reading ${fwd ? 'forwards' : 'backwards'}, w<sub>0</sub> = <code>${w0}</code> and −w<sub>n−1</sub> = <code>${ml}</code>; in the order e < w < n < s < u < d, ${w0} ${ok ? '<' : '>'} ${ml}, so ${ok ? '<span class="ok">DMON4 holds</span>' : '<span class="no">DMON4 fails</span>'}. The bead shows the direction of travel.`;
    st.request();
  }
  const c = ctlRow(w); c.append(seg([['f', 'Read forwards'], ['b', 'Read backwards']], 'f', (v) => { fwd = v === 'f'; s0 = performance.now(); draw(); }), H('span', { class: 'readout grow' }, 'Drag to turn.'));
  draw();
}

// ===================================================================== Figure 11: the reach test on the real search (3D)
export function figReach(w) {
  const T = DATA.trace, V = T.verts, n = V.length;
  const [pane, side] = stage(w, 2, 'stage-side'); side.classList.add('side');
  const st = new Studio(pane, { aspect: '1 / 1', shadowDir: [0.2, -0.3, 1], label: 'The reach test on a real search state; click a site',
    onPick: (u) => { if (u.site) { sel = u.site; draw(); } } });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame(V, [1.2, -1.6, 1.1]);
  const steps = T.steps.map((s, i) => i).filter((i) => T.steps[i].pending.length);
  let si = steps.indexOf(8) >= 0 ? steps.indexOf(8) : 0, sel = null;
  const head = H('h5'), info = H('div', { class: 'readout' }), nb = H('div', { class: 'readout', style: 'margin-top:10px' });
  side.append(head, info, nb);
  const l1 = (p, q = [0, 0, 0]) => Math.abs(p[0] - q[0]) + Math.abs(p[1] - q[1]) + Math.abs(p[2] - q[2]);
  function lattPath(p, q) { const out = [p.slice()]; let c = p.slice(); for (let a = 0; a < 3; a++) { c = c.slice(); c[a] = q[a]; out.push(c); } return out; }
  function draw() {
    st.clear(grp); st.clearLabels();
    const s = T.steps[steps[si]], i = s.i, R1 = s.R1;
    const occ = V.slice(0, i + 2);
    st.rod(occ, { color: INK, radius: 0.08, parent: grp });
    occ.forEach((p) => st.ball(p, { color: INK, radius: 0.09, parent: grp }));
    st.ball(V[0], { color: INK, radius: 0.17, parent: grp }); st.label(add(V[0], [-0.35, 0, -0.45]), 'origin', 'tag');
    st.ball(s.head, { color: COL[1], radius: 0.17, parent: grp }); st.label(add(s.head, [-0.3, 0, 0.5]), 'head', 'tag strong');
    st.rod(V.slice(i + 1).concat([V[0]]), { color: '#d3d8de', radius: 0.03, parent: grp });
    const sites = [];
    s.pending.forEach((ob, k) => ob.forEach((p) => sites.push({ p, k, single: ob.length === 1 })));
    if (!sel || !sites.some((x) => key(x.p) === key(sel))) sel = sites.length ? sites[0].p : null;
    sites.forEach((x) => st.ball(x.p, { color: x.single ? COL[0] : COL[1], radius: key(x.p) === key(sel) ? 0.2 : 0.14, hollow: true, userData: { site: x.p }, pick: true, parent: grp }));
    head.textContent = `Step ${i + 1} of ${n}: ${s.pending.length} pending obligation${s.pending.length > 1 ? 's' : ''}`;
    if (sel) {
      const d1 = l1(s.head, sel), d2 = l1(sel), ok = d1 + d2 <= R1;
      const path = lattPath(s.head, sel).concat(lattPath(sel, [0, 0, 0]).slice(1));
      st.line(path, { color: ok ? GOOD : BAD, dashed: true, parent: grp });
      const set = new Set(occ.map(key)); let usable = 0;
      for (const d of Object.values(U)) {
        const q = add(sel, d), isHead = key(q) === key(s.head), isOrg = key(q) === '0,0,0', free = !set.has(key(q));
        const good = isHead || isOrg || free; if (good) usable++;
        st.ball(q, { color: good ? GOOD : BAD, radius: 0.07, parent: grp });
      }
      info.innerHTML = `Selected site s = (${sel.join(', ')}). The walk must go head → s → origin: at least |head − s|₁ + |s|₁ = ${d1} + ${d2} = <b>${d1 + d2}</b> steps; it has <b>${R1}</b> left. ${ok ? '<span class="ok">Reach passes.</span>' : '<span class="no">Reach fails.</span>'}`;
      nb.innerHTML = `Neighbours of s that are free, the head or the origin (small green balls): <b>${usable}</b> of 6. ${usable >= 2 ? '<span class="ok">Room to pass through.</span>' : '<span class="no">s could be entered but not left.</span>'} Click another ring to test it.`;
    }
    st.request();
  }
  const c = ctlRow(w);
  c.append(btn('Earlier', () => { si = Math.max(0, si - 1); draw(); }), btn('Later', () => { si = Math.min(steps.length - 1, si + 1); draw(); }),
    H('span', { class: 'readout grow', html: `The real search walking along <code>${T.word}</code>. Rings: sites of pending obligations (orange: curtain, blue: corner). Drag to turn.` }));
  draw();
}

// ===================================================================== Figure 14: the standard 5_2 as a 3D tube
export function figStd52(w) {
  const D = DATA.std52, VEC = [0, 1, 3, 4, 2], N = D.curve.length;
  // heights: the over-strand lifted, the under-strand lowered, smoothly
  const z = new Array(N).fill(0);
  for (const [u, o] of D.curveCross) for (let i = 0; i < N; i++) {
    const du = Math.min(Math.abs(i - u), N - Math.abs(i - u)), dov = Math.min(Math.abs(i - o), N - Math.abs(i - o));
    z[i] += -0.32 * Math.exp(-(du * du) / 120) + 0.32 * Math.exp(-(dov * dov) / 120);
  }
  const P = D.curve.map((p, i) => [p[0] * 1.6, p[1] * 1.6, z[i] + 1.0]);
  const arcs = arcPolylines(P, D.curveUnders, 0);
  const names = D.arcNames, nameIdx = { A: 0, B: 1, C: 2, D: 3, E: 4 };
  const [pane, side] = stage(w, 2, 'stage-side'); side.classList.add('side');
  let a = 0, b = 1;
  const st = new Studio(pane, { aspect: '1 / 1', shadowDir: [0, 0, 1], label: 'The standard diagram of 5₂ as a knot in space' });
  const tubes = arcs.map((pts, e) => st.tube(pts, { closed: false, radius: 0.1, segments: 160, userData: { arc: e } }));
  st.frame(P, [0.15, -1.25, 1.6]);
  D.edgeLabels.forEach((e) => st.label([e.p[0] * 1.6, e.p[1] * 1.6, 1.0], String(e.label), 'edge'));
  const xl = D.crossings.map((c, k) => { const lp = D.crossLabels[k]; const L = st.label([lp[0] * 1.6, lp[1] * 1.6, 1.4], `X<sub>${D.crossNames[k]}</sub>`, 'xing'); L.el.tabIndex = 0; L.el.addEventListener('pointerenter', () => focusX(k)); L.el.addEventListener('focus', () => focusX(k)); return L; });
  const codeBox = H('div', { class: 'readout' }), eqs = H('div', { class: 'readout', style: 'margin-top:10px' });
  side.append(H('h5', {}, 'The KnotInfo code'), codeBox, H('h5', { style: 'margin-top:14px' }, 'A colouring'), eqs);
  function focusX(k) {
    const X = D.pd[D.crossNames[k] - 1];
    codeBox.innerHTML = D.pd.map((X2, j) => `<div class="${j === D.crossNames[k] - 1 ? 'now' : ''}">X<sub>${j + 1}</sub>[${X2.join(', ')}]</div>`).join('') +
      `<p style="margin:.5em 0 0">At X<sub>${D.crossNames[k]}</sub> the under-strand runs from edge ${X[0]} to edge ${X[2]}; the over-strand is edges ${X[1]} and ${X[3]}.</p>`;
    xl.forEach((L, j) => L.el.classList.toggle('on', j === k));
  }
  function draw() {
    tubes.forEach((t, e) => t.material.color.set(COL[mod(a + b * VEC[nameIdx[names[e]]], 7)]));
    const v = [0, 1, 2, 3, 4].map((k) => mod(a + b * VEC[k], 7)), [A, B, C, Dd, E] = v;
    const rows = [['2B', 'E + A', 2 * B, E + A], ['2D', 'A + B', 2 * Dd, A + B], ['2E', 'B + C', 2 * E, B + C], ['2A', 'C + D', 2 * A, C + Dd], ['2C', 'D + E', 2 * C, Dd + E]];
    eqs.innerHTML = `<b>(A, B, C, D, E) = (${v.join(', ')})</b><br>` + rows.map(([l, r, x, y]) => `${l} = ${mod(x, 7)}, ${r} = ${mod(y, 7)}: ${mod(x - y, 7) === 0 ? '<span class="ok">balanced</span>' : '<span class="no">unbalanced</span>'}`).join('<br>') + `<br>${b === 0 ? 'b = 0: a constant colouring.' : 'Not constant, and every crossing balances.'}`;
    st.request();
  }
  const sa = H('input', { type: 'range', min: 0, max: 6, value: a, 'aria-label': 'a' }), sb = H('input', { type: 'range', min: 0, max: 6, value: b, 'aria-label': 'b' });
  sa.addEventListener('input', () => { a = +sa.value; draw(); }); sb.addEventListener('input', () => { b = +sb.value; draw(); });
  const c = ctlRow(w);
  c.append(H('label', { class: 'range' }, 'a', sa), H('label', { class: 'range' }, 'b', sb), H('span', { class: 'readout grow' }, 'The 49 colourings a(1,1,1,1,1) + b(0,1,3,4,2). Point at a crossing label to read its PD tuple. The floor shows the diagram.'));
  focusX(0); draw();
}

// ===================================================================== Figure 15: the worked certificate
export function figCertex(w) {
  const C = DATA.cert, ac = [COL[0], COL[1], COL[2]];
  const [p3, p2] = stage(w, 2);
  p3.append(H('span', { class: 'pane-label' }, '(a) the polygon; its shadow is the diagram'));
  p2.append(H('span', { class: 'pane-label' }, '(b) the diagram along (7, 13, 31)'));
  const st = new Studio(p3, { aspect: '1 / 1', shadowDir: C.D, label: 'The 24-step trefoil polygon' });
  const n = C.verts.length;
  for (const [i, a, c, arc] of C.pieces) { const p = C.verts[i], q = C.verts[(i + 1) % n]; st.rod([add(p, add(q, p, -1), a), add(p, add(q, p, -1), c)], { color: ac[arc], radius: 0.11 }); }
  st.ball(C.verts[0], { color: INK, radius: 0.18 });
  st.frame(C.verts, [1.1, -1.5, 1.05]);
  const D = knot2d(p2, C, { colour: (k) => ac[k], width: 0.15, gap: 0.3 });
  const anch = arcAnchors(D), arcsK = Object.keys(anch).map(Number);
  const spots = placeLabels(D, arcsK.map((k) => anch[k][1]), 0.42);
  arcsK.forEach((k, j) => pill(D.svg, spots[j], k, ac[k], 0.4));
  const ul = placeLabels(D, D.crossPts, 0.5, spots);
  const ring = S('g', {}, D.svg);
  C.crossings.forEach((c, k) => { const t = S('text', { x: ul[k][0], y: -ul[k][1] + 0.1, 'text-anchor': 'middle', 'font-size': 0.3, fill: INK }, D.svg); t.innerHTML = `u<tspan baseline-shift="sub" font-size=".21">${c.e}</tspan>`; });
  const o = D.P2[0]; S('circle', { cx: o[0], cy: -o[1], r: 0.15, fill: INK }, D.svg);
  const mats = H('div', { class: 'matrow' });
  const mat = (M, cls) => { const m = H('span', { class: 'mat ' + cls, style: `grid-template-columns:repeat(${M[0].length},auto)` }); M.forEach((r, i) => r.forEach((v) => m.append(H('span', { 'data-r': i }, v)))); return m; };
  mats.append('F =', mat(C.F, 'F'), '≡', mat(C.F.map((r) => r.map((v) => mod(v, 7))), 'Fm'), 'L =', mat(C.L, 'L'), 'LF ≡', mat(C.LF, 'LF'), '(mod 7)');
  w.querySelector('.stage').append(mats);
  const read = readout(w);
  function row(r) {
    w.querySelectorAll('.mat span').forEach((s) => s.classList.toggle('hl', (s.parentNode.classList.contains('F') || s.parentNode.classList.contains('Fm')) && +s.dataset.r === r));
    const c = C.crossings.find((cc) => cc.e === r); ring.innerHTML = '';
    const x = D.crossPts[C.crossings.indexOf(c)]; S('circle', { cx: x[0], cy: -x[1], r: 0.36, fill: 'none', stroke: COL[5], 'stroke-width': 0.08 }, ring);
    const inn = mod(r - 1, 3);
    read.innerHTML = `Row ${r + 1} of F is the crossing with under-passage u<sub>${r}</sub> (ringed): over-arc ${c.overArc}, incoming under-arc ${inn}, outgoing ${r}, so 2x<sub>${c.overArc}</sub> − x<sub>${inn}</sub> − x<sub>${r}</sub> ≡ 0. The rows of LF are e<sub>1</sub> − e<sub>0</sub> and e<sub>2</sub> − e<sub>0</sub>, so every colouring is constant.`;
  }
  w.querySelectorAll('.mat.F span, .mat.Fm span').forEach((s) => s.addEventListener('pointerenter', () => row(+s.dataset.r)));
  const c = ctlRow(w); [0, 1, 2].forEach((r) => c.append(btn(`Row ${r + 1}`, () => row(r))));
  c.append(H('span', { class: 'readout grow' }, 'Drag (a) to turn.'));
  row(0);
}

// ===================================================================== Figure 16: PD comparison
export function figPdCompare(w) {
  const B = DATA.w36, Dd = DATA.std52, PD = DATA.pd;
  const [left, right] = stage(w, 2);
  left.append(H('span', { class: 'pane-label' }, '(a) |w36| along (1, −1, 4)'));
  right.append(H('span', { class: 'pane-label' }, '(b) the KnotInfo diagram of 5₂'));
  let sw = false, sh = true, svgL = null;
  const svg2 = S('svg', { role: 'img', class: 'knot2d' }, right);
  const all = Dd.arcs.flat(), xs = all.map((p) => p[0]), ys = all.map((p) => -p[1]);
  svg2.setAttribute('viewBox', `${Math.min(...xs) - 0.5} ${Math.min(...ys) - 0.5} ${Math.max(...xs) - Math.min(...xs) + 1} ${Math.max(...ys) - Math.min(...ys) + 1}`);
  Dd.arcs.forEach((pts) => { const d = 'M' + pts.map((p) => `${p[0]},${-p[1]}`).join('L'); S('path', { d, fill: 'none', stroke: SHEET, 'stroke-width': 0.17, 'stroke-linecap': 'round' }, svg2); S('path', { d, fill: 'none', stroke: INK, 'stroke-width': 0.08, 'stroke-linecap': 'round' }, svg2); });
  Dd.edgeLabels.forEach((e) => { const t = S('text', { x: e.p[0], y: -e.p[1] + 0.06, 'text-anchor': 'middle', 'font-size': 0.17, fill: '#1f3b73', 'font-weight': 700 }, svg2); t.textContent = e.label; });
  const tbl = H('table', {}); w.querySelector('.stage').append(H('div', { class: 'tablewrap', style: 'padding:12px' }, tbl));
  const read = H('div', { class: 'readout' });
  // positions of the PD edges of w36 under pi_D: the edge with label e+1 runs from passage e to e+1
  function edgeAnchors(D) {
    const pas = B.passages.map(([i, t]) => i + t), m = pas.length, n = D.P2.length, out = [];
    for (let e = 0; e < m; e++) { let a = pas[e], b = pas[(e + 1) % m]; if (b <= a) b += n; out.push(D.at(((a + b) / 2) % n)); }
    return out;
  }
  function draw() {
    const D = knot2d(left, B, { colour: () => INK, width: 0.15, gap: 0.3, switched: sw, svg: svgL });
    svgL = D.svg;
    const anchors = edgeAnchors(D), spots = placeLabels(D, anchors, 0.5);
    spots.forEach((p, e) => { const lab = sh ? ((e + 6) % 10) + 1 : e + 1; const t = S('text', { x: p[0], y: -p[1] + 0.13, 'text-anchor': 'middle', 'font-size': 0.3, fill: '#1f3b73', 'font-weight': 700 }, D.svg); t.textContent = lab; });
    { const a0 = D.P2[0], a1 = D.at(0.55); S('path', { d: `M${a0[0]},${-a0[1]}L${a1[0]},${-a1[1]}`, stroke: COL[1], 'stroke-width': 0.09, 'marker-end': 'url(#pdarrow)', fill: 'none' }, D.svg);
      D.svg.insertAdjacentHTML('afterbegin', `<defs><marker id="pdarrow" viewBox="0 0 10 10" refX="6" refY="5" markerWidth="4" markerHeight="4" orient="auto"><path d="M0,0L10,5L0,10z" fill="${COL[1]}"/></marker></defs>`); }
    D.crossPts.forEach((x) => S('circle', { cx: x[0], cy: -x[1], r: 0.08, fill: '#8a1c1c' }, D.svg));
    const o = D.P2[0]; S('circle', { cx: o[0], cy: -o[1], r: 0.14, fill: INK }, D.svg);
    const cur = sw ? (sh ? PD.shifted : PD.switched) : (sh ? PD.w36.map((X) => X.map((x) => (x + 5) % 10 + 1)) : PD.w36);
    const stdS = PD.std.map((X) => X.join(','));
    tbl.innerHTML = '<thead><tr><th>code of w36</th><th>now</th><th>KnotInfo</th></tr></thead>';
    const tb = H('tbody'); tbl.append(tb);
    cur.forEach((X, k) => { const j = stdS.indexOf(X.join(',')); tb.append(H('tr', {}, H('td', {}, `[${PD.w36[k].join(', ')}]`), H('td', { style: j >= 0 ? 'font-weight:700' : '' }, `[${X.join(', ')}]`), H('td', { html: j >= 0 ? `<span class="ok">= X<sub>${j + 1}</sub></span>` : `<span style="color:${INK2}">no match</span>` }))); });
    read.innerHTML = sw && sh ? '<span class="ok">Every crossing matches the KnotInfo code.</span> The diagram of w<sub>36</sub> is the KnotInfo diagram with every crossing switched: a diagram of the mirror image of 5<sub>2</sub>.'
      : 'The labels are increased by 6 (mod 10), as in the caption. Now switch all crossings: each row then becomes a crossing of the KnotInfo code. The orange arrow leaves v<sub>0</sub> in the direction of travel.';
  }
  const ctl = ctlRow(w);
  const b1 = btn('Switch all crossings', () => { sw = !sw; b1.setAttribute('aria-pressed', String(sw)); draw(); }, { 'aria-pressed': 'false' });
  const b2 = btn('Add 6 to every label', () => { sh = !sh; b2.setAttribute('aria-pressed', String(sh)); draw(); }, { 'aria-pressed': 'true' });
  ctl.append(b1, b2); w.append(read); draw();
}

// ===================================================================== New: the proof of Theorem 2.4, unfolding (3D)
export function figDeltaProof(w) {
  const a = [0, 0, 0], b = [3, 0, 0], c = [1.1, 1.8, 0], m = [1.5, 0, 0];
  const del = 0.22, eta = 0.5, cp = add(m, add(c, m, -1), 1 + del), d = add(m, add(c, m, -1), -del);
  const q = add(m, add(c, m, -1), 0.5), ep = add(q, [0, 0, eta]), em = add(q, [0, 0, -eta]);
  const [pane, side] = stage(w, 2, 'stage-side'); side.classList.add('side');
  const st = new Studio(pane, { aspect: '1 / 1', shadowDir: [0.25, -0.35, 1], label: 'The proof of Theorem 2.4, step by step' });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame([[-0.4, -0.6, -0.6], [3.4, 2.2, 0.6]], [0.35, -1.1, 1.35]);
  let stepI = 0, kk = 0;
  const STEPS = [
    ['The move', 'The edge [a, b] of the knot K and the triangle abc. The triangle meets K only in [a, b]; the other strands of K (grey) pass beside it.'],
    ['The quadrilateral Q', 'Push c a little further to c⁺ and add d a little below [a, b]. The quadrilateral Q = adbc⁺ is convex: its diagonals [a, b] and [d, c⁺] cross at m.'],
    ['The ball B', 'Add e₊ and e₋ just above and below the middle of Q. The bipyramid B = conv(Q ∪ {e₊, e₋}) is a convex ball. For δ, η small it meets K only in [a, b]: the angle estimate keeps the edges at a and b outside, and the rest of K is at distance ρ > 0.'],
    ['The map f', 'Cut Q into the four triangles adm, dbm, bc⁺m, c⁺am. Move m to c and stretch each triangle affinely (slider). The boundary of Q does not move, and [a, m] ∪ [m, b] becomes [a, c] ∪ [c, b].'],
    ['Coning', 'Extend f over B by coning from e₊ and e₋: points of ∂B do not move. Outside B nothing moves. This homeomorphism of ℝ³ carries K to K′: the Δ-move is an isotopy.'],
  ];
  const head = H('h5'), text = H('div', { class: 'readout' });
  side.append(head, text);
  const others = [[[-1.4, -1.0, 0.6], [-0.6, -0.5, 0.3], a], [b, [3.6, -0.5, -0.4], [4.4, -0.9, -0.9]], [[0.4, 2.6, 1.2], [1.6, 2.4, 1.4], [2.6, 2.2, 1.1]]];
  function draw() {
    st.clear(grp); st.clearLabels();
    const mt = m.map((x, i) => x + (stepI >= 3 ? kk : 0) * (c[i] - x));
    others.forEach((pts) => st.tube(pts, { closed: false, radius: 0.07, color: '#9aa3ad', segments: 30, parent: grp }));
    st.sheet([a, b, c], { color: COL[0], opacity: stepI === 0 ? 0.2 : 0.08, parent: grp });
    if (stepI >= 1) {
      st.line([a, d, b, cp, a], { color: COL[2], parent: grp }); st.line([a, b], { color: COL[2], dashed: true, opacity: 0.6, parent: grp }); st.line([d, cp], { color: COL[2], dashed: true, opacity: 0.6, parent: grp });
      st.ball(d, { color: COL[2], radius: 0.07, parent: grp }); st.ball(cp, { color: COL[2], radius: 0.07, parent: grp });
      st.label(add(d, [0, -0.3, 0]), 'd', 'tag'); st.label(add(cp, [0.2, 0.25, 0]), 'c⁺', 'tag');
    }
    if (stepI >= 2) {
      const B = [a, d, b, cp];
      for (let i = 0; i < 4; i++) { st.sheet([ep, B[i], B[(i + 1) % 4]], { color: COL[3], opacity: 0.1, parent: grp }); st.sheet([em, B[i], B[(i + 1) % 4]], { color: COL[3], opacity: 0.06, parent: grp }); st.line([ep, B[i]], { color: COL[3], opacity: 0.5, parent: grp }); st.line([em, B[i]], { color: COL[3], opacity: 0.35, parent: grp }); }
      st.ball(ep, { color: COL[3], radius: 0.07, parent: grp }); st.ball(em, { color: COL[3], radius: 0.07, parent: grp });
      st.label(add(ep, [0.32, -0.1, 0.12]), 'e₊', 'tag'); st.label(add(em, [0.32, -0.1, -0.12]), 'e₋', 'tag');
    }
    if (stepI >= 3) {
      const T = [[a, d], [d, b], [b, cp], [cp, a]];
      T.forEach(([p, r], i) => st.sheet([p, r, mt], { color: [COL[0], COL[5], COL[2], COL[4]][i], opacity: 0.22, parent: grp }));
      st.ball(mt, { color: COL[1], radius: 0.09, parent: grp }); st.label(add(mt, [0.25, -0.25, 0]), kk < 0.98 ? 'f(m)' : 'f(m) = c', 'tag');
    }
    const path = stepI >= 3 ? [a, mt, b] : [a, b];
    st.rod(path, { color: INK, radius: 0.09, parent: grp });
    if (stepI < 3 || kk < 0.98) { st.ball(c, { color: '#fff', radius: 0.1, parent: grp }); }
    [['a', a, [-0.3, -0.25, 0]], ['b', b, [0.3, -0.25, 0]], ['c', c, [-0.2, 0.3, 0]]].forEach(([s, p, o]) => st.label(add(p, o), s, 'tag strong'));
    if (stepI >= 1 && stepI < 3) st.label(add(m, [0, -0.3, 0]), 'm', 'tag');
    head.textContent = `Step ${stepI + 1} of ${STEPS.length}: ${STEPS[stepI][0]}`;
    text.textContent = STEPS[stepI][1];
    back.disabled = stepI === 0; next.disabled = stepI === STEPS.length - 1;
    slider.disabled = stepI < 3; st.request();
  }
  const slider = H('input', { type: 'range', min: 0, max: 100, value: 0, 'aria-label': 'move m to c' });
  slider.addEventListener('input', () => { kk = slider.value / 100; draw(); });
  const back = btn('Back', () => { stepI--; draw(); });
  const next = btn('Next', () => { stepI++; if (stepI === 3) { st.tween(1400, (k) => { kk = k; slider.value = k * 100; draw(); }); } if (stepI === 4) { kk = 1; slider.value = 100; } draw(); });
  const c2 = ctlRow(w); c2.append(back, next, H('label', { class: 'range' }, 'Move m to c', slider), H('span', { class: 'readout grow' }, 'Drag to turn.'));
  draw();
}

// ===================================================================== New: Lemma 4.3, the obligation invariant (stepper)
export function figInvariant(w) {
  const T = DATA.trace, V = T.verts, n = V.length, word = T.word;
  // follow each obligation through the trace: its creation step, the step that removes it, and its witness v_m
  const obs = []; let active = [];
  T.steps.forEach((s, i) => {
    const keys = s.pending.map((ob) => ob.map(key).sort().join('|'));
    const left = active.slice(), now = [];
    keys.forEach((k, j) => {
      const at = left.findIndex((o) => o.k === k);
      if (at >= 0) { now.push(left[at]); left.splice(at, 1); }
      else { const o = { k, sites: s.pending[j], c: i, end: null, kind: s.pending[j].length === 1 ? 'one' : 'many' }; obs.push(o); now.push(o); }
    });
    left.forEach((o) => { o.end = i; }); active = now;
  });
  active.forEach((o) => { o.end = n; });
  const vIndex = new Map(V.map((v, m) => [key(v), m]));
  obs.forEach((o, j) => {
    o.m = Math.min(...o.sites.map((p) => vIndex.get(key(p))).filter((m) => m != null && m >= o.c + 2));
    o.col = [COL[1], COL[0], COL[2], COL[3], COL[4], COL[5]][j % 6];
  });
  const [pane, side] = stage(w, 2, 'stage-side'); side.classList.add('side');
  const st = new Studio(pane, { aspect: '1 / 1', shadowDir: [0.2, -0.3, 1], label: 'The walk along w and its pending obligations' });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame(V, [1.2, -1.6, 1.1]);
  const head = H('h5'), info = H('div', { class: 'readout' });
  const tl = S('svg', { class: 'timeline', role: 'img', 'aria-label': 'Timeline of the obligations: each bar runs from the step that creates an obligation to the step that removes it' });
  side.append(head, info, H('h5', { style: 'margin-top:14px' }, 'Timeline'), tl, hint('Each bar is one obligation, from the step that creates it to the step that removes it. The dot on the bar is its witness: the later vertex v_m of w that is one of its sites. The lemma says every dot lies on or right of the dashed line i + 2.'));
  let i = 8;
  const W = 300, rowH = 13, X = (s) => 24 + (s / n) * (W - 34);
  function draw() {
    st.clear(grp); st.clearLabels();
    const s = T.steps[i];
    st.rod(V.slice(0, i + 2), { color: INK, radius: 0.08, parent: grp });
    st.rod([...V.slice(i + 1), V[0]], { color: '#c3c9d0', radius: 0.035, parent: grp });
    st.ball(V[0], { color: INK, radius: 0.16, parent: grp }); st.label(add(V[0], [0, 0, -0.42]), 'v<sub>0</sub>', 'tag');
    st.ball(V[i + 1], { color: COL[1], radius: 0.16, parent: grp }); st.label(add(V[i + 1], [0, 0, 0.42]), `head v<sub>${i + 1}</sub>`, 'tag strong');
    const pend = obs.filter((o) => o.c <= i && o.end > i);
    pend.forEach((o) => {
      o.sites.forEach((p) => st.ball(p, { color: o.col, radius: vIndex.get(key(p)) === o.m ? 0.2 : 0.14, hollow: true, parent: grp }));
      st.label(add(V[o.m], [0.22, -0.22, 0.3]), `v<sub>${o.m}</sub>`, 'tag');
    });
    head.textContent = `After step ${i} (letter ${word[i]}): ${pend.length} pending`;
    const ev = (s.events || []).map((e) => e.kind + (e.result === 'new' ? ' obligation created' : e.result === 'sat' || e.result === 'satisfied' ? ' already satisfied' : ' ' + e.result)).join('; ');
    info.innerHTML = (pend.length ? pend.map((o) => `<span class="chip" style="background:${o.col}"></span>${o.kind === 'one' ? 'corner' : 'curtain'}, sites ${o.sites.map((p) => `(${p.join(',')})`).join(' ')}: witness v<sub>${o.m}</sub>, and ${o.m} ≥ ${i} + 2 <span class="ok">✓</span>`).join('<br>') : 'No pending obligation.') +
      (ev ? `<br><span style="color:${INK2}">This step: ${ev}.</span>` : '');
    // timeline
    tl.innerHTML = ''; const rows = obs.length, Ht = 30 + rows * rowH;
    tl.setAttribute('viewBox', `0 0 ${W} ${Ht}`);
    for (let k = 0; k <= n; k += 4) { S('line', { x1: X(k), y1: 14, x2: X(k), y2: Ht, stroke: 'rgba(20,23,27,.1)' }, tl); const t = S('text', { x: X(k), y: 10, 'text-anchor': 'middle', 'font-size': 8, fill: INK2 }, tl); t.textContent = k; }
    S('rect', { x: X(i) - 0.5, y: 14, width: 1.5, height: Ht - 14, fill: INK }, tl);
    S('line', { x1: X(i + 2), y1: 14, x2: X(i + 2), y2: Ht, stroke: GOOD, 'stroke-dasharray': '3 2' }, tl);
    obs.forEach((o, r) => {
      const y = 24 + r * rowH, on = o.c <= i && o.end > i;
      S('rect', { x: X(o.c), y: y - 3, width: Math.max(2, X(Math.min(o.end, n)) - X(o.c)), height: 6, fill: o.col, opacity: on ? 1 : 0.25 }, tl);
      S('circle', { cx: X(o.m), cy: y, r: 3.6, fill: '#fff', stroke: o.col, 'stroke-width': 1.6, opacity: on ? 1 : 0.35 }, tl);
    });
    back.disabled = i === 0; next.disabled = i === n - 1; st.request();
  }
  const back = btn('← Earlier step', () => { i--; draw(); }), next = btn('Later step →', () => { i++; draw(); });
  w.tabIndex = 0; w.classList.add('keys');
  w.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowRight' && i < n - 1) { i++; draw(); e.preventDefault(); }
    if (e.key === 'ArrowLeft' && i > 0) { i--; draw(); e.preventDefault(); }
  });
  const c = ctlRow(w); c.append(back, next, H('span', { class: 'readout grow', html: `The search along the 24-step trefoil <code>${word}</code>. Use the arrow keys or the buttons. Drag to turn.` }));
  draw();
}

// ===================================================================== New: Theorem 5.1, reflections of the heptagon
export function figD7(w) {
  const [pane, side] = stage(w, 2, 'stage-side'); side.classList.add('side');
  const svg = S('svg', { viewBox: '-1.55 -1.45 3.1 2.95', role: 'img', class: 'hepta', 'aria-label': 'The heptagon with corners 0 to 6 and the mirror lines of reflections' }, pane);
  const ang = (t) => Math.PI / 2 - (t * 2 * Math.PI) / 7, pt = (t, r = 1) => [r * Math.cos(ang(t)), -r * Math.sin(ang(t))];
  let b = 1, a = 3, tt = 0, phase = 0;   // over-colour b, in-colour a, test corner t; phase = how many reflections shown
  const head = H('h5'), info = H('div', { class: 'readout' });
  side.append(head, info);
  const axis = (c, col, wdt, dash) => { const p = pt(c, 1.32), q = pt(c + 3.5, 1.32); S('line', { x1: p[0], y1: p[1], x2: q[0], y2: q[1], stroke: col, 'stroke-width': wdt, 'stroke-dasharray': dash || null, 'stroke-linecap': 'round' }, svg); };
  function arrow(from, to, col, k) {
    const p = pt(from, 0.86), q = pt(to, 0.86);
    if (from === to) { S('circle', { cx: p[0] * 1.17, cy: p[1] * 1.17, r: 0.1, fill: 'none', stroke: col, 'stroke-width': 0.03 }, svg); return; }
    const mx = (p[0] + q[0]) / 2 * 0.55, my = (p[1] + q[1]) / 2 * 0.55;
    const path = S('path', { d: `M${p[0]},${p[1]}Q${mx},${my} ${q[0]},${q[1]}`, fill: 'none', stroke: col, 'stroke-width': 0.035, 'marker-end': `url(#ah${k})` }, svg);
    return path;
  }
  function draw() {
    svg.innerHTML = '<defs>' + [COL[1], COL[0], COL[1], GOOD].map((c, k) => `<marker id="ah${k}" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="5" markerHeight="5" orient="auto-start-reverse"><path d="M0,0L10,5L0,10z" fill="${c}"/></marker>`).join('') + '</defs>';
    const P = [0, 1, 2, 3, 4, 5, 6].map((t) => pt(t));
    S('path', { d: 'M' + P.map((p) => p.join(',')).join('L') + 'Z', fill: 'rgba(0,114,178,.05)', stroke: INK, 'stroke-width': 0.025 }, svg);
    const out = mod(2 * b - a, 7);
    axis(a, COL[0], 0.03); axis(b, COL[1], 0.045);
    if (phase >= 4) axis(out, GOOD, 0.04, '0.08 0.05');
    const seq = [tt, mod(2 * b - tt, 7)]; seq.push(mod(2 * a - seq[1], 7)); seq.push(mod(2 * b - seq[2], 7));
    const cols = [COL[1], COL[0], COL[1]];
    for (let k = 0; k < Math.min(phase, 3); k++) arrow(seq[k], seq[k + 1], cols[k], k);
    if (phase >= 4) arrow(tt, out === tt ? tt : mod(2 * out - tt, 7), GOOD, 3);
    P.forEach((p, t) => {
      const g = S('g', { class: 'hit', tabindex: 0, role: 'button', 'aria-label': `test corner ${t}` }, svg);
      const isT = t === tt;
      S('circle', { cx: p[0], cy: p[1], r: 0.13, fill: isT ? INK : '#fff', stroke: INK, 'stroke-width': 0.025 }, g);
      const tx = S('text', { x: p[0], y: p[1] + 0.055, 'text-anchor': 'middle', 'font-size': 0.15, 'font-weight': 700, fill: isT ? '#fff' : INK }, g); tx.textContent = t;
      const pick = () => { tt = t; phase = 0; draw(); };
      g.addEventListener('click', pick); g.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); pick(); } });
    });
    const lab = (c, txt, col) => { const p = pt(c + 3.5, 1.42); const t = S('text', { x: p[0], y: p[1] + 0.05, 'text-anchor': 'middle', 'font-size': 0.13, 'font-weight': 700, fill: col }, svg); t.textContent = txt; };
    lab(a, `r${sub(a)}`, COL[0]); lab(b, `r${sub(b)}`, COL[1]); if (phase >= 4 && out !== a && out !== b) lab(out, `r${sub(out)}`, GOOD);
    head.textContent = `Over-arc colour b = ${b}, incoming colour a = ${a}`;
    const s1 = seq[1], s2 = seq[2], s3 = seq[3];
    const lines = [
      `Click a corner to choose t, then press <b>Next reflection</b>.`,
      `r<sub>b</sub>(t) = 2·${b} − ${tt} ≡ <b>${s1}</b> (orange mirror).`,
      `r<sub>a</sub>(${s1}) = 2·${a} − ${s1} ≡ <b>${s2}</b> (blue mirror).`,
      `r<sub>b</sub>(${s2}) = 2·${b} − ${s2} ≡ <b>${s3}</b>. So r<sub>b</sub>r<sub>a</sub>r<sub>b</sub> sends ${tt} to ${s3}.`,
      `One reflection does the same: r<sub>2b−a</sub> = r<sub>${out}</sub> sends ${tt} to 2·${out} − ${tt} ≡ <b>${mod(2 * out - tt, 7)}</b> (green). Its mirror is the blue mirror reflected in the orange one.`];
    info.innerHTML = lines.slice(0, phase + 1).join('<br>') + (phase >= 4 ? `<br><br>At a crossing with over-colour ${b} and incoming colour ${a}, the Wirtinger relation needs the outgoing reflection r<sub>${out}</sub>: outgoing colour ${out}, and 2·${b} ≡ ${a} + ${out} (mod 7) <span class="ok">is the Fox rule</span>.` : '');
    nxt.disabled = phase >= 4;
  }
  const sub = (k) => '₀₁₂₃₄₅₆'[k];
  const nxt = btn('Next reflection', () => { phase++; draw(); });
  const sb = H('input', { type: 'range', min: 0, max: 6, value: b, 'aria-label': 'over-arc colour b' }), sa = H('input', { type: 'range', min: 0, max: 6, value: a, 'aria-label': 'incoming colour a' });
  sb.addEventListener('input', () => { b = +sb.value; phase = 0; draw(); }); sa.addEventListener('input', () => { a = +sa.value; phase = 0; draw(); });
  const c = ctlRow(w); c.append(H('label', { class: 'range' }, 'over b', sb), H('label', { class: 'range' }, 'in a', sa), nxt, btn('Start again', () => { phase = 0; draw(); }));
  draw();
}

// ===================================================================== Figure 2: the Delta-move (3D)
export function figDelta(w) {
  const a = [0, 0, 0], b = [3, 0, 0], m = [1.5, 0, 0];
  const strandX = 2.0, strandY = 1.15;               // the other strand: a vertical line through (2, 1.15)
  const [pane] = stage(w, 1);
  const st = new Studio(pane, { aspect: '16 / 9', shadowDir: [0.25, -0.35, 1], label: 'A Delta-move in 3D' });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame([[-0.8, -0.4, -0.9], [3.8, 2.4, 0.9]], [0.35, -1.25, 1.2]);
  let push = 0.55, slide = 0, through = false;
  const read = readout(w);
  const cOf = () => [1.3 + 0.4 * push, 0.5 + 1.9 * push, 0];
  function pierced(c) {   // does the vertical line x = strandX, y = strandY meet the triangle abc (in the plane z = 0)?
    const P = [strandX, strandY], T = [a, b, c].map((p) => [p[0], p[1]]);
    const sgn = (p, q, r) => (q[0] - p[0]) * (r[1] - p[1]) - (q[1] - p[1]) * (r[0] - p[0]);
    const d1 = sgn(T[0], T[1], P), d2 = sgn(T[1], T[2], P), d3 = sgn(T[2], T[0], P);
    return !((d1 < 0 || d2 < 0 || d3 < 0) && (d1 > 0 || d2 > 0 || d3 > 0));
  }
  function draw() {
    st.clear(grp); st.clearLabels();
    const c = cOf(), bad = pierced(c), p = m.map((x, i) => x + slide * (c[i] - x));
    st.sheet([a, b, c], { color: bad ? BAD : COL[0], opacity: 0.2, parent: grp });
    st.line([a, c, b], { color: bad ? BAD : COL[0], dashed: true, parent: grp });
    st.tube([[-1.2, -0.5, 0.4], [-0.6, -0.2, 0.15], a], { closed: false, radius: 0.08, segments: 20, parent: grp });
    st.tube([b, [3.7, 0.4, -0.3], [4.2, 1.1, -0.7]], { closed: false, radius: 0.08, segments: 20, parent: grp });
    st.rod([a, p, b], { color: INK, radius: 0.08, parent: grp });
    st.rod([[strandX, strandY, -1.2], [strandX, strandY, 1.2]], { color: '#8a929c', radius: 0.07, parent: grp });
    st.ball([strandX, strandY, 0], { color: bad ? BAD : '#8a929c', radius: 0.09, parent: grp });
    st.ball(c, { color: '#fff', radius: 0.09, parent: grp });
    [['a', a, [-0.25, -0.3, 0]], ['b', b, [0.25, -0.3, 0]], ['c', c, [0, 0.3, 0.15]]].forEach(([s, q, o]) => st.label(add(q, o), s, 'tag strong'));
    st.label([strandX + 0.2, strandY, 1.15], 'another strand', 'tag');
    read.innerHTML = bad
      ? '<span class="no">Not a Δ-move.</span> The other strand pierces the triangle (red dot). Sliding the edge across the triangle would drag it through that strand, which can change the knot type.'
      : (slide < 1 ? '<span class="ok">A Δ-move.</span> The triangle abc meets the knot only in the edge [a, b]; the other strand passes beside it. Slide the edge across the triangle.'
        : '<span class="ok">Done:</span> [a, b] is replaced by [a, c] ∪ [c, b]. Nothing was cut or passed through.');
    st.request();
  }
  const s1 = H('input', { type: 'range', min: 0, max: 100, value: push * 100, 'aria-label': 'move c' });
  const s2 = H('input', { type: 'range', min: 0, max: 100, value: 0, 'aria-label': 'slide the edge' });
  s1.addEventListener('input', () => { push = s1.value / 100; draw(); });
  s2.addEventListener('input', () => { slide = s2.value / 100; draw(); });
  const c2 = ctlRow(w);
  c2.append(H('label', { class: 'range' }, 'Move c', s1), H('label', { class: 'range' }, 'Slide the edge', s2),
    btn('Play the move', () => st.tween(1200, (k) => { slide = k; s2.value = k * 100; draw(); })),
    H('span', { class: 'readout grow' }, 'Move c until the triangle reaches the other strand. Drag to turn.'));
  draw();
}

// ===================================================================== Figure 5: a flip and a U-turn as two Delta-moves (3D)
export function figFlipDelta(w) {
  const [pane, side] = stage(w, 2, 'stage-side'); side.classList.add('side');
  const st = new Studio(pane, { aspect: '1 / 1', shadowDir: [0.25, -0.35, 1], label: 'A corner flip and a U-turn removal as two Delta-moves' });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame([[-0.6, -0.6, -0.8], [1.6, 1.0, 1.8]], [0.9, -1.6, 0.8]);
  let mode = 'flip', t = 0, k = 1;          // t = number of Delta-moves done (0, 1, 2); k = progress of the current one
  const head = H('h5'), info = H('div', { class: 'readout' }); side.append(head, info);
  // flip: v_{i-1} = (0,0,0), v_i = (0,0,1), v_{i+1} = (1,0,1), v' = (1,0,0); outer edges leave the square in other directions
  const F = { A: [0, 0, 0], V: [0, 0, 1], B: [1, 0, 1], P: [1, 0, 0], inA: [0, -0.8, -0.5], outB: [1, 0.9, 1.4] };
  // U-turn: v_i = (0,0,0), v_{i+1} = (0,0,1), v_{i+2} = (1,0,1), v_{i+3} = (1,0,0)
  const Ut = { A: [0, 0, 0], V: [0, 0, 1], B: [1, 0, 1], P: [1, 0, 0], inA: [-0.7, -0.6, -0.4], outB: [1.6, 0.7, -0.5] };
  const lerp = (p, q, s) => p.map((x, i) => x + s * (q[i] - x));
  function draw() {
    st.clear(grp); st.clearLabels();
    const G = mode === 'flip' ? F : Ut;
    const tri1 = [G.A, G.V, G.B], tri2 = mode === 'flip' ? [G.A, G.P, G.B] : [G.A, G.B, G.P];
    st.sheet(tri1, { color: COL[0], opacity: t === 0 || (t === 1 && k < 1) ? 0.24 : 0.08, parent: grp });
    st.sheet(tri2, { color: COL[2], opacity: t >= 1 ? 0.24 : 0.08, parent: grp });
    let path;
    if (mode === 'flip') {
      const mid = lerp(G.V, [0.5, 0, 0.5], t === 0 ? 0 : t === 1 ? k : 1);       // move 1: v_i slides to the diagonal
      const mid2 = lerp([0.5, 0, 0.5], G.P, t === 2 ? k : 0);                   // move 2: the diagonal bends to v'
      path = t < 2 ? [G.inA, G.A, mid, G.B, G.outB] : [G.inA, G.A, mid2, G.B, G.outB];
    } else {
      // move 1: v_{i+1} slides onto the diagonal [v_i, v_{i+2}]; move 2: the diagonal and the last side collapse onto [v_i, v_{i+3}]
      const mid = lerp(G.V, [0.5, 0, 0.5], t === 0 ? 0 : t === 1 ? k : 1);
      const end = lerp(G.B, [1, 0, 0.0001], t === 2 ? k : 0);
      path = t < 2 ? [G.inA, G.A, mid, G.B, G.P, G.outB] : [G.inA, G.A, lerp(mid, [0.5, 0, 0], k), end, G.P, G.outB];
    }
    st.rod(path, { color: INK, radius: 0.06, parent: grp });
    const names = mode === 'flip' ? [['v<sub>i−1</sub>', G.A], ['v<sub>i</sub>', G.V], ['v<sub>i+1</sub>', G.B], ['v′', G.P]] : [['v<sub>i</sub>', G.A], ['v<sub>i+1</sub>', G.V], ['v<sub>i+2</sub>', G.B], ['v<sub>i+3</sub>', G.P]];
    names.forEach(([s, p], j) => {
      const isVertex = mode === 'uturn' ? (t < 2 || j === 0 || j === 3) : (j !== 3 || t === 2) && (j !== 1 || t === 0);
      st.ball(p, { color: INK, radius: 0.09, hollow: !isVertex, parent: grp });
      st.label(add(p, [p[0] < 0.5 ? -0.3 : 0.3, -0.1, p[2] > 0.5 ? 0.22 : -0.22]), s, 'tag');
    });
    const T = mode === 'flip'
      ? ['The corner at v<sub>i</sub>. The fourth corner v′ of the unit square Q is not a vertex, so (Lemma 3.1) every other edge meets Q at most in v<sub>i−1</sub> or v<sub>i+1</sub>; here they leave the square in other directions.',
        'First Δ-move: the blue triangle v<sub>i−1</sub>v<sub>i</sub>v<sub>i+1</sub> meets the knot only in the two edges at v<sub>i</sub>. They are replaced by the diagonal [v<sub>i−1</sub>, v<sub>i+1</sub>].',
        'Second Δ-move: the green triangle v<sub>i−1</sub>v′v<sub>i+1</sub> meets the knot only in the diagonal. It is replaced by [v<sub>i−1</sub>, v′] ∪ [v′, v<sub>i+1</sub>]. The corner has flipped, and the knot type is the same (Theorem 2.4).']
      : ['A U-turn a, b, −a: the square v<sub>i</sub>v<sub>i+1</sub>v<sub>i+2</sub>v<sub>i+3</sub> has three sides that are edges. Every other edge meets it at most in v<sub>i</sub> or v<sub>i+3</sub>.',
        'First Δ-move: the blue triangle v<sub>i</sub>v<sub>i+1</sub>v<sub>i+2</sub> turns the two edges at v<sub>i+1</sub> into the diagonal [v<sub>i</sub>, v<sub>i+2</sub>].',
        'Second Δ-move: the green triangle v<sub>i</sub>v<sub>i+2</sub>v<sub>i+3</sub> turns the diagonal and [v<sub>i+2</sub>, v<sub>i+3</sub>] into the single edge [v<sub>i</sub>, v<sub>i+3</sub>]. The polygon is two steps shorter and has the same knot type.'];
    head.textContent = `${mode === 'flip' ? 'Corner flip' : 'U-turn removal'}: step ${t + 1} of 3`;
    info.innerHTML = T[t]; back.disabled = t === 0; next.disabled = t === 2; st.request();
  }
  const back = btn('Back', () => { t--; k = 1; draw(); });
  const next = btn('Next Δ-move', () => { t++; st.tween(900, (x) => { k = x; draw(); }); });
  const c = ctlRow(w);
  c.append(seg([['flip', 'Corner flip'], ['uturn', 'U-turn removal']], 'flip', (v) => { mode = v; t = 0; k = 1; draw(); }), back, next, H('span', { class: 'readout grow' }, 'Drag to turn: the other edges may point in any direction out of the square.'));
  draw();
}

// ===================================================================== Figure 10: obligations on the real search (3D)
export function figObligation(w) {
  const T = DATA.trace, V = T.verts, n = V.length, word = T.word;
  const evSteps = T.steps.map((s, i) => i).filter((i) => (T.steps[i].events || []).length);
  const [pane, side] = stage(w, 2, 'stage-side'); side.classList.add('side');
  const st = new Studio(pane, { aspect: '1 / 1', shadowDir: [0.2, -0.3, 1], label: 'An obligation created by the real search' });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame(V, [1.2, -1.6, 1.0]);
  let ei = evSteps.indexOf(6) >= 0 ? evSteps.indexOf(6) : 0;
  const head = H('h5'), info = H('div', { class: 'readout' }); side.append(head, info);
  function draw() {
    st.clear(grp); st.clearLabels();
    const i = evSteps[ei], s = T.steps[i];
    st.rod(V.slice(0, i + 2), { color: INK, radius: 0.08, parent: grp });
    st.line([...V.slice(i + 1), V[0]], { color: INK2, dashed: true, opacity: 0.7, parent: grp });
    st.ball(V[0], { color: INK, radius: 0.15, parent: grp }); st.label(add(V[0], [-0.3, 0, -0.42]), 'origin', 'tag');
    st.ball(V[i + 1], { color: COL[1], radius: 0.16, parent: grp }); st.label(add(V[i + 1], [-0.3, 0, 0.45]), 'head', 'tag strong');
    const lines = [];
    for (const e of s.events) {
      if (e.kind === 'curtain') {
        const j = e.j, a = U[word[j]];
        for (let q = j + 1; q < i; q++) st.sheet([V[q], V[q + 1], add(V[q + 1], a, -1), add(V[q], a, -1)], { color: COL[1], opacity: 0.16, parent: grp });
        st.rod([V[j], V[j + 1]], { color: COL[1], radius: 0.1, parent: grp }); st.rod([V[i], V[i + 1]], { color: COL[1], radius: 0.1, parent: grp });
        st.label(add(V[j], add(V[j + 1], V[j], -1), 0.5).map((x, t) => x + [0.25, -0.2, 0][t]), 'a', 'tag strong');
        st.label(add(V[i], add(V[i + 1], V[i], -1), 0.5).map((x, t) => x + [0.25, -0.2, 0][t]), '−a', 'tag strong');
        e.sites.forEach((p) => st.ball(p, { color: COL[1], radius: 0.16, hollow: true, parent: grp }));
        lines.push(`<b>Curtain</b> from step ${j} (letter <code>${word[j]}</code>) to step ${i} (letter <code>${word[i]}</code>), k = ${e.k}. Interior points ${e.sites.map((p) => `(${p.join(',')})`).join(', ')}: ` +
          (e.result === 'new' ? 'none is a vertex yet, so they become <b>one obligation</b> (orange rings): the rest of the walk (dashed) must visit one of them.' : '<span class="ok">one is already a vertex</span>, so DMON6 holds and nothing is recorded.'));
      } else {
        st.ball(e.site, { color: COL[0], radius: 0.16, hollow: true, parent: grp });
        lines.push(`<b>Corner</b> (DMON7) at v<sub>${i}</sub>: the point (${e.site.join(',')}) ` + (e.result === 'new' ? 'is not a vertex yet: <b>an obligation with one site</b> (blue ring).' : '<span class="ok">is already a vertex</span>.'));
      }
    }
    head.textContent = `Step ${i} (letter ${word[i]}): ${s.events.length} event${s.events.length > 1 ? 's' : ''}`;
    info.innerHTML = lines.join('<br><br>') + `<br><br>Pending after this step: <b>${s.pending.length}</b>.`;
    back.disabled = ei === 0; next.disabled = ei === evSteps.length - 1; st.request();
  }
  const back = btn('Previous event', () => { ei--; draw(); }), next = btn('Next event', () => { ei++; draw(); });
  const c = ctlRow(w); c.append(back, next, H('span', { class: 'readout grow', html: `The real search along <code>${word}</code>, at each step that closes a curtain or makes a DMON7 corner. Drag to turn.` }));
  draw();
}

// ===================================================================== Figure 12: the span test on the real search (3D + per axis)
export function figSpan(w) {
  const T = DATA.trace, V = T.verts, n = V.length;
  const steps = T.steps.map((s, i) => i).filter((i) => T.steps[i].pending.length >= 2);
  const [pane, side] = stage(w, 2, 'stage-side'); side.classList.add('side');
  const st = new Studio(pane, { aspect: '1 / 1', shadowDir: [0.2, -0.3, 1], label: 'The span test: the box the rest of the walk must cover' });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame(V, [1.2, -1.6, 1.0]);
  let si = steps.indexOf(8) >= 0 ? steps.indexOf(8) : 0;
  const head = H('h5'), tbl = H('table', { class: 'spantbl' }), info = H('div', { class: 'readout' });
  side.append(head, tbl, info);
  const AXN = ['x', 'y', 'z'], AXC = [COL[1], COL[2], COL[0]];
  function draw() {
    st.clear(grp); st.clearLabels();
    const i = steps[si], s = T.steps[i], c = s.head;
    const S = s.pending.filter((o) => o.length === 1).map((o) => o[0]);
    st.rod(V.slice(0, i + 2), { color: INK, radius: 0.07, parent: grp });
    st.ball(V[0], { color: INK, radius: 0.15, parent: grp }); st.label(add(V[0], [-0.3, 0, -0.42]), 'origin', 'tag');
    st.ball(c, { color: COL[1], radius: 0.16, parent: grp }); st.label(add(c, [-0.3, 0, 0.45]), 'head', 'tag strong');
    S.forEach((p) => st.ball(p, { color: COL[0], radius: 0.16, hollow: true, parent: grp }));
    const lo = [0, 1, 2].map((q) => Math.min(c[q], 0, ...S.map((p) => p[q]))), hi = [0, 1, 2].map((q) => Math.max(c[q], 0, ...S.map((p) => p[q])));
    // the box [l, h] on every axis: the rest of the walk must reach both faces on each axis
    const bx = [lo, hi], corner = (m) => [bx[m & 1][0], bx[(m >> 1) & 1][1], bx[(m >> 2) & 1][2]];
    for (const [p, q] of [[0, 1], [2, 3], [4, 5], [6, 7], [0, 2], [1, 3], [4, 6], [5, 7], [0, 4], [1, 5], [2, 6], [3, 7]]) st.line([corner(p), corner(q)], { color: COL[5], dashed: true, parent: grp });
    let tot = 0; const rows = [];
    for (let q = 0; q < 3; q++) {
      const l = lo[q], h = hi[q], cc = c[q], a1 = (cc - l) + (h - l) + h, a2 = (h - cc) + (h - l) - l, mn = Math.min(a1, a2); tot += mn;
      rows.push(`<tr><td style="color:${AXC[q]};font-weight:700">${AXN[q]}</td><td>${cc}</td><td>[${l}, ${h}]</td><td>${a1}</td><td>${a2}</td><td><b>${mn}</b></td></tr>`);
    }
    tbl.innerHTML = '<thead><tr><th>axis</th><th>c</th><th>[l, h]</th><th>a₁</th><th>a₂</th><th>min</th></tr></thead><tbody>' + rows.join('') + `</tbody><tfoot><tr><td colspan="5">sum</td><td><b>${tot}</b></td></tr></tfoot>`;
    head.textContent = `After step ${i}: ${s.pending.length} pending, ${S.length} with a single site`;
    info.innerHTML = `The rest of the walk starts at the head, visits every single site (blue rings), and ends at the origin, so on each axis it reaches both l and h. Reaching l first costs at least a₁ = (c − l) + (h − l) + h steps on that axis; reaching h first, a₂ = (h − c) + (h − l) − l. In all it needs at least <b>${tot}</b> steps, and <b>${s.R1}</b> are left: ` + (tot <= s.R1 ? '<span class="ok">the span test passes</span>.' : '<span class="no">the walk is discarded</span>.') + ' The dashed box is [l, h] on all three axes.';
    back.disabled = si === 0; next.disabled = si === steps.length - 1; st.request();
  }
  const back = btn('Earlier', () => { si--; draw(); }), next = btn('Later', () => { si++; draw(); });
  const c = ctlRow(w); c.append(back, next, H('span', { class: 'readout grow' }, 'The span test runs while at least two obligations are pending. Drag to turn.'));
  draw();
}
