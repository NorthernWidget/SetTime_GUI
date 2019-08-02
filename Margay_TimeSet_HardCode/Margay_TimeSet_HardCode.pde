/**
* ControlP5 Textfield
*
*
* find a list of public methods available for the Textfield Controller
* at the bottom of this sketch.
*
* by Andreas Schlegel, 2012
* www.sojamo.de/libraries/controlp5
*
*/

static int SerialPortNum = 32;  //USER DEFINABLE

import processing.serial.*;
import controlP5.*;

ControlP5 cp5;

String textValue = "";

static float Rad = 7;
static float TopPerimeter = 25; 
static float SidePerimeter = 20;
static float BoxSpacing = 25;

static float[] CompTimeBox = {SidePerimeter, TopPerimeter, 300, 100, Rad};
static float[] CompTimeLabel = {CompTimeBox[0] + 10, CompTimeBox[1] + 25};
static float[] CompTimeData = {CompTimeBox[0] + 10, CompTimeBox[1] + 50};

static float[] SetButton = {CompTimeBox[0] + CompTimeBox[2] + BoxSpacing, CompTimeBox[1], 95, 95, Rad};
static float[] SetLabel = {SetButton[0] + 30, SetButton[1] + 35};
String SetButtonMessage = "Wait";
boolean SetOver = false;
boolean CloseOver = false;

boolean SetCommand = false;

color SetButtonColor_LOCK = color(100);
color SetButtonColor_ACTIVE = color(255);
color SetButtonColor = color(100);
color SetButtonTextColor = color(255);

color TextColor = color(255);

int XAlign = 125;
int YAlign = 20;
int YStep = 60;
String Year, Month, Day, Hour, Minute, Second; //Initialize strings to pull values from 

String[] TextBoxNames = {"Year", "Month", "Day", "Hour", "Minute", "Second"};

static final int TXT_FIELDS = 6;
int txtFieldIdx = 0;

Serial Logger;  // Create object from Serial class

PImage webImg;

String portName = "";
void setup() {
  size(700,400);
  
  PFont font = loadFont("OCRAExtended-24.vlw");
  
  cp5 = new ControlP5(this);
  
  cp5.addTextfield("Year")
     .setPosition(XAlign,YAlign)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(TextColor)
     .setLabel("")
     .setAutoClear(false)
     ;
  
  cp5.addTextfield("Month")
     .setPosition(XAlign,YAlign + YStep)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(TextColor)
     .setLabel("")
     .setAutoClear(false)
     ;
  cp5.addTextfield("Day")
     .setPosition(XAlign,YAlign + 2*YStep)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(TextColor)
     .setLabel("")
     .setAutoClear(false)
     ;
   cp5.addTextfield("Hour")
     .setPosition(XAlign,YAlign + 3*YStep)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(TextColor)
     .setLabel("")
     .setAutoClear(false)
     ;
   cp5.addTextfield("Minute")
     .setPosition(XAlign,YAlign + 4*YStep)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(TextColor)
     .setLabel("")
     .setAutoClear(false)
     ;
   cp5.addTextfield("Second")
     .setPosition(XAlign,YAlign + 5*YStep)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(TextColor)
     .setLabel("")
     .setAutoClear(false)
     ;
                 
  //cp5.addTextfield("textValue")
  //   .setPosition(20,170)
  //   .setSize(200,40)
  //   .setFont(createFont("arial",20))
  //   .setAutoClear(false)
  //   ;
       
  cp5.addBang("clear")
     .setPosition(450, YAlign)
     .setSize(80,40)
     .setFont(font)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;    
     
  cp5.addBang("set")
     .setPosition(450, YAlign + YStep)
     .setSize(80,40)
     .setFont(font)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;    
  
  //cp5.addTextfield("default")
  //   .setPosition(20,350)
  //   .setAutoClear(false)
  //   ;
     
  textFont(font);
  
  String url = "https://avatars0.githubusercontent.com/u/5341107?v=3&s=200";
  // Load image from a web server
  webImg = loadImage(url, "png");
  
  print(Serial.list());
  
  boolean _exitflag = false;
  int i = 0;
  String portName;
  while(i < Serial.list().length && !_exitflag){
    portName = Serial.list()[i];
    if(portName.substring(0, 3).equals("COM")){
      if(Integer.parseInt(portName.substring(3)) != 1 && Integer.parseInt(portName.substring(3)) != 3) break; //Exit only if not "COM1" or "COM3"
    }
    else if (portName.length() > 11){
      if (portName.substring(11).equals("/dev/ttyUSB")){
        break;
      }
    }
    else if (portName.length() > 17){
      if (portName.substring(17).equals("/dev/cu.usbserial")){
        break;
      }
      else if (portName.substring(18).equals("/dev/tty.usbserial")){
        break;
      }
    }
    i++;
    //print(i); //DEBUG!
  }
  SerialPortNum = i;
  portName = Serial.list()[SerialPortNum];
  Logger = new Serial(this, portName, 38400);
}

