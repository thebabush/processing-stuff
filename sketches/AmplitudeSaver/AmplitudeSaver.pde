import java.io.*;
import processing.sound.*;


// Input file
final String inputFile = "../AABCirclesRender/Aphex Twin - Flim.mp3";
// Output file
final String outputFile = "../AABCirclesRender/amplitude.bin";


Amplitude amp;
SoundFile sound;

void setup() {
    sound = new SoundFile(this, sketchPath(inputFile));
    sound.play();
    amp = new Amplitude(this);
    amp.input(sound);
    frameRate(60);
}

ArrayList<Float> vals = new ArrayList<Float>(10000);
void draw() {
    vals.add(amp.analyze());
}

void save() {
    float[] raw = new float[vals.size()];
    for (int i=0; i<vals.size(); i++) {
        raw[i] = vals.get(i);
    }
    try {
        FileOutputStream file = new FileOutputStream(sketchPath(outputFile));
        ObjectOutputStream out = new ObjectOutputStream(file);
        out.writeObject(raw);
        out.close();
        file.close();
        println("File saved.");
    } catch (Exception e) {
        println(e);
    }
}

void keyPressed() {
    if (key == 'q') {
        save();
        exit();
    }
}
