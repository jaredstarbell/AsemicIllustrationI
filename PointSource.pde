class PointSource {
  float x, y;
  float w;
  
  float lastr;
  float lastdr;
  float lastmaxr;
  
  color idc;
  
  PointSource(float _x, float _y, float _w) {
    x = _x;
    y = _y;
    w = _w;

    lastr = w;
    lastdr = random(2,40);
    lastmaxr = 1.2*width/2;   // allow to fill screen completely

    idc = color(random(255),random(255),random(255));
    
  }
  
  void render() {
    stroke(colorStroke);
    fill(0);
    ellipse(x,y,w,w);
  }
  
  void renderBackground() {
    bg.beginDraw();
    bg.stroke(idc);
    bg.ellipse(x,y,w,w);
    bg.endDraw();
  }
  
  void renderGhost() {
    stroke(ghostStroke);
    fill(0);
    ellipse(x,y,w,w);
    stroke(colorStroke);
    point(x,y);
  }
  
  boolean isClear(color ec) {
    // check if free of obstruction
    float area = PI*pow(w/2,2);
    int samples = floor(area*.4);
    for (float i=0;i<=samples;i++) {
      float t = random(TWO_PI);
      float d = random(w/2);
      float fx = x + d*cos(t);
      float fy = y + d*sin(t);
      stroke(colorClear);
      point(fx,fy);
      if (!bgClear(floor(fx),floor(fy),ec)) return false;
    }
    
    return true;
     
  }  
  
  void incrementLastRadius() {
    lastr+=lastdr;
    if (lastr>lastmaxr) lastr-=lastmaxr;
  }
    
}
