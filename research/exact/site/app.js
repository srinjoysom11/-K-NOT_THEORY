import { DATA } from "./data.js";
import { verticesOf, centre, crossings, arcsOf, foxOK, countColourings, pieces, projAlong } from "./knot.js";

/* ============================================================== utilities */
const NS = "http://www.w3.org/2000/svg";
const $ = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => [...r.querySelectorAll(s)];
const reduced = matchMedia("(prefers-reduced-motion: reduce)").matches;
const el = (tag, attrs = {}, parent) => {
  const e = document.createElementNS(NS, tag);
  for (const [k, v] of Object.entries(attrs)) e.setAttribute(k, v);
  if (parent) parent.appendChild(e);
  return e;
};
const html = (tag, attrs = {}, parent, text) => {
  const e = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs)) e.setAttribute(k, v);
  if (text != null) e.textContent = text;
  if (parent) parent.appendChild(e);
  return e;
};
const fig = (host, vb) => el("svg", { class: "fig", viewBox: vb, preserveAspectRatio: "xMidYMid meet", role: "img" }, host);
const fmt = n => n.toLocaleString("en-US").replace(/,/g, " ");
const sci = n => { const e = Math.floor(Math.log10(n)); return `${(n / 10 ** e).toFixed(1)} × 10${sup(e)}`; };
const sup = e => String(e).split("").map(c => "⁰¹²³⁴⁵⁶⁷⁸⁹"[+c] ?? c).join("");
const roman = n => ["I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","XIII","XIV","XV","XVI"][n - 1];
const cssVar = name => getComputedStyle(document.documentElement).getPropertyValue(name).trim();
const norm = v => { const l = Math.hypot(...v); return v.map(x => x / l); };
const cross3 = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const dot = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
const lerp = (a, b, t) => a + (b - a) * t;
const ease = t => 1 - Math.pow(1 - t, 3);

/* view along direction d (towards the viewer), z up: screen x, screen y (down), depth */
function basis(d) {
  const n = norm(d);
  let up = [0, 0, 1];
  if (Math.abs(dot(n, up)) > 0.995) up = [0, 1, 0];
  const r = norm(cross3(up, n)), u = cross3(n, r);
  return p => [dot(r, p), -dot(u, p), dot(n, p)];
}
const dirFromAngles = (az, el) => [Math.cos(el) * Math.cos(az), Math.cos(el) * Math.sin(az), Math.sin(el)];
const anglesOf = d => { const n = norm(d); return [Math.atan2(n[1], n[0]), Math.asin(n[2])]; };

/* a live knot diagram: projects a polygon along any direction and redraws with correct crossings */
class LiveKnot {
  constructor(svg, V, { gap = 0.2, pad = 1.25, vertices = false, arcs = false, cls = "knot" } = {}) {
    this.svg = svg; this.V = centre(V); this.gap = gap; this.vertices = vertices; this.arcs = arcs; this.cls = cls;
    const R = Math.max(...this.V.map(p => Math.hypot(...p)));
    this.R = R * pad;
    svg.setAttribute("viewBox", `${-this.R} ${-this.R} ${2 * this.R} ${2 * this.R}`);
    this.g = el("g", {}, svg);
    this.top = el("g", {}, svg);
  }
  draw(d, extra) {
    const B = basis(d), P = this.V.map(B), cr = crossings(P);
    const arcs = this.arcs ? arcsOf(cr) : null;
    const ps = pieces(P, cr, this.gap, arcs);
    let s = "";
    for (const q of ps) {
      const style = arcs && this.colour ? ` style="stroke:var(--c${this.colour[q.arc] ?? 0})"` : "";
      s += `<line class="${this.cls}" x1="${q.x1.toFixed(3)}" y1="${q.y1.toFixed(3)}" x2="${q.x2.toFixed(3)}" y2="${q.y2.toFixed(3)}" stroke-width="${(this.R / 60).toFixed(3)}"${style}/>`;
    }
    if (this.vertices) {
      P.forEach((p, i) => { s += `<circle class="${i === 0 ? "origin" : "vx"}" cx="${p[0].toFixed(3)}" cy="${p[1].toFixed(3)}" r="${(this.R / (i === 0 ? 55 : 95)).toFixed(3)}"/>`; });
    }
    this.g.innerHTML = s;
    if (extra) extra(P, cr, this);
    return { P, cr, arcs };
  }
}

/* drag to turn */
function draggable(target, onDrag) {
  let on = false, x = 0, y = 0;
  target.addEventListener("pointerdown", e => { on = true; x = e.clientX; y = e.clientY; target.setPointerCapture(e.pointerId); });
  target.addEventListener("pointermove", e => { if (!on) return; onDrag(e.clientX - x, e.clientY - y); x = e.clientX; y = e.clientY; });
  const end = () => { on = false; };
  target.addEventListener("pointerup", end); target.addEventListener("pointercancel", end);
  target.style.touchAction = "none"; target.style.cursor = "grab";
}

function loop(fn) {
  let id = 0, running = false, t0 = 0;
  const step = t => { if (!running) return; fn((t - t0) / 1000); id = requestAnimationFrame(step); };
  return {
    start() { if (running) return; running = true; t0 = performance.now(); id = requestAnimationFrame(step); },
    stop() { running = false; cancelAnimationFrame(id); },
  };
}

function controls(host) { return html("div", { class: "panel-controls" }, host); }
function chip(host, label, onClick, pressed) {
  const b = html("button", { class: "chip", type: "button" }, host, label);
  if (pressed !== undefined) b.setAttribute("aria-pressed", String(pressed));
  b.addEventListener("click", onClick);
  return b;
}
function readout(host, cls = "readout") { return html("span", { class: cls }, host); }

/* ============================================================== exhibits */
const V36 = verticesOf(DATA.w36);
const EXHIBITS = {};

/* ---------------------------------------------------- hero: the polygon turning (SVG; WebGL in the Cabinet) */
EXHIBITS.hero = host => {
  let gl = null, svgMode = null;
  const box = html("div", { style: "position:absolute;inset:0" }, host);
  const cs = controls(host);
  const info = readout(cs);
  const alignBtn = chip(cs, "Align with the 5₂ diagram", () => align());
  let az = -0.6, elv = 0.62, target = null, spin = !reduced;
  const fixed = anglesOf(DATA.dirFig);

  function buildSVG() {
    box.innerHTML = "";
    const svg = fig(box, "0 0 1 1");
    const k = new LiveKnot(svg, V36, { vertices: true, gap: 0.22 });
    draggable(svg, (dx, dy) => { az -= dx * 0.008; elv = Math.max(-1.3, Math.min(1.3, elv + dy * 0.008)); target = null; spin = false; });
    const L = loop(dt => {
      if (target) {
        az = lerp(az, target[0], 0.06); elv = lerp(elv, target[1], 0.06);
        if (Math.abs(az - target[0]) + Math.abs(elv - target[1]) < 1e-3) { az = target[0]; elv = target[1]; target = null; }
      } else if (spin) az += 0.0028;
      const { cr } = k.draw(dirFromAngles(az, elv));
      info.innerHTML = `<b>${cr.length}</b> crossings in this view`;
    });
    return { start: L.start, stop: L.stop, align() { const a = anglesOf(DATA.dirFig); target = [nearestAngle(az, a[0]), a[1]]; } };
  }
  const nearestAngle = (cur, t) => t + 2 * Math.PI * Math.round((cur - t) / (2 * Math.PI));
  function align() { spin = false; (gl || svgMode).align(); }

  let active = false, mounted = [];
  async function mount() {
    const theme = document.documentElement.dataset.theme;
    if (gl) { gl.dispose(); gl = null; }
    if (svgMode) { svgMode.stop(); svgMode = null; }
    mounted.forEach(m => m.remove()); mounted = [];
    if (theme === "cabinet" && hasGL()) {
      try {
        const mod = await import("./gl.js");
        box.innerHTML = "";
        const card = html("figure", { class: "shadowcard" }, host);
        const cs2 = el("svg", { viewBox: "0 0 1 1", "aria-hidden": "true" }, card);
        html("p", {}, card, "The shadow, drawn");
        gl = await mod.cabinet(box, V36, DATA.dirFig, (n, P) => {
          info.innerHTML = `shadow on the plinth: <b>${n}</b> crossings`;
          const xs = P.map(p => p[0]), ys = P.map(p => p[1]);
          const cx = (Math.min(...xs) + Math.max(...xs)) / 2, cy = (Math.min(...ys) + Math.max(...ys)) / 2;
          const span = Math.max(Math.max(...xs) - Math.min(...xs), Math.max(...ys) - Math.min(...ys)) * 1.12;
          cs2.setAttribute("viewBox", `${cx - span / 2} ${cy - span / 2} ${span} ${span}`);
          const cr = crossings(P);
          cs2.innerHTML = pieces(P, cr, span * 0.03).map(q => `<line x1="${q.x1}" y1="${q.y1}" x2="${q.x2}" y2="${q.y2}" stroke-width="${span / 70}"/>`).join("");
        });
        mounted.push(card);
        if (active) gl.start();
        return;
      } catch (e) { console.warn("WebGL exhibit unavailable, using the drawing", e); }
    }
    svgMode = buildSVG();
    if (active) svgMode.start();
  }
  mount();
  document.addEventListener("themechange", mount);
  return {
    activate() { active = true; (gl || svgMode)?.start(); },
    deactivate() { active = false; (gl || svgMode)?.stop(); },
  };
};
function hasGL() {
  try { const c = document.createElement("canvas"); return !!(c.getContext("webgl2") || c.getContext("webgl")); } catch { return false; }
}

