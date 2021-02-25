import processing.serial.*;
import themidibus.*;
import javax.sound.midi.MidiMessage;
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;
import java.util.Date;

// constants
int CHANNEL = 8;
int FIELDS = 9;
int STEPS = 3860;
int ROUND = 1;

// objects and variables
Serial port;
String data;
boolean firstContact;
Sensor sensor;
Motor motor;
int currentY;
int position;
float target;
boolean active;
MidiBus midi;
boolean[] fieldsVisited;
Date d;

void setup() {
  // frame size
  size(600,600);
  // init communication
  firstContact = false;
  // printArray(Serial.list());
  port = new Serial(this, Serial.list()[3], 9600);
  port.bufferUntil('\n');
  // init sensor
  sensor = new Sensor;
  // init motor
  motor = new Motor();
  // init position
  target = 0.0;
  currentY = 0;
  position = 0;
  active = false;
  // init midi
  midi.list();
  midi = new MidiBus(this, "IAC MIDI", "IAC MIDI");
  // init fields array
  fieldsVisited = new boolean[FIELDS];
  for(int i = 0; i < fieldsVisited.length; i++) {
    fieldsVisited[i] = false;
  }
  // init timestamp
  d = new Date();
}

void draw() {
  // draw the grid
  line(0, 200, 600, 200);
  line(0, 400, 600, 400);
  stroke(204, 102, 0);
  line(0, 300, 600, 300);
  stroke(0);
  line(200, 600, 200, 0);
  line(400, 600, 400, 0);
  // kinect
  sensor.trackUser();
  println(getPosition());
  // get mouse position and set as target
  if(mousePressed) {
    if(mouseY != currentY) {
      currentY = mouseY;
      target = currentY * 6.433;
      active = true;
    }
  }
  // play sound depending on field
  // playSoundFile(determineField(getXPosition(), getYPosition()));
}

// communication
void serialEvent(Serial port) {
  long currentTime = d.getTime() / 1000;
  data = port.readStringUntil('\n');
  if(data != null) {
    data = trim(data);
    if(firstContact == false) {
      if(data.equals("A")) {
        port.clear();
        firstContact = true;
        port.write("A");
        println("Connection established.");
      }
    } else {
      if(!data.equals("A") && active == true) {
        motor.runTo(data);
        println("Target: " + (int)target + " Arduino: " + position);
      }
      port.write("A");
    }
  }
}

// position
float getXPosition() {
  float x = mouseX;
  return x;
}

float getYPosition() {
  float y = mouseY;
  return y;
}

void printPosition() {
  println("X: " + getXPosition() + " " + "Y: " + getYPosition());
  for(int i = 0; i < fieldsVisited.length; i++) {
    if(fieldsVisited[i] == true) {
      println("Sound: #" + (i + 1));
    }
  }
}

int determineField(float x, float y) {
  int field;
  if(x == 0 && y == 0) {
    field = 0;
  } else if(x <= 200 && y <= 200) {
    field = 1;
  } else if(x <= 200 && y <= 400) {
    field = 2;
  } else if(x <= 200 && y <= 600) {
    field = 3;
  } else if(x <= 400 && y <= 200) {
    field = 4;
  } else if(x <= 400 && y <= 400) {
    field = 5;
  } else if(x <= 400 && y <= 600) {
    field = 6;
  } else if(x <= 600 && y <= 200) {
    field = 7;
  } else if(x <= 600 && y <= 400) {
    field = 8;
  } else if(x <= 600 && y <= 600) {
    field = 9;
  } else {
    field = -1;
  }
  return field;
}

// sound
void playSoundFile(int field) {
  for(int i = 1; i <= FIELDS; i++) {
    if(i == field) {
      if(!fieldsVisited[i-1]) {
        // midi.sendControllerChange(CHANNEL, 69 + i, 127);
        fieldsVisited[i-1] = true;
      }
    } else {
      if(fieldsVisited[i-1] == true) {
        // midi.sendControllerChange(CHANNEL, 69 + i, 0);
        fieldsVisited[i-1] = false;
      }
    }
  }
}