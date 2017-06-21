/*
Icefin Master Power Board GUI for Testing

What this does:
  1) Shows status of all signals
  2) Can enable and disable the Power Board
    to ENABLE:
    a) Check if EN is high to begin, if yes CONTINUE
    b) Check if Load_Ready is high, if yes CONTINUE
    c) Check if VAUX1 and VAUX2 are high, if yes CONTINUE
    d) Set EN to low
  3) Logs Temperature in a separate file
  4) Plots temperature VS time
  
Example code from StandardFirmata Firmware which "Demonstrates the reading of 
digital and analog pins of an Arduino board running the StandardFirmata firmware."
  
How to use:
  1) Connect Arduino to computer via USB and run the StandardFirmata example code in the 
  Arduino application.
  2) Run this program to use interface.
  3) If it doesn't work, check that the port is /dev/cu.usbmodem1441 in Arduino > tools.
  If not, write the correct port into this line in the code below and use quotations: 
  arduino = new Arduino(this, "/dev/cu.usbmodem1441", 57600);

Lara Kassabian 2017
*/

import processing.serial.*;

import cc.arduino.*;

Arduino arduino;

color off = color(4, 79, 111);
color on = color(84, 145, 158);
boolean enabled = false;
ArrayList<Pin> pinList = new ArrayList<Pin>(8);
Table table;
int phase = 0;
int count = 0;

void setup() {
  size(940, 280);

  // Prints out the available serial ports.
  println(Arduino.list());
  arduino = new Arduino(this, "/dev/tty.usbmodem1431", 57600);
  // Use the name of the serial port corresponding to your 
  // Arduino (in double-quotes), as in the following line.
  // arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);
  pinList.add(pinA0);
  pinList.add(pinA1);
  pinList.add(pinA2);
  pinList.add(pin2);
  pinList.add(pin3);
  pinList.add(pin4);
  pinList.add(pin5);
  pinList.add(pin6);
  //pin6.printPin();
  //disable();
  //for (int i = 0; i < 8 ; i++){
  // pinList.get(i).begin();}
  //pin6.setpinInOut("OUTPUT");
  //pin6.dWrite("LOW"); 
  //pin6.printPin();
  //pin6.dWrite("HIGH");
  //pin6.printPin();
  ////IMPORTANT: pin6 aka OPTO_EN must be HIGH before enabling
  testPins();
}

void draw() {
  background(off);
  stroke(on);
  fill(on);
  textSize(24);
  text("Icefin Master Power Board Testing GUI", width/4, 30);
  textSize(12);
  text("Digital I/O", 70, 65);
  text("Analog I/O", 290, 65);
  text("Press to Enable/Disable", 450, 65);
  text("Temperature versus Time", 650, 65);
  textSize(9);
  
  //Draw a filled box for each digital pin that's HIGH (5 volts).
  for (int i = 0; i < 5; i++) {
    fill(on);
    text(pinList.get(i+3).name, 40, 90 + i * 40);
    if (arduino.digitalRead(i+3) == Arduino.HIGH){
      fill(on);
      text("HIGH",158, 90 + i * 40);
      pinList.get(i+3).state = "HIGH";
    }
    else {
      text("LOW",158, 90 + i * 40);
      pinList.get(i+3).state = "LOW";
      fill(off);
    }
    rect(130, 75 + i * 40, 20, 20);
  } 

  // Draw a circle whose size corresponds to the value of an analog input.
  for (int i = 0; i < 3; i++) {
    noFill();
    //ellipse(360, 90 + i * 40, 25, 25);
    ellipse(360, 90 + i * 40, arduino.analogRead(i) / 16, arduino.analogRead(i) / 16);
    fill(on);
    text(pinList.get(i).name, 260, 90 + i * 40);
    text(arduino.analogRead(i), 380, 93 + i * 40);
  }
  //Make button for enabling and disabling board
  stroke(255);
  if (enabled == true) {
    text("Enabled", 480, 115);
    fill(on);
  }
  else fill(off);
  rect(480, 80, 60, 20);
}

void testPins(){
  for (int i = 0; i < pinList.size(); i++){
    println("waiting...");
    delay(15000);
    Pin pin = pinList.get(i);
    println("Begin testing: " + pin.name);
    if (pin.type == "analog"){
      pin.printPin();
      println(pin.aRead());
    }
    else{
      println("Testing HIGH");
      pin.printPin();
      pin.dWrite("HIGH");
      pin.printPin();
      println("Reading: " + pin.dRead());
      println("waiting...");
      delay(15000);
      println("Testing LOW");
      pin.printPin();
      pin.dWrite("LOW");
      pin.printPin();
      println("Reading: " + pin.dRead());
      }
    }
  }

void keyPressed(){
  if (keyPressed){
    count += 1;
    phase = count%2;
  }
}

//toggle button
void mousePressed(){
  if (mouseX > 480 && mouseX < 540 && mouseY > 80 && mouseY < 100) {
    if (enabled == false) enable();
    else disable();
  }
}

void enable(){
  if (arduino.digitalRead(6) == arduino.HIGH){
    if (arduino.digitalRead(pin5.pinNumber) == arduino.HIGH){
      if (arduino.digitalRead(pin3.pinNumber) == arduino.HIGH && arduino.digitalRead(pin4.pinNumber) == arduino.HIGH){
        arduino.digitalWrite(pin6.pinNumber, arduino.LOW);
        enabled = true;
      }
      else println("Cannot Enable: VAUX1 or VAUX2 currently LOW");
    }
    else println("Cannot Enable: LOAD_READY_ISO currently LOW");
  }
  else println("Cannot Enable: OPTO_EN currently LOW at " + arduino.digitalRead(pin6.pinNumber));
}

void disable(){
  if (pin6.state == "LOW") {
    arduino.digitalWrite(pin6.pinNumber, arduino.HIGH);
    enabled = false;
  }
  //do stuff to disable
}

/* QUESTIONS
when disabling what do we turn to low?
is everything else default low?
setter-- just a function where you input parameters and pop out a pin with those variables
*/
/*
Looop Pins{
 printPInt
  dWrite pin High
 printPin
 print(dRead) 
}
*/