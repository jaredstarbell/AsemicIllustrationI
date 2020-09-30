// Asemic Illustration I 
//   Inspired by the work of Gwen Jarr
//   Jared S Tarbell
//   September 13, 2020
//   The Treehouse, Orcas Island, WA

PGraphics bg;
PGraphics spg;

ArrayList<PointSource> psources = new ArrayList<PointSource>();
ArrayList<Chord> chords = new ArrayList<Chord>();
ArrayList<Orbit> orbits = new ArrayList<Orbit>();
ArrayList<PointEnd> pends = new ArrayList<PointEnd>();
ArrayList<Radiant> radiants = new ArrayList<Radiant>();
ArrayList<Star> stars = new ArrayList<Star>();

int orbDim = 10;
PImage[] orbs = new PImage[orbDim*2];

color colorClear;
color colorStroke;
color ghostStroke;
color lightStroke;
color halfStroke;

boolean showBg = false;
boolean expand = true;
boolean allowOutBounds = false;
boolean blend = false;

float minEndw = 4;
float maxEndw = 8;

int snumOrbits = 1000000000;   // max int
int snumPointEnds = 1000000000;

GoodPalette pal;

void setup() {
  //size(1000,1000,FX2D);
  fullScreen(FX2D);
  background(0);
  noFill();
  strokeWeight(2.0);
  
  pal = new GoodPalette(512);
  //pal.readXML("jacksonFloor.xml",256);
  pal.readXML("jacksonConvergence.xml",256);
  //pal.readXML("jacksonRBD.xml",256);
  //pal.readXML("jacksonRed.xml",256);
  //pal.readXML("jacksonWar.xml",256);
  //pal.readXML("jacksonWhiteLight.xml",256);
  pal.pumpBlack(48);
  pal.pumpWhite(24);
  
  colorClear = color(255,32);
  colorStroke = color(255,173);
  ghostStroke = color(255,64);
  lightStroke = color(255,42);
  halfStroke = color(255,22);
  
  buildOrbs();
  imageMode(CENTER);
  
  reset();
}

void reset() {
  background(0);
  
  expand = true;
  
  psources.clear();
  chords.clear();
  orbits.clear();
  pends.clear();
  radiants.clear();
  stars.clear();
  showBg = false;
  

  // initialize background image to hold reserved space for objects
  bg = createGraphics(width,height);
  bg.noSmooth();
  bg.beginDraw();
  bg.clear();
  bg.noFill();
  bg.strokeWeight(10);      // the fatter the bg stroke weight, the more padding each drawn element is given
  bg.endDraw();
  
  spg = createGraphics(width,height);
  spg.beginDraw();
  spg.strokeWeight(2.0);
  spg.endDraw();
  
  snumOrbits = 1000000000;   // max int
  snumPointEnds = 1000000000;

  
  // single distribution
  float px = width/2;
  float py = height/2;
  float pw = random(minEndw,maxEndw);
  PointSource ps = new PointSource(px,py,pw);
  ps.renderGhost();
  ps.renderBackground();
  psources.add(ps);
  
  /*  
  // random distribution
  for (int k=0;k<11;k++) {
    // create initial source point
    float px = random(width*.1,width*.9);
    float py = random(height*.1,height*.9);
    float pw = random(minEndw,maxEndw);
    PointSource ps = new PointSource(px,py,pw);
    ps.renderGhost();
    ps.renderBackground();
    psources.add(ps);
  }
  */
  
  /*
  // grid distribution
  int cols = 3;
  int rows = 1;
  float cw = width/cols;
  float rw = height/rows;
  for (int xx=0;xx<cols;xx++) {
    for (int yy=0;yy<rows;yy++) {
      float px = cw/2 + cw*xx;
      float py = rw/2 + rw*yy;
      float pw = random(minEndw,maxEndw);
      PointSource ps = new PointSource(px,py,pw);
      ps.renderGhost();
      ps.renderBackground();
      psources.add(ps);
    }
  }
  */
  
  /*
  // ring distribution
  int num = 11;
  float radius = height*.5;
  float omega = TWO_PI/num;
  for (int n=0;n<num;n++) {
    float px = width/2 + radius*cos(omega*n-HALF_PI);
    float py = height/2 + radius*sin(omega*n-HALF_PI);
    float pw = random(minEndw,maxEndw);
    PointSource ps = new PointSource(px,py,pw);
    ps.renderGhost();
    ps.renderBackground();
    psources.add(ps);
  }
  */
}

