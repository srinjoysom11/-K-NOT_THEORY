import { DATA } from "./data.js";
import { verticesOf, centre, crossings, arcsOf, foxOK, countColourings, pieces, projAlong } from "./knot.js";
import { createStage, viewOf, anglesOf, project, hexToRGB } from "./stage.js";

/* ============================================================== utilities */
const NS = "http://www.w3.org/2000/svg";
const $ = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => [...r.querySelectorAll(s)];
const QS = new URLSearchParams(location.search);
const reduced = matchMedia("(prefers-reduced-motion: reduce)").matches;
const forceSVG = QS.has("nogl");
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
const fig = (host, vb) => el("svg", { class: "fig", viewBox: vb, preserveAspectRatio: "xMidYMid meet", "aria-hidden": "true" }, host);
const fmt = n => n.toLocaleString("en-US").replace(/,/g, " ");
const sup = e => String(e).split("").map(c => "⁰¹²³⁴⁵⁶⁷⁸⁹"[+c] ?? c).join("");
const sci = n => { const e = Math.floor(Math.log10(n)); return `${(n / 10 ** e).toFixed(1)} × 10${sup(e)}`; };
const roman = n => ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "XVI"][n - 1];
const cssVar = (name, node = document.documentElement) => getComputedStyle(node).getPropertyValue(name).trim();
const norm = v => { const l = Math.hypot(...v); return v.map(x => x / l); };
const cross3 = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const dot = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
const lerp = (a, b, t) => a + (b - a) * t;
const clamp = (x, a = 0, b = 1) => Math.max(a, Math.min(b, x));
const ease = t => 1 - Math.pow(1 - t, 3);
const inOut = t => t < .5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
const ramp = (x, a, b) => clamp((x - a) / (b - a));
const nearestAngle = (cur, t) => t + 2 * Math.PI * Math.round((cur - t) / (2 * Math.PI));

/* view along direction d (towards the viewer), z up: screen x, screen y (down), depth */
function basis(d) {
  const n = norm(d);
  let up = [0, 0, 1];
  if (Math.abs(dot(n, up)) > 0.995) up = [0, 1, 0];
  const r = norm(cross3(up, n)), u = cross3(n, r);
  return p => [dot(r, p), -dot(u, p), dot(n, p)];
}

/* drag to turn; vertical touches still scroll the page */
function draggable(target, onDrag) {
  let on = false, x = 0, y = 0;
  target.addEventListener("pointerdown", e => { on = true; x = e.clientX; y = e.clientY; try { target.setPointerCapture(e.pointerId); } catch {} });
  target.addEventListener("pointermove", e => { if (!on) return; onDrag(e.clientX - x, e.clientY - y, e); x = e.clientX; y = e.clientY; });
  const end = () => { on = false; };
  target.addEventListener("pointerup", end); target.addEventListener("pointercancel", end);
}

function loop(fn) {
  let id = 0, running = false, t0 = 0;
  let last = 0;
  const step = t => { if (!running) return; const dt = Math.min(0.06, Math.max(0, (t - last) / 1000)); last = t; fn((t - t0) / 1000, dt); id = requestAnimationFrame(step); };
  return {
    start() { if (running) return; running = true; t0 = last = performance.now(); id = requestAnimationFrame(step); },
    stop() { running = false; cancelAnimationFrame(id); },
    get running() { return running; },
  };
}

/* the foot of a plate: its number, what it reads, what it lets you do */
const chapters = $$("[data-title]");
function plateNo(node) { return `Plate ${roman(chapters.indexOf(node.closest("[data-title]")) + 1)}`; }
function footOf(host) {
  const figure = host.closest("figure");
  let foot = $(".foot", figure);
  if (!foot) {
    foot = html("figcaption", { class: "foot" }, figure);
    html("span", { class: "plate-no" }, foot, plateNo(host));
  }
  return foot;
}
const controls = footOf;
function chip(foot, label, onClick, pressed) {
  const box = $(".controls", foot) || html("span", { class: "controls" }, foot);
  const b = html("button", { class: "chip", type: "button" }, box, label);
  if (pressed !== undefined) b.setAttribute("aria-pressed", String(pressed));
  b.addEventListener("click", onClick);
  return b;
}
function readout(foot) { return html("span", { class: "readout", "aria-live": "off" }, foot); }

/* the two inks, as the engraving shader wants them, read where the figure stands */
function inksOf(node) {
  const ink = cssVar("--ink", node), alert = cssVar("--alert", node), paper = cssVar("--paper", node);
  return { ink: hexToRGB(ink), alert: hexToRGB(alert), css: { ink, alert, paper } };
}
const paletteOf = node => [0, 1, 2, 3, 4, 5, 6].map(i => cssVar(`--c${i}`, node));

const V36 = verticesOf(DATA.w36);
const EXHIBITS = {};

