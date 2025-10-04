void setup() {
  size(500,500);
  
}

void draw(){
  background(0,200,255);
  
  fill(0,150,0);
  rect(0,400, 500, 100);
  
  tekenBoom(250, 260, 50, 190, 200, 200);
}

void tekenBoom(int x, int y, int stamBreedte, int stamHoogte, int bladBreedte, int bladHoogte){
  //Stam
  fill(150,80,0);
  rect(x - 20, y, stamBreedte, stamHoogte);
  //Bladren
  fill(80,255,0);
  ellipse(x, y - 30, bladBreedte, bladHoogte);
}
