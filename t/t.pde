/*
  20170412
 rrrrrrosees
 */

float posX = 0;
float posY = 0;
float posZ = 0;

int count = 0;
int count_2 = 0;
float eyeY = 0;
float mouseScroll = 0;
float side = 0;

boolean drawEnable = true;

//440, 235, -> 470, 539
PVector SP = new PVector(440, 235);
PVector EP = new PVector(470, 539);

PVector sp = new PVector(440, 235);
PVector ep = new PVector(470, 539);


float dist = 0.0;
boolean dir = true;
int dur = 60;
float DX = 0;
float DY = 0;

void setup()
{
  size(700, 700, P3D);
  smooth();
  noFill();
  stroke(255);
  strokeWeight(0.9);
  frameRate(60);

  posX = width/2;
  posY = height/2;
  posZ = 0;

  side = width/32;

  DX = ep.x - sp.x;
  DY = ep.y - sp.y;

  //noLoop();
}


void draw()
{

  background(0, 0, 0, 170);
  //fill(0, 0, 0, 60);
  //rect(0, 0, width, height);
  count_2 = 0;
  count = 0;

  //count = 0;
  //posX = 0;
  //posY = 0;
  //posZ = 0;
  pushMatrix();
  translate(posX, posY, posZ);
  ////rotateY(PI*sin(millis()/100));
  r(side, 300);
  popMatrix();

  //r2(side, count_2);


  //pushMatrix();
  //translate(posX, posY, posZ);
  //box(40);
  ////rect(width/2, height/2, width/8, width/8);
  //popMatrix();

  //posZ+=2;
  //posY+=0.5;

  float spd = sin(frameCount%(2*PI));
  println("spd: " + spd);

  PVector cp = move2Point(sp, ep, 4);
  PVector tp = new PVector(0, 0);
  if (dir == true) {
    sp.x = cp.x;
    sp.y = cp.y;
    tp.x = sp.x;
    tp.y = sp.y;
  } else {
    ep.x = cp.x;
    ep.y = cp.y;
    tp.x = ep.x;
    tp.y = ep.y;
  }
  println("tp x/y: " + tp.x + " / " + tp.y);
  camera(tp.x, height*eyeY/height, tp.y, width/2, height/2, 0.0, 0.0, 1.0, 0.0);
  //camera(width*mouseX/width, height*eyeY/height, height*mouseY/height, width/2, height/2, 0.0, 0.0, 1.0, 0.0);

  //saveFrame("frames/####.tif");
}


PVector move2Point(PVector s, PVector e, float spd) {

  //println("move2Point(" + sp+ ")");
  if (dur == 60) {
    println("sp / ep: " + sp + " / " + ep);
  }

  float rx = 0.0;
  float ry = 0.0;
  float dx = e.x - s.x;
  float dy = e.y - s.y;



  if (dir == true) {
    println("inc");
    if (s.x + (dx/dur + spd) <= e.x) rx = s.x + dx/dur;
    if (s.y + (dy/dur + spd) <= e.y) ry = s.y + dy/dur;
  } else {
    println("dec");
    if (e.x - (dx/dur + spd) >= s.x) rx = e.x - dx/dur;
    if (e.y - (dy/dur + spd) >= s.y) ry = e.y - dy/dur;
  }


  dur--;
  println("dur: " + dur);
  
  if (dur == 0) {
    dir = !dir;
    println("reverse dir: " + dir);
    dur = 60;
    sp = new PVector(440, 235);
    ep = new PVector(470, 539);
  }



  PVector r = new PVector(rx, ry);
  return r;
}

float r2(float in, int in2) {
  count_2++;

  print("count_2: " + count_2);

  count = 0;
  posX = random(width);
  posY = random(height);
  posZ = random(-1500, 300);
  pushMatrix();
  translate(posX, posY, posZ);
  rotateY(PI*sin(millis()/100));
  r(noise(in), 200);
  popMatrix();

  if (count_2 < 1) {
    r2(in, in2);
  }

  return in;
}

float r(float in, int in2)
{
  count++;
  //println("count: " + count);

  //if (posX > width) {
  //  posY+=in;
  //} else if (posY > height) {
  //  posZ+=in;
  //} else {
  //  posX+=in;
  //}

  //in=side*cos(in);
  in=side*tan(in);
  stroke(150+55*noise(in), 0, noise(in)*80, noise(in)*255);

  float sw = noise(count);
  //println("sw: " + sw);
  strokeWeight(1*sw);


  //println("count: " + count);
  pushMatrix();
  //translate(posX, posY, posZ);
  //rotateX(noise(cos(in)*PI));
  //rotateY(noise(0, sin(in)*PI/2));
  //box(in);
  sphereDetail((int)(7*noise(in)));
  sphere(in);
  popMatrix();
  //in/=count;

  if (count < in2) {
    //println("count: " + count);
    //println("r(in)");
    //println("posX: " + posX);
    r(in, in2);
  }


  //posX = posX%width;

  //println("in: " + in);
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
  println("mX: " + mouseX); 
  println("mY: " + mouseY);
}

void mouseWheel(MouseEvent event) {
  mouseScroll = event.getCount();
  //println(mouseScroll);
}

void mousePressed() {
  //drawEnable = true;
  redraw();  // or loop()
}