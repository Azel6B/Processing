size(400, 400);
background(0, 255, 255);

int sizeC = 200;

for (int i = 0; i < 50; i++) {
  ellipse(5 - sizeC/2, 5 - sizeC/2, sizeC, sizeC);
  sizeC = sizeC - 40;
}