void draw() {
    
  if (expand) substitute();

  spg.beginDraw();
  int kmax = 1;
  if (!expand) kmax = 10;    // if not expanding, render sand painters faster
  for (int k=0;k<kmax;k++) {
    if (snumOrbits<orbits.size()) {
      orbits.get(snumOrbits).renderSP();
      snumOrbits++;
    }
    if (snumPointEnds<pends.size()) {
      pends.get(snumPointEnds).renderSP();
      snumPointEnds++;
    }
  }
  spg.endDraw();
  
  // color brightness oscillates as eons go
  colorStroke = color(255,random(222,255));
}

// load the orb sprite sheet and convert into images
void buildOrbs() {
  PImage orbSheet = loadImage("10x1orbs.png");
  int w = 200;
  int h = 200;
  for (int x=0;x<orbDim/2;x++) {
    int xx = x*w;
    orbs[x] = orbSheet.get(xx,0,w,h);
  }
}

void renderAll() {
  for (Chord chd:chords) chd.render();
  for (Orbit orb:orbits) orb.render();
  for (Radiant rad:radiants) rad.render();
  for (PointEnd pe:pends) pe.render();
  for (PointSource ps:psources) ps.render();
}

void renderGhost() {
  for (Chord chd:chords) chd.renderGhost();
  for (Orbit orb:orbits) orb.renderGhost();
  for (Radiant rad:radiants) rad.renderGhost();
  for (PointEnd pe:pends) pe.renderGhost();
  for (PointSource ps:psources) ps.renderGhost();
}  

void renderGhost(float ratio) {
  for (int i=0;i<chords.size();i++) if (random(1)<ratio) chords.get(i).renderGhost();
  for (int i=0;i<orbits.size();i++) if (random(1)<ratio) orbits.get(i).renderGhost();
  for (int i=0;i<radiants.size();i++) if (random(1)<ratio) radiants.get(i).renderGhost();
  for (int i=0;i<pends.size();i++) if (random(1)<ratio) pends.get(i).renderGhost();
  for (int i=0;i<psources.size();i++) if (random(1)<ratio) psources.get(i).renderGhost(); 
}

PointSource getRandomPointSource() {
  if (psources.size()==0) return null;
  int i = floor(random(psources.size()));
  return psources.get(i);
}

PointEnd getRandomPointEnd() {
  if (pends.size()==0) return null;
  int i = floor(random(pends.size()));
  return pends.get(i);
}

Orbit getRandomOrbit() {
  if (orbits.size()==0) return null;
  int i = floor(random(orbits.size()));
  return orbits.get(i);
}

Orbit getRecentOrbit() {
  if (orbits.size()==0) return null;
  return orbits.get(orbits.size()-1);
}

Radiant getRandomRadiant() {
  if (radiants.size()==0) return null;
  int i = floor(random(radiants.size()));
  return radiants.get(i);
}

Chord getRandomChord() {
  if (chords.size()==0) return null;
  int i = floor(random(chords.size()));
  return chords.get(i);
}

void substitute() {
  // pick an orbit
  //Orbit orb = getRandomOrbit();
  Orbit orb = getRecentOrbit();
  substituteOrbit(orb);

  // pick a radiant
  Radiant rdt = getRandomRadiant();
  substituteRadiant(rdt);
  
  if (random(100)<40) {
    // pick a source point
    PointSource ps = getRandomPointSource();
    substitutePointSource(ps);
  }
  
    
}

void substitutePointSource(PointSource ps) {
  if (ps==null) return;
  // add an orbit
  //float r = random(ps.w*2,ps.w*100);
  float r = ps.lastr;
  float maxTheta = map(r,0,width/2,TWO_PI,0);
  float st = random(TWO_PI);
  float et = st + random(maxTheta);
  ps.incrementLastRadius();
  Orbit orb = new Orbit(ps,st,et,r);
  if (orb.isClear(ps.idc)) {
    
    orb.renderGhost();
    orb.renderBackground();
    orbits.add(orb);
    
    // add end points
    float pw0 = random(minEndw,maxEndw);
    int et0 = floor(random(16));
    PointEnd pe0 = new PointEnd(orb,orb.ax,orb.ay,pw0,st-HALF_PI,et0);
    if (pe0.isClear(orb.idc)) {
      pe0.renderGhost();
      pe0.renderBackground();
      pends.add(pe0);
    }
    float pw1 = random(minEndw,maxEndw);
    int et1 = floor(random(16));
    PointEnd pe1 = new PointEnd(orb,orb.bx,orb.by,pw1,et+HALF_PI,et1);
    if (pe1.isClear(orb.idc)) {
      pe1.renderGhost();
      pe1.renderBackground();
      pends.add(pe1);
    }
    
  }
}

