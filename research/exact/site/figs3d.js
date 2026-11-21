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
const readout = (w) => { const r = H('div', { class: 'readout', 'aria-live': 'polite' }); w.append(r); return r; };
const hint = (text) => H('p', { class: 'hint' }, text);

function stepList(parent, names) {
  const ol = H('ol', { class: 'steps' }); names.forEach((n2) => ol.append(H('li', { html: n2 }))); parent.append(ol);
  return (k) => [...ol.children].forEach((li, j) => { li.classList.toggle('now', j === k); li.classList.toggle('done', j < k); });
}

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
    for (let k = 0; k < 24; k++) { const ang = k / 24 * 2 * Math.PI; for (const rr of [r, r * 1.35]) {
      const c = [x[0] + rr * Math.cos(ang), x[1] + rr * Math.sin(ang)];
      const clear = Math.min(...avoid.map((p) => Math.hypot(p[0] - c[0], p[1] - c[1])));
      let apart = 9; for (const u of used) apart = Math.min(apart, Math.hypot(u[0] - c[0], u[1] - c[1]));
      const s = Math.min(clear, r * 0.9) + 0.6 * Math.min(apart, r * 2.2) - (rr > r ? 0.08 : 0);
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
  p3.append(H('span', { class: 'pane-label' }, '(a)'));
  p2.append(H('span', { class: 'pane-label' }, '(b)'));
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
  }
  const c = ctlRow(w);
  let flat = false;
  // the signature moment: when (a) has turned to look along D, (b) draws itself: arcs, then crossings, then colours
  function revealB() {
    if (matchMedia('(prefers-reduced-motion: reduce)').matches || !D.svg.animate) return;
    D.arcs.forEach((a2, k) => { const L = a2.path.getTotalLength(); a2.path.animate([{ strokeDasharray: `${L}`, strokeDashoffset: L }, { strokeDasharray: `${L}`, strokeDashoffset: 0 }], { duration: 650, delay: k * 90, easing: 'cubic-bezier(.2,.7,.2,1)', fill: 'backwards' }); });
    const t0 = D.arcs.length * 90 + 500;
    D.svg.querySelectorAll('circle[stroke-dasharray]').forEach((c2, k) => c2.animate([{ opacity: 0 }, { opacity: 1 }], { duration: 300, delay: t0 + k * 80, fill: 'backwards' }));
    D.svg.querySelectorAll('g.hit').forEach((g2, k) => g2.animate([{ opacity: 0, transform: 'scale(.4)' }, { opacity: 1, transform: 'scale(1)' }], { duration: 360, delay: t0 + 450 + k * 90, easing: 'cubic-bezier(.3,1.4,.5,1)', fill: 'backwards' }));
  }
  const mode = seg([['free', 'Free view'], ['proj', 'Look along D']], 'free', (v) => {
    if (v === 'proj') { st.setDir(b.D, 1200, [0, 1, 0], revealB); if (!flat) { flat = true; st.flatten(true, 1200); } }
    else { st.setDir([1.1, -1.5, 1.05], 1000); if (flat) { flat = false; st.flatten(false, 1000); } }
  });
  st.onUser = () => { mode.set('free'); if (flat) { flat = false; st.flatten(false, 500); } };
  c.append(mode); hl(null);
}

// ===================================================================== Figure 3: Fox colourings of the trefoil (3D)
export function figTrefoil(w) {
  const N = 360, P = [];
  for (let k = 0; k < N; k++) { const t = k / N * 2 * Math.PI; P.push([(Math.sin(t) + 2 * Math.sin(2 * t)) * 0.9, (Math.cos(t) - 2 * Math.cos(2 * t)) * 0.9, -Math.sin(3 * t) * 0.9 + 1.4]); }
  const K = crossingsOf(P), arcs = arcPolylines(P, K.unders, 0), NAME = ['A', 'B', 'C'];
  const [rule, pane] = stage(w, 2, 'stage-rule');
  rule.classList.add('side');
  rule.innerHTML = `<h4>(a)</h4><svg viewBox="0 0 120 100" class="rule-svg" role="img" aria-label="A crossing: the over-arc has colour b, the under-arcs have colours a and c, and 2b = a + c mod p">
    <path d="M60,96 L60,62" stroke="${COL[0]}" stroke-width="6" stroke-linecap="round"/><path d="M60,38 L60,4" stroke="${COL[2]}" stroke-width="6" stroke-linecap="round"/>
    <path d="M10,50 L110,50" stroke="${COL[1]}" stroke-width="6" stroke-linecap="round"/>
    <text x="70" y="88" font-size="13" font-weight="700" fill="${COL[0]}">a</text><text x="70" y="18" font-size="13" font-weight="700" fill="${COL[2]}">c</text><text x="100" y="42" font-size="13" font-weight="700" fill="${COL[1]}">b</text>
  </svg><p class="rule-f">2b ≡ a + c (mod p)</p>`;
  let p = 3, x = [0, 1, 2], walkK = -1;
  const st = new Studio(pane, { aspect: '4 / 3', shadowDir: [0, 0, 1], label: 'A trefoil in 3D; click a strand to change its colour',
    onPick: (u) => { if (u.arc != null) { x[u.arc] = mod(x[u.arc] + 1, p); walkK = -1; draw(); } } });
  pane.append(H('span', { class: 'pane-label' }, '(b)'));
  const tubes = arcs.map((pts, e) => st.tube(pts, { closed: false, radius: 0.17, userData: { arc: e }, pick: true, segments: 140 }));
  st.frame(P.concat([[0, -3.6, 1.4], [0, 3.2, 1.4]]), [0.3, -1.25, 1.35], 1.08);
  const badges = K.crossings.map((c) => st.label(pointAt(P, c.so).map((v, i) => (i === 2 ? v + 0.5 : v)), '', 'badge'));
  const chips = arcs.map((pts) => { const m = pts[Math.floor(pts.length / 2)]; return st.label([m[0] * 1.12, m[1] * 1.12, m[2] + 0.1], '', 'chip3'); });
  function all() { const out = []; for (let a0 = 0; a0 < p; a0++) for (let a1 = 0; a1 < p; a1++) for (let a2 = 0; a2 < p; a2++) { const v = [a0, a1, a2]; if (K.crossings.every((cr) => mod(2 * v[cr.over] - v[cr.inArc] - v[cr.outArc], p) === 0)) out.push(v); } return out; }
  function draw() {
    tubes.forEach((t, e) => { t.material.color.set(COL[x[e]]); });
    chips.forEach((L, e) => { L.el.innerHTML = `${NAME[e]} = ${x[e]}`; L.el.style.background = COL[x[e]]; L.el.style.color = onText(COL[x[e]]); });
    let ok = true;
    K.crossings.forEach((c, k) => {
      const o = x[c.over], i = x[c.inArc], u = x[c.outArc], good = mod(2 * o - i - u, p) === 0; ok = ok && good;
      badges[k].el.className = 'studio-label badge ' + (good ? 'ok' : 'no');
      badges[k].el.innerHTML = `2·${o} ${good ? '≡' : '≢'} ${i} + ${u}`;
    });
    st.request();
    const sols = all(); count.innerHTML = walkK >= 0 ? `${walkK + 1} / ${sols.length}` : `${sols.length}`;
  }
  const c = ctlRow(w);
  const count = H('span', { class: 'count', 'aria-label': 'number of colourings' });
  c.append(seg([['3', 'p = 3'], ['7', 'p = 7']], '3', (v) => { p = +v; x = x.map((a) => mod(a, p)); walkK = -1; draw(); }),
    btn('Next colouring', () => { const S2 = all(); walkK = (walkK + 1) % S2.length; x = S2[walkK].slice(); draw(); }), count);
  draw();
}

