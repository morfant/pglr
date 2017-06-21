class Pullee extends Puller {

  //PVector pos = new PVector(0, 0, 0);
  //PVector velocity = new PVector(0, 0, 0);
  //float spd = 20.0;
  //float force = 0.5;
  float r = 30;
  color c = color(255, 205, 50, 140);


  Pullee() {
    //r = random(15.0, 30.0);
    //r = 8.0;
    sensor = new Sensor(pos, r * 3);
    //power = random(0.1, 1.0);
    pos = new Vec2(random(r/2, width-r/2), random(r/2, height-r/2));
    velocity = new Vec2(random(-0.5, 0.5)*velMul, random(-0.5, 0.5)*velMul);

    makeBody(new Vec2(pos.x, pos.y), r);
    sensor.make(body);

    body.setLinearVelocity(new Vec2(velocity.x, velocity.y));
    body.setAngularVelocity(random(-5, 5));
  }

  void forceFowardNeighbour() {
    Vec2 this_body_pos = body.getWorldCenter();
    //Vec2 force = new Vec2(0, 0);
    PVector forceSum = new PVector(0, 0);
    for (Object o : sensor.neighbourList) {
      if (o.getClass() == Pullee.class) {
        Pullee p = (Pullee) o;
        Vec2 f = p.body.getWorldCenter().sub(body.getWorldCenter());
        forceSum = PVector.add(forceSum, new PVector(f.x, f.y));
        //println("f: " + f);
      } else if (o.getClass() == Puller.class){
        Puller p = (Puller) o;
        Vec2 f = p.body.getWorldCenter().sub(body.getWorldCenter());
        forceSum = PVector.add(forceSum, new PVector(-f.x, -f.y));
      }
    }

    forceSum.normalize();
    //println("force: " + force);

    force = new Vec2(forceSum.x, forceSum.y);
    force.mulLocal(forceStrength * this.body.m_mass);
    this.body.applyForce(force, this.body.getWorldCenter());
  }


  void draw() {

    //    pushMatrix();
    //    translate(pos.x, pos.y);
    //    fill(c);
    //    ellipse(0, 0, r, r);
    //    popMatrix();

    stroke(255);
    fill(c);
    strokeWeight(1);

    // We look at each body and get its screen position
    Vec2 _pos = box2d.getBodyPixelCoord(body);

    // Get its angle of rotation
    float a = body.getAngle();

    pushMatrix();
    translate(_pos.x, _pos.y);

    // force director - before rotating
    stroke(255, 0, 255);    
    strokeWeight(1);
    //line(0, 0, force.x, -force.y);    

    // Circle
    stroke(255);
    strokeWeight(1);
    noStroke();
    rotate(-a);
    ellipse(0, 0, r, r);

    popMatrix();

    //sensor.draw();
  }
};