void setup() {
  size(500, 500);
}

void draw() {
  background(0, 255, 255);
  stroke(255, 255, 255);
  strokeWeight(5);
  vierkant(100, 100, 100, 100);
}

void vierkant(int x, int y, int w, int h) {
  //top line
  line(x, y, x+w, y);
  //bottom line
  line(x, y+h, x+w, y+h);
  //Left line
  line(x, y, x, y+h);
  //right line
  line(x+w, y, x+w, y+h);
}
