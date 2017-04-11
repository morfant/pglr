import gifAnimation.*;

float c = 0;
int r = 255;
int g = 255;
int b = 255;

GifMaker gifExport;

void setup()
{

  //size(800, 400, P3D);
  size(1280, 900, P3D);  
  //size(320, 240, P3D);  
  frameRate(10);


  gifExport = new GifMaker(this, "test.gif");
  gifExport.setRepeat(0);        // make it an "endless" animation
  //gifExport.setTransparent(0, 0, 0);  // black is transparent

  smooth();
  //r(r(r(r(r(r(0))))));
  //r(0, 7);

  //stroke(255);
  strokeWeight(0.1);
}


void draw()
{
  background(0);
  r = 255;
  g = 255;
  b = 255;
  //stroke(255);
  //r(0, random(0.1));
  c+=0.01;
  //r(2*sin(c), noise(0.3));
  //r(2*sin(c), noise(0.3));  
  r(2*tan(c), random(c/100));

  //gifExport.setDelay(1);
  //gifExport.addFrame();
  
  saveFrame("frames/####.png");
}


float r(float in, float in2)
{

  float d = in;
  //d+=random(-1, 1.3);
  d+=0.6;

  stroke(r, g, b);
  //ellipse(width/2+(d/height), height/d, 5*d, 5/d);

  //strokeWeight(1);

  if (d%8 == 0 || d%5 == 0 || d%2 == 0) {
    r = 0;
    g = 90;
    b = 100;

    //println("!!!!!");
  };

  line(width/2, height/2, 0, width/in2/d, height/d, 900);
  line(width/2, height/2, 0, width/in2/d, d, 900);  

  if (d < height) {
    //println(d);
    r(d, in2);
  }


  return d;
}


void mousePressed() {
  gifExport.finish();          // write file
}