/* ---------------------------------------------------- the walk, step by step */
EXHIBITS.walk = host => {
  const word = html("p", { class: "wordline", "aria-hidden": "true" }, host);
  const letters = [...DATA.w36].map(c => html("span", {}, word, c));
  const svg = fig(host, "0 0 1 1");
  const V = centre(V36);
  const d = [0.9, -1.25, 0.95];
  const B = basis(d), P = V.map(B);
  const R = Math.max(...V.map(p => Math.hypot(...p))) * 1.3;
  svg.setAttribute("viewBox", `${-R} ${-R * 0.92} ${2 * R} ${2 * R}`);
  // faint lattice under the polygon
  const zmin = Math.min(...V.map(p => p[2]));
  const gl = el("g", {}, svg);
  for (let x = -4; x <= 4; x++) for (let y = -4; y <= 4; y++) {
    const a = B([x, y, zmin]), bx = B([x + 1, y, zmin]), by = B([x, y + 1, zmin]);
    if (x < 4) el("line", { class: "grid", x1: a[0], y1: a[1], x2: bx[0], y2: bx[1], "stroke-width": R / 260 }, gl);
    if (y < 4) el("line", { class: "grid", x1: a[0], y1: a[1], x2: by[0], y2: by[1], "stroke-width": R / 260 }, gl);
  }
  const g = el("g", {}, svg);
  const cs = controls(host);
  const r = readout(cs, "readout big");
  let k = 0, playing = false, timer = 0;
  const playBtn = chip(cs, "Play", () => toggle());
  chip(cs, "Step", () => { stop(); step(); });
  chip(cs, "Reset", () => { stop(); k = 0; render(); });
  function render() {
    const n = P.length;
    // the first k edges; crossings among them only
    const pts = P.slice(0, Math.min(k + 1, n));
    if (k >= n) pts.push(P[0]);
    let s = "";
    if (k >= n) {
      const cr = crossings(P);
      for (const q of pieces(P, cr, 0.22)) s += `<line class="knot" x1="${q.x1}" y1="${q.y1}" x2="${q.x2}" y2="${q.y2}" stroke-width="${R / 75}"/>`;
    } else {
      for (let i = 0; i + 1 < pts.length; i++) s += `<line class="knot" x1="${pts[i][0]}" y1="${pts[i][1]}" x2="${pts[i + 1][0]}" y2="${pts[i + 1][1]}" stroke-width="${R / 75}"/>`;
    }
    pts.slice(0, Math.min(k + 1, n)).forEach((p, i) => { s += `<circle class="${i === 0 ? "origin" : "vx"}" cx="${p[0]}" cy="${p[1]}" r="${R / (i === 0 ? 70 : 120)}"/>`; });
    g.innerHTML = s;
    letters.forEach((sp, i) => { sp.className = i < k - 1 ? "on" : i === k - 1 ? "now" : ""; });
    r.innerHTML = k >= n ? `<b>36</b> steps · closed` : `<b>${k}</b> of 36 steps`;
  }
  function step() { if (k < P.length) { k++; render(); } }
  function toggle() { playing ? stop() : play(); }
  function play() {
    if (k >= P.length) k = 0;
    playing = true; playBtn.textContent = "Pause"; playBtn.setAttribute("aria-pressed", "true");
    const tick = () => { step(); if (k < P.length && playing) timer = setTimeout(tick, reduced ? 40 : 220); else stop(); };
    tick();
  }
  function stop() { playing = false; clearTimeout(timer); playBtn.textContent = "Play"; playBtn.setAttribute("aria-pressed", "false"); }
  render();
  return { activate() { if (k === 0) setTimeout(play, 500); }, deactivate: stop };
};

/* ---------------------------------------------------- the knots that were known */
EXHIBITS.known = host => {
  const svg = fig(host, "0 0 1000 520");
  const cells = DATA.known;
  const W = 1000 / cells.length;
  const nums = [];
  cells.forEach((k, i) => {
    const g = el("g", { transform: `translate(${i * W + W / 2} 0)` }, svg);
    const sub = el("svg", { x: -W / 2 + 14, y: 20, width: W - 28, height: 290, overflow: "visible" }, g);
    const V = centre(verticesOf(k.word));
    const B = projAlong(k.dir);
    const P = V.map(B);
    const xs = P.map(p => p[0]), ys = P.map(p => p[1]);
    const cx = (Math.min(...xs) + Math.max(...xs)) / 2, cy = (Math.min(...ys) + Math.max(...ys)) / 2;
    const span = Math.max(Math.max(...xs) - Math.min(...xs), Math.max(...ys) - Math.min(...ys)) * 1.12;
    sub.setAttribute("viewBox", `${cx - span / 2} ${cy - span / 2} ${span} ${span}`);
    const cr = crossings(P);
    for (const q of pieces(P, cr, span * 0.022)) el("line", { class: "knot", x1: q.x1, y1: q.y1, x2: q.x2, y2: q.y2, "stroke-width": span / 85 }, sub);
    el("text", { class: "kn-label", x: 0, y: 356, "text-anchor": "middle" }, g).textContent = k.name;
    const t = el("text", { class: "kn-num", x: 0, y: 414, "text-anchor": "middle" }, g);
    t.textContent = i === 3 ? "≥ ?" : String(k.len);
    nums.push(t);
    el("text", { class: "kn-who", x: 0, y: 450, "text-anchor": "middle" }, g).textContent = i === 3 ? "lower bound open" : `${k.year} · ${k.who}`;
  });
  el("line", { class: "grid", x1: 40, y1: 470, x2: 960, y2: 470 }, svg);
  const cs = controls(host);
  const r = readout(cs);
  r.textContent = "The shortest polygons found by our own search, seen from a well-chosen side.";
  let done = false;
  return {
    activate() {
      if (done) return;
      setTimeout(() => {
        const t = nums[3]; const sub = t.nextSibling;
        t.textContent = "36"; t.classList.add("arrive"); sub.textContent = "2026 · proved here"; done = true;
      }, reduced ? 0 : 1800);
    },
    deactivate() {},
  };
};