// ===================================================================== Figure 6: the potential psi_Z (3D)
export function figPsi(w) {
  const start = 'eeeuwuwwdd'.split('');   // the polygon of the paper's figure, in the xz-plane
  const [pane] = stage(w, 1);
  let word = start.slice();
  const st = new Studio(pane, { aspect: '16 / 9', shadowDir: [0.2, -0.3, 1], label: 'A lattice polygon with the heights of its vertices; click a ring to flip a corner',
    onPick: (u) => { if (u.flip != null) doFlip(u.flip); } });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame(walk(word.join('')).slice(0, -1).concat([[0, 0, -0.3], [3, 0, 3.3]]), [0.55, -1.7, 0.6]);
  const big = st.label([0, 0, 0], '', 'psi z'); const hist = H('span', { class: 'chain', 'aria-live': 'polite' });
  const psiOf = (V) => { const z = V.map((v) => v[2]); const m = Math.min(...z); return [z.reduce((a, v) => a + v - m, 0), m]; };
  function flips(V) {
    const n = word.length, out = [], set = new Set(V.map(key));
    for (let i = 1; i < n; i++) { const pp = word[i - 1], d = word[i]; if (AX[pp] === AX[d]) continue; const vp = add(V[i - 1], U[d]); if (!set.has(key(vp))) out.push({ i, vp }); }
    return out;
  }
  function draw(moving) {
    st.clear(grp); st.labels.filter((L) => L !== big).forEach((L) => L.el.remove()); st.labels = st.labels.filter((L) => L === big);
    const V = walk(word.join('')).slice(0, -1);
    if (moving) V[moving.i] = moving.p;
    const [psi, zmin] = psiOf(V);
    st.rod([...V, V[0]], { color: INK, radius: 0.08, parent: grp });
    const zf = st.floorZ != null ? st.floorZ : zmin - 0.7;
    V.forEach((v, k) => {
      const h = Math.round(v[2] - zmin);
      st.ball(v, { color: INK, radius: 0.1, parent: grp });
      st.label(add(v, [0, -0.25, 0.3]), String(h), 'hchip');
      if (h > 0) st.line([v, [v[0], v[1], zmin]], { color: COL[0], dashed: true, opacity: 0.7, parent: grp });
    });
    // the floor level z_min
    const xs = V.map((v) => v[0]), ys = V.map((v) => v[1]);
    st.sheet([[Math.min(...xs) - 0.6, Math.min(...ys) - 0.6, zmin], [Math.max(...xs) + 0.6, Math.min(...ys) - 0.6, zmin], [Math.max(...xs) + 0.6, Math.max(...ys) + 0.6, zmin], [Math.min(...xs) - 0.6, Math.max(...ys) + 0.6, zmin]], { color: COL[0], opacity: 0.07, parent: grp });
    if (!moving) for (const f of flips(V)) {
      const down = f.vp[2] < V[f.i][2], same = f.vp[2] === V[f.i][2];
      const c = down ? GOOD : '#8a929c';
      const twin = flips(V).filter((g) => key(g.vp) === key(f.vp)).length > 1;
      const at = twin ? f.vp.map((x2, j) => x2 + 0.28 * (V[f.i][j] - x2)) : f.vp;
      st.ball(at, { color: c, radius: twin ? 0.12 : 0.16, hollow: true, userData: { flip: f.i }, pick: true, parent: grp });
      st.sheet([V[f.i - 1], V[f.i], V[(f.i + 1) % V.length], f.vp], { color: c, opacity: 0.12, parent: grp });
    }
    big.el.innerHTML = `ψ<sub>Z</sub> = ${psi}`; big.pos.set((Math.min(...xs) + Math.max(...xs)) / 2, 0, Math.max(...V.map((v) => v[2])) + 1.1);
    st.request();
  }
  let busy = false;
  function pushDown() {   // flip downwards while a downward flip exists
    const V = walk(word.join('')).slice(0, -1);
    const f = flips(V).find((x2) => x2.vp[2] < V[x2.i][2]);
    if (!f) { busy = false; pushB.disabled = false; return; }
    doFlip(f.i, pushDown);
  }
  function doFlip(i, then) {
    const V = walk(word.join('')).slice(0, -1), from = V[i], to = add(V[i - 1], U[word[i]]);
    const before = psiOf(V)[0];
    st.tween(650, (k) => draw({ i, p: from.map((a, j) => a + k * (to[j] - a)) }), () => {
      [word[i - 1], word[i]] = [word[i], word[i - 1]];
      draw();
      const after = psiOf(walk(word.join('')).slice(0, -1))[0];
      chain.push(after); hist.innerHTML = chain.map((v, j) => (j === chain.length - 1 ? `<b>${v}</b>` : String(v))).join(' → ');
      if (then) setTimeout(then, 250);
    });
  }
  let chain = [];
  const c = ctlRow(w);
  const pushB = btn('Push down', () => { if (busy) return; busy = true; pushB.disabled = true; pushDown(); });
  c.append(pushB, hist, btn('Reset', () => { if (busy) return; word = start.slice(); chain = []; draw(); chain = [psiOf(walk(word.join('')).slice(0, -1))[0]]; hist.innerHTML = `<b>${chain[0]}</b>`; }));
  draw(); chain = [psiOf(walk(word.join('')).slice(0, -1))[0]]; hist.innerHTML = `<b>${chain[0]}</b>`;
}

