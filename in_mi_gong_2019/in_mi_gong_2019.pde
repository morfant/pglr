
import java.io.*;
import processing.sound.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Amplitude amp;
AudioIn in;

float ampThr1 = 0.005;
float ampThr2 = 0.2; // figure change threshold

// in jeokdo
float mulAmp1 = 4600;

ArrayList<Figure> figures = new ArrayList<Figure>();

FFT fft;
int bands = 1024;
float[] spectrum = new float[bands];

int pitchInterval = 0;
boolean pitchGrabbed = false;
int pitch = 0;

float baseLineY = 0;

int pad = 10;

// blue
//int r1 = 10;
//int g1 = 80;
//int b1 = 200;
//int a1 = 200;

int r1 = 255;
int g1 = 255;
int b1 = 255;
int a1 = 255;


boolean isReset = false;
boolean makeGoAround = false;
boolean makeBlack = false;
boolean circleOverwhelm = false;
float newValue;
float vAngle1 = -0.5;

// to save writing as a file
// ArrayList<Figure> loadedFigures;

int figureType = 2;

void setup() {
  size(1280, 900);
   //size(1920, 1080);
  // fullScreen();
  background(255);
  rectMode(CENTER);
  noCursor();

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  Sound.list();
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);

  // guitar rig
  in = new AudioIn(this, 0); // piano

  in.start();

  amp.input(in);

  fft = new FFT(this, bands);
  fft.input(in);

  baseLineY = height/2 + 300;

}

void draw() {

  if (makeBlack) {
    background(0, 0, 0, 255);
  } else {
    background(0, 255);
  }

  if (circleOverwhelm) {
    background(0);
  }

  fft.analyze(spectrum);

  int pitchIdx = getMaxValIdx(spectrum);

  // Update buffer
  newValue = amp.analyze(); // input ch 1


  // ------------------------------------------------------------- 1 figures -------------------------------------------------------------------
  if (newValue > ampThr1) {

    // println(pitchIdx);
    if (newValue > ampThr2){
      figureType = (int)random(0, 10);
    }

    if (pitchGrabbed == false) {
      pitch = pitchIdx;
      pitchGrabbed = true;
      pitchInterval = 0;
    }

    if (pitchInterval > 10) {
      pitchGrabbed = false;
      pitchInterval = 0;
    }

    if (!makeBlack) {
      float v = newValue;
      // Figure c = new Figure(0, width/2, baseLineY - pitch * 10, mulAmp1 * v, true, true, pad);
      // Figure c = new Figure(1, width/2, baseLineY - pitch * 10, mulAmp1 * v, true, true, pad);
      // Figure c = new Figure(2, width/2, baseLineY - pitch * 10, mulAmp1 * v, true, true, pad);
      Figure c = new Figure(figureType, width/2, baseLineY - pitch * 10, mulAmp1 * v, true, true, pad);
 

      if (circleOverwhelm) {
        makeGoAround = false;
        c.setPos(width/2, height/2);
        c.setVelocity(0, 0);
        // mulAmp1 = 180000;
        mulAmp1 = 15000;
      }

      if (makeGoAround) {
        c.setGoAround(true);
        c.setDistFromCenter(400);
        c.setVangle(vAngle1);
      } else {
        c.setGoAround(false);
      }

      c.setStrokeWeight(2.0);

      // blue
      if (!circleOverwhelm) {
        c.setAging(true);
        c.setFillColor(r1, g1, b1, a1);
        c.setStrokeColor(170, 170, 190, 200);
      } else {
        c.setAging(true);
        // println(v);
        int a = (int)(v * 255);
        // println(a);
        c.setFillColor(r1, g1, b1, a);
        c.setStrokeColor(0, 0, 0, 0);
      }

      figures.add(c);

      // writer_1.data(v, pitch);
      pitchInterval++;
    }
  }

  // reset
  if (isReset == true) {
    
    for (int i = figures.size() - 1; i >= 0; i--) {
      figures.remove(i);
    }

    isReset = false;

  } else {
    for (Figure c : figures) {
      if (c != null) {
        c.update();
        c.draw();
      }
    }
  }


  // lines between figures
  // noFill();
  // beginShape();
  // strokeWeeght(10);
  // // noStroke();
  // for (Figure c : figures) {
  //   PVector pos = c.getPos();
  //   vertex(pos.x, pos.y);
  // }
  // endShape();

  // remove dead circle
  for (int i = figures.size() - 1; i >= 0; i--) {
    Figure c = figures.get(i);
    if (c.isDead() == true) {
      figures.remove(i);
    }
  }

}

void resetCanvas() {
  // writer_1.reset();
  // writer_2.reset();
  // if (CH3) writer_3.reset();
}


void keyPressed() {
  if (key == 'r' || key == 'R') {
    isReset = true;
  }
}

int getMaxValIdx(float[] fArr) {
  float maxVal = 0;
  int maxValIdx = 0;
  for (int i = 0; i < fArr.length; i++) {
    if (fArr[i] > maxVal) {
      maxVal = fArr[i];
      maxValIdx = i;
    }
  }

  return maxValIdx;
}

public void saveModel(String fileName, ArrayList<Figure> figures) {
  try {
    // File file = new File(getFilesDir(), fileName);
    FileOutputStream fos = new FileOutputStream(fileName);
    ObjectOutputStream oos = new ObjectOutputStream(fos);
    oos.writeObject(figures);
    fos.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}


public ArrayList<Figure> loadModel(String fileName) {
  ArrayList<Figure> figures = null;
  try {
    FileInputStream fis = new FileInputStream(fileName);
    ObjectInputStream ois = new ObjectInputStream(fis);
    figures = (ArrayList<Figure>) ois.readObject();
    fis.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  catch (ClassNotFoundException e) {
    e.printStackTrace();
  }
  return figures;

}
