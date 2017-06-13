class Puller {

  PVector pos = new PVector(0, 0, 0);
  PVector velocity = new PVector(0, 0, 0);
  float spd = 20.0;
  float force = 0.5;
  float r = 60;
  float m = r*0.1;
  int findRange = 100;
  color c = color(125, 25, 5);

  Puller() {
    pos = new PVector(random(r/2, width-r/2), random(r/2, height-r/2));
    velocity = new PVector(random(-0.5, 0.5)*spd, random(-0.5, 0.5)*spd);
  }

  
  void keepBorder() {

    if (pos.x + r/2 >= width) {
      velocity.x *= -1.0;
    } else if (pos.x - r/2 <= 0) {
      velocity.x *= -1.0;
    } else if (pos.y - r/2 <= 0) {
      velocity.y *= -1.0;
    } else if (pos.y + r/2 >= height) {
      velocity.y *= -1.0;
    }
    
  }
  
  
  boolean isCollide(Puller other){
    float d = PVector.dist(pos, other.pos);
    
    if (d <= r + other.r){
      return true;
    }
    
    return false;
  }
  
  

  void update() {

    keepBorder();
    pos.add(velocity);
    
  }


  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    fill(c, 200);
    ellipse(0, 0, r, r);
    popMatrix();
  }
  
  
};