void substituteOrbit(Orbit orb) {
  if (orb==null) return;
  
  if (random(100)<30) {
    // create a single radiant somewhere
    int attempts = 5;
    float ot = random(orb.startTheta,orb.endTheta);
    float od = random(10,attempts*100);
    while (attempts>0) {
      Radiant rdt = new Radiant(orb.ps,orb.r,orb.r+od,ot);
      if (rdt.isClear(orb.idc)) {
        rdt.renderGhost();
        rdt.renderBackground();
        radiants.add(rdt);
        
        float pw = random(minEndw,maxEndw);
        int et0 = floor(random(16));
        PointEnd pe = new PointEnd(orb,rdt.bx,rdt.by,pw,ot,et0);
        if (pe.isClear(rdt.idc)) {
          pe.renderGhost();
          pe.renderBackground();
          pends.add(pe);
        }
        return;    // an orbit has been successfully substituted
      } else {
        // find the blocking point
        float block = rdt.endClear(orb.idc);
        if (block<10) return;
        od = random(10,block);
      }
      attempts--;
    }
  } else {
    // create an array of radiants somewhere
    float ot = random(orb.startTheta,orb.endTheta);
    float od = random(10,100);
    float minSpacing = 10;
    int max = floor((orb.endTheta-ot)/atan(minSpacing/orb.r));
    int num = ceil(random(1,max));
    for (int tt=0;tt<num;tt++) {
      Radiant rdt = new Radiant(orb.ps,orb.r,orb.r+od,ot);
      if (rdt.isClear(orb.idc)) {
        rdt.renderGhost();
        rdt.renderBackground();
        radiants.add(rdt);
      } else {
        // find the blocking point
        float block = rdt.endClear(orb.idc);
        if (block<10) return;
        od = block;
        rdt = new Radiant(orb.ps,orb.r,orb.r+od,ot); 
        rdt.renderGhost();
        rdt.renderBackground();
        
        radiants.add(rdt);
      }
        
      float pw = random(minEndw,maxEndw);
      int et0 = floor(random(16));
      PointEnd pe = new PointEnd(orb,rdt.bx,rdt.by,pw,ot,et0);
      if (pe.isClear(rdt.idc)) {
        pe.renderGhost();
        pe.renderBackground();
        
        pends.add(pe);
      }
      
      ot+=atan(minSpacing/orb.r);
      od = random(10,100);
      
    }
  }    
 
}

void substituteRadiant(Radiant rdt) {
  if (rdt==null) return;
  int attempts = 5;
  
  // create an orbit
  PointSource ps = rdt.ps;
  while (attempts>0) {
    // pick a point on the radiant to branch out from
    float dd = random(rdt.ind,rdt.outd);
    // pick a random angle relative to starting radiant angle
    float omega0 = rdt.theta;
    float omega1 = rdt.theta + attempts*.1*random(-HALF_PI,HALF_PI);
 
    // make sure omega0 is always smaller than omega1
    if (omega1<omega0) {
      float temp = omega0;
      omega0 = omega1;
      omega1 = temp;
    }
    
    Orbit orb = new Orbit(ps,omega0,omega1,dd);
    if (orb.isClear(rdt.idc)) {
      orb.renderGhost();
      orb.renderBackground();
      orbits.add(orb);
      
      float pw0 = random(minEndw,maxEndw);
      int et0 = floor(random(16));
      PointEnd pe0 = new PointEnd(orb,orb.bx,orb.by,pw0,omega1+HALF_PI,et0);
      if (pe0.isClear(orb.idc)) {
        pe0.renderGhost();
        pe0.renderBackground();
        pends.add(pe0);
      }
      float pw1 = random(minEndw,maxEndw);
      int et1 = floor(random(16));
      PointEnd pe1 = new PointEnd(orb,orb.ax,orb.ay,pw1,omega0-HALF_PI,et1);
      if (pe1.isClear(orb.idc)) {
        pe1.renderGhost();
        pe1.renderBackground();
        pends.add(pe1);
      }
          
    }
    attempts--;
  }
   
  
}

void substitutePointEnd(PointEnd pe) {
  if (pe==null) return;
  
}

void substituteChord(Chord chd) {
  if (chd==null) return;
  
}

boolean bgClear(int x, int y, color exception) {
  // bound check
  if (x<0 || y<0 || x>=bg.width || y>=bg.height) return allowOutBounds;
  // sample color at location
  color c = bg.get(x,y);
  if (c==exception) return true; 
  if (brightness(c)<128) return true;
  // something is here
  return false;
}

void dline(float ax, float ay, float bx, float by, float ratio) {
  float d = dist(ax,ay,bx,by);
  for (int i=0;i<d*ratio;i++) {
    float fx = ax + i/(d*ratio)*(bx-ax);
    float fy = ay + i/(d*ratio)*(by-ay);
    point(fx,fy);
  }
}

