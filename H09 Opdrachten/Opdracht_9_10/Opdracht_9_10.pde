void setup() {
  size(800, 500);
}

void draw() {
  background(0, 200, 255);

  // grond
  fill(0, 150, 0);
  rect(0, 400, width, 100);

  // meerdere bomen (bos)
  tekenBoom(100, 250, 40, 200, 200, 200); 
  tekenBoom(250, 220, 50, 230, 200, 200); 
  tekenBoom(400, 260, 35, 190, 200, 200); 
  tekenBoom(550, 240, 45, 210, 200, 200); 
  tekenBoom(700, 230, 50, 230, 200, 200); 
}

void tekenBoom(int x, int y, int stamBreedte, int stamHoogte, int bladBreedte, int bladHoogte) {
  // stronk
  fill(150, 80, 0);
  rect(x - stamBreedte/2, y, stamBreedte, stamHoogte);
  
  // bladeren
  fill(80, 255, 0);
  ellipse(x, y, bladBreedte, bladHoogte);
}
