import processing.sound.*;

int bands = 1024;
FFT fft, fft2;
AudioIn in, in2;
float[] spectrum = new float[bands];
float[] spectrum2 = new float[bands];

int cnt = 0;
int visualizeMul = width/4;

void setup() {
  size(1920, 1024);
  background(0);
  rectMode(CENTER);

  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  fft2 = new FFT(this, bands);
  in = new AudioIn(this, 0);
  in2 = new AudioIn(this, 1);


  // start the Audio Input
  in.start();
  in2.start();

  // patch the AudioIn
  fft.input(in);
  fft2.input(in2);
}      


void draw()
{
  fft.analyze(spectrum);
  fft2.analyze(spectrum2);

  for (int i = 0; i < bands; i++)
  {
    //stroke(255, spectrum[i] * visualizeMul * i);
    noStroke();
    fill(255, spectrum[i] * visualizeMul * i);
    //noFill();
    //rect(cnt, height-i, spectrum[i] * visualizeMul * i, spectrum[i] * visualizeMul * i);
    ellipse(cnt, height-i, spectrum[i] * visualizeMul * i, spectrum[i] * visualizeMul * i);
    
    
    //stroke(255, spectrum2[i] * visualizeMul * i);
    //stroke(200, 10, 100);
    //noStroke();
    fill(255, 100, 100, spectrum2[i] * visualizeMul * i);
    //noFill();
    //rect(cnt, height-i, spectrum2[i] * visualizeMul * i, spectrum2[i] * visualizeMul * i);
    ellipse(cnt, height-i, spectrum2[i] * visualizeMul * i, spectrum2[i] * visualizeMul * i);
    
  }

  cnt++;
  if (cnt >= width) {
    background(0);
    cnt = 0;
  }
}
