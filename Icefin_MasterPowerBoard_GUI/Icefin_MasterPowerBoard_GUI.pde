/*
Icefin Master Power Board GUI for Testing

What this does:
  1) Shows status of all signals
  2) Can enable and disable the Power Board
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
StringList analogNames = new StringList(6);

void setup() {
  size(940, 560);

  // Prints out the available serial ports.
  println(Arduino.list());
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, "/dev/cu.usbmodem1461", 57600);
  
  // Alternatively, use the name of the serial port corresponding to your
  // Arduino (in double-quotes), as in the following line.
  //arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);
  
  // Set the Arduino digital pins as inputs.
  for (int i = 0; i <= 13; i++)
    arduino.pinMode(i, Arduino.INPUT);
  //StringList analogNames = {"joe"};
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
  textSize(9);
  for (int i = 0; i <= 13; i++) {
    fill(on);
    if (arduino.digitalRead(i) == Arduino.HIGH){
    text("NAME", 40, 545 - i * 35);
    //if (i%2 == 0) {
      fill(on);
      text("HIGH",158, 545 - i * 35);
    }
    else {
      text("LOW",158, 545 - i * 35);
      fill(off);
    }
    // Draw a filled box for each digital pin that's HIGH (5 volts).
    rect(130, 530 - i * 35, 20, 20);
  } 

  // Draw a circle whose size corresponds to the value of an analog input.
  for (int i = 0; i <= 5; i++) {
    noFill();
    //ellipse(360, 90 + i * 40, 25, 25);
    ellipse(280 + i * 30, 240, arduino.analogRead(i) / 16, arduino.analogRead(i) / 16);
    fill(on);
    text("NAME", 260, 90 + i * 40);
  }
}