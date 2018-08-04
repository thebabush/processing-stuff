final float ALPHA = 10.0;
final float RAND_DELTA = 0.08;

float r0 = random(10.0);
float r1 = random(10.0);
float r2 = random(10.0);
float r3 = random(10.0);

void setup() {
    size(800, 600);
    background(255);
}

void draw() {
    r0 += RAND_DELTA;
    float y0 = noise(r0);
    r1 += RAND_DELTA;
    float y1 = noise(r1);
    y0 = constrain(y0, 0.0, 1.0);
    y1 = constrain(y1, 0.0, 1.0);

    r2 += RAND_DELTA;
    float y2 = noise(r2);
    r3 += RAND_DELTA;
    float y3 = noise(r3);
    y2 = constrain(y2, 0.0, 1.0);
    y3 = constrain(y3, 0.0, 1.0);

    line(0, y0 * height, width, y1 * height);
    line(y2 * width, 0, y3 * width, height);

    pushStyle();
    fill(255, ALPHA);
    rect(0, 0, width, height);
    popStyle();
}