/* ---------------------------------------------------- the scale of the problem */
EXHIBITS.scale = host => {
  const svg = fig(host, "0 0 1000 560");
  const x0 = 70, x1 = 940, emax = 19;
  const X = e => x0 + (x1 - x0) * e / emax;
  el("line", { class: "grid", x1: x0, y1: 470, x2: x1, y2: 470 }, svg);
  for (let e = 0; e <= emax; e++) {
    el("line", { class: "grid", x1: X(e), y1: 464, x2: X(e), y2: 476 }, svg);
    if (e % 3 === 0) el("text", { x: X(e), y: 506, "text-anchor": "middle", "font-size": 24 }, svg).textContent = `10${sup(e)}`;
  }
  const rows = [
    { e: 18, label: "lattice polygons with 34 steps (order of magnitude)", cls: "bar-a" },
    { e: Math.log10(DATA.facts.nodes), label: `partial walks the search visited: ${sci(DATA.facts.nodes)}`, cls: "bar-b" },
    { e: Math.log10(Math.max(DATA.facts.words, 1)), label: `walks that obey all seven rules: ${fmt(DATA.facts.words)}`, cls: "bar-b" },
    { e: 0, label: "of them a 5₂: none", cls: "bar-b", zero: true },
  ];
  const bars = rows.map((r, i) => {
    const y = 70 + i * 96;
    const rect = el("rect", { class: r.cls, x: x0, y, height: 30, width: 0, rx: 2 }, svg);
    el("text", { x: x0, y: y - 12, "font-size": 26 }, svg).textContent = r.label;
    return { rect, w: r.zero ? 2 : X(r.e) - x0 };
  });
  const cs = controls(host);
  readout(cs).textContent = "Logarithmic scale: each tick is ten times the one before.";
  return {
    activate() {
      bars.forEach((b, i) => {
        b.rect.animate([{ width: "0px" }, { width: `${b.w}px` }], { duration: reduced ? 1 : 1400, delay: reduced ? 0 : 250 + i * 220, easing: "cubic-bezier(.16,1,.3,1)", fill: "forwards" });
        b.rect.setAttribute("width", b.w);
      });
    },
    deactivate() {},
  };
};

/* ---------------------------------------------------- the two moves (interactive, on a flat grid) */
EXHIBITS.moves = host => {
  const start = [[0,0],[1,0],[2,0],[3,0],[3,1],[4,1],[4,2],[4,3],[3,3],[3,4],[2,4],[1,4],[1,3],[2,3],[2,2],[1,2],[0,2],[0,1]];
  let pts = start.map(p => p.slice()), shown = pts.map(p => p.slice());
  const svg = fig(host, "-1.2 -5.1 6.4 6.4");
  const grid = el("g", {}, svg);
  for (let i = -1; i <= 5; i++) {
    el("line", { class: "grid", x1: i, y1: 1, x2: i, y2: -5, "stroke-width": 0.012 }, grid);
    el("line", { class: "grid", x1: -1, y1: -i, x2: 5, y2: -i, "stroke-width": 0.012 }, grid);
  }
  const ghost = el("g", {}, svg), g = el("g", {}, svg), hit = el("g", {}, svg);
  const cs = controls(host);
  const r = readout(cs, "readout big");
  chip(cs, "Reset", () => { pts = start.map(p => p.slice()); shown = pts.map(p => p.slice()); render(); });
  const key = p => p[0] + "," + p[1];
  const has = p => pts.some(q => q[0] === p[0] && q[1] === p[1]);
  function corners() {
    const n = pts.length, out = [];
    for (let i = 0; i < n; i++) {
      const a = pts[(i - 1 + n) % n], v = pts[i], b = pts[(i + 1) % n];
      const d1 = [v[0] - a[0], v[1] - a[1]], d2 = [b[0] - v[0], b[1] - v[1]];
      if (d1[0] * d2[0] + d1[1] * d2[1] !== 0) continue;
      const w = [a[0] + b[0] - v[0], a[1] + b[1] - v[1]];
      out.push({ i, w, free: !has(w) });
    }
    return out;
  }
  function uturns() {
    const n = pts.length, out = [];
    if (n <= 4) return out;
    for (let i = 0; i < n; i++) {
      const a = pts[(i - 1 + n) % n], b = pts[(i + 2) % n];
      if (Math.abs(a[0] - b[0]) + Math.abs(a[1] - b[1]) === 1) out.push(i);
    }
    return out;
  }
  function render() {
    const n = shown.length;
    let s = `<polygon points="${shown.map(p => `${p[0]},${-p[1]}`).join(" ")}" class="knot" stroke-width="0.07" stroke-linejoin="round"/>`;
    shown.forEach(p => { s += `<circle class="vx" cx="${p[0]}" cy="${-p[1]}" r="0.07"/>`; });
    g.innerHTML = s;
    hit.innerHTML = ""; ghost.innerHTML = "";
    const us = uturns();
    for (const i of us) {
      const a = pts[(i - 1 + n) % n], b = pts[(i + 2) % n];
      const c = el("line", { x1: a[0], y1: -a[1], x2: b[0], y2: -b[1], class: "ghost", "stroke-width": 0.04, "stroke-dasharray": ".1 .08" }, ghost);
      const p1 = pts[i], p2 = pts[(i + 1) % n];
      const zone = el("rect", { x: Math.min(a[0], b[0], p1[0], p2[0]) + 0.08, y: -Math.max(a[1], b[1], p1[1], p2[1]) + 0.08, width: 0.84, height: 0.84, fill: "var(--c2)", "fill-opacity": .14, rx: .05, tabindex: 0, role: "button", "aria-label": "Cut this U-turn" }, hit);
      zone.style.cursor = "pointer";
      const go = () => cut(i);
      zone.addEventListener("click", go); zone.addEventListener("keydown", e => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); go(); } });
    }
    for (const c of corners()) {
      const v = pts[c.i];
      const dot = el("circle", { cx: v[0], cy: -v[1], r: 0.2, fill: c.free ? "var(--accent)" : "var(--alert)", "fill-opacity": c.free ? .22 : .12, stroke: c.free ? "var(--accent)" : "none", "stroke-width": .025, tabindex: 0, role: "button", "aria-label": c.free ? "Flip this corner" : "Blocked corner" }, hit);
      dot.style.cursor = c.free ? "pointer" : "not-allowed";
      const go = () => flip(c);
      dot.addEventListener("click", go); dot.addEventListener("keydown", e => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); go(); } });
    }
    r.innerHTML = `<b>${pts.length}</b> sticks`;
  }
  function animateTo(next, after) {
    const from = shown.map(p => p.slice());
    const t0 = performance.now(), T = reduced ? 1 : 520;
    const f = t => {
      // a lightly damped spring for the moving vertex
      const x = Math.min(1, (t - t0) / T);
      const k = x >= 1 ? 1 : 1 - Math.exp(-6 * x) * Math.cos(9 * x);
      shown = from.map((p, i) => [lerp(p[0], next[i][0], k), lerp(p[1], next[i][1], k)]);
      render0();
      if (x < 1) requestAnimationFrame(f); else { shown = next.map(p => p.slice()); after && after(); render(); }
    };
    requestAnimationFrame(f);
  }
  const render0 = () => {
    let s = `<polygon points="${shown.map(p => `${p[0]},${-p[1]}`).join(" ")}" class="knot" stroke-width="0.07" stroke-linejoin="round"/>`;
    shown.forEach(p => { s += `<circle class="vx" cx="${p[0]}" cy="${-p[1]}" r="0.07"/>`; });
    g.innerHTML = s; hit.innerHTML = "";
  };
  function flip(c) {
    if (!c.free) {
      const v = pts[c.i];
      const b = el("circle", { cx: c.w[0], cy: -c.w[1], r: 0.28, fill: "none", stroke: "var(--alert)", "stroke-width": .05 }, ghost);
      b.animate([{ opacity: 1 }, { opacity: 0 }], { duration: 900, fill: "forwards" });
      r.innerHTML = `<b>blocked</b>: the fourth corner is taken`;
      return;
    }
    const next = pts.map(p => p.slice()); next[c.i] = c.w.slice();
    pts = next; animateTo(next);
  }
  function cut(i) {
    const n = pts.length, a = pts[(i - 1 + n) % n], b = pts[(i + 2) % n];
    // slide the two removed vertices onto the cut, then drop them
    const next = shown.map(p => p.slice());
    next[i] = a.slice(); next[(i + 1) % n] = b.slice();
    animateTo(next, () => { pts = pts.filter((_, k) => k !== i && k !== (i + 1) % n); shown = pts.map(p => p.slice()); });
  }
  render();
  return { activate() {}, deactivate() {} };
};

