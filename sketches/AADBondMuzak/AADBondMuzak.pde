import processing.sound.*;

class Line {
    float rand;
    float radius;
    float angle;
    float direction;

    public Line(float radius) {
        rand = random(10.0);
        this.radius = radius;
        angle = random(1.0);
        direction = 0;
    }

    public void draw(float step, float aperture) {
        rand += 0.1;
        angle += noise(rand);
        rand += 0.01;
        direction += noise(rand);

        float rad = radius * (1.0 + aperture);

        float x0 = width / 2 + rad * cos(angle * 2 * PI);
        float y0 = height / 2 + rad * sin(angle * 2 * PI);
        float x1 = width / 2 + width * cos((angle+direction) * 2 * PI);
        float y1 = height / 2 + height * sin((angle+direction) * 2 * PI);

        line(x0, y0, x1, y1);
    }
}

Amplitude amp;
SoundFile in;

final int LINES_PER_LEVEL = 100;
Line lines[] = new Line[LINES_PER_LEVEL * 2];
void setup() {
    size(1024, 1024);
    background(255);

    for (int i=0; i<lines.length; i++) {
        int level = i / LINES_PER_LEVEL + 1;
        lines[i] = new Line(width / 100 * level);
    }

    // in = new SoundFile(this, sketchPath("Aphex Twin - Flim.mp3"));
    in = new SoundFile(this, sketchPath("../AAACircles/Fixer.mp3"));
    in.loop();
    amp = new Amplitude(this);
    amp.input(in);
}

void draw() {
    pushStyle();
    noStroke();
    fill(255, 80);
    rect(0, 0, width, height);
    popStyle();

    // stroke(0, 0, 200);

    float ampVal = amp.analyze() / 0.01;

    for (int i=0; i<lines.length; i++) {
        lines[i].draw(1.0 / frameRate, ampVal);
    }
}
