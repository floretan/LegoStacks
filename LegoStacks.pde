import fullscreen.*; 
import hypermedia.video.*;
import java.awt.*;
import java.util.List;
import controlP5.*;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;

FullScreen fs; 
OpenCV opencv;
ControlP5 controlP5;

// Set capture resolution.
int w = 320;
int h = 240;

int maxTime = 60000;
int cameraIndex = 8;

boolean debugMode = false;

int displayMode = 0;
final int DISPLAY_MENU = 0;
final int DISPLAY_REGISTER = 1;
final int DISPLAY_PLAY = 2;
final int DISPLAY_CALIBRATE = 3;
final int DISPLAY_RESULT = 4;

Participant participant;

PFont font;

LegoCollection collection;

controlP5.Textlabel titleLabel, timerLabel, resultTitleLabel, resultTimeLabel;
controlP5.Button playButton, calibrateButton;
controlP5.Button calibrateSaveButton, calibrateResetButton, calibrateCancelButton;

controlP5.Textfield nameField;
controlP5.Button startPlayButton, cancelPlayButton, newPlayButton, menuButton;

controlP5.ControlTimer timer;

PImage backgroundImage;

boolean ignoreClickHack = false;

void setup() {
  size(w, h);

  backgroundImage = loadImage("background.jpg");

  // Create the fullscreen object
  fs = new FullScreen(this); 
  fs.setResolution(w*2, h*2);

  // enter fullscreen mode
  fs.enter(); 

  font = loadFont("AndaleMono-48.vlw"); 
  textFont(font, 32);

  // Create the ControlP5 object for the user interface.
  controlP5 = new ControlP5(this);
  //  controlP5.setColorForeground(0xffaa0000);
  //  controlP5.setColorBackground(0xff660000);
  //  controlP5.setColorLabel(0xffdddddd);
  //  controlP5.setColorValue(0xffff88ff);
  //  controlP5.setColorActive(0xffff0000);

  titleLabel = controlP5.addTextlabel("titleLabel", "Lego Bootstrap", 10, 10);  

  playButton = controlP5.addButton("playButton", 0.0, 135, 80, 50, 20);
  playButton.setCaptionLabel("Play");
  calibrateButton = controlP5.addButton("calibrateButton", 0.0, 135, 110, 50, 20);
  calibrateButton.setCaptionLabel("Calibrate");
  hideMenu();

  calibrateSaveButton = controlP5.addButton("calibrateSaveButton");
  calibrateSaveButton.setCaptionLabel("Save");
  calibrateResetButton = controlP5.addButton("calibrateResetButton");
  calibrateResetButton.setCaptionLabel("Reset");
  calibrateCancelButton = controlP5.addButton("calibrateCancelButton");
  calibrateCancelButton.setCaptionLabel("Cancel");
  hideCalibrate();

  nameField = controlP5.addTextfield("nameField", 60, 60, 200, 20);
  nameField.setCaptionLabel("Your drupal.org username");
  nameField.setAutoClear(false);

  startPlayButton = controlP5.addButton("startPlayButton", 0.0, 60, 150, 50, 20);
  startPlayButton.setCaptionLabel("Play Now");
  cancelPlayButton = controlP5.addButton("cancelPlayButton", 0.0, 120, 150, 50, 20);
  cancelPlayButton.setCaptionLabel("Cancel");
  hideRegister();

  timerLabel = controlP5.addTextlabel("timerLabel", "", 10, 30); 
  hidePlay(); 

  resultTitleLabel = controlP5.addTextlabel("resultTitleLabel", "Congratulations", 110, 80);  
  resultTimeLabel = controlP5.addTextlabel("resultTimeLabel", "Your time", 135, 100);  

  newPlayButton = controlP5.addButton("newPlayButton", 0.0, 135, 130, 50, 20);
  newPlayButton.setCaptionLabel("New Game");

  menuButton = controlP5.addButton("menuButton", 0.0, 135, 160, 50, 20);
  menuButton.setCaptionLabel("Main Menu");
  hideResult();

  timer = new controlP5.ControlTimer();

  opencv = new OpenCV(this);
  opencv.capture(w, h, cameraIndex);

  participant = new Participant();

  collection = new LegoCollection();
  collection.load();
  showMenu();
}

