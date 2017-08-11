/*
>>>>>>>>>>>>>>>>>>>>>>>>Icefin Master Power Board GUI for Testing<<<<<<<<<<<<<<<<<<<<<<<
Main tab - structure for program

IMPORTANT: pin6 aka OPTO_EN must be HIGH before enabling

What this does:
 1) Shows status of all signals
 2) Can enable and disable the Power Board
 to ENABLE:
   a) Check if EN is high to begin, if yes CONTINUE
   b) Check if Load_Ready is high, if yes CONTINUE
   c) Check if VAUX1 and VAUX2 are low, if yes CONTINUE
   d) Set EN to low
 3) Displays temperature gauges for BOARD_TMP_BUF, TM1_DC_BUF, and TM2_DC_BUF.
 4) Logs temperatures in a separate file, called "Temperature Logs"
 5) Controls four relays via toggle button
 
How to use:
 1) Ensure power board wires are snugly fit inside connectors and there are no shorts.
 2) Connect Arduino to computer via USB and run the StandardFirmata example code in the 
    Arduino IDE application. (Arduino>Examples>Firmata>Standard Firmata)
 3) Run this program to use the GUI.
 4) If it gives you a port not found error, check that the port is /dev/cu.usbmodem1441 
    in Arduino > tools. If not, write the correct port into this line in the code below 
    and use quotations: arduino = new Arduino(this, "/dev/cu.usbmodem1441", 57600);
 5) Press the enable button to toggle enabled and disabled board state. 
    Read the console below and the GUI to monitor status of board.
 6) If you would like to create a new pin or find pin names, click the Pins tab and 
    scroll to the bottom.
 7) See List of functions below and on each tab if you would like to call a function.
 
List of functions in this tab (name:how to use)
  1) setup():only runs once at start so use to create new variables/objects or declare 
     them outside the setup function.
  2) draw():edit this to change positions and shapes on the display. See 
     processing.org/reference for more detail.
  3) testPins():do not edit unless changing test procedure. Uncomment line 91 to run 
     a pin test using a multimeter and the display console below.
  4) mousePressed():is called everytime the mouse is pressed. Use to toggle things.
  5) enable():no need to call. Press button on display to toggle enable/disable. 
     only change if enable/disable procedure needs to be changed.
  5) disable():same as enable. Is called in setup() to initially disable.
  6) relayOn(Pin relay):call to turn a relay on. Put the desired pin as the parameter
  7) relayOff(Pin relay): call to turn a relay off. Put the desired pin as the parameter
  8) relayButton():draws the relay buttons. Is called in draw().
 
Example code from StandardFirmata Firmware which "Demonstrates the reading of 
digital and analog pins of an Arduino board running the StandardFirmata firmware."
Knob class from ControlP5 library.
Arduino library also required. 

Lara Kassabian 2017
*/

//Setting up
import processing.serial.*;
import controlP5.*;
import cc.arduino.*;
Arduino arduino;
color off = color(4, 79, 111); //darker blue
color on = color(84, 145, 158); //lighter blue
boolean enabled = false; //on/off for OPTO_EN
boolean R2state = false; //on/off for IN2 relay
boolean R3state = false; //on/off for IN3 relay
boolean R4state = false; //on/off for IN4 relay
boolean R5state = false; //on/off for IN5 relay
ArrayList<Pin> pinList = new ArrayList<Pin>(8);
//Note: on non-mac computers you can change the semicolons separating the time to colons. 
//On macs, colons display as slashes in the filename
String timeStamp = month() + "-" + day() + "-" + year() + " " + hour() + ";" + minute() + ";" + second();

