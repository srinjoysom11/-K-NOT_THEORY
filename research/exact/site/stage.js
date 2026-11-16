// The engraved specimen. A lattice polygon is drawn as a copperplate engraving of a model made of
// unit sticks: hatch lines that swell with the shade, a collar at every unit step, mitred corners,
// a hatched cast shadow, and a clear margin of paper wherever one stick passes in front of another.
// Raw WebGL2, no library. Where WebGL2 is missing the same poses are drawn as an SVG line figure.
import { centre, crossings, arcsOf, pieces } from "./knot.js";

const VS = `#version 300 es
layout(location=0) in vec2 aTA;
layout(location=1) in vec3 iA;
layout(location=2) in vec3 iB;
layout(location=3) in vec3 iP;
layout(location=4) in vec3 iN;
layout(location=5) in float iIdx;
uniform mat3 uR;
uniform vec2 uCenter, uView;
uniform float uScale, uRad;
uniform vec4 uShadow;
uniform int uMode;
out vec3 vP; out vec3 vN; out vec3 vQ; out float vS; out float vAng;
flat out vec3 fA, fB, fDp, fDn, fD; flat out int fIdx;
void main() {
  vec3 d = normalize(iB - iA);
  vec3 u = abs(d.z) > 0.5 ? vec3(1., 0., 0.) : vec3(0., 0., 1.);
  vec3 v = cross(d, u);
  vec3 n = cos(aTA.y) * u + sin(aTA.y) * v;
  vec3 P = mix(iA - d * uRad, iB + d * uRad, aTA.x) + uRad * n;
  vP = P; vN = n; vAng = aTA.y; vS = iIdx + dot(P - iA, d);
  fA = iA; fB = iB; fDp = iP; fDn = iN; fD = d; fIdx = int(iIdx + .5);
  vQ = uR * P;
  if (uMode == 2) { P.xy -= uShadow.xy * ((P.z - uShadow.w) / uShadow.z); P.z = uShadow.w; }
  vec3 q = uR * P;
  vec2 px = uCenter + vec2(q.x, -q.y) * uScale;
  float z = uMode == 2 ? 0.9 : clamp(-q.z * 0.045, -0.95, 0.95);
  gl_Position = vec4(px.x / uView.x * 2. - 1., 1. - px.y / uView.y * 2., z, 1.);
}`;

const FS = `#version 300 es
precision highp float; precision highp int;
in vec3 vP; in vec3 vN; in vec3 vQ; in float vS; in float vAng;
flat in vec3 fA, fB, fDp, fDn, fD; flat in int fIdx;
uniform mat3 uR;
uniform int uMode, uNC;
uniform float uBuild, uRpx, uRadU, uLines, uRings, uSolid, uAmt, uColMix, uDpr, uShadowW;
uniform vec2 uCenter;
uniform vec3 uInk, uLight;
uniform float uCuts[8];
uniform vec3 uCols[8];
uniform vec3 uPV[41];
uniform int uNV;
uniform float uGap;
out vec4 o;
float lineCov(float c, float w) {
  // one family of parallel engraved lines: c counts lines, w is the inked share of each period
  float d = abs(fract(c) - .5) * 2.;
  float aa = fwidth(c) * 1.4;
  float hard = 1. - smoothstep(1. - w - aa, 1. - w + aa, d);
  return w <= 0.001 ? 0. : mix(hard, w, smoothstep(.45, 1.1, aa));
}
void main() {
  float e0 = dot(vP - fA, fDp + fD) / max(length(fDp + fD), 1e-4);
  float e1 = -dot(vP - fB, fD + fDn) / max(length(fD + fDn), 1e-4);
  if (e0 < 0. || e1 < 0.) discard;
  if (vS > uBuild) discard;
  if (uMode == 1) { o = vec4(0.); return; }
  if (uMode == 2) {
    vec2 p = (gl_FragCoord.xy - vec2(uCenter.x, 0.)) / uDpr;
    float a = lineCov((p.x * .8 + p.y * .6) / 5.2, uShadowW);
    o = vec4(uInk * a, a) * uAmt; return;
  }
  // where a stick that is not a neighbour passes in front, this one stops short: the gap of a knot diagram
  for (int j = 0; j < 40; j++) {
    if (j >= uNV) break;
    int dj = j - fIdx; if (dj < 0) dj = -dj;
    if (dj <= 1 || dj == uNV - 1) continue;
    vec3 a = uPV[j], b = uPV[j + 1];
    vec2 ab = b.xy - a.xy;
    float t = clamp(dot(vQ.xy - a.xy, ab) / max(dot(ab, ab), 1e-6), 0., 1.);
    if (float(j) + t > uBuild) continue;
    if (distance(vQ.xy, a.xy + t * ab) < uGap && mix(a.z, b.z, t) - vQ.z > .5) discard;
  }
  vec3 col = uInk;
  if (uColMix > 0.) {
    int k = 0;
    for (int i = 0; i < 8; i++) if (i < uNC && vS > uCuts[i]) k++;
    if (uNC > 0) col = mix(uInk, uCols[k % uNC], uColMix);
  }
  if (!gl_FrontFacing) { o = vec4(col, 1.) * uAmt; return; }
  vec3 n = normalize(uR * vN);
  float shade = clamp(.5 - .5 * dot(n, uLight), 0., 1.);
  // lengthwise lines carry the tone; rings come in as cross-hatching in the deep shade
  float wa = .8 * smoothstep(.34, .96, shade);
  float wb = .5 * smoothstep(.74, 1., shade);
  float a = max(lineCov(vAng * uLines / 6.2831853, wa), lineCov(vS * uRings, wb));
  // the contour: a line of constant weight along the silhouette
  float dpx = uRpx * (1. - sqrt(max(0., 1. - n.z * n.z)));
  float lw = 1.15 * uDpr;
  a = max(a, 1. - smoothstep(lw - .6 * uDpr, lw + .6 * uDpr, dpx));
  // a fine ring at every unit step, and along every mitre
  float epx = min(e0, e1) * uRpx / max(uRadU, 1e-4);
  a = max(a, 1. - smoothstep(.55 * uDpr, 1.25 * uDpr, epx));
  a = mix(a, 1., uSolid);
  o = vec4(col * a, a) * uAmt;
}`;

