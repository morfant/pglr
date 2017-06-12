class Pulle {

  
  PVector pos = new PVector(0, 0, 0);
  PVector velocity = new PVector(0, 0, 0);
  float spd = 20.0;
  float force = 0.5;
  float r = 40;
  color c = color(255, 205, 50);


  Pulle() {
    pos = new PVector(random(r/2, width-r/2), random(r/2, height-r/2));
    velocity = new PVector(random(-0.5, 0.5)*spd, random(-0.5, 0.5)*spd);

  }


  void update() {
  }


  void draw() {
    
    pushMatrix();
    translate(pos.x, pos.y);
    fill(c);
    ellipse(0, 0, r, r);
    popMatrix();
  }
  
};