void makeStars() {
  for (int i=0;i<10;i++) {
    float sx = random(width);
    float sy = random(height);
    float sw = 5-50*log(random(1.0));
    // pick a random endpoint
    if (pends.size()>0) {
      PointEnd pe = pends.get(floor(random(pends.size())));
      sx = pe.x;
      sy = pe.y;
    }
    Star s = new Star(sx,sy,sw);
    stars.add(s);
  }
}

void renderStars() {
  for (Star s:stars) {
    s.render();
    s.renderConnections();
    
  }
}
  

void connectStars() {
  if (stars.size()==0) return;  // nothing to do
  for (int i=0;i<stars.size()-1;i++) {
    float mind = 200;    // set initially to maximum connection distance
    Star c = null;       // closest star
    Star a = stars.get(i);
    for (int j=i+1;j<stars.size();j++) {
      Star b = stars.get(j);
      if (!a.connectedTo(b)) {
        float d = dist(a.x,a.y,b.x,b.y);
        if (d<mind) {
          // new closest star found
          mind = d;
          c = b;
        }
      }
    }
  
    if (c!=null) {
      a.connectTo(c);
      c.connectTo(a);
    }
  }
  
}

void disconnectStars() {
  for (Star s:stars) {
    s.cons = new ArrayList<Star>();
  }
}


void keyPressed() {
  int mult = 50;
  if (key==' ') {
    reset(); 
  }
  if (key=='b' || key=='B') {
    showBg=!showBg;
    if (showBg) {
      imageMode(CORNER);
      image(bg,0,0);
    } else {
      background(0);
      renderGhost();
      renderStars();
    }
  }
  if (key=='o' || key=='O') {
    for (int k=0;k<mult;k++) {
      // pick an orbit
      Orbit orb = getRandomOrbit();
      substituteOrbit(orb);
    }
  }
  if (key=='r' || key=='R') {
    for (int k=0;k<mult;k++) {
      // pick a radiant
      Radiant rdt = getRandomRadiant();
      substituteRadiant(rdt);
    }
  }
  if (key=='s' || key=='S') {
    for (int k=0;k<mult;k++) {
      // pick a source point
      PointSource ps = getRandomPointSource();
      substitutePointSource(ps);
    }
  }
  
  if (key=='p' || key=='P') {
    for (int k=0;k<1;k++) {
      // create a new point source
      float px = random(width);
      float py = random(height);
      float pw = random(minEndw,maxEndw);
      PointSource ps = new PointSource(px,py,pw);
      if (ps.isClear(0)) {
        ps.renderGhost();
        ps.renderBackground();
        psources.add(ps);
      }
    }
  }
  if (key=='d' || key=='D') {
    if (pends.size()<2) return;
    for (int k=0;k<mult;k++) {
      // create some chords between nearby end points
      int i = floor(random(pends.size()));
      PointEnd pea = pends.get(i);
      float mind = 200;    // maximum distance of chord
      PointEnd peclose = null;
      for (int n=0;n<pends.size();n+=floor(1+random(5))) {
        if (i!=n) {
          PointEnd peb = pends.get(n);
          float d = dist(pea.x,pea.y,peb.x,peb.y);
          if (d<mind) {
            mind = d;
            peclose = peb;
          }
        }
      }
      
      if (peclose!=null) {
        // make a chord between these two end points
        Chord chd = new Chord(pea.x,pea.y,peclose.x,peclose.y);
        chd.renderGhost();
        chords.add(chd);
        
        // re-render the end points
        pea.renderGhost();
        peclose.renderGhost();
      }
    }
  }
  if (key=='z' || key=='Z') {
    // render all the sand painters
    snumOrbits = 0;
    snumPointEnds = 0;
  }
  if (key=='a' || key=='A') {
    // stop rendering sand painters
    snumOrbits = 1000000000;   // max int
    snumPointEnds = 1000000000;
  }
  if (key=='e' || key=='E') {
    // toggle expansion on and off
    expand=!expand;
  }
  if (key=='x' || key=='X') {
    // redraw all objects
    renderGhost();
  }
  if (key=='c' || key=='C') {
    // redraw some of the objects
    renderGhost(.1);
  }
  if (key=='m' || key=='M') {
    // toggle blend mode
    blend=!blend;
    if (blend) blendMode(SCREEN);
    if (!blend) blendMode(BLEND);
  }
  if (key=='y' || key=='Y') {
    makeStars();
  }
  if (key=='u' || key=='U') {
    connectStars();
  }
  if (key=='i' || key=='I') {
    disconnectStars();
  }
  if (key=='n' || key=='N') {
    imageMode(CORNER);
    image(spg,0,0);
  }

}

  
  
