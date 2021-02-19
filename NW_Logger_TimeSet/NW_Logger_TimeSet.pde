/**
  * Set Time Program for the Project Margay Data Logger
  * Developed by Bobby Schulz at Nohrthern Widget
  *
  * Compatible with modular Margay Library
  *
  * Version = 1.0.1
  *
  * "That's not fair. That's not fair at all. There was time now. There was, was all the time I needed..."
  * - Mr. Henery Bemis
 */

static int SerialPortNum = 32;  //USER DEFINABLE

import processing.serial.*;
import java.util.*; 
import java.text.SimpleDateFormat;
import java.util.Date;

static float Rad = 7;
static float TopPerimeter = 25; 
static float SidePerimeter = 20;
static float BoxSpacing = 25;

static float[] CompTimeBox = {SidePerimeter, TopPerimeter, 300, 100, Rad};
static float[] CompTimeLabel = {CompTimeBox[0] + 10, CompTimeBox[1] + 25};
static float[] CompTimeData = {CompTimeBox[0] + 10, CompTimeBox[1] + 50};

static float[] LoggerTimeBox = {SidePerimeter, CompTimeBox[1] + CompTimeBox[3] + BoxSpacing, 300, 100, Rad};
static float[] LoggerTimeLabel = {LoggerTimeBox[0] + 10, LoggerTimeBox[1] + 25};
static float[] LoggerTimeData = {LoggerTimeBox[0] + 10, LoggerTimeBox[1] + 50};

static float[] ErrorBox = {SidePerimeter, LoggerTimeBox[1] + LoggerTimeBox[3] + BoxSpacing, 300, 100, Rad};
static float[] ErrorLabel = {ErrorBox[0] + 10, ErrorBox[1] + 25};
static float[] ErrorData = {ErrorBox[0] + 10, ErrorBox[1] + 50};

static float[] SetButton = {CompTimeBox[0] + CompTimeBox[2] + BoxSpacing, CompTimeBox[1], 95, 95, Rad};
static float[] SetLabel = {SetButton[0] + 30, SetButton[1] + 35};
String SetButtonMessage = "Wait";
boolean SetOver = false;

static float[] CloseButton = {SetButton[0] + SetButton[2] + BoxSpacing, SetButton[1], 95, 95, Rad};
static float[] CloseLabel = {CloseButton[0] + 30, CloseButton[1] + 35};
boolean CloseOver = false;

color CompTimeColor = color(0, 0, 255);
color LoggerTimeColor = color(0, 150, 0);
color ErrorColor = color(100, 0, 0);

color SetButtonColor_LOCK = color(100);
color SetButtonColor_ACTIVE = color(255);
color SetButtonColor = color(100);
color SetButtonTextColor = color(255);

color CloseButtonColor = color(255);

color TextColor = color(255);

Serial Logger;  // Create object from Serial class
int val;        // Data received from the serial port

//GLOBALS
String Val = null;
boolean Ping = false;
boolean Init = false;
boolean SetReady = false;
boolean SetCommand = false;
String CompTimeDateInitial = null;
String LoggerTimeDateInitial = null;
long TimeError = 0;

PImage NWseal;

String portName = "";
void setup() 
{
  size(600, 400);
  background(0);
  
  // String url = "https://avatars0.githubusercontent.com/u/5341107?v=3&s=200";
  // Load image from a web server
  // Load image locally
  String url = "NWseal.png";
  NWseal = loadImage(url, "png");
  
  PrintBox(CompTimeBox, CompTimeColor);
  PrintText(CompTimeLabel, TextColor, "Computer Time:"); 
  
  PrintBox(LoggerTimeBox, LoggerTimeColor);
  PrintText(LoggerTimeLabel, TextColor, "Logger Time:"); 
  
  PrintBox(ErrorBox, ErrorColor);
  PrintText(ErrorLabel, TextColor, "Error:"); 
  
  PrintBox(SetButton, SetButtonColor_LOCK);
  PrintText(SetLabel, TextColor, "Set\nLogger\nTime");
  
  PrintBox(CloseButton, CloseButtonColor);
  PrintText(CloseLabel, color(0), "Push To\n Close");

  PrintText(CompTimeData, TextColor, "Initializing...");
  PrintText(LoggerTimeData, TextColor, "Initializing..."); 
  PrintText(ErrorData, TextColor, "Initializing...");
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  print("All available ports: ");
  print(Serial.list());
  
  boolean _exitflag = false;
  int i = 0;
  String portName;
  //print(Serial.list());
  while(i < Serial.list().length && !_exitflag){
    portName = Serial.list()[i];
    if(portName.substring(0, 3).equals("COM")){
      if(Integer.parseInt(portName.substring(3)) != 1 && Integer.parseInt(portName.substring(3)) != 3) break; //Exit only if not "COM1" or "COM3"
    }
    else if (portName.length() > 11){
      if (portName.substring(0,11).equals("/dev/ttyUSB")){
        break;
      }
    }
    else if (portName.length() > 17){
      if (portName.substring(0,17).equals("/dev/cu.usbserial")){
        break;
      }
      else if (portName.substring(0,18).equals("/dev/tty.usbserial")){
        break;
      }
    }
    i++;
    //print(i); //DEBUG!
  }
  SerialPortNum = i;
  //portName = "/dev/ttyUSB0"; //
  portName = Serial.list()[SerialPortNum];
  print("\n");
  print("Selected port: ");
  print(portName);
  print("\n");
  Logger = new Serial(this, portName, 38400);
}

