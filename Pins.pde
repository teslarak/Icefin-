/*
Pin class tab - for creating, editing, and using pin objects to represent pins on 
the shield.

To create a pin, scroll to the bottom and write
Pin pinwhatyouwanttocallit = new Pin("name", pinNumber, "analog" or "digital", "in" 
or "out");

List of functions in this tab (name:how to use)
  1) setpinName(String name):call pin#.setpinName("name"); to set pin name
  2) setpinNumber(int number):call pin#.setpinNumber(number); to set a pin number 
     corresponding to the arduino pin number.
  3) setpinType(String type):call pin#.setpinType("analog" or "digital"); to set a pin
     as analog or digital.
  4) setpinInOut(String inout):call pin#.setpinInOut("in"/"IN"/"INPUT" or "out"); to 
     set a pin as an input or output.
  5) setpinState(String state):do not call this function to change to HIGH or LOW. 
     Instead use dWrite.
  6) dWrite(String state):call pin#.dWrite("HIGH" or "LOW") to write a digital pin 
     to HIGH or LOW.
  7) dRead():call pin#.dRead() to read a digital pin. To print the reading uncomment
     line 102 or write println(pin#.dRead());
  8) aRead():call pin#.aRead() to read an analog pin. To print write 
     println(pin#.aRead());
  9) printPin():call pin#.printPin() to print the pin's information.
  10) begin():sets the digital pins as inputs or output except ones that need to be set
      up differently. Is called in setup(). No need to call.

*/
public class Pin {
  String name;
  String type;
  String inOut;
  String state;
  int pinNumber;
  
  Pin (String name, int pinNumber, String type, String inOut){
    this.name = name;
    this.pinNumber = pinNumber;
    this.type = type;
    this.inOut = inOut;
  }

//Sets the name of the pin for reference  
  Pin setpinName(String name){
    this.name = name;
    return this;
  }

//Sets pinNumber corresponding to where it is plugged in on the Arduino  
  Pin setpinNumber(int number){
    this.pinNumber = number;
    return this;
  }

//Sets the pin type as analog or digital  
  Pin setpinType(String type){
    this.type = type;
    return this;
  }

//Sets the pin as INPUT or OUTPUT  
  Pin setpinInOut(String inout) {
    if (inout == "INPUT" || inout == "IN" || inout == "in") {
      arduino.pinMode(this.pinNumber, Arduino.INPUT); 
      this.inOut = "in";
    }
    else if (inout == "INPUT_PULLUP"){
      arduino.pinMode(this.pinNumber, Arduino.INPUT_PULLUP); 
      this.inOut = "in";
    }
    else {
      arduino.pinMode(this.pinNumber, Arduino.OUTPUT); 
      this.inOut = "out";
    }
    return this;
  }

//Sets the pinState to HIGH or LOW
  Pin setpinState(String state){
    this.state = state;
    return this;
  }

//Sets a digital pin as an output and writes HIGH or LOW to it
  Pin dWrite(String state){
    this.setpinInOut("OUTPUT");
    if (state == "HIGH") { 
      arduino.digitalWrite(this.pinNumber, Arduino.HIGH); 
      this.setpinState("HIGH");
    }
    else if (state == "LOW") {
      arduino.digitalWrite(this.pinNumber, Arduino.LOW); 
      this.setpinState("LOW");
    }
    return this;
  }

//Sets a digital pin as an input and reads HIGH or LOW
  String dRead(){
    this.setpinInOut("INPUT_PULLUP");
    int out = arduino.digitalRead(this.pinNumber);
    if (out == 0) {
      this.setpinState("HIGH");
    }
    else this.setpinState("LOW");
    //println(this.state);
    return this.state;
  }
  
//Reads an analog pin and returns a value between 0 and 1023  
  int aRead(){
    return arduino.analogRead(this.pinNumber);
  }

//Prints the pin with all its instance variables: name, pinNumber, type, inOut, and state  
  void printPin(){
    println(this.name, this.pinNumber, this.type, this.inOut, this.state);
  }
 
//Sets the digital pins as inputs or outputs depending on their inOut variable
  void begin(){
    if (this.type == "digital" && 
        this.pinNumber != 5 && 
        this.pinNumber != 6)
      {
      this.setpinInOut(this.inOut);
      }
    }
}
    
//Create new pins here with parameters: name, pinnumber, analog or digital, 
//and input or output.
Pin pinA0 = new Pin("TM1_DC_BUF", 0, "analog", "in");
Pin pinA1 = new Pin("TM2_DC_BUF", 1, "analog", "in");
Pin pinA2 = new Pin("BOARD_TMP_BUF", 2, "analog", "in");
Pin pin2 = new Pin("ISO_PULL_UP", 2, "digital", "out");
Pin pin3 = new Pin("VAUX1_OC", 3, "digital", "in");
Pin pin4 = new Pin("VAUX2_OC", 4, "digital", "in");
Pin pin5 = new Pin("LOAD_READY_ISO", 5, "digital", "in");
Pin pin6 = new Pin("OPTO_EN", 6, "digital", "out");
Pin test = new Pin("test", 13, "digital", "out");