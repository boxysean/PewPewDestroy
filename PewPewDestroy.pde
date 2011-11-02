// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan
// http://www.shiffman.net
// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing

import org.openkinect.*;
import org.openkinect.processing.*;

import maxlink.*;

import fullscreen.*; 

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;

FullScreen fs;

MaxLink link = new MaxLink(this, "sound");

boolean drawKinect = true;

Game game = new Game();

PImage[] playerImage;
PImage[] bulletImage;
PImage nightSky;

PImage[] bottomHP;
PImage[] glassHP;
PImage barHP;

PImage title;
PImage subtitle;

boolean gameOn = false;

void setup() {
  size(800,600);
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  
  link.output(4, "start");
  
  game.setup();
  
  fs = new FullScreen(this);
  // DO WE NEED TO ADJUST RESOLUTION HeRE?
//  fs.setResolution(width-10, height-10);
//  fs.enter();
  
  playerImage = new PImage[] { loadImage("popoplayer.png"), loadImage("chochoplayer.png") };
  bulletImage = new PImage[] { loadImage("bluebullet.png"), loadImage("redbullet.png") };
  nightSky = loadImage("nightsky.png");
  
  bottomHP = new PImage[] { loadImage("bottomhealthleft.png"), loadImage("bottomhealthright.png") };
  glassHP = new PImage[] { loadImage("glassleft.png"), loadImage("glassright.png") };
  barHP = loadImage("healthbar.png");
  
  title = loadImage("title.png");
  subtitle = loadImage("subtitle.png");
}

void draw() {
  image(nightSky, 0, 0);
  
  if (drawKinect) {
//    background(255);
  
    // Run the tracking analysis
    tracker.track();
    // Show the image
    tracker.display();
  
    // Let's draw the raw location
    PVector v1 = tracker.getPos1();
    fill(255,128,128,200);
    noStroke();
    ellipse(v1.x,v1.y,20,20);
  
    game.players[0].moveTo(v1.y);
  
    // Let's draw the "lerped" location
    PVector v2 = tracker.getPos2();
    fill(128,128,255,200);
    noStroke();
    ellipse(v2.x,v2.y,20,20);
    
    game.players[1].moveTo(v2.y);
    
    // Display some info
//    int t = tracker.getThreshold();
//    fill(0);
//    text("threshold: " + t + "    " +  "framerate: " + (int)frameRate + "    " + "UP increase threshold, DOWN decrease threshold",10,500);
  }
  
  game.draw();
}

void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } 
    else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
  
  game.keyPressed();
}

void stop() {
  tracker.quit();
  super.stop();
}

