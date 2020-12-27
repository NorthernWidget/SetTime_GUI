# SetTime_GUI
A series of GUI based systems for setting the clock of the ALog (or other Arduino compatible systems which use the DS3231 RTC) based on computer time

## Usage

### Running within Processing

This program is built to run within the Processing IDE. Processing can be found, along with download instructions, on the [Processing](https://processing.org/download/) website.

For this option, you will also have to clone/save a copy of this repository on your local computer.

### Running outside of Processing

Don't want to download Processing? No problem. You can install prepared Java executables for:
* [64-bit Linux](https://drive.google.com/file/d/1gW2tnu2t9jABWCnqmpSAMX8eulWXuIyv/view?usp=sharing)
* [64-bit Windows](https://drive.google.com/file/d/1jLe1Z-629XJ8ikFgR_EwZZ-dWOePTuzI/view?usp=sharing)

### Setting your clock

*For the A/V-inclined, [this video](https://youtu.be/q0fVwhMNLZg) shows you how to set the time on your logger after installing SetTime_GUI.*

To use this program to set your clock, you must go through the following steps:

1. Make sure a Margay or Resnik Library compatible program is loaded onto the logger. This is any code incorporating and intantiating `Margay.h` or `Resnik.h`.
2. Plug the logger into the computer via the micro-USB cable.

#### If using Processing

3. Open `Margay_TimeSet.pde` in your Processing IDE (this file can be acquired by using the green **Clone or Download** button in the upper right of the [GitHub Repo](https://github.com/NorthernWidget/SetTime_GUI) screen. Press this button, then **Download Zip**, then simply extract it using your preferred method)
4. Then run `NW_Logger_TimeSet.pde` (this is done by pressing the play button in the upper left of the Processing IDE).

#### If using the executable

3. Open the executable file. Note that you may need to download/update Java for it to run on Windows; the Linux version is bundled with local Java libraries.
4. [Nothing! Celebrate that you're using the executable and that it's easy.]

#### For either method

5. As a result of the previous step, a window will open. This window will load with values from RTC on board the logger and the computer time.

**Program is in the process of getting time from the logger**
![](WaitingForTime.png?raw=true "Title")

6. Once this screen has loaded, you will see the current time on your computer in the top (blue) box. Make sure this time is, in fact, correct! Below in the (in the green box), you will see the current logger time, and finally in the bottom (red) box, you will see how large the error is between the two devices
	* If the error is acceptable or 0, then you are ready to go! Press push to close in the upper right corner to end the program.
	* If, more likely, the logger is not set, or the setting has drifted significantly, press the "Set Logger Time" button in the upper middle of the window. Give the system a few seconds to perform the setting, then an updated time will appear. If this time setting is correct, then go ahead and close the window by pressing "Push to Close" in the upper right corner.

**Time has been read into the program**
![](LoadedTime.png?raw=true "Title")

At this point, the time should be set and your logger should be ready to go to the field.

### Note

This program was designed to used the first serial port which is available, this is generally fine, but can cause problems if you have more than one serial device connected to your computer. If you are not able to connect to the board, scroll up and look at the first line of the serial terminal (it will be displayed in the box underneath the code in the IDE). This line should read like "COM1 COM12", if not, if instead it looks like "COM1 COM3 COM12 COM15", then try unplugging other devices which could be using a serial port, such as FTDI converters or other Arduino or logger boards. If this still does not work, determine which one of these COM ports belongs to your logger, and enter its location in this list (the list begins at 0, so in our example COM1 would be element 0, COM3 would be element 1, etc...) in this line near the top of the Processing code `static int SerialPortNum = 1;  //USER DEFINABLE` and re-run the code. It should be noted this is a workaround currently and this problem will be fixed in the future, scouts honor!

### Y2K Bug

If you ever see a message regarding a Y2K bug, simply rerun the program and it should fix it. This is an issue which comes up as a result of the way the firmware was written which goes on the logger, the logger firmware for time setting is currently legacy and we **will** be changing this to make it more modular across device platforms and to not have to deal with Y2K in the year 2018
