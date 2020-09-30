class Orbit {
  PointSource ps;
  float startTheta, endTheta;
  float r;
  
  float thickness;
  
  float ax, ay;
  float bx, by;
  float theta;
  
  color idc;
  
  SandPainterOg sp;
  float cycleDensifier = 1.0;

  int sign = 1;

  
  Orbit(PointSource _ps, float _startTheta, float _endTheta, float _r) {
    ps = _ps;
    startTheta = _startTheta;
    endTheta = _endTheta;
    r = _r;
  
    sign = 1;                           // sandpainter on the inside
    if (random(100)<50) sign = -1;      // flip the sandpainter to the outside
    cycleDensifier = random(.1,.5);     // how dense is the sand painter (ratio of pixel coverage tangential to arc)
    thickness = 2*r;//random(r*.8,r);         // length of sandpainter stroke
    if (sign<0) thickness=r*4;
  
    idc = color(random(255),random(255),random(255));
    sp = new SandPainterOg();
       
    // calculate end points
    ax = ps.x + r*cos(startTheta);
    ay = ps.y + r*sin(startTheta);
    bx = ps.x + r*cos(endTheta);
    by = ps.y + r*sin(endTheta);
    
    theta = endTheta-startTheta;
  }

  void renderSP() {
    // render sand painter
    float rr = r + thickness*sign;
    int cycles = ceil(theta*r*cycleDensifier);
    float omega = theta/cycles;
    for (int n=0;n<cycles;n++) {
      float ox = ps.x + rr*cos(startTheta + omega*n);
      float oy = ps.y + rr*sin(startTheta + omega*n);
      float mx = ps.x + (r+1)*cos(startTheta + omega*n);
      float my = ps.y + (r+1)*sin(startTheta + omega*n);
      sp.render(ox,oy,mx,my);
    }
    
    // randomize the sand painter for next time
    sp = new SandPainterOg();
  }
  
  void render() {
    // render stroke of object
    stroke(colorStroke);
    noFill();
    arc(ps.x,ps.y,r*2,r*2,startTheta,endTheta);
  }
  
  void renderBackground() {
    bg.beginDraw();
    bg.stroke(idc);
    bg.arc(ps.x,ps.y,r*2,r*2,startTheta,endTheta);
    bg.endDraw();
  }
  
  void renderGhost() {
    // render stroke of object
    stroke(ghostStroke);
    noFill();
    arc(ps.x,ps.y,r*2,r*2,startTheta,endTheta);
    stroke(colorStroke);
    point(ax,ay);
    point(bx,by);
  }
  
  
  boolean isClear(color ec) {
    // check if free of obstruction
    float d = r*(endTheta-startTheta);
    float samples = d*.2;
    for (float i=0;i<=samples;i++) {
      float t = i/samples; 
      float omega = startTheta + t*(endTheta - startTheta);
      float fx = ps.x + r*cos(omega);
      float fy = ps.y + r*sin(omega);
      //stroke(colorClear);
      //point(fx,fy);
      if (!bgClear(floor(fx),floor(fy),ec)) return false;
    }
    
    return true;
     
  }
    
}