/* ============================================================== I, II. the specimen: turning, then laid stick by stick */
function heroAct(stageEl) {
  const host = $(".stage-host", stageEl), foot = $(".stage-foot", stageEl), word = $(".wordline", stageEl);
  const st = createStage(host, { forceSVG });
  const spec = st.specimen(V36);
  const inks = inksOf(stageEl);
  const no = html("span", { class: "plate-no" }, foot, "Plate I");
  const info = readout(foot);
  const alignBtn = chip(foot, "Align with the 5₂ diagram", () => align());
  const letters = [...DATA.w36].map(c => html("span", {}, word, c));
  const sticks = $("#sticks");
  const fixed = anglesOf(DATA.dirFig), laid = anglesOf([0.9, -1.25, 0.95]);
  let az = -0.6, elv = 0.62, target = null, spin = !reduced, offAz = 0, offEl = 0, tIn = 0, lastKey = "", lastK = -1, lastPhase = "";

  draggable(host, (dx, dy, e) => {
    const vert = e.pointerType === "touch" ? 0 : dy;
    if (tIn < 0.5) { az -= dx * 0.008; elv = clamp(elv + vert * 0.008, -0.5, 1.35); target = null; spin = false; }
    else { offAz -= dx * 0.008; offEl = clamp(offEl + vert * 0.008, -0.7, 0.7); }
  });
  function align() { spin = false; target = [nearestAngle(az, fixed[0]), fixed[1]]; }

  function frame(_t = 0, dt = 0) {
    const w = host.clientWidth, h = host.clientHeight, vh = window.innerHeight;
    if (!w || !h) return;
    const r = sticks.getBoundingClientRect();
    const narrow = w <= 860;
    // on a narrow sheet the specimen is pinned above the text, so progress is read at its lower edge
    const edge = narrow ? host.getBoundingClientRect().bottom : 0;
    tIn = narrow ? clamp(1 - (r.top - edge) / (vh * 0.3)) : clamp(1 - r.top / vh);
    const pb = narrow ? clamp((edge - r.top) / Math.max(1, r.height * 0.8)) : clamp(-r.top / Math.max(1, r.height - vh));
    if (target) {
      const k = 1 - Math.exp(-dt * 4.2);
      az = lerp(az, target[0], k); elv = lerp(elv, target[1], k);
      if (Math.abs(az - target[0]) + Math.abs(elv - target[1]) < 2e-3) { az = target[0]; elv = target[1]; target = null; }
    } else if (spin && tIn === 0) az += 0.16 * dt;
    if (tIn < 0.02) { const k = Math.exp(-dt * 6); offAz *= k; offEl *= k; }
    const e = reduced ? (tIn > 0.5 ? 1 : 0) : inOut(tIn);
    const built = reduced ? 36.5 : (tIn < 1 ? lerp(36.5, 0, ramp(tIn, 0.1, 0.9)) : 36.5 * ramp(pb, 0.04, 0.86));
    const R0 = spec.R;
    const s0 = narrow ? Math.min(w * 0.94, h * 0.8) / (2 * R0) * 1.04 : Math.min(w * 0.54, h * 0.86) / (2 * R0) * 1.06;
    const x0 = narrow ? w * 0.5 : w * 0.705, y0 = narrow ? h * 0.42 : h * 0.47;
    const it = {
      spec, x: x0, y: lerp(y0, narrow ? h * 0.36 : h * 0.44, e), scale: s0 * lerp(1, narrow ? 0.84 : 0.86, e),
      az: lerp(az, nearestAngle(az, laid[0]), e) + offAz * e, el: lerp(elv, laid[1], e) + offEl * e,
      radius: 0.1, amt: 1, build: built, grid: e, shadow: 1 - 0.75 * ramp(lerp(elv, laid[1], e), 0.72, 0.98),
    };
    const k = Math.min(36, Math.floor(built));
    const phase = tIn < 0.5 ? "hero" : "sticks";
    if (phase !== lastPhase) {
      lastPhase = phase; lastK = -1;
      no.textContent = phase === "hero" ? "Plate I" : "Plate II";
      alignBtn.hidden = phase !== "hero";
      word.classList.toggle("is-on", phase === "sticks");
    }
    if (phase === "hero") {
      const n = crossings(spec.V.map(p => project(viewOf(it.az, it.el), p))).length;
      if (n !== lastK) { lastK = n; info.innerHTML = `<b>${n}</b> crossings in this view`; }
    } else if (k !== lastK) {
      lastK = k;
      letters.forEach((sp, i) => { sp.className = i < k - 1 ? "on" : i === k - 1 ? (k >= 36 ? "on" : "now") : ""; });
      info.innerHTML = k >= 36 ? `<b>36</b> steps · closed` : `<b>${k}</b> of 36 steps`;
    }
    const key = [w, h, it.y, it.scale, it.az, it.el, it.build, it.grid].map(v => v.toFixed(4)).join();
    if (key !== lastKey) { lastKey = key; st.draw([it], inks.ink, inks.alert, inks.css); }
  }
  const L = loop(frame);
  frame();
  return { activate: L.start, deactivate: L.stop };
}

/* ============================================================== XV. the model turns into the diagram every table prints */
function finaleAct(stageEl) {
  const host = $(".stage-host", stageEl), foot = $(".stage-foot", stageEl);
  const st = createStage(host, { forceSVG });
  const spec = st.specimen(V36);
  const inks = inksOf(stageEl), pal = paletteOf(stageEl);
  html("span", { class: "plate-no" }, foot, "Plate XV");
  const info = readout(foot);
  const end = $("#end");
  const target = anglesOf(DATA.dirCol);
  // the arcs of the final diagram, and a colouring of them that is not one colour
  const Pf = spec.V.map(p => project(viewOf(target[0], target[1]), p));
  const arcs = arcsOf(crossings(Pf));
  const colouring = countColourings(arcs, 7).nonconst || new Array(arcs.count).fill(0);
  const cuts = arcs.events.map(q => q[0] + q[1]);
  const c = cuts.length;
  const cssCols = Array.from({ length: Math.max(c, 1) }, (_, a) => pal[colouring[a] % 7]);
  const cols = Array.from({ length: c }, (_, j) => hexToRGB(cssCols[((j - 1) % c + c) % c]));
  const fx = Pf.map(q => q[0]), fy = Pf.map(q => q[1]);
  const box = { w: Math.max(...fx) - Math.min(...fx), h: Math.max(...fy) - Math.min(...fy), cx: (Math.max(...fx) + Math.min(...fx)) / 2, cy: (Math.max(...fy) + Math.min(...fy)) / 2 };
  let offAz = 0, lastKey = "", lastText = "";
  draggable(host, dx => { offAz -= dx * 0.008; });

  function frame(_t = 0, dt = 0) {
    const w = host.clientWidth, h = host.clientHeight, vh = window.innerHeight;
    if (!w || !h) return;
    const r = end.getBoundingClientRect(), narrow = w <= 860;
    const edge = narrow ? host.getBoundingClientRect().bottom : vh * 0.25;
    let p = clamp((edge - r.top) / Math.max(1, narrow ? r.height * 0.85 : r.height - vh * 0.55));
    if (reduced) p = p > 0.4 ? 1 : 0;
    const turn = inOut(ramp(p, 0.02, 0.62)), thin = inOut(ramp(p, 0.58, 0.82)), tint = ramp(p, 0.8, 0.96);
    offAz *= Math.exp(-dt * (p > 0.5 ? 9 : 0.9));
    // the room the figure may use: right of the text on a wide sheet, above the caption everywhere
    const top = narrow ? 8 : 70, bot = narrow ? 62 : 96, rw = narrow ? w * 0.92 : w * 0.5, rh = h - top - bot;
    const rx = narrow ? w * 0.5 : w * 0.71, ry = top + rh / 2;
    const s3 = Math.min(rw, rh) / (2 * spec.R) * 1.06, sf = Math.min(rw / box.w, rh / box.h) * 0.94;
    const s0 = lerp(s3, sf, thin);
    const it = {
      spec, x: rx - box.cx * s0 * thin, y: ry - box.cy * s0 * thin, scale: s0,
      az: lerp(target[0] - 2.2, target[0], turn) + offAz, el: lerp(0.3, target[1], turn),
      radius: lerp(0.1, 0.036, thin), halo: lerp(1.9, 4.6, thin), solid: thin, amt: 1,
      shadow: 1 - ramp(p, 0.12, 0.42), bead: 1 - thin, colMix: tint, cuts, cols, cssCols,
    };
    const n = crossings(spec.V.map(q => project(viewOf(it.az, it.el), q))).length;
    const text = tint >= 1 ? `<b>5</b> crossings · the standard 5₂ diagram, in a colouring that is not one colour` : `<b>${n}</b> crossings in this view`;
    if (text !== lastText) { lastText = text; info.innerHTML = text; }
    const key = [w, h, it.az, it.el, it.radius, it.colMix, it.shadow].map(v => v.toFixed(4)).join();
    if (key !== lastKey) { lastKey = key; st.draw([it], inks.ink, inks.alert, inks.css); }
  }
  const L = loop(frame);
  frame();
  return { activate: L.start, deactivate: L.stop };
}

