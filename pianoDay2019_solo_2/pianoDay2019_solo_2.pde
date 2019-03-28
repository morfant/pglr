
import java.io.*;
import processing.sound.*;
Amplitude amp, amp2;
AudioIn in, in2;

ArrayList<Circle> circles = new ArrayList<Circle>();
ArrayList<Circle> circlesEcho = new ArrayList<Circle>();
boolean frameMoved = false;
FFT fft, fft2;
int bands = 512;
float[] spectrum = new float[bands];
float[] spectrum2 = new float[bands];
int pitchInterval = 0;
int pitchInterval2 = 0;
boolean pitchGrabbed = false;
boolean pitchGrabbed2 = false;
int pitch = 0;
int pitch2 = 0;

int bufNumSeoul_1 = 0;
int bufNumSeoul_2 = 0;
FloatList bufSeoul_1;
FloatList bufSeoul_2;

int baseYSeoul_1 = 0;
int baseYSeoul_2 = 0;

WaveCircle wc, wc2;

int buf_diff = 180;

int pad = 10;

// velocity of horizontal amp lines
float velSeoul_1 = 1.0;
float velSeoul_2 = 1.0;
enum DIRECTION {
    UP, DOWN, CW, CCW;
}

Writer writer_1, writer_2;



ArrayList<Circle> loadedCircles;

void setup() {
    // size(1280, 900);
    size(1920, 1080);
    // fullScreen();
    background(255);
      
    bufSeoul_1 = new FloatList();
    bufSeoul_2 = new FloatList();
    bufNumSeoul_1 = 100;
    bufNumSeoul_2 = width/2;

    // wc = new WaveCircle(width*1/2, height/2, 300, bufNumSeoul_1);
    // wc2 = new WaveCircle(width*1/2, height/2, 300, bufNumSeoul_2);

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

    // Buffer Init
    // bufNumLondon = (width - (pad * 2))/velLondon
    // bufNumSeoul = (width - (pad * 2))/velSeoul

    baseYSeoul_1 = height/2;
    baseYSeoul_2 = height/2;

    frame.setLocation(0, 0);

    writer_1 = new Writer(width - pad*2, pad);
    writer_1.setFillColor(10, 180, 80, 255);
    writer_2 = new Writer(width/2, pad);
    writer_2.setFillColor(128, 0, 255, 255);

}      

