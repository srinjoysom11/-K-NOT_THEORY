// Wordless animatics: one clock with a scrubber, and the flat axonometric drawing style.
// (The cel-shaded 3D style is the Studio's `cel` mode, in studio.js.)
//
// player(host, { T, draw })   T seconds of animation; draw(t) paints the frame at time t.
//   Starts when the figure comes into view, loops with a pause on the last frame, and pauses
//   off-screen. A thin scrubber and a play/pause button sit under the stage; no words.
//   With reduced motion it shows the last frame, paused.
// Flat(host, { aspect })       an SVG stage drawn in a fixed generic axonometric view.

const reducedQ = matchMedia('(prefers-reduced-motion: reduce)');
export const INK = '#14171b';
// pastel tints of the colour programme (same hue, same meaning)
export const PAS = {
  blue: '#a9d0ec', blue2: '#84bbe2', blue3: '#5f9fd1', sky: '#cfe9f8', verm: '#f6bf9b', verm2: '#ee9d6c',
  green: '#a6dcc6', green2: '#6fc4a4', pink: '#eec6dc', umber: '#dcc4ad', grey: '#d9dcdf', red: '#f2a3a0', paper: '#ffffff',
};
export const clamp = (x) => Math.max(0, Math.min(1, x));
export const seg = (t, a, b) => clamp((t - a) / (b - a));
export const out3 = (x) => 1 - Math.pow(1 - x, 3);
export const inout = (x) => (x < 0.5 ? 4 * x * x * x : 1 - Math.pow(-2 * x + 2, 3) / 2);
export const pop = (x) => (x <= 0 ? 0 : x >= 1 ? 1 : 1 + 2.70158 * Math.pow(x - 1, 3) + 1.70158 * Math.pow(x - 1, 2));   // ease-out-back
export const lerp = (p, q, k) => p.map((v, i) => v + k * (q[i] - v));

const PAUSE = '<rect x="3" y="2" width="4" height="14"/><rect x="11" y="2" width="4" height="14"/>';
const PLAY = '<path d="M4 2 L15 9 L4 16 Z"/>';

export function player(host, { T, draw, hold = 1.8, bar = host }) {
  const wrap = document.createElement('div'); wrap.className = 'anim-bar';
  const b = document.createElement('button'); b.type = 'button'; b.className = 'anim-pp';
  b.innerHTML = `<svg viewBox="0 0 18 18" width="16" height="16" aria-hidden="true" fill="currentColor">${PAUSE}</svg>`;
  const r = document.createElement('input'); r.type = 'range'; r.min = 0; r.max = 1000; r.value = 0; r.className = 'anim-scrub';
  r.setAttribute('aria-label', 'Animation time');
  wrap.append(b, r); bar.append(wrap);
  const st = { t: 0, playing: !reducedQ.matches, visible: false, holdT: 0, raf: 0, last: 0 };
  if (reducedQ.matches) st.t = T;
  const icon = () => { b.querySelector('svg').innerHTML = st.playing ? PAUSE : PLAY; b.setAttribute('aria-label', st.playing ? 'Pause' : 'Play'); };
  const paint = () => { r.value = Math.round((st.t / T) * 1000); draw(st.t); };
  const loop = (now) => {
    st.raf = 0;
    const dt = Math.min(0.05, (now - st.last) / 1000); st.last = now;
    if (st.playing) {
      if (st.t >= T) { st.holdT += dt; if (st.holdT >= hold) { st.t = 0; st.holdT = 0; } }
      else st.t = Math.min(T, st.t + dt);
    }
    paint();
    if (st.playing && st.visible) st.raf = requestAnimationFrame(loop);
  };
  const kick = () => { if (!st.raf && st.visible) { st.last = performance.now(); st.raf = requestAnimationFrame(loop); } };
  b.addEventListener('click', () => { st.playing = !st.playing; if (st.playing && st.t >= T) { st.t = 0; st.holdT = 0; } icon(); kick(); });
  r.addEventListener('input', () => { st.playing = false; icon(); st.t = (r.value / 1000) * T; paint(); });
  new IntersectionObserver((es) => { st.visible = es[es.length - 1].isIntersecting; if (st.visible) kick(); }, { rootMargin: '80px 0px' }).observe(host);
  icon(); paint();
  return { get t() { return st.t; }, set(t) { st.t = t; paint(); }, paint, el: wrap };
}

