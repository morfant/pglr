class Sensor {

  Body body;
  Vec2 pos = new Vec2(0, 0);
  Vec2 velocity = new Vec2(0, 0);
  float velMul = 2.0;
  float r = 80;
  color c = color(155, 25, 5);  
  boolean isFill = false;
  ArrayList<Object> neighbourList;


  Sensor(Vec2 _pos, float _r) {
    neighbourList = new ArrayList<Object>();
    pos = _pos;
    r = _r;
  }

  void update(Vec2 _pos) {
    pos = _pos;
  }

  void draw() {

    strokeWeight(0.1);

    if (isFill) {
      fill(0, 200, 100);
    } else {
      noFill();
      stroke(0, 200, 100);
    }

    pushMatrix();
    translate(pos.x, pos.y);
    ellipse(0, 0, r, r);

    stroke(255);
    textSize(20);
    text(neighbourList.size(), -7, 5);

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
    fd.filter.maskBits = BIT_PULLER | BIT_PULLEE;

    _body.createFixture(fd);
    //_body.setUserData(this);
    _body.getFixtureList().setUserData(this);
  }

  int numNeighbour(){
    return neighbourList.size();
  }
  
  void addNeighbour(Object o) {
    neighbourList.add(o);
  }

  int indexOf(Object o) {
    for (int i = neighbourList.size() - 1; i >= 0; i--) {
      if (neighbourList.get(i) == o) {
        return i;
      }
    }
    return -1;
  }

  void removeNeighbour(Object o) {
    int idx = indexOf(o);
    if (idx >= 0) {
      neighbourList.remove(idx);
    }
  }
}