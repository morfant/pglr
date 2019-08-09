import java.io.Serializable;

class Circle implements Serializable {
    float posX, posY;
    float vx, vy;
    float radius;
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
    float vangle = 0;
    float beginAngleOffset = 5;

    boolean goAround = true;
 
    boolean isDead = false;
    boolean isFill = true;
    boolean isStroke = true;
    boolean withRect = false;
    boolean aging = false;
    int age = 0;
    final int AGE_LIMIT = 30;

    float deadLineX = 0;

    float strokeWeight = 2;
    float distFromCenter = 0;

    Circle(float x, float y, float r, boolean _isFill, boolean _isStroke, float _deadlineX, boolean _withRect) {
        posX = x;
        posY = y;
        radius = r;
        vx = 5;
        vy = 0;

        isFill = _isFill;
        isStroke = _isStroke;
        deadLineX = _deadlineX;
        withRect = _withRect;

        anglePos = beginAngleOffset;

        aging = false;
        age = 0;
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
        vx = x;
        vy = y;
    }

    void setRadius(float r) {
        radius = r;
    }

    void setDistFromCenter(float d) {
        distFromCenter = d;
    }

    void setVangle(float a) {
        vangle = a;

        if (vangle < 0) {
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
            anglePos += vangle;
            if (abs(anglePos) > 350) {
                isDead = true;
            }
            posX = 0;
            posY = -distFromCenter;

        } else {
            posX = posX - vx;

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

        if (withRect) {
            rectMode(CENTER);
            fill(0);
            rect(posX, posY, radius, radius);
        }

        if (withRect) {
            fill(255);
        }

        if (goAround) {
            pushMatrix();
            translate(width/2, height/2);
            rotate(radians(anglePos));

            ellipse(posX, posY, radius, radius);
            popMatrix();
        } else {
            ellipse(posX, posY, radius, radius);
        }

    }

    boolean isDead() {
        return isDead;
    }


}
