// the plan stays a drawing. what changes is that some of it stands up.

color inkAccent;

float riseScale = 1.0;
float iconScale = 1.0;
float accentRate = 0.045;

void chooseInk() {
  inkAccent = color(206, 78, 48);
  int pick = pickInk(150, 145, 230);
  if (pick < 0) pick = pickInk(110, 120, 240);
  if (pick >= 0) inkAccent = pal.goodcolor[pick];
  println("ink " + int(red(inkAccent)) + " " + int(green(inkAccent)) + " " + int(blue(inkAccent)));
}

int pickInk(float minSat, float minBri, float maxBri) {
  ArrayList<Integer> warm = new ArrayList<Integer>();
  for (int i = 0; i < pal.numpal; i++) {
    color c = pal.goodcolor[i];
    float h = hue(c);
    if (saturation(c) < minSat || brightness(c) < minBri || brightness(c) > maxBri) continue;
    if (h < 42 || h > 225) warm.add(i);
  }
  if (warm.size() == 0) return -1;
  return warm.get(int(random(warm.size())));
}

float unitHash(int n) {
  long x = n & 0xffffffffL;
  x = (x ^ (x >>> 16)) * 0x7feb352dL;
  x = (x ^ (x >>> 15)) * 0x846ca68bL;
  x = x ^ (x >>> 16);
  x = x & 0xffffffffL;
  return (x & 0xffffffL) / 16777215.0;
}

boolean hotOf(int id) {
  return unitHash(id ^ 0x51ed) < accentRate;
}

float wx(float x) { return x - width * 0.5; }
float wz(float y) { return y - height * 0.5; }

void renderScene() {
  hint(DISABLE_DEPTH_TEST);
  background(0);
  applyCamera();
  strokeCap(ROUND);
  strokeJoin(ROUND);

  drawFloorPlan();

  for (PointSource ps : psources) renderSource3D(ps);
  for (Orbit orb : orbits) renderOrbit3D(orb);
  for (Radiant rdt : radiants) renderRadiant3D(rdt);
  for (Chord chd : chords) renderChord3D(chd);
  for (PointEnd pe : pends) if (!monumentOf(pe)) renderPointEnd3D(pe);
  for (PointEnd pe : pends) if (monumentOf(pe)) renderPointEnd3D(pe);
  renderStars3D();
}

boolean monumentOf(PointEnd pe) {
  return unitHash(pe.idc ^ 0x5a1) > 0.945;
}

void applyCamera() {
  float aspect = width / (float) height;
  perspective(PI / 5.2, aspect, 6, 16000);
  float el = camElevation;
  float az = camAzimuth;
  float dist = camDistance;
  float lx = 0;
  float ly = -camLookUp;
  float lz = 0;
  float ex = lx + dist * cos(el) * sin(az);
  float ey = ly - dist * sin(el);
  float ez = lz + dist * cos(el) * cos(az);
  camera(ex, ey, ez, lx, ly, lz, 0, -1, 0);
}

void drawFloorPlan() {
  color g0 = ghostStroke;
  color c0 = colorStroke;
  color l0 = lightStroke;
  color h0 = halfStroke;
  ghostStroke = color(255, 148);
  colorStroke = color(255, 228);
  lightStroke = color(255, 72);
  halfStroke = color(255, 36);
  drawingFloor = true;
  pushMatrix();
  translate(-width * 0.5, 0, -height * 0.5);
  rotateX(HALF_PI);
  strokeWeight(1.25);
  renderGhost();
  popMatrix();
  drawingFloor = false;
  ghostStroke = g0;
  colorStroke = c0;
  lightStroke = l0;
  halfStroke = h0;
}

void whiteInk(int alpha) {
  noFill();
  stroke(255, alpha);
  strokeWeight(1.12);
}

void ink() {
  noFill();
  stroke(inkAccent);
  strokeWeight(1.55);
}

void renderSource3D(PointSource ps) {
  float t = unitHash(ps.idc);
  float h = lerp(70, 168, pow(t, 0.8)) * riseScale;
  float baseR = max(16, ps.w * 2.4);
  int wa = 188 + int(unitHash(ps.idc ^ 0x44) * 50);
  boolean hot = hotOf(ps.idc);

  whiteInk(wa - 40);
  line(wx(ps.x), 0, wz(ps.y), wx(ps.x), -h, wz(ps.y));
  ringFlat(ps.x, ps.y, 0, baseR);
  ringFlat(ps.x, ps.y, h * 0.46, baseR * 0.78);
  if (hot) ink();
  else whiteInk(min(255, wa + 20));
  ringFlat(ps.x, ps.y, h, baseR * 0.52);
}

