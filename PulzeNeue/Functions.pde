//  if(key == 'z') {
//    gamestate = 0;
//  }
//    if(key == 'd') {
//    gamestate = 1;
//  }
//    if(key == 'e') {
//    gamestate = 3;
//  }
//  //  void mousePressed() {
// // if(mousePressed == true) {
//   // gamestate = 1;
//  //}
// 
//}


void keyPressed() {
if(key == 'a') {
gamestate = 0; // Kalibrieren Bildschirm
}
if(key == 's') {
gamestate = 1; // Spielscreen
}
if(key == 'd') {
gamestate = 2; // Ende des Spiels - Ergebnis
}
if(key == 'f') {
gamestate = 3; // Anfang Auswahlbildschirm mit 3 Buttons
}
if(key == 'e') {
gamestate = 4; // Gamestate 4 - noch leer
}
}


void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.4*((float)BPM/500);

  // For every x value, calculate a y value with sine function
  float xX = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(xX)*BPM*5.3;
    xX+=dx;
  }
}

void renderWave() {
  noStroke();
  // A simple way to draw the wave with an ellipse at each location
  for (int xX = 0; xX < yvalues.length; xX++) {
    //fill(BPM, random(255), random(255));
    //    fill(BPM, random(255), random(255));
    fill(c1, c2, c3);
    ellipse(xX*xspacing, height/2+yvalues[xX], 16, 16);
   // rect(xX*xspacing, height/2+yvalues[xX], 16, 16, -BPM/10);
  }
}


void serialEvent(Serial myPort) {
  String inData = myPort.readStringUntil('\n');
  inData = trim(inData);
  if(inData.charAt(0) == 'B') {
    inData = inData.substring(1);
    BPM = int(inData);
  }
  if(inData.charAt(0) == 'Q') {
    inData = inData.substring(1);
    IBI = int(inData);
    beat = true;
  }
}

void score(boolean stat, int i) {
  if(stat) {
    // 
    if(g.getYPos() > obstacles.get(i).getYPos()) {
      multiplyer = abs(height-g.getYPos()-g.getRadius())/(obstacles.get(i).getHeight()/100);  

      text(multiplyer, width/2, 100);
    } else {
      score += 10*multiplyer/100;
    }
  }
}

//void setHighscore(int score) {
 // int currentHighscore = highscore;
  //if(score > currentHighscore) {
    //writer = createWriter("highscore.txt");
    // write score as new highscore
//  } else {
    // do nothing
 // }
//}

//void getHighscore() {
  //try {
    //readValue = reader.readLine();
  //} catch(IOException e) {
   // e.printStackTrace();
    //readValue = null;
  //}
  //if(readValue == null) {
    //noLoop();
    //println("Error in the getHighscore() function!");
  //} else {
    //String[] readHighscore = split(readValue, ' ');
    //highscore = int(readHighscore[0]);
 // }
//}

void resetAllTheStuff(){
  BPM = 0;
  beat = false;
  o = 0;
  caliCount = 10;
  test = 0;
  reached = false;
  stopuhr = 0;
  hase = 0;
  theta = 0.0;
  fill(255);
}

//boolean overButton1() {
//  if(mouseX >= bx1 && mouseX <= bx1+bWidth && mouseY >= by && mouseY <= by+bHeight) {
//    return true;
//  } else {
//    return false;
//  }
//}
//boolean overButton2() {
//  if(mouseX >= bx2 && mouseX <= bx2+bWidth && mouseY >= by && mouseY <= by+bHeight) {
//    return true;
//  } else {
//    return false;
//  }
//}
//boolean overButton3() {
//  if(mouseX >= bx3 && mouseX <= bx3+bWidth && mouseY >= by && mouseY <= by+bHeight) {
//    return true;
//  } else {
//    return false;
//  }
//}


boolean overButton1() {
if(mouseX >= bx && mouseX <= bx+bWidth && mouseY >= by1 && mouseY <= by1+bHeight && gamestate == 3) {
return true;
} else {
return false;
}
}
boolean overButton2() {
if(mouseX >= bx && mouseX <= bx+bWidth && mouseY >= by2 && mouseY <= by2+bHeight && gamestate == 3) {
return true;
} else {
return false;
}
}
boolean overButton3() {
if(mouseX >= bx && mouseX <= bx+bWidth && mouseY >= by3 && mouseY <= by3+bHeight && gamestate == 3) {
return true;
} else {
return false;
}
}

boolean overButton4() {
if(mouseX >= bx && mouseX <= bx+bWidth && mouseY >= by4 && mouseY <= by4+bHeight && gamestate == 0) {
return true;
} else {
return false;
}
}
boolean overButton5() {
if(mouseX >= bx && mouseX <= bx+bWidth && mouseY >= by5 && mouseY <= by5+bHeight && gamestate == 2) {
return true;
} else {
return false;
}
}
boolean overButton6() {
if(mouseX >= bx && mouseX <= bx+bWidth && mouseY >= by6 && mouseY <= by6+bHeight && gamestate == 2) {
return true;
} else {
return false;
}
}

void mousePressed() {
if(overButton1()) {
println("BUTTON1");
hase = 115;
gamestate = 0;
c1 = 250;
c2 = 250;
c3 = 250;
}
else if(overButton2()) {
println("BUTTON2");
hase = 140;
gamestate = 0;
c1 = 160;
c2 = 190;
c3 = 160;
}
else if(overButton3()) {
println("BUTTON3");
hase = 160;
gamestate = 0;
c1 = 40;
c2 = 140;
c3 = 90;
}
else if(overButton4()) {
println("BUTTON4");
gamestate = 1;
}
else if(overButton5()) {
println("BUTTON4");
gamestate = 0;
}
else if(overButton6()) {
println("BUTTON4");
gamestate = 3;
}
else {
println("DEINE MAMA");
}
}

