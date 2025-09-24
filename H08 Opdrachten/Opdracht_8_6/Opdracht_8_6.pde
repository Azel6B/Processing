size(200,200);
background(0,255,255);

int SizeC = 100;

for(int i = 0; i <5; i++){
  ellipse(200 - SizeC/2,100 - SizeC/2,SizeC,SizeC);
  SizeC = SizeC - 20;
}
