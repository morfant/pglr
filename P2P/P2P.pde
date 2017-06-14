
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

int nPuller = 50;
int nPulle = 5;

ArrayList<Boundary> boundaries;

ArrayList<Puller> pullers;
ArrayList<Pulle> pulles;

Box2DProcessing box2d;


void setup() {
  size(900, 900);
  frameRate(30);
  smooth();


  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  boundaries = new ArrayList<Boundary>();

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/2, 5, width, 10));
  boundaries.add(new Boundary(width/2, height-5, width, 10));
  boundaries.add(new Boundary(5, height/2, 10, height));
  boundaries.add(new Boundary(width - 5, height/2, 10, height));

  pullers = new ArrayList<Puller>();
  pulles = new ArrayList<Pulle>();


  for (int i = 0; i < nPuller; i++) {
    pullers.add(new Puller());
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
  for (Pulle p : pulles) {
    p.update();
    p.draw();
  }
}