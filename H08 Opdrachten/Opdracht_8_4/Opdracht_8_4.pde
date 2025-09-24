size(110,110);
background(0,255,255);

int xWaarde = 10;
int yWaarde = 10;

for (int i = 0; i < 5; i++){
  for(int j = 0; j < 5; i++){
    rect(xWaarde, yWaarde, 10,10);
    yWaarde = yWaarde + 10;
  }
  yWaarde = 10;
  xWaarde = xWaarde + 10;
}