/* ============================================================== III. the knots that were known */
EXHIBITS.known = host => {
  host.classList.add("known");
  const stageBox = html("div", { class: "known-stage" }, host);
  const st = createStage(stageBox, { forceSVG });
  const inks = inksOf(host);
  const done = DATA.facts.partsDone === DATA.facts.parts;
  const cells = DATA.known.map((k, i) => {
    const c = html("div", { class: "kn" + (i === 3 ? " new" : "") }, host);
    const box = html("div", { class: "kn-model" }, c);
    html("p", { class: "kn-name" }, c, k.name);
    const num = html("p", { class: "kn-num" }, c, i === 3 ? "≥ ?" : String(k.len));
    const who = html("p", { class: "kn-who" }, c, i === 3 ? "lower bound open" : `${k.year} · ${k.who}`);
    const a = anglesOf(k.dir);
    return { spec: st.specimen(verticesOf(k.word)), box, num, who, az: a[0], el: a[1] };
  });
  let arrived = false, lastKey = "";
  function frame(t) {
    const hr = stageBox.getBoundingClientRect();
    const items = cells.map((c, i) => {
      const r = c.box.getBoundingClientRect();
      const sway = reduced ? 0 : 0.2 * Math.sin(t * 0.55 + i * 1.3);
      return {
        spec: c.spec, x: r.left - hr.left + r.width / 2, y: r.top - hr.top + r.height * 0.5,
        scale: Math.min(r.width, r.height) * 0.78 / (2 * c.spec.R), az: c.az + sway, el: c.el, radius: 0.105, amt: 1, shadow: 0, bead: 0,
      };
    });
    const key = items.map(it => [it.x, it.y, it.scale, it.az].map(v => v.toFixed(3)).join()).join(";");
    if (key !== lastKey) { lastKey = key; st.draw(items, inks.ink, inks.alert, inks.css); }
  }
  const L = loop(frame);
  frame(0);
  return {
    activate() {
      L.start();
      if (arrived) return;
      arrived = true;
      setTimeout(() => {
        const c = cells[3];
        // the upper bound is the polygon itself; the lower bound is claimed only when every check is in
        c.num.textContent = done ? "36" : "≤ 36";
        c.num.classList.add("arrive");
        c.who.textContent = done ? "2026 · proved here" : `lower bound: ${fmt(DATA.facts.partsDone)} of ${fmt(DATA.facts.parts)} checks`;
      }, reduced ? 0 : 1500);
    },
    deactivate: L.stop,
  };
};

/* ============================================================== IV. the scale of the problem */
EXHIBITS.scale = host => {
  const box = html("div", { class: "scale" }, host);
  const rows = [
    { e: 18, cls: "vast", label: `lattice polygons with 34 steps <b>(order of magnitude)</b>` },
    { e: Math.log10(DATA.facts.nodes), cls: "", label: `partial walks the search visited: <b>${sci(DATA.facts.nodes)}</b>` },
    { e: Math.log10(Math.max(DATA.facts.words, 1)), cls: "", label: `walks that obey all seven rules: <b>${fmt(DATA.facts.words)}</b>` },
    { e: 0, cls: "none", label: `of them a 5₂: <b>none</b>` },
  ];
  rows.forEach((r, i) => {
    const row = html("div", { class: "row " + r.cls }, box);
    html("p", {}, row).innerHTML = r.label;
    const tr = html("div", { class: "track" }, row);
    html("i", { style: `--e:${r.e.toFixed(3)};--i:${i}` }, tr);
  });
  const axis = html("div", { class: "axis", "aria-hidden": "true" }, box);
  for (let e = 0; e <= 18; e += 3) html("span", { style: `--e:${e}` }, axis, `10${sup(e)}`);
  readout(footOf(host)).textContent = "Logarithmic scale: each tick is ten times the one before.";
  return { activate() { box.classList.add("in"); }, deactivate() {} };
};

