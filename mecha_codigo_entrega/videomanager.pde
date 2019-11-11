class VideoManager {
  Movie [] movies;
  int index;

  VideoManager(PApplet parent) {

    movies = new Movie[23];
    for (int i = 0; i < movies.length; i++) {
      String file = "vid/" + (i+1) + ".mov";
      movies[i] = new Movie(parent, file);
    }
    pickNewMovie();
  }

  void update() {
    if (movies[index].available()) {
      movies[index].read();
    }

    if (movies[index].time() >= movies[index].duration()) {
      pickNewMovie();
    }
  }

  PImage getCurrentFrame() {
    return movies[index];
  }

  void pickNewMovie() {
    movies[index].stop();
    index = floor(random(movies.length));
    movies[index].play();
  }
}
