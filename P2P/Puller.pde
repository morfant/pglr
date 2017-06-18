class Puller {

  ArrayList<Puller> inSensor;
  Body body;
  Sensor sensor;
  PVector pos = new PVector(0, 0, 0);
  PVector velocity = new PVector(0, 0, 0);
  float spd = 10.0;
  float force = 0.5;
  float power = 1.0;
  float pullRange = 100;
  float r = 14;
  float dens = 0.9;
  color c = color(155, 25, 5);


  Puller() {
    inSensor = new ArrayList<Puller>();
    r = random(5.0, 20.0);
    sensor = new Sensor(pos, r * 3);
    //power = random(0.1, 1.0);
    pos = new PVector(random(r/2, width-r/2), random(r/2, height-r/2));
    velocity = new PVector(random(-0.5, 0.5)*spd, random(-0.5, 0.5)*spd);
    
    makeBody(new Vec2(pos.x, pos.y), r);
    sensor.make(body);

    body.setLinearVelocity(new Vec2(velocity.x, velocity.y));
    body.setAngularVelocity(random(-5, 5));


  }

  void addNeighbour(Puller n){
    inSensor.add(n);
  }
  
  void subNeighbour(int idx){
    inSensor.remove(idx);
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
    fd.friction = 0.1;
    fd.restitution = 0.001;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
    body.setUserData(this);


    /*
    // attach sensor
     CircleShape circle_sensor = new CircleShape();
     float r_toWorld_sensor = box2d.scalarPixelsToWorld(_r * 2);
     circle_sensor.m_radius = r_toWorld_sensor/2;
     
     // Define a fixture
     FixtureDef fd_sensor = new FixtureDef();
     fd_sensor.shape = circle_sensor;
     fd_sensor.isSensor = true;
     //fd_sensor.filter.categoryBits = BIT_SENSOR;
     //fd_sensor.filter.maskBits = BIT_PULLER;
     
     body.createFixture(fd_sensor);
     //body.setUserData(this);
     */
  }

  void update() {

    //keepBorder();
    //pos.add(velocity);
    Vec2 body_pos = box2d.getBodyPixelCoord(body);
    PVector _pos = new PVector(body_pos.x, body_pos.y, 0);
    sensor.update(_pos);
  }


  void draw() {

    fill(c);

    // We look at each body and get its screen position
    Vec2 _pos = box2d.getBodyPixelCoord(body);

    // Get its angle of rotation
    float a = body.getAngle();

    pushMatrix();
    translate(_pos.x, _pos.y);
    rotate(-a);
    ellipse(0, 0, r, r);
    popMatrix();

    //sensor.draw();
  }

  void applyForce(Vec2 v, Vec2 posA, Vec2 posB) {
    Vec2 body_pos = box2d.getBodyPixelCoord(body);
    
    println("force: " + v);
    stroke(255, 0, 255);
    //strokeWeight(10);
    line(posA.x, posA.y, posB.x, posB.y);
    body.applyForce(v, body.getWorldCenter());
  }
}