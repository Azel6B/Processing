void setup(){
  size(200,200);
  background(0,255,255);
  int rectGrootte = 30;
  
  for (int i = 0; i < 5; i++){
    int x = 20 + i * rectGrootte;
    int y = 20 + i * rectGrootte;
    rect(x,y,rectGrootte,rectGrootte);
  }
}