/* ---------------------------------------------------- the curtain, animated in 3D */
EXHIBITS.curtain = host => {
  const svg = fig(host, "0 0 1 1");
  const d = [1.1, -1.6, 1.25];
  const B = basis(d);
  const base = [[-2, 0, 0], [-1, 0, 0], [0, 0, 0], [0, 0, 1], [1, 0, 1], [2, 0, 1], [2, 1, 1], [2, 1, 0], [3, 1, 0], [4, 1, 0]];
  // vertices 2..7 are v0..v5 of the curtain (a = up, k = 3 sideways steps)
  const rings = [[1, 0, 0], [2, 0, 0]];
  const other = [[1, -2, 0], [1, -1, 0], [1, 0, 0], [1, 1, 0], [1, 2, 0]];   // another strand, used to block
  const proj = p => B([p[0] - 1, p[1], p[2] - 0.4]);
  const R = 4.2;
  svg.setAttribute("viewBox", `${-R} ${-R * 0.75} ${2 * R} ${1.5 * R}`);
  const gCurt = el("g", {}, svg), gGrid = el("g", {}, svg), gOther = el("g", {}, svg), gPath = el("g", {}, svg), gRing = el("g", {}, svg);
  for (let x = -2; x <= 4; x++) for (let y = -2; y <= 2; y++) {
    const a = proj([x, y, 0]);
    if (x < 4) { const b = proj([x + 1, y, 0]); el("line", { class: "grid", x1: a[0], y1: a[1], x2: b[0], y2: b[1], "stroke-width": .012 }, gGrid); }
    if (y < 2) { const b = proj([x, y + 1, 0]); el("line", { class: "grid", x1: a[0], y1: a[1], x2: b[0], y2: b[1], "stroke-width": .012 }, gGrid); }
  }
  const cs = controls(host);
  const r = readout(cs, "readout big");
  const playBtn = chip(cs, "Push the curtain down", () => play());
  const blockBtn = chip(cs, "Put a strand under it", () => { blocked = !blocked; blockBtn.setAttribute("aria-pressed", String(blocked)); reset(); }, false);
  let blocked = false, path = base.map(p => p.slice()), anim = null;
  function draw(curtainOn = true) {
    gPath.innerHTML = ""; gRing.innerHTML = ""; gCurt.innerHTML = ""; gOther.innerHTML = "";
    if (blocked) {
      const P = other.map(proj);
      el("polyline", { points: P.map(p => p[0] + "," + p[1]).join(" "), class: "ghost", "stroke-width": .06, "stroke-dasharray": ".12 .1" }, gOther);
    }
    if (curtainOn && path.length === base.length) {
      // the strip under v1..v4
      const top = path.slice(3, 7), bot = top.map(p => [p[0], p[1], p[2] - 1]);
      const poly = [...top, ...bot.reverse()].map(proj);
      el("polygon", { points: poly.map(p => p[0] + "," + p[1]).join(" "), fill: "var(--accent)", "fill-opacity": .12, stroke: "none" }, gCurt);
    }
    const P = path.map(proj);
    el("polyline", { points: P.map(p => p[0] + "," + p[1]).join(" "), class: "knot", "stroke-width": .085, "stroke-linejoin": "round" }, gPath);
    P.forEach(p => el("circle", { class: "vx", cx: p[0], cy: p[1], r: .065 }, gPath));
    for (const q of rings) {
      const p = proj(q), taken = blocked && q[0] === 1;
      el("circle", { class: "ring" + (taken ? " taken" : ""), cx: p[0], cy: p[1], r: .17, "stroke-width": .03, "stroke-dasharray": taken ? "none" : ".06 .06" }, gRing);
    }
  }
  function tween(from, to, T) {
    return new Promise(res => {
      const t0 = performance.now();
      const f = t => {
        const x = Math.min(1, (t - t0) / (reduced ? 1 : T)), k = ease(x);
        path = from.map((p, i) => p.map((c, j) => lerp(c, to[i][j], k)));
        draw(); if (x < 1) anim = requestAnimationFrame(f); else res();
      };
      anim = requestAnimationFrame(f);
    });
  }
  const sleep = ms => new Promise(r => setTimeout(r, reduced ? 0 : ms));
  async function play() {
    reset(); playBtn.disabled = true;
    const p0 = base.map(p => p.slice());
    r.innerHTML = "flip 1: the up-step slides along";
    await sleep(300);
    if (blocked) {
      r.innerHTML = "<b>blocked</b>: a vertex sits under the curtain";
      const p = proj([1, 0, 0]);
      const x = el("circle", { cx: p[0], cy: p[1], r: .32, fill: "none", stroke: "var(--alert)", "stroke-width": .05 }, gRing);
      x.animate([{ opacity: 0 }, { opacity: 1 }, { opacity: .2 }, { opacity: 1 }], { duration: 1200, fill: "forwards" });
      playBtn.disabled = false; return;
    }
    const p1 = p0.map(p => p.slice()); p1[3] = [1, 0, 0];
    await tween(p0, p1, 700); await sleep(250);
    r.innerHTML = "flip 2";
    const p2 = p1.map(p => p.slice()); p2[4] = [2, 0, 0];
    await tween(p1, p2, 700); await sleep(250);
    r.innerHTML = "U-turn: up, across, down";
    await sleep(500);
    const p3 = p2.map(p => p.slice()); p3[5] = [2, 0, 0]; p3[6] = [2, 1, 0];
    await tween(p2, p3, 700);
    path = p3.filter((_, i) => i !== 5 && i !== 6);
    draw(false);
    r.innerHTML = "<b>two sticks shorter</b>, same knot";
    playBtn.disabled = false;
  }
  function reset() { cancelAnimationFrame(anim); path = base.map(p => p.slice()); draw(); r.innerHTML = blocked ? "a strand passes under the curtain" : "no vertex under the curtain"; }
  reset();
  return { activate() {}, deactivate() { cancelAnimationFrame(anim); } };
};

/* ---------------------------------------------------- the lowest polygon: downward corners all blocked */
EXHIBITS.push = host => {
  const svg = fig(host, "0 0 1 1");
  const W = DATA.w36, n = W.length;
  const V = V36;
  const key = p => p.join(",");
  const set = new Set(V.map(key));
  const U = { e: [1, 0, 0], w: [-1, 0, 0], n: [0, 1, 0], s: [0, -1, 0], u: [0, 0, 1], d: [0, 0, -1] };
  const marks = [];
  for (let i = 1; i < n; i++) {
    const p = W[i - 1], d = W[i];
    const horiz = c => "ewns".includes(c), ew = c => "ew".includes(c);
    if ((p === "u" && horiz(d)) || (d === "d" && horiz(p)) || (p === "n" && ew(d)) || (d === "s" && ew(p))) {
      const a = V[i - 1], v = V[i], b = V[(i + 1) % n];
      const w = [a[0] + b[0] - v[0], a[1] + b[1] - v[1], a[2] + b[2] - v[2]];
      marks.push({ i, w, ok: set.has(key(w)) });
    }
  }
  const zmin = Math.min(...V.map(p => p[2]));
  const psi = V.reduce((s, p) => s + p[2] - zmin, 0);
  const k = new LiveKnot(svg, V, { vertices: true, gap: 0.2 });
  const C = (() => { const c = [0, 1, 2].map(j => (Math.min(...V.map(p => p[j])) + Math.max(...V.map(p => p[j]))) / 2); return p => [p[0] - c[0], p[1] - c[1], p[2] - c[2]]; })();
  let az = -0.9, elv = 0.45, spin = !reduced;
  draggable(svg, (dx, dy) => { az -= dx * 0.008; elv = Math.max(-1.2, Math.min(1.3, elv + dy * 0.008)); spin = false; });
  const cs = controls(host);
  readout(cs, "readout big").innerHTML = `<b>${marks.length}</b> corners could point downwards · <b>${marks.filter(m => m.ok).length}</b> are blocked · Ψ = <b>${psi}</b>`;
  const L = loop(() => {
    if (spin) az += 0.003;
    const B = basis(dirFromAngles(az, elv));
    k.draw(dirFromAngles(az, elv), () => {
      let s = "";
      const sw = k.R / 140;
      for (const m of marks) {
        const v = B(C(V[m.i])), w = B(C(m.w));
        s += `<line x1="${v[0]}" y1="${v[1]}" x2="${w[0]}" y2="${w[1]}" stroke="var(--accent)" stroke-width="${sw}" stroke-dasharray="${sw * 2} ${sw * 2}"/>`;
        s += `<circle cx="${v[0]}" cy="${v[1]}" r="${k.R / 42}" fill="var(--accent)" fill-opacity=".35" stroke="var(--accent)" stroke-width="${sw}"/>`;
        s += `<circle cx="${w[0]}" cy="${w[1]}" r="${k.R / 48}" fill="none" stroke="${m.ok ? "var(--ink)" : "var(--alert)"}" stroke-width="${sw * 1.4}"/>`;
      }
      k.top.innerHTML = s;
    });
  });
  return { activate: L.start, deactivate: L.stop };
};