/* ============================================================== V. the two moves (interactive, on a flat grid) */
EXHIBITS.moves = host => {
  const start = [[0,0],[1,0],[2,0],[3,0],[3,1],[4,1],[4,2],[4,3],[3,3],[3,4],[2,4],[1,4],[1,3],[2,3],[2,2],[1,2],[0,2],[0,1]];
  let pts = start.map(p => p.slice()), shown = pts.map(p => p.slice());
  const svg = fig(host, "-1.4 -5.4 6.8 6.8");
  const defs = el("defs", {}, svg);
  const pat = el("pattern", { id: "hatch-moves", width: .12, height: .12, patternUnits: "userSpaceOnUse", patternTransform: "rotate(45)" }, defs);
  el("line", { x1: 0, y1: 0, x2: 0, y2: .12, stroke: "var(--c1)", "stroke-width": .035 }, pat);
  const grid = el("g", {}, svg);
  for (let i = -1; i <= 5; i++) {
    el("line", { class: "grid", x1: i, y1: 1, x2: i, y2: -5, "stroke-width": 0.012 }, grid);
    el("line", { class: "grid", x1: -1, y1: -i, x2: 5, y2: -i, "stroke-width": 0.012 }, grid);
  }
  const ghost = el("g", {}, svg), g = el("g", {}, svg), hit = el("g", {}, svg);
  const cs = controls(host);
  const r = readout(cs);
  chip(cs, "Reset", () => { pts = start.map(p => p.slice()); shown = pts.map(p => p.slice()); render(); });
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
  const body = () => {
    // a stick drawn as the engraved model is: two contours and a clear middle
    const d = shown.map(p => `${p[0]},${-p[1]}`).join(" ");
    let s = `<polygon points="${d}" class="knot" stroke-width="0.15" stroke-linejoin="miter"/><polygon points="${d}" fill="none" stroke="var(--paper-lit)" stroke-width="0.105" stroke-linejoin="miter"/>`;
    shown.forEach(p => { s += `<circle class="vx" cx="${p[0]}" cy="${-p[1]}" r="0.045"/>`; });
    return s;
  };
  const press = (node, go) => {
    node.addEventListener("click", go);
    node.addEventListener("keydown", e => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); go(); } });
  };
  function render() {
    const n = shown.length;
    g.innerHTML = body();
    hit.innerHTML = ""; ghost.innerHTML = "";
    for (const i of uturns()) {
      const a = pts[(i - 1 + n) % n], b = pts[(i + 2) % n], p1 = pts[i], p2 = pts[(i + 1) % n];
      el("line", { x1: a[0], y1: -a[1], x2: b[0], y2: -b[1], class: "ghost", "stroke-width": 0.03, "stroke-dasharray": ".1 .08" }, ghost);
      const zone = el("rect", { class: "hit uturn", x: Math.min(a[0], b[0], p1[0], p2[0]) + 0.14, y: -Math.max(a[1], b[1], p1[1], p2[1]) + 0.14, width: 0.72, height: 0.72, "stroke-width": .02, tabindex: 0, role: "button", "aria-label": "Cut this U-turn" }, hit);
      press(zone, () => cut(i));
    }
    for (const c of corners()) {
      const v = pts[c.i];
      const dot = el("circle", { class: "hit corner" + (c.free ? "" : " blocked"), cx: v[0], cy: -v[1], r: 0.21, "stroke-width": .022, tabindex: 0, role: "button", "aria-label": c.free ? "Flip this corner" : "Blocked corner" }, hit);
      press(dot, () => flip(c));
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
      g.innerHTML = body(); hit.innerHTML = "";
      if (x < 1) requestAnimationFrame(f); else { shown = next.map(p => p.slice()); after && after(); render(); }
    };
    requestAnimationFrame(f);
  }
  function flip(c) {
    if (!c.free) {
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

/* ============================================================== VI. the curtain, animated in 3D */
EXHIBITS.curtain = host => {
  const svg = fig(host, "0 0 1 1");
  const B = basis([1.1, -1.6, 1.25]);
  const base = [[-2, 0, 0], [-1, 0, 0], [0, 0, 0], [0, 0, 1], [1, 0, 1], [2, 0, 1], [2, 1, 1], [2, 1, 0], [3, 1, 0], [4, 1, 0]];
  // vertices 2..7 are v0..v5 of the curtain (a = up, k = 3 sideways steps)
  const rings = [[1, 0, 0], [2, 0, 0]];
  const other = [[1, -2, 0], [1, -1, 0], [1, 0, 0], [1, 1, 0], [1, 2, 0]];   // another strand, used to block
  const proj = p => B([p[0] - 1, p[1], p[2] - 0.4]);
  const R = 3.5;
  svg.setAttribute("viewBox", `${-R} ${-R * 0.8} ${2 * R} ${1.6 * R}`);
  const defs = el("defs", {}, svg);
  const pat = el("pattern", { id: "hatch-curtain", width: .11, height: .11, patternUnits: "userSpaceOnUse", patternTransform: "rotate(90)" }, defs);
  el("line", { x1: 0, y1: 0, x2: 0, y2: .11, stroke: "var(--ink)", "stroke-width": .022 }, pat);
  const gGrid = el("g", {}, svg), gCurt = el("g", {}, svg), gOther = el("g", {}, svg), gPath = el("g", {}, svg), gRing = el("g", {}, svg);
  for (let x = -2; x <= 4; x++) for (let y = -2; y <= 2; y++) {
    const a = proj([x, y, 0]);
    if (x < 4) { const b = proj([x + 1, y, 0]); el("line", { class: "grid", x1: a[0], y1: a[1], x2: b[0], y2: b[1], "stroke-width": .012 }, gGrid); }
    if (y < 2) { const b = proj([x, y + 1, 0]); el("line", { class: "grid", x1: a[0], y1: a[1], x2: b[0], y2: b[1], "stroke-width": .012 }, gGrid); }
  }
  const cs = controls(host);
  const r = readout(cs);
  const playBtn = chip(cs, "Push the curtain down", () => play());
  const blockBtn = chip(cs, "Put a strand under it", () => { blocked = !blocked; blockBtn.setAttribute("aria-pressed", String(blocked)); reset(); }, false);
  let blocked = false, path = base.map(p => p.slice()), anim = null, run = 0;
  const tube = (P, parent) => {
    const d = P.map(p => p[0] + "," + p[1]).join(" ");
    el("polyline", { points: d, class: "knot", "stroke-width": .13, "stroke-linejoin": "round" }, parent);
    el("polyline", { points: d, fill: "none", stroke: "var(--paper-lit)", "stroke-width": .085, "stroke-linejoin": "round", "stroke-linecap": "round" }, parent);
  };
  function draw(curtainOn = true) {
    gPath.innerHTML = ""; gRing.innerHTML = ""; gCurt.innerHTML = ""; gOther.innerHTML = "";
    if (blocked) tube(other.map(proj), gOther);
    if (curtainOn && path.length === base.length) {
      // the strip under v1..v4
      const top = path.slice(3, 7), bot = top.map(p => [p[0], p[1], p[2] - 1]);
      const poly = [...top, ...bot.reverse()].map(proj);
      el("polygon", { points: poly.map(p => p[0] + "," + p[1]).join(" "), fill: "url(#hatch-curtain)", stroke: "none" }, gCurt);
    }
    const P = path.map(proj);
    tube(P, gPath);
    P.forEach(p => el("circle", { class: "vx", cx: p[0], cy: p[1], r: .04 }, gPath));
    for (const q of rings) {
      const p = proj(q), taken = blocked && q[0] === 1;
      el("circle", { class: "ring" + (taken ? " taken" : ""), cx: p[0], cy: p[1], r: taken ? .1 : .16, "stroke-width": .028, "stroke-dasharray": taken ? "none" : ".06 .06" }, gRing);
    }
  }
  function tween(from, to, T, id) {
    return new Promise(res => {
      const t0 = performance.now();
      const f = t => {
        if (id !== run) return res();
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
    const id = run;
    const p0 = base.map(p => p.slice());
    r.innerHTML = "flip 1: the up-step slides along";
    await sleep(300);
    if (id !== run) return;
    if (blocked) {
      r.innerHTML = "<b>blocked</b>: a vertex sits under the curtain";
      const p = proj([1, 0, 0]);
      const x = el("circle", { cx: p[0], cy: p[1], r: .32, fill: "none", stroke: "var(--alert)", "stroke-width": .05 }, gRing);
      x.animate([{ opacity: 0 }, { opacity: 1 }, { opacity: .2 }, { opacity: 1 }], { duration: 1200, fill: "forwards" });
      playBtn.disabled = false; return;
    }
    const p1 = p0.map(p => p.slice()); p1[3] = [1, 0, 0];
    await tween(p0, p1, 700, id); await sleep(250);
    if (id !== run) return;
    r.innerHTML = "flip 2";
    const p2 = p1.map(p => p.slice()); p2[4] = [2, 0, 0];
    await tween(p1, p2, 700, id); await sleep(250);
    if (id !== run) return;
    r.innerHTML = "U-turn: up, across, down";
    await sleep(500);
    const p3 = p2.map(p => p.slice()); p3[5] = [2, 0, 0]; p3[6] = [2, 1, 0];
    await tween(p2, p3, 700, id);
    if (id !== run) return;
    path = p3.filter((_, i) => i !== 5 && i !== 6);
    draw(false);
    r.innerHTML = "<b>two sticks shorter</b>, same knot";
    playBtn.disabled = false;
  }
  function reset() { run++; cancelAnimationFrame(anim); playBtn.disabled = false; path = base.map(p => p.slice()); draw(); r.innerHTML = blocked ? "a strand passes under the curtain" : "no vertex under the curtain"; }
  reset();
  return { activate() {}, deactivate() { cancelAnimationFrame(anim); } };
};

/* ============================================================== VII. the lowest polygon: downward corners all blocked */
EXHIBITS.push = host => {
  const st = createStage(host, { forceSVG });
  const spec = st.specimen(V36);
  const inks = inksOf(host);
  const marksSvg = el("svg", { class: "marks", "aria-hidden": "true" }, host);
  const W = DATA.w36, n = W.length, V = V36;
  const key = p => p.join(",");
  const set = new Set(V.map(key));
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
  const off = V[0].map((c, k) => c - spec.V[0][k]);
  const C = p => [p[0] - off[0], p[1] - off[1], p[2] - off[2]];
  let az = -0.9, elv = 0.5, spin = !reduced, lastKey = "";
  draggable(host, (dx, dy, e) => { az -= dx * 0.008; if (e.pointerType !== "touch") elv = clamp(elv + dy * 0.008, -0.4, 1.3); spin = false; });
  readout(footOf(host)).innerHTML = `<b>${marks.length}</b> corners could point downwards · <b>${marks.filter(m => m.ok).length}</b> are blocked · Ψ = <b>${psi}</b>`;
  const L = loop((_t, dt) => {
    const w = host.clientWidth, h = host.clientHeight;
    if (!w || !h) return;
    if (spin) az += 0.17 * dt;
    const k = [w, h, az, elv].map(v => v.toFixed(4)).join();
    if (k === lastKey) return;
    lastKey = k;
    const scale = Math.min(w, h) * 0.98 / (2 * spec.R), x = w / 2, y = h * 0.47;
    st.draw([{ spec, x, y, scale, az, el: elv, radius: 0.1, amt: 1, shadow: 1 - 0.75 * ramp(elv, 0.72, 0.98) }], inks.ink, inks.alert, inks.css);
    const R = viewOf(az, elv);
    const at = p => { const q = project(R, C(p)); return [x + q[0] * scale, y + q[1] * scale]; };
    let s = "";
    for (const m of marks) {
      const v = at(V[m.i]), q = at(m.w);
      s += `<line x1="${v[0].toFixed(1)}" y1="${v[1].toFixed(1)}" x2="${q[0].toFixed(1)}" y2="${q[1].toFixed(1)}" stroke="var(--alert)" stroke-width="1.3" stroke-dasharray="3 4"/>`;
      s += `<circle cx="${v[0].toFixed(1)}" cy="${v[1].toFixed(1)}" r="${(scale * 0.2).toFixed(1)}" fill="none" stroke="var(--alert)" stroke-width="1.3"/>`;
      s += `<circle cx="${q[0].toFixed(1)}" cy="${q[1].toFixed(1)}" r="4" fill="${m.ok ? "var(--alert)" : "none"}" stroke="var(--alert)" stroke-width="1.3"/>`;
    }
    marksSvg.innerHTML = s;
  });
  return { activate: L.start, deactivate: L.stop };
};

/* ============================================================== VIII. the seven rules, each drawn */
EXHIBITS.rules = host => {
  const tray = html("div", { class: "tray" }, host);
  const items = [
    ["C1–C2", "A closed walk that never meets itself.", s => { poly(s, [[1,1],[4,1],[4,3],[3,3],[3,2],[2,2],[2,4],[1,4]], true); }],
    ["C3", "Its lowest vertex sits at the origin.", s => { hline(s, 1); poly(s, [[1,4],[1,2],[2,2],[2,1],[4,1],[4,4]], true); dot(s, [2, 1], "origin"); }],
    ["C4", "It leaves the origin in a fixed direction.", s => { poly(s, [[2,1],[4,1],[4,4],[1,4],[1,2],[2,2]], true); dot(s, [2, 1], "origin"); arrow(s, [2, .45], [3.2, .45]); }],
    ["C5", "Fewest steps up–down, most east–west.", s => { rods(s, [1.6, 2.6, 3.6]); }],
    ["C6", "A vertex under every curtain.", s => { poly(s, [[0.6,1],[1,1],[1,3],[3,3],[3,1],[3.4,1]]); ring(s, [2, 1], true); }],
    ["C7", "Every downward corner is blocked.", s => { poly(s, [[1,4],[1,3],[3,3]]); poly(s, [[0.5,2],[1.6,2]]); dot(s, [1, 2], "vx"); ring(s, [1, 2], false); }],
    ["⇒", `If 5₂ had a polygon with 34 steps or fewer, one would obey all seven. ${fmt(DATA.facts.words)} walks do; this 24-step trefoil is one of them.`, s => { survivor(s); }],
  ];
  function svgIn(f) { return el("svg", { class: "mini", viewBox: "0 0 5 5", "aria-hidden": "true" }, f); }
  function poly(s, pts, closed) {
    const d = pts.map(p => `${p[0]},${5 - p[1]}`).join(" "), tag = closed ? "polygon" : "polyline";
    el(tag, { points: d, class: "knot", "stroke-width": .2, "stroke-linejoin": "miter", fill: "none" }, s);
    el(tag, { points: d, stroke: "var(--paper)", "stroke-width": .12, "stroke-linejoin": "miter", "stroke-linecap": "round", fill: "none" }, s);
  }
  function dot(s, p, cls) { el("circle", { cx: p[0], cy: 5 - p[1], r: .2, class: cls }, s); }
  function ring(s, p, taken) { el("circle", { cx: p[0], cy: 5 - p[1], r: taken ? .16 : .32, class: taken ? "vx" : "", fill: taken ? "" : "none", stroke: taken ? "none" : "var(--alert)", "stroke-width": .07 }, s); }
  function hline(s, y) { el("line", { x1: .3, y1: 5 - y + .32, x2: 4.7, y2: 5 - y + .32, class: "ghost", "stroke-width": .05, "stroke-dasharray": ".15 .12" }, s); }
  function arrow(s, a, b) { el("line", { x1: a[0], y1: 5 - a[1], x2: b[0], y2: 5 - b[1], stroke: "var(--alert)", "stroke-width": .09 }, s); el("path", { d: `M${b[0]} ${5 - b[1] - .2} L${b[0] + .34} ${5 - b[1]} L${b[0]} ${5 - b[1] + .2}z`, fill: "var(--alert)" }, s); }
  function rods(s, h) {
    h.forEach((v, i) => {
      const x = 1 + i * 1.5;
      el("line", { x1: x, y1: 4.2, x2: x, y2: 4.2 - v, class: "knot", "stroke-width": .24, "stroke-linecap": "butt" }, s);
      el("line", { x1: x, y1: 4.13, x2: x, y2: 4.27 - v, stroke: "var(--paper)", "stroke-width": .15 }, s);
      for (let k = 1; k < v * 2.5; k++) el("line", { x1: x - .1, y1: 4.2 - k * .4, x2: x + .1, y2: 4.2 - k * .4, stroke: "var(--ink)", "stroke-width": .035 }, s);
      el("text", { x, y: 4.92, "text-anchor": "middle", "font-size": .52 }, s).textContent = ["z", "y", "x"][i];
    });
  }
  function survivor(s) {
    s.setAttribute("viewBox", "0 0 10 5");
    const V = centre(verticesOf(DATA.tref)), P = V.map(projAlong(DATA.trefDir));
    const xs = P.map(p => p[0]), ys = P.map(p => p[1]);
    const span = Math.max(Math.max(...xs) - Math.min(...xs), Math.max(...ys) - Math.min(...ys));
    const k = 4.4 / span, cx = (Math.min(...xs) + Math.max(...xs)) / 2, cy = (Math.min(...ys) + Math.max(...ys)) / 2;
    const Q = P.map(p => [5 + (p[0] - cx) * k, 2.5 + (p[1] - cy) * k, p[2]]);
    const ps = pieces(Q, crossings(Q), .2);
    for (const q of ps) el("line", { class: "knot", x1: q.x1, y1: q.y1, x2: q.x2, y2: q.y2, "stroke-width": .17 }, s);
    for (const q of ps) el("line", { x1: q.x1, y1: q.y1, x2: q.x2, y2: q.y2, stroke: "var(--paper)", "stroke-width": .095, "stroke-linecap": "round" }, s);
  }
  for (const [t, c, draw] of items) {
    const f = html("figure", t === "⇒" ? { class: "wide" } : {}, tray);
    draw(svgIn(f));
    const cap = html("figcaption", {}, f);
    html("b", {}, cap, t); cap.append(c);
  }
  footOf(host);
  return { activate() {}, deactivate() {} };
};

/* ============================================================== IX. a miniature search on the square grid */
EXHIBITS.search = host => {
  const canvas = html("canvas", { "aria-hidden": "true" }, host);
  const cs = controls(host);
  const r = readout(cs);
  const speedBtn = chip(cs, "Faster", () => { fast = !fast; speedBtn.setAttribute("aria-pressed", String(fast)); }, false);
  chip(cs, "Restart", () => { restart(); paint(); });
  let fast = false;
  const N = 12;   // closed walks of 12 steps on the square grid
  const D = [[1, 0], [-1, 0], [0, 1], [0, -1]];
  let gen, stats, found, current, timer = 0, running = false;
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
    const steps = fast ? 60 : (reduced ? 1 : 2);
    for (let s = 0; s < steps; s++) { if (gen.next().done) { restart(); break; } }
    paint();
    timer = setTimeout(() => requestAnimationFrame(frame), fast ? 16 : (reduced ? 400 : 70));
  }
  function paint() {
    const dpr = Math.min(devicePixelRatio || 1, 2), w = canvas.clientWidth, h = canvas.clientHeight;
    if (!w || !h) return;
    if (canvas.width !== Math.round(w * dpr) || canvas.height !== Math.round(h * dpr)) { canvas.width = Math.round(w * dpr); canvas.height = Math.round(h * dpr); }
    const c = canvas.getContext("2d"); c.setTransform(dpr, 0, 0, dpr, 0, 0); c.clearRect(0, 0, w, h);
    const ink = cssVar("--ink", host), acc = cssVar("--c1", host), alert = cssVar("--alert", host), rule = cssVar("--hair", host), paper = cssVar("--paper-lit", host);
    const S = Math.min(w / 14.4, h / 8.4), ox = w * 0.5 - 0.5 * S, oy = h * 0.5 + 3 * S;
    c.strokeStyle = rule; c.lineWidth = 1;
    for (let x = -6; x <= 7; x++) { c.beginPath(); c.moveTo(ox + x * S, oy); c.lineTo(ox + x * S, oy - 6 * S); c.stroke(); }
    for (let y = 0; y <= 6; y++) { c.beginPath(); c.moveTo(ox - 6 * S, oy - y * S); c.lineTo(ox + 7 * S, oy - y * S); c.stroke(); }
    // found polygons as faint ghosts
    c.globalAlpha = 0.16; c.strokeStyle = acc; c.lineWidth = 2;
    for (const f of found.slice(-12)) { c.beginPath(); f.forEach((p, i) => (i ? c.lineTo : c.moveTo).call(c, ox + p[0] * S, oy - p[1] * S)); c.closePath(); c.stroke(); }
    c.globalAlpha = 1;
    if (current) {
      const p = current.path, lw = Math.max(5, S * 0.17);
      const trace = () => { c.beginPath(); p.forEach((q, i) => (i ? c.lineTo : c.moveTo).call(c, ox + q[0] * S, oy - q[1] * S)); c.stroke(); };
      c.lineJoin = "miter"; c.lineCap = "round";
      c.strokeStyle = ink; c.lineWidth = lw; trace();
      c.strokeStyle = paper; c.lineWidth = lw - 2.6; trace();
      const last = p[p.length - 1], t = current.try;
      c.strokeStyle = current.ok ? acc : alert; c.setLineDash(current.ok ? [] : [5, 5]); c.lineWidth = 2.5;
      c.beginPath(); c.moveTo(ox + last[0] * S, oy - last[1] * S); c.lineTo(ox + t[0] * S, oy - t[1] * S); c.stroke(); c.setLineDash([]);
      c.fillStyle = alert; c.beginPath(); c.arc(ox, oy, Math.max(5, lw * 0.75), 0, 7); c.fill();
      if (!current.ok) {
        c.fillStyle = alert; c.font = `italic 15px ${cssVar("--font-body")}`;
        const tw = c.measureText(current.why).width;
        c.fillText(current.why, Math.max(6, Math.min(w - tw - 6, ox + t[0] * S + 9)), Math.max(16, oy - t[1] * S - 9));
      }
    }
    r.innerHTML = `<b>${fmt(stats.visited)}</b> steps taken · <b>${fmt(stats.tried - stats.visited)}</b> cut off · <b>${fmt(stats.closed)}</b> closed walks found`;
  }
  restart();
  return {
    activate() { if (running) return; running = true; frame(); },
    deactivate() { running = false; clearTimeout(timer); },
  };
};

/* ============================================================== X. 1358 drawers */
EXHIBITS.drawers = host => {
  const wall = html("div", { class: "wall" }, host);
  const rows = DATA.runs.filter(r => r.n >= 4);
  for (const r of rows) {
    html("span", { class: "n" }, wall, `n = ${r.n}`);
    const cells = html("div", { class: "cells", title: `n = ${r.n}: ${r.done} of ${r.parts} parts · ${fmt(r.words)} words · ${fmt(r.nodes)} nodes` }, wall);
    cells.style.setProperty("--cw", r.parts > 600 ? "8px" : r.parts > 100 ? "9px" : "11px");
    for (const ch of r.cells) html("i", ch === "." ? {} : { class: ch }, cells);
  }
  const lg = html("div", { class: "legend" }, wall);
  lg.innerHTML = `<span><i class="l"></i>checked in the container</span><span><i class="g"></i>checked on GitHub Actions</span><span><i></i>not in yet</span>`;
  readout(footOf(host)).innerHTML = `<b>${fmt(DATA.facts.partsDone)}</b> of ${fmt(DATA.facts.parts)} parts · <b>${sci(DATA.facts.nodes)}</b> search nodes`;
  return { activate() {}, deactivate() {} };
};

/* ============================================================== XI, XII. colouring puzzles */
function colouringExhibit(host, word, D, opts) {
  const svg = fig(host, "0 0 1 1");
  const V = centre(verticesOf(word));
  const P = V.map(projAlong(D));
  const cr = crossings(P), arcs = arcsOf(cr);
  const xs = P.map(p => p[0]), ys = P.map(p => p[1]);
  const span = Math.max(Math.max(...xs) - Math.min(...xs), Math.max(...ys) - Math.min(...ys)) * 1.3;
  const cx = (Math.min(...xs) + Math.max(...xs)) / 2, cy = (Math.min(...ys) + Math.max(...ys)) / 2;
  svg.setAttribute("viewBox", `${cx - span * 0.625} ${cy - span * 0.5} ${span * 1.25} ${span}`);
  const gap = span * 0.03, sw = span / 130;
  const ps = pieces(P, cr, gap, arcs);
  let p = opts.p ?? 7;
  let x = new Array(arcs.count).fill(0);
  const gArcs = el("g", {}, svg), gX = el("g", {}, svg);
  const groups = [];
  for (let a = 0; a < arcs.count; a++) {
    const g = el("g", { class: "hit", tabindex: 0, role: "button", "aria-label": `Arc ${a + 1}: change colour` }, gArcs);
    for (const q of ps.filter(q => q.arc === a)) {
      el("line", { x1: q.x1, y1: q.y1, x2: q.x2, y2: q.y2, stroke: "transparent", "stroke-width": sw * 6, "stroke-linecap": "round" }, g);
      el("line", { class: "knot arcline", x1: q.x1, y1: q.y1, x2: q.x2, y2: q.y2, "stroke-width": sw * 1.7 }, g);
    }
    const bump = () => { x[a] = (x[a] + 1) % p; paint(); };
    g.addEventListener("click", bump);
    g.addEventListener("keydown", e => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); bump(); } });
    g.addEventListener("focus", () => g.setAttribute("opacity", ".6")); g.addEventListener("blur", () => g.removeAttribute("opacity"));
    groups.push(g);
  }
  const marks = cr.map(c => {
    const a = P[c.i], b = P[(c.i + 1) % P.length];
    return el("circle", { class: "xmark", cx: a[0] + c.t * (b[0] - a[0]), cy: a[1] + c.t * (b[1] - a[1]), r: span * 0.0105, "stroke-width": sw * 0.7 }, gX);
  });
  const cs = controls(host);
  const r = readout(cs);
  const sw7 = html("div", { class: "swatches", "aria-hidden": "true" }, host);
  for (let i = 0; i < 7; i++) html("i", { style: `background:var(--c${i})` }, sw7, String(i));
  const eqs = html("p", { class: "eqs", "aria-hidden": "true" }, host);
  const names = "ABCDEFGH";
  function paint() {
    groups.forEach((g, a) => { $$(".arcline", g).forEach(l => l.style.stroke = `var(--c${x[a] % 7})`); g.setAttribute("aria-label", `Arc ${names[a]}, colour ${x[a]}: change colour`); });
    let ok = 0;
    arcs.rows.forEach((row, i) => {
      const good = foxOK(row, x, p); ok += good;
      marks[i].setAttribute("fill", good ? "var(--ink)" : "var(--paper-lit)");
      marks[i].setAttribute("stroke", good ? "var(--ink)" : "var(--alert)");
    });
    const nonconst = x.some(v => v !== x[0]);
    const all = ok === arcs.rows.length;
    r.innerHTML = `<b>${ok}</b> of ${arcs.rows.length} crossing rules hold` + (all ? (nonconst ? ` · <b>a colouring that is not one colour</b>` : ` · all one colour`) : "");
    eqs.innerHTML = arcs.rows.map(row => `2·${names[row.over]} ≡ ${names[row.inA]} + ${names[row.outA]}`).join("<br>") + `<br>(mod ${p})`;
    [...sw7.children].forEach((s, i) => { s.style.opacity = i < p ? 1 : .18; });
  }
  const api = { set(v) { x = v.slice(); paint(); }, setP(q) { p = q; x = x.map(v => v % q); paint(); }, arcs, get x() { return x; } };
  opts.controls(cs, api, r);
  paint();
  return api;
}

EXHIBITS.colour52 = host => {
  colouringExhibit(host, DATA.w36, DATA.dirCol, {
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

/* ============================================================== XIII. what Lean checked */
EXHIBITS.lean = host => {
  host.parentElement.classList.add("scroll-x");
  host.parentElement.style.aspectRatio = "1000 / 764";
  const svg = fig(host, "0 0 1000 764");
  const defs = el("defs", {}, svg);
  const m = el("marker", { id: "arr", viewBox: "0 0 10 10", refX: 9, refY: 5, markerWidth: 7, markerHeight: 7, orient: "auto-start-reverse" }, defs);
  el("path", { d: "M0 0 L10 5 L0 10z", fill: "var(--ink-soft)" }, m);
  const pat = el("pattern", { id: "hatch-lean", width: 7, height: 7, patternUnits: "userSpaceOnUse", patternTransform: "rotate(45)" }, defs);
  el("rect", { width: 7, height: 7, fill: "var(--paper-lit)" }, pat);
  el("line", { x1: 0, y1: 0, x2: 0, y2: 7, stroke: "var(--ink)", "stroke-width": 1, "stroke-opacity": .45 }, pat);
  const N = {
    spec: { x: 285, y: 30, w: 695, t: "Definitions", s: "polygons · rules · diagrams", cls: "s",
      code: "IsPolygon w, Survive w (C1–C7), KnotClass T, diagram D w, foxRows, CompCert", info: "The statement: what a reader must read. Spec.lean, Diagram.lean, Statement.lean, Cert.lean." },
    cls: { x: 20, y: 220, w: 250, t: "Classical knot theory", s: "Δ-moves · Wirtinger", cls: "c",
      code: "KnotClass T   TopHyp T", info: "Proved in the text: square moves are pairs of Δ-moves; Fox colourings count homomorphisms to D₇." },
    nf: { x: 285, y: 220, w: 221, t: "exists_survivor", s: "normal form, 1312 lines", cls: "k",
      code: "KnotClass T → T w₀ → ∃ w, T w ∧ |w| ≤ |w₀| ∧ (|w| = 4 ∨ Survive w)", info: "Kernel-checked. Uses only the moves: minimal length, lowest polygon, canonical position." },
    sc: { x: 522, y: 220, w: 221, t: "search_complete", s: "the real program, 1736 lines", cls: "k",
      code: "Survive w → |w| ≤ 34 → w ∈ (searchPart |w| 9 M r).out", info: "Kernel-checked about the very program that was run. No test can cut off a word that obeys the seven rules." },
    cc: { x: 759, y: 220, w: 221, t: "colorCheck_sound", s: "certificates", cls: "k",
      code: "colorCheck w = true → ∃ D, regular ∧ ¬ HasNontrivialColoring D w", info: "Kernel-checked. A certificate L with L·F ≡ E forces every 7-colouring to be constant." },
    cp: { x: 522, y: 420, w: 178, t: "CompCert", s: "1358 checks", cls: "t",
      code: "∀ n r, checkPart n r = true", info: "Evaluated by the compiled program (checkpart). Logged with exit status, hashes and the commit; cross-checked by an independent C++ program." },
    main: { x: 20, y: 630, w: 960, t: "no_short", s: "T w → 36 ≤ |w|", cls: "m",
      code: "theorem no_short (T) (hT : KnotClass T) (hTop : TopHyp T) (hComp : CompCert) : ∀ w, T w → 36 ≤ w.length", info: "The main theorem. #print axioms: propext, Classical.choice, Quot.sound." },
  };
  const H = 104;
  // every dependency runs straight down the sheet, as in a table of descent
  const edges = [["spec", "nf", 395], ["spec", "sc", 632], ["spec", "cc", 869], ["cls", "main", 145], ["nf", "main", 395], ["sc", "cp", 611], ["cp", "main", 611], ["sc", "main", 722], ["cc", "main", 869]];
  for (const [a, b, x] of edges) {
    const d = `M${x} ${N[a].y + H} V${N[b].y - 2}`;
    el("path", { class: "edge", d, "marker-end": "url(#arr)" }, svg);
    if (b === "main") el("path", { class: "flow", d }, svg);
  }
  const box = html("p", { class: "leanbox", "aria-live": "polite" });
  const foot = footOf(host);
  readout(foot).textContent = "Heavy rule: checked by the Lean kernel. Dashed: proved in the text. Hatched: evaluated by the compiled program.";
  foot.after(box);
  const show = k => {
    $$(".node", svg).forEach(n => n.classList.toggle("sel", n.dataset.k === k));
    box.innerHTML = `${N[k].info}<code>${N[k].code}</code>`;
  };
  for (const [k, n] of Object.entries(N)) {
    const g = el("g", { class: `node ${n.cls}`, "data-k": k, tabindex: 0, role: "button", "aria-label": n.t }, svg);
    el("rect", { x: n.x, y: n.y, width: n.w, height: H }, g);
    el("text", { class: k === "spec" || k === "cls" ? "" : "mono", x: n.x + 14, y: n.y + 45 }, g).textContent = n.t;
    el("text", { class: "sub", x: n.x + 14, y: n.y + 78 }, g).textContent = n.s;
    g.addEventListener("click", () => show(k));
    g.addEventListener("keydown", e => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); show(k); } });
  }
  show("main");
  return { activate() {}, deactivate() {} };
};

/* ============================================================== XIV. the making of */
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
      ? "All on GitHub's free runners, where GitHub's own job logs record every result. Every part true. A separate C++ program finds the same words."
      : `A 4-core container for lengths up to 30 and half of 32; GitHub's free runners for the rest of 32 and all of 34. ${fmt(DATA.facts.partsDone)} of 1358 parts are in, all true; the rest are running.`],
  ];
  const lis = items.map(([t, h, p, cls]) => {
    const li = html("li", cls ? { class: cls } : {}, ol);
    html("time", {}, li, t); html("h3", {}, li, h); html("p", {}, li, p);
    return li;
  });
  footOf(host);
  const io = new IntersectionObserver(es => es.forEach(e => { if (e.isIntersecting) { e.target.classList.add("in"); io.unobserve(e.target); } }), { rootMargin: "0px 0px -12% 0px" });
  lis.forEach(li => io.observe(li));
  return { activate() {}, deactivate() {} };
};

