/*
Author: Paolo Montesel
Description: Lines, two circles, some music.
*/

import java.io.*;
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
        angle += noise(rand) * step;
        rand += 0.01;
        direction += noise(rand) * step;

        float rad = radius * (1.0 + aperture);

        float x0 = width / 2 + rad * cos(angle * 2 * PI);
        float y0 = height / 2 + rad * sin(angle * 2 * PI);
        float x1 = width / 2 + width * cos((angle+direction) * 2 * PI);
        float y1 = height / 2 + height * sin((angle+direction) * 2 * PI);

        line(x0, y0, x1, y1);
    }
}

final int LINES_PER_LEVEL = 100;
Line lines[] = new Line[LINES_PER_LEVEL * 2];
void setup() {
    // size(1024, 1024);
    size(1920, 1080);
    // size(3840, 2160);
    background(255);

    for (int i=0; i<lines.length; i++) {
        int level = i / LINES_PER_LEVEL + 1;
        lines[i] = new Line(width / 100 * level);
    }

    initAmps();
}

float[] amps;
void initAmps() {
    try {
        FileInputStream file = new FileInputStream(sketchPath("amplitude.bin"));
        ObjectInputStream in = new ObjectInputStream(file);
        amps = (float[]) in.readObject();
        in.close();
        file.close();
    } catch(Exception e) {
        println("ERROR: amplitude.bin not found");
        exit();
    }
}

int ampIndex = 0;
float meanAmp = 0.0f;
void draw() {
    if (ampIndex >= amps.length) {
        println("FINISHED :D");
        exit();
    }

    pushStyle();
    noStroke();
    fill(255, 80);
    rect(0, 0, width, height);
    popStyle();

    // stroke(0, 0, 200);

    float ampVal = amps[ampIndex++] / 0.01;
    ampIndex++;
    float alpha = 0.1;
    meanAmp = ampVal * (1-alpha) + alpha * meanAmp;

    for (int i=0; i<lines.length; i++) {
        lines[i].draw(30.0 / 60.0, meanAmp);
    }

    saveFrame("video/snap-########.jpg");
}
