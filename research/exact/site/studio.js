// The lattice studio: one 3D look for every figure. Lit tubes, a lattice floor that catches the real
// shadow of the knot (so the shadow IS a diagram), HTML labels pinned to 3D points, click picking,
// tweened cameras and objects. The wheel never zooms: it scrolls the page.
import * as THREE from './vendor/three.module.min.js';
import { OrbitControls } from './vendor/OrbitControls.js';

export { THREE };
const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
export const ease = (t) => (t >= 1 ? 1 : 1 - Math.pow(2, -10 * t));
export const COL = ['#0072b2', '#d55e00', '#009e73', '#cc79a7', '#7a5230', '#56b4e9', '#7f7f7f'];
export const INK = '#14171b';

export function hasGL() {
  if (new URLSearchParams(location.search).has('nogl')) return false;
  try { const c = document.createElement('canvas'); return !!(c.getContext('webgl2') || c.getContext('webgl')); } catch (e) { return false; }
}

export class Studio {
  /**
   * host: element to fill. opts: { aspect, floor (bool), shadowDir [x,y,z] (light travels along -dir),
   * fov, onPick(userData, object, event) }
   */
  constructor(host, opts = {}) {
    this.opts = opts;
    this.host = host;
    host.classList.add('studio'); host.__studio = this;
    this.wrap = document.createElement('div'); this.wrap.className = 'studio-wrap';
    let asp = opts.aspect || '4 / 3';
    const [aw, ah] = asp.split('/').map(Number);
    if (innerWidth < 600 && aw / ah > 1.25) asp = '1 / 1';   // phones: wide stages become square so the scene is not tiny
    this.wrap.style.aspectRatio = asp;
    this.wrap.setAttribute('aria-label', (opts.label || 'Interactive 3D figure').replace(/;\s*(drag|click)[^;]*/gi, '') + '. Drag, or use the arrow keys, to turn it.');
    this.wrap.setAttribute('role', 'group');   // focusable: the arrow keys turn the scene
    this.overlay = document.createElement('div'); this.overlay.className = 'studio-labels';
    this.wrap.append(this.overlay); host.append(this.wrap);
    this.renderer = null; this.ensureRenderer();
    this.THREE_BACK = THREE.BackSide;
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(opts.fov || 24, 1, 0.1, 400);
    this.camera.up.set(0, 0, 1);
    this.controls = new OrbitControls(this.camera, this.wrap);
    Object.assign(this.controls, { enablePan: false, enableZoom: false, enableDamping: !reduced, dampingFactor: 0.1, rotateSpeed: 0.8 });
    this.controls.addEventListener('change', () => this.request());
    this.controls.addEventListener('start', () => { this.camTween = null; this.onUser && this.onUser(); });
    // light: soft sky + a key light that casts the shadow
    this.scene.add(new THREE.HemisphereLight(0xffffff, 0xd4d9de, 2.5));
    this.key = new THREE.DirectionalLight(0xffffff, 1.2);
    this.key.castShadow = opts.floor !== false;
    this.key.shadow.mapSize.set(2048, 2048);
    this.key.shadow.bias = -0.0004;
    this.key.shadow.radius = 2;
    this.scene.add(this.key, this.key.target);
    this.world = new THREE.Group(); this.scene.add(this.world);
    this.labels = [];
    this.tweens = [];
    this.pickables = [];
    // picking: a click (not a drag) on a pickable mesh
    let down = null;
    this.wrap.addEventListener('pointerdown', (e) => { down = [e.clientX, e.clientY]; });
    this.wrap.addEventListener('pointerup', (e) => {
      if (!down || Math.hypot(e.clientX - down[0], e.clientY - down[1]) > 5) return;
      const hit = this.pick(e); if (hit && opts.onPick) opts.onPick(hit.object.userData, hit.object, e);
    });
    this.wrap.addEventListener('pointermove', (e) => {
      if (!opts.onHover && !opts.onPick) return;
      const hit = this.pick(e);
      this.wrap.style.cursor = hit ? 'pointer' : 'grab';
      if (opts.onHover) opts.onHover(hit ? hit.object.userData : null);
    });
    // keyboard: with the scene focused, the arrow keys turn it (left/right about the vertical, up/down tilt)
    this.wrap.tabIndex = 0;
    this.wrap.addEventListener('keydown', (e) => {
      const k = { ArrowLeft: [-1, 0], ArrowRight: [1, 0], ArrowUp: [0, 1], ArrowDown: [0, -1] }[e.key];
      if (!k || !this.center) return;
      e.preventDefault(); e.stopPropagation();
      const off = this.camera.position.clone().sub(this.center);
      const sph = new THREE.Spherical().setFromVector3(new THREE.Vector3(off.x, off.z, -off.y));   // y-up spherical of a z-up scene
      sph.theta += k[0] * 0.17; sph.phi = Math.min(Math.PI - 0.15, Math.max(0.15, sph.phi - k[1] * 0.12));
      const v = new THREE.Vector3().setFromSpherical(sph);
      this.camera.position.copy(this.center).add(new THREE.Vector3(v.x, -v.z, v.y));
      this.camera.up.set(0, 0, 1); this.camera.lookAt(this.center); this.onUser && this.onUser(); this.request();
    });
    this.ro = new ResizeObserver(() => this.resize()); this.ro.observe(this.wrap);
    // a page can hold only about 16 WebGL contexts: a figure far off-screen gives its context back
    // and makes a new one when it comes near again (the scene itself is kept)
    this.io = new IntersectionObserver((es) => {
      this.visible = es[es.length - 1].isIntersecting;   // the newest entry wins when several arrive together
      if (this.visible) { clearTimeout(this.dropT); this.ensureRenderer(); this.resize(); this.request(); }
      else { clearTimeout(this.dropT); this.dropT = setTimeout(() => this.dropRenderer(), 1500); }
    }, { rootMargin: '300px 0px' });
    this.io.observe(this.wrap);
    this.resize();
  }
  ensureRenderer() {
    if (this.renderer) return;
    const c = document.createElement('canvas'); c.className = 'studio-canvas'; c.setAttribute('aria-hidden', 'true');
    this.wrap.insertBefore(c, this.overlay); this.canvas = c;
    const r = new THREE.WebGLRenderer({ canvas: c, antialias: true, alpha: true });
    r.setPixelRatio(Math.min(devicePixelRatio, 2));
    r.shadowMap.enabled = this.opts.floor !== false; r.shadowMap.type = THREE.PCFSoftShadowMap;
    this.renderer = r;
  }
  dropRenderer() {
    const r = this.wrap.getBoundingClientRect();
    if (r.bottom > -300 && r.top < innerHeight + 300) { if (!this.visible) this.dropT = setTimeout(() => this.dropRenderer(), 1500); return; }   // still near: look again later
    if (!this.renderer || this.visible) return;
    if (this.key.shadow.map) { this.key.shadow.map.dispose(); this.key.shadow.map = null; }
    this.renderer.dispose(); this.renderer.forceContextLoss(); this.canvas.remove(); this.renderer = null; this.canvas = null;
  }
  pick(e) {
    if (!this.pickables.length) return null;
    const r = this.wrap.getBoundingClientRect();
    const v = new THREE.Vector2(((e.clientX - r.left) / r.width) * 2 - 1, -((e.clientY - r.top) / r.height) * 2 + 1);
    const rc = new THREE.Raycaster(); rc.setFromCamera(v, this.camera);
    const hits = rc.intersectObjects(this.pickables, false);
    return hits[0] || null;
  }
  /** fit camera and floor to a set of points; dir = viewing direction (from target to camera) */
  frame(points, dir = [1.1, -1.5, 1.05], margin = 1.12) {
    const V = points.map((p) => new THREE.Vector3(...p));
    const box = new THREE.Box3().setFromPoints(V);
    this.box = box;
    this.center = box.getCenter(new THREE.Vector3());
    this.radius = box.getSize(new THREE.Vector3()).length() / 2 + 0.4;
    const step = Math.max(1, Math.floor(V.length / 400));
    this.fitPts = V.filter((_, i) => i % step === 0);
    this.margin = margin;
    this.controls.target.copy(this.center);
    this.setDir(dir, 0);
    if (this.opts.floor !== false) this.addFloor();
    this.aimLight(this.opts.shadowDir || [0.25, -0.35, 1]);
  }
  /** the camera distance at which every fitted point is in view, looking from direction dir */
  distance(dir) {
    const d = dir ? dir.clone().normalize() : this.camera.position.clone().sub(this.center).normalize();
    if (!this.fitPts || !isFinite(d.x)) return this.radius * 5;
    const upRef = Math.abs(d.z) > 0.95 ? new THREE.Vector3(0, 1, 0) : new THREE.Vector3(0, 0, 1);
    const r = new THREE.Vector3().crossVectors(upRef, d).normalize(), u = new THREE.Vector3().crossVectors(d, r);
    const tv = Math.tan(THREE.MathUtils.degToRad(this.camera.fov) / 2), th = tv * this.camera.aspect;
    let D = 0; const q = new THREE.Vector3();
    for (const p of this.fitPts) {
      q.copy(p).sub(this.center);
      const x = Math.abs(q.dot(r)) * this.margin + 0.3, y = Math.abs(q.dot(u)) * this.margin + 0.3, z = q.dot(d);
      D = Math.max(D, z + x / th, z + y / tv);
    }
    return D;
  }
  setDir(dir, ms = 900, up = null, done) {
    const to = new THREE.Vector3(...dir).normalize();
    const from = this.camera.position.clone().sub(this.center).normalize();
    const upTo = up ? new THREE.Vector3(...up) : new THREE.Vector3(0, 0, 1);
    const upFrom = this.camera.up.clone();
    if (!ms || reduced || !isFinite(from.x)) {
      this.camera.up.copy(upTo); this.camera.position.copy(this.center).addScaledVector(to, this.distance(to)); this.camera.lookAt(this.center);
      this.request(); done && done(); return;
    }
    this.camTween = { from, to, upFrom, upTo, t0: performance.now(), ms, done };
    this.request();
  }
  /** narrow the field of view (nearly orthographic) or widen it back, keeping the scene fitted */
  flatten(on, ms = 900) {
    const f0 = this.camera.fov, f1 = on ? 5 : (this.opts.fov || 24);
    this.tween(ms, (k) => {
      this.camera.fov = f0 + (f1 - f0) * k; this.camera.updateProjectionMatrix();
      const d = this.camera.position.clone().sub(this.center);
      this.camera.position.copy(this.center).add(d.setLength(this.distance(d))); this.camera.far = Math.max(400, this.distance(d) * 3); this.camera.updateProjectionMatrix();
    });
  }
  aimLight(dir) {
    const d = new THREE.Vector3(...dir).normalize();
    this.key.position.copy(this.center).addScaledVector(d, this.radius * 4);
    this.key.target.position.copy(this.center);
    const s = this.radius * 2.2, cam = this.key.shadow.camera;
    Object.assign(cam, { left: -s, right: s, top: s, bottom: -s, near: 0.1, far: this.radius * 10 });
    cam.updateProjectionMatrix();
    this.request();
  }
  addFloor() {
    if (this.floor) this.scene.remove(this.floor);
    const g = new THREE.Group(); this.floor = g;
    const z0 = this.box.min.z - 0.7;
    const span = Math.ceil(this.radius * 2.6);
    const cx = Math.round(this.center.x), cy = Math.round(this.center.y);
    const plane = new THREE.Mesh(new THREE.PlaneGeometry(span * 2, span * 2), new THREE.ShadowMaterial({ opacity: 0.2 }));
    plane.position.set(cx, cy, z0); plane.receiveShadow = true; g.add(plane);
    const pts = [];
    for (let i = -span; i <= span; i++) { pts.push(cx - span, cy + i, z0, cx + span, cy + i, z0, cx + i, cy - span, z0, cx + i, cy + span, z0); }
    const lg = new THREE.BufferGeometry(); lg.setAttribute('position', new THREE.Float32BufferAttribute(pts, 3));
    const lines = new THREE.LineSegments(lg, new THREE.LineBasicMaterial({ color: 0x9aa3ad, transparent: true, opacity: 0.32 }));
    g.add(lines);
    this.floorZ = z0;
    this.scene.add(g);
  }
  resize() {
    const w = this.wrap.clientWidth, h = this.wrap.clientHeight; if (!w || !h) return;
    if (this.renderer) this.renderer.setSize(w, h, false);
    this.camera.aspect = w / h; this.camera.updateProjectionMatrix();
    if (this.center) { const off = this.camera.position.clone().sub(this.center); if (off.lengthSq() > 1e-9) { const D = this.distance(off); this.camera.position.copy(this.center).add(off.setLength(D)); } }
    this.request();
  }
  request() { if (!this.pending) { this.pending = true; requestAnimationFrame(() => this.frameLoop()); } }
  /** animate fn(k) for k in [0,1] over ms milliseconds (eased) */
  tween(ms, fn, done) {
    if (reduced || !ms) { fn(1); this.request(); done && done(); return; }
    this.tweens.push({ t0: performance.now(), ms, fn, done }); this.request();
  }
  frameLoop() {
    this.pending = false;
    const now = performance.now();
    let more = false;
    if (this.camTween) {
      const T = this.camTween, t = Math.min(1, (now - T.t0) / T.ms), k = ease(t);
      const d = T.from.clone().lerp(T.to, k).normalize();
      this.camera.up.copy(T.upFrom).lerp(T.upTo, k).normalize();
      this.camera.position.copy(this.center).addScaledVector(d, this.distance(d));
      this.camera.lookAt(this.center);
      if (t >= 1) { this.camTween = null; T.done && T.done(); } else more = true;
    }
    if (this.tweens.length) {
      this.tweens = this.tweens.filter((T) => {
        const t = Math.min(1, (now - T.t0) / T.ms); T.fn(ease(t));
        if (t >= 1) { T.done && T.done(); return false; } return true;
      });
      if (this.tweens.length) more = true;
    }
    if (this.controls.update()) more = true;
    if (!this.renderer && this.visible) { this.ensureRenderer(); this.resize(); }
    this.camera.updateMatrixWorld();
    for (const o of this.world.children) o.traverse && o.traverse((c) => { if (c.userData && c.userData.billboard) c.lookAt(this.camera.position); });   // rings face the viewer in this frame
    if (this.renderer) this.renderer.render(this.scene, this.camera);
    this.placeLabels();
    if (more || (this.always && this.visible !== false)) this.request();   // a looping scene sleeps off-screen
  }
  // ---------------------------------------------------------------- building blocks
  material(color, opts = {}) {
    return new THREE.MeshStandardMaterial({ color, roughness: 0.82, metalness: 0, transparent: true, ...opts });   // matte, like printed ink
  }
  /** a lattice-style tube: one cylinder per segment and a ball at every joint; returns a Group */
  rod(points, { color = INK, radius = 0.09, closed = false, userData = {}, pick = false, parent } = {}) {
    const g = new THREE.Group(); g.userData = userData;
    const mat = this.material(color);
    const cyl = new THREE.CylinderGeometry(radius, radius, 1, 20, 1, true), sph = new THREE.SphereGeometry(radius, 20, 14);
    const up = new THREE.Vector3(0, 1, 0);
    const P = points.map((p) => new THREE.Vector3(...p)), n = P.length, m = closed ? n : n - 1;
    for (let i = 0; i < m; i++) {
      const A = P[i], B = P[(i + 1) % n], L = A.distanceTo(B); if (L < 1e-6) continue;
      const c = new THREE.Mesh(cyl, mat); c.scale.set(1, L, 1); c.position.copy(A).add(B).multiplyScalar(0.5);
      c.quaternion.setFromUnitVectors(up, B.clone().sub(A).normalize()); c.castShadow = true; c.userData = userData; g.add(c);
      if (pick) this.pickables.push(c);
    }
    for (const p of P) { const s = new THREE.Mesh(sph, mat); s.position.copy(p); s.castShadow = true; s.userData = userData; g.add(s); if (pick) this.pickables.push(s); }
    (parent || this.world).add(g); this.request(); return g;
  }
  /** a smooth closed tube through points */
  tube(points, { color = INK, radius = 0.09, closed = true, userData = {}, pick = false, segments, parent } = {}) {
    const curve = new THREE.CatmullRomCurve3(points.map((p) => new THREE.Vector3(...p)), closed, 'centripetal');
    const geo = new THREE.TubeGeometry(curve, segments || points.length * 3, radius, 14, closed);
    const mesh = new THREE.Mesh(geo, this.material(color)); mesh.castShadow = true; mesh.userData = userData;
    (parent || this.world).add(mesh); if (pick) this.pickables.push(mesh); this.request(); return mesh;
  }
  ball(p, { color = INK, radius = 0.12, hollow = false, userData = {}, pick = false, parent } = {}) {
    let mesh;
    if (hollow) {
      mesh = new THREE.Mesh(new THREE.SphereGeometry(radius, 22, 16), this.material(color, { opacity: 0.18, depthWrite: false }));
      const ring = new THREE.Mesh(new THREE.TorusGeometry(radius, radius * 0.16, 10, 40), new THREE.MeshBasicMaterial({ color }));
      ring.userData.billboard = true; mesh.add(ring);
    } else { mesh = new THREE.Mesh(new THREE.SphereGeometry(radius, 22, 16), this.material(color)); mesh.castShadow = true; }
    mesh.position.set(...p); mesh.userData = userData;
    (parent || this.world).add(mesh); if (pick) this.pickables.push(mesh); this.request(); return mesh;
  }
  sheet(corners, { color = '#0072b2', opacity = 0.18, parent } = {}) {   // a flat polygon (a square, a triangle, a curtain)
    const g = new THREE.BufferGeometry();
    const P = corners.map((p) => new THREE.Vector3(...p)); const pos = [];
    for (let i = 1; i + 1 < P.length; i++) pos.push(...P[0].toArray(), ...P[i].toArray(), ...P[i + 1].toArray());
    g.setAttribute('position', new THREE.Float32BufferAttribute(pos, 3)); g.computeVertexNormals();
    const m = new THREE.Mesh(g, new THREE.MeshBasicMaterial({ color, transparent: true, opacity, side: THREE.DoubleSide, depthWrite: false }));
    (parent || this.world).add(m); this.request(); return m;
  }
  line(points, { color = INK, dashed = false, opacity = 1, parent } = {}) {
    const g = new THREE.BufferGeometry().setFromPoints(points.map((p) => new THREE.Vector3(...p)));
    const mat = dashed ? new THREE.LineDashedMaterial({ color, dashSize: 0.12, gapSize: 0.09, transparent: true, opacity })
      : new THREE.LineBasicMaterial({ color, transparent: true, opacity });
    const l = new THREE.Line(g, mat); if (dashed) l.computeLineDistances();
    (parent || this.world).add(l); this.request(); return l;
  }
  /** an HTML label pinned to a 3D point */
  label(p, html, cls = '') {
    const el = document.createElement('div'); el.className = 'studio-label ' + cls; el.innerHTML = html;
    this.overlay.append(el);
    const L = { el, pos: new THREE.Vector3(...p) }; this.labels.push(L); new MutationObserver(() => { L.size = null; }).observe(el, { childList: true, characterData: true, subtree: true }); this.request(); return L;
  }
  clearLabels() { this.overlay.innerHTML = ''; this.labels = []; }
  placeLabels() {
    const w = this.wrap.clientWidth, h = this.wrap.clientHeight, boxes = [];
    // strong labels (and badges) first; a label that would cover one already placed fades out in this view
    const order = [...this.labels].sort((p, q) => (/strong|badge|xing|chip3/.test(q.el.className) ? 1 : 0) - (/strong|badge|xing|chip3/.test(p.el.className) ? 1 : 0));
    for (const L of order) {
      const v = L.pos.clone().project(this.camera), x = ((v.x + 1) / 2) * w, y = ((1 - v.y) / 2) * h;
      L.el.style.transform = `translate(${x}px, ${y}px) translate(-50%, -50%)`;
      if (v.z >= 1 || !L.el.textContent.trim()) { L.el.style.visibility = 'hidden'; continue; }
      L.el.style.visibility = 'visible';
      if (!L.size) L.size = [L.el.offsetWidth, L.el.offsetHeight];
      const r = [x - L.size[0] / 2, y - L.size[1] / 2, x + L.size[0] / 2, y + L.size[1] / 2];
      const hit = boxes.some((q) => Math.min(r[2], q[2]) - Math.max(r[0], q[0]) > 2 && Math.min(r[3], q[3]) - Math.max(r[1], q[1]) > 2);
      L.el.style.opacity = hit ? '0' : '';
      if (!hit) boxes.push(r);
    }
  }
  clear(group = this.world) {
    while (group.children.length) { const c = group.children.pop(); c.traverse && c.traverse((x) => { x.geometry && x.geometry.dispose(); }); }
    this.pickables = this.pickables.filter((p) => { let o = p; while (o) { if (o === group) return false; o = o.parent; } return true; });
    this.request();
  }
}

