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
 
    boolean isDead = false;
    boolean isFill = true;
    boolean isStroke = true;
    boolean withRect = false;

    float deadLineX = 0;
    

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
    }

    void update() {
        posX = posX - vx;

        if (posX < deadLineX) {
            isDead = true;
        }
    }

    PVector getPos() {
        return new PVector(posX, posY);
    }

    boolean isDead() {
        return isDead;
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
 

    void draw() {
        fill(red, green, blue, alpha);
        stroke(red_strk, green_strk, blue_strk, alpha_strk);
        strokeWeight(0.5);

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
        ellipse(posX, posY, radius, radius);
    }
}