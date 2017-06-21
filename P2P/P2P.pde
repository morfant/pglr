
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;

import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import controlP5.*;

ControlP5 cp5;

int nPuller = 300;
int nPullee = 20;

float forceStrength = 0.0;
float attraction_Puller = 1.0;
float attraction_Pullee = 3.0;


ArrayList<Boundary> boundaries;

ArrayList<Puller> pullers;
ArrayList<Pullee> pullees;

Box2DProcessing box2d;


void setup() {
  size(800, 800);
  frameRate(30);
  smooth();

  cp5 = new ControlP5(this);
  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  cp5.addSlider("f_mul")
    .setPosition(width - 250, 10)
    .setSize(200, 10)
    .setRange(-20.0, 20.0)
    .setValue(0.0)
    ;

  cp5.addSlider("attr_ee")
    .setPosition(width - 250, 20)
    .setSize(200, 10)
    .setRange(1.0, 5.0)
    .setValue(1.0)
    ;

  cp5.addSlider("attr_er")
    .setPosition(width - 250, 30)
    .setSize(200, 10)
    .setRange(1.0, 5.0)
    .setValue(1.0)
    ;


  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  box2d.listenForCollisions();

  box2d.setGravity(0, 0);

  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/2, 5, width, 10));
  boundaries.add(new Boundary(width/2, height-5, width, 10));
  boundaries.add(new Boundary(5, height/2, 10, height));
  boundaries.add(new Boundary(width - 5, height/2, 10, height));

  pullers = new ArrayList<Puller>();
  pullees = new ArrayList<Pullee>();

  // Puller
  for (int i = 0; i < nPuller; i++) {
    pullers.add(new Puller());
  }

  // Pullee
  for (int i = 0; i < nPullee; i++) {
    pullees.add(new Pullee());
  }
}


void draw() {
  background(0);

  // We must always step through time!
  box2d.step();


  // Display all the boundaries
  for (Boundary wall : boundaries) {
    wall.display();
  }

  // Manage Pullers
  for (Puller p : pullers) {
    p.update();
    p.draw();
  }

  // Manage Pulles
  for (Pullee p : pullees) {
    p.update();
    p.draw();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      println("left");
      Puller p1 = pullers.get(0);
      Puller p2 = pullers.get(1);

      Vec2 pos = p1.body.getWorldCenter();    
      Vec2 otherPos = p2.body.getWorldCenter();

      //Vec2 force = pos.sub(otherPos);
      Vec2 force = otherPos.sub(pos);      
      //float distance = force.length();

      //// Keep force within bounds
      //distance = constrain(distance, 1, 5);

      force.normalize();

      force.mulLocal(forceStrength);         // Get force vector --> magnitude * direction

      Vec2 p1_pos = box2d.getBodyPixelCoord(p1.body);
      Vec2 p2_pos = box2d.getBodyPixelCoord(p2.body);

      //p1.applyForce(force, p1_pos, p2_pos);
    }
  }
}


void removeNeighborList(Fixture f1, Fixture f2) {
  boolean sensorA = f1.isSensor();
  boolean sensorB = f2.isSensor();

  Body sensor;
  Body other;

  if ((sensorA ^ sensorB)) {

    if (sensorA) {
      sensor = f1.getBody();
      other = f2.getBody();

      //Object otherObj = other.getUserData();
      //if (otherObj.getClass() == Puller.class) {
      //  Puller p = (Puller) otherObj;
      //} else if (otherObj.getClass() == Pullee.class) {
      //  Pullee p = (Pullee) otherObj;
      //}
    } else {
      sensor = f2.getBody();
      other = f1.getBody();
    }  

    Object sensorObj = sensor.getFixtureList().getUserData();      
    Object otherObj = other.getUserData();

    //println(sensorObj);
    //println(otherObj);

    Sensor s = (Sensor) sensorObj;
    s.removeNeighbour(otherObj);
  }
}


void addNeighborList(Fixture f1, Fixture f2) {

  boolean sensorA = f1.isSensor();
  boolean sensorB = f2.isSensor();

  Body sensor;
  Body other;

  if ((sensorA ^ sensorB)) {    

    if (sensorA) {
      sensor = f1.getBody();
      other = f2.getBody();
    } else {
      sensor = f2.getBody();
      other = f1.getBody();
    }  


    //Vec2 worldPos_1 = sensor.getWorldCenter();
    //Vec2 worldPos_2 = other.getWorldCenter();
    //println(worldPos_1);
    //println(worldPos_2);  
    //float r1 = sensor.getFixtureList().getShape().m_radius;
    //float r2 = other.getFixtureList().getShape().m_radius;
    //float d = dist(worldPos_1.x, worldPos_1.y, worldPos_2.x, worldPos_2.y);
    //getContactBody(f1, f2);
    //if (d <= (r1 + r2) ) {
    //println(d);
    //println(r1 + " / " + r2);

    Object sensorObj = sensor.getFixtureList().getUserData();      
    Object otherObj = other.getUserData();

    //println(sensorObj);
    //println(otherObj);

    Sensor s = (Sensor) sensorObj;
    s.addNeighbour(otherObj);
    //}





    //if (o1.getClass() == Sensor.class && o2.getClass() == Puller.class) {
    //  Sensor s1 = (Sensor) o1;
    //  s1.change();
    //  //Puller p2 = (Puller) o2;
    //  //p2.change();
    //}
  }
}

void getContactBody(Fixture f1, Fixture f2) {

  boolean sensorA = f1.isSensor();
  boolean sensorB = f2.isSensor();

  Body sensor;
  Body other;

  if ((sensorA ^ sensorB)) {

    if (sensorA) {
      sensor = f1.getBody();
      other = f2.getBody();
    } else {
      sensor = f2.getBody();
      other = f1.getBody();
    }


    Vec2 pos = sensor.getWorldCenter();    
    Vec2 otherPos = other.getWorldCenter();

    Vec2 forceToSensor = otherPos.sub(pos);
    Vec2 forceToOther = pos.sub(otherPos);

    forceToSensor.normalize();
    forceToOther.normalize();

    forceToSensor.mulLocal(forceStrength * sensor.m_mass);
    forceToOther.mulLocal(forceStrength * other.m_mass);

    stroke(255, 0, 10);
    text(int(forceToSensor.x) + "/" + int(forceToSensor.y), box2d.getBodyPixelCoord(sensor).x, box2d.getBodyPixelCoord(sensor).y);
    stroke(0, 255, 100);
    text(int(forceToOther.x) + "/" + int(forceToOther.y), box2d.getBodyPixelCoord(other).x, box2d.getBodyPixelCoord(sensor).y);    

    //println(force);
    sensor.applyForce(forceToSensor, sensor.getWorldCenter());
    other.applyForce(forceToOther, other.getWorldCenter());
  }
}


boolean isSensorContact(Fixture f1, Fixture f2) {

  boolean sensorA = f1.isSensor();
  boolean sensorB = f2.isSensor();

  if (! (sensorA ^ sensorB) ) {
    return false;
  }

  return true;
}

// Collision event functions!
void beginContact(Contact cp) {

  //println("contact begin");

  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  addNeighborList(f1, f2);
}

// Objects stop touching each other
void endContact(Contact cp) {
  //println("contact end");
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  removeNeighborList(f1, f2);
}


// controlP5 event function
void f_mul(float strength) {
  forceStrength = strength;
  //println("a slider event. setting forceStrength to "+strength);
  //println(forceStrength);
}

void attr_er(float attr) {
  attraction_Puller = attr;
}

void attr_ee(float attr) {
  attraction_Pullee = attr;
}