// ------------------------------------------------------------------ knot curves with crossings
/** For a closed 3D curve, split it at its under-passages (in the projection along z). Returns
 * { arcOf(i), crossings: [{iu, io, p3, over, inArc, outArc}] } with sample indices. */
export function crossingsOf(P) {
  const N = P.length, out = [];
  for (let i = 0; i < N; i++) {
    const a = P[i], b = P[(i + 1) % N];
    for (let j = i + 2; j < N; j++) {
      if (i === 0 && j === N - 1) continue;
      const c = P[j], d = P[(j + 1) % N];
      const r = [b[0] - a[0], b[1] - a[1]], s = [d[0] - c[0], d[1] - c[1]];
      const den = r[0] * s[1] - r[1] * s[0]; if (Math.abs(den) < 1e-12) continue;
      const q = [c[0] - a[0], c[1] - a[1]];
      const t = (q[0] * s[1] - q[1] * s[0]) / den, u = (q[0] * r[1] - q[1] * r[0]) / den;
      if (t < 0 || t >= 1 || u < 0 || u >= 1) continue;
      const za = a[2] + t * (b[2] - a[2]), zc = c[2] + u * (d[2] - c[2]);
      const ti = i + t, tj = j + u;
      out.push(za < zc ? { su: ti, so: tj } : { su: tj, so: ti });
    }
  }
  const unders = out.map((c) => c.su).sort((x, y) => x - y);
  const arcOf = (s) => { let k = 0; for (const u of unders) if (u < s) k++; return (k - 1 + unders.length) % unders.length; };
  for (const c of out) { c.e = unders.indexOf(c.su); c.over = arcOf(c.so); c.inArc = (c.e - 1 + unders.length) % unders.length; c.outArc = c.e; }
  return { crossings: out, unders, arcOf };
}
export function pointAt(P, s) {
  const N = P.length, i = Math.floor(s) % N, f = s - Math.floor(s), a = P[i], b = P[(i + 1) % N];
  return [a[0] + f * (b[0] - a[0]), a[1] + f * (b[1] - a[1]), a[2] + f * (b[2] - a[2])];
}
/** the samples of each arc, as open polylines (arc e from under-passage e to e+1), trimmed by gap samples */
export function arcPolylines(P, unders, gap = 0) {
  const N = P.length, out = [];
  for (let e = 0; e < unders.length; e++) {
    let a = unders[e] + gap, b = unders[(e + 1) % unders.length] - gap; if (b <= a) b += N;
    const pts = [pointAt(P, a)];
    for (let k = Math.ceil(a); k < b; k++) pts.push(P[k % N]);
    pts.push(pointAt(P, b % N === 0 && b > 0 ? b - 1e-6 : b));
    out.push(pts);
  }
  return out;
}
