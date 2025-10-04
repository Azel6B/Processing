int mijngetal = 8;

void setup(){
  mijnmethode(mijngetal, 2);
  mijnmethode(mijngetal, 80);
}

void draw(){
  
}

void mijnmethode(int getal, int getaltwee){
  int totaal;
  totaal = (getal + getaltwee) / 2;
  println("Som " + getal +" + "+ getaltwee + " /2= " + totaal);
}
