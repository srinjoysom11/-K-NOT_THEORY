// The Cabinet's hero: a brass-wire model of the 36-step polygon in a vitrine. A light shines exactly
// along the projection direction, so the model's shadow on the plinth IS the knot diagram.
import * as THREE from "three";
import { RoomEnvironment } from "three/addons/RoomEnvironment.js";
import { crossings, centre } from "./knot.js";

const toThree = p => new THREE.Vector3(p[0], p[2], -p[1]);       // lattice z up -> three y up

export async function cabinet(host, V0, D, onCount) {
  const V = centre(V0);
  const W = () => Math.max(host.clientWidth, 10), H = () => Math.max(host.clientHeight, 10);
  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true, powerPreference: "high-performance" });
  renderer.setPixelRatio(Math.min(devicePixelRatio || 1, 2));
  renderer.setSize(W(), H());
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
  renderer.toneMappingExposure = 1.05;
  renderer.outputColorSpace = THREE.SRGBColorSpace;
  host.appendChild(renderer.domElement);
  renderer.domElement.style.touchAction = "none";
  renderer.domElement.style.cursor = "grab";
  renderer.domElement.setAttribute("aria-hidden", "true");

  const scene = new THREE.Scene();
  const pmrem = new THREE.PMREMGenerator(renderer);
  scene.environment = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;

  // the light direction, in three coordinates
  const d3 = toThree(D).normalize();

  // ---- the model
  const model = new THREE.Group();
  const brass = new THREE.MeshStandardMaterial({ color: 0xc9a45c, metalness: 1.0, roughness: 0.3, envMapIntensity: 0.9 });
  const path = new THREE.CurvePath();
  const pts = V.map(toThree);
  for (let i = 0; i < pts.length; i++) path.add(new THREE.LineCurve3(pts[i], pts[(i + 1) % pts.length]));
  const tube = new THREE.Mesh(new THREE.TubeGeometry(path, pts.length * 10, 0.07, 14, true), brass);
  tube.castShadow = true;
  model.add(tube);
  const joint = new THREE.SphereGeometry(0.085, 20, 14);
  pts.forEach((p, i) => {
    const m = new THREE.Mesh(i === 0 ? new THREE.SphereGeometry(0.14, 24, 16) : joint,
      i === 0 ? new THREE.MeshStandardMaterial({ color: 0xb3341f, metalness: 0.25, roughness: 0.35 }) : brass);
    m.position.copy(p); m.castShadow = true; model.add(m);
  });
  scene.add(model);

  // ---- the plinth: perpendicular to the light, behind the model
  const R = Math.max(...pts.map(p => p.length()));
  const plinth = new THREE.Mesh(new THREE.CircleGeometry(R * 1.55, 96),
    new THREE.MeshStandardMaterial({ color: 0xe9dfc6, roughness: 0.95, metalness: 0, envMapIntensity: 0.06 }));
  plinth.receiveShadow = true;
  plinth.position.copy(d3.clone().multiplyScalar(-(R + 1.4)));
  plinth.lookAt(plinth.position.clone().add(d3));
  scene.add(plinth);
  // a thin brass rim around the plinth
  const rim = new THREE.Mesh(new THREE.TorusGeometry(R * 1.55, 0.045, 10, 160), brass);
  rim.position.copy(plinth.position); rim.lookAt(rim.position.clone().add(d3));
  scene.add(rim);

  // ---- light along D: parallel projection, so the shadow is the diagram
  const sun = new THREE.DirectionalLight(0xfff1d6, 2.6);
  sun.position.copy(d3.clone().multiplyScalar(30));
  sun.target.position.set(0, 0, 0);
  sun.castShadow = true;
  sun.shadow.mapSize.set(2048, 2048);
  const sc = sun.shadow.camera;
  sc.left = sc.bottom = -R * 1.6; sc.right = sc.top = R * 1.6; sc.near = 1; sc.far = 60;
  sun.shadow.bias = -0.0004; sun.shadow.radius = 1.5;
  scene.add(sun, sun.target);
  scene.add(new THREE.HemisphereLight(0xfff4e0, 0x0b110f, 0.12));

  // ---- camera: in front of the vitrine, a little above
  const camera = new THREE.PerspectiveCamera(30, W() / H(), 0.1, 200);
  const camDir = new THREE.Vector3(-0.42, 0.62, 0.66).normalize();
  const place = () => {
    camera.aspect = W() / H(); camera.updateProjectionMatrix();
    const dist = R * (camera.aspect < 0.9 ? 8.6 : 6.3);
    camera.position.copy(camDir.clone().multiplyScalar(dist));
    camera.lookAt(d3.clone().multiplyScalar(-1.2));
  };
  place();

  // ---- interaction: turn the model about the vertical axis; the light stays fixed
  let yaw = 0, pitch = 0, target = null, idle = !matchMedia("(prefers-reduced-motion: reduce)").matches, drag = false, px = 0, py = 0;
  const cvs = renderer.domElement;
  cvs.addEventListener("pointerdown", e => { drag = true; idle = false; target = null; px = e.clientX; py = e.clientY; cvs.setPointerCapture(e.pointerId); cvs.style.cursor = "grabbing"; });
  cvs.addEventListener("pointermove", e => { if (!drag) return; yaw += (e.clientX - px) * 0.008; pitch = Math.max(-0.6, Math.min(0.6, pitch + (e.clientY - py) * 0.006)); px = e.clientX; py = e.clientY; });
  const up = () => { drag = false; cvs.style.cursor = "grab"; };
  cvs.addEventListener("pointerup", up); cvs.addEventListener("pointercancel", up);

  // the shadow's crossings: project the turned polygon along D, exactly as the light does
  const shadowCount = () => {
    const q = new THREE.Quaternion().setFromEuler(new THREE.Euler(pitch, yaw, 0, "YXZ"));
    const n = d3, upv = Math.abs(n.y) > 0.99 ? new THREE.Vector3(0, 0, 1) : new THREE.Vector3(0, 1, 0);
    const r = new THREE.Vector3().crossVectors(upv, n).normalize(), u = new THREE.Vector3().crossVectors(n, r);
    const P = pts.map(p => { const v = p.clone().applyQuaternion(q); return [v.dot(r), -v.dot(u), v.dot(n)]; });
    return crossings(P).length;
  };

  let raf = 0, running = false, frame = 0;
  const tick = () => {
    if (!running) return;
    if (target !== null) {
      yaw += (target - yaw) * 0.07; pitch += (0 - pitch) * 0.07;
      if (Math.abs(target - yaw) < 1e-3) { yaw = target; pitch = 0; target = null; }
    } else if (idle) yaw += 0.0022;
    model.rotation.set(pitch, yaw, 0, "YXZ");
    renderer.render(scene, camera);
    if (frame++ % 6 === 0) onCount(shadowCount());
    raf = requestAnimationFrame(tick);
  };
  const ro = new ResizeObserver(() => { renderer.setSize(W(), H()); place(); if (!running) renderer.render(scene, camera); });
  ro.observe(host);

  return {
    start() { if (running) return; running = true; raf = requestAnimationFrame(tick); },
    stop() { running = false; cancelAnimationFrame(raf); },
    align() { idle = false; target = Math.round(yaw / (2 * Math.PI)) * 2 * Math.PI; },
    dispose() { running = false; cancelAnimationFrame(raf); ro.disconnect(); renderer.dispose(); pmrem.dispose(); host.innerHTML = ""; },
  };
}