/* ---------------------------------------------------- the seven rules, each drawn */
EXHIBITS.rules = host => {
  const tray = html("div", { class: "tray" }, host);
  const items = [
    ["C1–C2", "A closed walk that never meets itself.", s => { poly(s, [[1,1],[4,1],[4,3],[3,3],[3,2],[2,2],[2,4],[1,4]], true); }],
    ["C3", "Its lowest vertex sits at the origin.", s => { poly(s, [[1,4],[1,2],[2,2],[2,1],[4,1],[4,4]], true); dot(s, [2, 1], "origin"); hline(s, 1); }],
    ["C4", "It leaves the origin in a fixed direction.", s => { poly(s, [[2,1],[4,1],[4,4],[1,4],[1,2],[2,2]], true); dot(s, [2, 1], "origin"); arrow(s, [2, 1], [3.2, 1]); }],
    ["C5", "Fewest steps up–down, most east–west.", s => { rods(s, [1.6, 2.6, 3.6]); }],
    ["C6", "A vertex under every curtain.", s => { poly(s, [[0.6,1],[1,1],[1,3],[3,3],[3,1],[3.4,1]]); ring(s, [2, 1], true); }],
    ["C7", "Every downward corner is blocked.", s => { poly(s, [[1,4],[1,3],[3,3]]); ring(s, [1, 2], false); poly(s, [[0.5,2],[1.6,2]]); dot(s, [1, 2], "vx"); }],
    ["⇒", `If 5₂ had a polygon with 34 steps or fewer, one would obey all seven. ${fmt(DATA.facts.words)} walks do; this 24-step trefoil is one of them.`, s => { survivor(s); }],
  ];
  function svgIn(f) { return el("svg", { class: "fig mini", viewBox: "0 0 5 5", "aria-hidden": "true" }, f); }
  function poly(s, pts, closed) { el(closed ? "polygon" : "polyline", { points: pts.map(p => `${p[0]},${5 - p[1]}`).join(" "), class: "knot", "stroke-width": .16, "stroke-linejoin": "round", fill: "none" }, s); }
  function dot(s, p, cls) { el("circle", { cx: p[0], cy: 5 - p[1], r: .22, class: cls }, s); }
  function ring(s, p, taken) { el("circle", { cx: p[0], cy: 5 - p[1], r: .3, class: "ring" + (taken ? " taken" : ""), "stroke-width": .08, "stroke-dasharray": taken ? "none" : ".12 .1" }, s); }
  function hline(s, y) { el("line", { x1: .3, y1: 5 - y + .35, x2: 4.7, y2: 5 - y + .35, class: "ghost", "stroke-width": .06, "stroke-dasharray": ".15 .12" }, s); }
  function arrow(s, a, b) { el("line", { x1: a[0], y1: 5 - a[1], x2: b[0], y2: 5 - b[1], stroke: "var(--accent)", "stroke-width": .14 }, s); el("path", { d: `M${b[0]} ${5 - b[1] - .25} L${b[0] + .35} ${5 - b[1]} L${b[0]} ${5 - b[1] + .25}z`, fill: "var(--accent)" }, s); }
  function bars(s, h) { h.forEach((v, i) => el("rect", { x: .8 + i * 1.3, y: 4.6 - v, width: .8, height: v, fill: `var(--c${[2, 1, 0][i]})` }, s)); ["z", "y", "x"].forEach((t, i) => el("text", { x: 1.2 + i * 1.3, y: 4.95, "text-anchor": "middle", "font-size": .45 }, s).textContent = t); }
  function rods(s, h) {
    h.forEach((v, i) => {
      const x = 1 + i * 1.5;
      el("line", { x1: x, y1: 4.3, x2: x, y2: 4.3 - v, class: "knot", "stroke-width": .26 }, s);
      el("circle", { cx: x, cy: 4.3 - v, r: .2, class: "vx" }, s);
      el("text", { x, y: 4.95, "text-anchor": "middle", "font-size": .5 }, s).textContent = ["z", "y", "x"][i];
    });
  }
  function survivor(s) {
    s.setAttribute("viewBox", "0 0 10 5");
    const V = centre(verticesOf(DATA.tref)), P = V.map(projAlong(DATA.trefDir));
    const xs = P.map(p => p[0]), ys = P.map(p => p[1]);
    const span = Math.max(Math.max(...xs) - Math.min(...xs), Math.max(...ys) - Math.min(...ys));
    const k = 4.4 / span, cx = (Math.min(...xs) + Math.max(...xs)) / 2, cy = (Math.min(...ys) + Math.max(...ys)) / 2;
    const Q = P.map(p => [5 + (p[0] - cx) * k, 2.5 + (p[1] - cy) * k, p[2]]);
    for (const q of pieces(Q, crossings(Q), .12)) el("line", { class: "knot", x1: q.x1, y1: q.y1, x2: q.x2, y2: q.y2, "stroke-width": .11 }, s);
  }
  for (const [t, c, draw] of items) {
    const f = html("figure", t === "⇒" ? { class: "wide" } : {}, tray);
    draw(svgIn(f));
    const cap = html("figcaption", {}, f);
    html("b", {}, cap, t); cap.append(c);
  }
  return { activate() {}, deactivate() {} };
};

