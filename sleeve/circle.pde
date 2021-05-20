class Circle {

  int x, y;
  float rx, ry;
  int brightness = 255;

  Circle () {
    x = width/2;
    y = height/2;
    rx = 10;
    ry = 2;
  }

  Circle (int _x, int _y, float _r) {
    x = _x;
    y = _y;
    rx = _r;
    ry = _r;
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
    ellipse(x, y, rx, ry);
  }
}
