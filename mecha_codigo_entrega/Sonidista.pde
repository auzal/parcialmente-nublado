//================================================================
/*                 
 Class Sonidista
 
 Miembros:
 
 int totalSonidos --> total de sonidos
 
 Sonido sonido[] --> vector de objetos Sonido
 
 
 Metodos:
 
 void ejecutarSonido(int id, boolean conLoop_, float amp_, float pan_, float speed_) --> Ejecuta el sonido "id"
 void ejecutarSonido(int id) --> ejecuta el sonido "id". Los valores por defecto son: loop false, amp 1.0, pan 0.0
 void ejecutarSonido(int min, int max) --> ejecuta un sonido al azar entre min y max. Los valores por defecto son: loop false, amp 1.0, pan 0.0
 void ejecutarSonido() --> ejecuta un sonido al azar del "totalSonidos" Los valores por defecto son: loop false, amp 1.0, pan 0.0
 void ejecutarSonidoRandomPan(int id) --> ejecuta el sonido "id" con un valor de paneo al azar
 void ejecutarSonidoLoop(int id) --> ejecuta "id" sonido en looop
 void fadeIn(int id, int tiempo) --> realiza un fade in al sonido "id" en tiempo definido
 void fadeOut(int id, int tiempo) --> realiza un fade out al sonido "id" en tiempo definido
 void setAmp(int id, float amp) --> establece la amplitud (0 a 1) del sonido "id"
 void setSpeed(int id, float speed) --> establece la velocidad de reproduccion del sonido "id"
 void setPan(int id, float pan) --> establece el paneo (-1 a 1) del sonido "id"
 void pararSonido(int id) --> detiene la ejecucion del sonido "id"
 void apagarTodosLosSonidosConFade() --> detiene y apaga todos los sonidos con un fade out
 void apagarSonidos() --> apaga todos los sonidos (sin fade)
 void prenderSonidos() --> habilita el sonido
 void imprimir() --> imprime la info del sonido ejecutado en cada momento. 
 Ej:  Sonido: id | Play: 1 | Loop: 1/0 | amp: 0.5 | pan: -1.0 | Speed: 1.0 | 
 
 */

import oscP5.*;
import netP5.*;

OscP5 sonidistaOSC;
NetAddress sonidistaDirIP;
String ip = "127.0.0.1";
int puerto = 13000;

//======================CONSTANTES================================

float DEFAULT_AMP = 0.9;

float MIN_AMP = 0;
float MAX_AMP = DEFAULT_AMP;

int FADE_IN_TIME = 1000;
int FADE_OUT_TIME = 2000;

//================================================================ 

class Sonidista {

  int totalSonidos;

  Sonido sonido[];

  Sonidista(int totalSonidos) {

    sonido = new Sonido [totalSonidos];

    for (int i = 0; i < totalSonidos; i++) {
      sonido[i] = new Sonido();
      sonido[i].id = i; //asigna un id a cada sonido
    }

    sonidistaOSC = new OscP5(this, puerto); // Entrada: mensajes de entrada por el puerto especificado
    sonidistaDirIP = new NetAddress(ip, puerto);
  }

  //---------------Metodos---------------

  //-------------------------------------
  void ejecutarSonido(int id, boolean conLoop_, float amp_, float pan_, float speed_) {

    if (sonido[id] != null) {
      sonido[id].conLoop = conLoop_ == true ? 1 : 0;
      sonido[id].amp = constrain (amp_, MIN_AMP, MAX_AMP);
      sonido[id].pan = constrain (map (pan_, 0, 1.0, -1.0, 1.0), -1.0, 1.0);
      sonido[id].speed = speed_;
      sonido[id].play();
    }
  }

  //-------------------------------------
  void ejecutarSonido(int min, int max) {
    int s = int (random (min, max) );
    ejecutarSonido(s);
  }

  //-------------------------------------
  void ejecutarSonido(int id) {
    ejecutarSonido(id, false, DEFAULT_AMP, 0.5, 1.0);
  }


  //-------------------------------------
  void ejecutarSonido() {
    int s = int (random (totalSonidos) );
    ejecutarSonido(s);
  }

  //-------------------------------------
  void ejecutarSonidoRandom(int min, int max) {
    int s = int (random (min, max) );
    ejecutarSonidoRandomPan(s);
  }
  //-------------------------------------
  void ejecutarSonidoRandomPan(int id) {
    float r = random(0, 1000);
    r = r / 1000.0;
    ejecutarSonido(id, false, DEFAULT_AMP, r, 1.0);
  }

  //-------------------------------------
  void ejecutarSonidoLoop(int id) {
    ejecutarSonido(id, true, DEFAULT_AMP, 0.0, 1.0);
  }

  //-------------------------------------
  void fadeIn(int id, int tiempo) {
    if (sonido[id] != null) {
      sonido[id].fadeIn(tiempo);
    }
  }

  //-------------------------------------
  void fadeOut(int id, int tiempo) {
    if (sonido[id] != null) {
      sonido[id].fadeOut(tiempo);
    }
  }

  //-------------------------------------
  void setAmp(int id, float amp) {
    if (sonido[id] != null) {
      sonido[id].setAmp(amp);
    }
  }

  //-------------------------------------
  void setSpeed(int id, float speed) {
    if (sonido[id] != null) {
      sonido[id].setSpeed(speed);
    }
  }

  //-------------------------------------
  void setPan(int id, float pan) {
    if (sonido[id] != null) {
      sonido[id].setPan(pan);
    }
  }

