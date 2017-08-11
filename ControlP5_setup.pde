Chart testChart1;
Chart testChart2;
Group Sensor7;
Knob hsi;

void controlp5Setup(){
  hsi = cp5.addKnob("blah")
           .setPosition(width/2-100, height-150)
           .setViewStyle(Knob.LINE)
           .setRange(0,50)
           .setValue(0)
           .setRadius(100)
           .setAngleRange(PI)
           .setStartAngle(PI)
           .setNumberOfTickMarks(15)
           .setColorForeground(color(255))
           .setColorBackground(color(100,100))
           .setColorActive(color(255))
           .setTickMarkWeight(2);
           
  //Group Thrusters = cp5.addGroup("Thrusters")
  //                   .setPosition(950,75)
  //                   .setFont(font)
  //                   .setWidth(300)
  //                   .setBarHeight(20)
  //                   .setColorBackground(blue)
  //                   .setColorForeground(active)
  //                   .setBackgroundHeight(200)
  //                   .setBackgroundColor(color(196,80))
  //                   .close();
                       
  //cp5.addScrollableList("Thrusters Info")
  //   .setGroup(Thrusters)
  //   .setPosition(100, 30)
  //   .addItems(java.util.Arrays.asList("Front","Back","Rear Propulsion"));
  
  Group Sensor1 = cp5.addGroup("DVL Position")
                     .setPosition(25,75)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Group Sensor2 = cp5.addGroup("Concentration")
                     .setPosition(25,200)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Group Sensor3 = cp5.addGroup("Temperature")
                     .setPosition(25,325)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Group Sensor4 = cp5.addGroup("Turbidity")
                     .setPosition(25,450)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Group Sensor5 = cp5.addGroup("Sensor5")
                     .setPosition(25,575)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Group Sensor6 = cp5.addGroup("Sensor6")
                     .setPosition(25,700)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Sensor7 = cp5.addGroup("Dissolved O2")
               .setPosition(200,75)
               .setFont(font)
               .setWidth(150)
               .setBarHeight(20)
               .setColorBackground(blue)
               .setColorForeground(active)
               .setBackgroundHeight(100)
               .setBackgroundColor(color(196,80))
               .close();
                     
  Group Sensor8 = cp5.addGroup("Sensor8")
                     .setPosition(200,200)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Group Sensor9 = cp5.addGroup("Sensor9")
                     .setPosition(200,325)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Group Sensor10 = cp5.addGroup("Sensor10")
                     .setPosition(200,450)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Group Sensor11 = cp5.addGroup("Sensor11")
                     .setPosition(200,575)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Group Sensor12 = cp5.addGroup("Sensor12")
                     .setPosition(200,700)
                     .setFont(font)
                     .setWidth(150)
                     .setBarHeight(20)
                     .setColorBackground(blue)
                     .setColorForeground(active)
                     .setBackgroundHeight(100)
                     .setBackgroundColor(color(196,80))
                     .close();
                     
  Knob testKnob1 = cp5.addKnob("data1")
                      .setRange(0, 50)
                      .setGroup(Sensor1)
                      .setPosition(45,10)
                      .setValue(0)
                      .setRadius(30)
                      .setViewStyle(Knob.LINE)
                      .setMoveable(false);
    
  testChart1 = cp5.addChart("dataflow")
                  .setGroup(Sensor2)
                  .setPosition(10,10)
                  .setSize(100,50)
                  .setRange(-20,20)
                  .setView(Chart.LINE)
                  .addDataSet("incoming")
                  .setData("incoming", new float[100]);
                  
  testChart2 = cp5.addChart("rando")
                  .setGroup(Sensor8)
                  .setPosition(10,10)
                  .setSize(100,50)
                  .setView(Chart.LINE);
}