// https://www.youtube.com/watch?v=0PrIO5tweeo

/**
  * This sketch demonstrates how to use an FFT to analyze
  * the audio being generated by an AudioPlayer.
  * <p>
  * FFT stands for Fast Fourier Transform, which is a 
  * method of analyzing audio that allows you to visualize 
  * the frequency content of a signal. You've seen 
  * visualizations like this before in music players 
  * and car stereos.
  * <p>
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioInput in;
FFT         fft;
int num = 100;
float[][] buffers = new float[num][513];

int cnt = 0;
void setup()
{
//   size(512, 1000, P3D);
  size(1920, 512, P3D);
  
  minim = new Minim(this);
  
  // specify that we want the audio buffers of the AudioPlayer
  // to be 1024 samples long because our FFT needs to have 
  // a power-of-two buffer size and this is a good size.
//   jingle = minim.loadFile("jingle.mp3", 1024);
  
  // loop the file indefinitely
//   jingle.loop();
  in = minim.getLineIn();
  
  // create an FFT object that has a time-domain buffer 
  // the same size as jingle's sample buffer
  // note that this needs to be a power of two 
  // and that it means the size of the spectrum will be half as large.
  fft = new FFT( in.bufferSize(), in.sampleRate() );
  
  background(0);
}

void draw()
{

//   background(0);
  stroke(255);
  
  // perform a forward FFT on the samples in jingle's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward( in.mix );
  
    // for (int j = 0; j < num - 1; j++) {
    //     buffers[j] = buffers[j+1];
    // }



    for(int i = 0; i < fft.specSize(); i++)
    {
    //     // draw the line for frequency band i, scaling it up a bit so we can see it
    //     // line( i, height, i, height - fft.getBand(i)*8 );
    //     // line( 100, height - i, -fft.getBand(i), 100, height - i, fft.getBand(i) );
    noStroke();
    // noFill();
    rectMode(CENTER);
        // ellipse(cnt, height-i, fft.getBand(i)/10, fft.getBand(i)/10);
        rect(cnt, height-i, fft.getBand(i)/200*i, fft.getBand(i)/200*i);
        // ellipse(cnt, height-i, fft.getBand(i)/200*i, fft.getBand(i)/200*i);
    //     // buffers[j][i] = fft.getBand(i);
    //     // buffers[j][i] = buffers[j+1][i];
    //     buffers[buffers.length - 1][i] = fft.getBand(i);
    }

    cnt++;
    if (cnt >= width) {
        background(0);
        cnt = 0;
    }



//   for (int j = num - 1; j > 0; j--) {
//   for (int j = 0; j < num; j++) {
    //   int len = buffers[j].length;
    //   for (int i = 0; i < len; i++) {
        //   ellipse(j, height - i * 3, buffers[j][i]/30, buffers[j][i]/30);
        // line(width-j, height - i , -buffers[j][i], width-j, height - i , buffers[j][i]);
        // line(j -buffers[j][i], height - i, j + buffers[j][i], height - i );
    //   }
//   }
}