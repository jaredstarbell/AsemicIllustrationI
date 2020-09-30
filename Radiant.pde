class Radiant {
  PointSource ps;
  float ind, outd;
  float theta;
  
  float ax, ay;
  float bx, by;
  
  color idc;
  
  PointEnd pe;
  
  
  Radiant(PointSource _ps, float _ind, float _outd, float _theta) {
    ps = _ps;
    ind = _ind;
    outd = _outd;
    theta = _theta;
    
    idc = color(random(255),random(255),random(255));
    
    ax = ps.x + ind*cos(theta);
    ay = ps.y + ind*sin(theta);
    bx = ps.x + outd*cos(theta);
    by = ps.y + outd*sin(theta);
    
  }
  
  void render() {
    stroke(colorStroke);
    noFill();
    line(ax,ay,bx,by);
  }
  
  void renderBackground() {
    bg.beginDraw();
    bg.stroke(idc);
    bg.line(ax,ay,bx,by);
    bg.endDraw();
  }
  
  void renderGhost() {
    stroke(ghostStroke);
    line(ax,ay,bx,by);
    stroke(lightStroke);
    point(ax,ay);
    stroke(colorStroke);
    point(bx,by);
  }
  
  boolean isClear(color ec) {
    // check if free of obstruction
    float d = dist(ax,ay,bx,by);
    float samples = d*.2;
    for (float i=0;i<=samples;i++) {
      float t = i/samples; 
      float fx = ax + t*(bx-ax);
      float fy = ay + t*(by-ay);
      //stroke(colorClear);
      //point(fx,fy);
      if (!bgClear(floor(fx),floor(fy),ec)) return false;
    }
    
    return true;
     
  }

  float endClear(color ec) {
    // find the point of obstruction
    float d = dist(ax,ay,bx,by);
    float samples = d*.25;
    for (float i=0;i<=samples;i++) {
      float t = i/samples; 
      float fx = ax + t*(bx-ax);
      float fy = ay + t*(by-ay);
      stroke(colorClear);
      point(fx,fy);
      if (!bgClear(floor(fx),floor(fy),ec)) return t*d;
    }
    println("WARN Radiant endClear should only be called if isClear==false");
    return 0;
     
  }


}