//Runs first and sets up program
void setup() {
  size(1440, 280);
  
  // Prints out the available serial ports.
  println("List of available serial ports: ");
  println(Arduino.list());
  arduino = new Arduino(this, "/dev/tty.usbmodem1461", 57600);
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
  pinList.add(pin9);
  pinList.add(pin10);
  pinList.add(pin11);
  pinList.add(pin12);
  
  relayOff(pin9);
  relayOff(pin10);
  relayOff(pin11);
  relayOff(pin12);
  disable();
  for (int i = 0; i < 8; i++) {
    pinList.get(i).begin();
  }
  pin2.dWrite("LOW");
  //uncomment this to run a test of all the pins using a multimeter and the display console below
  //testPins();

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

  //Draw a filled box for each digital pin that's HIGH (5 volts).
  for (int i = 0; i < 5; i++) {
   fill(on);
   Pin pin = pinList.get(i+3);
   text(pin.name, 40, 90 + i * 40);
   if (pin.inOut == "out"){
     if (pin.state == "HIGH") {
       fill(on);
       text("HIGH", 158, 90 + i * 40);
     }
     else {
       text("LOW", 158, 90 + i * 40);
       fill(off);
     }
   }
   else if (pin.inOut == "in") {
     if (pin.dRead() == "HIGH") {
       fill(on);
       text("HIGH", 158, 90 + i * 40);
     } 
     else if (pin.dRead() == "LOW") {
       text("LOW", 158, 90 + i * 40);
       fill(off);
     } 
   }
   else {
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
  } 
  else {
    text("Disabled", 488, 115);
    fill(off);
  }
  rect(488, 80, 60, 20);
  fill(on);
  text("OPTO_EN", 430, 95);
  
  //Draws buttons for relay switches
  relayButton();
  
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
    } 
    else {
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
  if (mouseX > 488 && mouseX < 548 && mouseY > 80 && mouseY < 100) {
    if (enabled == false) enable();
    else disable();
  }
  if (mouseX > 488 && mouseX < 548 && mouseY > 120 && mouseY < 140){
    if (!R2state) relayOn(pin9);
    else relayOff(pin9);
  }
  if (mouseX > 488 && mouseX < 548 && mouseY > 160 && mouseY < 180){
    if (!R3state) relayOn(pin10);
    else relayOff(pin10);
  }
  if (mouseX > 488 && mouseX < 548 && mouseY > 200 && mouseY < 220){
    if (!R4state) relayOn(pin11);
    else relayOff(pin11);
  }
  if (mouseX > 488 && mouseX < 548 && mouseY > 240 && mouseY < 260){
    if (!R5state) relayOn(pin12);
    else relayOff(pin12);
  }
}

//Enables board
void enable() {
  if (pin6.state == "HIGH") {
    println(pin6.name + " is HIGH. Proceeding...");
    pin5.setpinInOut("INPUT");
    println("LOAD_READY_ISO ready");
  if (pin3.state == "LOW" && pin4.state == "LOW");
    println("VAUX1 and VAUX2 ready");
  } 
  else println("Cannot Enable: OPTO_EN currently LOW");
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

//RELAY FUNCTIONS

//Turns relays on
void relayOn(Pin relay){
    relay.dWrite("LOW");
    if (relay == pin9) R2state = true;
    else if (relay == pin10) R3state = true;
    else if (relay == pin11) R4state = true;
    else if (relay == pin12) R5state = true;
}

//Turns relays off
void relayOff(Pin relay){
    relay.dWrite("HIGH");
    if (relay == pin9) R2state = false;
    else if (relay == pin10) R3state = false;
    else if (relay == pin11) R4state = false;
    else if (relay == pin12) R5state = false;
}

//Draw buttons for switching relay states
void relayButton(){
  fill(on);
  text("Relay IN2", 430, 135);
  text("Relay IN3", 430, 175);
  text("Relay IN4", 430, 215);
  text("Relay IN5", 430, 255);
  if (R2state) fill(on);
  else fill(off);
  rect(488, 120, 60, 20);
  
  if (R3state) fill(on);
  else fill(off);
  rect(488, 160, 60, 20);
  
  if (R4state) fill(on);
  else fill(off);
  rect(488, 200, 60, 20);
  
  if (R5state) fill(on);
  else fill(off);
  rect(488, 240, 60, 20);
}