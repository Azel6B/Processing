  void setup() {
  size(300, 300);
  background(0, 255, 255);
  
int grootte = 20;
int marge = 20;
for (int i = 0; i < 10; i++) {
  for (int j = 0; j < 10; j++){
    int x = marge + j * grootte;
  int y = marge + i * grootte;
  
  if ((i + j) % 2 == 0){
    fill(0);
  }else{
    fill(255);
  }
  rect(x, y, grootte, grootte);
  }
}
}