/* ============================================================== the folio: plates come alive as they are reached */
document.documentElement.dataset.proof = DATA.facts.partsDone === DATA.facts.parts ? "done" : "open";
$$("[data-fact]").forEach(n => { const f = n.dataset.fact, v = DATA.facts[f]; n.textContent = f === "nodes" ? sci(v) : fmt(v); });
// subscripts in display type are set as true subscripts
$$("h1, h2").forEach(h => { h.innerHTML = h.innerHTML.replace(/5₂/g, "5<sub>2</sub>"); });

const live = new Map();
const makers = new Map();
$$(".exhibit").forEach(ex => makers.set(ex, () => (EXHIBITS[ex.dataset.exhibit] || (() => ({ activate() {}, deactivate() {} })))(ex)));
$$(".act-stage").forEach(s => makers.set(s, () => (s.dataset.stage === "hero" ? heroAct : finaleAct)(s)));
const near = new IntersectionObserver(entries => {
  for (const e of entries) {
    if (!e.isIntersecting) continue;
    near.unobserve(e.target);
    try { live.set(e.target, makers.get(e.target)()); } catch (err) { console.error(err); live.set(e.target, { activate() {}, deactivate() {} }); }
    seen.observe(e.target);
  }
}, { rootMargin: "120% 0px 120% 0px" });
const seen = new IntersectionObserver(entries => {
  for (const e of entries) {
    const x = live.get(e.target);
    if (!x) continue;
    e.target.dataset.on = e.isIntersecting ? "1" : "";
    if (e.isIntersecting && !document.hidden) x.activate(); else x.deactivate();
  }
}, { threshold: 0.12 });
makers.forEach((_, node) => near.observe(node));
document.addEventListener("visibilitychange", () => live.forEach((x, node) => { if (document.hidden) x.deactivate(); else if (node.dataset.on) x.activate(); }));

