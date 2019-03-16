class WaveCircle {
    float x, y, r;
    DIRECTION ampDirectionFlag = DIRECTION.UP;
    FloatList buffer;
 
    WaveCircle(float _x, float _y, float _r) {
        x = _x;
        y = _y;
        r = _r;
        ampDirectionFlag = DIRECTION.UP;
    } 

    void update(FloatList bufferArray) {
        buffer = bufferArray;
    }

    void direction(DIRECTION _ampDirectionFlag) {
        ampDirectionFlag = _ampDirectionFlag;
    }

    void draw() {

        // noFill()
        // float newValue = buffer.get(buffer.size() - 1);
        // fill(10, 80, 200);
        // strokeWeight(0.4);
        // stroke(0, 150);

        push();
        translate(x, y);
        // beginShape();
        beginShape(TRIANGLE_STRIP);
        int len = buffer.size();
        // println("len: " + len);
        // float d = 360 / len;
        if (len >= 360 ) {

            fill(10, 80, 200);
            strokeWeight(0.4);
            stroke(0, 150);

            for (int i = 0; i < 360; i++) {
                float x = r * cos(radians(i * 1));
                float y = r * sin(radians(i * 1));
                if (ampDirectionFlag == DIRECTION.UP) {
                    float v = buffer.get(len - 1 - i);
                    if (v > 0.01) {
                        fill(200, 10, 80, 120);
                    } else {
                        fill(10, 80, 200);
                    }
                    vertex(x, y - v * 5000);
                    // bezierVertex(x, y, x * 2, y * 2, 0, 0);
                    // curveVertex(x, y - buffer.get(len - 1 - i) * 5000);
                } else if (ampDirectionFlag == DIRECTION.DOWN) {
                    vertex(x, y + buffer.get(len - 1 - i) * 5000);
                    // bezierVertex(80, 0, 80, 75, 30, 75);
                    // curveVertex(x, y + buffer.get(len - 1 - i) * 5000);
                }
                // println("len - 1:" + (len - 1));

            }
        }
        endShape(CLOSE);

        stroke(0);
        noFill();
        // fill(10, 80, 200);
        ellipse(0, 0, r*2, r*2);

        pop();
    }

}