  //-------------------------------------
  void pararSonido(int id) { 
    if (sonido[id] != null) {
      sonido[id].stop();
    }
  }

  //-------------------------------------
  void apagarTodosLosSonidosConFade() {

    for (int i = 0; i < totalSonidos; i++) {
      sonido[i].fadeOut(FADE_OUT_TIME);
    }
  }

  //-------------------------------------
  void apagarSonidos() {
    enviarApagarSonidos(1);
    //println("sonido OFF");
  }

  //-------------------------------------
  void prenderSonidos() {
    enviarApagarSonidos(0);
    //println("sonido ON");
  }

  //-------------------------------------
  void imprimir() {
    for (int i = 0; i < totalSonidos; i++) {
      sonido[i].imprimir();
    }
  }
}

//---------------------------------------------------
//----------------OBJETO SONIDO----------------------
//---------------------------------------------------

class Sonido {

  int id, play, conLoop; 
  float amp, pan, speed;

  boolean imprimirMensaje;

  Sonido() {

    //------Variables-----
    id = -1;
    play = 0;  // 1; sonido play
    conLoop = 0;  // 1: Sonido ejecutado en loop, 0: sin repetici√≥n
    amp = 1.0;  // Valor entre 0 y 1
    pan = 0.0;      // Panor√°mico de intensidad. Valor entre -1.0 y 1.0 || -1: izquierda y 1: derecha
    speed = 1.0;    // Velocidad de reproduccion del archivo. 1: velocidad original, 0.5: mitad, 2: el doble

    imprimirMensaje = false;
  }

  //-------------------------------------
  void play() {
    play = 1;
    ejecutar();
  }

  //-------------------------------------
  void stop() {
    play = 0;
    ejecutar();
  }

  //-------------------------------------
  void fadeIn( int tiempo ) {
    enviarFade (id, 1, tiempo);
  }

  //-------------------------------------
  void fadeOut( int tiempo ) {
    enviarFade (id, 2, tiempo);
  }

  //-------------------------------------
  void setAmp( float _amp ) {
    enviarAmp (id, _amp);
  }

  //-------------------------------------
  void setPan( float _pan ) {
    enviarPan (id, _pan);
  }

  //-------------------------------------
  void setSpeed( float _speed ) {
    enviarSpeed (id, _speed);
  }

  //-------------------------------------
  void ejecutar() {

    enviarEjecutarSonido (id, play, conLoop, amp, pan, speed, imprimirMensaje);
  }

  //-------------------------------------
  void imprimir() {
    imprimirMensaje = false;
  }
}  

//----------------------------------------------------
//----------------Funci√≥n Envio OSC-------------------
//----------------------------------------------------

void enviarEjecutarSonido (int cualSonido_, int playSonido_, int loopSonido_, float amplitud_, float pan_, float speed_, boolean imprimir) {

  OscMessage mensaje = new OscMessage("/sonido/play"); //crea una etiqueta para el mensaje

    mensaje.add(cualSonido_); // se le agrega un dato
  mensaje.add(playSonido_);
  mensaje.add(amplitud_);
  mensaje.add(pan_);
  mensaje.add(speed_);
  mensaje.add(loopSonido_);

  sonidistaOSC.send(mensaje, sonidistaDirIP); //Se envia el mensaje

  if (imprimir) {
    println(
    "Sonido: "+ cualSonido_ + " | " + 
      "Play: "+ playSonido_ + " | " + 
      "Loop: "+ loopSonido_ + " | " +
      "amp: "+ amplitud_ + " | " +
      "pan: "+ pan_ + " | " +
      "Speed: "+ speed_ + " | "
      );
  }
}

//----------------------------------------------------
void enviarApagarSonidos (int stopSonidos) {

  OscMessage mensaje = new OscMessage("/sonido/stop"); //crea una etiqueta para el mensaje

    mensaje.add(stopSonidos); // se le agrega un dato

  sonidistaOSC.send(mensaje, sonidistaDirIP); //Se envia el mensaje
}

//----------------------------------------------------
void enviarFade (int cual, int tipo, int tiempo) {

  OscMessage mensaje = new OscMessage("/sonido/fade"); //crea una etiqueta para el mensaje

    mensaje.add(cual);
  mensaje.add(tipo);
  mensaje.add(tiempo);

  sonidistaOSC.send(mensaje, sonidistaDirIP); //Se envia el mensaje
}

//----------------------------------------------------
void enviarAmp (int cual, float amp ) {

  OscMessage mensaje = new OscMessage("/sonido/amp"); //crea una etiqueta para el mensaje

    mensaje.add(cual);
  mensaje.add(amp);

  sonidistaOSC.send(mensaje, sonidistaDirIP); //Se envia el mensaje
}

//----------------------------------------------------
void enviarPan (int cual, float pan ) {

  OscMessage mensaje = new OscMessage("/sonido/pan"); //crea una etiqueta para el mensaje

    mensaje.add(cual);
  mensaje.add(pan);

  sonidistaOSC.send(mensaje, sonidistaDirIP); //Se envia el mensaje
}

//----------------------------------------------------
void enviarSpeed (int cual, float speed ) {

  OscMessage mensaje = new OscMessage("/sonido/speed"); //crea una etiqueta para el mensaje

    mensaje.add(cual);
  mensaje.add(speed);

  sonidistaOSC.send(mensaje, sonidistaDirIP); //Se envia el mensaje
}