const VS_BEAD = `#version 300 es
layout(location=0) in vec3 aPos;
uniform mat3 uR; uniform vec2 uCenter, uView; uniform float uScale, uRad; uniform vec3 uPos;
out vec3 vN;
void main() {
  vN = aPos;
  vec3 q = uR * (uPos + aPos * uRad);
  vec2 px = uCenter + vec2(q.x, -q.y) * uScale;
  gl_Position = vec4(px.x / uView.x * 2. - 1., 1. - px.y / uView.y * 2., clamp(-q.z * 0.045, -0.95, 0.95), 1.);
}`;
const FS_BEAD = `#version 300 es
precision highp float; precision highp int;
in vec3 vN; uniform mat3 uR; uniform vec3 uCol, uLight; uniform float uAmt, uDpr; uniform int uMode;
out vec4 o;
void main() {
  if (uMode == 1) { o = vec4(0.); return; }
  vec3 n = normalize(uR * vN);
  float shade = clamp(.5 - .5 * dot(n, uLight), 0., 1.);
  vec2 p = gl_FragCoord.xy / uDpr;
  float d = abs(fract((p.x * .8 + p.y * .6) / 3.2) - .5) * 2.;
  float w = .75 * smoothstep(.45, .95, shade);
  float hatch = w <= 0.001 ? 0. : 1. - smoothstep(1. - w - .25, 1. - w + .25, d);
  vec3 c = mix(uCol, uCol * .45, hatch);
  o = vec4(c, 1.) * uAmt;
}`;

const VS_GRID = `#version 300 es
layout(location=0) in vec2 aXY;
uniform mat3 uR; uniform vec2 uCenter, uView; uniform float uScale, uZ, uSpan;
out vec2 vXY;
void main() {
  vXY = aXY * uSpan;
  vec3 q = uR * vec3(vXY, uZ);
  vec2 px = uCenter + vec2(q.x, -q.y) * uScale;
  gl_Position = vec4(px.x / uView.x * 2. - 1., 1. - px.y / uView.y * 2., 0.95, 1.);
}`;
const FS_GRID = `#version 300 es
precision highp float; precision highp int;
in vec2 vXY; uniform vec2 uOff; uniform vec3 uInk; uniform float uAmt, uSpan;
out vec4 o;
void main() {
  vec2 g = vXY + uOff;
  vec2 d = abs(fract(g - .5) - .5) / fwidth(g);
  float line = 1. - min(min(d.x, d.y), 1.);
  float fade = 1. - smoothstep(uSpan * .45, uSpan * .98, length(vXY));
  float a = line * fade * uAmt * .3;
  o = vec4(uInk * a, a);
}`;

