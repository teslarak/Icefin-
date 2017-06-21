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
boolean enabled;
ArrayList<Pin> pinList = new ArrayList<Pin>(8);
Table table;

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
  for (int i = 0; i < 8 ; i++){
    pinList.get(i).begin();}
  disable();
  //IMPORTANT: pin6 aka OPTO_EN must be HIGH before enabling
  arduino.digitalWrite(pin6.pinNumber, arduino.HIGH);
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
    }
    else {
      text("LOW",158, 90 + i * 40);
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

//toggle button
void mousePressed(){
  if (mouseX > 480 && mouseX < 540 && mouseY > 80 && mouseY < 100) enabled =!enabled;
}

void enable(){
  if (arduino.digitalRead(pin6.pinNumber) == arduino.HIGH){
    if (arduino.digitalRead(pin5.pinNumber) == arduino.HIGH){
      if (arduino.digitalRead(pin3.pinNumber) == arduino.HIGH && arduino.digitalRead(pin4.pinNumber) == arduino.HIGH){
         arduino.digitalWrite(pin6.pinNumber, arduino.LOW);
         enabled = true;
      }
    }
  }
}

void disable(){
  arduino.digitalWrite(pin6.pinNumber, arduino.HIGH);
  enabled = false;
  //do stuff to disable
}

/* QUESTIONS
when disabling what do we turn to low?
is everything else default low?
*/