class Circle {
    float posX, posY;
    float vx, vy;
    float radius;
    color fillCol = color(10, 180, 80);
    boolean isDead = false;
    

    Circle(float x, float y, float r) {
        posX = x;
        posY = y;
        radius = r;
        vx = 5;
        vy = 0;
    }

    void update() {
        posX = posX - vx;

        if (posX < -200) {
            isDead = true;
        }
    }

    PVector getPos() {
        return new PVector(posX, posY);
    }

    boolean isDead() {
        return isDead;
    }

    void draw() {
        fill(fillCol);
        // noFill();
        strokeWeight(0.5);
        ellipse(posX, posY, radius, radius);
    }
}