void renderOrbit3D(Orbit o) {
  float t = unitHash(o.idc);
  if (t < 0.64) return;
  float span = o.endTheta - o.startTheta;
  if (span < 0.02) return;
  float h = lerp(18, 132, pow((t - 0.64) / 0.36, 1.15)) * riseScale;
  h *= lerp(1.0, 0.6, constrain(span / PI, 0, 1));
  h *= constrain(map(o.r, 36, width * 0.48, 1.05, 0.42), 0.42, 1.05);
  float k = lerp(0.38, 1, unitHash(o.idc ^ 8));
  float h0 = h * k;
  float h1 = h;
  if (unitHash(o.idc ^ 9) < 0.5) {
    float tmp = h0;
    h0 = h1;
    h1 = tmp;
  }

  whiteInk(96);
  post(o.ax, o.ay, h0);
  post(o.bx, o.by, h1);
  if (hotOf(o.idc)) ink();
  else whiteInk(236);
  arcLift(o.ps.x, o.ps.y, o.r, o.startTheta, o.endTheta, h0, h1);
}

void renderRadiant3D(Radiant r) {
  float t = unitHash(r.idc);
  float len = dist(r.ax, r.ay, r.bx, r.by);
  if (t < 0.58 || len < 18) return;
  float h = lerp(12, 78, pow((t - 0.58) / 0.42, 1.2)) * riseScale;
  h *= constrain(map(len, 14, 160, 0.5, 1), 0.5, 1);
  float k = lerp(0.32, 1, unitHash(r.idc ^ 3));
  float h0 = h * k;
  float h1 = h;
  if (unitHash(r.idc ^ 4) < 0.5) {
    float tmp = h0;
    h0 = h1;
    h1 = tmp;
  }

  whiteInk(100);
  post(r.ax, r.ay, h0);
  post(r.bx, r.by, h1);
  if (hotOf(r.idc)) ink();
  else whiteInk(230);
  line(wx(r.ax), -h0, wz(r.ay), wx(r.bx), -h1, wz(r.by));
}

void renderChord3D(Chord c) {
  float h = lerp(12, 64, unitHash(c.idc)) * riseScale;
  int segs = 18;
  float px = c.ax;
  float py = c.ay;
  float pu = 0;
  boolean hot = hotOf(c.idc);
  if (hot) ink();
  else whiteInk(200);
  for (int i = 1; i <= segs; i++) {
    float u = i / (float) segs;
    float x = lerp(c.ax, c.bx, u);
    float y = lerp(c.ay, c.by, u);
    float lift = sin(u * PI) * h;
    line(wx(px), -pu, wz(py), wx(x), -lift, wz(y));
    px = x;
    py = y;
    pu = lift;
  }
}

void renderPointEnd3D(PointEnd pe) {
  boolean monument = monumentOf(pe);
  float s = (monument ? (36 + pe.w * 2.4) : (11 + pe.w * 1.7)) * iconScale;
  float tilt = (unitHash(pe.idc ^ 0x10) - 0.5) * (monument ? 0.95 : 0.28);
  float spin = (unitHash(pe.idc ^ 0x11) - 0.5) * (monument ? 1.5 : 0.22);
  float pitch = (unitHash(pe.idc ^ 0x12) - 0.5) * (monument ? 0.7 : 0.12);
  float hover = 0;
  if (monument) hover = (28 + unitHash(pe.idc ^ 0x22) * 56) * riseScale;

  if (hover > 2) {
    stroke(255, 68);
    strokeWeight(0.75);
    line(wx(pe.x), 0, wz(pe.y), wx(pe.x), -hover, wz(pe.y));
  }

  int wa = 198 + int(unitHash(pe.idc ^ 0x44) * 52);
  pushMatrix();
  translate(wx(pe.x), -hover, wz(pe.y));
  rotateY(-pe.theta + spin);
  rotateX(pitch);
  rotateZ(tilt);
  whiteInk(wa);
  drawGlyph(pe.type, s, pe.num, pe.sign, hotOf(pe.idc));
  popMatrix();
}

void post(float sx, float sy, float h) {
  if (h < 2) return;
  line(wx(sx), 0, wz(sy), wx(sx), -h, wz(sy));
}

void arcLift(float cx, float cy, float r, float a0, float a1, float h0, float h1) {
  if (a1 < a0) a1 += TWO_PI;
  int segs = max(8, int(abs(a1 - a0) * r / 8.0));
  float px = 0;
  float py = 0;
  float pu = 0;
  for (int i = 0; i <= segs; i++) {
    float t = i / (float) segs;
    float a = lerp(a0, a1, t);
    float x = cx + r * cos(a);
    float y = cy + r * sin(a);
    float u = lerp(h0, h1, t);
    if (i > 0) line(wx(px), -pu, wz(py), wx(x), -u, wz(y));
    px = x;
    py = y;
    pu = u;
  }
}

