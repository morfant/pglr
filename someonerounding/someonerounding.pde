/*
  someone rounding
  2017.04.09
*/

float count = 0;

void setup() {
  size(1280, 900);

  // Set the background to black and turn off the fill color
  background(0);
  noFill();
  smooth();

  stroke(0, 153, 255);
  line(0, height*0.5, width, height*0.5);
}

void draw() {
  background(0, 0, 0, 100);

  stroke(0, 153, 255);
  line(0, height*0.5, width, height*0.5);
  
  count+=0.01;
  count = count%(2*PI);
  float t = 1*tan(count);
  //println(t);
  r(width + t);
}


float r(float d) {
  float t = d;
  t*=0.9;

  if (t > 0.00001) {
    stroke(255, 153, 0, 255);
    strokeWeight(3*(0.15 + t/width));
    //println(t/width);
    ellipse(width/t, height * 0.5, width*sin(t), height*cos(t));

    r(t);
    //println(r(t));
  }
  return d;
}