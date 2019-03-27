
class Writer {
    float posX, posY;
    int pageWidth, pageHeight;
    float barPosX, barPosY;
    float barPosXDiff = 0;
    float barVx, barVy;
    float barSpeed;
    float oneRowHeight;
    int numRow = 8;

    float radius = 10;
    color fillCol = color(10, 180, 80);
    // color strkCol = color(0);

    float amp = 0.0;
    int pitchIdx = 0;

    ArrayList<Circle> circles = new ArrayList<Circle>();

    Writer(float x, float y) {
        posX = x;
        posY = y;
        barVx = 1;
        barVy = 0;
        pageWidth = width/2;
        pageHeight = height;
        oneRowHeight = pageHeight/numRow;
        barPosX = posX - 0; // start from top right
        barPosY = oneRowHeight/2;
    }

    void update() {
        barPosX = barPosX - barVx;
        barPosXDiff += barVx;
        if (barPosXDiff >= pageWidth) {
            barPosY += oneRowHeight;
            barPosX = posX - 0;
            barPosXDiff = 0;
        }

        fill(255, 0, 0, 50);
        ellipse(barPosX, barPosY, 10, 10);
    }

    void data(float _amp, int _pitchIdx) {
        amp = _amp;
        pitchIdx = _pitchIdx;
        circles.add(new Circle(barPosX, barPosY -pitchIdx * 10, 500 * amp));
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
 
