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

void setup()
{
  size(700, 700, P3D);
  smooth();
  noFill();
  stroke(255);
  strokeWeight(0.1);
  frameRate(60);

  posX = width/2;
  posY = height/2;
  posZ = 0;

  side = width/4;

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
  r(side, 200);
  popMatrix();

  //r2(side, count_2);
  


  //pushMatrix();
  //translate(posX, posY, posZ);
  //box(40);
  ////rect(width/2, height/2, width/8, width/8);
  //popMatrix();

  //posZ+=2;
  //posY+=0.5;

  camera(width/2+width*cos(millis()/250), height*eyeY/height, height/2+height*sin(millis()/150), width/2, height/2, 0.0, 0.0, 1.0, 0.0);
  //camera(width*mouseX/width, height*eyeY/height, height*mouseY/height, width/2, height/2, 0.0, 0.0, 1.0, 0.0);

  //saveFrame("frames/####.tif");
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


  //println("count: " + count);
  pushMatrix();
  //translate(posX, posY, posZ);
  //rotateX(noise(cos(in)*PI));
  //rotateY(noise(0, sin(in)*PI/2));
  //box(in);
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