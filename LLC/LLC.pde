
import processing.sound.*;
SoundFile file;
Amplitude amp;
PImage img;  // Declare variable "a" of type PImage
float marginTop = 117;
float marginBottom = 70;
float marginLeft = 173;
float marginRight = 128;
// int[] xAxis = new int[29];
// float[] yAxis = new float[29];
PVector[] points = new PVector[5];
float alpha = 0;
Cochlear co;

void setup() {
  // 2560, 1800 // img size
  // 853, 600 // img size /3
  size(853, 600);
  // fullScreen();
  noCursor();

  img = loadImage("LLC.jpg");  // Load the image into the program  

  points[0] = new PVector(marginLeft, 70);
  points[1] = new PVector(485, 5);
  points[2] = new PVector(592, 0);
  points[3] = new PVector(668, 15);
  points[4] = new PVector(width - marginRight, 40);

  co = new Cochlear(width/2, height/2);

  amp = new Amplitude(this);
  file = new SoundFile(this, "sleeve.mp3");
  file.play();
  amp.input(file);

}


void draw() {
  // Displays the image at point (0, height/2) at half of its size
  background(255);
  tint(255, alpha);
  image(img, 0, 0, img.width/3, img.height/3);

  // float graphWidth = width - (marginLeft + marginRight);
  // float graphHeight = height - (marginTop + marginBottom);
  // fill(0, 255 - alpha);
  // rect(marginLeft, marginTop, graphWidth, graphHeight);
  
  stroke(0);
  strokeWeight(4);
  float x = constrain(mouseX, marginLeft, width-marginRight);
  // line(x, marginTop, x, height - marginBottom);

  if (alpha < 20) {
    float vol = amp.analyze();
    println(vol);
    co.setCoefs(vol * 2, vol * 9);
    co.setOffsetStep(0.19 - (vol/2));
    co.setSpin(true);
  } else {
    co.setCoefs(1, 0);
    co.setOffsetStep(0.19);
    co.setSpin(false);
  }

  // co.setColor(color(255, 205, 0));
  co.setPos(x, height - marginBottom);
  co.setAngle(270);
  co.update();
  co.draw();


  // println(mouseX);
  float val = 255; 
  if (x <= points[0].x) {

  } else if (x < points[1].x) {
    float range = points[1].x - points[0].x;
    float d = x - points[0].x;
    val = lerp(points[0].y, points[1].y, d/range);
  } else if (x < points[2].x) {
    float range = points[2].x - points[1].x;
    float d = x - points[1].x;
    val = lerp(points[1].y, points[2].y, d/range);
  } else if (x < points[3].x) {
    float range = points[3].x - points[2].x;
    float d = x - points[2].x;
    val = lerp(points[2].y, points[3].y, d/range);
  } else if (x <= points[4].x) {
    float range = points[4].x - points[3].x;
    float d = x - points[3].x;
    val = lerp(points[3].y, points[4].y, d/range);
  } 

  alpha = map(val, 0, 70, 0, 255);

  // println(alpha);

  // set volume
  float vol = map(alpha, 0, 255, 1.0, 0.0);
  file.amp(vol);

}
