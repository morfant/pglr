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
        beginShape();
        int len = buffer.size();
        // println("len: " + len);
        // float d = 360 / len;
        if (len == bufNumLondon) {

            fill(10, 80, 200);
            strokeWeight(0.4);
            stroke(0, 150);

            for (int i = 0; i < len; i++) {
                float x = r * cos(radians(i * 1));
                float y = r * sin(radians(i * 1));
                if (ampDirectionFlag == DIRECTION.UP) {
                    vertex(x, y - buffer.get(len - 1 - i) * 5000);
                } else if (ampDirectionFlag == DIRECTION.DOWN) {
                    vertex(x, y + buffer.get(len - 1 - i) * 5000);
                }
                // println("len - 1:" + (len - 1));

            }
        }
        endShape();

        stroke(0);
        noFill();
        // fill(10, 80, 200);
        ellipse(0, 0, r*2, r*2);

        pop();
    }

}