// ------------------------------------------------------------------ flat axonometric
// screen directions of the unit vectors: x runs down-right, y recedes up-right, z is up. The view
// direction (1, -1.679, 1.045) is not a short lattice vector, so no two lattice points coincide.
const AX = [0.94, -0.34], AY = [0.56, 0.42], AZ = [0, 1];
const raw = (p) => [p[0] * AX[0] + p[1] * AY[0] + p[2] * AZ[0], -(p[0] * AX[1] + p[1] * AY[1] + p[2] * AZ[1])];
export const depth = (p) => p[0] - 1.679 * p[1] + 1.045 * p[2];   // larger = nearer the viewer
const NS = 'http://www.w3.org/2000/svg';
const el = (tag, at, parent) => { const e = document.createElementNS(NS, tag); for (const k in at) if (at[k] != null) e.setAttribute(k, at[k]); if (parent) parent.append(e); return e; };
const same = (p, q) => Math.abs(p[0] - q[0]) + Math.abs(p[1] - q[1]) + Math.abs(p[2] - q[2]) < 1e-9;
export const axisTone = (a, b) => (Math.abs(a[2] - b[2]) > 1e-9 ? PAS.blue3 : Math.abs(a[1] - b[1]) > 1e-9 ? PAS.blue2 : PAS.blue);

