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

  //sets the digital pins as inputs or outputs
  void begin(){
    if (this.type == "digital"){
      if (this.inOut == "in"){
        arduino.pinMode(this.pinNumber, arduino.INPUT);
      }
      else arduino.pinMode(this.pinNumber, arduino.OUTPUT);
      }
    }
}
    
//create new pins here with parameters: name, pinnumber, analog or digital, 
// and input or output.
Pin pinA0 = new Pin("TM1_DC_BUF", 0, "analog", "in");
Pin pinA1 = new Pin("TM2_DC_BUF", 1, "analog", "in");
Pin pinA2 = new Pin("BOARD_TMP_BUF", 2, "analog", "in");
Pin pin2 = new Pin("ISO_PULL_UP", 2, "digital", "out");
Pin pin3 = new Pin("VAUX1_OC", 3, "digital", "in");
Pin pin4 = new Pin("VAUX2_OC", 4, "digital", "in");
Pin pin5 = new Pin("LOAD_READY_ISO", 5, "digital", "in");
Pin pin6 = new Pin("OPTO_EN", 6, "digital", "out");
Pin test = new Pin("test", 13, "digital", "out");