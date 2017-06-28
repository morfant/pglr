class Branch {

  PVector start, end;

  float len = 0;
  //float theta = radians(60);

  Branch(PVector s, PVector e) {
    start = s;
    end = e;
    len = dist(end.x, end.y, start.x, start.y);
    //println(len);
  }

  PVector nextStart() {

    PVector nextStart, nextEnd;
    nextStart = end;
    return nextStart;
  }

  PVector nextEndL() {
    len *= 0.5;
    PVector nextStart, nextEnd;
    nextStart = end;
    //PVector lv = new PVector(len*cos(theta), len*sin(theta));
    PVector lv = new PVector(0, -len);
    lv.rotate(radians(theta));

    nextEnd = PVector.add(nextStart, lv);
    //nextEnd.rotate(radians(theta));

    return nextEnd;
  }

  PVector nextEndR() {
    PVector nextStart, nextEnd;
    nextStart = end;
    //PVector lv = new PVector(-len*cos(theta), len*sin(theta));

    PVector lv = new PVector(0, -len);
    lv.rotate(-radians(theta));
    nextEnd = PVector.add(nextStart, lv);
    //nextEnd.rotate(-radians(theta));

    return nextEnd;
  }


  void draw() {
    stroke(0);
    line(start.x, start.y, end.x, end.y);
  }
}