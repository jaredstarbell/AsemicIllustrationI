// floor plan plus a few faint vertical highlights

void renderView() {
  hint(DISABLE_DEPTH_TEST);
  background(0);
  positionCamera();
  drawFloor();
  drawVerticals();
}

void positionCamera() {
  orbitAngle += 0.0022;
  float az = orbitAngle;
  float el = 0.5;
  if (pointer) {
    az += (mouseX / float(width) - 0.5) * 1.6;
    el -= (mouseY / float(height) - 0.5) * 0.9;
  }
  el = constrain(el, 0.2, 1.15);
  float dist = max(width, height) * 1.38;
  float ly = -28;
  float ex = dist * cos(el) * sin(az);
  float ey = ly - dist * sin(el);
  float ez = dist * cos(el) * cos(az);
  perspective(PI / 4.6, width / float(height), 6, 16000);
  camera(ex, ey, ez, 0, ly, 0, 0, -1, 0);
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
    line(sx, 0, sz, sx, -h, sz);
    stroke(color(255, 222));
    strokeWeight(6);
    point(sx, -h, sz);
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
