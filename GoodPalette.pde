class GoodPalette {
  color[] goodcolor;
  int numpal = 0;
  int maxpal;
  
  GoodPalette(int maxPaletteColors) {
    maxpal = maxPaletteColors;
  }

  void readXML(String filename, int max) {
    // read color data from CorelDRAW exported color palette XML file
    XML xml;
    print("Reading "+filename+"...");
    
    xml = loadXML(filename);
    XML colors = xml.getChild("colors");
    XML page = colors.getChild("page");
    XML[] val = page.getChildren("color");
    
    // each val entry looks like this:
    // <color cs="RGB" name="R236 G234 B234" tints="0.92549,0.917647,0.917647"/>
    
    int limit = min(val.length,max);
    goodcolor = new color[maxpal];
    for (int i=0;i<limit;i++) {
      float[] tints = float(split(val[i].getString("tints"),",")); 
      goodcolor[i] = color(256*tints[0],256*tints[1],256*tints[2]);
      numpal++;
    }
    println("done "+limit+" colors discovered");
    
  }    
  
  boolean colorExists(color c) {
    // check if color exist in the palette already
    for (int n=0;n<numpal;n++) {
      if (c==goodcolor[n]) {
        return true;
      }
    }
    return false;
  }
  
  void readBitmap(String fn) {
    // read color data from the pixel values of a bitmap PNG JPG BMP GIF 
    PImage b;
    print("Reading "+fn+"...");
    b = loadImage(fn);
    imageMode(CORNER);
    image(b,0,0);
    
    // assume maximum number of colors will be found
    goodcolor = new color[maxpal];
  
    for (int x=0;x<b.width;x++){
      for (int y=0;y<b.height;y++) {
        color c = get(x,y);
        if (!colorExists(c)) {
          // add color to pal
          if (numpal<maxpal) {
            goodcolor[numpal] = c;
            numpal++;
            if (numpal>=maxpal) return;
          }
        }
      }
    }
    println("done "+numpal+" colors discovered");
    
    //showcolor();
  }
  
  void pumpBlack(int val) {
    // pump black in
    for (int n=0;n<val;n++) {
      if (numpal<maxpal-2) {
        goodcolor[numpal]=#000000;
        numpal++;
      }
    }
  }
  
  void pumpWhite(int val) {
    // pump black in
    for (int n=0;n<val;n++) {
      if (numpal<maxpal-2) {
        goodcolor[numpal]=#FFFFFF;
        numpal++;
      }
    }
  }
  
  color somecolor() {
    // pick some random good color
    return goodcolor[int(random(numpal))];
  }
  
  void show() {
    // render all the colors to the screen
    println("num colors:"+numpal);
    // list all colors
    float spc = (1.0*width)/numpal;
    for (int n=0;n<numpal;n++) {
      stroke(0);
      fill(goodcolor[n]);
      rect(spc*n,0,spc,height);
    }
    
  }  
  

}