// ===================================================================== Figure 7: curtains (3D)
export function figCurtain(w) {
  const [pane] = stage(w, 1);
  const st = new Studio(pane, { aspect: '16 / 9', shadowDir: [0.2, -0.3, 1], label: 'A curtain in 3D and the flips that remove it' });
  const grp = new THREE.Group(); st.world.add(grp);
  const SIDE = ['e', 'n', 'e', 's', 'e'];
  const MIN7 = [[-0.4, -0.2, -0.2], [2.4, 1.1, 1.2]];   // the frame never gets smaller than the k = 3 curtain
  let k = 3, t = 0;
  const walkLine = H('div', { class: 'walkline bigwalk', 'aria-live': 'polite' });
  w.querySelector('.stage').append(walkLine);
  const tagL = H('span', { class: 'pane-label' }); pane.append(tagL);
  function orig() { const V = [[0, 0, 0]]; V.push([0, 0, 1]); for (let j = 0; j < k; j++) V.push(add(V[V.length - 1], U[SIDE[j]])); V.push(add(V[V.length - 1], U.d)); return V; } // v0..v_{k+2}
  function current(tt) {
    const V = orig(), a = U.u;
    if (tt === k) return [V[0], ...V.slice(2, k + 2).map((v) => add(v, a, -1))].concat([V[k + 2]]).filter((v, i, arr) => i === 0 || key(v) !== key(arr[i - 1]));
    const out = [V[0]]; for (let j = 2; j <= tt + 1; j++) out.push(add(V[j], a, -1)); for (let j = tt + 1; j <= k + 2; j++) out.push(V[j]); return out;
  }
  function draw(moveFrom, moveTo, kk, collapse) {
    st.clear(grp); st.clearLabels();
    const V = orig(), a = U.u;
    // the curtain: the vertical strip between the sideways stretch and the points below it
    for (let j = 1; j <= k; j++) st.sheet([V[j], V[j + 1], add(V[j + 1], a, -1), add(V[j], a, -1)], { color: COL[2], opacity: 0.16, parent: grp });
    let path = current(t);
    if (moveFrom) { path = current(t); path = path.map((p) => (key(p) === key(moveFrom) ? moveFrom.map((x, i) => x + kk * (moveTo[i] - x)) : p)); }
    if (collapse != null) {   // the U-turn a, s_k, -a folds down onto the single step s_k
      const top1 = V[k], top2 = V[k + 1];
      path = path.map((p) => (key(p) === key(top1) ? add(top1, a, -collapse) : key(p) === key(top2) ? add(top2, a, -collapse) : p));
    }
    st.line([[-0.6, 0, 0], V[0]], { color: INK2, dashed: true, parent: grp }); st.line([V[k + 2], add(V[k + 2], U.e, 0.6)], { color: INK2, dashed: true, parent: grp });
    st.rod(path, { color: INK, radius: 0.08, parent: grp });
    path.forEach((p) => st.ball(p, { color: INK, radius: 0.1, parent: grp }));
    const visited = new Set(path.map(key));
    for (let j = 2; j <= k; j++) { const q = add(V[j], a, -1); if (!visited.has(key(q))) st.ball(q, { color: COL[2], radius: 0.13, hollow: true, parent: grp }); }
    const letters = t === k ? Array.from({ length: k }, (_, j) => `s<sub>${j + 1}</sub>`) : [...Array.from({ length: t }, (_, j) => `s<sub>${j + 1}</sub>`), '<b>a</b>', ...Array.from({ length: k - t }, (_, j) => `s<sub>${t + j + 1}</sub>`), '<b>−a</b>'];
    walkLine.innerHTML = letters.join(' ') + `<span class="len">${letters.length}</span>`;
    tagL.textContent = k === 3 ? `(${'abcd'[t]})` : '';
    back.disabled = t === 0; next.disabled = t === k; st.request();
  }
  function step(dir) {
    if (dir > 0 && t < k - 1) {      // animate vertex v_{t+1} sliding to v_{t+2} - a
      const V = orig(), from = V[t + 1], to = add(V[t + 2], U.u, -1);
      st.tween(700, (kk) => draw(from, to, kk), () => { t++; draw(); });
    } else if (dir > 0 && t === k - 1) {   // the last stage, animated: the U-turn collapses onto one step
      st.tween(1100, (kk) => draw(null, null, 0, kk), () => { t++; draw(); });
    } else { t = Math.max(0, Math.min(k, t + dir)); draw(); }
  }
  st.frame(orig().concat(MIN7), [0.9, -1.7, 0.85]);
  const back = btn('Back', () => step(-1)), next = btn('Next', () => step(1));
  const c = ctlRow(w);
  c.append(H('span', { class: 'readout' }, H('i', {}, 'k'), ' ='), seg([['2', '2'], ['3', '3'], ['4', '4'], ['5', '5']], '3', (v) => { k = +v; t = 0; st.frame(orig().concat(MIN7), [0.9, -1.7, 0.85]); draw(); }), back, next);
  draw();
}

