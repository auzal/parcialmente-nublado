import processing.sound.*;
import peasy.*;
import processing.video.*;
import oscP5.*;
import netP5.*;


/// ASTRA zapping-browsing 1994





Sonidista sounddirector;
VideoManager vm;
Timer timer;

ArrayList <Stripe> stripes;
PFont font;
PeasyCam cam;

String [] moods;
String [] climates;

PImage [] branches;

StopWatch time;



//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void setup() {
  //size(1280, 800, P3D);
  fullScreen(P3D);

  sounddirector = new Sonidista(11);

  loadJSON();
  initSerial();

  vm = new VideoManager(this);

  stripes = new ArrayList();
  timer = new Timer();
  timer.setInterval(CREATE_INTERVAL);
  timer.fire();
  timer.setLoop(true);
  noCursor();
  font = createFont("apercu_mono_pro.otf", TEXT_SIZE);
  textFont(font);

  loadAndCreateStripes();

  cam = new PeasyCam(this, 690);

  sounddirector.prenderSonidos();

  sounddirector.ejecutarSonidoLoop(0);
  sounddirector.ejecutarSonidoLoop(1);
  sounddirector.ejecutarSonidoLoop(2);
  sounddirector.setAmp(0, 0.1);
  sounddirector.setAmp(1, 0.5);
  sounddirector.setAmp(2, 0.5);


  time = new StopWatch();

  // blendMode(ADD);
  //ortho();
  hint(DISABLE_DEPTH_MASK);
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void draw() {
  background(20);
  updateWind(); // update wind managment
  vm.update();  // update video manager
  time.update(); // update stopwatch

  if (val_damp > WIND_THRESHOLD) {
    if (!time.isRunning()) {
      time.fire();
    }
  } else {
    if (time.isRunning()) {
      time.stop();
    }
  }

  float noise_amp = calculateNoiseAmp();

  sounddirector.setAmp(1, noise_amp);
  sounddirector.setAmp(0, map((1.0-noise_amp), 0, 1, 0, 0.07));
  sounddirector.setAmp(2, map((1.0-noise_amp), 0, 1, 0, 0.3));

  String title = nfc(frameRate, 1) + " | " + stripes.size(); 
  surface.setTitle(title);
  translate(-width/2, -height/2);


  timer.update();
  image(vm.getCurrentFrame(), 0, 0, width, height);

  for (int i = 0; i < stripes.size(); i++) {
    stripes.get(i).render();
    stripes.get(i).update(time.getTime());
  }

  if (timer.isDone() && !time.isRunning()) {
    if (stripes.size() < STRIPES_NUM) {
      addStripe();
      timer.setInterval(CREATE_INTERVAL + int(random(-CREATE_INTERVAL_VARIANCE, CREATE_INTERVAL_VARIANCE)));
    }
  }

  if (keyPressed) {

    String fps = nfc(frameRate, 1);
    fill(255, 0, 0);
    text(fps, 20, 20);
    text(stripes.size(), 20, 40);
    text(time.getTime(), 20, 60);
    text(noise_amp, 20, 80);
    renderWind();
  }


  for (int i = stripes.size() -1; i >=0; i--) {
    if (stripes.get(i).kill_flag) {
      stripes.remove(i);
    }
  }
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void keyPressed() {

  if (key =='r' || key == 'R') {
    reset();
  }
  if (key == DELETE || key == BACKSPACE) {
    sounddirector.apagarSonidos();
  }
}


//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void keyReleased() {
}


//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void mouseClicked() {
  cam.reset();
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void loadJSON() {
  JSONObject json;
  JSONArray array;
  json = loadJSONObject("JSON/weathershort_spa.json");
  array = json.getJSONArray("conditions");

  climates = new String[array.size()];
  for (int i = 0; i < array.size(); i++) {
    climates[i] = array.get(i).toString();
  }
  println(climates.length);

  json = loadJSONObject("JSON/moods_spa.json");
  array = json.getJSONArray("moods");

  moods = new String[array.size()];
  for (int i = 0; i < array.size(); i++) {
    moods[i] = array.get(i).toString();
  }
  println(moods.length);
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void reset() {
  stripes.clear();
  createStripes();
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void loadAndCreateStripes() {
  branches = new PImage[3];
  for (int i = 0; i < branches.length; i++) {
    String file = "img/branch" + (i+1) + ".png";
    branches[i] = loadImage(file);
    branches[i].resize(400, 0);
  }
  stripes = new ArrayList();
  createStripes();
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void createStripes() {
  for (int i = 0; i < STRIPES_NUM; i++) {
    int which = floor(random(branches.length));
    PImage img = createImage(branches[which].width, branches[which].height, ARGB);
    img = branches[which].copy();
    Stripe aux = new Stripe(img);
    stripes.add(aux);
  }
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••

void addStripe() {
  int which = floor(random(branches.length));
  PImage img = createImage(branches[which].width, branches[which].height, ARGB);
  img = branches[which].copy();
  Stripe aux = new Stripe(img);
  stripes.add(aux);

  which = floor(random(branches.length));
  img = createImage(branches[which].width, branches[which].height, ARGB);
  img = branches[which].copy();
  aux = new Stripe(img);
  stripes.add(aux);

  int thump = floor(random(3, 11));
  sounddirector.ejecutarSonido(thump);
  sounddirector.setAmp(2, 0.5);
  sounddirector.setAmp(3, 0.5);
}

//••••••••••••••••••••••••••••••••••••••••••••••••••••••••


float calculateNoiseAmp() {
  float res = 0;

  float acum = 0;
  for (int i = 0; i < stripes.size(); i++ ) {
    acum += stripes.get(i).getAmpValue();
  }

  res = acum/STRIPES_NUM;
  return res;
}
