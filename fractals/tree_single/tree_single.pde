
float theta = 0;
float nn = 0.0;

void setup() {
  size(500, 500);
  smooth();
  frameRate(1);

  //theta = radians(20);


  //theta = map(mouseX, 0, width, 0, PI);
}


void draw() {
  translate(width/2, height);
  background(255);
  makeBranch(150);
}





void makeBranch(float len) {


  stroke(0, 100);
  strokeWeight(len/6);
  line(0, 0, 0, -len);
  translate(0, -len);

  nn+=0.01;

  if (len > 3) {

    int n = int(random(2, 5));
    //len *= random(0.2, 0.8);
    len *= 0.66;    
    for (int i = 0; i < n; i++) {
      //theta = noise(nn);
      theta = random(-PI/2, PI/2);

      pushMatrix();
      rotate(theta);
      makeBranch(len);
      popMatrix();

      //rotate(-theta);
      //makeBranch(len);
    }
  }
}