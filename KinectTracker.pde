class KinectTracker {



  // Size of kinect image
  int kw = 640;
  int kh = 480;
  
  int tw = 800;
  int th = 600;
  
  int threshold = 745;

  // Raw location
  PVector loc1;
  PVector loc2;

  // Interpolated location
  PVector lerpedLoc;

  // Depth data
  int[] depth;


  PImage display;

  KinectTracker() {
    kinect.start();
    kinect.enableDepth(true);

    // We could skip processing the grayscale image for efficiency
    // but this example is just demonstrating everything
    kinect.processDepthImage(true);

    display = createImage(tw,th,PConstants.RGB);

    loc1 = new PVector(0,0);
    loc2 = new PVector(kw/2,0);
    lerpedLoc = new PVector(0,0);
  }

  void track() {

    // Get the raw depth as array of integers
    depth = kinect.getRawDepth();

    // Being overly cautious here
    //if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float count = 0;

    for(int x = 0; x < tw/2; x++) {
      for(int y = 0; y < th; y++) {
        int xx = (kw * x) / tw;
        int yy = (kh * y) / th;
        
        // Mirroring the image
        int offset = kw-xx-1+yy*kw;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }
    // As long as we found something
    if (count != 0) {
      loc1 = new PVector(sumX/count,sumY/count);
    }
    sumX=sumY=count=0;
    for(int x = tw/2; x < tw; x++) {
      for(int y = 0; y < th; y++) {
        int xx = (kw * x) / tw;
        int yy = (kh * y) / th;

        // Mirroring the image
        int offset = kw-xx-1+yy*kw;
        // Grabbing the raw depth
        int rawDepth = depth[offset];

        // Testing against threshold
        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }
    // As long as we found something
    if (count != 0) {
      loc2 = new PVector(sumX/count,sumY/count);
    }
  }


  PVector getPos1() {
    return loc1;
  }

  PVector getPos2() {
    return loc2;
  }

  void display() {
    PImage img = kinect.getDepthImage();

    // Being overly cautious here
    if (depth == null || img == null) return;

    // Going to rewrite the depth image to show which pixels are in threshold
    // A lot of this is redundant, but this is just for demonstration purposes
    display.loadPixels();
    for(int x = 0; x < tw; x++) {
      for(int y = 0; y < th; y++) {
        int xx = (kw * x) / tw;
        int yy = (kh * y) / th;

        // mirroring image
        int offset = kw-xx-1+yy*kw;
        // Raw depth
        int rawDepth = depth[offset];

        int pix = x+y*display.width;
        if (rawDepth < threshold) {
          // A red color instead
          display.pixels[pix] = color(150,50,50, 150);
        } 
        else {
//          display.pixels[pix] = img.pixels[offset];
//          display.pixels[pix] = #000000;
          display.pixels[pix] = nightSky.pixels[pix];
        }
      }
    }
    display.updatePixels();

    // Draw the image
    image(display,0,0);
  }

  void quit() {
    kinect.quit();
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }
}

