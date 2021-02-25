class Rect extends Obstacle {
	int type;
	int w, h;
	boolean scaleBar;
	Rect(float x, float y, int w, int h, boolean stat) {
		super(x, y, stat);
		this.w = w;
		this.h = h;
		this.type = 1;
	}
	void display() {
	    if(stat) {
	    	this.scaleBar = true;
	    	fill(64, 64, 64, 127);
	    	rect(x+10, 0, 10, height);
	    	fill(255, 51, 51);
	    }
	    else {
	    	this.scaleBar = false;
	    	fill(102, 255, 102);
	    }
	    
	    noStroke();
	    rect(x, y, w, h);
  	}
  	int getType() {
  		return type;
  	}
  	int getRadius() {
  		return 0;
  	}
  	int getWidth() {
  		return w;
  	}
  	int getHeight() {
  		return h;
  	}
  	boolean getScaleBar() {
  		return scaleBar;
  	}
}
