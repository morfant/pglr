class Rlin{


  PVector sp;
  PVector velo;
  PVector ep;
  float spx, spy, r, g, b, a;
  float lime = 10;
  float lims = 10;
  
  
  Rlin()
  {
    
  }


  Rlin(PVector _sp, PVector _ep, float _r, float _g, float _b, float _a)
  {
    
    
    sp = new PVector();
    ep = new PVector();
    
    sp = _sp;
    ep = _ep;
    r = _r;
    g = _g;
    b = _b;
    a = _a;
        
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
//    velo = new PVector(random(-1, 1), random(-1, 1), random(-1, 1)); //ORIGINAL
    velo = new PVector(random(-2, 2), random(-2, 2), random(-2, 2));
    ep.add(velo);
//    ep.limit(lime);
    sp.add(velo);
//    sp.limit(lims);
    
  }
  
  
  void display()
  {
    stroke(r, g, b, a);
//    make();
    line(sp.x, sp.y, sp.z, ep.x, ep.y, ep.z);
    
    
  }

void make() {
  
  OscMessage myMessage1 = new OscMessage("/pp");    
  OscMessage myMessage2 = new OscMessage("/dd");    

  float freq = round(sp.x);
  float delta = abs(ep.x - sp.x)/100;

  PVector mes = new PVector(freq, delta);
  myMessage1.add(freq);
  myMessage2.add(delta);  
println(freq);
println(delta);
//  myMessage1.add(velsum/(topspeed/2));
//  myMessage1.add((location.x/(width/2))-1);
  
  osc.send(myMessage1, myRemoteLocation); 
//  osc.send(myMessage2, myRemoteLocation);   
  
}
}