void draw() {
    if (!frameMoved){
        frame.setLocation(700, 0);
        frameMoved = true;
    }
    background(255);
    
    fft.analyze(spectrum);
    fft2.analyze(spectrum2);

    int pitchIdx = getMaxValIdx(spectrum);
    int pitchIdx2 = getMaxValIdx(spectrum2);

    println(pitchIdx);
    println(pitchIdx2);
    // colorMode(HSB, 360, 100, 100);
    // float vc = (float)maxValIdx/(float)spectrum.length * 360.0;
    // println(vc);
    // fill(220 + vc, 100, 100);
    // rect(0, 0, 100, 100);

    // noStroke();
    // fill(255);
    // rect(0, 0, width, height);

    // Boundary
    stroke(0);
    line(pad, pad, width - pad, pad);
    line(width - pad, pad, width - pad, height - pad);
    line(width - pad, height - pad, pad, height - pad);
    line(pad, height - pad, pad, pad);

    // Center red line
    // stroke(255, 0, 0);
    // line(width/2, 0, width/2, height);


    // Update buffer
    float newValue = amp.analyze(); // input ch 1
    float newValue2 = amp2.analyze(); // input ch 2
    stroke(255, 0, 0);
    line(0, 100, newValue * 1000, 100);
    stroke(0, 0, 255);
    line(0, 200, newValue2 * 1000, 200);


    // circles 1
    if (newValue > 0.05) {

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
        Circle c = new Circle(width/2, baseYSeoul_1 - pitch * 10, 500 * v, true, true, pad);
        c.setFillColor(10, 180, 80, 200);
        c.setStrokeColor(0, 0, 255, 200);
        circles.add(c);

        writer_1.data(v, pitch);
        pitchInterval++;
    }

    for (Circle c : circles) {
        c.update();
        c.draw();
    } 

    // noFill();
    fill(255, 100);
    beginShape();
    stroke(255, 100);
    strokeWeight(5);
    for (Circle c : circles) {
        PVector pos = c.getPos();
        vertex(pos.x, pos.y);
    } 
    endShape(CLOSE);

    for (int i = circles.size() - 1; i >= 0; i--) {
        Circle c = circles.get(i);
        if (c.isDead() == true) {
            circles.remove(i);
        }
    }

    // circlesEcho
    if (newValue2 > 0.05) {

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
        Circle c = new Circle(width - pad, baseYSeoul_1 - pitch2 * 10, 500 * newValue2, true, true, width/2);
        c.setFillColor(128, 0, 255, 80);
        c.setStrokeColor(255, 155, 155, 80);
        circlesEcho.add(c);
        // circles.add(new Circle(width/2, baseYSeoul_1 - pitch * 10, 50));

        writer_2.data(newValue2, pitch);
        pitchInterval2++;
    }

    for (Circle c : circlesEcho) {
        c.update();
        c.draw();
    } 

    // noFill();
    fill(255, 100);
    beginShape();
    stroke(255, 100);
    strokeWeight(5);
    for (Circle c : circlesEcho) {
        PVector pos = c.getPos();
        vertex(pos.x, pos.y);
    } 
    endShape(CLOSE);

    for (int i = circlesEcho.size() - 1; i >= 0; i--) {
        Circle c = circlesEcho.get(i);
        if (c.isDead() == true) {
            circlesEcho.remove(i);
        }
    }




    // ch 1
    if (bufSeoul_1.size() < bufNumSeoul_1) {
        bufSeoul_1.append(newValue);
    } else {
        bufSeoul_1.remove(0); // remove first element
        bufSeoul_1.append(newValue); // append to last index position
        // print(bufSeoul_1)
    }

    // ch 2
    if (bufSeoul_2.size() < bufNumSeoul_2) {
        if (bufSeoul_2.size() < buf_diff) {
            bufSeoul_2.append(0);
        } else {
            bufSeoul_2.append(newValue);
        }
    } else {
        bufSeoul_2.remove(0); // remove first element
        bufSeoul_2.append(newValue); // append to last index position
        // print(bufSeoul_2)
    }

    // wc.setVel(0.5);
    // wc.setColor(color(10, 80, 200, 255), color(0), 0.4);
    // wc.update(bufSeoul_1);
    // wc.setFill(false);
    // wc.updateFFT(spectrum);
    // wc.direction(DIRECTION.UP);
    // wc.rotation(DIRECTION.CCW);
    // wc.draw();
    // wc.drawFFT();

    // wc2.setColor(color(10, 80, 200, 120), color(40), 0.3);
    // // wc2.setFill(false);
    // wc2.update(bufSeoul_2);
    // wc2.direction(DIRECTION.UP);
    // wc2.rotation(DIRECTION.CCW);
    // wc2.draw();


    // fill(10, 80, 200);
    // noFill();
    // strokeWeight(0.4);
    // stroke(10, 80, 200);
    // if (lenSeoul_2 == bufNumSeoul_2) {
    //     beginShape();
    //         for (int i = 0; i < bufNumSeoul_2; i++) {
    //             int w = width - pad;
    //             vertex(w - (i * velSeoul_2), baseYSeoul_2 + bufSeoul_2.get(lenSeoul_2 - 1 - i) * 1000);
    //         }
    //     endShape();
    // }




    for(int i = 0; i < bands; i++){
        // The result of the FFT is normalized
        // draw the line for frequency band i scaling it up by 5 to get more amplitude.
        line( i, height, i, height - spectrum[i]*height*5 );
    } 


    writer_1.update();
    writer_1.draw();

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

// void keyPressed() {
//     loadedCircles = null;
//   if (key == CODED) {
//     if (keyCode == UP) {
//         loadedCircles = loadModel("C:/Users/morfa/Documents/pglr/pianoDay2019_solo_2/test.bin");

//     } else if (keyCode == DOWN) {
//         if (loadedCircles != null) {
//             println(loadedCircles.size());
//         } else {
//             println("loadedCircles is null");
//         }
//     } 
//   } else {
//   }
// }

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