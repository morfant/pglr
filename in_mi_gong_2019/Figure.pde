import java.io.Serializable;

class Figure implements Serializable {
    float posX, posY;
    float velX, velY;
    float radius;

    int type = 0; // 0: circle, 1: rect, 2: triangle, 3: diamond, 4: ...

    // color fillCol = color(10, 180, 80);
    int red = 10;
    int green = 180;
    int blue = 80;
    int alpha = 255;
    
    int red_strk = 10;
    int green_strk = 180;
    int blue_strk = 80;
    int alpha_strk = 255;

    float anglePos = 0;
    float angleVel = 0;
    float beginAngleOffset = 5;

    boolean goAround = true;
 
    boolean isDead = false;
    boolean isFill = true;
    boolean isStroke = true;
    boolean aging = true;

    int age = 0;
    final int AGE_LIMIT = 1;

    float deadLineX = 0;

    float strokeWeight = 5;
    float distFromCenter = 0;

    Figure(int _type, float x, float y, float r, boolean _isFill, boolean _isStroke, float _deadlineX) {
        posX = x;
        posY = y;
        radius = r;
        velX = 5;
        velY = 0;

        isFill = _isFill;
        isStroke = _isStroke;
        deadLineX = _deadlineX;

        anglePos = beginAngleOffset;

        aging = true;
        age = 0;

        type = _type;
    }

    PVector getPos() {
        return new PVector(posX, posY);
    }

    void setPos(float x, float y) {
        posX = x;
        posY = y;
    }

    void setAging(boolean b) {
        aging = b;
    }

    void setVelocity(float x, float y) {
        velX = x;
        velY = y;
    }

    void setRadius(float r) {
        radius = r;
    }

    void setDistFromCenter(float d) {
        distFromCenter = d;
    }

    void setVangle(float a) {
        angleVel = a;

        if (angleVel < 0) {
            beginAngleOffset *= -1;
            anglePos = beginAngleOffset;
        }
    }

    void setGoAround(boolean b) {
        goAround = b;
    }

    void setFillColor(int r, int g, int b, int a) {
        red = r;
        green = g;
        blue = b;
        alpha = a;
    }

    void setStrokeColor(int r, int g, int b, int a) {
        red_strk = r;
        green_strk = g;
        blue_strk = b;
        alpha_strk = a;
    }

    void setDeadLine(float _deadLineX) {
        deadLineX = _deadLineX;
    }

    void setStrokeWeight(float _strokeWeight) {
        strokeWeight = _strokeWeight;
    }

    void update() {

      
        if (aging) {
            if (age > AGE_LIMIT) {
                isDead = true;
            } else {
                // println("age: " + age);
                age++;
            }
        }

        if (goAround == true) {
            anglePos += angleVel;
            if (abs(anglePos) > 350) {
                isDead = true;
            }
            posX = 0;
            posY = -distFromCenter;

        } else {
            posX = posX - velX;

            if (posX < deadLineX) {
                isDead = true;
            }
        }

    }

    void draw() {
        fill(red, green, blue, alpha);
        stroke(red_strk, green_strk, blue_strk, alpha_strk);
        strokeWeight(strokeWeight);
        // strokeWeight(2);

        if (isFill == false) {
            noFill();
        }

        if (isStroke == false) {
            noStroke();
        }

        pushMatrix();
        translate(width/2, height/2);

        figures(type);
        // figures(9);

        popMatrix();

    }

    void figures(int _type) {

        if (goAround) {
            rotate(radians(anglePos));
        } 


        switch (_type) {
            case 0:
                ellipse(0, 0, radius, radius);
            break;

            case 1:
                rect(0, 0, radius, radius);
            break;
            
            case 2:
                drawTriangle(0, 0, radius);
                // polygon(0, 0, radius, 3);
            break;

            case 3:
                rotate(PI/4);
                rect(0, 0, radius, radius);
            break;

            case 4:
                polygon(0, 0, radius, 5);
            break;

            case 5:
                polygon(0, 0, radius, 6);
            break;

            case 6:
                polygon(0, 0, radius, 7);
            break;

            case 7:
                polygon(0, 0, radius, 8);
            break;

            case 8:
                polygon(0, 0, radius, 9);
            break;

            case 9:
                rotate(frameCount/100.0);
                snow((int)constrain(radius, 0, width/2), (int)constrain(radius, 0, height/2));
            break;


            default:
            break;	
        }        

    }

    boolean isDead() {
        return isDead;
    }

    void drawTriangle(float x, float y, float r) {

        triangle(x - r/2, y - r/2, x, y + r/2, x + r/2, y - r/2);

    }

    void polygon(float x, float y, float radius, int npoints) {
        float angle = TWO_PI / npoints;
        beginShape();
        for (float a = 0; a < TWO_PI; a += angle) {
            float sx = x + cos(a) * radius;
            float sy = y + sin(a) * radius;
            vertex(sx, sy);
        }
        endShape(CLOSE);
    }

    void snow(int w, int h) {

        int step = 40;

        pushMatrix();
        translate(-w/2, -h/2);

        for (float i = 0; i < w; i+=step) {
            for (float j = 0; j < h; j+=step) {
                float n = noise(frameCount/100.0);
                noStroke();
                // fill(n * 255);
                // noFill();
                // ellipse(i + random(step), j + random(step) , 2, n * step*2);
                float rr = random(h/2);
                ellipse(i + random(step), j + random(step) , rr * n, rr * n);
            }
        }

        popMatrix();

    }



}
