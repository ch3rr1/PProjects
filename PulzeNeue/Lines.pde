class Line extends Obstacle {
	int type;
	float x2, y2;
	Line(float x, float y, float x2, float y2, boolean stat) {
		super(x, y, stat);
		this.x2 = x2;
		this.y2 = y2;
		this.type = 2;
	}
	void display() {
	    if(stat)
	      stroke(255, 51, 51);
	    else
	      stroke(102, 255, 102);
	      
	    line(x, y, x2, y2);
  	}
  	void move() {
  		x -= speed;
  		x2 -= speed;
  	}
  	int getType() {
  		return type;
  	}
  	int getRadius() {
  		return 0;
  	}
  	int getWidth() {
  		return int(x2 - x);
  	}
  	int getHeight() {
  		return 0;
  	}
    boolean getScaleBar() {
      return false;
    }
}