export class Flat {
  constructor(host, { W = 600, H = 600, label = '' } = {}) {
    this.W = W; this.H = H;
    this.svg = el('svg', { viewBox: `0 0 ${W} ${H}`, class: 'flat', role: 'img', 'aria-label': label }, host);
    this.S = 60; this.cx = W / 2; this.cy = H / 2; this.k = 1;
  }
  /** fit these 3D points (and 2D screen-space extras) into the frame with a margin in px */
  fit(points, margin = 34, box = [0, 0, this.W, this.H]) {
    const q = points.map(raw), xs = q.map((v) => v[0]), ys = q.map((v) => v[1]);
    const x0 = Math.min(...xs), x1 = Math.max(...xs), y0 = Math.min(...ys), y1 = Math.max(...ys);
    const bw = box[2] - box[0], bh = box[3] - box[1];
    this.S = Math.min((bw - 2 * margin) / Math.max(1e-6, x1 - x0), (bh - 2 * margin) / Math.max(1e-6, y1 - y0));
    this.cx = (box[0] + box[2]) / 2 - this.S * (x0 + x1) / 2; this.cy = (box[1] + box[3]) / 2 - this.S * (y0 + y1) / 2;
    this.k = this.S / 60;   // stroke widths scale with the drawing, so small panels stay bold but not blobby
    return this;
  }
  pr(p) { const q = raw(p); return [this.cx + this.S * q[0], this.cy + this.S * q[1]]; }
  clear() { this.svg.replaceChildren(); this.layer = el('g', {}, this.svg); return this; }
  g(parent = this.svg) { return el('g', {}, parent); }
  /** a filled face (plane, curtain, square) with an ink edge */
  quad(corners, { fill = PAS.sky, opacity = 1, stroke = INK, sw = 3, dash, parent } = {}) {
    if (opacity <= 0) return null;
    return el('polygon', { points: corners.map((p) => this.pr(p).map((v) => v.toFixed(1)).join(',')).join(' '), fill, stroke, 'stroke-width': sw, 'stroke-linejoin': 'round', 'stroke-dasharray': dash, opacity }, parent || this.svg);
  }
  /** lattice rods: ink casing with a pastel core, far ones first; joints kept clean.
   * segs: [{a, b, tone?, w?}] (w scales the width) */
  rods(segs, { w = 15, core = 9, parent, opacity = 1 } = {}) {
    const g = el('g', { opacity, 'stroke-linecap': 'round' }, parent || this.svg);
    const kw = this.k;
    const list = segs.map((s, i) => ({ ...s, i, d: depth(lerp(s.a, s.b, 0.5)), tone: s.tone || axisTone(s.a, s.b) }));
    const order = [...list].sort((p, q) => p.d - q.d), drawn = new Set();
    for (const e of order) {
      const s = e.w || 1, [x1, y1] = this.pr(e.a), [x2, y2] = this.pr(e.b);
      el('line', { x1, y1, x2, y2, stroke: e.ink || INK, 'stroke-width': w * s * kw }, g);
      el('line', { x1, y1, x2, y2, stroke: e.tone, 'stroke-width': core * s * kw }, g);
      // a neighbour drawn earlier lost the end of its core under this rod's ink cap: give it back
      for (const o of list) if (o.i !== e.i && drawn.has(o.i)) for (const v of [e.a, e.b]) {
        const far = same(o.a, v) ? o.b : same(o.b, v) ? o.a : null; if (!far) continue;
        const [vx, vy] = this.pr(v), [fx, fy] = this.pr(far), m = Math.hypot(fx - vx, fy - vy), kk = Math.min(1, (w * 0.62 * (o.w || 1) * kw) / m);
        el('line', { x1: vx, y1: vy, x2: vx + (fx - vx) * kk, y2: vy + (fy - vy) * kk, stroke: o.tone, 'stroke-width': core * (o.w || 1) * kw }, g);
      }
      drawn.add(e.i);
    }
    return g;
  }
  /** a polyline of lattice points as rods */
  path(pts, opts = {}) { const segs = []; for (let i = 0; i + 1 < pts.length; i++) segs.push({ a: pts[i], b: pts[i + 1], tone: opts.tone, w: opts.wk }); return this.rods(segs, opts); }
  bead(p, { fill = PAS.verm, r = 9, k = 1, sw = 3, opacity = 1, parent } = {}) {
    if (k <= 0 || opacity <= 0) return null; const [cx, cy] = this.pr(p);
    return el('circle', { cx, cy, r: r * pop(k) * this.k, fill, stroke: INK, 'stroke-width': sw * this.k, opacity }, parent || this.svg);
  }
  ring(p, { r = 11, stroke = INK, sw = 3, fill = PAS.paper, opacity = 1, dash, parent } = {}) {
    if (opacity <= 0) return null; const [cx, cy] = this.pr(p);
    return el('circle', { cx, cy, r: r * this.k, fill, stroke, 'stroke-width': sw * this.k, opacity, 'stroke-dasharray': dash }, parent || this.svg);
  }
  burst(p, k, { r0 = 12, r1 = 44 } = {}) {
    if (k <= 0 || k >= 1) return; const [cx, cy] = this.pr(p);
    el('circle', { cx, cy, r: (r0 + (r1 - r0) * out3(k)) * this.k, fill: 'none', stroke: INK, 'stroke-width': 3 * (1 - k) * this.k, opacity: 1 - k }, this.svg);
  }
  /** a fat arrow from a to b (3D points), ink edged */
  arrow(a, b, { fill = PAS.verm, w = 14, head = 30, k = 1, parent } = {}) {
    if (k <= 0) return null;
    const g = el('g', {}, parent || this.svg), kw = this.k;
    const [x1, y1] = this.pr(a), [X, Y] = this.pr(lerp(a, b, k));
    const ux = X - x1, uy = Y - y1, m = Math.hypot(ux, uy) || 1, nx = ux / m, ny = uy / m, h = Math.min(head * kw, m * 0.6), hw = h * 0.6;
    const bx = X - nx * h, by = Y - ny * h;
    el('line', { x1, y1, x2: bx, y2: by, stroke: INK, 'stroke-width': (w + 7) * kw, 'stroke-linecap': 'round' }, g);
    el('line', { x1, y1, x2: bx, y2: by, stroke: fill, 'stroke-width': w * kw, 'stroke-linecap': 'round' }, g);
    el('polygon', { points: `${X},${Y} ${bx - ny * hw},${by + nx * hw} ${bx + ny * hw},${by - nx * hw}`, fill, stroke: INK, 'stroke-width': 3.5 * kw, 'stroke-linejoin': 'round' }, g);
    return g;
  }
  /** a short math label (numbers, symbols) at a 3D point, offset in px */
  text(p, s, { dx = 0, dy = 0, size = 22, fill = INK, weight = 700, anchor = 'middle', opacity = 1, parent, cls = 'flat-t' } = {}) {
    if (opacity <= 0) return null; const [x, y] = this.pr(p);
    const t = el('text', { x: x + dx * this.k, y: y + dy * this.k, 'font-size': size * this.k, fill, 'font-weight': weight, 'text-anchor': anchor, 'dominant-baseline': 'central', opacity, class: cls }, parent || this.svg);
    t.innerHTML = s; return t;
  }
  /** raw screen-space helpers */
  line2(x1, y1, x2, y2, at = {}, parent) { return el('line', { x1, y1, x2, y2, stroke: INK, 'stroke-width': 3, 'stroke-linecap': 'round', ...at }, parent || this.svg); }
  el(tag, at, parent) { return el(tag, at, parent || this.svg); }
}
