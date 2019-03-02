import ddf.minim.analysis.*;
import ddf.minim.*;

class Spectrometer {
  FFT fft;
  AudioSource input;
  
  Float[][] Q;
  int tail;
  
  //----------------------------------------------------------
  // Constructors
  //----------------------------------------------------------
  
  //AudioPlayer constructor
  Spectrometer(String fileName, int buffSize, int qLength) {
    //load specified file
    AudioPlayer player = minim.loadFile(fileName, buffSize);
    //play and loop
    player.loop();
    //implicit cast of AudioPlayer to AudioSource
    input = player;   
    // init FFT and Queue
    init(qLength);
  }
  
  //AudioInput constructor
  Spectrometer(int lineIn, int buffSize, int qLength) {
    // implicit cast of AudioInput to AudioSource
    input = minim.getLineIn(lineIn, buffSize);   
    //init FFT and Queue
    init(qLength);
  }
  
  //----------------------------------------------------------
  // Public methods
  //----------------------------------------------------------
  
  public void update() {
    fft.forward(input.mix);
    Float[] buff = new Float[fft.specSize()];
    for(int i=0; i < buff.length; ++i) {
      buff[i] = fft.getBand(i);
    }
    insert(buff);
  }
  
  
  public void render3D() {
    float dx = ((float)width)/Q[0].length;
    float dy = ((float)height)/Q.length;
    pushMatrix();
    
    translate(0, 0, -height/5);  // Hardcoded
    rotateX(0.90 * TWO_PI);      // Hardcoded
    
    for(int i=0; i < Q.length; ++i) {
      beginShape(TRIANGLE);
      for(int j=0; j < Q[i].length;++j) {
        int mod = ((((tail-1-i)%Q.length)+Q.length)%Q.length);
        Float intensity = Q[mod][j];
        strokeWeight(4);
        stroke(input.right.level()*255, intensity*255,input.left.level()*255);
        vertex(dx*j, -intensity*10, dy*i);
      }
      endShape();
    }
    
    popMatrix();
  }
  
  public void render2D() {
    float dx = ((float)width)/Q[0].length;
    float dy = ((float)height)/Q.length; 
    
    for(int i=0; i < Q.length; ++i) {
      for(int j=0; j < Q[i].length;++j) {
        int mod = ((((tail-1-i)%Q.length)+Q.length)%Q.length);
      
        Float intensity = Q[mod][j];
        strokeWeight(4);
        stroke(input.right.level()*255, intensity*255, input.left.level()*255);
        
        point(dx*j, dy*i);
      }
    }
  }
  
  //----------------------------------------------------------
  // Private methods
  //----------------------------------------------------------
  
  private void insert(Float[] b) {
    for(int i=0; i < b.length; ++i){
      Q[tail][i] = new Float(b[i]);
    } 
    tail = (tail+1)%Q.length;
  }
  
  private void init(int qLength) {
    //create FFT with input infos
    fft = new FFT(input.bufferSize(), input.sampleRate());
    
    //create queue
    tail = 0;
    Q = new Float[qLength][fft.specSize()];
    for(int i = 0; i < Q.length; i++)
      for(int j = 0; j < Q[i].length; ++j)
        Q[i][j] = 0.0;
  }
  

}
