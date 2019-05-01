//import processing.video.*;
import oscP5.*;
import netP5.*;
import processing.opengl.*;
//MovieMaker mm;

import processing.pdf.*;
import processing.svg.*;

boolean record;


int num = 50;
PVector tsp;
PVector tep;
float time;
Rlin[] lines = new Rlin[num];
OscP5 osc;
NetAddress myRemoteLocation;

void setup()
{
  osc = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
  smooth();
  //size(900, 900, OPENGL);
  size(900, 900, P3D);

  frameRate(20);

  beginRecord(PDF, "allSomeOfUseless-####.pdf");
  background(0);


  //  mm = new MovieMaker(this, width, height, "Rlins.mov", 30, MovieMaker.VIDEO, MovieMaker.LOSSLESS); 
  for (int i = 0; i < lines.length; i++)
  {
    tsp = new PVector(random(-width, width*2), random(-height, height*2), random(200));
    tep = new PVector(random(-width, width*2), random(-height, height*2), random(200));  

    //lines[i] = new Rlin(tsp, tep, 10, random(255), 140, random(90)); //original color
    lines[i] = new Rlin(tsp, tep, 255, 255, 255, random(10));    //mono tone
    //lines[i] = new Rlin(random(width), random(height), 255, 255, 255, 200);
  }
}



void draw()
{
  //frameRate(random(10));

  for (int i = 0; i < lines.length; i++)
  {
    lines[i].update();
    lines[i].display();
  }

  if (record) {
    print("record()!!");
    endRecord();
    record = false;
  }

  //  mm.addFrame();
}

void mousePressed() {
  /* createan osc message with address pattern /test */
  OscMessage myMessage = new OscMessage("/test");

  myMessage.add(123); /* add an int to the osc message */
  myMessage.add(456); /* add a second int to the osc message */

  /* send the message */
  osc.send(myMessage, myRemoteLocation);
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    record = true;
  }
}
