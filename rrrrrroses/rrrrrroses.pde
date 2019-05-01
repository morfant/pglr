/*
  20170412
 rrrrrrosees
 */


import processing.pdf.*;
import processing.svg.*;
boolean record;


float posX = 0;
float posY = 0;
float posZ = 0;

int count = 0;
int count_2 = 0;
float eyeY = 0;
float mouseScroll = 0;
float side = 0;

boolean drawEnable = true;

void setup()
{
  size(3600, 2200, P3D);
  smooth();
  noFill();
  stroke(255);
  strokeWeight(0.5);
  frameRate(30);

  posX = width/2;
  posY = height/2;
  posZ = -1500;

  side = width/12;

  noLoop();
  //background(0, 0, 0, 170);
}


void draw()
{
  //beginRaw(PDF, "rrose-####.pdf");
  //beginRecord(PDF, "rrose-####.pdf");
  background(0, 170);
  //fill(0, 0, 0, 60);
  //rect(0, 0, width, height);
  count_2 = 0;

  //count = 0;
  posX = 0;
  posY = 0;
  posZ = 0;
  //pushMatrix();
  //translate(posX, posY, posZ);
  ////rotateY(PI*sin(millis()/100));
  //r(width/4);
  //popMatrix();

  r2(side);


  //pushMatrix();
  //translate(posX, posY, posZ);
  //box(40);
  ////rect(width/2, height/2, width/8, width/8);
  //popMatrix();

  //posZ+=2;
  //posY+=0.5;

  //camera(width*mouseX/width, height*eyeY/height, height*mouseY/height, width/2, height/2, 0.0, 0.0, 1.0, 0.0);
  //camera(width*mouseX/width, height*eyeY/height, height*mouseY/height, width/2, height/2, 0.0, 0.0, 1.0, 0.0);

  saveFrame("frames/####.tif");


  //print("record pdf");
  //endRaw();
  //endRecord();
  
}


float r2(float in) {
  count_2++;

  //print("count_2: " + count_2);

  count = 0;
  posX = random(width);
  posY = random(height);
  posZ = random(-1500, 300);
  pushMatrix();
  translate(posX, posY, posZ);
  rotateY(PI*sin(millis()/100));
  r(noise(in));
  popMatrix();

  if (count_2 < 200) {
    r2(in);
  }

  return in;
}

float r(float in)
{
  count++;

  //if (posX > width) {
  //  posY+=in;
  //} else if (posY > height) {
  //  posZ+=in;
  //} else {
  //  posX+=in;
  //}

  //println("count: " + count);
  pushMatrix();
  //translate(posX, posY, posZ);
  rotateX(noise(cos(in)*PI));
  rotateY(noise(0, sin(in)*PI/2));
  box(in);
  popMatrix();
  //in/=count;
  in=side*cos(in);

  stroke(150+55*noise(in), 0, noise(in)*80, noise(in)*255);

  if (count < 320) {
    //println("count: " + count);
    //println("r(in)");
    //println("posX: " + posX);
    r(in);
  }


  //posX = posX%width;


  return in;
}



void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      eyeY+=100;
    } else if (keyCode == DOWN) {
      eyeY-=100;
    } else if (keyCode == ENTER) {
      saveFrame("frames/####.tif");
    }
  }
}

void mouseMoved() {
  //println("mX: " + mouseX); println("mY: " + mouseY);
}

void mouseWheel(MouseEvent event) {
  mouseScroll = event.getCount();
  //println(mouseScroll);
}

void mousePressed() {
  //drawEnable = true;
  redraw();  // or loop()
}
