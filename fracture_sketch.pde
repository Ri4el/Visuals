import ddf.minim.*;
import ddf.minim.analysis.*;
Minim minim;
AudioPlayer player;
FFT fft;
BeatDetect beat;
AudioRecorder recorder;
boolean recording = false;
Fracture r;
void setup() {
  size(1200, 900, P3D);
  //frameRate(24);
  smooth(8);
  minim = new Minim(this);
  player = minim.loadFile("Kode9_Burial.mp3", 2048);
  player.play();
  fft = new FFT(player.bufferSize(), player.sampleRate());
  beat = new BeatDetect();
  recorder = minim.createRecorder(player, "AudioOut/rec.wav");
  r = new Fracture();
} 
void draw() {
  fft.forward(player.mix);
  beat.detect(player.mix);
  background(0);
  r.render();
  if(recording) {
    saveFrame("media/frame_####.png");
  }
}

void keyPressed()
{
  if ( key == 'f' )
  {
    player.skip(10000);
  }
  if (key == 'r') {
    if (recorder.isRecording()) {
      recording = false;
      //recorder.endRecord();
      //recorder.save();
    } else {
      //recorder.beginRecord();
      recording = true;
    }
  }
}
