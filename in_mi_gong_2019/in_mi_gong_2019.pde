
import java.io.*;
import processing.sound.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Amplitude amp, amp2, amp3;
AudioIn in, in2, in3;

float ampThr1 = 0.005;
// float ampThr2 = 0.005;
// float ampThr3 = 0.005;

// in jeokdo
float mulAmp1 = 4600;
// float mulAmp2 = 4600;
// float mulAmp3 = 4600;

// in test
// float mulAmp1 = 300;
// float mulAmp2 = 200;


// float writerAmpMul1 = 38;
// float writerAmpMul2 = 38;
// float writerAmpMul3 = 38;

ArrayList<Circle> circles = new ArrayList<Circle>();
ArrayList<Circle> circlesEcho = new ArrayList<Circle>();
// ArrayList<Circle> circlesTicket = new ArrayList<Circle>();

FFT fft, fft2;
int bands = 1024;
float[] spectrum = new float[bands];
float[] spectrum2 = new float[bands];
// float[] spectrum3 = new float[bands];

int pitchInterval = 0;
int pitchInterval2 = 0;
int pitchInterval3 = 0;
boolean pitchGrabbed = false;
boolean pitchGrabbed2 = false;
boolean pitchGrabbed3 = false;
int pitch = 0;
int pitch2 = 0;
int pitch3 = 0;

float baseLineY = 0;

int pad = 10;

// Writer writer_1, writer_2, writer_3;

int r1 = 10;
int g1 = 80;
int b1 = 200;
int a1 = 200;

int r2 = 190;
int g2 = 200;
int b2 = 190;
int a2 = 80;

int r3 = 90;
int g3 = 200;
int b3 = 90;
int a3 = 80;

boolean CH3 = false;

boolean drawCH2 = true;
boolean changeCH2 = false;
boolean isReset = false;
boolean isReset2 = false;
boolean makeGoAround = false;
boolean makeBlack = false;
boolean circleOverwhelm = false;

float newValue, newValue2, newValue3;

float vAngle1 = -0.5;
float vAngle2 = 0.5;

// to save writing as a file
// ArrayList<Circle> loadedCircles;

void setup() {
  // size(1280, 900);
   //size(1920, 1080);
  fullScreen();
  background(255);

  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);

  Sound.list();
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  amp2 = new Amplitude(this);
  // amp3 = new Amplitude(this);

  // guitar rig
  in = new AudioIn(this, 0); // piano
  in2 = new AudioIn(this, 1); // piano echo

  // H6
  // in = new AudioIn(this, 2); // piano
  // in2 = new AudioIn(this, 4); // piano echo

  if (CH3) {
    // H6
    in3 = new AudioIn(this, 5); // ticket
  }

  in.start();
  in2.start();
  if (CH3) {
    in3.start();
  }

  amp.input(in);
  amp2.input(in2);
  if (CH3) {
    amp3.input(in3);
  }

  fft = new FFT(this, bands);
  fft.input(in);

  fft2 = new FFT(this, bands);
  fft2.input(in2);

  // if (CH3) {
  //   fft3 = new FFT(this, bands);
  //   fft3.input(in3);
  // }


  baseLineY = height/2 + 300;

  // writer_1 = new Writer(width - pad*2, pad, writerAmpMul1);
  // writer_1.setFillColor(r1, g1, b1, a1/3);
  // writer_2 = new Writer(width/2, pad, writerAmpMul2);
  // writer_2.setFillColor(r2, g2, b2, a2);

  // if (CH3) {
  //   writer_3 = new Writer(width/2, pad/2, writerAmpMul3);
  //   writer_3.setFillColor(r3, g3, b3, a3);
  // }

}

