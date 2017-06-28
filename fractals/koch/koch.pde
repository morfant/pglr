ArrayList<KochLine> lines;

ArrayList<PVector> baseLines;

float w = 0;
float ww = 20;
float h = 0;
float hh = 50;

void setup() {

  size(600, 600);

  baseLines = new ArrayList<PVector> ();
  lines = new ArrayList<KochLine> ();

  float lineLength = 800;

  baseLines.add(new PVector(width/6, lineLength/3*cos(radians(30))));
  baseLines.add(new PVector(width/6 + lineLength, lineLength/3*cos(radians(30))));
  baseLines.add(new PVector(width/6 + lineLength, lineLength/3*cos(radians(30))));
  baseLines.add(new PVector(width/6 + lineLength/2, lineLength/3*cos(radians(30)) + lineLength*cos(radians(30))));
  baseLines.add(new PVector(width/6 + lineLength/2, lineLength/3*cos(radians(30)) + lineLength*cos(radians(30))));
  baseLines.add(new PVector(width/6, lineLength/3*cos(radians(30))));





  for (int i = 0; i < baseLines.size(); i+=2) {
    lines.add(new KochLine(baseLines.get(i), baseLines.get(i + 1)));
  }

  //KochLine line_0 = new KochLine(baseLines[0], baseLines[1]);
  //KochLine line_1 = new KochLine(start, end);
  //KochLine line_2 = new KochLine(start, end);
  //lines.add(line);

  for (int i = 0; i < 3; i++) {
    generate();
  }
}


void draw() {
  background(255);
  //regenerate();
  
  for (KochLine l : lines) {
    l.draw();
  }
}

void regenerate() {

  
  baseLines.add(baseLines.get(baseLines.size()-1));
  //PVector re = new PVector(noise(w)*width, noise(h)*height);
  PVector re = new PVector(random(width/3), random(height/8));  
  //baseLines.add(rs);
  baseLines.add(re);

  w += 0.1;
  h += 0.1;
  ww += 0.1;
  //ww += random(0, 4);
  hh += 0.1;
  //hh += random(0, 8);

  //println(rs);
  //println(re);


  lines.clear();

  //println(baseLines.size());

  for (int i = 0; i < baseLines.size(); i+=2) {
    lines.add(new KochLine(baseLines.get(i), baseLines.get(i + 1)));
  }

  //println(lines.size());

  for (int i = 0; i < 3; i++) {
    generate();
  }
}

void generate() {

  ArrayList next = new ArrayList<KochLine> ();

  for (KochLine l : lines) {

    PVector a = l.kochA();
    PVector b = l.kochB();
    PVector c = l.kochC();
    PVector d = l.kochD();
    PVector e = l.kochE();

    next.add(new KochLine(a, b));
    next.add(new KochLine(b, c));
    next.add(new KochLine(c, d));
    next.add(new KochLine(d, e));
  }

  lines = next;
}


void mousePressed() {
  //println("re");
  PVector rs = new PVector(noise(w)*width, noise(h)*height);
  PVector re = new PVector(noise(ww)*width, noise(hh)*height);
  baseLines.add(rs);
  baseLines.add(re);

  w += 0.1;
  h += 0.1;
  ww += 0.1;
  //ww += random(0, 4);
  hh += 0.1;
  //hh += random(0, 8);

  //println(rs);
  //println(re);
  regenerate();
}