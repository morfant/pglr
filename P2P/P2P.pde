

ArrayList<Puller> pullers;
ArrayList<Pulle> pulles;


void setup() {
  size(900, 900);
  frameRate(30);
  smooth();

  pullers = new ArrayList<Puller>();
  pulles = new ArrayList<Pulle>();


  for (int i = 0; i < 50; i++) {
    pullers.add(new Puller());
  }
  
  for (int i = 0; i < 5; i++) {
    pulles.add(new Pulle());
  }
  
}


void draw() {
  background(0);

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