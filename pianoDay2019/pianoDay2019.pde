import processing.sound.*;
Amplitude amp, amp2;
AudioIn in, in2;

int bufNumLondon = 0;
int bufNumSeoul = 0;
FloatList bufLondon;
FloatList bufSeoul;

int baseYLondon = 0;
int baseYSeoul = 0;


float ampMulLondon = 100;
float ampMulSeoul = 100;

WaveCircle wc, wc2;


int pad = 10;

float velLondon = 1.0;
float velSeoul = 1.0;

int count = 0;
float rotRadius = 400;

float nightMovX = 0;
float pointPosX = 0;
float pointPosY = 0;

enum DIRECTION {
    UP, DOWN;
}

void setup() {
    // size(1280, 900);
    size(1920, 1080);
    // fullScreen();
    background(255);
      
    bufLondon = new FloatList();
    bufSeoul = new FloatList();

    wc = new WaveCircle(width*1/4, height/2, 200);
    wc2 = new WaveCircle(width*3/4, height/2, 100);

    // Create an Input stream which is routed into the Amplitude analyzer
    amp = new Amplitude(this);
    amp2 = new Amplitude(this);
    in = new AudioIn(this, 0);
    in2 = new AudioIn(this, 1);
    in.start();
    in2.start();
    amp.input(in);
    amp2.input(in2);

    // Buffer Init
    // bufNumLondon = (width - (pad * 2))/velLondon
    // bufNumSeoul = (width - (pad * 2))/velSeoul
    bufNumLondon = 420 * 1;
    bufNumSeoul = 360 * 4;

    baseYLondon = height / 2 - 80;
    // print(baseYLondon);
    // baseYSeoul = baseYLondon * 2;
    baseYSeoul = 353 * 2;


}      

void draw() {
    background(255, 0);
    
    // Boundary
    stroke(0);
    strokeWeight(1);
    line(pad, pad, width - pad, pad);
    line(width - pad, pad, width - pad, height - pad);
    line(width - pad, height - pad, pad, height - pad);
    line(pad, height - pad, pad, pad);


    // Center red line
    stroke(255, 0, 0);
    // strokeWeight(0.3);
    float rh = width/2 + (noise(frameCount/40) - 0.5) * 100;
    // line(rh, 0, rh, height);


    // Update buffer
    float newValue = amp.analyze(); // input ch 1
    float newValue2 = amp2.analyze(); // input ch 2


    // night rect
    fill(20, 50 - (newValue * 50));
    // stroke(20, 200 - (newValue * 50));
    strokeWeight(5);
    // noStroke();
    // noFill();
    // rect(pad + nightMovX, pad, width/2 - pad, height - pad*2);
    // line(width/2 + nightMovX, pad, width/2 + nightMovX, height-pad);
    noStroke();
    triangle((float)width/2 + nightMovX, (float)pad, (float)width/2 - nightMovX, (float)height - (float)pad, (float)width/2 + nightMovX + pointPosX, (float)height*2/5 + pointPosY);
    nightMovX+=0.01;
    pointPosX = sin(frameCount/10000) * 20;
    pointPosY = cos(frameCount/1000) * 500;
    println(nightMovX);


    // Amp input test lines
    // stroke(255, 0, 0);
    // line(0, 100, newValue * 1000, 100);
    // stroke(0, 0, 255);
    // line(0, 200, newValue2 * 1000, 200);


    // ch 1
    if (bufSeoul.size() < bufNumSeoul) {
        bufSeoul.append(newValue);
    } else {
        bufSeoul.remove(0); // remove first element
        bufSeoul.append(newValue); // append to last index position
        // print(bufSeoul)
    }


    // ch 2
    if (bufLondon.size() < bufNumLondon) {
        bufLondon.append(newValue2);
    } else {
        bufLondon.remove(0); // remove first element
        bufLondon.append(newValue2); // append to last index position
        // print(bufLondon)
    }

    // println("len: " + bufLondon.size());

    wc.update(bufSeoul);
    wc.direction(DIRECTION.UP);
    // wc.setPos(rotRadius *cos(radians(count)), rotRadius * sin(radians(count)));
    wc.draw();
    count++;
    // Sound line
    // for (int i = 0; i < bufNumLondon; i++) {
    //     int w = width - pad;
    //     int lenLondon = bufLondon.size();
    //     int lenSeoul = bufSeoul.size();
    //     if (lenLondon == 360 && lenSeoul == 360) {
    //         fill(0);
    //         ellipse(w - i/2, baseYLondon + bufLondon.get(lenLondon - 1 - i) * 1000 , 5, 5);

    //         fill(10, 60, 120);
    //         ellipse(pad + i/2, baseYSeoul + bufSeoul.get(lenSeoul - 1 - i) * 1000 , 5, 5);
    //     }

    // }


    // fill(0);
    noFill();
    // strokeWeight(0.4);
    stroke(0, 150);
    strokeWeight(1);

    int lenLondon = bufLondon.size();
    int lenSeoul = bufSeoul.size();

    if (lenLondon == bufNumLondon) {
        beginShape();
            for (int i = 0; i < bufNumLondon; i++) {
                int w = width - pad; // <--
                // int w = width - bufNumLondon; // -->
                vertex(w - (i * velLondon), baseYLondon + bufLondon.get(lenLondon - 1 - i) * ampMulLondon); // <--
                // vertex(w + (i * velLondon), baseYLondon + bufLondon.get(lenLondon - 1 - i) * 1000); // -->
            }
        endShape();
    }

    // fill(10);
    // rect(width*3/4, 0, width*1/4, height);

    wc2.update(bufLondon);
    wc2.direction(DIRECTION.UP);
    // wc2.setPos(rotRadius *cos(radians(count)), rotRadius * sin(radians(count)));
    wc2.draw();



    // fill(10, 80, 200);
    noFill();
    strokeWeight(1);
    stroke(10, 80, 200);
    push();
    translate(width - bufNumSeoul, baseYSeoul);
    rotate(radians(-5));
    if (lenSeoul == bufNumSeoul) {
        beginShape();
            for (int i = 0; i < bufNumSeoul; i++) {
                // int w = width - pad;
                // int w = width - bufNumSeoul;
                int w = -bufNumSeoul;
                // vertex(w - (i * velSeoul), baseYSeoul + bufSeoul.get(lenSeoul - 1 - i) * 1000);
                // vertex(w + (i * velSeoul), baseYSeoul + bufSeoul.get(lenSeoul - 1 - i) * 3000);
                vertex(0 + (i * velSeoul), 0 + bufSeoul.get(lenSeoul - 1 - i) * ampMulSeoul);
            }
        endShape();
    }
    pop();

}

