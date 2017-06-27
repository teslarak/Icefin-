/*
Icefin Master Power Board GUI for Testing
 
IMPORTANT: pin6 aka OPTO_EN must be HIGH before enabling
 
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
 6) If you would like to create a new pin, click the Pins tab and scroll to the bottom.
 
Example code from StandardFirmata Firmware which "Demonstrates the reading of 
digital and analog pins of an Arduino board running the StandardFirmata firmware."
 
Lara Kassabian 2017
*/

//Setting up
import processing.serial.*;
import controlP5.*;
import cc.arduino.*;
Arduino arduino;
ControlP5 cp5;
color off = color(4, 79, 111);
color on = color(84, 145, 158);
boolean enabled = false;
ArrayList<Pin> pinList = new ArrayList<Pin>(8);
float newVal;
color dialColor = on;
Knob tempKnob;
Table tempTable = new Table();
//Note: on non-mac computers you can change the semicolons separating the time to colons. 
//On macs, colons display as slashes in the filename
String timeStamp = month() + "-" + day()+ " " + hour() + ";" + minute() + ";" + second();

//Runs first and sets up program
void setup() {
  size(800, 280);
  
  // Prints out the available serial ports.
  println("List of available serial ports: ");
  println(Arduino.list());
  arduino = new Arduino(this, "/dev/tty.usbmodem1431", 57600);
  // Use the name of the serial port corresponding to your 
  // Arduino (in double-quotes), as in the following line.
  // arduino = new Arduino(this, "/dev/tty.usbmodem621", 57600);

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

  //Makes temperature knob
  cp5 = new ControlP5(this);
  tempKnob = cp5.addKnob("Temperature ˚C")
    .setRange(0, 100)
    .setValue(0)
    .setPosition(660, 100)
    .setRadius(50)
    .setViewStyle(Knob.ARC)
    .setMoveable(false)
    .setColorForeground(dialColor)
    .setColorActive(dialColor)
    .setUpdate(true);
  
  //Makes temperature log
  tempTable.addColumn("Timestamp");
  tempTable.addColumn("Temperature");
  tempTable.addColumn("ON/OFF");
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
  text("Temperature Gauge", 650, 65);
  line(617, 65, 617, 250);
  line(420, 65, 420, 250);
  line(215, 65, 215, 250);
  float temp = temp(pinA2.aRead());
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
  if (enabled == true) {
    text("Enabled", 488, 115);
    fill(on);
  } else {
    text("Disabled", 488, 115);
    fill(off);
  }
  rect(488, 80, 60, 20);

  //Draw the temperature dial
  if (temp >= 90) {
    dialColor = color(204, 0, 0);
  } else dialColor = on;
  tempKnob.setValue(temp);
  tempKnob.setColorForeground(dialColor);
  tempKnob.setColorActive(dialColor);
  
  //Add to temperature log
  if (millis()%2000 < 20){
   TableRow row = tempTable.addRow();
   row.setString("Timestamp", month() + "/" + day()+ " " + hour() + ":" + minute() + ":" + second());
   row.setFloat("Temperature", temp);
   if (enabled) row.setInt("ON/OFF", 1);
   else row.setInt("ON/OFF", 0);
   saveTable(tempTable, "Temperature log " + timeStamp + ".csv");
  }
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

//Maps from analog 0 to 1023 to volts to temperature ˚C
float temp(float val) {
  float newVal = map(val, 0, 1023, 0, 5);
  float temp = voltTempEq(newVal);
  text(round(temp) + " ˚C", 685, 95);
  return temp;
}

//Equation that turns voltage reading to temperature
float voltTempEq(float volt) {
  float newTemp = (volt - 0.5)*100;
  return newTemp;
}