void draw() {
  background(0);
  fill(255);
  //text(cp5.get(Textfield.class,"Year").getText(), 20, YAlign);
  //text(textValue, 360,180);
  text("Year", 20, YAlign + 25);
  text("Month", 20, YAlign + YStep + 25);
  text("Day", 20, YAlign + YStep*2 + 25);
  text("Hour", 20, YAlign + YStep*3 + 25);
  text("Minute", 20, YAlign + YStep*4 + 25);
  text("Second", 20, YAlign + YStep*5 + 25);
  
  fill(255);
  ellipse(450, 250, 200, 200);
  image(webImg, 350, 150);
  //if(mouseOverRect(SetButton[0], SetButton[1], SetButton[2], SetButton[3])){
  //  SetOver = true;
  //  strokeWeight(5);
  //  stroke(0, 0, 175);
  //  PrintBox(SetButton, SetButtonColor);
  //  PrintText(SetLabel, SetButtonTextColor, SetButtonMessage);
  //  stroke(0);
  //}
  //else{
  //  SetOver = false;
  //  strokeWeight(5);
  //  stroke(SetButtonColor);
  //  PrintBox(SetButton, SetButtonColor);
  //  PrintText(SetLabel, SetButtonTextColor, SetButtonMessage); 
  //  stroke(0);
  //}
  
  //if(SetCommand == true){
  //  print("RESET!"); //DEBUG!
  //  Logger.setDTR(false);  //Reset logger
  //  delay(10);
  //  Logger.setDTR(true);
  //  boolean Test = false;
  //  String Check = "";
  //  while(Test == false){
  //    Check = Logger.readStringUntil('\n');
  //    try{
  //      if(Check.contains("Init")) Test = true;
  //    }
  //    catch (NullPointerException e) {
        
  //    }
  //    if(Check != null) print(Check);
  //  }
  //  Logger.write(LoggerSetTime());
  //  print("Sent!"); //DEBUG!
  //  SetCommand = false; 
  //}
}

boolean mouseOverRect(float Xorg, float Yorg, float W, float H) { // Test if mouse is over square
  return ((mouseX >= Xorg) && (mouseX <= Xorg + W) && (mouseY >= Yorg) && (mouseY <= Yorg + H));
}

void mouseClicked() {
if(SetOver == true)  SetCommand = true;
  
  if(CloseOver == true)  exit();
}

void keyPressed() {
  final int k = keyCode;
 
  if (k == TAB) {
    cp5.get(Textfield.class, TextBoxNames[txtFieldIdx]).setFocus(false);
    if (++txtFieldIdx >= TXT_FIELDS)   txtFieldIdx = 0;
    cp5.get(Textfield.class, TextBoxNames[txtFieldIdx]).setFocus(true).clear();
  }
}

void PrintBox(float[] Coord, color Color) {
  fill(Color);
  rect(Coord[0], Coord[1], Coord[2], Coord[3], Coord[4]);
}

