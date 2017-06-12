class Puller {

  Body body;
  PVector pos = new PVector(0, 0, 0);
  PVector velocity = new PVector(0, 0, 0);
  float spd = 200.0;
  float force = 0.5;
  float r = 40;
  color c = color(255, 25, 5);

  Puller() {
    pos = new PVector(random(r/2, width-r/2), random(r/2, height-r/2));
    velocity = new PVector(random(-0.5, 0.5)*spd, random(-0.5, 0.5)*spd);
    makeBody(new Vec2(pos.x, pos.y), r, r);

    body.setLinearVelocity(new Vec2(velocity.x, velocity.y));
    body.setAngularVelocity(random(-5, 5));
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
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


  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    CircleShape circle = new CircleShape();
    float box2dW = box2d.scalarPixelsToWorld(w_);
    float box2dH = box2d.scalarPixelsToWorld(h_);
    circle.m_radius = box2dW/2;

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = circle;
    // Parameters that affect physics
    fd.density = 0.4;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
  }

  void update() {

    //keepBorder();
    //pos.add(velocity);
  }


  void draw() {

    fill(c);
    //ellipse(pos.x, pos.y, r, r);

    // We look at each body and get its screen position
    Vec2 _pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    pushMatrix();
    translate(_pos.x, _pos.y);
    rotate(-a);
    //fill(175);
    //stroke(0);
    ellipse(0, 0, r, r);
    //rect(0, 0, w, h);
    popMatrix();
  }
}