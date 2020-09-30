class Chord {
  float ax, ay;
  float bx, by;
  
  color idc;
  
  Chord(float _ax, float _ay, float _bx, float _by) {
    ax = _ax;
    ay = _ay;
    bx = _bx;
    by = _by;
    
    idc = color(random(255),random(255),random(255));
    
  }
  
  void render() {
    stroke(idc,128);
    noFill();
    //line(ax,ay,bx,by);
    dline(ax,ay,bx,by,.25);
  }
  
  void renderBackground() {
    bg.beginDraw();
    bg.stroke(idc);
    bg.line(ax,ay,bx,by);
    bg.endDraw();
  } 
  
  void renderGhost() {
    
  }
  
  boolean isClear(color ec) {
    // check if free of obstruction
    float d = dist(ax,ay,bx,by);
    int samples = floor(d);
    for (float i=1;i<=samples;i++) {
      float t = i/samples; 
      float fx = ax + t*(bx-ax);
      float fy = ay + t*(by-ay);
      //stroke(colorClear);
      //point(fx,fy);
      if (!bgClear(floor(fx),floor(fy),ec)) return false;
    }
    
    return true;
     
  }
  
}
