// import java.util.Arrays; 
// import java.util.Collections;

import processing.sound.*;

boolean TWO_IN = true;
int bands = 1024;
FFT fft, fft2;
AudioIn in, in2;
float[] spectrum = new float[bands];
float[] spectrum2 = new float[bands];

// PVector[] points = new PVector[1920];
// PVector[] points2 = new PVector[1920];

int[] points = new int[1920];
int[] points2 = new int[1920];
float[] radius = new float[1920];
float[] radius2 = new float[1920];

int cnt = 0;
int visualizeMul = width*4; // stream
int visualizeMul2 = width; // instrument

ArrayList<Circle> circles = new ArrayList<Circle>();

void setup() {
  // size(1920, 512, OPENGL);
  fullScreen();
  smooth(8);
  background(0);
  rectMode(CENTER);
  noCursor();


  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);

  // start the Audio Input
  in.start();

  // patch the AudioIn
  fft.input(in);

  if (TWO_IN) {
    fft2 = new FFT(this, bands);
    in2 = new AudioIn(this, 1);
    in2.start();
    fft2.input(in2);
  }
}      


void draw()
{
  // background(0);
  fft.analyze(spectrum);

  if (TWO_IN) {
    fft2.analyze(spectrum2);
  }

  pushMatrix();
  translate(0, -23);
  strokeWeight(1);
  for (int i = 0; i < bands; i++)
  {
    //stroke(255, spectrum[i] * visualizeMul * i);
    noStroke();
    // fill(255, spectrum[i] * visualizeMul * i);
    fill(255);
    //noFill();
    //rect(cnt, height-i, spectrum[i] * visualizeMul * i, spectrum[i] * visualizeMul * i);
    ellipse(width - cnt, height-i, spectrum[i] * visualizeMul * i * random(2), spectrum[i] * visualizeMul * i * random(2));
    // circles.add(new Circle(width, height-i, spectrum[i] * visualizeMul * i));
    // points[cnt] = (int)random(bands/2 - 100, bands/2 + 100);
  }

  // line
  int maxIdx = maxIdxOfArr(spectrum);
  points[cnt] = maxIdx;
  radius[cnt] = spectrum[maxIdx];

  if (TWO_IN) {
    for (int i = 0; i < bands; i++)
    {

      //stroke(255, spectrum2[i] * visualizeMul * i);
      //stroke(200, 10, 100);
      //noStroke();
      fill(255, 100, 100, spectrum2[i] * visualizeMul * i);
      //noFill();
      //rect(cnt, height-i, spectrum2[i] * visualizeMul * i, spectrum2[i] * visualizeMul * i);
      // ellipse(width - cnt, height-i, spectrum2[i] * visualizeMul2 * i + random(-10, 10), spectrum2[i] * visualizeMul2 * i + random(-10, 10));
      ellipse(width - cnt, height-i, spectrum2[i] * visualizeMul2 * i, spectrum2[i] * visualizeMul2 * i);
    }
  }
  popMatrix();

  /*
  for (int i = circles.size() - 1; i >= 0; i--) {
    Circle c = circles.get(i);
    if (c.isDie()) {
      circles.remove(i);
    }
  }

  for (Circle c : circles) {
    c.move();
    c.draw();
  }
  */



  cnt++;
  if (cnt >= width) {
    background(0, 10);

    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < points.length; i++) {
      stroke(0, 100, 200, 140);
      strokeWeight(radius[i]*900);
      if (random(1) > 0.90) {
        vertex(i, points[i] * 10);
      }
    }
    endShape();

    cnt = 0;
  }
}




int maxIdxOfArr(float[] arr) {

		float max = arr[0];
		int index = 0;

		for (int i = 0; i < arr.length; i++) 
		{
			if (max < arr[i]) {
				max = arr[i];
				index = i;
			}
    }

  return index;
}
