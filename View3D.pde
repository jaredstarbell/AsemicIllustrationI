// floor plan plus a few faint vertical highlights

void renderView() {
  hint(DISABLE_DEPTH_TEST);
  background(0);
  positionCamera();
  drawFloor();
  drawVerticals();
}

float lookX = 0;
float lookY = 0;
float lookZ = 0;

float camAz = 0.4;
float camEl = 0.5;
float camDist = 900;
float camZoom = 1;
float targetZoom = 1;
float shownLookX = 0;
float shownLookY = 0;
float shownLookZ = 0;
boolean camReady = false;

void positionCamera() {
  orbitAngle += 0.0022;
  float targetAz = orbitAngle;
  float targetEl = 0.5;
  if (pointer) {
    targetAz += (mouseX / float(width) - 0.5) * 1.6;
    targetEl -= (mouseY / float(height) - 0.5) * 0.9;
  }
  targetEl = constrain(targetEl, 0.2, 1.15);
  float fov = PI / 4.6;
  focusOnDrawing();
  float base = fitDistance(targetAz, targetEl, fov);
  float destDist = base * targetZoom;
  if (!camReady) {
    camAz = targetAz;
    camEl = targetEl;
    camDist = destDist;
    camZoom = targetZoom;
    shownLookX = lookX;
    shownLookY = lookY;
    shownLookZ = lookZ;
    camReady = true;
  }
  float ease = 0.07;
  camAz += shortAngle(targetAz - camAz) * ease;
  camEl += (targetEl - camEl) * ease;
  camZoom += (targetZoom - camZoom) * ease;
  camDist += (destDist - camDist) * ease;
  shownLookX += (lookX - shownLookX) * ease;
  shownLookY += (lookY - shownLookY) * ease;
  shownLookZ += (lookZ - shownLookZ) * ease;
  applyCamera(camAz, camEl, camDist, fov, shownLookX, shownLookY, shownLookZ);
}

float shortAngle(float d) {
  while (d > PI) d -= TWO_PI;
  while (d < -PI) d += TWO_PI;
  return d;
}

void mouseWheel(MouseEvent event) {
  targetZoom *= pow(1.08, event.getCount());
  targetZoom = constrain(targetZoom, 0.28, 5);
}

void focusOnDrawing() {
  float minX = width;
  float maxX = 0;
  float minY = height;
  float maxY = 0;
  float top = 0;
  for (PointSource ps : psources) {
    minX = min(minX, ps.x); maxX = max(maxX, ps.x);
    minY = min(minY, ps.y); maxY = max(maxY, ps.y);
  }
  for (PointEnd pe : pends) {
    minX = min(minX, pe.x); maxX = max(maxX, pe.x);
    minY = min(minY, pe.y); maxY = max(maxY, pe.y);
    top = max(top, liftHeight(pe));
  }
  for (Radiant r : radiants) {
    minX = min(minX, min(r.ax, r.bx)); maxX = max(maxX, max(r.ax, r.bx));
    minY = min(minY, min(r.ay, r.by)); maxY = max(maxY, max(r.ay, r.by));
  }
  for (Orbit o : orbits) {
    minX = min(minX, min(o.ax, o.bx)); maxX = max(maxX, max(o.ax, o.bx));
    minY = min(minY, min(o.ay, o.by)); maxY = max(maxY, max(o.ay, o.by));
    // the arc itself can sit outside the chord of its endpoints
    float mid = (o.startTheta + o.endTheta) * 0.5;
    float mx = o.ps.x + o.r * cos(mid);
    float my = o.ps.y + o.r * sin(mid);
    minX = min(minX, mx); maxX = max(maxX, mx);
    minY = min(minY, my); maxY = max(maxY, my);
  }
  if (maxX < minX) {
    lookX = 0; lookY = 0; lookZ = 0;
    return;
  }
  lookX = (minX + maxX) * 0.5 - width * 0.5;
  lookZ = (minY + maxY) * 0.5 - height * 0.5;
  lookY = top * 0.35;
  spanX = max(40, maxX - minX);
  spanZ = max(40, maxY - minY);
  spanTop = max(top, 8);
}

float spanX = 100;
float spanZ = 100;
float spanTop = 8;

void applyCamera(float az, float el, float dist, float fov) {
  applyCamera(az, el, dist, fov, lookX, lookY, lookZ);
}

void applyCamera(float az, float el, float dist, float fov, float lx, float ly, float lz) {
  float ex = lx + dist * cos(el) * sin(az);
  float ey = ly + dist * sin(el);
  float ez = lz + dist * cos(el) * cos(az);
  perspective(fov, width / float(height), 2, dist * 14);
  camera(ex, ey, ez, lx, ly, lz, 0, 1, 0);
}

float fitDistance(float az, float el, float fov) {
  float lo = 80;
  float hi = max(width, height) * 4;
  for (int i = 0; i < 18; i++) {
    float mid = (lo + hi) * 0.5;
    applyCamera(az, el, mid, fov);
    if (modelOnScreen()) hi = mid;
    else lo = mid;
  }
  return hi;
}

boolean modelOnScreen() {
  float hx = spanX * 0.5;
  float hz = spanZ * 0.5;
  float m = 6;
  float[][] pts = {
    {lookX - hx, 0, lookZ - hz},
    {lookX + hx, 0, lookZ - hz},
    {lookX + hx, 0, lookZ + hz},
    {lookX - hx, 0, lookZ + hz},
    {lookX, spanTop, lookZ}
  };
  for (int i = 0; i < pts.length; i++) {
    float sx = screenX(pts[i][0], pts[i][1], pts[i][2]);
    float sy = screenY(pts[i][0], pts[i][1], pts[i][2]);
    if (Float.isNaN(sx) || Float.isNaN(sy)) return false;
    if (sx < m || sy < m || sx > width - m || sy > height - m) return false;
  }
  return true;
}

void drawFloor() {
  pushMatrix();
  translate(-width * 0.5, 0, -height * 0.5);
  rotateX(HALF_PI);
  strokeWeight(2);
  renderGhost();
  popMatrix();
}

void drawVerticals() {
  for (PointEnd pe : pends) {
    float h = liftHeight(pe);
    if (h <= 0) continue;
    float sx = pe.x - width * 0.5;
    float sz = pe.y - height * 0.5;
    stroke(color(255, 32));
    strokeWeight(1.5);
    line(sx, 0, sz, sx, h, sz);
    stroke(color(255, 222));
    strokeWeight(6);
    point(sx, h, sz);
  }
}

float liftHeight(PointEnd pe) {
  float pick = unitHash(pe.idc);
  if (pick < 0.7) return 0;
  return lerp(32, 230, unitHash(pe.idc ^ 91));
}

float unitHash(int n) {
  long x = n & 0xffffffffL;
  x = (x ^ (x >>> 16)) * 0x7feb352dL;
  x = (x ^ (x >>> 15)) * 0x846ca68bL;
  x = x ^ (x >>> 16);
  return (x & 0xffffffL) / 16777215.0;
}
