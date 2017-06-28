Branch br;
ArrayList<Branch> branches;
ArrayList<Branch> currents;

float theta = 0;

void setup() {
  size(500, 500);
  smooth();

  translate(width/2, height);

  theta = 20;


  branches = new ArrayList<Branch>();
  currents = new ArrayList<Branch>();



  PVector s = new PVector(width/2, height);
  PVector e = new PVector(width/2, height - 100);
  br = new Branch(s, e);

  branches.add(br);
  currents = branches;
  
  for (int i = 0; i < 2; i++) {
    generate();
    //println(branches.size());
  }
  
}

void generate() {

  ArrayList nextList = new ArrayList<Branch>();

  for (Branch b : currents) {

    PVector ns = b.nextStart();
    PVector nel = b.nextEndL();
    PVector ner = b.nextEndR();

    //println(ns);
    //println(nel);
    //println(ner);

    nextList.add(new Branch(ns, nel));
    nextList.add(new Branch(ns, ner));
  }

  println(nextList.size());


  //if (nextList.size() > 0) {
  //  for (int i = 0; i < nextList.size(); i++) {
  //    branches.add((Branch)nextList.get(i));
  //  }
  //}

  currents = nextList;
  for (int i = 0; i < currents.size(); i++) {
    branches.add((Branch)currents.get(i));
  }
}

void draw() {


  background(255);

  theta = map(mouseX, 0, width, 0, PI);

  //branches.clear();

  //for (int i = 0; i < 5; i++) {
  //  generate();
  //  //println(branches.size());
  //}

  for (Branch b : branches) {
    b.draw();
  }

  //makeBranch(150);
}





void makeBranch(float len) {

  stroke(0);
  strokeWeight(len/10);
  line(0, 0, 0, -len);
  translate(0, -len);


  if (len > 2) {
    len *= 0.7;

    pushMatrix();
    rotate(theta);
    makeBranch(len);
    popMatrix();

    rotate(-theta);
    makeBranch(len);
  }
}