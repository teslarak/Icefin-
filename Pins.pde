public class Pin {
  String state;
  String name;
  int pinNumber;
  String type;
  String inOut;
  
  Pin (String name, int pinNumber, String type, String inOut){
    this.name = name;
    this.pinNumber = pinNumber;
    this.type = type;
    this.inOut = inOut;
  }
  
  Pin setpinName(String name){
    this.name = name;
    return this;
  }
  
  Pin setpinNumber(int number){
    this.pinNumber = number;
    return this;
  }
  
  Pin setpinType(String type){
    this.type = type;
    return this;
  }
  
  Pin setpinInOut(String inout){
    if (inout == "INPUT" || inout == "IN") {
      arduino.pinMode(this.pinNumber, arduino.INPUT); 
      this.inOut = "in";
    }
    else {arduino.pinMode(this.pinNumber, arduino.OUTPUT); this.inOut = "out";}
    return this;
  }
  
  Pin setpinState(String state){
    this.state = state;
    return this;
  }

  Pin dWrite(String state){
    this.setpinInOut("OUTPUT");
    if (state == "HIGH"){ 
      arduino.digitalWrite(this.pinNumber, arduino.HIGH); 
      this.setpinState("HIGH");
    }
    else {
      arduino.digitalWrite(this.pinNumber, arduino.LOW); 
      this.setpinState("LOW");
    }
    return this;
  }
  
  String dRead(){
    this.setpinInOut("INPUT");
    arduino.digitalRead(this.pinNumber);
    return this.state;
  }
  
  int aRead(){
    return arduino.analogRead(this.pinNumber);
  }
  
  void printPin() {
    println(this.name, this.pinNumber, this.type, this.inOut, this.state);
  }
 
  //sets the digital pins as inputs or outputs
  void begin(){
    if (this.type == "digital"){
      this.setpinInOut(this.inOut);
      }
    }
}
    
//create new pins here with parameters: name, pinnumber, analog or digital, 
// and input or output.
//setter("TM1_DC_BUF", 0, "analog", "in");
Pin pinA0 = new Pin("TM1_DC_BUF", 0, "analog", "in");
Pin pinA1 = new Pin("TM2_DC_BUF", 1, "analog", "in");
Pin pinA2 = new Pin("BOARD_TMP_BUF", 2, "analog", "in");
Pin pin2 = new Pin("ISO_PULL_UP", 2, "digital", "out");
Pin pin3 = new Pin("VAUX1_OC", 3, "digital", "in");
Pin pin4 = new Pin("VAUX2_OC", 4, "digital", "in");
Pin pin5 = new Pin("LOAD_READY_ISO", 5, "digital", "in");
Pin pin6 = new Pin("OPTO_EN", 6, "digital", "out");
Pin test = new Pin("test", 13, "digital", "out");