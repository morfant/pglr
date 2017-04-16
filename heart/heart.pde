/*
  #new Painter
  20170417
  cosOnLeftTopThat'sWhyThisIsHeart
 */

float posX = 0;
float posY = 0;
float posZ = 0;

float c = 0;
float rate = 0.0;
float pulseInterval = 0.0;
int count = 0;
int count_2 = 0;

float eyeY = 0;
float mouseScroll = 0;
float side = 0;

//boolean drawEnable = true;

//440, 235, -> 470, 539
PVector SP = new PVector(440, 235);
PVector EP = new PVector(470, 539);



void setup()
{
  size(700, 700, P3D);
  smooth();
  noFill();
  stroke(255);
  strokeWeight(0.9);
  frameRate(30);

  posX = width/3;
  posY = height/3;
  posZ = 0;

  side = width/32;

  //noLoop();
}


void draw()
{

  background(0, 0, 0, 170);
  count_2 = 0;
  count = 0;


  pushMatrix();
  translate(posX, posY, posZ);
  //rotateY(PI*sin(millis()/100));
  r(side, 300);
  popMatrix();

  pulseInterval = 0.1;
  
  //but sometimes that can be stopped
  rate = random(0.16, 0.19);
  if ((random(-0.1, 0.1) + noise(frameCount)) < rate) {
    pulseInterval = 0.0001;
    SP.set(440, 135);
    EP.set(490, 569);
  } else {
    // reset
    SP.set(440, 225);
    EP.set(470, 539);    
  }
  
  c+=pulseInterval;
  c = c%(PI);
  //println("c: " + c);
  float spd = sin(c);
  //println("spd: " + spd);
  PVector cp = moveVector(SP, EP, spd);
  camera(cp.x, height*eyeY/height, cp.y, width/2, height/2, 0.0, 0.0, 1.0, 0.0);
  //camera(width*mouseX/width, height*eyeY/height, height*mouseY/height, width/2, height/2, 0.0, 0.0, 1.0, 0.0);

  //saveFrame("frames/####.png");
}

PVector moveVector(PVector s, PVector e, float spd) {
  
  PVector rslt = PVector.lerp(SP, EP, map(spd, -1.0, 1.0, 0.0, 1.0));
  return rslt;
  
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
  //println("mX: " + mouseX); 
  //println("mY: " + mouseY);
}

void mouseWheel(MouseEvent event) {
  mouseScroll = event.getCount();
  //println(mouseScroll);
}

void mousePressed() {
  //drawEnable = true;
  redraw();  // or loop()
}