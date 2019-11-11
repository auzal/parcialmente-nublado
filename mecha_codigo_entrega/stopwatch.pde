class StopWatch {
  int fire_time;
  int curr_time;
  boolean running;

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  StopWatch() {
    running = false;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update() {
    if (running == true)
      curr_time = millis() - fire_time;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void stop() {
    running = false;
    curr_time = 0;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void fire() {
    fire_time = millis();
    curr_time = 0;
    running = true;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  int getTime() {
    return curr_time;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  boolean isRunning(){
    return running;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••
}
