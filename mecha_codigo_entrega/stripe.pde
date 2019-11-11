class Stripe {
  float x;
  float y;
  float z;
  float w;
  float h;
  float ang_z;
  float ang_y;
  float dir;
  float vel;
  float vel_init;
  float rotation_vel;
  float fly_rotation;
  String text;
  String text2;

  float init_x;
  float init_y;
  float init_z;
  PImage branch;

  float opacity_mult;


  String state; // STAND BY, ROTATING, FLAPPING, FLYING, RETURNING

  int rotating_time = 10;
  int flying_time = 5000;

  float rotation_speed;
  float rotation_speed_init;

  boolean kill_flag;

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  Stripe(PImage img_) {

    x = random(width);
    y = random(height);
    w = 150;
    h = 40;

    branch = img_;

    ang_z = atan2(y-height/2, x-width/2) + PI + radians(random(-15, 15));
    // ang_z = random(TWO_PI);
    ang_y = 0;
    dir = 0;
    vel = random(15, 25);
    vel_init = vel;
    rotation_vel = random(-6, 6);

    text = moods[int(random(moods.length))];
    text2 = climates[int(random(climates.length))];
    text = text.toLowerCase();
    text2 = text2.toLowerCase();

    pushStyle();
    textFont(font);
    float w1 = textWidth(text);
    float w2 = textWidth(text2);
    w = max(w1, w2) + 20;
    popStyle();

    branch.resize(int(w), 0);

    state = "STAND BY"; 
    z = w;
    fly_rotation = 0;

    init_x = x;
    init_y = y;
    init_z = z;
    kill_flag = false;

    rotating_time += int(random(ROTATE_TIME_VARIANCE));
    flying_time += int(random(FLY_TIME_VARIANCE));

    rotation_speed = random(1.5, 4);
    rotation_speed_init = rotation_speed;
    opacity_mult = 1;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void  render() {
    pushStyle();
    textFont(font);
    noStroke();

    rectMode(CENTER);
    pushMatrix();
    translate(x, y, z);
    rotateZ(ang_z);
    translate(-w/2, 0, 0);
    if (state.equals("FLAPPING") || state.equals("STAND BY")) {
      rotateY(radians(ang_y + random(-2, 2)));
    } else {
      rotateY(radians(ang_y));
    }
    translate(w/2, 0, 0);
    rotateZ(fly_rotation/2);
    rotateX(fly_rotation);

    imageMode(CENTER);
    tint(255, 128 * opacity_mult);
    image(branch, 0, 0);
    fill(0, 90 * opacity_mult);
    beginShape();
    vertex(-w/2, 0);
    vertex(-w/2 + h/2, -h/2);
    vertex(w/2, -h/2);
    vertex(w/2, h/2);
    vertex(-w/2+ h/2, h/2);
    endShape();
    // rect(0, 0, w, h);
    textAlign(CENTER, CENTER);
    translate(0, 0, 1);
    fill(255, 90 * opacity_mult);
    text(text, 5, -3);
    translate(0, 0, 1);
    text(text2, 5, 3);
    popMatrix();
    popStyle();
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  void update(int time) {

    if (state.equals("STAND BY") || state.equals("RETURNING")) {
      if (time> rotating_time)
        state = "ROTATING";
    } else if (state.equals("FLAPPING")) {
      if (time > flying_time)
        state = "FLYING";
      dir = atan2(y-height/2, x-width/2);
    }

    if (state.equals("FLAPPING")) {
      if (time< rotating_time) {
        state = "RETURNING";
        rotation_speed = rotation_speed_init;
      }
    }

    if (state.equals("ROTATING")) {
      if (time< rotating_time) {
        state = "RETURNING";
        rotation_speed = rotation_speed_init;
      }
      if (ang_y < 90) {
        ang_y += rotation_speed;
        rotation_speed = rotation_speed*1.1;
      } else {
        ang_y = 90;
        state = "FLAPPING";
      }
    }

    if (state.equals("RETURNING")) {

      if (ang_y > 0) {
        ang_y -= rotation_speed*.7;
        rotation_speed = rotation_speed*1.1;
      } else {
        ang_y = 0;
        state = "STAND BY";
        rotation_speed = rotation_speed_init;
        vel = vel_init;
      }
    }

    if (state.equals("FLYING")) {
      z -= vel;
      x += cos(dir) * vel*.5;
      y += sin(dir) * vel*.5;
      fly_rotation += radians(random(8, 13));
      vel = vel*0.99;
      vel = max(vel_init*.3, vel);
      opacity_mult = map(dist(x, y, z, init_x, init_y, init_z), 0, width, 1, 0);
    }

    if (dist(x, y, z, init_x, init_y, init_z) > width) {
      kill_flag = true;
    }
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••

  float getAmpValue() {
    float ret = 0;
    if(state.equals("STAND BY")){
      ret = 1;
    }else if(state.equals("ROTATING") || state.equals("RETURNING") || state.equals("FLAPPING")){
      ret = map(ang_y, 0, 90, 1, .2);
    }else if(state.equals("FLYING")){
      ret = .2;
    }
    ret = constrain(ret, 0, 1);
    return ret;
  }

  //••••••••••••••••••••••••••••••••••••••••••••••••••••••••
}