void ringFlat(float sx, float sy, float up, float r) {
  pushMatrix();
  translate(wx(sx), -up, wz(sy));
  rotateX(HALF_PI);
  noFill();
  ellipse(0, 0, r * 2, r * 2);
  popMatrix();
}

void iline(float x0, float u0, float z0, float x1, float u1, float z1) {
  line(x0, -u0, z0, x1, -u1, z1);
}

void iringFlat(float x, float u, float z, float r) {
  pushMatrix();
  translate(x, -u, z);
  rotateX(HALF_PI);
  noFill();
  ellipse(0, 0, r * 2, r * 2);
  popMatrix();
}

void iringUp(float x, float u, float z, float r) {
  pushMatrix();
  translate(x, -u, z);
  noFill();
  ellipse(0, 0, r * 2, r * 2);
  popMatrix();
}

void iarch(float x, float u, float z, float r) {
  pushMatrix();
  translate(x, -u, z);
  noFill();
  arc(0, 0, r * 2, r * 2, PI, TWO_PI);
  popMatrix();
}

void ibox(float x, float u, float z, float w, float h, float d) {
  pushMatrix();
  translate(x, -(u + h * 0.5), z);
  noFill();
  box(w, h, d);
  popMatrix();
}

void iocta(float s) {
  float r = s * 0.55;
  iline(0, 0, 0, r, r, 0);
  iline(0, 0, 0, -r, r, 0);
  iline(0, 0, 0, 0, r, r);
  iline(0, 0, 0, 0, r, -r);
  iline(0, 2 * r, 0, r, r, 0);
  iline(0, 2 * r, 0, -r, r, 0);
  iline(0, 2 * r, 0, 0, r, r);
  iline(0, 2 * r, 0, 0, r, -r);
  iline(r, r, 0, 0, r, r);
  iline(0, r, r, -r, r, 0);
  iline(-r, r, 0, 0, r, -r);
  iline(0, r, -r, r, r, 0);
}

void drawGlyph(int type, float s, int num, int sign, boolean hot) {
  int n = max(1, num);
  switch (type) {
    case 0: {
      iringUp(0, s * 0.55, 0, s * 0.55);
      if (hot) {
        ink();
        iringUp(0, s * 0.55, 0, s * 0.2);
      }
      break;
    }
    case 1: {
      iocta(s);
      if (hot) {
        ink();
        iringFlat(0, s * 0.55, 0, s * 0.28);
      }
      break;
    }
    case 2: {
      iringUp(0, s * 0.5, 0, s * 0.5);
      if (hot) ink();
      iringUp(s * 0.95, s * 0.82, 0, s * 0.3);
      break;
    }
    case 3: {
      iline(0, 0, -s, 0, 0, s);
      iline(0, 0, -s, 0, s * 1.35, -s);
      iline(0, 0, s, 0, s * 1.35, s);
      if (hot) ink();
      iline(0, s * 1.35, -s, 0, s * 1.35, s);
      break;
    }
    case 4: {
      iline(0, 0, 0, s, 0, 0);
      iline(s, 0, -s * 0.75, s, 0, s * 0.75);
      iline(s, 0, -s * 0.75, s, s * 1.15, -s * 0.75);
      iline(s, 0, s * 0.75, s, s * 1.15, s * 0.75);
      iline(0, 0, 0, 0, s * 0.5, 0);
      iline(0, s * 0.5, 0, s, s * 1.15, 0);
      if (hot) ink();
      iline(s, s * 1.15, -s * 0.75, s, s * 1.15, s * 0.75);
      break;
    }
    case 5: {
      float aw = s * 0.52;
      float d = 0;
      float u = aw;
      for (int i = 0; i < n; i++) {
        if (hot && i == n - 1) ink();
        iringUp(d, u, 0, aw);
        d += aw * 1.35;
        u += aw * 0.8;
        aw *= 0.64;
      }
      break;
    }
    case 6: {
      float twist = hot ? 0.7 : 0.42;
      glyphPrism(s, s * 1.05, twist, hot);
      break;
    }
    case 7: {
      iarch(0, 0, 0, s);
      if (hot) ink();
      iarch(0, 0, 0, s * 0.58);
      break;
    }
    case 8: {
      float aw = max(3.5, s * 0.22);
      for (int i = 0; i < n; i++) {
        if (hot && i == 0) ink();
        ibox(-i * aw * 3.1, i * aw * 1.35, aw * 1.6, aw * 2.1, aw * 2.1, aw * 2.1);
      }
      break;
    }
    case 9: {
      int shells = max(2, n / 2);
      for (int i = 0; i < shells; i++) {
        if (hot && i == shells - 1) ink();
        iarch(0, 0, i * s * 0.07, s * 0.42 + i * s * 0.26);
      }
      break;
    }
    case 10: {
      int feathers = max(1, n / 2);
      for (int i = 0; i < feathers; i++) {
        float x = -i * s * 0.36;
        float u = i * s * 0.2;
        if (hot && i == feathers - 1) ink();
        iline(x, u, 0, x + s * 0.82, u + s * 0.5, s * 0.26);
        iline(x, u, 0, x + s * 0.82, u + s * 0.5, -s * 0.26);
      }
      break;
    }
    case 11: {
      float sgn = sign;
      iline(0, 0, 0, s * 0.58, s * 0.18, sgn * s * 0.42);
      if (hot) ink();
      iline(s * 0.58, s * 0.18, sgn * s * 0.42, s * 1.2, s * 0.92, -sgn * s * 0.18);
      break;
    }
    case 12: {
      pushMatrix();
      rotateY(0.55);
      rotateZ(0.38);
      ibox(0, 0, 0, s * 0.9, s * 0.9, s * 0.9);
      popMatrix();
      if (hot) {
        ink();
        iringFlat(0, s * 0.95, 0, s * 0.28);
      }
      break;
    }
    case 13: {
      float h = s * 0.92;
      ibox(0, 0, 0, h, h, h);
      if (hot) {
        ink();
        float e = h * 0.5;
        iline(-e, h, -e, e, h, -e);
        iline(e, h, -e, e, h, e);
        iline(e, h, e, -e, h, e);
        iline(-e, h, e, -e, h, -e);
      }
      break;
    }
    case 14: {
      for (int i = 0; i < 4; i++) {
        if (hot && i == 3) ink();
        iringFlat(0, i * s * 0.28, 0, s * (0.55 - i * 0.09));
      }
      break;
    }
    default: {
      iline(0, 0, 0, s, s * 1.05, s * 0.35);
      if (hot) ink();
      iline(s, s * 1.05, s * 0.35, s * 0.15, s * 1.45, -s * 0.28);
      iringFlat(s * 0.15, s * 1.45, -s * 0.28, s * 0.16);
      break;
    }
  }
}

