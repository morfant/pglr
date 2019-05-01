//import processing.video.*;
//MovieMaker mm;

import processing.pdf.*;
import processing.svg.*;

boolean record;

int num = 50;
PVector sp;
PVector velo;
PVector ep;
float time;
Rlin[] lines = new Rlin[num];


void setup()
{

  smooth();
  size(1000, 1000);
  frameRate(20);

  //  sp = new PVector(random(width), random(height));
  //  ep = new PVector(0, 0);
  //  mm = new MovieMaker(this, width, height, "Rlins.mov", 30, MovieMaker.H263, MovieMaker.HIGH); 
  for (int i = 0; i < lines.length; i++)
  {
    lines[i] = new Rlin(random(width), random(height), 10, random(255), 140, random(90));
    //    lines[i] = new Rlin(random(width), random(height), 255, 255, 255, 200);
  }
  
  beginRecord(PDF, "allSomeOfUseless-####.pdf");
  background(0);


}



void draw()
{

  //    stroke(255);
  ////  velo = new PVector(random(-0.3, 0.3), random(-0.3, 0.3));
  //  velo = new PVector(random(-8, 8), random(-1, 1));
  ////  velo.mult(50);
  //  ep = PVector.add(sp, velo);
  //  line(sp.x, sp.y, ep.x, ep.y);
  //  sp = ep;

  for (int i = 0; i < lines.length; i++)
  {
    lines[i].update();
    lines[i].display();
  }

  //  mm.addFrame();  

  if (record) {
    print("record()!!");
    endRecord();
    record = false;
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    record = true;
  }
}
