/*
Author: Paolo Montesel
Date: 2018/07/18
Description: Some circlular things that are very simply tied to music through amplitude.
*/

import java.io.*;


final float fakeFrameRate = 30.0f;
final float RADIUS_SPACING = 70.0f;

class Circle {
    final float ARC_SPACING = 2 * PI / 260 * 10;
    final float FRAMERATE_DIVIDER = 2 * PI;
    final float MAX_WEIGHT = RADIUS_SPACING / 5;

    float x, y;
    float radius;
    float weight;
    int divisor;
    float r;
    float g;
    float b;
    float speed;
    float acceleration;
    float t;

    public Circle(int ith) {
        t = random(2*PI);

        x = width / 2;
        y = height / 2;
        radius = (ith + 1) * RADIUS_SPACING - RADIUS_SPACING / 2;
        // radius = (ith + 1) * RADIUS_SPACING;
        weight = random(MAX_WEIGHT);

        divisor = int(random(9)) + 1;

        r = random(255);
        g = random(255);
        b = random(255);
        speed = random(40) - 40;
        acceleration = random(20);
    }

    void draw(float delta, float expansion) {
        delta = delta / FRAMERATE_DIVIDER / radius;
        float fuzz = noise(t);
        acceleration += (fuzz - 0.5) * 5;
        speed += delta * acceleration;
        // TODO: Fix this overflow that keeps switching
        if ((speed * delta > PI / 1.5 / radius * fakeFrameRate && acceleration > 0)
            ||
            (speed * delta < - PI / 1.5 / radius * fakeFrameRate && acceleration < 0)) {
            acceleration = -acceleration;
            acceleration /= 1.5;
        }
        t += speed * delta;
        t %= 2 * PI;
        // t += delta;
        // while (t > 2 * PI) {
        //     t -= 2 * PI;
        // }
        // while (t < 0) {
        //     t += 2 * PI;
        // }

        weight = weight * 0.9 + (weight + (random(fuzz) - fuzz / 2) * 10) * 0.1;
        weight = constrain(weight, 1, MAX_WEIGHT);

        fuzz *= 10;
        r += random(fuzz) - fuzz / 2;
        g += random(fuzz) - fuzz / 2;
        b += random(fuzz) - fuzz / 2;
        r = constrain(r, 0, 255);
        g = constrain(g, 0, 255);
        b = constrain(b, 0, 255);

        float ith = radius / RADIUS_SPACING;
        expansion = exp(expansion * ith - ith);

        pushStyle();
        noFill();
        stroke(r, g, b, 220);
        strokeCap(SQUARE);
        strokeWeight(weight * expansion);

        float length = (2 * PI - ARC_SPACING * divisor) / divisor;
        for (int i=0; i<divisor; i++) {
            float start = t + i * (length + ARC_SPACING);
            float end = start + length;
            arc(x, y, radius * expansion, radius * expansion, start, end);
        }

        popStyle();
    }
}

Circle[] circles = new Circle[200];
float expansionMin;
float expansionMax;

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
void setup() {
    initAmps();
    // while (amps[ampIndex] <= 0.00001f) {
    //     ampIndex++;
    // }
    // size(1024, 1024, P3D);
    size(1920, 1080);
    smooth(8);
    background(0);
    // colorMode(HSB);

    for (int i=0; i<circles.length; i++) {
        circles[i] = this.new Circle(i);
    }

    expansionMin = lamberto(0.1);
    expansionMax = lamberto(1.0);
}

float lamberto(float target) {
    int n = circles.length + 1;
    float m = height;
    float x = 2.0f;

    while (m > height / 1.1 * target) {
        x -= 0.001;
        m = 0.0f;
        for (int i=1; i<n; i++) {
            float radius = i * RADIUS_SPACING;
            float mi = radius * exp(x * radius / RADIUS_SPACING - radius / RADIUS_SPACING);
            // float r = i * RADIUS_SPACING;
            // float mi = r * exp(x * r / RADIUS_SPACING - r / RADIUS_SPACING);
            m = max(m, mi);
        }
    }

    return x;
}

float tt = 0;
float signal = 0.5;
void draw() {
    if (ampIndex >= amps.length) {
        println("FINISHED :D");
        exit();
    }

    float newSignal = amps[ampIndex++];
    newSignal = pow((log(1 + newSignal) / log(2)), 0.1);
    newSignal /= 0.85;
    // newSignal = (sin(newSignal * PI - PI / 2.0) + 1.0) / 2.0;
    float a = 0.3;
    signal = newSignal * a + (1.0 - a) * signal;

    float delta = fakeFrameRate / 60.0;
    tt += delta;
    int n = circles.length + 1;

    float x = signal * (expansionMax - expansionMin) + expansionMin;

    background(0);
    for (int i=0; i<circles.length; i++) {
        // circles[i].draw(delta, (sin(tt * 2 * PI / 30)+1.0)/2 * (expansionMax - expansionMin) + expansionMin);
        // circles[i].draw(fakeFrameRate, expansionMin);
        circles[i].draw(fakeFrameRate, x);
    }

    saveFrame("video/snap-########.jpg");
}