/* ---------------------------------------------------- a miniature search on the square grid */
EXHIBITS.search = host => {
  const canvas = html("canvas", {}, host);
  const cs = controls(host);
  const r = readout(cs, "readout big");
  const speedBtn = chip(cs, "Faster", () => { fast = !fast; speedBtn.setAttribute("aria-pressed", String(fast)); }, false);
  chip(cs, "Restart", () => restart());
  let fast = false;
  const N = 12;   // closed walks of 12 steps on the square grid
  const D = [[1, 0], [-1, 0], [0, 1], [0, -1]];
  let gen, stats, found, current, flash, timer = 0, running = false;
  function* dfs() {
    // canonical: start at the lowest-leftmost vertex: every later vertex is above, or level and to the right
    const path = [[0, 0]], dirs = [], seen = new Set(["0,0"]);
    function* rec() {
      const i = dirs.length, R = N - i, cur = path[path.length - 1];
      for (let d = 0; d < 4; d++) {
        if (i >= 1 && d === (dirs[i - 1] ^ 1)) continue;
        const nx = [cur[0] + D[d][0], cur[1] + D[d][1]];
        if (R === 1) {
          if (nx[0] === 0 && nx[1] === 0) { stats.closed++; found.push(path.map(p => p.slice())); current = { path, try: nx, ok: true, why: "closed" }; yield; }
          continue;
        }
        stats.tried++;
        let why = null;
        if (nx[1] < 0 || (nx[1] === 0 && nx[0] <= 0)) why = "below the root";
        else if (seen.has(nx.join(","))) why = "meets itself";
        else if (Math.abs(nx[0]) + Math.abs(nx[1]) > R - 1) why = "too far from home";
        else if (i >= 2 && d === (dirs[i - 2] ^ 1) && (dirs[i - 1] >> 1) !== (d >> 1)) why = "U-turn";
        current = { path, try: nx, ok: !why, why };
        if (why) { stats[why] = (stats[why] || 0) + 1; yield; continue; }
        stats.visited++;
        path.push(nx); dirs.push(d); seen.add(nx.join(","));
        yield;
        yield* rec();
        path.pop(); dirs.pop(); seen.delete(nx.join(","));
      }
    }
    yield* rec();
  }
  function restart() { stats = { tried: 0, visited: 0, closed: 0 }; found = []; current = null; gen = dfs(); }
  function frame() {
    if (!running) return;
    const steps = fast ? 60 : 2;
    for (let s = 0; s < steps; s++) { if (gen.next().done) { restart(); break; } }
    paint();
    timer = setTimeout(() => requestAnimationFrame(frame), fast ? 16 : 70);
  }
  function paint() {
    const dpr = Math.min(devicePixelRatio || 1, 2), w = canvas.clientWidth, h = canvas.clientHeight;
    if (canvas.width !== w * dpr) { canvas.width = w * dpr; canvas.height = h * dpr; }
    const c = canvas.getContext("2d"); c.setTransform(dpr, 0, 0, dpr, 0, 0); c.clearRect(0, 0, w, h);
    const ink = cssVar("--ink"), soft = cssVar("--ink-soft"), acc = cssVar("--accent"), alert = cssVar("--alert"), rule = cssVar("--rule");
    const S = Math.min(w / 15, h / 8), ox = w * 0.5 - 0.5 * S, oy = h * 0.5 + 3 * S;
    c.strokeStyle = rule; c.lineWidth = 1;
    for (let x = -6; x <= 7; x++) { c.beginPath(); c.moveTo(ox + x * S, oy); c.lineTo(ox + x * S, oy - 6 * S); c.stroke(); }
    for (let y = 0; y <= 6; y++) { c.beginPath(); c.moveTo(ox - 6 * S, oy - y * S); c.lineTo(ox + 7 * S, oy - y * S); c.stroke(); }
    // found polygons as faint ghosts
    c.globalAlpha = 0.12; c.strokeStyle = acc; c.lineWidth = 2;
    for (const f of found.slice(-12)) { c.beginPath(); f.forEach((p, i) => (i ? c.lineTo : c.moveTo).call(c, ox + p[0] * S, oy - p[1] * S)); c.closePath(); c.stroke(); }
    c.globalAlpha = 1;
    if (current) {
      const p = current.path;
      c.strokeStyle = ink; c.lineWidth = 3; c.lineJoin = "round"; c.beginPath();
      p.forEach((q, i) => (i ? c.lineTo : c.moveTo).call(c, ox + q[0] * S, oy - q[1] * S)); c.stroke();
      const last = p[p.length - 1], t = current.try;
      c.strokeStyle = current.ok ? acc : alert; c.setLineDash(current.ok ? [] : [5, 5]); c.lineWidth = 3;
      c.beginPath(); c.moveTo(ox + last[0] * S, oy - last[1] * S); c.lineTo(ox + t[0] * S, oy - t[1] * S); c.stroke(); c.setLineDash([]);
      c.fillStyle = cssVar("--origin"); c.beginPath(); c.arc(ox, oy, 5, 0, 7); c.fill();
      if (!current.ok) {
        c.fillStyle = alert; c.font = `600 14px ${cssVar("--font-num")}`;
        const tw = c.measureText(current.why).width;
        c.fillText(current.why, Math.max(6, Math.min(w - tw - 6, ox + t[0] * S + 8)), Math.max(16, oy - t[1] * S - 8));
      }
    }
    r.innerHTML = `<b>${fmt(stats.visited)}</b> steps taken · <b>${fmt(stats.tried - stats.visited)}</b> cut off · <b>${fmt(stats.closed)}</b> closed walks found`;
  }
  restart();
  return {
    activate() { running = true; frame(); },
    deactivate() { running = false; clearTimeout(timer); },
  };
};

/* ---------------------------------------------------- 1358 drawers */
EXHIBITS.drawers = host => {
  const wall = html("div", { class: "wall" }, host);
  const rows = DATA.runs.filter(r => r.n >= 4);
  for (const r of rows) {
    html("span", { class: "n" }, wall, `n = ${r.n}`);
    const cells = html("div", { class: "cells", title: `n = ${r.n}: ${r.done} of ${r.parts} parts · ${fmt(r.words)} words · ${fmt(r.nodes)} nodes` }, wall);
    cells.style.setProperty("--cw", r.parts > 600 ? "7px" : r.parts > 100 ? "8px" : "11px");
    for (const ch of r.cells) html("i", { class: ch === "." ? "" : ch }, cells);
  }
  const lg = html("div", { class: "legend" }, wall);
  lg.innerHTML = `<span><i style="background:var(--accent)"></i>checked in the container</span><span><i style="background:var(--c2)"></i>checked on GitHub Actions</span><span><i style="background:var(--rule)"></i>not in yet</span>`;
  const cs = controls(host);
  readout(cs, "readout big").innerHTML = `<b>${fmt(DATA.facts.partsDone)}</b> of ${fmt(DATA.facts.parts)} parts · <b>${sci(DATA.facts.nodes)}</b> search nodes`;
  return { activate() {}, deactivate() {} };
};

/* ---------------------------------------------------- colouring puzzles */
function colouringExhibit(host, word, D, opts) {
  const svg = fig(host, "0 0 1 1");
  const V = centre(verticesOf(word));
  const P = V.map(projAlong(D));
  const cr = crossings(P), arcs = arcsOf(cr);
  const xs = P.map(p => p[0]), ys = P.map(p => p[1]);
  const span = Math.max(Math.max(...xs) - Math.min(...xs), Math.max(...ys) - Math.min(...ys)) * 1.2;
  const cx = (Math.min(...xs) + Math.max(...xs)) / 2, cy = (Math.min(...ys) + Math.max(...ys)) / 2;
  svg.setAttribute("viewBox", `${cx - span / 2} ${cy - span * 0.42} ${span} ${span * 1.12}`);
  const gap = span * 0.034, sw = span / 120;
  const ps = pieces(P, cr, gap, arcs);
  let p = opts.p ?? 7;
  let x = new Array(arcs.count).fill(0);
  const gArcs = el("g", {}, svg), gX = el("g", {}, svg);
  const groups = [];
  for (let a = 0; a < arcs.count; a++) {
    const g = el("g", { tabindex: 0, role: "button", "aria-label": `Arc ${a + 1}: change colour` }, gArcs);
    g.style.cursor = "pointer";
    for (const q of ps.filter(q => q.arc === a)) {
      el("line", { x1: q.x1, y1: q.y1, x2: q.x2, y2: q.y2, stroke: "transparent", "stroke-width": sw * 5, "stroke-linecap": "round" }, g);
      el("line", { class: "knot arcline", x1: q.x1, y1: q.y1, x2: q.x2, y2: q.y2, "stroke-width": sw * 1.6 }, g);
    }
    const bump = () => { x[a] = (x[a] + 1) % p; paint(); };
    g.addEventListener("click", bump);
    g.addEventListener("keydown", e => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); bump(); } });
    groups.push(g);
  }
  const marks = cr.map(c => {
    const a = P[c.i], b = P[(c.i + 1) % P.length];
    return el("circle", { cx: a[0] + c.t * (b[0] - a[0]), cy: a[1] + c.t * (b[1] - a[1]), r: span * 0.016, "stroke-width": sw * 0.8 }, gX);
  });
  const cs = controls(host);
  const r = readout(cs, "readout big");
  const eqs = html("div", { class: "readout eqs" }, host);
  const names = "ABCDEFGH";
  function paint() {
    groups.forEach((g, a) => $$(".arcline", g).forEach(l => l.style.stroke = `var(--c${x[a] % 7})`));
    let ok = 0;
    arcs.rows.forEach((row, i) => {
      const good = foxOK(row, x, p); ok += good;
      marks[i].setAttribute("fill", good ? "var(--ink)" : "none");
      marks[i].setAttribute("stroke", good ? "var(--ink)" : "var(--alert)");
    });
    const nonconst = x.some(v => v !== x[0]);
    const all = ok === arcs.rows.length;
    r.innerHTML = `<b>${ok}</b> of ${arcs.rows.length} crossing rules hold` + (all ? (nonconst ? ` · <b>a colouring that is not one colour</b>` : ` · all one colour`) : "");
    eqs.innerHTML = arcs.rows.map(row => `2·${names[row.over]} ≡ ${names[row.inA]} + ${names[row.outA]}`).join("<br>") + `<br>(mod ${p})`;
  }
  const api = { set(v) { x = v.slice(); paint(); }, setP(q) { p = q; x = x.map(v => v % q); paint(); }, arcs, get x() { return x; } };
  opts.controls(cs, api, r);
  paint();
  return api;
}