function program(gl, vs, fs) {
  const p = gl.createProgram();
  for (const [type, src] of [[gl.VERTEX_SHADER, vs], [gl.FRAGMENT_SHADER, fs]]) {
    const s = gl.createShader(type);
    gl.shaderSource(s, src); gl.compileShader(s);
    if (!gl.getShaderParameter(s, gl.COMPILE_STATUS)) throw new Error(gl.getShaderInfoLog(s));
    gl.attachShader(p, s);
  }
  gl.linkProgram(p);
  if (!gl.getProgramParameter(p, gl.LINK_STATUS)) throw new Error(gl.getProgramInfoLog(p));
  const u = {};
  const n = gl.getProgramParameter(p, gl.ACTIVE_UNIFORMS);
  for (let i = 0; i < n; i++) {
    const name = gl.getActiveUniform(p, i).name.replace(/\[0\]$/, "");
    u[name] = gl.getUniformLocation(p, name);
  }
  return { p, u };
}

const norm = v => { const l = Math.hypot(...v) || 1; return v.map(x => x / l); };
const cross3 = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const dot3 = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];

/* the view along direction (az, el), z up: rows are screen-right, screen-up and towards-the-viewer */
export function viewOf(az, el) {
  const n = [Math.cos(el) * Math.cos(az), Math.cos(el) * Math.sin(az), Math.sin(el)];
  let up = [0, 0, 1];
  if (Math.abs(n[2]) > 0.999) up = [0, 1, 0];
  const r = norm(cross3(up, n)), u = cross3(n, r);
  return [r, u, n];
}
export const anglesOf = d => { const n = norm(d); return [Math.atan2(n[1], n[0]), Math.asin(n[2])]; };
export const project = (R, p) => [dot3(R[0], p), -dot3(R[1], p), dot3(R[2], p)];

const LIGHT = norm([-0.6, 0.7, 0.4]);      // in view space: from the upper left, in front
const K = 28;                                  // sides of a stick

