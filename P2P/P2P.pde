int nPuller = 50;
int nPulle = 5;

ArrayList<Puller> pullers;
ArrayList<Pulle> pulles;


void setup() {
  size(900, 900);
  frameRate(30);
  smooth();

  pullers = new ArrayList<Puller>();
  pulles = new ArrayList<Pulle>();


  for (int i = 0; i < nPuller; i++) {
    pullers.add(new Puller());
  }

  for (int i = 0; i < nPulle; i++) {
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

  for (int i = nPuller-1; i >= 1; i--) {
    Puller a = pullers.get(i);
    for (int j = i - 1; j >= 0; j--) {
      Puller b = pullers.get(j);
      a.checkCollision(b);
      //println(b.overlapTime);
    }
  }


// Manage Pulles
for (Pulle p : pulles) {
  p.update();
  p.draw();
}

}