
class Writer {
    float posX, posY;
    int pageWidth, pageHeight;
    float barPosX, barPosY;
    float barPosXDiff = 0;
    float barVx, barVy;
    float barSpeed;
    float oneRowHeight;
    int numRow = 20;

    float radius = 10;

    int red = 10;
    int green = 180;
    int blue = 80;
    int alpha = 255;

    int red_strk = 0;
    int green_strk = 0;
    int blue_strk = 0;
    int alpha_strk = 255;

    float amp = 0.0;
    int pitchIdx = 0;

    float ampMul = 10;

    ArrayList<Circle> circles = new ArrayList<Circle>();
    int circleLimitNum = 4000;

    Writer(float x, float y, float _ampMul) {
        posX = x;
        posY = y;
        barVx = 5;
        barVy = 0;
        pageWidth = width/2 - pad;
        pageHeight = height - pad * 2;
        oneRowHeight = pageHeight/numRow;
        barPosX = posX - 0; // start from top right
        barPosY = pad + oneRowHeight/2;
        ampMul = _ampMul;
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

    void update() {
        barPosX = barPosX - barVx;
        barPosXDiff += barVx;
        if (barPosXDiff >= pageWidth) {
            barPosY += oneRowHeight;
            barPosX = posX - 0;
            barPosXDiff = 0;
            if (barPosY > height) {
                barPosY = pad + oneRowHeight/2;
            }
        }

        // fill(255, 0, 0, 50);
        // ellipse(barPosX, barPosY, 10, 10);
    }

    void data(float _amp, int _pitchIdx) {
        amp = _amp;
        pitchIdx = _pitchIdx;
        Circle c = new Circle(barPosX, barPosY -pitchIdx, oneRowHeight*3/4 * amp * ampMul, true, false, -width, false);
        c.setFillColor(red, green, blue, alpha);
        c.setStrokeColor(red_strk, green_strk, blue_strk, alpha_strk);
        circles.add(c);

        if (circles.size() >= circleLimitNum) {
            circles.remove(0);
        }
    }


    void reset() {
        for (int i = circles.size() - 1; i >= 0; i--) {
            circles.remove(i);
        }

        barPosX = posX - 0; // start from top right
        barPosY = pad + oneRowHeight/2;

    }

    ArrayList<Circle> getData() {
        return circles;
    }

    void draw() {
        for (Circle c : circles) {
            // c.update();
            c.draw();
        } 
    }

}
 