// ===================================================================== Figure 8: the corner patterns of DMON7 on a real knot (cel 3D)
// A 40-step polygon of type 5_2: |w36| with two bumps added (reverse U-turn removals) and pushed up by
// allowed flips. Every ring is a corner in one of the four DMON7 patterns whose fourth corner is free.
export function figCorners(w) {
  const START = 'eeuennwwwwssseennwuueedddndnuueuwwssswdd';
  const PZ = '#a6dcc6', PY = '#a9d0ec', TONE = ['#d9dcdf', '#cfd3d7', '#c2c7cc'];
  const [pane] = stage(w, 1);
  let word = START.split('');
  const st = new Studio(pane, { cel: true, aspect: '16 / 10', label: 'A 40-step 5₂ polygon with its potentials; click a ring to flip a corner',
    onPick: (u) => { if (u.flip != null && !busy) doFlip(u.flip); } });
  const grp = new THREE.Group(); st.world.add(grp);
  const V0 = walk(START).slice(0, -1);
  st.frame(V0.concat([[V0[0][0], V0[0][1], 5.2]]), [1, -1.68, 1.05], 1.04);
  const low = (p, q) => (p === 'u' && AX[q] < 2) || (AX[p] < 2 && q === 'd') || (p === 'n' && AX[q] === 0) || (AX[p] === 0 && q === 's');
  const potentials = (V) => { const z = V.map((v) => v[2]), y = V.map((v) => v[1]), zm = Math.min(...z), ym = Math.min(...y); return [z.reduce((t, v) => t + v - zm, 0), y.reduce((t, v) => t + v - ym, 0)]; };
  function flips(V) {
    const set = new Set(V.map(key)), out = [];
    for (let i = 1; i < word.length; i++) { const p = word[i - 1], q = word[i]; if (AX[p] === AX[q] || !low(p, q)) continue; const vp = add(V[i - 1], U[q]); if (!set.has(key(vp))) out.push({ i, vp, z: p === 'u' || q === 'd' }); }
    return out;
  }
  const lz = st.label([0, 0, 0], '', 'psi z'), ly = st.label([0, 0, 0], '', 'psi y');
  let shown = potentials(V0), busy = false;
  function setPsi(P, pulse) {
    lz.el.innerHTML = `ψ<sub>Z</sub> = ${P[0]}`; ly.el.innerHTML = `ψ<sub>Y</sub> = ${P[1]}`;
    if (pulse != null && lz.el.animate) [lz, ly][pulse].el.animate([{ transform: 'scale(1.18)' }, { transform: 'scale(1)' }], { duration: 420, easing: 'cubic-bezier(.3,1.4,.5,1)', composite: 'add' });
  }
  function draw(moving) {
    st.clear(grp);
    const V = walk(word.join('')).slice(0, -1);
    if (moving) V[moving.i] = moving.p;
    for (let i = 0; i < V.length; i++) { const p = V[i], q = V[(i + 1) % V.length]; st.rod([p, q], { color: TONE[p[2] !== q[2] ? 2 : p[1] !== q[1] ? 1 : 0], radius: 0.1, parent: grp }); }
    if (!moving) for (const f of flips(V)) {
      const c = f.z ? PZ : PY;
      st.sheet([V[f.i - 1], V[f.i], V[f.i + 1], f.vp], { color: c, opacity: 0.55, parent: grp });
      st.rod([V[f.i - 1], V[f.i], V[f.i + 1]], { color: f.z ? '#6fc4a4' : '#84bbe2', radius: 0.13, parent: grp });
      st.ball(f.vp, { color: f.z ? '#3fa985' : '#4a8fc6', radius: 0.22, hollow: true, userData: { flip: f.i }, pick: true, parent: grp });
    }
    const xs = V.map((v) => v[0]), ys = V.map((v) => v[1]), zs = V.map((v) => v[2]);
    const cx = (Math.min(...xs) + Math.max(...xs)) / 2, top = Math.max(...zs) + 1.5;
    lz.pos.set(cx - 1.5, (Math.min(...ys) + Math.max(...ys)) / 2, top); ly.pos.set(cx + 1.6, (Math.min(...ys) + Math.max(...ys)) / 2, top);
    st.request();
    return V;
  }
  function doFlip(i, then) {
    const V = walk(word.join('')).slice(0, -1), from = V[i], to = add(V[i - 1], U[word[i]]), zType = word[i - 1] === 'u' || word[i] === 'd';
    busy = true;
    st.tween(560, (k) => draw({ i, p: from.map((a2, j) => a2 + k * (to[j] - a2)) }), () => {
      [word[i - 1], word[i]] = [word[i], word[i - 1]];
      const V2 = draw(); shown = potentials(V2); setPsi(shown, zType ? 0 : 1);
      const pop = st.label(to, '−1', 'minus ' + (zType ? 'z' : 'y'));
      if (pop.el.animate) pop.el.animate([{ opacity: 1, translate: '0 0' }, { opacity: 0, translate: '0 -28px' }], { duration: 900, easing: 'ease-out', fill: 'forwards' });
      setTimeout(() => { const j = st.labels.indexOf(pop); if (j >= 0) { st.labels.splice(j, 1); pop.el.remove(); } }, 950);
      busy = false; pushB.disabled = !flips(V2).length;
      if (then) setTimeout(then, 140);
    });
  }
  function pushDown() { const V = walk(word.join('')).slice(0, -1), F = flips(V); if (!F.length) { pushB.disabled = true; return; } F.sort((p, q) => (q.z - p.z) || (p.i - q.i)); doFlip(F[0].i, pushDown); }
  const c = ctlRow(w);
  const pushB = btn('Push down', () => { if (!busy) pushDown(); });
  c.append(pushB, btn('Reset', () => { if (busy) return; word = START.split(''); const V = draw(); shown = potentials(V); setPsi(shown); pushB.disabled = false; }));
  draw(); setPsi(shown);
}

