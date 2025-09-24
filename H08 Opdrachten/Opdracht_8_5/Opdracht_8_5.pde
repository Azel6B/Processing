size(200,200);
background(0,255,255);

int SizeC = 180;

for(int i = 0; i <5; i++){
  ellipse(100,100,SizeC,SizeC);
  SizeC = SizeC - 40;
}
