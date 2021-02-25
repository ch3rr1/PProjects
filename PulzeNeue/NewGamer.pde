class NewGamer {
  int w;
  int h;
  
  float yG;
  float easing = 0.05;

  NewGamer() {
    this.w = width;
    this.h = height*2;
  }
  void update() {
    fill(255,255,255,40);
    noStroke();
    float targetY = this.getYPos();
    float dy = targetY - yG;
    if(abs(dy) > 1) {
      yG += dy * easing;
    }
  rect(0, yG, w, h);
    // ellipse(30, yG, w, h);
        //ellipse(30, -yG, w, h);
   //ellipse(2028, -yG, w, h);
    //ellipse(100, ((height-(h/2))-BPM*int(arg))+test*int(arg), w, h);
      //  ellipse(2028, ((height-(h/2))+BPM*int(arg))-test*int(arg), w, h);
           //ellipse(2028, -yG, w, h);
    //ellipse(100, ((height+(h/2))-BPM*int(arg))+test*int(arg), w, h);
           // ellipse(2028, yG, w, h);
  }
  int getYPos() {
    if(BPM <= test) {
      return height;
    } else {
      return height-(BPM*(int)arg)+test*(int)arg;
    }
  }
  int getType() {
    return 0;
  }
}
