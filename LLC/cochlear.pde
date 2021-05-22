class Cochlear {

    float posX, posY;
    float destX = 0, destY = 0;
    float a = 1; // whole radius
    float b = 0.1; // 0 ~ 1.0
    float posXoffset = 0;
    float offsetStep = 0.1;
    float lineWidth = 1;
    float lengthMul = 6;
    float angle = 0;
    float time = 0;
    float startTime = 0;
    int col_r = 0;
    int col_g = 0;
    int col_b = 0;
    color col = color(col_r, col_g, col_b);
    boolean isSpin = false;
    boolean isSwing = false;
    int spinAngle = 0;
    float spinOffset = 0;
    float swingDiv = 0;
    float swingRange = 0;

    Cochlear(float _x, float _y) {
        posX = _x;
        posY = _y;
    }

    Cochlear(float _x, float _y, float _a) {
        posX = _x;
        posY = _y;
        angle = _a;
    }

    void setColor(color _c) {
        col = _c;
    }

    void setPos(float _x, float _y) {
        posX = _x;
        posY = _y;
    }

    void setCoefs(float _a, float _b) {
        a = _a;
        b = _b;
    }

    void setOffsetStep(float of) {
        offsetStep = of;
    }

    void setAngle(float a) {
        angle = a;
    }

    void setSwing(boolean b, float sw_d, float sw_r) {
        isSwing = b;
        swingDiv = sw_d;
        swingRange = sw_r;
    }

    void setStartTime(float t) {
        startTime = t;
    }

    void setSpin(boolean b, float _spinOffset) {
        isSpin = b;
        spinOffset = _spinOffset;
    }

    void update() {

        if (startTime != 0 && time > startTime) {
            if (time % 100 == 0) {
                destX = random(width);
                destY = random(height);
            }
            posX = lerp(posX, destX, (time%100)/1000);
            posY = lerp(posY, destY, (time%100)/1000);

            angle+=random(-100, 100)/10;
        }

        time+=1;
        if (isSpin) {
            spinAngle += 5;
        } else {
            spinAngle = 0;
        }

        if (isSwing) {
            angle = angle + sin(time/swingDiv) * swingRange;
        }
    }


    void draw() {
        posXoffset = 0;
        rectMode(CENTER);
        pushMatrix();
        translate(posX, posY);
        
        rotate(radians(angle%360));
        // rotateY(radians(spinAngle%360));
        
        beginShape();
        strokeWeight(2);
        noFill();
        for (int i = 0; i < 360 * lengthMul; i++) {
           float theta = radians(i + spinAngle + spinOffset);
           float r = a + b * theta;
           float x = r * cos(theta) + posXoffset;
           float y = r * sin(theta);
           stroke(col);
           vertex(x, y);
        //    ellipse(x, y, lineWidth, lineWidth);
           posXoffset+=offsetStep;
        }
        endShape();
        popMatrix();
    }

}
