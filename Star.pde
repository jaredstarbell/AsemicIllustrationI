class Star {
 
  float x, y;
  float w;
  
  ArrayList<Star> cons = new ArrayList<Star>();
  
  Star(float _x, float _y, float _w) {
    x = _x;
    y = _y;
    w = _w;
    render();
  }
  
  void render() {
    imageMode(CENTER);
    image(orbs[0],x,y,w,w);
  }
  
  void renderConnections() {
    stroke(halfStroke);
    for (int i=0;i<cons.size();i++) {
      Star b = cons.get(i);
      line(x,y,b.x,b.y);
    }
  }
  
  void connectTo(Star b) {
    cons.add(b);
    stroke(halfStroke);
    line(x,y,b.x,b.y);
  }
  
  boolean connectedTo(Star b) {
    // return true if connected to this star
    for (Star c:cons) if (c==b) return true;
    return false;
  }
  
}
