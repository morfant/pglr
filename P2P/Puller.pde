class Puller {

  Body body;
  Sensor sensor;
  Vec2 pos = new Vec2(0, 0);
  Vec2 velocity = new Vec2(0, 0);
  Vec2 force = new Vec2(0, 0);
  float velMul = 50.0;
  float r = 20;
  float dens = 0.4;
  color c = color(155, 25, 5, 100);

  float power = 1.0;
  float pullRange = 100;


  Puller() {
    //r = random(15.0, 30.0);
    sensor = new Sensor(pos, r * 3);
    //power = random(0.1, 1.0);
    pos = new Vec2(random(r/2, width-r/2), random(r/2, height-r/2));
    velocity = new Vec2(random(-0.5, 0.5)*velMul, random(-0.5, 0.5)*velMul);

    makeBody(new Vec2(pos.x, pos.y), r);
    sensor.make(body);

    body.setLinearVelocity(new Vec2(velocity.x, velocity.y));
    body.setAngularVelocity(random(-5, 5));
  }


  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  void makeBody(Vec2 center, float _r) {

    // Define a polygon (this is what we use for a rectangle)
    CircleShape circle = new CircleShape();
    float r_toWorld = box2d.scalarPixelsToWorld(_r);
    circle.m_radius = r_toWorld/2;


    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = circle;

    fd.filter.categoryBits = BIT_PULLER;
    fd.filter.maskBits = BIT_BOUNDARY | BIT_SENSOR | BIT_PULLER;

    // Parameters that affect physics
    fd.density = dens;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
    body.setUserData(this);
  }

  void update() {

    Vec2 body_pos = box2d.getBodyPixelCoord(body);
    Vec2 _pos = new Vec2(body_pos.x, body_pos.y);
    sensor.update(_pos);

    forceFowardNeighbour();
  }


  void draw() {

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


  void forceFowardNeighbour() {
    Vec2 this_body_pos = body.getWorldCenter();
    //Vec2 force = new Vec2(0, 0);
    PVector forceSum = new PVector(0, 0);
    for (Object o : sensor.neighbourList) {
      if (o.getClass() == Pullee.class) {
        Pullee p = (Pullee) o;
        Vec2 f = p.body.getWorldCenter().sub(body.getWorldCenter());
        forceSum = PVector.add(forceSum, new PVector(f.x*attraction_Pullee, f.y*attraction_Pullee));
        //println("f: " + f);
      } else if (o.getClass() == Puller.class) {
        Puller p = (Puller) o;
        Vec2 f = p.body.getWorldCenter().sub(body.getWorldCenter());
        forceSum = PVector.add(forceSum, new PVector(f.x*attraction_Puller, f.y*attraction_Puller));
        //println("f: " + f);
      }
    }

    forceSum.normalize();
    //println("force: " + force);

    force = new Vec2(forceSum.x, forceSum.y);
    force.mulLocal(forceStrength * this.body.m_mass);
    this.body.applyForce(force, this.body.getWorldCenter());
  }
}