void draw() {

  fill(255);
  ellipse(450, 250, 200, 200);
  image(NWseal, 350, 150);
  if(mouseOverRect(SetButton[0], SetButton[1], SetButton[2], SetButton[3])){
    SetOver = true;
    strokeWeight(5);
    stroke(0, 0, 175);
    PrintBox(SetButton, SetButtonColor);
    PrintText(SetLabel, SetButtonTextColor, SetButtonMessage);
    stroke(0);
  }
  else{
    SetOver = false;
    strokeWeight(5);
    stroke(SetButtonColor);
    PrintBox(SetButton, SetButtonColor);
    PrintText(SetLabel, SetButtonTextColor, SetButtonMessage); 
    stroke(0);
  }
  
  if(mouseOverRect(CloseButton[0], CloseButton[1], CloseButton[2], CloseButton[3])){
    CloseOver = true;
    strokeWeight(5);
    stroke(0, 0, 175);
    PrintBox(CloseButton, CloseButtonColor);
    PrintText(CloseLabel, color(0), "Push To\n Close");
    stroke(0);
  }
  else{
    CloseOver = false;
    strokeWeight(5);
    stroke(CloseButtonColor);
    PrintBox(CloseButton, CloseButtonColor);
    PrintText(CloseLabel, color(0), "Push To\n Close");
    stroke(0);
  }
  
  try{if(Val.contains("Timestamp")){
    LoggerTimeDateInitial = Val;
    CompTimeDateInitial = EpochToHuman(GetCompTimeEpoch());  //MOD
    LoggerTimeDateInitial = LoggerTimeDateInitial.substring(12, 31);
    TimeError = int(abs(HumanToEpoch(LoggerTimeDateInitial) - GetCompTimeEpoch()));
  }
    
    PrintBox(CompTimeBox, CompTimeColor);
    PrintText(CompTimeLabel, TextColor, "Computer Time:"); 
  
    PrintBox(LoggerTimeBox, LoggerTimeColor);
    PrintText(LoggerTimeLabel, TextColor, "Logger Time:"); 
  
    PrintBox(ErrorBox, ErrorColor);
    PrintText(ErrorLabel, TextColor, "Error:"); 
  
    SetButtonColor = SetButtonColor_ACTIVE;
    SetButtonTextColor = color(0);
    PrintBox(SetButton, SetButtonColor);
    
    SetButtonMessage = "Press to\n  Set\nLogger\n Time";
    
    PrintText(SetLabel, SetButtonTextColor, SetButtonMessage);
    PrintText(CompTimeData, TextColor, CompTimeDateInitial);
    PrintText(LoggerTimeData, TextColor, LoggerTimeDateInitial); 
    PrintText(ErrorData, TextColor, str(TimeError) + " Seconds");
  }
  catch(NullPointerException e) {
  }
  
  if(SetCommand == true){
    print("RESET!"); //DEBUG!
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
    print("Sent!"); //DEBUG!
    SetCommand = false; 
  }

  Val = Logger.readStringUntil('\n');
  if(Val != null){
    print(Val);
  }
  delay(1);
//  }
}

boolean mouseOverRect(float Xorg, float Yorg, float W, float H) { // Test if mouse is over square
  return ((mouseX >= Xorg) && (mouseX <= Xorg + W) && (mouseY >= Yorg) && (mouseY <= Yorg + H));
}

void mouseClicked() {
if(SetOver == true)  SetCommand = true;
  
  if(CloseOver == true)  exit();
}

String GetCompTime() {
    String TimeDate = year() + "-" + month() + "-" + day() + "  " + hour() + ":" + minute() + ":" + second();
    return TimeDate;
}

long GetCompTimeEpoch() {
   Date TimeDate = new Date();
   return TimeDate.getTime()/1000;
}

long HumanToEpoch(String HumanTime) {
    long epoch = 0;
    try {
      SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");     
      df.setTimeZone(TimeZone.getTimeZone("UTC"));
      Date date = df.parse(HumanTime);      
      epoch = date.getTime();
    } catch(Exception e) {
      e.printStackTrace();
      System.out.print("you get the ParseException");
    }
    return epoch/1000;
}

String EpochToHuman(String EpochTime) {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
    long Epoch = Long.parseLong(EpochTime);
    Date TimeDate = new Date(Epoch*1000);
    return sdf.format(TimeDate);
}

String EpochToHuman(long Epoch) {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd  HH:mm:ss");
    sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
    Date TimeDate = new Date(Epoch*1000);
    return sdf.format(TimeDate);
}

long EpochToLong(String EpochTime) {
    long Epoch = Long.parseLong(EpochTime);
    return Epoch;
}

String LoggerSetTime() {
  SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
  sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
  Date TimeDate = new Date();
  String DateTimeSet = sdf.format(TimeDate.getTime()) + "x";
  return DateTimeSet;
}


void PrintBox(float[] Coord, color Color) {
  fill(Color);
  rect(Coord[0], Coord[1], Coord[2], Coord[3], Coord[4]);
}

void PrintText(float[] Coord, color Color, String Text) {
  fill(Color);
  text(Text, Coord[0], Coord[1]); 
}
