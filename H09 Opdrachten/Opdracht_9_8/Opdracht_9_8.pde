void setup(){
  size(500,500); 
}

void draw(){
  background(0,255,255); 
  
  driehoek(250,100, 100,400, 400,400); //every 2 is a diff corner
}

void driehoek(int x1, int y1, int x2, int y2, int x3, int y3){
  stroke(255,255,255); 
  strokeWeight(5);     
  
  line(x1, y1, x2, y2); // side 1
  line(x2, y2, x3, y3); // side 2
  line(x3, y3, x1, y1); // side 3
}