void glyphPrism(float s, float h, float twist, boolean hot) {
  float ax = s;
  float az = 0;
  float bx = -s * 0.42;
  float bz = s * 0.7;
  float cx = -s * 0.42;
  float cz = -s * 0.7;
  float cs = cos(twist);
  float sn = sin(twist);
  float ax1 = ax * cs - az * sn;
  float az1 = ax * sn + az * cs;
  float bx1 = bx * cs - bz * sn;
  float bz1 = bx * sn + bz * cs;
  float cx1 = cx * cs - cz * sn;
  float cz1 = cx * sn + cz * cs;
  iline(ax, 0, az, bx, 0, bz);
  iline(bx, 0, bz, cx, 0, cz);
  iline(cx, 0, cz, ax, 0, az);
  iline(ax, 0, az, ax1, h, az1);
  iline(bx, 0, bz, bx1, h, bz1);
  iline(cx, 0, cz, cx1, h, cz1);
  if (hot) ink();
  iline(ax1, h, az1, bx1, h, bz1);
  iline(bx1, h, bz1, cx1, h, cz1);
  iline(cx1, h, cz1, ax1, h, az1);
}

void renderStars3D() {
  if (stars.size() == 0) return;
  for (Star s : stars) {
    pushMatrix();
    translate(wx(s.x), -(14 + s.w * 0.3), wz(s.y));
    noFill();
    stroke(255, 210);
    strokeWeight(1.05);
    float r = max(5, s.w * 0.4);
    line(0, -r, 0, 0, r, 0);
    line(-r, 0, 0, r, 0, 0);
    line(0, 0, -r, 0, 0, r);
    popMatrix();
    stroke(255, 46);
    strokeWeight(0.8);
    for (Star b : s.cons) {
      if (b.x < s.x || (b.x == s.x && b.y <= s.y)) continue;
      int segs = 12;
      float px = s.x;
      float py = s.y;
      float pu = 0;
      for (int i = 1; i <= segs; i++) {
        float u = i / (float) segs;
        float x = lerp(s.x, b.x, u);
        float y = lerp(s.y, b.y, u);
        float lift = sin(u * PI) * 18;
        line(wx(px), -pu, wz(py), wx(x), -lift, wz(y));
        px = x;
        py = y;
        pu = lift;
      }
    }
  }
}