void draw() {
  background(0);

  controlP5.draw();

  opencv.read();

  PImage original = opencv.image();

  switch(displayMode) {
  case DISPLAY_MENU:
  case DISPLAY_REGISTER:
  case DISPLAY_RESULT:
    image(backgroundImage, 0, 0, width, height);
    break;

  case DISPLAY_CALIBRATE:
    image(original, 0, 0, width, height);
    collection.draw();
    break;

  case DISPLAY_PLAY:
    image(original, 0, 0, width, height);
    timerLabel.setValue(timer.toString());
    collection.draw();
    if (timer.time() >= maxTime) {
      gameOver();
    }
    break;
  }
}

void gameOver() {
  participant.time = timer.time();

  participant.saveScore();

  displayMode = DISPLAY_RESULT;
  hidePlay();
  showResult();

  if (participant.time < maxTime) {
    resultTitleLabel.setValue("Congratulations " + participant.name + "!\nSee your ranking at lego.wunderkraut.com");
    resultTimeLabel.setValue(timer.toString());
  }
  else {
    resultTitleLabel.setValue("Sorry " + participant.name + "...");
    resultTimeLabel.setValue("Your time is over.");
  }
}

void mouseClicked() {
  if (displayMode == DISPLAY_CALIBRATE) {
    if (ignoreClickHack) {
      ignoreClickHack = false;
    }
    else {
      collection.pick(mouseX, mouseY);
    }
  }
}

void keyPressed() {
  // Switch debug mode on/off.
  if (key == 'd') {
    debugMode = !debugMode;
  }
}

/**************************
 * Widget event handlers. *
 **************************/
void calibrateButton(float theValue) {
  displayMode = DISPLAY_CALIBRATE;
  hideMenu();
  showCalibrate();  
  ignoreClickHack = true;
}

void calibrateSaveButton(float theValue) {
  collection.save();
  displayMode = DISPLAY_MENU;
  hideCalibrate();
  showMenu();
}

void calibrateResetButton(float theValue) {
  ignoreClickHack = true;
  collection.clear();
}

void calibrateCancelButton(float theValue) {
  displayMode = DISPLAY_MENU;
  hideCalibrate();
  showMenu();
}

void playButton(float theValue) {
  hideMenu();
  showRegister();
  nameField.setFocus(true);
}

void startPlayButton(float theValue) {
  participant.name = nameField.getText();

  displayMode = DISPLAY_PLAY;
  hideRegister();
  showPlay();
  timer.reset();
}
void cancelPlayButton(float theValue) {
  displayMode = DISPLAY_MENU;
  hideRegister();
  showMenu();
}

void newPlayButton(float theValue) {
  displayMode = DISPLAY_REGISTER;
  hideResult();
  showRegister();
}

void menuButton(float theValue) {
  displayMode = DISPLAY_MENU;
  hideResult();
  showMenu();
}

/************************************************************
 * Helper functions to hide/show different sets of widgets. *
 ************************************************************/
void hideMenu() {
  //  titleLabel.hide();
  playButton.hide();
  calibrateButton.hide();
}

void showMenu() {
  //  titleLabel.show();
  if (collection.size() > 0) {
    playButton.show();
  }
  calibrateButton.show();
}

void hideCalibrate() {
  calibrateSaveButton.hide();
  calibrateResetButton.hide();
  calibrateCancelButton.hide();
}
void showCalibrate() {
  calibrateSaveButton.show();
  calibrateResetButton.show();
  calibrateCancelButton.show();
}

void hideRegister() {
  nameField.hide();
  startPlayButton.hide();
  cancelPlayButton.hide();
}
void showRegister() {
  nameField.show();
  startPlayButton.show();
  cancelPlayButton.show();
}

void hidePlay() {
  timerLabel.hide();
}
void showPlay() {
  timerLabel.show();
}

void hideResult() {
  menuButton.hide();
  newPlayButton.hide();
  resultTitleLabel.hide();
  resultTimeLabel.hide();
}
void showResult() {
  menuButton.show();
  newPlayButton.show();
  resultTitleLabel.show();
  resultTimeLabel.show();
}

