class Circle extends Obstacle {
	int type;
	int r;
	Circle(float x, float y, int r, boolean stat) {
		super(x, y, stat);
		this.r = r;
		this.type = 0;
	}
	void display() {
	    if(stat)
	      fill(255, 51, 51);
	    else
	      fill(102, 255, 102);
	     
	    noStroke();
	    ellipse(x, y, r, r);
  	}
  	int getRadius() {
    	return r/2;
 	}
 	int getWidth() {
    	return r;
  	}
  	int getHeight() {
    	return r;
  	}
  	int getType() {
  		return type;
  	}
  	boolean getScaleBar() {
  		return false;
  	}
}
