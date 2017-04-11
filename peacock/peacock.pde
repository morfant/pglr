// 20170410_peacock

float c = 0;
int r = 255;
int g = 255;
int b = 255;

void setup()
{
  size(1280, 900, P3D);  
  frameRate(10);
  smooth();
  strokeWeight(0.1);
}


void draw()
{
  background(0);
  r = 255;
  g = 255;
  b = 255;

  c+=0.01;
  r(2*tan(c), random(c/100));
  
  //saveFrame("frames/####.png");
}


float r(float in, float in2)
{
  float d = in;
  d+=0.6;

  stroke(r, g, b);

  if (d%8 == 0 || d%5 == 0 || d%2 == 0) {
    r = 0;
    g = 90;
    b = 100;
  };

  line(width/2, height/2, 0, width/in2/d, height/d, 900);
  line(width/2, height/2, 0, width/in2/d, d, 900);  

  if (d < height) {
    r(d, in2);
  }

  return d;
}