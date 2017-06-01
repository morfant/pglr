import processing.pdf.*;
import processing.svg.*;

boolean record;
ArrayList<Dot> dots;


void setup()
{
  size(700, 800);
  frameRate(30);
  smooth();
  dots = new ArrayList<Dot>();  

  // Start by adding one element
  for (int i = 0; i < 14000; i++) {
    dots.add(new Dot());
  }
}


void draw()
{

  if (record) {
    // Note that #### will be replaced with the frame number. Fancy!
    //beginRecord(SVG, "dots-frame-####.svg");
    beginRecord(PDF, "dots-frame-####.pdf");
  }


  background(0, 0, 0, 255);

  for (int i = dots.size()-1; i >= 0; i--) { 
    // An ArrayList doesn't know what it is storing so we have to cast the object coming out
    Dot dot = dots.get(i);
    dot.update();
    dot.draw();
  }


  if (record) {
    endRecord();
    record = false;
  }
  
}


void mousePressed() {
  //println("mousePressed() !!");
  dots.add(new Dot());
}


void keyPressed() {
  if (key == 'c' || key == 'C') {
      record = true;
  }
}