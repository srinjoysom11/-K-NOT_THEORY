// The knot-move lab: a lattice knot in three dimensions that the reader changes with the proof's own
// square moves (corner flips and U-turn removals, and the reverse of a removal). Every move keeps the
// knot type, and the lab shows it: the shadow on the floor is the knot's diagram, drawn again with its
// crossings in the inset, and the number of Fox colourings of that diagram never changes.
// three.js, with engraving shaders that match the rest of the atlas.
import * as THREE from "three";
import { verticesOf, crossings, arcsOf, pieces } from "./knot.js";

/* ------------------------------------------------------------------ lattice geometry */
const U6 = [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]];
const add = (a, b) => [a[0] + b[0], a[1] + b[1], a[2] + b[2]];
const sub = (a, b) => [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
const dot = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
const cross = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const scale = (a, s) => [a[0] * s, a[1] * s, a[2] * s];
const lerp3 = (a, b, t) => [a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t];
const norm = v => { const l = Math.hypot(...v) || 1; return v.map(x => x / l); };
const key = p => p.join(",");
const manh = (a, b) => Math.abs(a[0] - b[0]) + Math.abs(a[1] - b[1]) + Math.abs(a[2] - b[2]);
const easeInOut = t => t < .5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
const easeOut = t => 1 - Math.pow(1 - t, 3);

function cornersOf(V) {
  const n = V.length, occ = new Set(V.map(key)), out = [];
  for (let i = 0; i < n; i++) {
    const a = V[(i - 1 + n) % n], v = V[i], c = V[(i + 1) % n];
    if (dot(sub(v, a), sub(c, v)) !== 0) continue;
    const w = add(a, sub(c, v));
    out.push({ i, a, v, c, w, free: !occ.has(key(w)) });
  }
  return out;
}
function uturnsOf(V) {
  const n = V.length, out = [];
  if (n < 6) return out;
  for (let i = 0; i < n; i++) {
    const a = V[(i - 1 + n) % n], b = V[i], c = V[(i + 1) % n], d = V[(i + 2) % n];
    if (manh(a, d) === 1) out.push({ i, a, b, c, d });
  }
  return out;
}
function pushDirs(V, i) {
  const n = V.length, occ = new Set(V.map(key));
  const a = V[i], b = V[(i + 1) % n], d = sub(b, a);
  return U6.filter(e => dot(e, d) === 0 && !occ.has(key(add(a, e))) && !occ.has(key(add(b, e))));
}

/* ------------------------------------------------------------------ the diagram and its colourings */
function frameOf(L) {
  const n = norm(L);
  let up = [0, 0, 1];
  if (Math.abs(n[2]) > 0.999) up = [0, 1, 0];
  const r = norm(cross(up, n)), u = cross(n, r);
  return [r, u, n];
}
const modinv = (a, p) => { for (let x = 1; x < p; x++) if ((a * x) % p === 1) return x; return 1; };
// the number of Fox p-colourings is p to the dimension of the kernel of the Fox matrix mod p
function foxCount(arcs, p) {
  const c = arcs.count;
  const M = arcs.rows.map(r => {
    const v = new Array(c).fill(0);
    v[r.over] += 2; v[r.inA] -= 1; v[r.outA] -= 1;
    return v.map(x => ((x % p) + p) % p);
  });
  const piv = [];
  let rank = 0;
  for (let col = 0; col < c && rank < M.length; col++) {
    let r = rank;
    while (r < M.length && M[r][col] === 0) r++;
    if (r === M.length) continue;
    [M[rank], M[r]] = [M[r], M[rank]];
    const inv = modinv(M[rank][col], p);
    M[rank] = M[rank].map(x => (x * inv) % p);
    for (let k = 0; k < M.length; k++) {
      if (k === rank || M[k][col] === 0) continue;
      const f = M[k][col];
      M[k] = M[k].map((x, j) => ((x - f * M[rank][j]) % p + p) % p);
    }
    piv.push(col); rank++;
  }
  const free = [];
  for (let j = 0; j < c; j++) if (!piv.includes(j)) free.push(j);
  let colouring = null;
  for (const f of free) {
    const x = new Array(c).fill(0);
    x[f] = 1;
    piv.forEach((pc, k) => { x[pc] = ((-M[k][f]) % p + p) % p; });
    if (x.some(v => v !== x[0])) { colouring = x; break; }
  }
  return { count: Math.pow(p, free.length), colouring };
}
function diagramOf(V, L, p) {
  const [r, u, n] = frameOf(L);
  const P = V.map(q => [dot(r, q), -dot(u, q), dot(n, q)]);
  const cr = crossings(P), arcs = arcsOf(cr);
  return { P, cr, arcs, ...foxCount(arcs, p) };
}

/* ------------------------------------------------------------------ the knots on the bench */
const KNOTS = {
  "3_1": { label: "3₁", common: "trefoil", p: 3, who: "Diao proved it in 1993" },
  "4_1": { label: "4₁", common: "figure-eight knot", p: 5, who: "Scharein et al. reported it in 2009" },
  "5_1": { label: "5₁", common: "cinquefoil", p: 5, who: "Scharein et al. reported it in 2009" },
  "5_2": { label: "5₂", common: "knot 5₂", p: 7, who: "" },
};

/* ------------------------------------------------------------------ shaders */
const VERT = `
uniform float uK;
attribute float aTint;
varying vec3 vN; varying vec2 vUv; varying float vTint; varying float vLen;
void main() {
  vec3 pos = position;
#ifdef SPHERE
  pos *= uK;
#else
  pos.xz *= uK;
#endif
  vec4 wp = modelMatrix * instanceMatrix * vec4(pos, 1.0);
  vN = normalize(normalMatrix * (mat3(instanceMatrix) * normal));
  vUv = uv; vTint = aTint; vLen = length(instanceMatrix[1].xyz);
  gl_Position = projectionMatrix * viewMatrix * wp;
}`;
const FRAG_ENGRAVE = `
uniform vec3 uInk, uAlert, uPaper, uLight;
uniform float uLines, uDpr;
varying vec3 vN; varying vec2 vUv; varying float vTint; varying float vLen;
float lineCov(float c, float w) {
  float d = abs(fract(c) - .5) * 2.;
  float aa = fwidth(c) * 1.4;
  float hard = 1. - smoothstep(1. - w - aa, 1. - w + aa, d);
  return w <= 0.001 ? 0. : mix(hard, w, smoothstep(.45, 1.1, aa));
}
void main() {
  vec3 n = normalize(vN);
  float shade = clamp(.5 - .5 * dot(n, uLight), 0., 1.);
  float wa = .84 * smoothstep(.28, .95, shade);
  float wb = .5 * smoothstep(.74, 1., shade);
  float a;
#ifdef SPHERE
  vec2 p = gl_FragCoord.xy / uDpr;
  a = max(lineCov((p.x * .8 + p.y * .6) / 3.2, wa), lineCov((p.x * .6 - p.y * .8) / 3.2, wb));
#else
  a = max(lineCov(vUv.x * uLines, wa), lineCov(vUv.y * vLen * 11., wb));
  float e = min(vUv.y, 1. - vUv.y) * vLen, ea = fwidth(e) * 1.2;
  a = max(a, (1. - smoothstep(.016 - ea, .016 + ea, e)) * step(.3, vLen));
#endif
  vec3 ink = mix(uInk, uAlert, vTint);
  gl_FragColor = vec4(mix(uPaper, ink, a), 1.);
}`;
const FRAG_FLAT = `uniform vec3 uColor; void main() { gl_FragColor = vec4(uColor, 1.); }`;
const VERT_SHADOW = `
uniform float uZ0; uniform vec3 uL;
void main() {
  vec4 wp = modelMatrix * instanceMatrix * vec4(position, 1.0);
  wp.xy -= uL.xy * (wp.z - uZ0) / uL.z;
  wp.z = uZ0;
  gl_Position = projectionMatrix * viewMatrix * wp;
}`;
const FRAG_SHADOW = `
uniform vec3 uInk; uniform float uDpr, uAmt;
void main() {
  vec2 p = gl_FragCoord.xy / uDpr;
  float c = (p.x * .8 + p.y * .6) / 4.6;
  float d = abs(fract(c) - .5) * 2., aa = fwidth(c) * 1.4;
  float a = (1. - smoothstep(.36 - aa, .36 + aa, d)) * uAmt;
  gl_FragColor = vec4(uInk, a);
}`;
const VERT_GRID = `varying vec2 vXY; void main() { vec4 wp = modelMatrix * vec4(position, 1.0); vXY = wp.xy; gl_Position = projectionMatrix * viewMatrix * wp; }`;
const FRAG_GRID = `
uniform vec3 uInk; uniform vec2 uC; uniform float uR, uAmt;
varying vec2 vXY;
void main() {
  vec2 g = abs(fract(vXY - .5) - .5) / fwidth(vXY);
  float line = 1. - min(min(g.x, g.y), 1.);
  float fade = 1. - smoothstep(uR * .55, uR, length(vXY - uC));
  gl_FragColor = vec4(uInk, line * fade * uAmt * .34);
}`;

const blendOver = m => Object.assign(m, {
  transparent: false, blending: THREE.CustomBlending,
  blendSrc: THREE.SrcAlphaFactor, blendDst: THREE.OneMinusSrcAlphaFactor,
  blendSrcAlpha: THREE.OneFactor, blendDstAlpha: THREE.OneMinusSrcAlphaFactor,
});

/* ================================================================== the lab */
export function createLab(root, { DATA, reduced, proofDone, partsDone, parts, palette, hex }) {
  const $ = s => root.querySelector(s);
  const $$ = s => [...root.querySelectorAll(s)];
  const stageEl = $(".lab-stage"), canvasBox = $(".lab-canvas"), markersEl = $(".lab-markers");
  const ghost = $(".lab-ghost"), insetSvg = $(".lab-inset svg"), captionEl = $(".lab-caption");
  const out = name => $(`[data-out="${name}"]`);

  /* ---------- renderer and scene */
  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true, powerPreference: "high-performance" });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
  renderer.setClearColor(0x000000, 0);
  canvasBox.appendChild(renderer.domElement);
  renderer.domElement.setAttribute("aria-hidden", "true");
  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(30, 1, 0.1, 400);
  camera.up.set(0, 0, 1);

  const ink = hex(getComputedStyle(root).getPropertyValue("--ink"));
  const paper = hex(getComputedStyle(root).getPropertyValue("--paper"));
  const alert = hex(getComputedStyle(root).getPropertyValue("--alert"));
  const v3 = c => new THREE.Vector3(c[0], c[1], c[2]);
  const LIGHT_VIEW = new THREE.Vector3(-0.6, 0.7, 0.4).normalize();
  const dpr = () => renderer.getPixelRatio();

  const CAP = 200, R = 0.1;
  const cyl = new THREE.CylinderGeometry(1, 1, 1, 26, 1, true);
  const sph = new THREE.SphereGeometry(1, 22, 14);
  const tint = new THREE.InstancedBufferAttribute(new Float32Array(CAP), 1);
  cyl.setAttribute("aTint", tint);
  sph.setAttribute("aTint", new THREE.InstancedBufferAttribute(new Float32Array(CAP), 1));
  const edgeM = new THREE.InstancedBufferAttribute(new Float32Array(CAP * 16), 16);
  const vertM = new THREE.InstancedBufferAttribute(new Float32Array(CAP * 16), 16);
  edgeM.setUsage(THREE.DynamicDrawUsage); vertM.setUsage(THREE.DynamicDrawUsage);

  const engraveU = () => ({ uK: { value: 1 }, uInk: { value: v3(ink) }, uAlert: { value: v3(alert) }, uPaper: { value: v3(paper) }, uLight: { value: LIGHT_VIEW }, uLines: { value: 22 }, uDpr: { value: dpr() } });
  const mat = (frag, uniforms, sphere, extra = {}) => new THREE.ShaderMaterial({ vertexShader: VERT, fragmentShader: frag, uniforms, defines: sphere ? { SPHERE: "" } : {}, ...extra });
  const flat = (color, k, sphere) => mat(FRAG_FLAT, { uK: { value: k }, uColor: { value: v3(color) } }, sphere, { side: THREE.BackSide });
  const shadowU = { uZ0: { value: -1 }, uL: { value: new THREE.Vector3(0.3, -0.5, 1) }, uInk: { value: v3(ink) }, uDpr: { value: dpr() }, uAmt: { value: 1 } };
  const shadowMat = blendOver(new THREE.ShaderMaterial({ vertexShader: VERT_SHADOW, fragmentShader: FRAG_SHADOW, uniforms: shadowU }));

  function inst(geo, material, matrices, order) {
    const m = new THREE.InstancedMesh(geo, material, CAP);
    m.instanceMatrix = matrices;
    m.frustumCulled = false;
    m.renderOrder = order;
    scene.add(m);
    return m;
  }
  const meshes = [
    inst(cyl, shadowMat, edgeM, 1), inst(sph, shadowMat, vertM, 1),
    inst(cyl, flat(paper, 1.7, false), edgeM, 2), inst(sph, flat(paper, 1.7, true), vertM, 2),
    inst(cyl, flat(ink, 1.24, false), edgeM, 3), inst(sph, flat(ink, 1.24, true), vertM, 3),
    inst(cyl, mat(FRAG_ENGRAVE, engraveU(), false), edgeM, 4), inst(sph, mat(FRAG_ENGRAVE, engraveU(), true), vertM, 4),
  ];
  const engraveMats = [meshes[6].material, meshes[7].material];
  const gridU = { uInk: { value: v3(ink) }, uC: { value: new THREE.Vector2() }, uR: { value: 8 }, uAmt: { value: 1 } };
  const grid = new THREE.Mesh(new THREE.PlaneGeometry(1, 1), blendOver(new THREE.ShaderMaterial({ vertexShader: VERT_GRID, fragmentShader: FRAG_GRID, uniforms: gridU, depthWrite: false })));
  grid.renderOrder = 0; grid.frustumCulled = false;
  scene.add(grid);

  /* ---------- state */
  let V = [], hist = [], knotId = "3_1", knot = KNOTS[knotId], minLen = 24, tool = "flip";
  let anim = null, busy = false, token = 0;
  let disp = [];
  let showShadow = true, showGrid = true, showInset = true, spin = !reduced;
  let L = norm([0.34, -0.52, 1]), lightAnim = null;
  let az = -0.75, el = 0.62, dist = 20, target = [0, 0, 0], z0 = -1, fitR = 4;
  let hover = null, rings = [], lastDiagram = null, solving = false, demoTitle = "";
  const minWord = id => DATA.known.find(k => k.name === KNOTS[id].label)?.word;

  /* ---------- moves: each returns a record that can be undone, and an animation */
  function animate(spec) {
    return new Promise(res => {
      const dur = reduced ? 1 : spec.dur * (solving ? 0.42 : 1);
      anim = { ...spec, t0: performance.now(), dur, res };
      busy = true;
      markersEl.classList.add("is-moving");
    });
  }
  function finish() {
    const a = anim;
    anim = null; busy = false;
    a.done();
    markersEl.classList.remove("is-moving");
    afterChange();
    a.res();
  }
  // a corner swings through space about the diagonal of its square: the edges stay one unit long
  function flipSpec(i) {
    const n = V.length, a = V[(i - 1 + n) % n], v = V[i], c = V[(i + 1) % n];
    const m = scale(add(a, c), .5), k = norm(sub(c, a)), r0 = sub(v, m);
    let s = cross(k, r0);
    const toCam = sub(camPos(), m);
    if (dot(s, toCam) < 0) s = scale(s, -1);
    const w = add(a, sub(c, v));
    return {
      dur: 700,
      disp: t => { const th = Math.PI * easeInOut(t), D = V.map(p => p.slice()); D[i] = add(m, add(scale(r0, Math.cos(th)), scale(s, Math.sin(th)))); return D; },
      done: () => { V[i] = w; },
    };
  }
  function cutSpec(i) {
    const n = V.length, a = V[(i - 1 + n) % n], b = V[i], c = V[(i + 1) % n], d = V[(i + 2) % n], j = (i + 1) % n;
    return {
      dur: 560,
      disp: t => { const e = easeInOut(t), D = V.map(p => p.slice()); D[i] = lerp3(b, a, e); D[j] = lerp3(c, d, e); return D; },
      done: () => { V = j === 0 ? V.slice(1, n - 1) : V.filter((_, k) => k !== i && k !== j); },
    };
  }
  // the reverse of a cut: two new vertices slide out of an edge into the empty square beside it
  function insertSpec(W, idxs, starts) {
    return {
      dur: 560,
      disp: t => { const e = easeInOut(t), D = W.map(p => p.slice()); idxs.forEach((x, k) => { D[x] = lerp3(starts[k], W[x], e); }); return D; },
      done: () => { V = W; },
    };
  }
  const forward = {
    flip: r => flipSpec(r.i),
    cut: r => cutSpec(r.i),
    push: r => {
      const n = V.length, a = V[r.i], b = V[(r.i + 1) % n], p = add(a, r.e), q = add(b, r.e);
      const at = r.i < n - 1 ? r.i + 1 : n;
      r.at = at;
      const W = V.slice(0, at).concat([p, q], V.slice(at));
      return insertSpec(W, [at, at + 1], [a, b]);
    },
  };
  const backward = {
    flip: r => flipSpec(r.i),
    cut: r => {
      const n = V.length;
      if (r.wrap) { const W = [r.c, ...V, r.b]; return insertSpec(W, [0, n + 1], [V[0], V[n - 1]]); }
      const W = V.slice(0, r.i).concat([r.b, r.c], V.slice(r.i));
      return insertSpec(W, [r.i, r.i + 1], [V[(r.i - 1 + n) % n], V[r.i % n]]);
    },
    push: r => cutSpec(r.at),
  };
  function record(type, i, extra = {}) {
    const n = V.length;
    if (type === "cut") return { t: "cut", i, b: V[i], c: V[(i + 1) % n], wrap: i === n - 1 };
    return { t: type, i, ...extra };
  }
  async function play(rec, { log = true } = {}) {
    const spec = forward[rec.t](rec);
    if (log) hist.push(rec);
    await animate(spec);
  }
  function applyNow(rec) { const s = forward[rec.t](rec); s.done(); hist.push(rec); }
  async function undo() {
    if (busy || !hist.length) return;
    const rec = hist.pop();
    await animate(backward[rec.t](rec));
  }

  /* ---------- the knot on the bench */
  function load(id, extra) {
    token++; solving = false;
    knotId = id; knot = KNOTS[id];
    V = verticesOf(minWord(id)); minLen = V.length; hist = [];
    if (extra) tangle(extra);
    $$("[data-knot]").forEach(b => b.setAttribute("aria-pressed", String(b.dataset.knot === id)));
    out("p").textContent = knot.p;
    out("min").textContent = minLen;
    setCaption(extra ? `A tangled ${knot.common}, ${V.length} steps. Flip corners and cut U-turns to bring it down to ${minLen}.` : `The shortest known ${knot.common}: ${minLen} steps.`);
    afterChange(true);
  }
  function tangle(extra) {
    const goal = V.length + extra;
    let guard = 0;
    const rnd = a => a[Math.floor(Math.random() * a.length)];
    while (V.length < goal && guard++ < 4000) {
      for (let k = 0; k < 3; k++) { const fs = cornersOf(V).filter(c => c.free); if (fs.length) applyNow(record("flip", rnd(fs).i)); }
      const i = Math.floor(Math.random() * V.length), ds = pushDirs(V, i);
      if (ds.length) applyNow(record("push", i, { e: rnd(ds) }));
    }
    for (let k = 0; k < 10; k++) { const fs = cornersOf(V).filter(c => c.free); if (fs.length) applyNow(record("flip", rnd(fs).i)); }
  }

  /* ---------- after every change: invariants, the inset, the markers */
  function afterChange(snap) {
    disp = V.map(p => p.slice());
    const D = diagramOf(V, L, knot.p);
    lastDiagram = D;
    out("len").textContent = V.length;
    out("cr").textContent = D.cr.length;
    out("col").textContent = D.count;
    const expect = { 3: 9, 5: 25, 7: 49 }[knot.p];
    out("verdict").textContent = D.count === expect ? `still the ${knot.common}` : (D.count === knot.p ? "only one colour at a time" : "");
    status();
    drawInset(D);
    buildMarkers();
    $$("[data-act='undo']").forEach(b => { b.disabled = !hist.length; });
    if (snap) fit(true);
  }
  function status() {
    const el = out("status");
    if (demoTitle) { el.textContent = ""; return; }
    if (!minLen) { el.textContent = "Free play: flip, cut and push the demonstration's knot."; return; }
    if (V.length === minLen) {
      if (knotId === "5_2") el.innerHTML = proofDone
        ? `<b>36 steps.</b> No one can do better: that is the theorem this atlas proves.`
        : `<b>36 steps.</b> Nobody has found a shorter 5₂; the proof that none exists rests on 1358 checks, ${partsDone} in so far.`;
      else el.innerHTML = `<b>${minLen} steps, the minimum.</b> ${knot.who}.`;
    } else if (V.length < minLen) el.innerHTML = `<b>Shorter than the minimum?</b> That cannot happen.`;
    else el.innerHTML = `${(V.length - minLen) / 2} more U-turn${V.length - minLen === 2 ? "" : "s"} to remove.`;
  }

  function drawInset(D) {
    const P = D.P, xs = P.map(p => p[0]), ys = P.map(p => p[1]);
    const span = Math.max(Math.max(...xs) - Math.min(...xs), Math.max(...ys) - Math.min(...ys)) * 1.18 || 1;
    const cx = (Math.min(...xs) + Math.max(...xs)) / 2, cy = (Math.min(...ys) + Math.max(...ys)) / 2;
    insetSvg.setAttribute("viewBox", `${cx - span / 2} ${cy - span / 2} ${span} ${span}`);
    const sw = span / 70, gap = span * 0.026, cols = palette();
    let s = "";
    for (const q of pieces(P, D.cr, gap, D.arcs)) {
      const col = D.colouring ? cols[D.colouring[q.arc] % 7] : "var(--ink)";
      s += `<line x1="${q.x1.toFixed(3)}" y1="${q.y1.toFixed(3)}" x2="${q.x2.toFixed(3)}" y2="${q.y2.toFixed(3)}" stroke="${col}" stroke-width="${sw.toFixed(3)}" stroke-linecap="round"/>`;
    }
    insetSvg.innerHTML = s;
    out("inset").textContent = `${D.cr.length} crossings · ${D.count} ${knot.p}-colourings`;
  }

  /* ---------- markers: one button per possible move */
  function buildMarkers() {
    markersEl.innerHTML = "";
    if (demoTitle) return;
    const mk = (cls, label, pos, data) => {
      const b = document.createElement("button");
      b.type = "button"; b.className = "mk " + cls; b.setAttribute("aria-label", label);
      b._pos = pos; b._data = data;
      b.addEventListener("pointerenter", () => setHover(data));
      b.addEventListener("pointerleave", () => setHover(null));
      b.addEventListener("focus", () => setHover(data));
      b.addEventListener("blur", () => setHover(null));
      b.addEventListener("click", () => act(data));
      markersEl.appendChild(b);
      return b;
    };
    if (tool === "flip") {
      for (const c of cornersOf(V)) mk(c.free ? "corner" : "corner blocked", c.free ? `Flip the corner at (${c.v})` : `Blocked corner at (${c.v})`, c.v, { t: "flip", ...c });
      for (const u of uturnsOf(V)) mk("uturn", `Cut the U-turn at (${u.b}) and (${u.c})`, scale(add(add(u.a, u.b), add(u.c, u.d)), .25), { t: "cut", ...u });
    } else {
      for (let i = 0; i < V.length; i++) {
        const ds = pushDirs(V, i);
        if (ds.length) mk("push", `Push the edge from (${V[i]}) out`, lerp3(V[i], V[(i + 1) % V.length], .5), { t: "push", i, ds });
      }
    }
    out("moves").textContent = tool === "flip"
      ? `${cornersOf(V).filter(c => c.free).length} corners can flip · ${uturnsOf(V).length} U-turns can be cut`
      : `${markersEl.children.length} edges can be pushed out`;
  }
  function setHover(d) { hover = d; paintTint(); }
  function paintTint() {
    tint.array.fill(0);
    const n = V.length;
    if (hover && !busy) {
      const on = j => { tint.array[((j % n) + n) % n] = 1; };
      if (hover.t === "flip") { on(hover.i - 1); on(hover.i); }
      if (hover.t === "cut") { on(hover.i - 1); on(hover.i); on(hover.i + 1); }
      if (hover.t === "push") on(hover.i);
    }
    tint.needsUpdate = true;
  }
  function bestPushDir(i, ds) {
    // the direction that shows most clearly from where the reader is looking
    const a = V[i];
    let best = ds[0], bl = -1;
    for (const e of ds) { const s = screenOf(a), t = screenOf(add(a, e)); const l = Math.hypot(t[0] - s[0], t[1] - s[1]); if (l > bl) { bl = l; best = e; } }
    return best;
  }
  async function act(d) {
    if (busy) return;
    token++; demoTitle = ""; solving = false;
    if (d.t === "flip" && !d.free) {
      flash(d.w);
      setCaption(`Blocked: the fourth corner of that square, (${d.w}), is already on the knot.`);
      return;
    }
    hover = null; paintTint();
    if (d.t === "flip") { setCaption("A corner flip: two steps swap order and the corner swings across its square."); await play(record("flip", d.i)); }
    if (d.t === "cut") { setCaption("A U-turn removal: three sides of a square become the fourth. Two steps shorter."); await play(record("cut", d.i)); }
    if (d.t === "push") { setCaption("The reverse of a U-turn removal: two steps longer, same knot."); await play(record("push", d.i, { e: bestPushDir(d.i, d.ds) })); }
  }
  function flash(p) {
    const s = screenOf(p);
    const c = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    c.setAttribute("cx", s[0]); c.setAttribute("cy", s[1]); c.setAttribute("r", 15);
    c.setAttribute("class", "flash");
    ghost.appendChild(c);
    c.animate([{ opacity: 1, r: 9 }, { opacity: 0, r: 22 }], { duration: 1000, easing: "cubic-bezier(.16,1,.3,1)" }).onfinish = () => c.remove();
  }
  function hint() {
    if (busy) return;
    const us = uturnsOf(V);
    if (V.length === minLen) { setCaption("Already as short as it gets."); return; }
    let pick = null;
    if (us.length) pick = [...markersEl.children].find(b => b._data.t === "cut");
    else {
      const base = uturnsOf(V).length;
      for (const c of cornersOf(V).filter(c => c.free)) {
        const W = V.map(p => p.slice()); W[c.i] = c.w;
        if (uturnsOf(W).length > base) { pick = [...markersEl.children].find(b => b._data.t === "flip" && b._data.i === c.i); break; }
      }
    }
    if (!pick) { setCaption("No single flip opens a U-turn here. Push an edge out to make room, or undo."); return; }
    setCaption(pick._data.t === "cut" ? "Hint: this U-turn can go." : "Hint: flipping this corner opens a U-turn.");
    pick.classList.add("hinted"); pick.focus({ preventScroll: true });
    setTimeout(() => pick.classList.remove("hinted"), 2400);
  }
  async function solve() {
    if (busy || !hist.length) return;
    const my = ++token; solving = true; demoTitle = "";
    setCaption(`Untangling: every move undone in reverse, ${hist.length} moves.`);
    while (hist.length && my === token) await undo();
    solving = false;
    if (my === token) setCaption(`Back to ${minLen} steps.`);
  }

  /* ---------- camera */
  function camPos() {
    return [target[0] + dist * Math.cos(el) * Math.cos(az), target[1] + dist * Math.cos(el) * Math.sin(az), target[2] + dist * Math.sin(el)];
  }
  function fit(snap) {
    const P = disp.length ? disp : V;
    if (!P.length) return;
    const lo = [0, 1, 2].map(k => Math.min(...P.map(p => p[k]))), hi = [0, 1, 2].map(k => Math.max(...P.map(p => p[k])));
    const c = lo.map((x, k) => (x + hi[k]) / 2), r = Math.hypot(hi[0] - lo[0], hi[1] - lo[1], hi[2] - lo[2]) / 2 + 0.6;
    if (snap) { target = c; fitR = r; z0 = lo[2] - 0.75; }
    return { c, r, zmin: lo[2] };
  }
  function screenOf(p) {
    const v = new THREE.Vector3(p[0], p[1], p[2]).project(camera);
    return [(v.x + 1) / 2 * stageEl.clientWidth, (1 - v.y) / 2 * stageEl.clientHeight, v.z];
  }

  /* ---------- pointer: drag to turn, wheel or pinch to zoom */
  // the slow turn waits while the reader's pointer is on the bench, so the move markers hold still
  let pointerOver = false;
  stageEl.addEventListener("pointerenter", e => { if (e.pointerType === "mouse") pointerOver = true; });
  stageEl.addEventListener("pointerleave", () => { pointerOver = false; });
  const ptrs = new Map();
  let pinch0 = 0, zoom = 1;
  const cv = renderer.domElement;
  cv.addEventListener("pointerdown", e => { ptrs.set(e.pointerId, [e.clientX, e.clientY]); try { cv.setPointerCapture(e.pointerId); } catch {} spin = false; syncToggles(); if (ptrs.size === 2) { const [a, b] = [...ptrs.values()]; pinch0 = Math.hypot(a[0] - b[0], a[1] - b[1]) / zoom; } });
  cv.addEventListener("pointermove", e => {
    if (!ptrs.has(e.pointerId)) return;
    const p = ptrs.get(e.pointerId), dx = e.clientX - p[0], dy = e.clientY - p[1];
    ptrs.set(e.pointerId, [e.clientX, e.clientY]);
    if (ptrs.size === 1) { az -= dx * 0.008; el = Math.max(0.06, Math.min(1.5, el + dy * 0.006)); }
    else if (ptrs.size === 2) { const [a, b] = [...ptrs.values()]; zoom = Math.max(0.5, Math.min(2.4, Math.hypot(a[0] - b[0], a[1] - b[1]) / pinch0)); }
  });
  const up = e => { ptrs.delete(e.pointerId); };
  cv.addEventListener("pointerup", up); cv.addEventListener("pointercancel", up);
  cv.addEventListener("wheel", e => { e.preventDefault(); zoom = Math.max(0.5, Math.min(2.4, zoom * Math.exp(-e.deltaY * 0.0012))); }, { passive: false });

  /* ---------- the frame */
  let raf = 0, running = false, lastT = performance.now();
  function frame(now) {
    if (!running) return;
    const dt = Math.min(0.05, (now - lastT) / 1000);
    lastT = now;
    if (anim) {
      const t = Math.min(1, (now - anim.t0) / anim.dur);
      disp = anim.disp(t);
      if (t >= 1) finish();
    }
    if (lightAnim) {
      const t = Math.min(1, (now - lightAnim.t0) / lightAnim.dur);
      L = norm(lerp3(lightAnim.from, lightAnim.to, easeInOut(t)));
      if (t >= 1) lightAnim = null;
      const D = diagramOf(V, L, knot.p); lastDiagram = D; drawInset(D);
      out("cr").textContent = D.cr.length;
    }
    if (spin && !anim && !pointerOver) az += 0.07 * dt;
    // ease the camera towards the polygon as it changes
    const f = fit(false);
    if (f) {
      const k = 1 - Math.exp(-dt * 3.2);
      target = lerp3(target, f.c, k); fitR += (f.r - fitR) * k; z0 += (f.zmin - 0.75 - z0) * k;
    }
    render();
    raf = requestAnimationFrame(frame);
  }
  function render() {
    const w = stageEl.clientWidth, h = stageEl.clientHeight;
    if (!w || !h) return;
    const size = renderer.getSize(new THREE.Vector2());
    if (size.x !== w || size.y !== h) renderer.setSize(w, h, false);
    renderer.domElement.style.width = w + "px"; renderer.domElement.style.height = h + "px";
    camera.aspect = w / h;
    // on a wide bench the knot moves right of the diagram inset; on a tall one the inset sits above it
    const ins = root.querySelector(".lab-inset"), shift = showInset && ins && w > h ? (ins.offsetWidth + 12) / 2 : 0;
    const vfov = camera.fov * Math.PI / 180, hfov = 2 * Math.atan(Math.tan(vfov / 2) * (w - 2 * shift) / h);
    dist = fitR / Math.sin(Math.min(vfov, hfov) / 2) / zoom * 1.02;
    const cp = camPos();
    camera.position.set(cp[0], cp[1], cp[2]);
    camera.lookAt(target[0], target[1], target[2]);
    camera.near = Math.max(0.1, dist - fitR * 3); camera.far = dist + fitR * 6;
    // keep the knot clear of the diagram inset in the corner
    camera.setViewOffset(w, h, -shift, 0, w, h);
    camera.updateProjectionMatrix();
    // instances: one stick per edge, one knuckle per vertex
    const n = disp.length, m4 = new THREE.Matrix4(), q = new THREE.Quaternion(), Y = new THREE.Vector3(0, 1, 0);
    for (let i = 0; i < n; i++) {
      const A = v3(disp[i]), B = v3(disp[(i + 1) % n]), d = B.clone().sub(A), len = d.length();
      if (len > 1e-5) q.setFromUnitVectors(Y, d.clone().divideScalar(len)); else q.identity();
      m4.compose(A.clone().add(B).multiplyScalar(.5), q, new THREE.Vector3(R, Math.max(len, 1e-4), R));
      m4.toArray(edgeM.array, i * 16);
      m4.compose(A, new THREE.Quaternion(), new THREE.Vector3(R * 1.02, R * 1.02, R * 1.02));
      m4.toArray(vertM.array, i * 16);
    }
    edgeM.needsUpdate = true; vertM.needsUpdate = true;
    meshes.forEach((mm, k) => { mm.count = n; mm.visible = k > 1 || showShadow; });
    const pxPerUnit = h / (2 * dist * Math.tan(vfov / 2));
    engraveMats.forEach(mm => { mm.uniforms.uLines.value = Math.max(8, Math.min(40, Math.round(R * pxPerUnit * 1.15))); mm.uniforms.uDpr.value = dpr(); });
    shadowU.uZ0.value = z0; shadowU.uL.value.set(L[0], L[1], L[2]); shadowU.uDpr.value = dpr();
    grid.visible = showGrid;
    grid.position.set(target[0], target[1], z0 - 0.002);
    grid.scale.set(fitR * 5, fitR * 5, 1);
    gridU.uC.value.set(target[0], target[1]); gridU.uR.value = fitR * 2.3;
    renderer.render(scene, camera);
    placeMarkers();
  }
  function placeMarkers() {
    for (const b of markersEl.children) {
      const s = screenOf(b._pos);
      b.style.transform = `translate(${s[0].toFixed(1)}px, ${s[1].toFixed(1)}px)`;
    }
    // ghosts of the hovered move, and any rings a demonstration asks for
    let g = "";
    const P = p => screenOf(p).slice(0, 2).map(x => x.toFixed(1)).join(",");
    if (hover && !busy) {
      if (hover.t === "flip") g += `<polyline class="ghost-path${hover.free ? "" : " bad"}" points="${P(hover.a)} ${P(hover.w)} ${P(hover.c)}"/><circle class="ghost-dot${hover.free ? "" : " bad"}" cx="${P(hover.w).split(",")[0]}" cy="${P(hover.w).split(",")[1]}" r="5"/>`;
      if (hover.t === "cut") g += `<polyline class="ghost-path" points="${P(hover.a)} ${P(hover.d)}"/>`;
      if (hover.t === "push") { const e = bestPushDir(hover.i, hover.ds), a = V[hover.i], b = V[(hover.i + 1) % V.length]; g += `<polyline class="ghost-path" points="${P(a)} ${P(add(a, e))} ${P(add(b, e))} ${P(b)}"/>`; }
    }
    for (const r of rings) { const s = screenOf(r.p); g += `<circle class="ring-mark${r.taken ? " taken" : ""}" cx="${s[0].toFixed(1)}" cy="${s[1].toFixed(1)}" r="9"/>`; }
    const keep = [...ghost.querySelectorAll(".flash")];
    ghost.innerHTML = g;
    keep.forEach(k => ghost.appendChild(k));
  }

  /* ---------- the demonstrations */
  const sleep = ms => new Promise(r => setTimeout(r, reduced ? Math.min(ms, 300) : ms));
  function setCaption(t) { captionEl.textContent = t; }
  function stage(Vlist, { id = "3_1", az: a = -0.9, el: e = 0.6 } = {}) {
    knotId = id; knot = KNOTS[id];
    V = Vlist.map(p => p.slice()); hist = []; minLen = 0;
    out("min").textContent = "—"; out("p").textContent = knot.p;
    az = a; el = e; zoom = 1;
    afterChange(true);
  }
  const DEMOS = {
    async flip(my) {
      demoTitle = "Corner flip";
      stage([[0, 0, 0], [1, 0, 0], [2, 0, 0], [3, 0, 0], [3, 1, 0], [3, 2, 0], [2, 2, 0], [1, 2, 0], [0, 2, 0], [0, 1, 0]], { az: -1.1, el: .75 });
      setCaption("Two perpendicular steps meet at a corner. The fourth corner of their unit square is empty.");
      rings = [{ p: [2, 1, 0] }]; await sleep(2200); if (my !== token) return;
      rings = [];
      setCaption("So the steps can swap order: the corner swings across the square, through space, and lands on the other side.");
      await play(record("flip", 3), { log: false }); await sleep(1200); if (my !== token) return;
      setCaption("Another corner, the same move. The knot never changes and the length stays the same.");
      await play(record("flip", 0), { log: false }); await sleep(1400); if (my !== token) return;
      rings = [{ p: [2, 1, 0], taken: true }];
      setCaption("But this corner is stuck: the fourth corner of its square is now part of the knot, so it may not flip.");
      flash([2, 1, 0]); await sleep(2600); rings = [];
    },
    async uturn(my) {
      demoTitle = "U-turn removal";
      stage([[0, 0, 0], [1, 0, 0], [1, 0, 1], [2, 0, 1], [2, 0, 0], [3, 0, 0], [3, 1, 0], [3, 2, 0], [2, 2, 0], [1, 2, 0], [0, 2, 0], [0, 1, 0]], { az: -1.25, el: .45 });
      setCaption("Up, across, down: three sides of a unit square, a U-turn.");
      await sleep(2200); if (my !== token) return;
      setCaption("Replace the three sides by the fourth. The square meets the knot only in those sides, so the knot is unchanged, and two sticks shorter.");
      await play(record("cut", 2), { log: false }); await sleep(2400);
    },
    async curtain(my) {
      demoTitle = "The curtain";
      stage([[-2, 0, 0], [-1, 0, 0], [0, 0, 0], [0, 0, 1], [1, 0, 1], [2, 0, 1], [2, 1, 1], [2, 1, 0], [3, 1, 0], [4, 1, 0], [4, 2, 0], [4, 3, 0], [3, 3, 0], [2, 3, 0], [1, 3, 0], [0, 3, 0], [-1, 3, 0], [-2, 3, 0], [-2, 2, 0], [-2, 1, 0]], { az: -1.3, el: .5 });
      rings = [{ p: [1, 0, 0] }, { p: [2, 0, 0] }];
      setCaption("A curtain: a step up, three steps across, a step down. The ringed points under its middle are empty.");
      await sleep(2600); if (my !== token) return;
      setCaption("Flip 1: the up-step slides one place along.");
      rings = [];
      await play(record("flip", 3), { log: false }); await sleep(700); if (my !== token) return;
      setCaption("Flip 2: and one more.");
      await play(record("flip", 4), { log: false }); await sleep(900); if (my !== token) return;
      setCaption("Now up and down sit side by side, a U-turn. Cut it.");
      await sleep(1100); if (my !== token) return;
      await play(record("cut", 5), { log: false }); await sleep(600);
      setCaption("Two steps shorter, the same knot. So a shortest polygon always has a vertex under every curtain: condition C6.");
      await sleep(2600);
    },
    async shadow(my) {
      demoTitle = "The shadow is the diagram";
      L = norm([0.34, -0.52, 1]);
      stage(verticesOf(DATA.w36), { id: "5_2", az: -0.6, el: .6 });
      minLen = 36; out("min").textContent = 36;
      setCaption("The 36-step polygon, lit from an ordinary direction: its shadow has many crossings.");
      await sleep(2400); if (my !== token) return;
      setCaption("Swing the light to the direction (3, −2, 8)…");
      lightAnim = { from: L, to: norm([3, -2, 8]), t0: performance.now(), dur: reduced ? 1 : 3200 };
      await sleep(3500); if (my !== token) return;
      setCaption("…and the shadow is the five-crossing diagram that every knot table prints for 5₂, coloured by one of its 49 seven-colourings.");
      await sleep(3000);
    },
  };
  async function runDemo(name) {
    if (busy) return;
    const my = ++token;
    solving = false;
    $$("[data-demo]").forEach(b => b.setAttribute("aria-pressed", String(b.dataset.demo === name)));
    spin = false; syncToggles();
    await DEMOS[name](my);
    if (my === token) { demoTitle = ""; $$("[data-demo]").forEach(b => b.setAttribute("aria-pressed", "false")); afterChange(); }
  }

  /* ---------- controls */
  function syncToggles() {
    const set = (n, v) => { const b = $(`[data-toggle="${n}"]`); if (b) b.setAttribute("aria-pressed", String(v)); };
    set("shadow", showShadow); set("grid", showGrid); set("inset", showInset); set("spin", spin);
    $(".lab-inset").hidden = !showInset;
  }
  $$("[data-knot]").forEach(b => b.addEventListener("click", () => { if (!busy) { demoTitle = ""; rings = []; load(b.dataset.knot, +($("[data-tangle][aria-pressed='true']")?.dataset.tangle || 8)); } }));
  $$("[data-tangle]").forEach(b => b.addEventListener("click", () => { if (busy) return; $$("[data-tangle]").forEach(x => x.setAttribute("aria-pressed", String(x === b))); demoTitle = ""; rings = []; load(knotId === "5_2" || KNOTS[knotId] ? knotId : "3_1", +b.dataset.tangle); }));
  $$("[data-tool]").forEach(b => b.addEventListener("click", () => { tool = b.dataset.tool; $$("[data-tool]").forEach(x => x.setAttribute("aria-pressed", String(x === b))); hover = null; paintTint(); buildMarkers(); }));
  $$("[data-act]").forEach(b => b.addEventListener("click", () => {
    const a = b.dataset.act;
    if (a === "undo") { token++; undo(); }
    if (a === "new") { if (!busy) { demoTitle = ""; rings = []; load(minWord(knotId) && KNOTS[knotId] ? knotId : "3_1", +($("[data-tangle][aria-pressed='true']")?.dataset.tangle || 8)); } }
    if (a === "hint") hint();
    if (a === "solve") solve();
    if (a === "light") { if (busy) return; const to = Math.abs(L[0] - norm([3, -2, 8])[0]) < 1e-3 ? norm([0.34, -0.52, 1]) : norm([3, -2, 8]); lightAnim = { from: L, to, t0: performance.now(), dur: reduced ? 1 : 1800 }; b.setAttribute("aria-pressed", String(to[0] > 0.3)); }
  }));
  $$("[data-toggle]").forEach(b => b.addEventListener("click", () => {
    const t = b.dataset.toggle;
    if (t === "shadow") showShadow = !showShadow;
    if (t === "grid") showGrid = !showGrid;
    if (t === "inset") showInset = !showInset;
    if (t === "spin") spin = !spin;
    syncToggles();
  }));
  $$("[data-demo]").forEach(b => b.addEventListener("click", () => runDemo(b.dataset.demo)));
  $$("[data-mode]").forEach(b => b.addEventListener("click", () => {
    const m = b.dataset.mode;
    $$("[data-mode]").forEach(x => x.setAttribute("aria-selected", String(x === b)));
    $$("[data-panel]").forEach(p => { p.hidden = p.dataset.panel !== m; });
    if (m === "play" && demoTitle) { token++; demoTitle = ""; rings = []; load(knotId in KNOTS && minWord(knotId) ? knotId : "3_1", 8); }
  }));
  root.addEventListener("keydown", e => {
    if (e.target.closest("input, textarea")) return;
    if (e.key === "u" || e.key === "U" || ((e.ctrlKey || e.metaKey) && e.key === "z")) { e.preventDefault(); token++; undo(); }
    if (e.key === "h" || e.key === "H") hint();
  });

  load("3_1", 8);
  syncToggles();
  render();

  return {
    activate() { if (running) return; running = true; lastT = performance.now(); raf = requestAnimationFrame(frame); },
    deactivate() { running = false; cancelAnimationFrame(raf); },
  };
}
