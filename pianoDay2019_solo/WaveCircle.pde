class WaveCircle {
    float x, y, r;
    boolean isFill = true;
    color fillCol = color(10, 80, 200);
    color strkCol = color(0);
    float strkWeight = 0.4;
    float vel = 1.0;
    float[] fftBuffer = new float[16];

    DIRECTION ampDirectionFlag = DIRECTION.UP;
    DIRECTION ampRotationFlag = DIRECTION.CW;

    int bufNum = 0;
    
    FloatList buffer;
 
    WaveCircle(float _x, float _y, float _r, int _bufNum) {
        x = _x;
        y = _y;
        r = _r;
        bufNum = _bufNum;
        ampDirectionFlag = DIRECTION.UP;
    } 

    void setColor(color _fillCol, color _strkCol, float _strkWeight) {
        fillCol = _fillCol;
        strkCol = _strkCol;
        strkWeight = _strkWeight;
    }

    void setFill(boolean _b) {
        isFill = _b;
    }

    void setVel(float _v) {
        vel = _v;
    }

    void update(FloatList bufferArray) {
        buffer = bufferArray;
    }

    void updateFFT(float[] _fftBuf) {
        fftBuffer = _fftBuf;
    }

    void updateLen(int _bufNum) {
        bufNum = _bufNum;
    }

    void direction(DIRECTION _ampDirectionFlag) {
        ampDirectionFlag = _ampDirectionFlag;
    }

    void rotation(DIRECTION _ampRotationFlag) {
        ampRotationFlag = _ampRotationFlag;
    }


    void drawFFT() {

        push();
        translate(x, y);
        rotate(radians(frameCount%360));
 
        beginShape();
        // beginShape(TRIANGLE_STRIP);

        stroke(strkCol);
        strokeWeight(strkWeight);

        fill(fillCol);
        if (isFill == false) {
            // noFill();
            // beginShape(TRIANGLE_STRIP);
        }

        int len = fftBuffer.length;
        // println("len: " + len);
        // float d = 360 / len;
        int one_cycle = 360;

        // for (int i = 0; i < len; i++) {
        for (int i = 0; i < len; i++) {
            float x = r * cos(radians(i * one_cycle / len));
            float y = r * sin(radians(i * one_cycle / len));
            float v = 0;
            if (ampRotationFlag == DIRECTION.CW) {
                v = fftBuffer[len - 1 - i];
            } else if (ampRotationFlag == DIRECTION.CCW) {
                v = fftBuffer[i];
            }
            if (ampDirectionFlag == DIRECTION.UP) {
                vertex(x, y - v * 5000);
                // bezierVertex(x, y, x * 2, y * 2, 0, 0);
                // curveVertex(x, y - buffer.get(len - 1 - i) * 5000);
            } else if (ampDirectionFlag == DIRECTION.DOWN) {
                vertex(x, y + v * 5000);
                // bezierVertex(80, 0, 80, 75, 30, 75);
                // curveVertex(x, y + buffer.get(len - 1 - i) * 5000);
            }
            // println("len - 1:" + (len - 1));

        }
        endShape(CLOSE);

        // base circle
        strokeWeight(0.4);
        noFill();
        ellipse(0, 0, r*2, r*2);

        pop();
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
        // beginShape(TRIANGLE_STRIP);

        stroke(strkCol);
        strokeWeight(strkWeight);

        fill(fillCol);
        if (isFill == false) {
            // noFill();
            // beginShape(TRIANGLE_STRIP);
        }

        int len = buffer.size();
        // println("len: " + len);
        // float d = 360 / len;
        int one_cycle = 360;
        if (len >= bufNum) {
            // for (int i = 0; i < len; i++) {
            for (int i = 0; i < len; i++) {
                float x = r * cos(radians(i * one_cycle / len));
                float y = r * sin(radians(i * one_cycle / len));
                float v = 0;
                if (ampRotationFlag == DIRECTION.CW) {
                    v = buffer.get(len - 1 - i);
                } else if (ampRotationFlag == DIRECTION.CCW) {
                    v = buffer.get(i);
                }
                if (ampDirectionFlag == DIRECTION.UP) {
                    // if (v > 0.01) {
                    //     fill(200, 10, 80, 120);
                    // } else {
                    //     fill(10, 80, 200);
                    // }
                    vertex(x, y - v * 10000);
                    // bezierVertex(x, y, x * 2, y * 2, 0, 0);
                    // curveVertex(x, y - buffer.get(len - 1 - i) * 5000);
                } else if (ampDirectionFlag == DIRECTION.DOWN) {
                    vertex(x, y + v * 10000);
                    // bezierVertex(80, 0, 80, 75, 30, 75);
                    // curveVertex(x, y + buffer.get(len - 1 - i) * 5000);
                }
                // println("len - 1:" + (len - 1));

            }
        }
        endShape(CLOSE);

        // base circle
        strokeWeight(0.4);
        noFill();
        ellipse(0, 0, r*2, r*2);

        pop();
    }

}
