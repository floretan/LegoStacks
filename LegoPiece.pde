
class LegoPiece {
  PVector position;
  color c;

  LegoPiece(color c) {
    this.position = new PVector();
    this.c = c;
  }

  void draw() {
    color reference = this.c;
    //    float r = red(reference), g = green(reference), b = blue(reference);
    //
    //    // Create difference image.
    //    PImage difference = opencv.image(opencv.SOURCE);
    //    for (int i = 0; i < difference.pixels.length; i++) {
    //
    //      float distance = sqrt(sq(r - red(difference.pixels[i])) +
    //        sq(g - green(difference.pixels[i])) + 
    //        sq(b - blue(difference.pixels[i])));
    //      difference.pixels[i] = color(255-distance);
    //    }

    float referenceHue = hue(reference);
    float referenceSaturation = saturation(reference);
    float brightnessReference = brightness(reference);

    // Create difference image.
    PImage difference = opencv.image(opencv.SOURCE);
    for (int i = 0; i < difference.pixels.length; i++) {
      float hueOffset = abs(hue(difference.pixels[i]) - referenceHue);
      float saturationOffset = abs(saturation(difference.pixels[i]) - referenceSaturation);
      float brightnessOffset = abs(brightness(difference.pixels[i]) - brightnessReference);

      // Hue is a cyclic set.
      if (hueOffset > 128) {
        hueOffset = 255 - hueOffset;
      }
      difference.pixels[i] = color(max(0, 255 - 4*hueOffset - saturationOffset - brightnessOffset));
    }

    difference.filter(THRESHOLD, .7); 
    opencv.copy(difference);


    Blob[] blobs = opencv.blobs(800, w*h/8, 1, false);

    for (int i=0; i<blobs.length; i++) {
      Point centroid = blobs[i].centroid;
      this.position.set((float)centroid.x, (float)centroid.y, 0.0);

      Point[] points = blobs[i].points;
      stroke(255);

      if (debugMode) {
        fill(reference);
      }
      else {
        fill(255, 255, 255, 128);
      }


      if (points.length > 0) {
        beginShape();
        for ( int j=0; j<points.length; j++ ) {
          vertex( points[j].x, points[j].y );
        }
        endShape(CLOSE);
      }
      point(centroid.x, centroid.y);
    }

    if (blobs.length == 0) {
      this.position.set(0, 0, 0);
    }
  }
}