// ===================================================================== Figure 9: DMON3 and DMON4 at the origin (3D)
export function figOrigin(w) {
  const b = DATA.w36, V = b.verts, n = V.length, word = b.word;
  const [pane] = stage(w, 1);
  const st = new Studio(pane, { cel: true, aspect: '16 / 9', label: 'The 36-step polygon, its lowest vertex and the direction of travel' });
  st.rod([...V, V[0]], { color: '#d9dcdf', radius: 0.08 });
  const ends = new THREE.Group(); st.world.add(ends);
  st.ball(V[0], { color: INK, radius: 0.2 });
  const xs = V.map((v) => v[0]), ys = V.map((v) => v[1]);
  st.sheet([[Math.min(...xs) - 0.8, Math.min(...ys) - 0.8, -0.12], [Math.max(...xs) + 0.8, Math.min(...ys) - 0.8, -0.12], [Math.max(...xs) + 0.8, Math.max(...ys) + 0.8, -0.12], [Math.min(...xs) - 0.8, Math.max(...ys) + 0.8, -0.12]], { color: '#cfe9f8', opacity: 0.7 });
  st.frame(V, [1.2, -1.7, 0.7]);
  const lw0 = st.label(V[0], '', 'tag strong first'), lwl = st.label(V[0], '', 'tag strong last');
  const away = (d) => (d === 'u' || d === 'd' ? [-1.5, -0.4, 0] : d === 'e' || d === 'w' ? [0, -1.1, -0.35] : [-1.1, 0, -0.35]);
  const cone = (p, dir, color) => { const m = new THREE.Mesh(new THREE.ConeGeometry(0.16, 0.38, 18), st.material(color)); m.position.set(...p); m.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), new THREE.Vector3(...dir)); ends.add(m); };
  const bead = st.ball(V[0], { color: '#eec6dc', radius: 0.2 });
  let fwd = true, s0 = performance.now();
  st.always = true;
  const tick = () => { const t = ((performance.now() - s0) / 9000) % 1; const sIdx = (fwd ? t : 1 - t) * n; const p = pointAt(V, sIdx % n); bead.position.set(...p); };
  const orig = st.frameLoop.bind(st); st.frameLoop = () => { if (st.visible !== false) tick(); orig(); };
  const ruler = H('div', { class: 'ruler', 'aria-live': 'polite' }); w.querySelector('.stage').append(ruler);
  const order = 'ewnsud';
  function draw() {
    const w0 = fwd ? word[0] : REV[word[n - 1]], last = fwd ? word[n - 1] : REV[word[0]], ml = REV[last];
    lw0.el.innerHTML = `w<sub>0</sub> = ${w0}`; lwl.el.innerHTML = `−w<sub>n−1</sub> = ${ml}`;
    lw0.pos.set(...add(add(V[0], U[w0], 0.6), away(w0))); lwl.pos.set(...add(add(V[0], U[ml], 0.6), away(ml)));
    st.clear(ends);
    const A = add(V[0], U[w0]), Z = add(V[0], U[ml]);
    st.rod([V[0], A], { color: '#f6bf9b', radius: 0.13, parent: ends }); st.rod([Z, V[0]], { color: '#5f9fd1', radius: 0.13, parent: ends });
    cone(add(V[0], U[w0], 0.6), U[w0], '#f6bf9b'); cone(add(V[0], U[ml], 0.45), U[REV[ml]], '#5f9fd1');
    const ok = order.indexOf(w0) < order.indexOf(ml);
    ruler.innerHTML = order.split('').map((l) => `<span class="ordl${l === w0 ? ' o1' : l === ml ? ' o0' : ''}">${l}</span>`).join('<span class="lt">&lt;</span>') +
      `<span class="verdict ${ok ? 'yes' : 'no'}">${ok ? '<svg viewBox="0 0 20 20" aria-label="holds"><path d="M4 10.5 L8.5 15 L16 5.5"/></svg>' : '<svg viewBox="0 0 20 20" aria-label="fails"><path d="M5 5 L15 15 M15 5 L5 15"/></svg>'}</span>`;
    st.request();
  }
  const c = ctlRow(w); c.append(seg([['f', '(a) Forwards'], ['b', '(b) Backwards']], 'f', (v) => { fwd = v === 'f'; s0 = performance.now(); draw(); }));
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
  { // the orientation arrow on edge 1 (labels increase along it), as in the paper's figure
    const e1 = D.edges.find((e) => e.label === 1), k = Math.floor(e1.pts.length / 2), sg = D.reversed ? -1 : 1;
    const q = e1.pts[k], q2 = e1.pts[k + 1], dir = new THREE.Vector3(sg * (q2[0] - q[0]), sg * (q2[1] - q[1]), 0).normalize();
    let best = 0; P.forEach((pp, j) => { if (Math.hypot(pp[0] - 1.6 * q[0], pp[1] - 1.6 * q[1]) < Math.hypot(P[best][0] - 1.6 * q[0], P[best][1] - 1.6 * q[1])) best = j; });
    const cone = new THREE.Mesh(new THREE.ConeGeometry(0.14, 0.34, 18), st.material(INK));
    cone.position.set(1.6 * q[0], 1.6 * q[1], P[best][2] + 0.24);
    cone.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), dir); cone.castShadow = true; st.world.add(cone);
  }
  D.edgeLabels.forEach((e) => st.label([e.p[0] * 1.6, e.p[1] * 1.6, 1.0], String(e.label), 'edge'));
  const xl = D.crossings.map((c, k) => { const lp = D.crossLabels[k]; const L = st.label([lp[0] * 1.6, lp[1] * 1.6, 1.4], `X<sub>${D.crossNames[k]}</sub>`, 'xing'); L.el.tabIndex = 0; L.el.addEventListener('pointerenter', () => focusX(k)); L.el.addEventListener('focus', () => focusX(k)); return L; });
  const codeBox = H('div', { class: 'readout' }), eqs = H('div', { class: 'readout', style: 'margin-top:10px' });
  side.append(codeBox, eqs);
  function focusX(k) {
    const X = D.pd[D.crossNames[k] - 1];
    codeBox.innerHTML = D.pd.map((X2, j) => `<div class="${j === D.crossNames[k] - 1 ? 'now' : ''}">X<sub>${j + 1}</sub>[${X2.join(', ')}]</div>`).join('');
    xl.forEach((L, j) => L.el.classList.toggle('on', j === k));
  }
  function draw() {
    tubes.forEach((t, e) => t.material.color.set(COL[mod(a + b * VEC[nameIdx[names[e]]], 7)]));
    const v = [0, 1, 2, 3, 4].map((k) => mod(a + b * VEC[k], 7)), [A, B, C, Dd, E] = v;
    const rows = [['2B', 'E + A', 2 * B, E + A], ['2D', 'A + B', 2 * Dd, A + B], ['2E', 'B + C', 2 * E, B + C], ['2A', 'C + D', 2 * A, C + Dd], ['2C', 'D + E', 2 * C, Dd + E]];
    eqs.innerHTML = `<b>(A, B, C, D, E) = (${v.join(', ')})</b><br>` + rows.map(([l, r, x, y]) => `${l} = ${mod(x, 7)} ${mod(x - y, 7) === 0 ? '<span class="ok">≡</span>' : '<span class="no">≢</span>'} ${mod(y, 7)} = ${r}`).join('<br>');
    st.request();
  }
  const sa = H('input', { type: 'range', min: 0, max: 6, value: a, 'aria-label': 'a' }), sb = H('input', { type: 'range', min: 0, max: 6, value: b, 'aria-label': 'b' });
  sa.addEventListener('input', () => { a = +sa.value; draw(); }); sb.addEventListener('input', () => { b = +sb.value; draw(); });
  const c = ctlRow(w);
  const va = H('b', {}, String(a)), vb = H('b', {}, String(b));
  sa.addEventListener('input', () => { va.textContent = sa.value; }); sb.addEventListener('input', () => { vb.textContent = sb.value; });
  c.append(H('label', { class: 'range' }, H('i', {}, 'a'), ' = ', va, sa), H('label', { class: 'range' }, H('i', {}, 'b'), ' = ', vb, sb));
  focusX(0); draw();
}

