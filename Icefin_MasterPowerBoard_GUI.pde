/*
Icefin Master Power Board GUI for Testing
Main tab - structure for program
 
IMPORTANT: pin6 aka OPTO_EN must be HIGH before enabling
 
What this does:
 1) Shows status of all signals
 2) Can enable and disable the Power Board
 to ENABLE:
   a) Check if EN is high to begin, if yes CONTINUE
   b) Check if Load_Ready is high, if yes CONTINUE
   c) Check if VAUX1 and VAUX2 are high, if yes CONTINUE
   d) Set EN to low
 3) Displays temperature gauges for BOARD_TMP_BUF, TM1_DC_BUF, and TM2_DC_BUF.
 4) Logs temperatures in a separate file
 
How to use:
 1) Ensure power board wires are snugly fit inside connectors and there are no shorts.
 2) Connect Arduino to computer via USB and run the StandardFirmata example code in the 
    Arduino application.
 3) Run this program to use the GUI.
 4) If it gives you a port not found error, check that the port is /dev/cu.usbmodem1441 
    in Arduino > tools. If not, write the correct port into this line in the code below 
    and use quotations: arduino = new Arduino(this, "/dev/cu.usbmodem1441", 57600);
 5) Press the enable button to toggle enabled and disabled board state. 
    Read the console below and the GUI to monitor status of board.
 6) If you would like to create a new pin or find pin names, click the Pins tab and 
    scroll to the bottom.
 
List of functions in this tab (name:how to use)
  1) setup():only runs once at start so use to create new variables/objects or declare 
     them outside the setup function.
  2) draw():edit this to edit positions and shapes on the display see 
     processing.org/reference for more detail.
  3) testPins():do not edit unless changing test procedure. Uncomment line 87 to run 
     a pin test using a multimeter and the display console below.
  4) mousePressed():is called everytime the mouse is pressed. Use to toggle things.
  5) enable():no need to call. Press button on display to toggle enable/disable. 
     only change if enable/disable procedure needs to be changed.
  5) disable():same as enable. Is called in setup() to initially disable.
 
Example code from StandardFirmata Firmware which "Demonstrates the reading of 
digital and analog pins of an Arduino board running the StandardFirmata firmware."
Knob class from ControlP5 library.

Lara Kassabian 2017
*/

//Setting up
import processing.serial.*;
import controlP5.*;
import cc.arduino.*;
Arduino arduino;
color off = color(4, 79, 111);
color on = color(84, 145, 158);
boolean enabled = false;
ArrayList<Pin> pinList = new ArrayList<Pin>(8);
//Note: on non-mac computers you can change the semicolons separating the time to colons. 
//On macs, colons display as slashes in the filename
String timeStamp = month() + "-" + day() + "-" + year() + " " + hour() + ";" + minute() + ";" + second();

//Runs first and sets up program
void setup() {
  size(1160, 280);
  
  // Prints out the available serial ports.
  println("List of available serial ports: ");
  println(Arduino.list());
  arduino = new Arduino(this, "/dev/tty.usbmodem1431", 57600);
  // Use the name of the serial port corresponding to your Arduino (in double-quotes), 
  //as in the following line. arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);

  //adds pins to the pinList  
  pinList.add(pinA0); 
  pinList.add(pinA1);
  pinList.add(pinA2);
  pinList.add(pin2);
  pinList.add(pin3);
  pinList.add(pin4);
  pinList.add(pin5);
  pinList.add(pin6);
  disable();
  for (int i = 0; i < 8; i++) {
    pinList.get(i).begin();
  }
  //testPins(); //uncomment this to run a test of all the pins using a multimeter and the display console below

  //Creates temperature dials
  createDial(); 
   
  //Creates temperature log 
  createTempLog();
}

//Runs 60 times per second and draws the GUI
void draw() {
  background(off);
  stroke(255);
  fill(255);
  textSize(24);
  text("Icefin Master Power Board Testing GUI", width/4, 30);
  textSize(12);
  text("Digital I/O", 70, 65);
  text("Analog I/O", 290, 65);
  text("Press to Enable/Disable", 450, 65);
  text("Temperature Gauges", 830, 65);
  line(617, 65, 617, 250);
  line(420, 65, 420, 250);
  line(215, 65, 215, 250);
  stroke(on);
  textSize(10);
  text("0", 660, 200);
  text("100", 750, 200);

  //Draw a filled box for each digital pin that's HIGH (5 volts).
  for (int i = 0; i < 5; i++) {
    fill(on);
    text(pinList.get(i+3).name, 40, 90 + i * 40);
    if (pinList.get(i+3).state == "HIGH") {
      fill(on);
      text("HIGH", 158, 90 + i * 40);
    } else if (pinList.get(i+3).state == "LOW") {
      text("LOW", 158, 90 + i * 40);
      fill(off);
    } else {
      text("null", 158, 90 + i * 40);
      fill(128, 128, 128);
    }
    rect(130, 75 + i * 40, 20, 20);
  } 

  //Draw a circle whose size corresponds to the value of an analog input.
  for (int i = 0; i < 3; i++) {
    noFill();
    ellipse(340, 90 + i * 40, pinList.get(i).aRead() / 16, pinList.get(i).aRead() / 16);
    fill(on);
    text(pinList.get(i).name, 240, 90 + i * 40);
    text(map(pinList.get(i).aRead(), 0, 1023, 0, 5), 360, 93 + i * 40);
    text("V", 395, 93 + i * 40);
  }
  //Draw button for enabling and disabling board
  stroke(255);
  if (enabled) {
    text("Enabled", 488, 115);
    fill(on);
  } else {
    text("Disabled", 488, 115);
    fill(off);
  }
  rect(488, 80, 60, 20);
  
  //Draws temperature gauges and calls updateTempLog
  drawDial();
}

//Function to run a pin test. Uncomment the line testPins(); in the setup function 
//to run a test.
void testPins() {
  for (int i = 0; i < pinList.size(); i++) {
    println("waiting...");
    delay(5000);
    Pin pin = pinList.get(i);
    println("Begin testing: " + pin.name);
    delay(5000);
    if (pin.type == "analog") {
      pin.printPin();
      println(pin.aRead());
    } else {
      println("Testing HIGH");
      pin.printPin();
      pin.dWrite("HIGH");
      pin.printPin();
      println("waiting...");
      delay(5000);
      println("Reading: " + pin.dRead());
      println("Testing LOW");
      pin.printPin();
      pin.dWrite("LOW");
      pin.printPin();
      println("waiting...");
      delay(5000);      
      println("Reading: " + pin.dRead());
    }
  }
  println("Test Complete");
}

//ENABLE/DISABLE FUNCTIONS

//Toggles button
void mousePressed() {
  if (mouseX > 480 && mouseX < 540 && mouseY > 80 && mouseY < 100) {
    if (enabled == false) enable();
    else disable();
  }
}

//Enables board
void enable() {
  if (pin6.state == "HIGH") {
    println(pin6.name + " is HIGH. Proceeding...");
    pin5.setpinInOut("INPUT");
    println("LOAD_READY_ISO ready");
    pin3.setpinInOut("INPUT");
    pin4.setpinInOut("INPUT");
    println("VAUX1 and VAUX2 ready");
  } else println("Cannot Enable: OPTO_EN currently LOW");
  enabled = true;
  pin6.dWrite("LOW");
  println("Enabled");
}

//Disables board
void disable() {
  pin6.dWrite("HIGH");
  enabled = false;
  println("Disabled");
}