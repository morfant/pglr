// import java.util.Arrays; 
// import java.util.Collections;

import processing.sound.*;

boolean TWO_IN = false;
int bands = 512;
FFT fft, fft2;
AudioIn in, in2;
float[] spectrum = new float[bands];
float[] spectrum2 = new float[bands];

ArrayList<float[]> buffer = new ArrayList<float[]>();
int cnt = 0;
int visualizeMul = height * 20; // for amplify visualize
int visualizeMul2 = width; 
int step = 0; // step between value of spectrums
int stepVertex = 10; // step between vertices
int bufferLen = 220; // decide length of ground
int updateInterval = 1; // drawing spectrum interval
int c = 0;


void setup() {
  // size(1920, 512, OPENGL);
  // size(1920, 512, P3D);
  fullScreen(OPENGL);
  // fullScreen(P3D);
  smooth(8);
  background(0);
  rectMode(CENTER);
  noCursor();
  // frameRate(10);
  step = width/bands;


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
  background(0);
  fft.analyze(spectrum);

  if (TWO_IN) {
    fft2.analyze(spectrum2);
  }


  if (frameCount % updateInterval == 0) {

    float[] t = new float[bands];
    for (int i = 0; i < bands; i++) {
      t[i] = spectrum[i];
    }

    buffer.add(t);

    float mean = 0;
    for (int i = 0; i < bands-1; i++) {
      mean += buffer.get(buffer.size() - 1)[i];
    }
    mean = mean / bands;

    textSize(32);
    fill(255);
    text(mean, width-200, 100);

  }

  if (buffer.size() > bufferLen) {
    buffer.remove(0);
  }

  pushMatrix();
  float tx = width*2/3;
  float ty = height/2;
  translate(tx, ty, 0);
  rotateY(radians(map(mouseX, 0, 1920, -90, 90)));
  // rotateX(radians(map(mouseY, 0, 512, -90, 90)));
  // rotateZ(radians(90));

  for (int i = 0; i < buffer.size(); i++) { // BACKWARD
  // for (int i = buffer.size() - 1; i > 0; i--) { // FORWARD 
    strokeWeight(1);
    noStroke();
    // noFill();
    beginShape(TRIANGLE_STRIP);
    float[] spec = buffer.get(i);
    for (int j = 0; j < bands; j++)
    {
      fill(255 * spec[j] * 10, 255, 255);
      // vertex(j * step * 1 - tx, height - (spec[j] * visualizeMul) * 1 - ty, (i - buffer.size() - 1) * 10); // FORWARD
      vertex(j * step * 1 - tx, height - (spec[j] * visualizeMul) * 1 - ty, 200 -i * stepVertex); // BACKWARD
    }
    endShape();
  }
  popMatrix();


  // line
  // int maxIdx = maxIdxOfArr(spectrum);
  // points[cnt] = maxIdx;
  // radius[cnt] = spectrum[maxIdx];

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
  // popMatrix();

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



  cnt--;
  if (cnt < -500) {
    background(0, 10);

    // beginShape(TRIANGLE_STRIP);
    // for (int i = 0; i < points.length; i++) {
    //   stroke(0, 100, 200, 140);
    //   strokeWeight(radius[i]*900);
    //   if (random(1) > 0.90) {
    //     vertex(i, points[i] * 10);
    //   }
    // }
    // endShape();
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
