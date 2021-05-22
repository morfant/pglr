// import java.util.Arrays; 
// import java.util.Collections;

import processing.sound.*;
SoundFile file;
Amplitude amp;
boolean TWO_IN = false;
int bands = 512;
FFT fft;
AudioIn in;
float[] spectrum = new float[bands];

int[] points = new int[1920];
float[] radius = new float[1920];

int cnt = 0;
int visualizeMul = 0; // stream

ArrayList<Circle> circles = new ArrayList<Circle>();
ArrayList<Cochlear> cocs = new ArrayList<Cochlear>();

void setup() {
  // size(1280, 720); // HD
  // size(640, 360); // HD /2
  frameRate(15);
   fullScreen();
  // smooth(8);
  background(255);
  //rectMode(CENTER);
   noCursor();

  visualizeMul = width; // stream
  // Load a soundfile from the /data folder of the sketch and play it back
  file = new SoundFile(this, "sleeve.mp3");
  file.play();


  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  // in = new AudioIn(this, 0);
  // in.start();

  // patch the AudioIn
  fft.input(file);


  // amp = new Amplitude(this);
  // amp.input(file);
  
  
  for (int i = 0; i < 4; i++) {
   cocs.add(
     new Cochlear(
       width/2 - (width/10*4) + (width/12 * i),
       height/2 + height/3 - (height/10 * i)));
  }
  
    Cochlear co = cocs.get(0);
    co.setStartTime(0);

    co = cocs.get(1);
    co.setStartTime(0);

    co = cocs.get(2);
    co.setStartTime(1000);

    co = cocs.get(3);
    co.setStartTime(500);


  // for (int i = 0; i < 3; i++) {
  //   cocs.add(
  //     new Cochlear(width/8, height/8, i * 15)
  //   );
  // }

  // for (int i = 0; i < 1; i++) {
  //  cocs.add(
  //    new Cochlear(width/2 + width/4, height/2)
  //  );
  // }

}      


void draw()
{
  background(255);
  
  fft.analyze(spectrum);

  pushMatrix();
  translate(0, -23);
  strokeWeight(1);
  // for (int i = 0; i < bands; i++)
  // {
  //   //stroke(255, spectrum[i] * visualizeMul * i);
  //   noStroke();
  //   // fill(255, spectrum[i] * visualizeMul * i);
  //   fill(5);
  //   //noFill();
  //   //rect(cnt, height-i, spectrum[i] * visualizeMul * i, spectrum[i] * visualizeMul * i);
  //   ellipse(width - cnt, height-i, spectrum[i] * visualizeMul * i, 1);
  //   // circles.add(new Circle(width, height-i, spectrum[i] * visualizeMul * i));
  //   // points[cnt] = (int)random(bands/2 - 100, bands/2 + 100);
  // }

  // line
  int maxIdx = maxIdxOfArr(spectrum);
  points[cnt] = maxIdx;
  radius[cnt] = spectrum[maxIdx];


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

  int a = 4;
  int b = 3;
  int c = 1;

  // println(spectrum[500]);
 
  for (int i = 0; i < a; i++) {
    Cochlear co = cocs.get(i);
    co.setCoefs(spectrum[300] * visualizeMul, spectrum[400] * visualizeMul);
    // co.setCoefs(1, 0.1);
    co.setOffsetStep(spectrum[300] * visualizeMul/3);
    co.update();
    co.draw();
    
  }


  // for (int i = a; i < (a + b); i++) {
  //   // cocs.add(
  //   //   new Cochlear(width/8, height/8, i * 15)
  //   // );
  //   cocs.get(i).draw();
  // }

  // for (int i = (a + b); i < (a + b + c); i++) {
  // //  cocs.add(
  // //    new Cochlear(width/2 + width/4, height/2)
  // //  );
  //   cocs.get(i).draw();
  // }



  // for (Cochlear co : cocs) {
  //   co.draw();
  // }


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