EXHIBITS.colour52 = host => {
  let api;
  api = colouringExhibit(host, DATA.w36, DATA.dirCol, {
    controls(cs, a, r) {
      chip(cs, "All one colour", () => a.set(new Array(a.arcs.count).fill(3)));
      chip(cs, "Show another way", () => {
        let v = DATA.colouring.slice(0, a.arcs.count);
        if (!a.arcs.rows.every(row => foxOK(row, v, 7))) v = countColourings(a.arcs, 7).nonconst;
        a.set(v);
      });
      chip(cs, "Count every way", () => {
        const { total } = countColourings(a.arcs, 7);
        r.innerHTML = `<b>${total}</b> colourings of this drawing (7⁵ = 16 807 tried)`;
      });
    },
  });
  return { activate() {}, deactivate() {} };
};

EXHIBITS.colourTref = host => {
  colouringExhibit(host, DATA.tref, DATA.trefDir, {
    p: 7,
    controls(cs, a, r) {
      const b3 = chip(cs, "Count in threes", () => { a.setP(3); b3.setAttribute("aria-pressed", "true"); b7.setAttribute("aria-pressed", "false"); count(3); }, false);
      const b7 = chip(cs, "Count in sevens", () => { a.setP(7); b7.setAttribute("aria-pressed", "true"); b3.setAttribute("aria-pressed", "false"); count(7); }, true);
      function count(p) {
        const { total, nonconst } = countColourings(a.arcs, p);
        if (nonconst) a.set(nonconst);
        r.innerHTML = p === 3 ? `<b>${total}</b> colourings with 3 colours: a trefoil` : `<b>${total}</b> colourings with 7 colours: only one colour at a time, so not 5₂`;
      }
    },
  });
  return { activate() {}, deactivate() {} };
};

/* ---------------------------------------------------- what Lean checked */
EXHIBITS.lean = host => {
  const svg = fig(host, "0 0 1000 560");
  const defs = el("defs", {}, svg);
  const m = el("marker", { id: "arr", viewBox: "0 0 10 10", refX: 9, refY: 5, markerWidth: 7, markerHeight: 7, orient: "auto-start-reverse" }, defs);
  el("path", { d: "M0 0 L10 5 L0 10z", fill: "var(--ink-soft)" }, m);
  const N = {
    spec: { x: 40, y: 40, w: 250, t: "Definitions", s: "polygons · rules · diagrams", cls: "s",
      code: "IsPolygon w, Survive w (C1–C7), KnotClass T, diagram D w, foxRows, CompCert", info: "The statement: what a reader must read. Spec.lean, Diagram.lean, Statement.lean, Cert.lean." },
    cls: { x: 40, y: 230, w: 250, t: "Classical knot theory", s: "Δ-moves · Wirtinger", cls: "c",
      code: "KnotClass T   TopHyp T", info: "Proved in the text: square moves are pairs of Δ-moves; Fox colourings count homomorphisms to D₇." },
    nf: { x: 380, y: 40, w: 260, t: "exists_survivor", s: "normal form, 1312 lines", cls: "k",
      code: "KnotClass T → T w₀ → ∃ w, T w ∧ |w| ≤ |w₀| ∧ (|w| = 4 ∨ Survive w)", info: "Kernel-checked. Uses only the moves: minimal length, lowest polygon, canonical position." },
    sc: { x: 380, y: 160, w: 260, t: "search_complete", s: "the real program, 1736 lines", cls: "k",
      code: "Survive w → |w| ≤ 34 → w ∈ (searchPart |w| 9 M r).out", info: "Kernel-checked about the very program that was run. No test can cut off a word that obeys the seven rules." },
    cc: { x: 380, y: 280, w: 260, t: "colorCheck_sound", s: "certificates", cls: "k",
      code: "colorCheck w = true → ∃ D, regular ∧ ¬ HasNontrivialColoring D w", info: "Kernel-checked. A certificate L with L·F ≡ E forces every 7-colouring to be constant." },
    cp: { x: 720, y: 160, w: 240, t: "CompCert", s: "1358 checks, all true", cls: "t",
      code: "∀ n r, checkPart n r = true", info: "Evaluated by the compiled program (checkpart). Logged with exit status, hashes and the commit; cross-checked by an independent C++ program." },
    main: { x: 330, y: 440, w: 360, t: "no_short", s: "T w → 36 ≤ |w|", cls: "m",
      code: "theorem no_short (T) (hT : KnotClass T) (hTop : TopHyp T) (hComp : CompCert) : ∀ w, T w → 36 ≤ w.length", info: "The main theorem. #print axioms: propext, Classical.choice, Quot.sound." },
  };
  const H = 80;
  const centreOf = k => [N[k].x + N[k].w / 2, N[k].y + H / 2];
  const edges = [["spec", "nf"], ["spec", "sc"], ["spec", "cc"], ["cls", "main"], ["nf", "main"], ["sc", "main"], ["cc", "main"], ["cp", "main"], ["sc", "cp"]];
  for (const [a, b] of edges) {
    const A = centreOf(a), B = centreOf(b);
    const end = [B[0], N[b].y + (B[1] > A[1] ? 0 : H)];
    const start = [A[0], N[a].y + (B[1] > A[1] ? H : 0)];
    const dpath = Math.abs(A[1] - B[1]) < 5 ? `M${N[a].x + N[a].w} ${A[1]} L${N[b].x} ${B[1]}` : `M${start[0]} ${start[1]} C${start[0]} ${(start[1] + end[1]) / 2} ${end[0]} ${(start[1] + end[1]) / 2} ${end[0]} ${end[1]}`;
    el("path", { class: "edge", d: dpath }, svg);
    if (b === "main") el("path", { class: "flow", d: dpath }, svg);
  }
  const box = html("div", { class: "leanbox" }, host);
  const show = k => {
    $$(".node", svg).forEach(n => n.classList.toggle("sel", n.dataset.k === k));
    box.innerHTML = `${N[k].info}<code>${N[k].code}</code>`;
  };
  for (const [k, n] of Object.entries(N)) {
    const g = el("g", { class: `node ${n.cls}`, "data-k": k, tabindex: 0, role: "button", "aria-label": n.t }, svg);
    el("rect", { x: n.x, y: n.y, width: n.w, height: H }, g);
    el("text", { x: n.x + 16, y: n.y + 34, "font-family": k === "spec" || k === "cls" ? "" : "ui-monospace, Menlo, monospace" }, g).textContent = n.t;
    el("text", { class: "sub", x: n.x + 16, y: n.y + 58 }, g).textContent = n.s;
    g.addEventListener("click", () => show(k));
    g.addEventListener("keydown", e => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); show(k); } });
  }
  show("main");
  return { activate() {}, deactivate() {} };
};

