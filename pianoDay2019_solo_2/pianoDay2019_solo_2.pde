import processing.sound.*;
Amplitude amp, amp2;
AudioIn in, in2;

ArrayList<Circle> circles = new ArrayList<Circle>();
boolean frameMoved = false;
FFT fft;
int bands = 512;
float[] spectrum = new float[bands];
int pitchInterval = 0;
boolean pitchGrabbed = false;
float pitch = 0;

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

void setup() {
    size(1280, 900);
    // fullScreen();
    background(255);
      
    bufSeoul_1 = new FloatList();
    bufSeoul_2 = new FloatList();
    bufNumSeoul_1 = 100;
    bufNumSeoul_2 = width/2;

    wc = new WaveCircle(width*1/2, height/2, 300, bufNumSeoul_1);
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

    // Buffer Init
    // bufNumLondon = (width - (pad * 2))/velLondon
    // bufNumSeoul = (width - (pad * 2))/velSeoul

    baseYSeoul_1 = height/2;
    baseYSeoul_2 = height/2;

    frame.setLocation(0, 0);

}      

void draw() {
    if (!frameMoved){
        frame.setLocation(700, 0);
        frameMoved = true;
    }
    background(255);
    
    fft.analyze(spectrum);

    float maxVal = 0;
    int maxValIdx = 0;
    for (int i = 0; i < spectrum.length; i++) {
        if (spectrum[i] > maxVal) {
            maxVal = spectrum[i];
            maxValIdx = i;
        }
    }

    // print(maxVal);
    println(maxValIdx);
    // println(spectrum.length);

    // colorMode(HSB, 360, 100, 100);
    float vc = (float)maxValIdx/(float)spectrum.length * 360.0;
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



    if (newValue > 0.05) {
        rect(width/2, height/2, 100, 100);

        if (pitchGrabbed == false) {
            pitch = maxValIdx;
            pitchGrabbed = true;
            pitchInterval = 0;
        }

        if (pitchInterval > 10) {
            pitchGrabbed = false;
            pitchInterval = 0;
        }


        float v = newValue;
        circles.add(new Circle(width/2, baseYSeoul_1 - pitch * 10, 500 * newValue));
        // circles.add(new Circle(width/2, baseYSeoul_1 - pitch * 10, 50));

        pitchInterval++;

    }


    for (Circle c : circles) {
        c.update();
        c.draw();
    } 

    // noFill();
    fill(255, 100);
    beginShape(QUAD_STRIP);
    stroke(255, 100);
    strokeWeight(80);
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



    // horizontal lines
    fill(0);
    noFill();
    strokeWeight(0.4);
    stroke(0, 150);

    int lenSeoul_1 = bufSeoul_1.size();
    int lenSeoul_2 = bufSeoul_2.size();

    if (lenSeoul_1 == bufNumSeoul_1) {
        // beginShape();
            for (int i = 0; i < bufNumSeoul_1; i++) {
                int w = width/2;
                // vertex(w - (i * velSeoul_1), baseYSeoul_1 - bufSeoul_1.get(lenSeoul_1 - 1 - i) * 1000);

                float v = bufSeoul_1.get(lenSeoul_1 - 1 - i);
                float pitch = maxValIdx;
                if (bufSeoul_1.get(lenSeoul_1 - 1 - i) > 0.01) {
                    // Circle c = new Circle(w - (i * velSeoul_1), pitch * 10 + baseYSeoul_1, 500 * v);
                    // circles.add(new Circle(w - (i * velSeoul_1), pitch * 10 + baseYSeoul_1, 500 * v));
                    // ellipse(w - (i * velSeoul_1), 100 + baseYSeoul_1, 500 * v , 500 * v);
                }
            }
        // endShape();
    }


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

}

// void mouseClicked() {
//     bufNumSeoul_1 = (int)random(180, 480);
//     bufSeoul_1.clear();
//     println(bufNumSeoul_1);
// }

