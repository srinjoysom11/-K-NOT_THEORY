// Geometry of lattice polygons: words, vertices, projections, crossings, arcs and Fox colourings.
// A port of research/exact/formal/projections.py (the same rules as Len52/Diagram.lean).

export const UNIT = { e: [1, 0, 0], w: [-1, 0, 0], n: [0, 1, 0], s: [0, -1, 0], u: [0, 0, 1], d: [0, 0, -1] };

export function verticesOf(word) {
  const v = [[0, 0, 0]];
  for (const c of word) {
    const a = UNIT[c], p = v[v.length - 1];
    v.push([p[0] + a[0], p[1] + a[1], p[2] + a[2]]);
  }
  v.pop();                       // the walk returns to the origin
  return v;
}

export function centre(V) {
  const c = [0, 1, 2].map(k => (Math.min(...V.map(p => p[k])) + Math.max(...V.map(p => p[k]))) / 2);
  return V.map(p => [p[0] - c[0], p[1] - c[1], p[2] - c[2]]);
}

/* ---------- a rotating view: screen x, y and depth (towards the viewer) ---------- */
export function rotator(yaw, pitch, roll = 0) {
  const cy = Math.cos(yaw), sy = Math.sin(yaw), cp = Math.cos(pitch), sp = Math.sin(pitch);
  const cr = Math.cos(roll), sr = Math.sin(roll);
  return p => {
    // z up in lattice coordinates; turn about z (yaw), then tilt about screen x (pitch)
    let x = cy * p[0] - sy * p[1], y = sy * p[0] + cy * p[1], z = p[2];
    let y2 = cp * y - sp * z, z2 = sp * y + cp * z;      // y2: depth, z2: screen up
    const X = cr * x - sr * z2, Y = sr * x + cr * z2;
    return [X, -Y, -y2];                                  // screen x right, screen y down, depth towards viewer
  };
}

/* projection along an integer direction D, as in the Lean definitions */
export function projAlong(D) {
  const [dx, dy, dz] = D;
  return p => [dz * p[0] - dx * p[2], -(dz * p[1] - dy * p[2]), dx * p[0] + dy * p[1] + dz * p[2]];
}

/* ---------- crossings of a projected closed polygon ---------- */
// P: projected points [x, y, depth]; returns crossings {i, t, j, u} with edge i UNDER at parameter t, j OVER at u
export function crossings(P) {
  const n = P.length, out = [];
  for (let i = 0; i < n; i++) {
    const a = P[i], b = P[(i + 1) % n];
    for (let j = i + 2; j < n; j++) {
      if (i === 0 && j === n - 1) continue;
      const c = P[j], d = P[(j + 1) % n];
      const rx = b[0] - a[0], ry = b[1] - a[1], sx = d[0] - c[0], sy = d[1] - c[1];
      const den = rx * sy - ry * sx;
      if (Math.abs(den) < 1e-12) continue;
      const qx = c[0] - a[0], qy = c[1] - a[1];
      const t = (qx * sy - qy * sx) / den, u = (qx * ry - qy * rx) / den;
      if (t <= 1e-9 || t >= 1 - 1e-9 || u <= 1e-9 || u >= 1 - 1e-9) continue;
      const hi = a[2] + t * (b[2] - a[2]), hj = c[2] + u * (d[2] - c[2]);
      if (hi < hj) out.push({ i, t, j, u }); else out.push({ i: j, t: u, j: i, u: t });
    }
  }
  return out;
}

/* ---------- arcs and the Fox system ---------- */
export function arcsOf(cr) {
  const ev = cr.map(c => [c.i, c.t]).sort((p, q) => p[0] - q[0] || p[1] - q[1]);
  const c = ev.length;
  const before = (e, t) => ev.filter(q => q[0] < e || (q[0] === e && q[1] < t)).length;
  const arcAt = (e, t) => c ? ((before(e, t) - 1) % c + c) % c : 0;
  const rows = cr.map(x => {
    const k = ev.findIndex(q => q[0] === x.i && Math.abs(q[1] - x.t) < 1e-12);
    return { over: arcAt(x.j, x.u), inA: ((k - 1) % c + c) % c, outA: k };
  });
  return { count: Math.max(c, 1), arcAt, rows, events: ev };
}

export function foxOK(row, x, p) {
  return ((2 * x[row.over] - x[row.inA] - x[row.outA]) % p + p) % p === 0;
}

export function countColourings(arcs, p) {
  const c = arcs.count, x = new Array(c).fill(0);
  let total = 0, nonconst = null;
  const rec = k => {
    if (k === c) {
      if (arcs.rows.every(r => foxOK(r, x, p))) {
        total++;
        if (!nonconst && x.some(v => v !== x[0])) nonconst = x.slice();
      }
      return;
    }
    for (let v = 0; v < p; v++) { x[k] = v; rec(k + 1); }
  };
  rec(0);
  return { total, nonconst };
}

/* ---------- drawing: pieces of each edge between under-passage gaps ---------- */
// returns [{x1,y1,x2,y2,edge,arc,depth}] in screen units, with gaps of half-width `gap` (screen units)
export function pieces(P, cr, gap, arcs) {
  const n = P.length, cuts = Array.from({ length: n }, () => []);
  for (const c of cr) cuts[c.i].push(c.t);
  const out = [];
  for (let i = 0; i < n; i++) {
    const a = P[i], b = P[(i + 1) % n];
    const L = Math.hypot(b[0] - a[0], b[1] - a[1]) || 1;
    const g = gap / L;
    const pts = [0];
    for (const t of cuts[i].sort((p, q) => p - q)) pts.push(t - g, t + g);
    pts.push(1);
    for (let k = 0; k < pts.length; k += 2) {
      const t0 = Math.max(pts[k], 0), t1 = Math.min(pts[k + 1], 1);
      if (t1 <= t0) continue;
      const mid = (t0 + t1) / 2;
      out.push({
        x1: a[0] + t0 * (b[0] - a[0]), y1: a[1] + t0 * (b[1] - a[1]),
        x2: a[0] + t1 * (b[0] - a[0]), y2: a[1] + t1 * (b[1] - a[1]),
        edge: i, arc: arcs ? arcs.arcAt(i, mid) : 0, depth: a[2] + mid * (b[2] - a[2]),
      });
    }
  }
  return out;
}

export function bounds(P) {
  const xs = P.map(p => p[0]), ys = P.map(p => p[1]);
  return { x0: Math.min(...xs), x1: Math.max(...xs), y0: Math.min(...ys), y1: Math.max(...ys) };
}
