int mijngetal;

void setup(){
println(mijnfunctie(10,20));
mijngetal = mijnfunctie(15,45);
  println(mijngetal);
  
}

void draw(){
  
}

int mijnfunctie(int getal1, int getal2){
  int antwoord;
  antwoord = (getal1 + getal2)/2;
  return antwoord;
}