void PrintText(float[] Coord, color Color, String Text) {
  fill(Color);
  text(Text, Coord[0], Coord[1]); 
}

String LoggerSetTime() {
  String DateTimeSet = Year.substring(2,4) + Month + Day + Hour + Minute + Second + "x";  //Concatonate String
  print(DateTimeSet);
  return DateTimeSet;
}

public void clear() {
  //cp5.get(Textfield.class,"textValue").clear();
  cp5.get(Textfield.class,"Year").setValue("");
  cp5.get(Textfield.class,"Month").setValue("");
  cp5.get(Textfield.class,"Day").setValue("");
  cp5.get(Textfield.class,"Hour").setValue("");
  cp5.get(Textfield.class,"Minute").setValue("");
  cp5.get(Textfield.class,"Second").setValue("");
}

public void set() {
  print("RESET!"); //DEBUG!
    //cp5.get(Textfield.class,"Year").submit(); //Update values
    //cp5.get(Textfield.class,"Month").submit();
    //cp5.get(Textfield.class,"Day").submit();
    //cp5.get(Textfield.class,"Hour").submit();
    //cp5.get(Textfield.class,"Minute").submit();
    //cp5.get(Textfield.class,"Second").submit();
    Logger.setDTR(false);  //Reset logger
    delay(10);
    Logger.setDTR(true);
    boolean Test = false;
    String Check = "";
    while(Test == false){
      Check = Logger.readStringUntil('\n');
      try{
        if(Check.contains("Init")) Test = true;
      }
      catch (NullPointerException e) {
        
      }
      if(Check != null) print(Check);
    }

    Logger.write(LoggerSetTime());
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    //println("controlEvent: accessing a string from controller '"
    //        +theEvent.getName()+"': "
    //        +theEvent.getStringValue()
    //        );
    //switch(theEvent.getName()) {
    //  case "Year":
    //    Year = theEvent.getStringValue().substring(2, 4);
    //    break;
    //  case "Month":
    //    Month = theEvent.getStringValue();
    //    break;
    //  case "Day":
    //    Day = theEvent.getStringValue();
    //    break;
    //  case "Hour":
    //    Hour = theEvent.getStringValue();
    //    break;
    //  case "Minute":
    //    Minute = theEvent.getStringValue();
    //    break;
    //  case "Second":
    //    Second = theEvent.getStringValue();
    //    break;
    //}
  }
}


public void input(String theText) {
  // automatically receives results from controller input
  println("a textfield event for controller 'input' : "+theText);
}




