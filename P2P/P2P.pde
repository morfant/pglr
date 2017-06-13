int nPuller = 200;
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
  
  for (int i = nPuller-1; i > 0; i--){
    Puller a = pullers.get(i);
    for (int j = i - 1; j > 0; j--){
      Puller b = pullers.get(j);
      if (a.isCollide(b)){
        //println("puller " + i + " with " + j + " is collide!");
        stroke(255);
        strokeWeight(0.4);
        line(a.pos.x, a.pos.y, b.pos.x, b.pos.y);
      }
      
    }
  }

  // Manage Pulles
  for (Pulle p : pulles) {
    p.update();
    p.draw();
  }
  
}