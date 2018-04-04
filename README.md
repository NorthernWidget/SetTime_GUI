# SetTime_GUI
A series of GUI based systems for setting the clock of the ALog (or other Arduino compatable systems which use the DS3231 RTC) based on computer time 

## Usage
This program is built to run within the Processing IDE, this program can be found, along with download instructions, on the [Processing](https://processing.org/download/) website.

This program also requires the use of the [ALog library](https://github.com/NorthernWidget/ALog) and an example sketch contained within the ALog library. 
	*Note:* This will likely change in the future in favor of a more generic and self contained option

To use this program to set your clock, you must go through the following steps:
1. Open "ALog_TimeSet.pde" in your Processing IDE
2. Open "one_thermistor" from the ALog examples folder, upload this program to your Logger board
3. Then run "ALog_TimeSet.pde" (this is done by pressing the play button in the upper left of the Processing IDE), it is important that this is run *after* the Logger board has the code uploaded
4. As a result of the previous step a window will open (as seen below), this window will load with values from RTC on board the logger and the computer time
5. Once this screen has loaded, you will see the current time on your computer in the top (blue) box, make sure this time is, in fact, correct! Below in the (in the green box), you will see the current logger time, and finally in the bottom (red) box, you will see how large the error is between the two devices
	* If the error is acceptable or 0, then you are ready to go! Press push to close in the upper right corner to end the program.
	* If, more likey, the logger is not set, or the setting has drifted significantly, press the "Set Logger Time" button in the upper middle of the window. Give the system a few seconds to perform the setting, then go ahead and close the window by pressing "Push to Close" in the upper right corner
6. (Optional) Once you have set the time, it is a good practice to verify this was sucessful, to do this simply re-run the Processing script and observe the times. Running the program only gets the values, it will not set them unless you press the set time button, so you can always re-run the program to check the setting. After this, close the program in the same manor as before.

### Program is in the process of getting time from the logger
![](WaitingForTime.png?raw=true "Title")

### Time has been read into the program
![](LoadedTime.png?raw=true "Title")

*Note*: This program was designed to used the first serial port which is available, this is generally fine, but can cause problems if you have more than one serial device connected to your computer. If you are not able to connect to the board, scroll up and look at the first line of the serial terminal (it will be displayed in the box underneath the code in the IDE). This line should read like "COM1 COM12", if not, if instead it looks like "COM1 COM3 COM12 COM15", then try unplugging other devices which could be using a serial port, such as FTDI converters or other Arduinos or logger boards. If this still does not work, determine which one of these COM ports belongs to your logger, and enter its location in this list (the list begins at 0, so in our example COM1 would be element 0, COM3 would be element 1, etc...) in this line near the top of the Processing code '<static int SerialPortNum = 1;  //USER DEFINABLE>' and re-run the code. It should be noted this is a workaround currently and this problem will be fixed in the future, scouts honor! 