// ===================================================================== Figure 15: the worked certificate
export function figCertex(w) {
  const C = DATA.cert, ac = [COL[0], COL[1], COL[2]];
  const [p3, p2] = stage(w, 2);
  p3.append(H('span', { class: 'pane-label' }, '(a)'));
  p2.append(H('span', { class: 'pane-label' }, '(b)'));
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
  const mat = (M, cls) => { const m = H('span', { class: 'mat ' + cls, style: `grid-template-columns:repeat(${M[0].length},auto)` }); M.forEach((r, i) => r.forEach((v) => m.append(H('span', { 'data-r': i }, String(v).replace('-', '−'))))); return m; };
  const grp2 = (...k) => H('span', { class: 'matgrp' }, ...k);
  mats.append(grp2('F =', mat(C.F, 'F'), '≡', mat(C.F.map((r) => r.map((v) => mod(v, 7))), 'Fm')), grp2('L =', mat(C.L, 'L')), grp2('LF ≡', mat(C.LF, 'LF'), '(mod 7)'));
  w.querySelector('.stage').append(mats);
  const eqRow = H('div', { class: 'eqrow', 'aria-live': 'polite' }); mats.append(eqRow);
  function row(r) {
    if (typeof rowBtns !== 'undefined') rowBtns.forEach((b2, j) => b2.setAttribute('aria-pressed', String(j === r)));
    w.querySelectorAll('.mat span').forEach((s) => s.classList.toggle('hl', (s.parentNode.classList.contains('F') || s.parentNode.classList.contains('Fm')) && +s.dataset.r === r));
    const c = C.crossings.find((cc) => cc.e === r); ring.innerHTML = '';
    const x = D.crossPts[C.crossings.indexOf(c)]; S('circle', { cx: x[0], cy: -x[1], r: 0.36, fill: 'none', stroke: COL[5], 'stroke-width': 0.08 }, ring);
    const inn = mod(r - 1, 3);
    eqRow.innerHTML = `2x<sub>${c.overArc}</sub> − x<sub>${inn}</sub> − x<sub>${r}</sub> ≡ 0`;
  }
  w.querySelectorAll('.mat.F span, .mat.Fm span').forEach((s) => s.addEventListener('pointerenter', () => row(+s.dataset.r)));
  const c = ctlRow(w); const rowBtns = [0, 1, 2].map((r) => btn(`Row ${r + 1}`, () => row(r), { 'aria-pressed': String(r === 0) })); rowBtns.forEach((b2) => c.append(b2));
  row(0);
}

// ===================================================================== Figure 16: PD comparison
export function figPdCompare(w) {
  const B = DATA.w36, Dd = DATA.std52, PD = DATA.pd;
  const [left, right] = stage(w, 2);
  left.append(H('span', { class: 'pane-label' }, '(a)'));
  right.append(H('span', { class: 'pane-label' }, '(b)'));
  let sw = false, sh = true, svgL = null;
  const svg2 = S('svg', { role: 'img', class: 'knot2d' }, right);
  const all = Dd.arcs.flat(), xs = all.map((p) => p[0]), ys = all.map((p) => -p[1]);
  svg2.setAttribute('viewBox', `${Math.min(...xs) - 0.5} ${Math.min(...ys) - 0.5} ${Math.max(...xs) - Math.min(...xs) + 1} ${Math.max(...ys) - Math.min(...ys) + 1}`);
  Dd.arcs.forEach((pts) => { const d = 'M' + pts.map((p) => `${p[0]},${-p[1]}`).join('L'); S('path', { d, fill: 'none', stroke: SHEET, 'stroke-width': 0.17, 'stroke-linecap': 'round' }, svg2); S('path', { d, fill: 'none', stroke: INK, 'stroke-width': 0.08, 'stroke-linecap': 'round' }, svg2); });
  Dd.edgeLabels.forEach((e) => { const t = S('text', { x: e.p[0], y: -e.p[1] + 0.06, 'text-anchor': 'middle', 'font-size': 0.17, fill: INK, 'font-weight': 700 }, svg2); t.textContent = e.label; });
  const tbl = H('table', {}); w.querySelector('.stage').append(H('div', { class: 'tablewrap', style: 'padding:12px' }, tbl));
  const score = H('span', { class: 'count', 'aria-live': 'polite' });
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
    spots.forEach((p, e) => { const lab = sh ? ((e + 6) % 10) + 1 : e + 1; const t = S('text', { x: p[0], y: -p[1] + 0.13, 'text-anchor': 'middle', 'font-size': 0.3, fill: INK, 'font-weight': 700 }, D.svg); t.textContent = lab; });
    { const a0 = D.P2[0], a1 = D.at(0.55); S('path', { d: `M${a0[0]},${-a0[1]}L${a1[0]},${-a1[1]}`, stroke: COL[1], 'stroke-width': 0.09, 'marker-end': 'url(#pdarrow)', fill: 'none' }, D.svg);
      D.svg.insertAdjacentHTML('afterbegin', `<defs><marker id="pdarrow" viewBox="0 0 10 10" refX="6" refY="5" markerWidth="4" markerHeight="4" orient="auto"><path d="M0,0L10,5L0,10z" fill="${COL[1]}"/></marker></defs>`); }
    D.crossPts.forEach((x) => S('circle', { cx: x[0], cy: -x[1], r: 0.07, fill: INK }, D.svg));
    const o = D.P2[0]; S('circle', { cx: o[0], cy: -o[1], r: 0.14, fill: INK }, D.svg);
    const cur = sw ? (sh ? PD.shifted : PD.switched) : (sh ? PD.w36.map((X) => X.map((x) => (x + 5) % 10 + 1)) : PD.w36);
    const stdS = PD.std.map((X) => X.join(','));
    tbl.innerHTML = '<thead><tr><th>w<sub>36</sub></th><th>→</th><th>5<sub>2</sub></th></tr></thead>';
    const tb = H('tbody'); tbl.append(tb);
    cur.forEach((X, k) => { const j = stdS.indexOf(X.join(',')); tb.append(H('tr', {}, H('td', {}, `[${PD.w36[k].join(', ')}]`), H('td', { style: j >= 0 ? 'font-weight:700' : '' }, `[${X.join(', ')}]`), H('td', { html: j >= 0 ? `<span class="ok">= X<sub>${j + 1}</sub></span>` : `<span style="color:${INK2}">≠</span>` }))); });
    const hits = cur.filter((X) => stdS.includes(X.join(','))).length;
    score.innerHTML = `${hits} / 5`; score.classList.toggle('full', hits === 5);
  }
  const ctl = ctlRow(w);
  const b1 = btn('Switch crossings', () => { sw = !sw; b1.setAttribute('aria-pressed', String(sw)); draw(); }, { 'aria-pressed': 'false' });
  const b2 = btn('+6 (mod 10)', () => { sh = !sh; b2.setAttribute('aria-pressed', String(sh)); draw(); }, { 'aria-pressed': 'true' });
  ctl.append(b1, b2, score); draw();
}

