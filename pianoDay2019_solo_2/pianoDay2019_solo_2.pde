
import java.io.*;
import processing.sound.*;

Amplitude amp, amp2;
AudioIn in, in2;

float ampThr1 = 0.005;
float ampThr2 = 0.005;

// in jeokdo
float mulAmp1 = 4600;
float mulAmp2 = 4600;

// in test
// float mulAmp1 = 300;
// float mulAmp2 = 200;


float writerAmpMul1 = 38;
float writerAmpMul2 = 38;

ArrayList<Circle> circles = new ArrayList<Circle>();
ArrayList<Circle> circlesEcho = new ArrayList<Circle>();

FFT fft, fft2;
int bands = 1024;
float[] spectrum = new float[bands];
float[] spectrum2 = new float[bands];
int pitchInterval = 0;
int pitchInterval2 = 0;
boolean pitchGrabbed = false;
boolean pitchGrabbed2 = false;
int pitch = 0;
int pitch2 = 0;

float baseLineY = 0;

int pad = 10;

Writer writer_1, writer_2;

int r1 = 10;
int g1 = 80;
int b1 = 200;
int a1 = 200;

int r2 = 190;
int g2 = 200;
int b2 = 190;
int a2 = 80;

// to save writing as a file
// ArrayList<Circle> loadedCircles;

void setup() {
    // size(1280, 900);
    // size(1920, 1080);
    fullScreen();
    background(255);
      
    // Create an Input stream which is routed into the Amplitude analyzer
    amp = new Amplitude(this);
    amp2 = new Amplitude(this);
    in = new AudioIn(this, 0);
    in2 = new AudioIn(this, 1);
    in.start();
    in2.start();
    amp.input(in);
    amp2.input(in2);

    fft = new FFT(this, bands);
    fft.input(in);

    fft2 = new FFT(this, bands);
    fft2.input(in2);


    baseLineY = height/2 + 300;

    writer_1 = new Writer(width - pad*2, pad, writerAmpMul1);
    writer_1.setFillColor(r1, g1, b1, a1/3);
    writer_2 = new Writer(width/2, pad, writerAmpMul2);
    writer_2.setFillColor(r2, g2, b2, a2);

}      

void draw() {
    background(255);
    
    fft.analyze(spectrum);
    fft2.analyze(spectrum2);

    int pitchIdx = getMaxValIdx(spectrum);
    int pitchIdx2 = getMaxValIdx(spectrum2);

    // println(pitchIdx);
    // println(pitchIdx2);
    // colorMode(HSB, 360, 100, 100);
    // float vc = (float)maxValIdx/(float)spectrum.length * 360.0;
    // println(vc);
    // fill(220 + vc, 100, 100);
    // rect(0, 0, 100, 100);

    // noStroke();
    // fill(255);
    // rect(0, 0, width, height);

    // Boundary
    // stroke(0);
    // line(pad, pad, width - pad, pad);
    // line(width - pad, pad, width - pad, height - pad);
    // line(width - pad, height - pad, pad, height - pad);
    // line(pad, height - pad, pad, pad);

    // Center red line
    // stroke(255, 0, 0);
    // line(width/2, 0, width/2, height);


    // Update buffer
    float newValue = amp.analyze(); // input ch 1
    float newValue2 = amp2.analyze(); // input ch 2

    // amp input test line
    // stroke(255, 0, 0);
    // line(0, 100, newValue * 1000, 100);
    // stroke(0, 0, 255);
    // line(0, 200, newValue2 * 1000, 200);


    // circles 1
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

        float v = newValue;
        Circle c = new Circle(width/2, baseLineY - pitch * 10, mulAmp1 * v, true, true, pad, false);
        c.setStrokeWeight(2.0);
        // green
        // c.setFillColor(10, 180, 80, 200);
        // c.setStrokeColor(0, 0, 255, 200);

        // blue
        c.setFillColor(r1, g1, b1, a1);
        c.setStrokeColor(170, 170, 190, 200);

        circles.add(c);

        writer_1.data(v, pitch);
        pitchInterval++;
    }

    for (Circle c : circles) {
        c.update();
        c.draw();
    } 

    noFill();
    // fill(255, 100);
    beginShape();
    // stroke(255, 100);
    strokeWeight(0.05);
    noStroke();
    for (Circle c : circles) {
        PVector pos = c.getPos();
        vertex(pos.x, pos.y);
    } 
    endShape();

    for (int i = circles.size() - 1; i >= 0; i--) {
        Circle c = circles.get(i);
        if (c.isDead() == true) {
            circles.remove(i);
        }
    }

    writer_1.update();
    writer_1.draw();

    // circlesEcho
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

        float v = newValue2;
        Circle c = new Circle(width - pad, baseLineY - pitch2 * 10, mulAmp2 * newValue2, true, true, width/2, false);
        c.setStrokeWeight(0.3);
        // purple
        // c.setFillColor(128, 0, 255, 80);
        // c.setStrokeColor(255, 155, 155, 80);

        // gray
        c.setFillColor(r2, g2, b2, 70);
        c.setStrokeColor(r2/2, g2/2, b2/2, 140);
        float vd = constrain(width/2 * ((float)frameCount/(1800*25)), 0, width/2 + 200);
        // println(vd);
        c.setDeadLine(width/2 - vd);
        circlesEcho.add(c);

        writer_2.data(newValue2, pitch);
        pitchInterval2++;
    }

    for (Circle c : circlesEcho) {
        c.update();
        c.draw();
    } 

    // noFill();
    fill(255, 100);
    beginShape(LINES);
    // stroke(255, 100);
    strokeWeight(1);
    for (Circle c : circlesEcho) {
        PVector pos = c.getPos();
        vertex(pos.x, pos.y);
    } 
    endShape();

    for (int i = circlesEcho.size() - 1; i >= 0; i--) {
        Circle c = circlesEcho.get(i);
        if (c.isDead() == true) {
            circlesEcho.remove(i);
        }
    }


    writer_2.update();
    writer_2.draw();


}

// void mouseClicked() {
    // bufNumSeoul_1 = (int)random(180, 480);
    // bufSeoul_1.clear();
    // println(bufNumSeoul_1);

//     ArrayList<Circle> cs = writer_1.getData();
//     saveModel("C:/Users/morfa/Documents/pglr/pianoDay2019_solo_2/test.bin", cs);
//     println("save file()");
// }

void resetCanvas() {
    for (int i = circles.size() - 1; i >= 0; i--) {
        circles.remove(i);
    }
    for (int i = circlesEcho.size() - 1; i >= 0; i--) {
        circlesEcho.remove(i);
    }

    writer_1.reset();
    writer_2.reset();
}


void keyPressed() {
    if (key == 'r' || key == 'R') {
        println("Reset");
        resetCanvas();
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

public void saveModel(String fileName, ArrayList<Circle> circles){
    try {
        // File file = new File(getFilesDir(), fileName);
        FileOutputStream fos = new FileOutputStream(fileName);
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(circles);
        fos.close();
    } catch (IOException e) {
        e.printStackTrace();
    }
}


public ArrayList<Circle> loadModel(String fileName){
    ArrayList<Circle> circles = null;
    try {
        FileInputStream fis = new FileInputStream(fileName);
        ObjectInputStream ois = new ObjectInputStream(fis);
        circles = (ArrayList<Circle>) ois.readObject();
        fis.close();
    } catch (IOException e) {
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }
    return circles;
}
