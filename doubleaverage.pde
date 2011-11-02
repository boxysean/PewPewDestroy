// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan
// http://www.shiffman.net
// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing

import org.openkinect.*;
import org.openkinect.processing.*;

// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;

boolean drawKinect = true;

Game game = new Game();

void setup() {
  size(640,520);
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  game.setup();
}

void draw() {
  if (drawKinect) {
    background(255);
  
    // Run the tracking analysis
    tracker.track();
    // Show the image
    tracker.display();
  
    // Let's draw the raw location
    PVector v1 = tracker.getPos1();
    fill(128,128,255,200);
    noStroke();
    ellipse(v1.x,v1.y,20,20);
  
    game.players[0].moveTo(v1.y);
  
    // Let's draw the "lerped" location
    PVector v2 = tracker.getPos2();
    fill(255,128,128,200);
    noStroke();
    ellipse(v2.x,v2.y,20,20);
    
    game.players[1].moveTo(v2.y);
    
    // Display some info
    int t = tracker.getThreshold();
    fill(0);
    text("threshold: " + t + "    " +  "framerate: " + (int)frameRate + "    " + "UP increase threshold, DOWN decrease threshold",10,500);
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

