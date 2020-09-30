class PointEnd {
  Orbit orb;
  float x, y;
  float w;
  float theta;
  int type;
  
  color idc;
  
  int num;
  int sign;
  
  Orbit orbit;
  
  SandPainterOg sp;
  float cycleDensifier = 1.0;
  
  PointEnd(Orbit _orb, float _x, float _y, float _w, float _theta, int _type) {
    orb = _orb;
    x = _x;
    y = _y;
    w = _w;
    theta = _theta;
    type = _type;
    
    idc = color(random(255),random(255),random(255));
    sp = new SandPainterOg();
    sp.grains = 10;
    cycleDensifier = random(3.0);
    
    // number is used for some drawing styles 
    num = floor(random(1,w));
    
    sign = 1;
    if (random(100)<50) sign = -1;
    
  }
  
  void renderSP() {
    float rr = w*14;
    //int cycles = 5;
    //float omega = TWO_PI/cycles;
    float omega = atan(random(5,20)/rr);
    int cycles = round(TWO_PI/omega); 
    for (int i=0;i<cycles;i++) {
      //float ox = x;
      //float oy = y;
      float t = theta + omega*i;
      float ox = x - rr*cos(t);
      float oy = y - rr*sin(t);
      float mx = x + rr*cos(t);
      float my = y + rr*sin(t);
      sp.render(ox,oy,mx,my);
    }
    
    sp = new SandPainterOg();
    sp.grains = 10;
    
  }
  
  void render() {
    if (type==0) {
      stroke(colorStroke);
      fill(0);
      ellipse(x,y,w,w);
    } else if (type==1) {
      stroke(colorStroke);
      fill(colorStroke);
      ellipse(x,y,w,w);
    } else if (type==2) {
      stroke(colorStroke);
      fill(0);
      ellipse(x,y,w,w);
      float dw = (w+w*.618)/2;
      float nx = x + dw*cos(theta);
      float ny = y + dw*sin(theta);
      ellipse(nx,ny,w*.618,w*.618);
    } else if (type==3) {
      stroke(colorStroke);
      noFill();
      float ax = x + w*cos(theta+HALF_PI);
      float ay = y + w*sin(theta+HALF_PI);
      float bx = x + w*cos(theta-HALF_PI);
      float by = y + w*sin(theta-HALF_PI);
      line(ax,ay,bx,by);
    } else if (type==4) {
      stroke(colorStroke);
      noFill();
      float dw = w;
      float ax = x + dw*cos(theta+HALF_PI);
      float ay = y + dw*sin(theta+HALF_PI);
      float bx = x + dw*cos(theta-HALF_PI);
      float by = y + dw*sin(theta-HALF_PI);
      float cx = x + dw*cos(theta);
      float cy = y + dw*sin(theta);
      line(ax,ay,bx,by);
      line(x,y,cx,cy);
    } else if (type==5) {
      stroke(colorStroke);
      fill(0);
      float aw = w;
      float d = 0;
      for (int n=0;n<num;n++) {
        float ax = x + d*cos(theta);
        float ay = y + d*sin(theta);
        ellipse(ax,ay,aw,aw);
        aw*=.618;
        d+=w*1.21;
      }
      
    } else if (type==6) {
      stroke(colorStroke);
      fill(0);
      float ax = x + w*cos(theta+HALF_PI);
      float ay = y + w*sin(theta+HALF_PI);
      float bx = x + w*cos(theta-HALF_PI);
      float by = y + w*sin(theta-HALF_PI);
      float cx = x + w*cos(theta);
      float cy = y + w*sin(theta);
      line(ax,ay,bx,by);
      line(bx,by,cx,cy);
      line(cx,cy,ax,ay);
    } else if (type==7) {
      stroke(colorStroke);
      noFill();
      arc(x,y,w,w,theta+HALF_PI,theta+3*HALF_PI,OPEN);
    } else if (type==8) {
      stroke(colorStroke);
      fill(colorStroke);
      float aw = w*.18;
      float offx = 2.5*aw*cos(theta+HALF_PI);
      float offy = 2.5*aw*sin(theta+HALF_PI);
      for (int n=0;n<num;n++) {
        float ax = x + offx - n*aw*3.3*cos(theta);
        float ay = y + offy - n*aw*3.3*sin(theta);
        ellipse(ax,ay,w*.3,w*.3);
      }
    } else if (type==9) {
      stroke(colorStroke);
      fill(0);
      for (int n=num/2-1;n>=0;n--) {
        float aw = w + n*8;
        arc(x,y,aw,aw,theta-HALF_PI,theta+HALF_PI,OPEN);
      }
    } else if (type==10) {
      stroke(colorStroke);
      noFill();
      float aw = w*.5;
      float offx = aw*cos(theta);
      float offy = aw*sin(theta);
      for (int n=0;n<num/2;n++) {
        float ax = x - offx*n;
        float ay = y - offy*n;
        float bx = ax + aw*3*cos(theta-QUARTER_PI);
        float by = ay + aw*3*sin(theta-QUARTER_PI);
        float cx = ax + aw*3*cos(theta+QUARTER_PI);
        float cy = ay + aw*3*sin(theta+QUARTER_PI);
        line(ax,ay,bx,by);
        line(ax,ay,cx,cy);
      }
    } else if (type==11) {
      stroke(colorStroke);
      noFill();
      int sign = 1;
      if (random(1.0)<.5) sign = -1;
      float ax = x + w/2*cos(theta+QUARTER_PI*sign);
      float ay = y + w/2*sin(theta+QUARTER_PI*sign);
      float bx = ax + w*cos(theta-QUARTER_PI*sign);
      float by = ay + w*sin(theta-QUARTER_PI*sign);
      line(x,y,ax,ay);
      line(ax,ay,bx,by);
    } else if (type==12) {
      stroke(colorStroke);
      fill(0);
      pushMatrix();
      translate(x,y);
      rotate(theta);
      rectMode(CENTER);
      rect(0,0,w,w);
      popMatrix();
    } else if (type==13) {
      stroke(colorStroke);
      fill(colorStroke);
      pushMatrix();
      translate(x,y);
      rotate(theta);
      rectMode(CENTER);
      rect(0,0,w,w);
      popMatrix();
    } else if (type==14) {
      // TODO 
    } else if (type==15) {
      // TODO 
    } else {
      // TODO
    }
    
  }
  
void renderBackground() {
    if (type==0) {
      bg.beginDraw();
      bg.stroke(idc);
      bg.ellipse(x,y,w,w);
      bg.endDraw();
    } else if (type==1) {
      bg.beginDraw();
      bg.stroke(idc);
      bg.ellipse(x,y,w,w);
      bg.endDraw();
    } else if (type==2) {
      float dw = (w+w*.618)/2;
      float nx = x + dw*cos(theta);
      float ny = y + dw*sin(theta);
      bg.beginDraw();
      bg.stroke(idc);
      bg.ellipse(x,y,w,w);
      bg.ellipse(nx,ny,w*.618,w*.618);
      bg.endDraw();
    } else if (type==3) {
      float ax = x + w*cos(theta+HALF_PI);
      float ay = y + w*sin(theta+HALF_PI);
      float bx = x + w*cos(theta-HALF_PI);
      float by = y + w*sin(theta-HALF_PI);
      bg.beginDraw();
      bg.stroke(idc);
      bg.line(ax,ay,bx,by);
      bg.endDraw();
    } else if (type==4) {
      float dw = w;
      float ax = x + dw*cos(theta+HALF_PI);
      float ay = y + dw*sin(theta+HALF_PI);
      float bx = x + dw*cos(theta-HALF_PI);
      float by = y + dw*sin(theta-HALF_PI);
      float cx = x + dw*cos(theta);
      float cy = y + dw*sin(theta);
      bg.beginDraw();
      bg.stroke(idc);
      bg.line(ax,ay,bx,by);
      bg.line(x,y,cx,cy);
      bg.endDraw();
    } else if (type==5) {
      float aw = w;
      float d = 0;
      for (int n=0;n<num;n++) {
        float ax = x + d*cos(theta);
        float ay = y + d*sin(theta);
        bg.beginDraw();
        bg.stroke(idc);
        bg.ellipse(ax,ay,aw,aw);
        bg.endDraw();
        aw*=.618;
        d+=w*1.21;
      }
      
    } else if (type==6) {
      float ax = x + w*cos(theta+HALF_PI);
      float ay = y + w*sin(theta+HALF_PI);
      float bx = x + w*cos(theta-HALF_PI);
      float by = y + w*sin(theta-HALF_PI);
      float cx = x + w*cos(theta);
      float cy = y + w*sin(theta);
      bg.beginDraw();
      bg.line(ax,ay,bx,by);
      bg.line(bx,by,cx,cy);
      bg.line(cx,cy,ax,ay);
      bg.endDraw();
    } else if (type==7) {
      bg.beginDraw();
      bg.arc(x,y,w,w,theta+HALF_PI,theta+3*HALF_PI,OPEN);
      bg.endDraw();
    } else if (type==8) {
      bg.beginDraw();
      bg.stroke(idc);
      float aw = w*.18;
      float offx = 2.5*aw*cos(theta+HALF_PI);
      float offy = 2.5*aw*sin(theta+HALF_PI);
      for (int n=0;n<num;n++) {
        float ax = x + offx - n*aw*3.3*cos(theta);
        float ay = y + offy - n*aw*3.3*sin(theta);
        bg.ellipse(ax,ay,w*.3,w*.3);
      }
      bg.endDraw();
    } else if (type==9) {
      bg.beginDraw();
      bg.stroke(idc);
      for (int n=num/2-1;n>=0;n--) {
        float aw = w + n*8;
        bg.arc(x,y,aw,aw,theta-HALF_PI,theta+HALF_PI,OPEN);
      }
      bg.endDraw();
    } else if (type==10) {
      bg.beginDraw();
      bg.stroke(idc);
      float aw = w*.5;
      float offx = aw*cos(theta);
      float offy = aw*sin(theta);
      for (int n=0;n<num/2;n++) {
        float ax = x - offx*n;
        float ay = y - offy*n;
        float bx = ax + aw*3*cos(theta-QUARTER_PI);
        float by = ay + aw*3*sin(theta-QUARTER_PI);
        float cx = ax + aw*3*cos(theta+QUARTER_PI);
        float cy = ay + aw*3*sin(theta+QUARTER_PI);
        bg.line(ax,ay,bx,by);
        bg.line(ax,ay,cx,cy);
      }
      bg.endDraw();
    } else if (type==11) {
      bg.beginDraw();
      bg.stroke(idc);
      float ax = x + w/2*cos(theta+QUARTER_PI*sign);
      float ay = y + w/2*sin(theta+QUARTER_PI*sign);
      float bx = ax + w*cos(theta-QUARTER_PI*sign);
      float by = ay + w*sin(theta-QUARTER_PI*sign);
      bg.line(x,y,ax,ay);
      bg.line(ax,ay,bx,by);
      bg.endDraw();
    } else if (type==12) {
      bg.beginDraw();
      bg.stroke(idc);
      bg.ellipse(x,y,w*1.2,w*1.2);
      bg.endDraw();
    } else if (type==13) {
      bg.beginDraw();
      bg.stroke(idc);
      bg.ellipse(x,y,w*1.2,w*1.2);
      bg.endDraw();
    } else if (type==14) {
      // TODO 
    } else if (type==15) {
      // TODO 
    } else {
      // TODO
    }
    
  }  
  
  void renderGhost() {
    if (type==0) {
      stroke(ghostStroke);
      fill(0);
      ellipse(x,y,w,w);
    } else if (type==1) {
      noStroke();
      fill(ghostStroke);
      ellipse(x,y,w,w);
    } else if (type==2) {
      noStroke();
      fill(ghostStroke);
      ellipse(x,y,w,w);
      float dw = (w+w*.618)/2;
      float nx = x + dw*cos(theta);
      float ny = y + dw*sin(theta);
      stroke(ghostStroke);
      noFill();
      ellipse(nx,ny,w*.618,w*.618);
    } else if (type==3) {
      stroke(ghostStroke);
      noFill();
      float ax = x + w*cos(theta+HALF_PI);
      float ay = y + w*sin(theta+HALF_PI);
      float bx = x + w*cos(theta-HALF_PI);
      float by = y + w*sin(theta-HALF_PI);
      line(ax,ay,bx,by);
      stroke(colorStroke);
      point(ax,ay);
      point(bx,by);
    } else if (type==4) {
      stroke(ghostStroke);
      noFill();
      float dw = w;
      float ax = x + dw*cos(theta+HALF_PI);
      float ay = y + dw*sin(theta+HALF_PI);
      float bx = x + dw*cos(theta-HALF_PI);
      float by = y + dw*sin(theta-HALF_PI);
      float cx = x + dw*cos(theta);
      float cy = y + dw*sin(theta);
      line(ax,ay,bx,by);
      line(x,y,cx,cy);
      stroke(colorStroke);
      point(ax,ay);
      point(bx,by);
      point(cx,cy);
    } else if (type==5) {
      fill(0);
      float aw = w;
      float d = 0;
      for (int n=0;n<num;n++) {
        float ax = x + d*cos(theta);
        float ay = y + d*sin(theta);
        stroke(ghostStroke);
        ellipse(ax,ay,aw,aw);
        aw*=.618;
        d+=w*1.21;
        stroke(colorStroke);
        point(ax,ay);
      }
    } else if (type==6) {
      stroke(ghostStroke);
      fill(0);
      float ax = x + w*cos(theta+HALF_PI);
      float ay = y + w*sin(theta+HALF_PI);
      float bx = x + w*cos(theta-HALF_PI);
      float by = y + w*sin(theta-HALF_PI);
      float cx = x + w*cos(theta);
      float cy = y + w*sin(theta);
      line(ax,ay,bx,by);
      line(bx,by,cx,cy);
      line(cx,cy,ax,ay);
      stroke(colorStroke);
      point(ax,ay);
      point(bx,by);
      point(cx,cy);
    } else if (type==7) {
      stroke(ghostStroke);
      noFill();
      arc(x,y,w,w,theta+HALF_PI,theta+3*HALF_PI,OPEN);
    } else if (type==8) {
      float aw = w*.18;
      float offx = 2.5*aw*cos(theta+HALF_PI);
      float offy = 2.5*aw*sin(theta+HALF_PI);
      for (int n=0;n<num;n++) {
        float ax = x + offx - n*aw*3.3*cos(theta);
        float ay = y + offy - n*aw*3.3*sin(theta);
        noStroke();
        fill(ghostStroke);
        ellipse(ax,ay,w*.3,w*.3);
        stroke(colorStroke);
        point(ax,ay);
      }
    } else if (type==9) {
      fill(0);
      for (int n=num/2-1;n>=0;n--) {
        float aw = w + n*8;
        stroke(ghostStroke);
        arc(x,y,aw,aw,theta-HALF_PI,theta+HALF_PI,OPEN);
        float ax = x + aw/2*cos(theta-HALF_PI);
        float ay = y + aw/2*sin(theta-HALF_PI);
        float bx = x + aw/2*cos(theta+HALF_PI);
        float by = y + aw/2*sin(theta+HALF_PI);
        stroke(colorStroke);
        point(ax,ay);
        point(bx,by);
      }
    } else if (type==10) {
      noFill();
      float aw = w*.5;
      float offx = aw*cos(theta);
      float offy = aw*sin(theta);
      for (int n=0;n<num/2;n++) {
        float ax = x - offx*n;
        float ay = y - offy*n;
        float bx = ax + aw*3*cos(theta-QUARTER_PI);
        float by = ay + aw*3*sin(theta-QUARTER_PI);
        float cx = ax + aw*3*cos(theta+QUARTER_PI);
        float cy = ay + aw*3*sin(theta+QUARTER_PI);
        stroke(ghostStroke);
        line(ax,ay,bx,by);
        line(ax,ay,cx,cy);
        stroke(colorStroke);
        point(bx,by);
        point(cx,cy);
        
      }
    } else if (type==11) {
      noFill();
      float ax = x + w/2*cos(theta+QUARTER_PI*sign);
      float ay = y + w/2*sin(theta+QUARTER_PI*sign);
      float bx = ax + w*cos(theta-QUARTER_PI*sign);
      float by = ay + w*sin(theta-QUARTER_PI*sign);
      stroke(ghostStroke);
      line(x,y,ax,ay);
      line(ax,ay,bx,by);
      stroke(colorStroke);
      point(ax,ay);
      point(bx,by);
    } else if (type==12) {
      stroke(ghostStroke);
      fill(0);
      pushMatrix();
      translate(x,y);
      rotate(theta);
      rectMode(CENTER);
      rect(0,0,w,w);
      popMatrix();
    } else if (type==13) {
      noStroke();
      fill(ghostStroke);
      pushMatrix();
      translate(x,y);
      rotate(theta);
      rectMode(CENTER);
      rect(0,0,w,w);
      popMatrix();
    } else if (type==14) {
      // TODO 
      
    } else if (type==15) {
      // TODO 
    } else {  
    }
    
  }  
  
  boolean isClear(color ec) {
    // check if free of obstruction
    if (type==2) {
      // double dots (one filled)
      float area = PI*pow(w/2,2);
      int samples = floor(area*.4);
      for (float i=0;i<=samples;i++) {
        float t = random(TWO_PI);
        float da = random(w/2);
        float db = random(w*.618/2);
        
        float off = (w+w*.618)/2;
        float nx = x + off*cos(theta);
        float ny = y + off*sin(theta);
        
        float fx = x + da*cos(t);
        float fy = y + da*sin(t);
        if (!bgClear(floor(fx),floor(fy),ec)) return false;
        
        float bx = nx + db*cos(t);
        float by = ny + db*sin(t);
        if (!bgClear(floor(bx),floor(by),ec)) return false;
      }
    } else if (type==3) {
      // tangential bar
      float ax = x + w*cos(theta+HALF_PI);
      float ay = y + w*sin(theta+HALF_PI);
      float bx = x + w*cos(theta-HALF_PI);
      float by = y + w*sin(theta-HALF_PI);
      if (!bgClear(floor(ax),floor(ay),ec)) return false;
      if (!bgClear(floor(bx),floor(by),ec)) return false;
    } else if (type==5) {
      // trailing sequential dots
      float aw = w;
      float d = 0;
      for (int n=0;n<num;n++) {
        float ax = x + d*cos(theta);
        float ay = y + d*sin(theta);
        
        for (int k=0;k<4;k++) {
          float t = random(TWO_PI);
          float dd = random(aw/2);
          float fx = ax + dd*cos(t);
          float fy = ay + dd*sin(t);
          if (!bgClear(floor(fx),floor(fy),ec)) return false;
        }
        
        aw*=.618;
        d+=w*1.21;
      }
    } else if (type==6) {
      // arrowhead pointer
      float ax = x + w*cos(theta+HALF_PI);
      float ay = y + w*sin(theta+HALF_PI);
      float bx = x + w*cos(theta-HALF_PI);
      float by = y + w*sin(theta-HALF_PI);
      float cx = x + w*cos(theta);
      float cy = y + w*sin(theta);
      if (!bgClear(floor(ax),floor(ay),ec)) return false;
      if (!bgClear(floor(bx),floor(by),ec)) return false;
      if (!bgClear(floor(cx),floor(cy),ec)) return false;
    } else if (type==8) {
      // sequential offset dots
      float aw = w*.18;
      float offx = 2.5*aw*cos(theta+HALF_PI);
      float offy = 2.5*aw*sin(theta+HALF_PI);
      for (int n=0;n<num;n++) {
        float ax = x + offx - n*aw*3.3*cos(theta);
        float ay = y + offy - n*aw*3.3*sin(theta);
        
        // montecarlo sampling of elliptical space
        for (int k=0;k<3;k++) {
          float t = random(TWO_PI);
          float dd = random(w*.15,w*.15);
          float fx = ax + dd*cos(t);
          float fy = ay + dd*sin(t);
          if (!bgClear(floor(fx),floor(fy),ec)) return false;
        }
      }
    } else if (type==9) {
      // nested arcs
      float aw = w + num*4;
      for (int k=0;k<5;k++) {
        float t = theta-HALF_PI+random(PI);
        float dd = random(aw/2);
        float fx = x + dd*cos(t);
        float fy = y + dd*sin(t);
        if (!bgClear(floor(fx),floor(fy),ec)) return false;
      }
    } else if (type==10) {
      // arrow feathers
      float aw = w*.5;
      float offx = aw*cos(theta);
      float offy = aw*sin(theta);
      for (int n=0;n<num/2;n++) {
        float ax = x - offx*n;
        float ay = y - offy*n;
        float bx = ax + aw*3*cos(theta-QUARTER_PI);
        float by = ay + aw*3*sin(theta-QUARTER_PI);
        float cx = ax + aw*3*cos(theta+QUARTER_PI);
        float cy = ay + aw*3*sin(theta+QUARTER_PI);
        if (!bgClear(floor(bx),floor(by),ec)) return false;
        if (!bgClear(floor(cx),floor(cy),ec)) return false;
      }
    } else if (type==11) {
      // jagged end
      float ax = x + w/2*cos(theta+QUARTER_PI);
      float ay = y + w/2*sin(theta+QUARTER_PI);
      float bx = ax + w*cos(theta-QUARTER_PI);
      float by = ay + w*sin(theta-QUARTER_PI);
      float cx = x + w/2*cos(theta-QUARTER_PI);
      float cy = y + w/2*sin(theta-QUARTER_PI);
      float dx = ax + w*cos(theta+QUARTER_PI);
      float dy = ay + w*sin(theta+QUARTER_PI);
      if (!bgClear(floor(ax),floor(ay),ec)) return false;
      if (!bgClear(floor(bx),floor(by),ec)) return false;
      if (!bgClear(floor(cx),floor(cy),ec)) return false;
      if (!bgClear(floor(dx),floor(dy),ec)) return false;
      
    } else {
      // test a general ellipse for all other end point types
      float area = PI*pow(w/2,2);
      int samples = floor(area*.2);
      for (float i=0;i<=samples;i++) {
        float t = random(TWO_PI);
        float d = random(w/2);
        float fx = x + d*cos(t);
        float fy = y + d*sin(t);
        if (!bgClear(floor(fx),floor(fy),ec)) return false;
      }
    }
            
    return true;
     
  }
  
  
}
