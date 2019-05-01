class Rlin{


  PVector sp;
  PVector velo;
  PVector ep;
  float spx, spy, r, g, b, a;
  
  
  Rlin()
  {
    
  }


  Rlin(float _spx, float _spy, float _r, float _g, float _b, float _a)
  {
    spx = _spx;
    spy = _spy;
    r = _r;
    g = _g;
    b = _b;
    a = _a;
    
    sp = new PVector(spx, spy);
    ep = new PVector(0, 0);
  }



  void update()
  {
    velo = new PVector(random(-8, 8), random(-3, 3));
    velo.mult(5);
    ep = PVector.add(sp, velo);
  }
  
  
  void display()
  {
    stroke(r, g, b, a);
    line(sp.x, sp.y, ep.x, ep.y);
    sp = ep;
    
  }


}
