ControlP5 cp5;
color dialColorBoard = on;
color dialColorV1 = on;
color dialColorV2 = on;
Knob tempKnobBoard;
Knob tempKnobVicor1;
Knob tempKnobVicor2;
Table tempTable = new Table();
float newVal;

void createDial(){
  cp5 = new ControlP5(this);
  tempKnobBoard = cp5.addKnob("Board Temperature (C)")
    .setRange(0, 100)
    .setValue(0)
    .setPosition(660, 100)
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
    .setPosition(840, 100)
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
    .setPosition(1020, 100)
    .setRadius(50)
    .setViewStyle(Knob.ARC)
    .setMoveable(false)
    .setColorForeground(dialColorV2)
    .setColorActive(dialColorV2)
    .setUpdate(true);   
}

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
  
  if (millis()%2000 < 20){
    updateTempLog(tempBoard, tempVicor1, tempVicor2);
  }
}

void updateTempLog(float tempBoard, float tempVicor1, float tempVicor2){
  TableRow row = tempTable.addRow();
  row.setString("Timestamp", month() + "/" + day()+ " " + hour() + ":" + minute() + ":" + second());
  row.setFloat("Temperature", tempBoard);
  if (enabled) row.setInt("ON/OFF", 1);
  else row.setInt("ON/OFF", 0);
  saveTable(tempTable, "Temperature Logs/TempLog " + timeStamp + ".csv");
}

void createTempLog(){  
  //Makes temperature log
  tempTable.addColumn("Timestamp");
  tempTable.addColumn("Temperature");
  tempTable.addColumn("ON/OFF");
  
}

//Maps from analog 0 to 1023 to volts to temperature ˚C for board temperature
float tempBoard(float val) {
  float newVal = map(val, 0, 1023, 0, 5);
  float cel = voltTempEqBoard(newVal);
  text(round(cel) + " ˚C", 685, 95);
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