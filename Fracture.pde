/*
This class depends on the following objects that have to be included in the processing sketch.
Minim minim;
AudioPlayer player;
FFT fft;
BeatDetect beat;
AudioRecorder recorder;
*/
class Fracture
{
  float threshold, dx, dy;
  int step;
  Fracture() {
    //not sure how to obtain this number precisely.
    //hardcoded having seen this performs well with different audio tracks
    //this is probably one of those parameters you want to control live.
    threshold = 0.23; 
    //////////////////
    dx = ((float)width/player.bufferSize());
    dy = ((float)height/player.bufferSize());
    
    beat.setSensitivity(10);
  }
  public void render() {
    //Translate origin to the center
    translate(width/2, height/2);
    //z value depends on RMS of the mix of the left and right channels.
    translate(-width/2, -height/2, -(player.mix.level())*1000); 
    
    //set the step length depending on the RMS.
    step = (int)map(player.mix.level(), 0, 0.3, 25, 45);
    
    if(beat.isOnset() || player.mix.level() > threshold) {
      lines_wave();
    }
    else {
      mesh();
      lines_fracture();
    }
  } 
  private void mesh() {
    beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < player.bufferSize() - step; i = i + step) {
        for (int j = 0; j < player.bufferSize() - step; j = j + step) {
            strokeWeight(player.mix.level());
            noFill();
            vertex(j*dx + player.right.get(j)*200, i*dy + player.left.get(j)*200);
        }
      }
      endShape();
  }
  private void lines_fracture() {
    for (int i = 0; i < player.bufferSize() - step; i = i + step) {
        for (int j = 0; j < player.bufferSize() - step; j = j + step) {
          strokeWeight(0.7);
          stroke(fft.getBand(i)*10000, player.left.level()*2550, player.right.level()*2550, player.mix.level()*2550);
          line(j*dx + player.right.get(j)*200, i*dy + player.left.get(j)*200, (j+step)*dx + player.right.get(j+step)*200, (j+step)*dy + player.left.get(j+step)*200);
       }
    }
  }
  private void lines_wave() {
    for (int i = 0; i < player.bufferSize() - step; i = i + step) {
        for (int j = 0; j < player.bufferSize() - step; j = j + step) {
          strokeWeight(0.7);
          stroke(fft.getBand(i)*10000, player.left.level()*2550, player.right.level()*2550, player.mix.level()*2550);
          line(j*dx + player.right.get(j)*200, i*dy + player.left.get(i)*200, (j+step)*dx + player.right.get(j+step)*200, (i+step)*dy + player.left.get(i+step)*200);
       }
    }
  }
  private void lines_wave_side() {
    for (int i = 0; i < player.bufferSize() - step; i = i + step) {
        for (int j = 0; j < player.bufferSize() - step; j = j + step) {
          strokeWeight(0.7);
          stroke(fft.getBand(i)*10000, player.left.level()*2550, player.right.level()*2550, player.mix.level()*2550);
          line(j*dx + player.right.get(j)*200, i*dy + player.left.get(j)*200, (j+step)*dx + player.right.get(j+step)*200, (i+step)*dy + player.left.get(j+step)*200);
       }
    }
  }
}
