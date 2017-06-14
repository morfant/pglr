class Puller {

  int OVERLAP_TIME_LIMIT = 10;
  PVector pos = new PVector(0, 0, 0);
  PVector velocity = new PVector(0, 0, 0);
  float spd = 20.0;
  float force = 0.5;
  float r = 80;
  float m = r*0.1;
  int findRange = 100;
  color c = color(155, 25, 5);
  int overlapTime = 0;

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


  void isCollide(Puller other) {
    float d = PVector.dist(pos, other.pos);

    if (d <= r/2 + other.r/2 && overlapTime < OVERLAP_TIME_LIMIT) {
      stroke(255);
      strokeWeight(10);
      line(pos.x, pos.y, other.pos.x, other.pos.y);

      float nx = (other.pos.x - pos.x) / d;
      float ny = (other.pos.y - pos.y) / d;

      float p = 2 * (
        (velocity.x * nx + velocity.y * ny) - 
        (other.velocity.x * nx + other.velocity.y * ny)
        ) / (m + other.m);

      velocity.x = velocity.x - p * m * nx;
      velocity.y = velocity.y - p * m * ny;
      other.velocity.x = other.velocity.x + p * other.m * nx;
      other.velocity.y = other.velocity.y + p * other.m * ny;

      //overlapTime++;
      //println("overlaptime: " + overlapTime);
    }
    //else if (d > r/2 + other.r/2) {
    //  overlapTime = 0;
    //  println("overlaptime: " + overlapTime);
    //} else if (overlapTime > OVERLAP_TIME_LIMIT) {
    //  println("overlaptime over!!!");
    //}
  }
  
  
  void checkCollision(Puller other) {

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other.pos, pos);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = r/2 + other.r/2;

    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other.pos.add(correctionVector);
      pos.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball poss. You 
       just need to worry about bTemp[1] pos*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's pos is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].pos.x and bTemp[0].pos.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball poss and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen pos
      other.pos.x = pos.x + bFinal[1].x;
      other.pos.y = pos.y + bFinal[1].y;

      pos.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
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