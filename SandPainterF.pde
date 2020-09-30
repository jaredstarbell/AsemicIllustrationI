class SandPainterF {

  color c;
  int age;
  float nz, ny, nx;    // noise offset
  float fz, fy, fx;    // noise frequency
  float g;
  float intensity;
  
  int grains = 32;

  SandPainterF(color _c, float _intensity) {
    c = _c;
    intensity = _intensity;
    if (intensity>1) intensity = 1;
    if (intensity<0) intensity = 0;
    
    age = 0;
    nz = random(100);
    ny = random(100); 
    nx = random(100);
    
    fz = random(.03,.07);
    
    g = random(0.01,0.1);
    
  }
  
  void render(float x, float y, float ox, float oy) {
    // modulate gain
    age++;
//    float g = noise(age*.05 + nz) * noise(age*.025 + ny) * noise(age*.01 + nx);
//    float g = (noise(age*.05 + nz) + noise(age*.025 + ny) + noise(age*.01 + nx))/3;

    //g+=random(-0.050,0.050);
    g+=.05*(noise(age*fz + nz)-.5);
    if (g<.01) g=.01;
    if (g>1) g=1;
    
    // calculate number of pixels by distance between points 
    float d = dist(x,y,ox,oy);
    float dx = (x-ox)/d;
    float dy = (y-oy)/d;
    
    float val = 255*intensity*(1-.8*g);
    
    // lay down grains of sand (transparent pixels)
    for (int i=0;i<ceil(d*g);i++) {
      float a = 1 - i/(d*g); 
      stroke(red(c),green(c),blue(c),a*val);
      point(ox+dx*i,oy+dy*i);
    }
  }
}
