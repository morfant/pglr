import processing.sound.*;
Amplitude amp, amp2;
AudioIn in, in2;

int bufNumLondon = 0;
int bufNumSeoul = 0;
FloatList bufLondon;
FloatList bufSeoul;

int baseYLondon = 0;
int baseYSeoul = 0;

WaveCircle wc, wc2;


int pad = 10;

enum DIRECTION {
    UP, DOWN;
}

void setup() {
    size(1280, 900);
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
    bufNumLondon = 360 * 1;
    bufNumSeoul = 360 * 1;

    baseYLondon = (height - (pad * 2)) / 3;
    // print(baseYLondon)
    baseYSeoul = baseYLondon * 2;

}      

void draw() {
    background(255);
    
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
    float newValue = amp.analyze();
    float newValue2 = amp2.analyze();
    line(0, 100, newValue * 1000, 100);
    line(0, 200, newValue2 * 1000, 200);

    if (bufLondon.size() < bufNumLondon) {
        bufLondon.append(newValue);
    } else {
        bufLondon.remove(0); // remove first element
        bufLondon.append(newValue); // append to last index position
        // print(bufLondon)
    }

    if (bufSeoul.size() < bufNumSeoul) {
        bufSeoul.append(newValue2);
    } else {
        bufSeoul.remove(0); // remove first element
        bufSeoul.append(newValue2); // append to last index position
        // print(bufSeoul)
    }

    // println("len: " + bufLondon.size());
    wc2.update(bufLondon);
    wc2.direction(DIRECTION.UP);
    wc2.draw();

    wc.update(bufSeoul);
    wc.direction(DIRECTION.UP);
    wc.draw();

}