/*
a list of all methods available for the Textfield Controller
use ControlP5.printPublicMethodsFor(Textfield.class);
to print the following list into the console.

You can find further details about class Textfield in the javadoc.

Format:
ClassName : returnType methodName(parameter type)


controlP5.Controller : CColor getColor() 
controlP5.Controller : ControlBehavior getBehavior() 
controlP5.Controller : ControlWindow getControlWindow() 
controlP5.Controller : ControlWindow getWindow() 
controlP5.Controller : ControllerProperty getProperty(String) 
controlP5.Controller : ControllerProperty getProperty(String, String) 
controlP5.Controller : ControllerView getView() 
controlP5.Controller : Label getCaptionLabel() 
controlP5.Controller : Label getValueLabel() 
controlP5.Controller : List getControllerPlugList() 
controlP5.Controller : Pointer getPointer() 
controlP5.Controller : String getAddress() 
controlP5.Controller : String getInfo() 
controlP5.Controller : String getName() 
controlP5.Controller : String getStringValue() 
controlP5.Controller : String toString() 
controlP5.Controller : Tab getTab() 
controlP5.Controller : Textfield addCallback(CallbackListener) 
controlP5.Controller : Textfield addListener(ControlListener) 
controlP5.Controller : Textfield addListenerFor(int, CallbackListener) 
controlP5.Controller : Textfield align(int, int, int, int) 
controlP5.Controller : Textfield bringToFront() 
controlP5.Controller : Textfield bringToFront(ControllerInterface) 
controlP5.Controller : Textfield hide() 
controlP5.Controller : Textfield linebreak() 
controlP5.Controller : Textfield listen(boolean) 
controlP5.Controller : Textfield lock() 
controlP5.Controller : Textfield onChange(CallbackListener) 
controlP5.Controller : Textfield onClick(CallbackListener) 
controlP5.Controller : Textfield onDoublePress(CallbackListener) 
controlP5.Controller : Textfield onDrag(CallbackListener) 
controlP5.Controller : Textfield onDraw(ControllerView) 
controlP5.Controller : Textfield onEndDrag(CallbackListener) 
controlP5.Controller : Textfield onEnter(CallbackListener) 
controlP5.Controller : Textfield onLeave(CallbackListener) 
controlP5.Controller : Textfield onMove(CallbackListener) 
controlP5.Controller : Textfield onPress(CallbackListener) 
controlP5.Controller : Textfield onRelease(CallbackListener) 
controlP5.Controller : Textfield onReleaseOutside(CallbackListener) 
controlP5.Controller : Textfield onStartDrag(CallbackListener) 
controlP5.Controller : Textfield onWheel(CallbackListener) 
controlP5.Controller : Textfield plugTo(Object) 
controlP5.Controller : Textfield plugTo(Object, String) 
controlP5.Controller : Textfield plugTo(Object[]) 
controlP5.Controller : Textfield plugTo(Object[], String) 
controlP5.Controller : Textfield registerProperty(String) 
controlP5.Controller : Textfield registerProperty(String, String) 
controlP5.Controller : Textfield registerTooltip(String) 
controlP5.Controller : Textfield removeBehavior() 
controlP5.Controller : Textfield removeCallback() 
controlP5.Controller : Textfield removeCallback(CallbackListener) 
controlP5.Controller : Textfield removeListener(ControlListener) 
controlP5.Controller : Textfield removeListenerFor(int, CallbackListener) 
controlP5.Controller : Textfield removeListenersFor(int) 
controlP5.Controller : Textfield removeProperty(String) 
controlP5.Controller : Textfield removeProperty(String, String) 
controlP5.Controller : Textfield setArrayValue(float[]) 
controlP5.Controller : Textfield setArrayValue(int, float) 
controlP5.Controller : Textfield setBehavior(ControlBehavior) 
controlP5.Controller : Textfield setBroadcast(boolean) 
controlP5.Controller : Textfield setCaptionLabel(String) 
controlP5.Controller : Textfield setColor(CColor) 
controlP5.Controller : Textfield setColorActive(int) 
controlP5.Controller : Textfield setColorBackground(int) 
controlP5.Controller : Textfield setColorCaptionLabel(int) 
controlP5.Controller : Textfield setColorForeground(int) 
controlP5.Controller : Textfield setColorLabel(int) 
controlP5.Controller : Textfield setColorValue(int) 
controlP5.Controller : Textfield setColorValueLabel(int) 
controlP5.Controller : Textfield setDecimalPrecision(int) 
controlP5.Controller : Textfield setDefaultValue(float) 
controlP5.Controller : Textfield setHeight(int) 
controlP5.Controller : Textfield setId(int) 
controlP5.Controller : Textfield setImage(PImage) 
controlP5.Controller : Textfield setImage(PImage, int) 
controlP5.Controller : Textfield setImages(PImage, PImage, PImage) 
controlP5.Controller : Textfield setImages(PImage, PImage, PImage, PImage) 
controlP5.Controller : Textfield setLabel(String) 
controlP5.Controller : Textfield setLabelVisible(boolean) 
controlP5.Controller : Textfield setLock(boolean) 
controlP5.Controller : Textfield setMax(float) 
controlP5.Controller : Textfield setMin(float) 
controlP5.Controller : Textfield setMouseOver(boolean) 
controlP5.Controller : Textfield setMoveable(boolean) 
controlP5.Controller : Textfield setPosition(float, float) 
controlP5.Controller : Textfield setPosition(float[]) 
controlP5.Controller : Textfield setSize(PImage) 
controlP5.Controller : Textfield setSize(int, int) 
controlP5.Controller : Textfield setStringValue(String) 
controlP5.Controller : Textfield setUpdate(boolean) 
controlP5.Controller : Textfield setValue(float) 
controlP5.Controller : Textfield setValueLabel(String) 
controlP5.Controller : Textfield setValueSelf(float) 
controlP5.Controller : Textfield setView(ControllerView) 
controlP5.Controller : Textfield setVisible(boolean) 
controlP5.Controller : Textfield setWidth(int) 
controlP5.Controller : Textfield show() 
controlP5.Controller : Textfield unlock() 
controlP5.Controller : Textfield unplugFrom(Object) 
controlP5.Controller : Textfield unplugFrom(Object[]) 
controlP5.Controller : Textfield unregisterTooltip() 
controlP5.Controller : Textfield update() 
controlP5.Controller : Textfield updateSize() 
controlP5.Controller : boolean isActive() 
controlP5.Controller : boolean isBroadcast() 
controlP5.Controller : boolean isInside() 
controlP5.Controller : boolean isLabelVisible() 
controlP5.Controller : boolean isListening() 
controlP5.Controller : boolean isLock() 
controlP5.Controller : boolean isMouseOver() 
controlP5.Controller : boolean isMousePressed() 
controlP5.Controller : boolean isMoveable() 
controlP5.Controller : boolean isUpdate() 
controlP5.Controller : boolean isVisible() 
controlP5.Controller : float getArrayValue(int) 
controlP5.Controller : float getDefaultValue() 
controlP5.Controller : float getMax() 
controlP5.Controller : float getMin() 
controlP5.Controller : float getValue() 
controlP5.Controller : float[] getAbsolutePosition() 
controlP5.Controller : float[] getArrayValue() 
controlP5.Controller : float[] getPosition() 
controlP5.Controller : int getDecimalPrecision() 
controlP5.Controller : int getHeight() 
controlP5.Controller : int getId() 
controlP5.Controller : int getWidth() 
controlP5.Controller : int listenerSize() 
controlP5.Controller : void remove() 
controlP5.Controller : void setView(ControllerView, int) 
controlP5.Textfield : String getText() 
controlP5.Textfield : String[] getTextList() 
controlP5.Textfield : Textfield clear() 
controlP5.Textfield : Textfield keepFocus(boolean) 
controlP5.Textfield : Textfield setAutoClear(boolean) 
controlP5.Textfield : Textfield setColor(int) 
controlP5.Textfield : Textfield setColorCursor(int) 
controlP5.Textfield : Textfield setFocus(boolean) 
controlP5.Textfield : Textfield setFont(ControlFont) 
controlP5.Textfield : Textfield setFont(PFont) 
controlP5.Textfield : Textfield setFont(int) 
controlP5.Textfield : Textfield setHeight(int) 
controlP5.Textfield : Textfield setInputFilter(int) 
controlP5.Textfield : Textfield setPasswordMode(boolean) 
controlP5.Textfield : Textfield setSize(int, int) 
controlP5.Textfield : Textfield setText(String) 
controlP5.Textfield : Textfield setValue(String) 
controlP5.Textfield : Textfield setValue(float) 
controlP5.Textfield : Textfield setWidth(int) 
controlP5.Textfield : Textfield submit() 
controlP5.Textfield : boolean isAutoClear() 
controlP5.Textfield : boolean isFocus() 
controlP5.Textfield : int getIndex() 
controlP5.Textfield : void draw(PGraphics) 
controlP5.Textfield : void keyEvent(KeyEvent) 
java.lang.Object : String toString() 
java.lang.Object : boolean equals(Object) 

created: 2015/03/24 12:21:31

*/
