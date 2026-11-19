// Interactive 3D lattice polygons (three.js).  One LatticeView per canvas; renders on demand.
import * as THREE from './vendor/three.module.min.js';
import { OrbitControls } from './vendor/OrbitControls.js';

const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
const easeOut = (t) => (t >= 1 ? 1 : 1 - Math.pow(2, -10 * t));

export class LatticeView {
  /** verts: lattice points; pieces: [edge, t0, t1, arc]; colourOf(arc) -> css colour */
  constructor(canvas, { verts, pieces, colourOf, radius = 0.075, grid = true }) {
    this.canvas = canvas;
    this.verts = verts.map((v) => new THREE.Vector3(...v));
    const n = this.verts.length;
    this.renderer = new THREE.WebGLRenderer({ canvas, antialias: true, alpha: true });
    this.renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
    this.scene = new THREE.Scene();
    // bounds
    const box = new THREE.Box3().setFromPoints(this.verts);
    this.center = box.getCenter(new THREE.Vector3());
    this.size = box.getSize(new THREE.Vector3()).length() * 0.62 + 0.6;
    this.camera = new THREE.OrthographicCamera(-1, 1, 1, -1, -100, 100);
    this.camera.up.set(0, 0, 1);
    this.setDir(new THREE.Vector3(1.0, -1.35, 0.95));
    this.controls = new OrbitControls(this.camera, canvas);
    this.controls.target.copy(this.center);
    this.controls.enablePan = false;
    this.controls.enableDamping = !reduced;
    this.controls.dampingFactor = 0.12;
    this.controls.minZoom = 0.6; this.controls.maxZoom = 3;
    this.controls.addEventListener('change', () => this.request());
    this.controls.addEventListener('start', () => { this.tween = null; this.camera.up.set(0, 0, 1); this.onUser && this.onUser(); });
    // light
    this.scene.add(new THREE.HemisphereLight(0xffffff, 0x9aa3ad, 2.2));
    const dl = new THREE.DirectionalLight(0xffffff, 1.6); dl.position.set(3, -2, 6); this.scene.add(dl);
    // tubes
    this.group = new THREE.Group(); this.scene.add(this.group);
    this.pieceMeshes = [];
    const cyl = new THREE.CylinderGeometry(radius, radius, 1, 18, 1, true);
    const sph = new THREE.SphereGeometry(radius, 18, 12);
    const up = new THREE.Vector3(0, 1, 0);
    for (const [i, a, b, arc] of pieces) {
      const p = this.verts[i], q = this.verts[(i + 1) % n];
      const A = p.clone().lerp(q, a), B = p.clone().lerp(q, b);
      const len = A.distanceTo(B); if (len < 1e-6) continue;
      const mat = new THREE.MeshStandardMaterial({ color: colourOf(arc), roughness: 0.55, metalness: 0.0, transparent: true });
      const m = new THREE.Mesh(cyl, mat);
      m.scale.set(1, len, 1);
      m.position.copy(A).add(B).multiplyScalar(0.5);
      m.quaternion.setFromUnitVectors(up, B.clone().sub(A).normalize());
      m.userData = { edge: i, arc };
      this.group.add(m); this.pieceMeshes.push(m);
      // round joints at both ends
      for (const P of [A, B]) {
        const j = new THREE.Mesh(sph, mat); j.position.copy(P); j.userData = { edge: i, arc }; this.group.add(j); this.pieceMeshes.push(j);
      }
    }
    // vertices and the origin
    const dot = new THREE.SphereGeometry(radius * 0.55, 10, 8);
    const dmat = new THREE.MeshBasicMaterial({ color: 0x14171b });
    this.dots = [];
    this.verts.forEach((v, k) => { const d = new THREE.Mesh(dot, dmat); d.position.copy(v); d.userData = { vertex: k }; this.group.add(d); this.dots.push(d); });
    const o = new THREE.Mesh(new THREE.SphereGeometry(radius * 1.8, 20, 14), new THREE.MeshStandardMaterial({ color: 0x14171b, roughness: 0.4 }));
    o.position.copy(this.verts[0]); this.group.add(o); this.origin = o;
    // lattice points of the bounding box, faint
    if (grid) {
      const pts = [];
      for (let x = Math.floor(box.min.x); x <= box.max.x; x++)
        for (let y = Math.floor(box.min.y); y <= box.max.y; y++)
          for (let z = Math.floor(box.min.z); z <= box.max.z; z++) pts.push(x, y, z);
      const g = new THREE.BufferGeometry(); g.setAttribute('position', new THREE.Float32BufferAttribute(pts, 3));
      this.grid = new THREE.Points(g, new THREE.PointsMaterial({ color: 0x8a929c, size: 2.2, sizeAttenuation: false }));
      this.scene.add(this.grid);
    }
    this.markers = new THREE.Group(); this.scene.add(this.markers);
    this.resize();
    this.ro = new ResizeObserver(() => this.resize()); this.ro.observe(canvas);
    this.request();
  }
  setDir(d) {
    const dir = d.clone().normalize();
    this.camera.position.copy(this.center).addScaledVector(dir, 20);
    this.camera.lookAt(this.center);
  }
  resize() {
    const w = this.canvas.clientWidth, h = this.canvas.clientHeight; if (!w || !h) return;
    this.renderer.setSize(w, h, false);
    const s = this.size, r = w / h;
    Object.assign(this.camera, r >= 1 ? { left: -s * r, right: s * r, top: s, bottom: -s } : { left: -s, right: s, top: s / r, bottom: -s / r });
    this.camera.updateProjectionMatrix(); this.request();
  }
  request() { if (!this.pending) { this.pending = true; requestAnimationFrame(() => this.frame()); } }
  frame() {
    this.pending = false;
    if (this.tween) {
      const t = Math.min(1, (performance.now() - this.tween.t0) / this.tween.ms);
      const k = easeOut(t);
      const d = this.tween.from.clone().lerp(this.tween.to, k).normalize();
      this.camera.position.copy(this.center).addScaledVector(d, 20);
      this.camera.zoom = this.tween.z0 + (this.tween.z1 - this.tween.z0) * k; this.camera.updateProjectionMatrix();
      this.camera.up.copy(this.upFrom).lerp(this.upTo, k).normalize();
      this.camera.lookAt(this.center);
      if (t >= 1) { const cb = this.tween.done; this.tween = null; cb && cb(); } else this.request();
    }
    if (this.controls.update()) this.request();
    this.faceMarkers();
    this.renderer.render(this.scene, this.camera);
  }
  /** turn the camera to look along -D (viewer far out along +D), z up */
  viewAlong(D, ms = 1100, done) {
    const to = new THREE.Vector3(...D).normalize();
    const ref = Math.abs(to.z) < 0.8 ? new THREE.Vector3(0, 0, 1) : new THREE.Vector3(0, 1, 0);
    this.upTo = ref.clone().addScaledVector(to, -ref.dot(to)).normalize();
    this.upFrom = this.camera.up.clone();
    const from = this.camera.position.clone().sub(this.center).normalize();
    if (reduced) ms = 1;
    this.tween = { from, to, t0: performance.now(), ms, z0: this.camera.zoom, z1: 1, done };
    this.request();
  }
  highlight(arc) {
    for (const m of this.pieceMeshes) m.material.opacity = arc == null || m.userData.arc === arc ? 1 : 0.18;
    this.request();
  }
  showUpTo(k) { // edges 0..k-1 visible
    for (const m of this.pieceMeshes) m.visible = m.userData.edge < k;
    for (const d of this.dots) d.visible = d.userData.vertex <= k;
    this.request();
  }
  setMarkers(list) { // {p:[x,y,z], kind:'site'|'done'|'head', colour}
    this.markers.clear();
    for (const mk of list) {
      let mesh;
      if (mk.kind === 'site') mesh = new THREE.Mesh(new THREE.TorusGeometry(0.17, 0.035, 8, 28), new THREE.MeshBasicMaterial({ color: mk.colour }));
      else if (mk.kind === 'head') mesh = new THREE.Mesh(new THREE.SphereGeometry(0.16, 18, 12), new THREE.MeshStandardMaterial({ color: mk.colour, roughness: 0.4 }));
      else mesh = new THREE.Mesh(new THREE.SphereGeometry(0.15, 16, 10), new THREE.MeshBasicMaterial({ color: mk.colour }));
      mesh.position.set(...mk.p);
      if (mk.kind === 'site') mesh.lookAt(this.camera.position);
      this.markers.add(mesh);
    }
    this.request();
  }
  faceMarkers() { for (const m of this.markers.children) m.lookAt(this.camera.position); }
}

export function hasGL() {
  if (new URLSearchParams(location.search).has('nogl')) return false;
  try { const c = document.createElement('canvas'); return !!(c.getContext('webgl2') || c.getContext('webgl')); } catch (e) { return false; }
}
