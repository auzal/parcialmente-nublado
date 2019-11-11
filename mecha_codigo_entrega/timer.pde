class Timer {
  int fire_time;
  int interval_time;
  int prev_time;
  int curr_time;
  int time_acum;
  boolean ring = false;
  boolean loop = false;
  boolean running = false;

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  Timer(int interval_time_) {
    interval_time = interval_time_;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  Timer() {
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setInterval(int interval_) {
    interval_time = interval_;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void fire() {
    running = true;
    fire_time = millis();
    time_acum = 0;
    prev_time = fire_time;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update() {
    if (running) {
      time_acum += millis() - prev_time;
      if (time_acum >= interval_time) {
        time_acum -= interval_time;
        ring = true;
      }
    } else {
      ring = false;
    }
    prev_time = millis();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  boolean isDone() {
    boolean ret = ring;
    if (ring) {
      ring = false;
      if (!loop)
        running = false;
    }
    return ret;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void setLoop(boolean loop_) {
    loop = loop_;
  }
}
