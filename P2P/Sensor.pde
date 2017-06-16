class Sensor {

  Body body;
  PVector pos = new PVector(0, 0, 0);
  PVector velocity = new PVector(0, 0, 0);
  float spd = 2.0;
  float force = 0.5;
  float power = 1.0;
  float pullRange = 100;
  float r = 80;
  color c = color(155, 25, 5);
  boolean isFill = false;


  Sensor(PVector _pos, float _r) {
    pos = _pos;
    r = _r;
  }

  void update(PVector _pos) {
    pos = _pos;
  }

  void draw() {

    if (isFill) {
      fill(0, 200, 100);
    } else {
      noFill();
      stroke(0, 200, 100);
    }

    pushMatrix();
    translate(pos.x, pos.y);
    ellipse(0, 0, r, r);
    popMatrix();
  }

  void change() {
    isFill = true;
  }

  void make(Body _body) {

    // Define a polygon (this is what we use for a rectangle)
    CircleShape circle = new CircleShape();
    float r_toWorld = box2d.scalarPixelsToWorld(r/2);
    circle.m_radius = r_toWorld;

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = circle;
    fd.isSensor = true;
    fd.filter.categoryBits = BIT_SENSOR;
    fd.filter.maskBits = BIT_PULLER;

    _body.createFixture(fd);
    _body.setUserData(this);
  }
}