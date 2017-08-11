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
  6) tempVicor(float val):call this function to convert an analog reading to a 
     temperature of the Vicor chips.
  7) voltTempEqBoard(float volt):this function is a helper function for 
     tempBoard(float val). Call if you want a temperature from a voltage from the board.
  8) voltTempEqVicor(float volt):this function is a helper function for 
     tempVicor(float val). Call if you want a temperature from a voltage from the 
     Vicor chips.
  9) checkVaux():call if you want to check if VAUX1 and VAUX2 are ready to power on/
     run temperature tests.
  10) calcAvg(ArrayList<Float> List, float tempData):call if you want to take a changing 
      value put each iteration of the value in a list and average that list. Returns avg
*/

ControlP5 cp5;
color dialColorBoard = on;
color dialColorV1 = on;
color dialColorV2 = on;
Knob tempKnobBoard;
Knob tempKnobVicor1;
Knob tempKnobVicor2;
Chart tempChartBoard;
int numSamples = 64;
ArrayList<Float> avgVicor1List = new ArrayList<Float>(numSamples);
ArrayList<Float> avgVicor2List = new ArrayList<Float>(numSamples);
Table tempTable = new Table();
float newVal;
float tempVicor1Average;
float tempVicor2Average;
int tUnavailable = -130;

//Creates the dials (also called knobs or gauges).
//see Processing/File/Examples/Contributed Libraries/ControlP5/Controllers/Knob 
//for all functions in the knob class. 
void createDial(){
  cp5 = new ControlP5(this);
  //Makes board temperature knob
  tempKnobBoard = cp5.addKnob("Board Temperature (C)")
    .setRange(0, 200)
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
    .setRange(0, 200)
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
    .setRange(0, 200)
    .setValue(0)
    .setPosition(1020, 110)
    .setRadius(50)
    .setViewStyle(Knob.ARC)
    .setMoveable(false)
    .setColorForeground(dialColorV2)
    .setColorActive(dialColorV2)
    .setUpdate(true);   
    
  tempChartBoard = cp5.addChart("Board Temperature")
                      .setPosition(1200, 110)
                      .setSize(200,100)
                      .setRange(0, 150)
                      .setView(Chart.LINE)
                      .setStrokeWeight(1.5)
                      .setColorCaptionLabel(color(255))
                      .setLabel("Board Temperature");
                      
  tempChartBoard.addDataSet("incoming");
  tempChartBoard.setData("incoming", new float[100]);
}

//Draws the dials
void drawDial(){
  float tempBoard;
  float tempVicor1;
  float tempVicor2;
  tempBoard = tempBoard(pinA2.aRead());
  if (checkVaux()){
    tempVicor1 = tempVicor(pinA0.aRead());
    tempVicor2 = tempVicor(pinA1.aRead());
  }
  else {
    tempVicor1 = tUnavailable;
    tempVicor2 = tUnavailable;
  }
  if (tempBoard >= 90) {
    dialColorBoard = color(204, 0, 0); //red
  } 
  else dialColorBoard = on;
  if (tempVicor1 >= 90) {
    dialColorV1 = color(204, 0, 0); //red
  }
  else dialColorV1 = on;
  if (tempVicor2 >= 90) {
    dialColorV2 = color(204, 0, 0); //red
  }
  else dialColorV2 = on; 
  
  tempVicor1Average = calcAvg(avgVicor1List, tempVicor1);
  tempVicor2Average = calcAvg(avgVicor2List, tempVicor2);
  
  tempKnobBoard.setValue(tempBoard);
  tempKnobBoard.setColorForeground(dialColorBoard);
  tempKnobBoard.setColorActive(dialColorBoard);
  tempKnobVicor1.setValue(tempVicor1Average);
  tempKnobVicor1.setColorForeground(dialColorV1);
  tempKnobVicor1.setColorActive(dialColorV1);
  tempKnobVicor2.setValue(tempVicor2Average);
  tempKnobVicor2.setColorForeground(dialColorV2);
  tempKnobVicor2.setColorActive(dialColorV2);
  
  fill(255);
  textSize(10);
  text("0", 662, 200);
  text("0", 842, 200);
  text("0", 1022, 200);
  text("200", 750, 200);
  text("200", 930, 200);
  text("200", 1110, 200);
  
  textSize(24);
  text(round(tempBoard) + " ˚C", 680, 105);
  text(round(tempVicor1Average) + " ˚C", 860, 105); 
  text(round(tempVicor2Average) + " ˚C", 1040, 105); 
  
  tempChartBoard.push("incoming", tempBoard);
  
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
  tempTable.addColumn("VAUX1 state");
  tempTable.addColumn("VAUX2 state");
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
  if (pin3.dRead() == "HIGH") row.setInt("VAUX1 state", 1);
  else {
    row.setInt("VAUX1 state", 0);
    row.setFloat("Vicor1 Temperature", tempVicor1);
  }
  if (pin4.dRead() == "HIGH") row.setInt("VAUX2 state", 1);
  else {
    row.setInt("VAUX2 state", 0);
    row.setFloat("Vicor2 Temperature", tempVicor2);
  }
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

//Checks if VAUX1 and VAUX2 are HIGH to log temperature
boolean checkVaux(){
  if (pin3.dRead() == "HIGH" && pin4.dRead() == "HIGH"){
    return true;
  }
  else return false;
}

//Calculates average of a list of changing data
float calcAvg(ArrayList<Float> List, float tempData){
  if (List.size() == numSamples){
    List.remove(0);
  }
  List.add(tempData);
  float sum = 0;
  float out;
  for (float element : List) {
    sum += element;
  }
  out = sum / List.size();
  return out;
}