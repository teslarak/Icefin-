/*
Temperature Tab - location of all temperature related functions and objects

List of functions in this tab (name:how to use)
  1) createDial():creates the three temperature gauges and is called in setup(). 
     Add or edit dials here.
  2) drawDial():draws the dials for each frame and is called in draw().
  3) createTempLog():creates the temperature log. Add new columns here.
  4) updateTempLog(float tempBoard, float tempVicor1, float tempVicor2):is called in 
     drawDial(). Add row entries here.
  5) tempBoard(float val):call this function to convert an analog reading to a 
     temperature of the board.
  6) tempVicor(float val): call this function to convert an analog reading to a 
     temperature of the Vicor chips.
  7) voltTempEqBoard(float volt):this function is a helper function for 
     tempBoard(float val). Call if you want a temperature from a voltage from the board.
  8) voltTempEqVicor(float volt):this function is a helper function for 
     tempVicor(float val). Call if you want a temperature from a voltage from the 
     Vicor chips.
*/

ControlP5 cp5;
color dialColorBoard = on;
color dialColorV1 = on;
color dialColorV2 = on;
Knob tempKnobBoard;
Knob tempKnobVicor1;
Knob tempKnobVicor2;
Table tempTable = new Table();
float newVal;

//Creates the dials (also called knobs or gauges).
//see Processing/File/Examples/Contributed Libraries/ControlP5/Controllers/Knob 
//for all functions in the knob class. 
void createDial(){
  cp5 = new ControlP5(this);
  //Makes board temperature knob
  tempKnobBoard = cp5.addKnob("Board Temperature (C)")
    .setRange(0, 100)
    .setValue(0)
    .setPosition(660, 110)
    .setRadius(50)
    .setViewStyle(Knob.ARC)
    .setMoveable(false)
    .setColorForeground(dialColorBoard)
    .setColorActive(dialColorBoard)
    .setUpdate(true);
    
  //Makes Vicor 1 Temperature Knob
  tempKnobVicor1 = cp5.addKnob("Vicor1 Temperature (C)")
    .setRange(0, 100)
    .setValue(0)
    .setPosition(840, 110)
    .setRadius(50)
    .setViewStyle(Knob.ARC)
    .setMoveable(false)
    .setColorForeground(dialColorV1)
    .setColorActive(dialColorV1)
    .setUpdate(true);  
    
  //Makes Vicor 2 Temperature Knob
  tempKnobVicor2 = cp5.addKnob("Vicor2 Temperature (C)")
    .setRange(0, 100)
    .setValue(0)
    .setPosition(1020, 110)
    .setRadius(50)
    .setViewStyle(Knob.ARC)
    .setMoveable(false)
    .setColorForeground(dialColorV2)
    .setColorActive(dialColorV2)
    .setUpdate(true);   
}

//Draws the dials
void drawDial(){
  float tempBoard = tempBoard(pinA2.aRead());
  float tempVicor1 = tempVicor(pinA0.aRead());
  float tempVicor2 = tempVicor(pinA1.aRead());
  if (tempBoard >= 90) {
    dialColorBoard = color(204, 0, 0);
  } 
  else dialColorBoard = on;
  if (tempVicor1 >= 90) {
    dialColorV1 = color(204, 0, 0);
  }
  else dialColorV1 = on;
  if (tempVicor2 >= 90) {
    dialColorV2 = color(204, 0, 0);
  }
  else dialColorV2 = on;  
  tempKnobBoard.setValue(tempBoard);
  tempKnobBoard.setColorForeground(dialColorBoard);
  tempKnobBoard.setColorActive(dialColorBoard);
  tempKnobVicor1.setValue(tempVicor1);
  tempKnobVicor1.setColorForeground(dialColorV1);
  tempKnobVicor1.setColorActive(dialColorV1);
  tempKnobVicor2.setValue(tempVicor2);
  tempKnobVicor2.setColorForeground(dialColorV2);
  tempKnobVicor2.setColorActive(dialColorV2);
  
  textSize(24);
  fill(255);
  text(round(tempBoard) + " ˚C", 680, 105);
  text(round(tempVicor1) + " ˚C", 860, 105); 
  text(round(tempVicor2) + " ˚C", 1040, 105); 
  
  if (millis()%2000 < 20) {
    updateTempLog(tempBoard, tempVicor1, tempVicor2);
  }
}

//Creates the temperature log
void createTempLog(){  
  //Makes temperature log
  tempTable.addColumn("Timestamp");
  tempTable.addColumn("Board Temperature");
  tempTable.addColumn("Vicor1 Temperature");
  tempTable.addColumn("Vicor2 Temperature");
  tempTable.addColumn("ON/OFF");
}

//Updates temperature log
void updateTempLog(float tempBoard, float tempVicor1, float tempVicor2){
  TableRow row = tempTable.addRow();
  row.setString("Timestamp", month() + "/" + day()+ " " + hour() + ":" + minute() + ":" + second());
  row.setFloat("Board Temperature", tempBoard);
  row.setFloat("Vicor1 Temperature", tempVicor1);
  row.setFloat("Vicor2 Temperature", tempVicor2);
  if (enabled) row.setInt("ON/OFF", 1);
  else row.setInt("ON/OFF", 0);
  saveTable(tempTable, "Temperature Logs/TempLog " + timeStamp + ".csv");
}

//Maps from analog 0 to 1023 to volts to temperature ˚C for board temperature
float tempBoard(float val) {
  float newVal = map(val, 0, 1023, 0, 5);
  float cel = voltTempEqBoard(newVal);
  return cel;
}

//Maps from analog 0 to 1023 to volts to temperature ˚C for Vicor chips
float tempVicor(float val) {
  float newVal = map(val, 0, 1023, 0, 5);
  float cel = voltTempEqVicor(newVal);
  return cel;
}

//Equation that turns voltage reading to temperature for the board temperature
float voltTempEqBoard(float volt) {
  float newTemp = (volt - 0.5)*100;
  return newTemp;
}

//Equation that turns voltage reading to temperature for Vicor chips
float voltTempEqVicor(float volt){
  float newTemp = (volt - 1.02)*100;
  return newTemp;
}