/* ---------------------------------------------------- the running head: where you are, and the way through */
const index = $("#index");
const links = chapters.map((ch, i) => {
  const li = html("li", {}, index);
  const a = html("a", { href: "#" + ch.id, "aria-label": `Plate ${roman(i + 1)}: ${ch.dataset.title}` }, li, roman(i + 1));
  html("span", { class: "tip", "aria-hidden": "true" }, a, ch.dataset.title);
  return a;
});
let current = -1;
function mark(i) {
  if (i === current) return;
  current = i;
  links.forEach((a, k) => { if (k === i) a.setAttribute("aria-current", "true"); else a.removeAttribute("aria-current"); });
  $("#here-n").textContent = roman(i + 1);
  $("#here-t").textContent = chapters[i].dataset.title;
  if (location.hash !== "#" + chapters[i].id) history.replaceState(null, "", i === 0 ? location.pathname + location.search : "#" + chapters[i].id);
}
const bar = $(".bar");
let ticking = false;
function onScroll() {
  ticking = false;
  const line = window.innerHeight * 0.42;
  let i = 0;
  chapters.forEach((ch, k) => { if (ch.getBoundingClientRect().top <= line) i = k; });
  mark(i);
  const max = document.documentElement.scrollHeight - window.innerHeight;
  bar.style.setProperty("--read", max > 0 ? clamp(window.scrollY / max).toFixed(4) : "0");
}
addEventListener("scroll", () => { if (!ticking) { ticking = true; requestAnimationFrame(onScroll); } }, { passive: true });
addEventListener("resize", onScroll);
function goTo(i) {
  i = clamp(i, 0, chapters.length - 1);
  const ch = chapters[i];
  const y = ch.getBoundingClientRect().top + window.scrollY - (ch.closest(".act") ? 0 : parseFloat(getComputedStyle(document.documentElement).fontSize) * 3.25);
  window.scrollTo({ top: i === 0 ? 0 : y + 2, behavior: reduced ? "auto" : "smooth" });
}
document.addEventListener("keydown", e => {
  if (e.altKey || e.ctrlKey || e.metaKey) return;
  if (e.target.closest("input, textarea, select")) return;
  if (e.key === "ArrowRight") { e.preventDefault(); goTo(current + 1); }
  else if (e.key === "ArrowLeft") { e.preventDefault(); goTo(current - 1); }
});
onScroll();
