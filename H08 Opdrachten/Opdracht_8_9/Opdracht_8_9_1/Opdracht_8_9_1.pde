size(400,400);
background(0,255,255);

int SizeC = 350;

for(int i = 0; i <50; i++){
  ellipse(200,200,SizeC,SizeC);
  SizeC = SizeC - 7;
}