class GLStage {
  constructor(host) {
    this.host = host;
    const c = this.canvas = document.createElement("canvas");
    c.setAttribute("aria-hidden", "true");
    host.appendChild(c);
    const gl = this.gl = c.getContext("webgl2", { antialias: true, alpha: true, premultipliedAlpha: true, powerPreference: "high-performance" });
    if (!gl) { c.remove(); throw new Error("no webgl2"); }
    this.kind = "gl";
    try {
      this.tube = program(gl, VS, FS);
      this.bead = program(gl, VS_BEAD, FS_BEAD);
      this.grid = program(gl, VS_GRID, FS_GRID);
    } catch (e) { c.remove(); throw e; }
    // one stick: a strip of K quads, drawn once per edge
    const tv = [], ti = [];
    for (let k = 0; k <= K; k++) { const a = k / K * 2 * Math.PI; tv.push(0, a, 1, a); }
    for (let k = 0; k < K; k++) { const a = 2 * k; ti.push(a, a + 2, a + 1, a + 1, a + 2, a + 3); }
    this.stickV = gl.createBuffer(); gl.bindBuffer(gl.ARRAY_BUFFER, this.stickV); gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(tv), gl.STATIC_DRAW);
    this.stickI = gl.createBuffer(); gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.stickI); gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(ti), gl.STATIC_DRAW);
    this.stickN = ti.length;
    // a bead
    const sv = [], si = [], A = 24, B = 14;
    for (let j = 0; j <= B; j++) for (let i = 0; i <= A; i++) {
      const th = j / B * Math.PI, ph = i / A * 2 * Math.PI;
      sv.push(Math.sin(th) * Math.cos(ph), Math.sin(th) * Math.sin(ph), Math.cos(th));
    }
    for (let j = 0; j < B; j++) for (let i = 0; i < A; i++) { const a = j * (A + 1) + i, b = a + A + 1; si.push(a, b, a + 1, a + 1, b, b + 1); }
    this.beadVAO = gl.createVertexArray(); gl.bindVertexArray(this.beadVAO);
    const bv = gl.createBuffer(); gl.bindBuffer(gl.ARRAY_BUFFER, bv); gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(sv), gl.STATIC_DRAW);
    gl.enableVertexAttribArray(0); gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);
    const bi = gl.createBuffer(); gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, bi); gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(si), gl.STATIC_DRAW);
    this.beadN = si.length;
    this.gridVAO = gl.createVertexArray(); gl.bindVertexArray(this.gridVAO);
    const gv = gl.createBuffer(); gl.bindBuffer(gl.ARRAY_BUFFER, gv); gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1]), gl.STATIC_DRAW);
    gl.enableVertexAttribArray(0); gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 0, 0);
    gl.bindVertexArray(null);
    this.specimens = [];
    this.lost = false;
    c.addEventListener("webglcontextlost", e => { e.preventDefault(); this.lost = true; });
  }
  /* V: lattice vertices of a closed polygon. Returns a handle. */
  specimen(V0) {
    const gl = this.gl, V = centre(V0), n = V.length;
    const off = V0[0].map((c, k) => c - V[0][k]);
    const inst = new Float32Array(n * 13);
    for (let i = 0; i < n; i++) {
      const a = V[i], b = V[(i + 1) % n], p = V[(i - 1 + n) % n], q = V[(i + 2) % n];
      inst.set([...a, ...b, a[0] - p[0], a[1] - p[1], a[2] - p[2], q[0] - b[0], q[1] - b[1], q[2] - b[2], i], i * 13);
    }
    const vao = gl.createVertexArray(); gl.bindVertexArray(vao);
    gl.bindBuffer(gl.ARRAY_BUFFER, this.stickV);
    gl.enableVertexAttribArray(0); gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 0, 0);
    const ib = gl.createBuffer(); gl.bindBuffer(gl.ARRAY_BUFFER, ib); gl.bufferData(gl.ARRAY_BUFFER, inst, gl.STATIC_DRAW);
    [[1, 3, 0], [2, 3, 12], [3, 3, 24], [4, 3, 36], [5, 1, 48]].forEach(([loc, size, o]) => {
      gl.enableVertexAttribArray(loc); gl.vertexAttribPointer(loc, size, gl.FLOAT, false, 52, o); gl.vertexAttribDivisor(loc, 1);
    });
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.stickI);
    gl.bindVertexArray(null);
    const s = { V, n, vao, off, zmin: Math.min(...V.map(p => p[2])), R: Math.max(...V.map(p => Math.hypot(...p))) };
    this.specimens.push(s);
    return s;
  }
  resize() {
    const dpr = Math.min(window.devicePixelRatio || 1, 2), w = this.host.clientWidth, h = this.host.clientHeight;
    this.w = w; this.h = h; this.dpr = dpr;
    const W = Math.max(1, Math.round(w * dpr)), H = Math.max(1, Math.round(h * dpr));
    if (this.canvas.width !== W || this.canvas.height !== H) { this.canvas.width = W; this.canvas.height = H; }
  }
  /* items: {spec, x, y, scale, az, el, build, radius, halo, solid, amt, shadow, grid, colMix, cuts, cols, bead} — x, y, scale in CSS px */
  draw(items, ink, alert) {
    const gl = this.gl;
    if (this.lost) return;
    this.resize();
    const dpr = this.dpr, W = this.canvas.width, H = this.canvas.height;
    gl.viewport(0, 0, W, H);
    gl.clearColor(0, 0, 0, 0); gl.clearDepth(1);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    for (const it of items) {
      if (!it || it.amt <= 0.002) continue;
      const s = it.spec, R = viewOf(it.az, it.el);
      const Rm = new Float32Array([R[0][0], R[1][0], R[2][0], R[0][1], R[1][1], R[2][1], R[0][2], R[1][2], R[2][2]]);
      const cx = it.x * dpr, cy = it.y * dpr, sc = it.scale * dpr, rad = it.radius ?? 0.1;
      const build = it.build ?? s.n + 1;
      const zg = s.zmin - rad - 0.02;
      // the light as it falls through the model, in lattice coordinates
      const lm = [0, 1, 2].map(k => -(R[0][k] * LIGHT[0] + R[1][k] * LIGHT[1] + R[2][k] * LIGHT[2]));
      const shadowAmt = (it.shadow ?? 0) * Math.max(0, Math.min(1, (-lm[2] - 0.2) / 0.3));

      gl.disable(gl.DEPTH_TEST); gl.depthMask(false);
      gl.enable(gl.BLEND); gl.blendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA);
      if ((it.grid ?? 0) > 0.002) {
        const g = this.grid; gl.useProgram(g.p); gl.bindVertexArray(this.gridVAO);
        gl.uniformMatrix3fv(g.u.uR, false, Rm); gl.uniform2f(g.u.uCenter, cx, cy); gl.uniform2f(g.u.uView, W, H);
        gl.uniform1f(g.u.uScale, sc); gl.uniform1f(g.u.uZ, zg); gl.uniform1f(g.u.uSpan, s.R * 1.9);
        gl.uniform2f(g.u.uOff, s.off[0], s.off[1]); gl.uniform3fv(g.u.uInk, ink); gl.uniform1f(g.u.uAmt, it.grid * it.amt);
        gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
      }
      const t = this.tube; gl.useProgram(t.p); gl.bindVertexArray(s.vao);
      gl.uniformMatrix3fv(t.u.uR, false, Rm); gl.uniform2f(t.u.uCenter, cx, cy); gl.uniform2f(t.u.uView, W, H);
      gl.uniform1f(t.u.uScale, sc); gl.uniform1f(t.u.uBuild, build); gl.uniform1f(t.u.uDpr, dpr);
      gl.uniform3fv(t.u.uInk, ink); gl.uniform3fv(t.u.uLight, LIGHT); gl.uniform1f(t.u.uAmt, it.amt);
      gl.uniform1f(t.u.uSolid, it.solid ?? 0); gl.uniform1f(t.u.uColMix, it.colMix ?? 0);
      const nc = it.cuts ? Math.min(8, it.cuts.length) : 0;
      gl.uniform1i(t.u.uNC, nc);
      if (nc) {
        const cu = new Float32Array(8), co = new Float32Array(24);
        for (let i = 0; i < nc; i++) { cu[i] = it.cuts[i]; co.set(it.cols[i], i * 3); }
        gl.uniform1fv(t.u.uCuts, cu); gl.uniform3fv(t.u.uCols, co);
      }
      const pv = new Float32Array(41 * 3), nv = s.n <= 40 ? s.n : 0;
      for (let i = 0; i <= nv && nv; i++) { const p = s.V[i % s.n]; for (let k = 0; k < 3; k++) pv[i * 3 + k] = R[k][0] * p[0] + R[k][1] * p[1] + R[k][2] * p[2]; }
      const halo = rad * (it.halo ?? 1.9);
      gl.uniform3fv(t.u.uPV, pv); gl.uniform1i(t.u.uNV, nv); gl.uniform1f(t.u.uGap, halo);
      if (shadowAmt > 0.002) {
        // every stick's shadow lands at one depth, so only the first one to reach a pixel inks it
        gl.enable(gl.DEPTH_TEST); gl.depthMask(true); gl.depthFunc(gl.LESS);
        gl.uniform1i(t.u.uMode, 2); gl.uniform1f(t.u.uRad, rad);
        gl.uniform4f(t.u.uShadow, lm[0], lm[1], lm[2], zg); gl.uniform1f(t.u.uShadowW, 0.26 * shadowAmt);
        gl.drawElementsInstanced(gl.TRIANGLES, this.stickN, gl.UNSIGNED_SHORT, 0, s.n);
      }
      // a clear margin of paper around every stick, over its own shadow and the lattice
      gl.disable(gl.BLEND); gl.disable(gl.DEPTH_TEST); gl.depthMask(false);
      if (shadowAmt > 0.002 || (it.grid ?? 0) > 0.002) {
        gl.uniform1i(t.u.uMode, 1); gl.uniform1f(t.u.uRad, rad * 1.8);
        gl.drawElementsInstanced(gl.TRIANGLES, this.stickN, gl.UNSIGNED_SHORT, 0, s.n);
      }
      gl.enable(gl.DEPTH_TEST); gl.depthMask(true); gl.depthFunc(gl.LESS);
      gl.uniform1i(t.u.uMode, 0); gl.uniform1f(t.u.uRad, rad); gl.uniform1f(t.u.uRpx, rad * sc); gl.uniform1f(t.u.uRadU, rad);
      const rcss = rad * it.scale;
      gl.uniform1f(t.u.uLines, Math.max(12, Math.min(44, Math.round(rcss * 1.7)))); gl.uniform1f(t.u.uRings, Math.max(6, Math.min(26, Math.round(it.scale / 5.5))));
      gl.drawElementsInstanced(gl.TRIANGLES, this.stickN, gl.UNSIGNED_SHORT, 0, s.n);
      if ((it.bead ?? 1) > 0.002 && build > 0) {
        const bd = this.bead; gl.useProgram(bd.p); gl.bindVertexArray(this.beadVAO);
        gl.uniformMatrix3fv(bd.u.uR, false, Rm); gl.uniform2f(bd.u.uCenter, cx, cy); gl.uniform2f(bd.u.uView, W, H);
        gl.uniform1f(bd.u.uScale, sc); gl.uniform3fv(bd.u.uPos, s.V[0]); gl.uniform3fv(bd.u.uLight, LIGHT);
        gl.uniform3fv(bd.u.uCol, alert); gl.uniform1f(bd.u.uDpr, dpr); gl.uniform1f(bd.u.uAmt, it.amt);
        gl.uniform1i(bd.u.uMode, 0); gl.uniform1f(bd.u.uRad, rad * 1.75 * (it.bead ?? 1));
        gl.drawElements(gl.TRIANGLES, this.beadN, gl.UNSIGNED_SHORT, 0);
      }
    }
    gl.bindVertexArray(null);
  }
}

