import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
float val_damp;

void initSerial() {
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
}

void updateWind() {
  // max valor de viento 952.5248
  if ( myPort.available() > 0) { 
    float val_prev = val_damp;// If data is available,
    val = myPort.read() * WIND_AMPLIFICATION_FACTOR;    // read it and store it in val
    float f = 0.07;
    val_damp = val*f + val_prev * (1-f);
  }
}


void renderWind() {
  pushStyle();
  pushMatrix();
  translate(200, 200, 200);
  noFill();
  stroke(255, 0, 0);
  rect(0, 0, MAX_WIND/2, 20);
  fill(255, 0, 0);
  rect(0, 0, val_damp/2, 20);
  stroke(0,255,0);
  line(WIND_THRESHOLD/2,0,WIND_THRESHOLD/2,20);
  line(FLY_THRESHOLD/2,0,FLY_THRESHOLD/2,20);
  popMatrix();
  popStyle();
}
