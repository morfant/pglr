class Dot {

  float x;
  float y;
  float r = 5;
  float bps = 0.01; // beat per sec
  float radius;


  Dot() {
    x = random(0, width);
    y = random(0, height);
    r = random(1, 10);
    //bps = random(0.2, 0.9);
  }


  void update()
  {
    radius = r * (2 + sin( (millis()/(1000/TWO_PI)*bps) % TWO_PI)); // float
    //radius = r * (2 + sin( (millis()/(1000/TWO_PI)*(int)bps) % TWO_PI)); // int
    
  }

  void draw()
  {
    //fill(255);
    noFill();
    //noStroke();
    stroke(255, 255, 255, 50);
    strokeWeight(10.0 * noise(radius));
    ellipse(x, y, radius, radius);
  }
  
}