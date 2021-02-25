class Gamer {
  int r;
  PImage gamer = loadImage("img/gamer.png");
  
  Gamer(int r) {
    this.r = r;
  }
  void update() {
    fill(255, 51, 255, 0);
    noStroke();
    ellipse(100, ((height-(r/2))-BPM*int(arg))+test*int(arg), r, r);
    imageMode(CENTER);
    image(gamer, 100, g.getYPos(), r, r);
  }
  int getXPos() {
    return 100;
  }
  int getYPos() {
    if(BPM < test) {
      return (height-(r/2));
    } else {
      return ((height-(r/2))-BPM*int(arg))+test*int(arg);
    }
  }
  int getRadius() {
    return r/2;
  }
}

// height = (pulseMax - test) * x
// x = (pulseMax - test) / height
