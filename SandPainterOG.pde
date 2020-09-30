class SandPainterOg {

  color c;
  float g;
  int grains = 64;

  SandPainterOg() {
    c = pal.somecolor();
    g = random(0.01,0.1);
  }
  
  void render(float x, float y, float ox, float oy) {
    // modulate gain
    g+=random(-0.050,0.050);
    float maxg = 1.0;
    if (g<0) g=0;
    if (g>maxg) g=maxg;
    
    // calculate grains by distance
    //int grains = int(sqrt((ox-x)*(ox-x)+(oy-y)*(oy-y)));

    // lay down grains of sand (transparent pixels)
    float w = g/(grains-1);
    for (int i=0;i<grains;i++) {
      float a = 0.1-i/(grains*10.0);
      spg.stroke(red(c),green(c),blue(c),a*256);
      spg.point(ox+(x-ox)*sin(sin(i*w)),oy+(y-oy)*sin(sin(i*w)));
      stroke(red(c),green(c),blue(c),a*256);
      point(ox+(x-ox)*sin(sin(i*w)),oy+(y-oy)*sin(sin(i*w)));
    }
  }
}