// ===================================================================== Web figure 1: the proof of Theorem 2.4, unfolding (3D)
export function figDeltaProof(w) {
  const a = [0, 0, 0], b = [3, 0, 0], c = [1.1, 1.8, 0], m = [1.5, 0, 0];
  const del = 0.42, eta = 0.62;   // the proof's small delta and eta, drawn large enough to see
  const cp = add(m, add(c, m, -1), 1 + del), d = add(m, add(c, m, -1), -del);
  const q = add(m, add(c, m, -1), 0.5), ep = add(q, [0, 0, eta]), em = add(q, [0, 0, -eta]);
  const [pane] = stage(w, 1);
  const st = new Studio(pane, { aspect: '16 / 9', shadowDir: [0.25, -0.35, 1], label: 'The proof of Theorem 2.4, step by step' });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame([[-0.9, -0.9, -0.8], [3.9, 2.6, 0.8]], [0.35, -1.1, 1.35]);
  let stepI = 0, kk = 0;
  const lerp3 = (p, r, s) => p.map((x, i) => x + s * (r[i] - x));
  const others = [[[-1.4, -1.0, 0.6], [-0.6, -0.5, 0.3], a], [b, [3.6, -0.5, -0.4], [4.4, -0.9, -0.9]], [[0.4, 2.6, 1.2], [1.6, 2.4, 1.4], [2.6, 2.2, 1.1]]];
  const corners = [a, d, b, cp];
  // sample points of Q for the coning: on the four spokes m -> corner, and on the boundary (which never moves)
  const spokes = []; corners.forEach((k) => [0.34, 0.68].forEach((s2) => spokes.push({ k, s: s2 })));
  const rim = []; corners.forEach((k, i) => rim.push(lerp3(k, corners[(i + 1) % 4], 0.5)));
  // points of space outside B: they stay where they are
  const outside = [];
  for (const x of [-0.6, 0.6, 1.8, 3.0, 4.0]) for (const y of [-0.8, 0.5, 1.8, 2.9]) for (const z of [-0.7, 0.7]) { const p = [x, y, z]; if (Math.hypot(p[0] - q[0], p[1] - q[1]) > 1.25) outside.push(p); }
  function draw() {
    st.clear(grp); st.clearLabels();
    const k2 = stepI >= 3 ? kk : 0, mt = lerp3(m, c, k2);
    others.forEach((pts) => st.tube(pts, { closed: false, radius: 0.07, color: '#9aa3ad', segments: 30, parent: grp }));
    st.sheet([a, b, c], { color: COL[0], opacity: stepI === 0 ? 0.2 : 0.06, parent: grp });
    if (stepI >= 1) {
      st.line([a, d, b, cp, a], { color: COL[2], parent: grp });
      if (stepI < 3) { st.line([a, b], { color: COL[2], dashed: true, opacity: 0.6, parent: grp }); st.line([d, cp], { color: COL[2], dashed: true, opacity: 0.6, parent: grp }); }
      st.ball(d, { color: COL[2], radius: 0.07, parent: grp }); st.ball(cp, { color: COL[2], radius: 0.07, parent: grp });
      st.label(add(d, [0.05, -0.32, 0]), 'd', 'tag'); st.label(add(cp, [0.28, 0.22, 0]), 'c⁺', 'tag');
    }
    if (stepI >= 2) {
      for (let i = 0; i < 4; i++) {
        const P = corners[i], R = corners[(i + 1) % 4];
        st.sheet([ep, P, R], { color: COL[3], opacity: stepI === 4 ? 0.05 : 0.1, parent: grp }); st.sheet([em, P, R], { color: COL[3], opacity: stepI === 4 ? 0.03 : 0.06, parent: grp });
        st.line([ep, P], { color: COL[3], opacity: 0.55, parent: grp }); st.line([em, P], { color: COL[3], opacity: 0.4, parent: grp });
      }
      st.ball(ep, { color: COL[3], radius: 0.08, parent: grp }); st.ball(em, { color: COL[3], radius: 0.08, parent: grp });
      st.label(add(ep, [-0.35, -0.15, 0.2]), 'e₊', 'tag'); st.label(add(em, [-0.35, -0.15, -0.2]), 'e₋', 'tag');
    }
    if (stepI >= 3) {   // the four triangles of Q, stretched as m moves to c
      corners.forEach((P, i) => st.sheet([P, corners[(i + 1) % 4], mt], { color: [COL[0], COL[5], COL[2], COL[4]][i], opacity: stepI === 4 ? 0.16 : 0.24, parent: grp }));
      corners.forEach((P) => st.line([mt, P], { color: INK2, opacity: 0.5, parent: grp }));
      st.ball(mt, { color: COL[1], radius: 0.09, parent: grp });
      st.label(add(mt, [0.4, -0.3, -0.05]), k2 < 0.98 ? 'f(m)' : 'f(m) = c', 'tag');
    }
    if (stepI === 4) {   // coning: every segment from e+ or e- to a point x of Q goes to the segment to f(x)
      const img = (sp) => lerp3(mt, sp.k, sp.s);
      const targets = [mt, ...spokes.map(img)];
      for (const e of [ep, em]) {
        targets.forEach((x) => { st.line([e, x], { color: COL[1], opacity: 0.85, parent: grp }); st.ball(lerp3(e, x, 0.5), { color: COL[1], radius: 0.045, parent: grp }); });
        rim.forEach((x) => { st.line([e, x], { color: INK2, opacity: 0.45, parent: grp }); st.ball(lerp3(e, x, 0.5), { color: INK2, radius: 0.04, parent: grp }); });
      }
      outside.forEach((p) => st.ball(p, { color: '#9aa3ad', radius: 0.035, parent: grp }));
    }
    const path = stepI >= 3 ? [a, mt, b] : [a, b];
    st.rod(path, { color: INK, radius: 0.09, parent: grp });
    if (stepI < 3 || k2 < 0.98) st.ball(c, { color: '#fff', radius: 0.1, parent: grp });
    [['a', a, [-0.3, -0.25, 0]], ['b', b, [0.3, -0.25, 0]]].concat(stepI >= 3 && k2 > 0.5 ? [] : [['c', c, [-0.32, 0.12, 0]]]).forEach(([s2, p, o]) => st.label(add(p, o), s2, 'tag strong'));
    if (stepI >= 1 && stepI < 3) st.label(add(m, [0.3, -0.12, 0]), 'm', 'tag');
    chips.set(String(stepI));
    back.disabled = stepI === 0; next.disabled = stepI === 4;
    slider.disabled = stepI < 3; sliderLab.style.visibility = stepI < 3 ? 'hidden' : 'visible'; st.request();
  }
  const slider = H('input', { type: 'range', min: 0, max: 100, value: 0, 'aria-label': 'move m to c' });
  slider.addEventListener('input', () => { kk = slider.value / 100; draw(); });
  const VIEW = [[0.35, -1.1, 1.35], [0.25, -0.9, 1.5], [0.15, -1.6, 0.42], [0.3, -1.1, 1.3], [0.55, -1.5, 0.55]];
  const play = () => { kk = 0; slider.value = 0; st.tween(1800, (k) => { kk = k; slider.value = k * 100; draw(); }); };
  const go = (i) => { const was = stepI; stepI = Math.max(0, Math.min(4, i)); st.setDir(VIEW[stepI], 800); if (stepI >= 3 && (was < 3 || stepI === 4)) play(); else if (stepI < 3) { kk = 0; slider.value = 0; } draw(); };
  const chips = seg([['0', 'Δ'], ['1', 'Q'], ['2', 'B'], ['3', 'f'], ['4', 'cone']], '0', (v) => go(+v));
  const back = btn('Back', () => go(stepI - 1)), next = btn('Next', () => go(stepI + 1));
  const sliderLab = H('label', { class: 'range' }, H('i', {}, 'm → c'), slider);
  const c2 = ctlRow(w); c2.append(chips, back, next, sliderLab);
  draw();
}

