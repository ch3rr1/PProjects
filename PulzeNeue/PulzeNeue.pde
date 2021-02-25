import processing.serial.*;
import ddf.minim.*;

//sound

import beads.*; // import the beads library
AudioContext ac; // create our AudioContext
// declare our unit generators
WavePlayer modulator;
Glide modulatorFrequency;
WavePlayer carrier;
// our envelope and gain objects
Envelope gainEnvelope;
Gain synthGain;
// our delay objects
TapIn delayIn;
TapOut delayOut;
Gain delayGain;

//

// DECLARE VARIABLES
// *THIS VARIABLES CAN BE CHANGED

Serial myPort;            // USED TO LISTEN ON SIGNALS
int[] rate;               // USED TO STORE HEARTRATE DATA
int[] cali;               // USED TO HOLD BPM DATA FOR CALIBRATION
int IBI;                  // HOLDS INTERVALL BETWEEN BEATS
int BPM = 0;              // HOLDS BEATS PER MINUTE
boolean beat = false;     // USED TO DETECT A BEAT

Minim minim;
AudioSample kick;

PrintWriter writer;
BufferedReader reader;
String readValue;
//int highscore;

int c1 = 0;
int c2 = 0;
int c3 = 0;

PImage gameBackground;
PImage logo;
PImage logorad;
int screenWidth = 1280;   // SET SCREEN WIDTH
int gamestate = 3;        // WELCHER SCREEN FUER START
int score;                // HOLDS CURRENT SCORE
float x, y;               // HOLDS X AND Y COORDINATES
float speed = 1.5;        // SET GAME SPEED*
int o = 0;                // USED TO COUNT OBJECTS
int caliCount = 10;       // SET NUMBER OF BEATS TO CALIBRATE*
int test = 0;             // USED TO CORRECT GAMER POSITION
float multiplyer = 0;     // HOLDS VALUE TO MULTIPLY SCORE
int pulseMax = 160;       // SET MAX PULSE VALUE
float arg;
int fac = 2;
boolean reached = false;
int stopuhr = 0;
int hase = 0;

PFont myFont;

// BUTTONS
int bWidth = 650;
int bHeight = 150;
int bx = 699;
int by1 = 800;
int by2 = 1000;
int by3 = 1200;
int by4 = 805;
int by5 = 825;  // Buttons am Ende
int by6 = 1025;  // Buttons am Ende
PImage button1;
PImage button2;
PImage button3;


int xspacing = 16;   // How far apart should each horizontal location be spaced
int wW;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float amplitude = 75.0;  // Height of wave
float period = 50.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave


Gamer g;                          // HOLDS THE GAMER OBJECT
NewGamer g1;
ArrayList<Obstacle> obstacles;    // HOLDS LIST OF OBSTACLE OBJECTS
ArrayList<Challange> challanges;

// SETUP GAME DATA

void setup() {
  frameRate(32);
  size(2048, 1536);
  logo = loadImage("img/logo.png");
  logorad = loadImage("img/logorad.png");
  //textSize(28);
  //textAlign(CENTER);
  myFont = createFont("ADAM.CGPRO", 32);
  textFont(myFont);

  //sound
  ac = new AudioContext();
  /* Ausgangstonhöhe - Frequenzspektrum = mittlerer Parameter */
  modulatorFrequency = new Glide(ac, 20, 30);   
  modulator = new WavePlayer(ac, 
  modulatorFrequency, 
  Buffer.SINE);
  Function frequencyModulation = new Function(modulator)
  {
    public float calculate() {

      return BPM*1.5;                // Je höher Zahl desto Höher Ton - Ausgangsfreqeeqzuenz
    }
  };
  carrier = new WavePlayer(ac, 
  frequencyModulation, 
  Buffer.SINE);          
  gainEnvelope = new Envelope(ac, 0.0);
  synthGain = new Gain(ac, 1, gainEnvelope);
  synthGain.addInput(carrier);
  delayIn = new TapIn(ac, 2000);
  delayIn.addInput(synthGain);
  delayOut = new TapOut(ac, delayIn, 500.0);
  delayGain = new Gain(ac, 1, 0.50);
  delayGain.addInput(delayOut);
  ac.out.addInput(synthGain);
  ac.out.addInput(delayGain);
  ac.start();
  //soundende

  wW = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[wW/xspacing];

  minim = new Minim(this);
  kick = minim.loadSample("audio/kick.wav", 2048);

  // reader = createReader("highscore.txt");
  // getHighscore();

  rate = new int[150];
  for (int i=0; i<rate.length; i++) {
    rate[i] = height/2+500;
    //wert
  }

  gameBackground = loadImage("img/backbackback.jpg");


  g = new Gamer(50);
  g1 = new NewGamer();

  challanges = new ArrayList<Challange>();
  challanges.add(new Challange(130));
  //challanges.add(new Challange(140));

  cali = new int[10];

  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 115200);
  myPort.clear();
  myPort.bufferUntil('\n');
}

