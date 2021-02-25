abstract class Obstacle {
  float x, y;
  boolean stat;
  float triggerPoint = 800;
  boolean moveLeft = true;
  float counter = 300;

  Obstacle(float x, float y, boolean stat) {
    this.x = x;
    this.y = y;
    this.stat = stat;
  }
  
  abstract void display();
  abstract int getType();
  abstract int getRadius();
  abstract int getWidth();
  abstract int getHeight();
  abstract boolean getScaleBar();

  void move() {
    x -= speed;
  }
  void trigger() {
    if(x < triggerPoint && y > height - this.getHeight()) {
      y -= speed*2;
    }
    x -= speed;
  }
  void slideIn() {
    if(x < triggerPoint && counter > 1) {
      if(moveLeft) {
        x -= speed*7;
        if(int(x) <= int(counter)) {
          moveLeft = false;
          counter += counter * 0.5;
        }
      }
      if(!moveLeft) {
        x += speed*7;
        if(int(x) >= int(counter)) {
          moveLeft = true;
          counter = counter * 0.5;
        }
      }
    } else {
      x -= speed;
    }
  }
  float getXPos() {
    return x;
  }
  float getYPos() {
    return y;
  }
  boolean getStat() {
    return stat;
  }
}