// ===================================================================== Figure 2: the Delta-move (3D)
export function figDelta(w) {
  const a = [0, 0, 0], b = [3, 0, 0], m = [1.5, 0, 0];
  const strandX = 2.3, strandY = 1.5;                // the other strand: a vertical line through (2.3, 1.5)
  const [pane] = stage(w, 1);
  const st = new Studio(pane, { aspect: '16 / 9', shadowDir: [0.25, -0.35, 1], label: 'A Delta-move in 3D' });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame([[-0.8, -0.4, -0.9], [3.8, 2.8, 0.9]], [0.3, -1.1, 1.35]);
  let push = 0.4, slide = 0;
  const cOf = () => [1.2 + 0.9 * push, 0.5 + 2.1 * push, 0];   // the triangle reaches the strand at push = 0.83
  function pierced(c) {   // does the vertical line x = strandX, y = strandY meet the triangle abc (in the plane z = 0)?
    const P = [strandX, strandY], T = [a, b, c].map((p) => [p[0], p[1]]);
    const sgn = (p, q, r) => (q[0] - p[0]) * (r[1] - p[1]) - (q[1] - p[1]) * (r[0] - p[0]);
    const d1 = sgn(T[0], T[1], P), d2 = sgn(T[1], T[2], P), d3 = sgn(T[2], T[0], P);
    return !((d1 < 0 || d2 < 0 || d3 < 0) && (d1 > 0 || d2 > 0 || d3 > 0));
  }
  function draw() {
    st.clear(grp); st.clearLabels();
    const c = cOf(), bad = pierced(c);
    // with the strand inside the triangle the edge cannot get past it: it stops where it meets the strand
    let sMax = 1;
    if (bad) { let lo = 0, hi = 1; for (let k = 0; k < 30; k++) { const mid = (lo + hi) / 2; if (pierced(m.map((x, i) => x + mid * (c[i] - x)))) hi = mid; else lo = mid; } sMax = lo - 0.01; }
    const blocked = bad && slide > sMax, sl = Math.min(slide, sMax), p = m.map((x, i) => x + sl * (c[i] - x));
    st.sheet([a, b, c], { color: bad ? BAD : COL[0], opacity: 0.2, parent: grp });
    st.line([a, c, b], { color: bad ? BAD : COL[0], dashed: true, parent: grp });
    st.tube([[-1.2, -0.5, 0.4], [-0.6, -0.2, 0.15], a], { closed: false, radius: 0.08, segments: 20, parent: grp });
    st.tube([b, [3.7, 0.4, -0.3], [4.2, 1.1, -0.7]], { closed: false, radius: 0.08, segments: 20, parent: grp });
    st.rod([a, p, b], { color: blocked ? BAD : INK, radius: 0.08, parent: grp });
    st.rod([[strandX, strandY, -1.2], [strandX, strandY, 1.2]], { color: '#8a929c', radius: 0.07, parent: grp });
    st.ball([strandX, strandY, 0], { color: bad ? BAD : '#8a929c', radius: 0.09, parent: grp });
    st.ball(c, { color: '#fff', radius: 0.09, parent: grp });
    [['a', a, [-0.25, -0.3, 0]], ['b', b, [0.25, -0.3, 0]], ['c', c, [-0.3, 0.2, 0.15]]].forEach(([s, q, o]) => st.label(add(q, o), s, 'tag strong'));
    tagL.textContent = bad ? '(c)' : slide < 1 ? '(a)' : '(b)';
    st.request();
  }
  const tagL = H('span', { class: 'pane-label' }); pane.append(tagL);
  const s1 = H('input', { type: 'range', min: 0, max: 100, value: push * 100, 'aria-label': 'move c' });
  const s2 = H('input', { type: 'range', min: 0, max: 100, value: 0, 'aria-label': 'slide the edge' });
  s1.addEventListener('input', () => { push = s1.value / 100; draw(); });
  s2.addEventListener('input', () => { slide = s2.value / 100; draw(); });
  const c2 = ctlRow(w);
  c2.append(H('label', { class: 'range' }, H('i', {}, 'c'), s1), H('label', { class: 'range' }, H('i', {}, '[a, b]'), s2),
    btn('Play', () => st.tween(1200, (k) => { slide = k; s2.value = k * 100; draw(); })));
  draw();
}

// ===================================================================== Figure 5: a flip and a U-turn as two Delta-moves (3D)
export function figFlipDelta(w) {
  const [pane] = stage(w, 1);
  const st = new Studio(pane, { aspect: '16 / 9', shadowDir: [0.25, -0.35, 1], label: 'A corner flip and a U-turn removal as two Delta-moves' });
  const grp = new THREE.Group(); st.world.add(grp);
  st.frame([[-0.9, -0.7, -0.8], [1.9, 1.0, 1.8]], [0.9, -1.6, 0.8]);
  let mode = 'flip', t = 0, k = 1;          // t = number of Delta-moves done (0, 1, 2); k = progress of the current one
  const tagL = H('span', { class: 'pane-label' }); pane.append(tagL);
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
      const isVertex = mode === 'uturn' ? (j === 0 || j === 3 || (j === 1 && t === 0) || (j === 2 && t < 2)) : (j !== 3 || t === 2) && (j !== 1 || t === 0);
      st.ball(p, { color: INK, radius: 0.09, hollow: !isVertex, parent: grp });
      st.label(add(p, [p[0] < 0.5 ? -0.32 : 0.32, -0.32, p[2] > 0.5 ? 0.18 : -0.18]), s, 'tag');
    });
    tagL.textContent = `(${(mode === 'flip' ? 'abc' : 'def')[t]})`;
    back.disabled = t === 0; next.disabled = t === 2; st.request();
  }
  const back = btn('Back', () => { t--; k = 1; draw(); });
  const next = btn('Next', () => { t++; st.tween(900, (x) => { k = x; draw(); }); });
  const c = ctlRow(w);
  c.append(seg([['flip', 'Corner flip'], ['uturn', 'U-turn removal']], 'flip', (v) => { mode = v; t = 0; k = 1; draw(); }), back, next);
  draw();
}