/* the same poses as a line figure, for browsers without WebGL2 */
class SVGStage {
  constructor(host) {
    this.host = host; this.kind = "svg";
    const s = this.svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    s.setAttribute("class", "stage-svg"); s.setAttribute("aria-hidden", "true");
    host.appendChild(s);
  }
  specimen(V0) { const V = centre(V0); return { V, n: V.length, R: Math.max(...V.map(p => Math.hypot(...p))) }; }
  resize() { this.w = this.host.clientWidth; this.h = this.host.clientHeight; this.svg.setAttribute("viewBox", `0 0 ${this.w} ${this.h}`); }
  draw(items, ink, alert, css) {
    this.resize();
    let out = "";
    for (const it of items) {
      if (!it || it.amt <= 0.002) continue;
      const s = it.spec, R = viewOf(it.az, it.el), rad = (it.radius ?? 0.1) * it.scale;
      const P = s.V.map(p => { const q = project(R, p); return [it.x + q[0] * it.scale, it.y + q[1] * it.scale, q[2]]; });
      const cr = crossings(P), arcs = arcsOf(cr);
      const build = it.build ?? s.n + 1, solid = (it.solid ?? 0) > 0.5;
      // contours first, then the clear middles, so that the sticks join into one tube
      let ink = "", core = "";
      for (const q of pieces(P, cr, rad * 2.2, arcs)) {
        if (q.edge >= build) continue;
        const col = (it.colMix ?? 0) > 0.5 && it.cssCols ? it.cssCols[q.arc % it.cssCols.length] : css.ink;
        const line = `x1="${q.x1.toFixed(1)}" y1="${q.y1.toFixed(1)}" x2="${q.x2.toFixed(1)}" y2="${q.y2.toFixed(1)}" stroke-linecap="round" opacity="${it.amt.toFixed(2)}"`;
        ink += `<line ${line} stroke="${col}" stroke-width="${(rad * 2).toFixed(1)}"/>`;
        if (!solid && rad > 2.2) core += `<line ${line} stroke="${css.paper}" stroke-width="${(rad * 2 - 2.6).toFixed(1)}"/>`;
      }
      out += ink + core;
      if ((it.bead ?? 1) > 0.002 && build > 0) out += `<circle cx="${P[0][0].toFixed(1)}" cy="${P[0][1].toFixed(1)}" r="${(rad * 1.75 * (it.bead ?? 1)).toFixed(1)}" fill="${css.alert}" opacity="${it.amt.toFixed(2)}"/>`;
    }
    this.svg.innerHTML = out;
  }
}

export function createStage(host, { forceSVG = false } = {}) {
  if (!forceSVG) { try { return new GLStage(host); } catch (e) { console.warn("Engraved model unavailable, using the line drawing:", e.message); } }
  return new SVGStage(host);
}

export function hexToRGB(hex) {
  const h = hex.trim().replace("#", "");
  const v = h.length === 3 ? [...h].map(c => c + c).join("") : h;
  return [0, 2, 4].map(i => parseInt(v.slice(i, i + 2), 16) / 255);
}
