# Installation

The following dependencies are needed to run the LegoStacks processing sketch.

* Install OpenCV and the Processing OpenCV library: http://ubaa.net/shared/processing/opencv/
* Install the Fullscreen API for Processing: http://www.superduper.org/processing/fullscreen_api/
* Install the ControlP5 library: http://www.sojamo.de/libraries/controlP5/#installation

# Physical setup
Open LegoStacks.pde with processing and run the application. The first time the main menu only contains the "Calibrate" option. 

To calibrate a stack, stack the lego pieces in the right order in front of the webcam and click on them from bottom to top after choosing "Calibrate" from the main menu. The pieces will be highlighted on the screen as they are recognized by the program. 

# How to play

Enter your user data and click "Play Now". The timer starts automatically and stops when the correct order for the lego pieces is detected.

# Tips

The recognition of Lego bricks is based on areas of homogenous color. 

* Despite the name, I actually used this program with Duplos, not Legos. The program can surely work with Legos, although the smaller size might be problematic.
* The recognition works best with a good webcam. Some older webcams have a lot of grain and low contrast, making the recognition difficult.
* The recognition works best in a well-lit environment with good ambient light. Direct sunlight or inconsistent lighting (for example, where people passing by can affect the lighting) don't work well.
* Try avoiding reflections on the surface of lego pieces.
* Putting a lamp on the side of the webcam can solve inconsistent lighting problems.
