// import processing.serial.*;

public class Motor {
  int LACE_LENGTH = 200;
  
  int currentPosition;
  boolean isActive;
  
  public Motor() {
    this.currentPosition = 0;
    this.isActive = true;
  }
  
  void goTo(int newPosition) {
    if(currentPosition < newPosition) {
      while(currentPosition != newPosition) {
        currentPosition++;
        // println("Position: " + currentPosition);
        // needs a for loop
      }
    } else if(currentPosition > newPosition) {
      while(currentPosition != newPosition) {
        currentPosition--;
        // println("Position: " + currentPosition);
        // needs a for loop
      }
    } else {
      println("Position: " + currentPosition);
    }
  }
  
  void setActive(boolean status) {
    this.isActive = status;
  }

  void rotate(Serial port) {
    port.write("something");
  }
}