void draw() {

  if (makeBlack) {
    background(0, 0, 0, 255);
  } else {
    background(255);
  }

  if (circleOverwhelm) {
    background(0);
  }

  fft.analyze(spectrum);
  fft2.analyze(spectrum2);

  int pitchIdx = getMaxValIdx(spectrum);
  int pitchIdx2 = getMaxValIdx(spectrum2);

  // Update buffer
  newValue = amp.analyze(); // input ch 1
  newValue2 = amp2.analyze(); // input ch 2

  // ------------------------------------------------------------- 1 circles -------------------------------------------------------------------
  if (newValue > ampThr1) {

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
      Circle c = new Circle(width/2, baseLineY - pitch * 10, mulAmp1 * v, true, true, pad, false);

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
        c.setAging(false);
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

      circles.add(c);

      // writer_1.data(v, pitch);
      pitchInterval++;
    }
  }


  // reset
  if (isReset == true) {
    
    for (int i = circles.size() - 1; i >= 0; i--) {
      circles.remove(i);
    }

    isReset = false;

  } else {
    for (Circle c : circles) {
      if (c != null) {
        c.update();
        c.draw();
      }
    }
  }


  // lines between circles
  // noFill();
  // beginShape();
  // strokeWeight(10);
  // // noStroke();
  // for (Circle c : circles) {
  //   PVector pos = c.getPos();
  //   vertex(pos.x, pos.y);
  // }
  // endShape();

  // remove dead circle
  for (int i = circles.size() - 1; i >= 0; i--) {
    Circle c = circles.get(i);
    if (c.isDead() == true) {
      circles.remove(i);
    }
  }

  //    writer_1.update();
  //    writer_1.draw();

  // ----------------------------------- 2 circlesEcho -----------------------------------------
  if (newValue2 > ampThr2) {

    if (pitchGrabbed2 == false) {
      pitch2 = pitchIdx2;
      pitchGrabbed2 = true;
      pitchInterval2 = 0;
    }

    if (pitchInterval2 > 10) {
      pitchGrabbed2 = false;
      pitchInterval2 = 0;
    }

    if (!makeBlack && !circleOverwhelm && drawCH2) {
      float v = newValue2;
      Circle c = new Circle(width - pad, baseLineY - pitch2 * 10, mulAmp2 * newValue2, true, true, width/2, false);

      if (makeGoAround) {
        c.setGoAround(true);
        c.setDistFromCenter(200);
        c.setVangle(vAngle2); // rotate CW
      } else {
        c.setGoAround(false);
      }

      c.setStrokeWeight(0.3);

      // purple
      // c.setFillColor(128, 0, 255, 80);
      // c.setStrokeColor(255, 155, 155, 80);

      // gray
      if (changeCH2 == false) {
        c.setFillColor(r2, g2, b2, 70);
        c.setStrokeColor(r2/2, g2/2, b2/2, 140);
      } else {
        c.setFillColor(r3, g3, b3, 70);
        c.setStrokeColor(370, 370, 390, 200);
      }

      if (!makeGoAround) {
        float vd = constrain(width/2 * ((float)frameCount/(1800*35)), 0, width/2 + 200);
        // println(vd);
        c.setDeadLine(width/2 - vd);
      }

      circlesEcho.add(c);

      // writer_2.data(newValue2, pitch);
      pitchInterval2++;
    }
  }

  // reset circles
  if (isReset2 == true) {
    for (int i = circlesEcho.size() - 1; i >= 0; i--) {
      circlesEcho.remove(i);
    }

    isReset2 = false;

  } else {
    for (Circle c : circlesEcho) {
      if (c != null) {
        c.update();
        c.draw();
      }
    }
  }

  // lines between circles
  if (!makeGoAround) {
    fill(255, 100);
    beginShape(LINES);
    strokeWeight(1);
    for (Circle c : circlesEcho) {
      PVector pos = c.getPos();
      vertex(pos.x, pos.y);
    }
    endShape();
  }

  // remove dead circle
  for (int i = circlesEcho.size() - 1; i >= 0; i--) {
    Circle c = circlesEcho.get(i);
    if (c.isDead() == true) {
      circlesEcho.remove(i);
    }
  }


  //   writer_2.update();
  //   writer_2.draw();

}

void resetCanvas() {
  // writer_1.reset();
  // writer_2.reset();
  // if (CH3) writer_3.reset();
}


void keyPressed() {
  if (key == 'r' || key == 'R') {
    isReset = true;
    isReset2 = true;
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

public void saveModel(String fileName, ArrayList<Circle> circles) {
  try {
    // File file = new File(getFilesDir(), fileName);
    FileOutputStream fos = new FileOutputStream(fileName);
    ObjectOutputStream oos = new ObjectOutputStream(fos);
    oos.writeObject(circles);
    fos.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
}


public ArrayList<Circle> loadModel(String fileName) {
  ArrayList<Circle> circles = null;
  try {
    FileInputStream fis = new FileInputStream(fileName);
    ObjectInputStream ois = new ObjectInputStream(fis);
    circles = (ArrayList<Circle>) ois.readObject();
    fis.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  catch (ClassNotFoundException e) {
    e.printStackTrace();
  }
  return circles;
}


void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/toConsole") == true) {
    if (theOscMessage.checkTypetag("s")) {
      String msg = theOscMessage.get(0).stringValue();
      println("msg: " + msg);
      if (msg.equals("r")) {
        isReset = true;
        isReset2 = true;
        println("resetCanvas() with OSC");
      } else if (msg.equals("d")) {
        drawCH2 = true;
        println("drawCH2: " + drawCH2);
      } else if (msg.equals("f")) {
        drawCH2 = false;
        println("drawCH2: " + drawCH2);
      } else if (msg.equals("j")) {
        changeCH2 = true;
        println("changeCH2: " + changeCH2);
      }else if (msg.equals("k")) {
        changeCH2 = false;
        println("changeCH2: " + changeCH2);
      } else if (msg.equals("1")) {
        makeGoAround = false;
        circleOverwhelm = false;
      } else if (msg.equals("2")) {
        makeGoAround = true;
        circleOverwhelm = false;
        // drawCH2 = false;
        makeBlack = false;
        ampThr1 = 0.008;
        ampThr2 = 0.008;
      } else if (msg.equals("3")) {
        makeGoAround = false;
        circleOverwhelm = true;
        makeBlack = false;
        ampThr1 = 0.005;
        ampThr2 = 0.005;
      } 
      
      else if (msg.equals("b")) {
        makeBlack = true;
      } else if (msg.equals("w")) {
        makeBlack = false;
      }
      return;
    }
  }

}