/* ---------------------------------------------------- the making of */
EXHIBITS.timeline = host => {
  const box = html("div", { class: "tl" }, host);
  const ol = html("ol", {}, box);
  const items = [
    ["13–14 Nov", "A fast search, with two extra lemmas", "C++ enumerator with a plane-crossing lemma (prime knots only). Reproduces Len 24, 30, 34 and the published counts of shortest polygons, 3328 and 3648 and 6672."],
    ["15 Nov, early", "5₂ appears at length 36", "Lengths 32–36 on GitHub Actions. The 1012 5₂ words at 36 rebuild 114 912 polygons, the known number. Evidence, not yet proof."],
    ["15 Nov", "The goal changes: no holes", "Every lemma we cannot fully check is dropped. The search must use only the seven rules, which hold for every knot."],
    ["15 Nov", "The search is rewritten for Lean", "Node for node identical to the C++ program — after catching a corner test one vertex too early.", "fix"],
    ["15 Nov", "Three proofs in parallel", "Agents prove the normal form, the colour certificates and the PD identification, then the completeness of the search: 1736 lines."],
    ["Review, round 1", "Two fatal and nine major objections", "Truncated outputs could pass; glue code was trusted silently; colour invariance leaned on the hard direction of Reidemeister. Fixed: one Boolean per part, a knot-group proof.", "fix"],
    ["Review, round 2", "Provenance", "Local runs named the wrong commit; GitHub runs lacked a trace. Fixed: source hashes before every build, bot commits that name the run.", "fix"],
    ["15–16 Nov", "1358 checks", DATA.facts.partsDone === DATA.facts.parts
      ? "Container for lengths up to 32, GitHub's free runners for length 34. Every part true. An independent C++ run agrees."
      : `Container for lengths up to 32, GitHub's free runners for length 34. ${fmt(DATA.facts.partsDone)} of 1358 parts are in, all true; the rest are running.`],
  ];
  const lis = items.map(([t, h, p, cls]) => {
    const li = html("li", cls ? { class: cls } : {}, ol);
    html("time", {}, li, t); html("h3", {}, li, h); html("p", {}, li, p);
    return li;
  });
  let shown = false;
  return {
    activate() { if (shown) return; shown = true; lis.forEach((li, i) => setTimeout(() => li.classList.add("in"), reduced ? 0 : 120 + i * 160)); },
    deactivate() {},
  };
};

/* ---------------------------------------------------- finale: the polygon turns into the 5₂ diagram */
EXHIBITS.finale = host => {
  const svg = fig(host, "0 0 1 1");
  const k = new LiveKnot(svg, V36, { vertices: false, gap: 0.24, arcs: true });
  const cs = controls(host);
  const r = readout(cs, "readout big");
  const target = anglesOf(DATA.dirCol);
  let t = 0, colour = null;
  const L = loop(dt => {
    t = Math.min(1, dt / 4.5);
    const e = ease(t);
    const az = lerp(target[0] - 2.4, target[0], e), elv = lerp(0.1, target[1], e);
    if (t >= 1 && !colour) {
      const P = centre(V36).map(basis(dirFromAngles(az, elv)));
      colour = countColourings(arcsOf(crossings(P)), 7).nonconst;
    }
    k.colour = t >= 1 ? colour : null;
    const { cr } = k.draw(dirFromAngles(az, elv));
    r.innerHTML = t < 1 ? `<b>${cr.length}</b> crossings` : `<b>5</b> crossings · the standard 5₂ diagram, in a colouring that is not one colour`;
    if (t >= 1) L.stop();
  });
  return { activate() { L.stop(); if (reduced) { t = 1; } L.start(); }, deactivate: L.stop };
};

/* ============================================================== the deck */
const chapters = $$(".chapter");
const rail = $("#rail");
const instances = new Map();
let current = -1;

chapters.forEach((ch, i) => {
  const li = html("li", {}, rail);
  const b = html("button", { type: "button", "aria-label": ch.dataset.title }, li);
  html("span", { class: "tip" }, b, ch.dataset.title);
  b.addEventListener("click", () => go(i));
  const ex = $(".exhibit", ch);
  ex.dataset.cat = `Cat. 5₂ · ${String(i + 1).padStart(2, "0")}`;
  ex.dataset.plate = `PLATE ${roman(i + 1)}`;
});
$("#where-total").textContent = chapters.length;

function instance(i) {
  if (!instances.has(i)) {
    const ex = $(".exhibit", chapters[i]);
    const make = EXHIBITS[ex.dataset.exhibit];
    instances.set(i, make ? make(ex) : { activate() {}, deactivate() {} });
  }
  return instances.get(i);
}

function go(i, { push = true } = {}) {
  i = Math.max(0, Math.min(chapters.length - 1, i));
  if (i === current) return;
  if (current >= 0) { chapters[current].classList.remove("is-active"); instances.get(current)?.deactivate(); }
  current = i;
  const ch = chapters[i];
  ch.classList.add("is-active");
  instance(i).activate();
  // warm the next exhibit
  if (i + 1 < chapters.length) setTimeout(() => instance(i + 1), 400);
  $$("#rail button").forEach((b, k) => { if (k === i) b.setAttribute("aria-current", "step"); else b.removeAttribute("aria-current"); });
  $("#where-n").textContent = i + 1;
  $("#where-title").textContent = ch.dataset.title;
  $(".nav.prev").disabled = i === 0;
  $(".nav.next").disabled = i === chapters.length - 1;
  if (push) history.replaceState(null, "", "#" + ch.id);
}

document.addEventListener("click", e => {
  const t = e.target.closest("[data-go]");
  if (!t) return;
  if (t.dataset.go === "next") go(current + 1);
  if (t.dataset.go === "prev") go(current - 1);
});
document.addEventListener("keydown", e => {
  if (e.target.closest("input, textarea, select, summary, [role=button], button")) {
    if (!["ArrowRight", "ArrowLeft", "PageDown", "PageUp"].includes(e.key)) return;
  }
  if (["ArrowRight", "PageDown"].includes(e.key) || (e.key === " " && !e.target.closest("button, [role=button], summary"))) { e.preventDefault(); go(current + 1); }
  else if (["ArrowLeft", "PageUp"].includes(e.key)) { e.preventDefault(); go(current - 1); }
  else if (e.key === "Home") go(0);
  else if (e.key === "End") go(chapters.length - 1);
});
window.addEventListener("hashchange", () => { const i = chapters.findIndex(c => "#" + c.id === location.hash); if (i >= 0) go(i, { push: false }); });
document.addEventListener("visibilitychange", () => { const x = instances.get(current); if (!x) return; document.hidden ? x.deactivate() : x.activate(); });

/* the theorem is stated as proved only when every part of the computation is in */
document.documentElement.dataset.proof = DATA.facts.partsDone === DATA.facts.parts ? "done" : "open";

/* facts filled from the data */
$$("[data-fact]").forEach(n => {
  const f = n.dataset.fact, v = DATA.facts[f];
  n.textContent = f === "nodes" ? sci(v) : fmt(v);
});

/* ============================================================== flavours */
const NOTE_LABEL = { cabinet: "Curator's note", plates: "Commentary", canon: "For the expert" };
function applyTheme(t) {
  document.documentElement.dataset.theme = t;
  $$("[data-set-theme]").forEach(b => b.setAttribute("aria-checked", String(b.dataset.setTheme === t)));
  $$(".note summary").forEach(s => s.textContent = NOTE_LABEL[t]);
  try { localStorage.setItem("len52-theme", t); } catch {}
  document.dispatchEvent(new Event("themechange"));
}
$$("[data-set-theme]").forEach(b => b.addEventListener("click", e => {
  const t = b.dataset.setTheme;
  if (t === document.documentElement.dataset.theme) return;
  const r = b.getBoundingClientRect();
  document.documentElement.style.setProperty("--vx", `${r.left + r.width / 2}px`);
  document.documentElement.style.setProperty("--vy", `${r.top + r.height / 2}px`);
  if (document.startViewTransition && !reduced) document.startViewTransition(() => applyTheme(t));
  else applyTheme(t);
}));
let saved = null;
try { saved = localStorage.getItem("len52-theme"); } catch {}
const qs = new URLSearchParams(location.search).get("style");
applyTheme(["cabinet", "plates", "canon"].includes(qs) ? qs : (["cabinet", "plates", "canon"].includes(saved) ? saved : "cabinet"));

const start = chapters.findIndex(c => "#" + c.id === location.hash);
go(start >= 0 ? start : 0, { push: false });