// LET'S PLAY

void draw() {

  // Startscreen
  if (gamestate == 0) {

    background(90, 90, 90);

    BPM = min(BPM, pulseMax);
    
  //  fill(190, 190, 190, 10);
  //  noStroke();
    fill(250, 42, 60, 0);           // Farbe von Buttons
    noStroke();
    rect(bx, by4, bWidth, bHeight);


    // Sound für Startscreen - Kick 
    if (beat) {
      if (caliCount > 0) {
        cali[abs(caliCount-10)] = BPM;
        caliCount--;
      }
      beat = false;
      kick.trigger();
    }

    noFill();
    strokeWeight(4);
    smooth();
    stroke(255);

    image(logorad, width/2-200, height/2-480);
    // image(logo, width/2-80, height/2-520);
    //ellipse(width/2, height/2, 120, 120);

    //pushMatrix();
   // translate(395, -300);
    //liniepuls
    rate[rate.length-1] = (height/2+500 - IBI/10);
    IBI = 0;

    stroke(255);
    if (caliCount  == 0) {
      for (int i = 0; i < 10; i++) {
        test += cali[i];
      }
      test /= 10;
      stroke(117, 185, 117);
      fill(255); 
      textAlign(CENTER);
      text("CLICK TO START!", width/2, 850);
    }

    strokeWeight(1);
    noFill();
    beginShape();
    for (int x = 1; x < rate.length-1; x++) {
      //koordinate 
      vertex(x+955, rate[x]);
    }
    endShape();

    for (int i = 1; i < rate.length-1; i++) {
      rate[i] = rate[i+1];
    }
  //  popMatrix();
    //text("Highscore: "+highscore, width/2, 100);
    fill(255);
    textAlign(CENTER);
    text("BPM: "+BPM, width/2, height-200);
  }

  // Ende Startbildschirm

  // Anfang Spiel 

  else if (gamestate == 1) {
    imageMode(CORNER);
    image(gameBackground, x, 0);
    x -= speed * 1.7;
    fill(c1, c2, c3, 127);
    rect(0,0,width,height);
    //hase = challanges.get(o).getChallange();
    arg = (height / (float(hase) - float(test)));

    BPM = min(BPM, 160);
    fill(255);
    textAlign(CENTER);
    if(!reached)
    text("TILL YOU REACH "+hase, width/2, height-100);
    /* Synthisound mit Beads library wird generiert */
    modulatorFrequency.setValue(BPM*3);

    gainEnvelope.addSegment(0.7, BPM*1);    // Linker Teil muss unter 1 bleiben, Rechts beliebig, je nach Frequenz
    gainEnvelope.addSegment(0.1, BPM*5);    // -- " -- 

    fill(255);
    textAlign(CENTER);
    text("BPM: "+BPM, width/2, 100);
    //textAlign(LEFT);
    //text("Score: "+score, 10, 38);

    g1.update();
    calcWave();
    renderWave();

    fill(255);
    if (reached == false && g1.getYPos() <= hase) {
      reached = true;
    }
    if (reached == true) {
      stopuhr++;
      println(stopuhr);
      textAlign(CENTER);
      text("time"+stopuhr, width/2, height-100);
      if (stopuhr >= 0 && stopuhr < 30)
        text("WELL DONE!", width/2, height/2);
        
      // text("points "+stopuhr, width/2, 100);
      else if
        (stopuhr >= 50 && stopuhr < 80)
        text("HOW FAST CAN YOU COME DOWN TO "+test+" BPM, WHERE YOU STARTED?", width/2, height/2);
      else if
        (stopuhr >= 100 && stopuhr < 120)
        text("DID YOU KNOW THAT....", width/2, height/2);
      else if
        (stopuhr >= 130 && stopuhr < 150)
        text("...The faster the heart rate drops after you stop exercising the healthier your heart is?", width/2, height/2);
    
      else if
        (stopuhr >= 170 && stopuhr < 200)
        text("the most important factor in heart rate reduction ", width/2, height/2);
         else if
        (stopuhr >= 210 && stopuhr < 230)
        text("is what happens during the first minute after you stop exercising.", width/2, height/2);
      else if
        (stopuhr >= 260 && stopuhr < 320)
        text("Once you stop your workout, your heart rate should drop by about 20 beats during the first minute.", width/2, height/2);  
      else if
        (stopuhr >= 350 && stopuhr < 420)
        text("This minute is gone now. What is your heartrate?", width/2, height/2); 
      else if 
        (stopuhr >= 450 && stopuhr < 480)
        text("TRY TO DECREASE YOUR HEARTRATE WITH EXERCISE AND LESS STRESS.", width/2, height/2);
              else if 
        (stopuhr >= 500 && stopuhr < 530)
        text("ANYWAS. YOU'RE DOING GREAT.", width/2, height/2);
    }
    if (reached == true && g1.getYPos() == height) {
      reached = false;
      gamestate = 2;
    }
    // println(o);

    fill(255);
    if(!reached)
    text("make your heart bounce", width/2, height-200);
    fill(255);
    /* Das ding hier spielt die Kick ab */
    if (beat) {
      beat = false;
      kick.trigger();
    }
  }


  // Ende vom Spiel 

  // Anfang Endebildschirm
  else if (gamestate == 2) {
    fill(255);
    background(90, 90, 90);
    textAlign(CENTER);
    text("TRY AGAIN?", width/2, 100);
    text("YES", width/2, height-640);
    text("NO!", width/2, height-420);
  
    fill(190, 190, 190, 20);           // Farbe von Buttons
    noStroke();
    rect(bx, by5, bWidth, bHeight);   // Button 5 
    rect(bx, by6, bWidth, bHeight);   // button 6
  }
  else if (gamestate == 3) {
    resetAllTheStuff();
    fill(255);
    textAlign(CENTER);
    background(86, 86, 86);

    text("LAZY", width/2, 880);
    text("ACTIVE", width/2, 1090);
    text("FANATIC", width/2, 1290);
    

    image(logorad, width/2-200, height/2-480);
    
        fill(190, 190, 190, 20);
    noStroke();
    rect(bx, by1, bWidth, bHeight);
    rect(bx, by2, bWidth, bHeight);
    rect(bx, by3, bWidth, bHeight);
        //image(imageName1, bx1, by, bWidth, bHeight);
    //image(imageName2, bx2, by, bWidth, bHeight);
    //image(imageName3, bx3, by, bWidth, bHeight);
  }

  /* MUTED SYNTHI - mit Beads library wird generiert - hier mit "0" gemuted */

  modulatorFrequency.setValue(0);

  gainEnvelope.addSegment(0.0, 0);    // Linker Teil muss unter 1 bleiben, Rechts beliebig, je nach Frequenz


  /* Das ding hier spielt die Kick ab */
  if (beat) {
    beat = false;
    kick.trigger();
  }
}
//}

// CLEAR RAM

void stop() {
  kick.close();
  minim.stop();

  super.stop();
}

