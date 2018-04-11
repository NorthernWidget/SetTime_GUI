/**
 * Simple Write. 
 * 
 * Check if the mouse is over a rectangle and writes the status to the serial port. 
 * This example works with the Wiring / Arduino program that follows below.
 */

static int SerialPortNum = 1;  //USER DEFINABLE

import processing.serial.*;
import java.util.*; 
import java.text.SimpleDateFormat;

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

PImage webImg;

void setup() 
{
  size(600, 400);
  background(0);
  
  String url = "https://avatars0.githubusercontent.com/u/5341107?v=3&s=200";
  // Load image from a web server
  webImg = loadImage(url, "png");
  
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
  print(Serial.list());
  String portName = Serial.list()[SerialPortNum];
  Logger = new Serial(this, portName, 38400);
}

void draw() {

  

  
//  while(true) {
  

  fill(255);
  ellipse(450, 250, 200, 200);
  image(webImg, 350, 150);
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
  
  
  
  
  
  if(Ping == false){
    Logger.write('A');
    //print("BANG!");
    if(Init == true){
    try{if(Val.contains("ALog")) Ping = true;
    } catch(NullPointerException e) {}
    }
    
    try{if(Val.contains("Logger initializing.")) Init = true;
    } catch(NullPointerException e) {}
  }
  
  try{if(Val.contains("computer?") || Val.contains("Uh-oh")){
    for(int i = 0; i < 10; i++){  //FIX kinda spamy
    Logger.write('g');
    //print("g"); //DEBUG!
    delay(10);
    }
    
    delay(100);
    //delay(2000);
    long TimeStamp = millis();
    while(millis() - TimeStamp < 3000){
     if(Logger.available() > 0){
       LoggerTimeDateInitial = Logger.readStringUntil('\n');
       CompTimeDateInitial = EpochToHuman(GetCompTimeEpoch());  //MOD
       //print("GOT IT!");
       break;
     }
     delay(5); 
    }
    if(Val.contains("Uh-oh")) { //Stuck in strange 2000 problem, why is this even needed?
      delay(3000);  //Really fraked up attempt to use existing call response, may this print statment laiden monstrosity find its appropriate level of hell... //DEBUG!
      Logger.write(LoggerSetTime());
      print("Y2K!"); //DEBUG!
    }
    

    //while(Logger.available() < 9) {  //FIX fixed number issue, or validate with minumum unix time
    //  //print("wait"); //DEBUG!
    //  delay(1);
    //}
    //println("FRAK");  //DEBUG!

    
        //print("BANG!"); //DEBUG!
    //println(LoggerTimeDateInitial.length());
    //LoggerTimeDateInitial.trim();
    LoggerTimeDateInitial = LoggerTimeDateInitial.substring(0, 10);
    LoggerTimeDateInitial = LoggerTimeDateInitial.trim(); //Remove leading whitespace
    //LoggerTimeDateInitial = LoggerTimeDateInitial.replaceAll("[^\\x00-\\x7F]", ""); //FIX, try to find better way to parse
   // LoggerTimeDateInitial.trim();
    //println(LoggerTimeDateInitial.length());
    print("Logger Time = ");
    println(EpochToHuman(LoggerTimeDateInitial));
    print("Comp Time = ");
    print(GetCompTimeEpoch());
    println(CompTimeDateInitial);
    
    PrintBox(CompTimeBox, CompTimeColor);
    PrintText(CompTimeLabel, TextColor, "Computer Time:"); 
  
    PrintBox(LoggerTimeBox, LoggerTimeColor);
    PrintText(LoggerTimeLabel, TextColor, "Logger Time:"); 
  
    PrintBox(ErrorBox, ErrorColor);
    PrintText(ErrorLabel, TextColor, "Error:"); 
  
    SetButtonColor = SetButtonColor_ACTIVE;
    SetButtonTextColor = color(0);
    PrintBox(SetButton, SetButtonColor);
    
    if(Val.contains("Uh-oh")) {
      SetButtonMessage = "Encountered\nY2K\nBug";
      //PrintText(SetLabel, SetButtonTextColor, "Encountered\nY2K\nBug");
    }
    else {
      SetButtonMessage = "Press to\n  Set\nLogger\n Time";
      //PrintText(SetLabel, SetButtonTextColor, SetButtonMessage);
    }
    PrintText(SetLabel, SetButtonTextColor, SetButtonMessage);
    PrintText(CompTimeData, TextColor, CompTimeDateInitial);
    PrintText(LoggerTimeData, TextColor, EpochToHuman(LoggerTimeDateInitial)); 
    PrintText(ErrorData, TextColor, str(abs(EpochToLong(LoggerTimeDateInitial) - GetCompTimeEpoch())) + " Seconds");
  }
  } catch(NullPointerException e) {
  //print("NULL POINTER ERROR!");
  }
  
  //DEBUG!
  try{if(Val.contains("(y/n)")) {
    SetReady = true;
    //Logger.write('y');
    //delay(10);
    //Logger.write("1606213134216x");
  } 
  }catch(NullPointerException e) {}
  
  //try{if(Val.contains("Uh-oh")) {
  //  //SetReady = true;
  //  //for(int i = 0; i < 10; i++){  //FIX kinda spamy
  //  Logger.write(LoggerSetTime());
  //  //print("g"); //DEBUG!
  //  //delay(10);
  //  //}
  //  //delay(10);
  //  //Logger.write("1606213134216x");
  //} 
  //}catch(NullPointerException e) {}
  
  if(SetReady == true && SetCommand == true){
    Logger.write('y');
    delay(10);
    Logger.write(LoggerSetTime());
    SetCommand = false; 
    delay(100);
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

String EpochToHuman(String EpochTime) {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd  HH:mm:ss");
    sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
    //String TimeDate = null;
    long Epoch = Long.parseLong(EpochTime);
    Date TimeDate = new Date(Epoch*1000);
    return sdf.format(TimeDate);
}

String EpochToHuman(long Epoch) {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd  HH:mm:ss");
    sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
    //String TimeDate = null;
    //long Epoch = Long.parseLong(EpochTime);
    Date TimeDate = new Date(Epoch*1000);
    return sdf.format(TimeDate);
}

long EpochToLong(String EpochTime) {
    long Epoch = Long.parseLong(EpochTime);
    return Epoch;
}

String LoggerSetTime() {
  SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd1HHmmss");
  sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
  //long Epoch = Long.parseLong(EpochTime);
  Date TimeDate = new Date();
  String DateTimeSet = sdf.format(TimeDate.getTime()) + "x";
  //String DateTimeSet = nf(year() % 100, 2) + nf(month(), 2) + nf(day(), 2) + "1" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + "x"; //FIX day of week placeholder 
  print(DateTimeSet); //DEBUG!
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



/*
  // Wiring/Arduino code:
 // Read data from the serial and turn ON or OFF a light depending on the value
 
 char val; // Data received from the serial port
 int ledPin = 4; // Set the pin to digital I/O 4
 
 void setup() {
 pinMode(ledPin, OUTPUT); // Set pin as OUTPUT
 Serial.begin(9600); // Start serial communication at 9600 bps
 }
 
 void loop() {
 while (Serial.available()) { // If data is available to read,
 val = Serial.read(); // read it and store it in val
 }
 if (val == 'H') { // If H was received
 digitalWrite(ledPin, HIGH); // turn the LED on
 } else {
 digitalWrite(ledPin, LOW); // Otherwise turn it OFF
 }
 delay(100); // Wait 100 milliseconds for next reading
 }
 
 */