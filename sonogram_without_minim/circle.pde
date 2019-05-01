class Circle {

  int x, y;
  float r;
  int brightness = 255;

  Circle () {
    x = width/2;
    y = height/2;
    r = 10;
  }

  Circle (int _x, int _y, float _r) {
    x = _x;
    y = _y;
    r = _r;
  }


  boolean isDie() {
    if (x < 0) {
      return true;
    } else {
      return false;
    }
  }

  void move() {
    x = x - 1;
    y = y;
  }

  void draw() {
    fill(255, brightness);
    ellipse(x, y, r, r);
  }
}
