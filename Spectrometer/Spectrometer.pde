class Spectrometer {
  FFT fft;
  Float[][] Q;
  int tail;
  
  Spectrometer(String fileName, int buffSize, int qLength) {

    player = minim.loadFile(fileName, buffSize);
    player.loop();
    fft = new FFT(player.bufferSize(), player.sampleRate());
    
    Q = new Float[qLength][fft.specSize()];
    for(int i = 0; i < Q.length; i++)
      for(int j = 0; j < Q[i].length; ++j)
        Q[i][j] = 0.0;
    tail = 0;
  }
  
  public void update() {
    fft.forward(player.mix);
    
    Float[] buff = new Float[fft.specSize()];
    
    for(int i=0; i < buff.length; ++i) {
      buff[i] = fft.getBand(i);
    }
    insert(buff);
  }
  
  public void render() {
    float dx = ((float)width)/Q[0].length;
    float dy = ((float)height)/Q.length; 
    for(int i=0; i < Q.length; ++i) {
      for(int j=0; j < Q[i].length;++j) {
        int mod = ((((tail-1-i)%Q.length)+Q.length)%Q.length);
      
        Float intensity = Q[mod][j];
        strokeWeight(4);
        stroke(player.right.level()*255, intensity*255,player.left.level()*255);
        
        point(dx*j, dy*i);
      }
    }
  }
  
  private void insert(Float[] b) {
    for(int i=0; i < b.length; ++i){
      Q[tail][i] = new Float(b[i]);
    }
    
    tail = (tail+1)%Q.length;
  }
  
}
