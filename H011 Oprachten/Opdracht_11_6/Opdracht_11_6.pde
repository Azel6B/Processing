int zoekGetal = 4;
int hoeveel = 0;
boolean gevonden = false;
int[] mijnArray = {0,1,2,4,4,4,6,7,8,9};


void setup(){
  for (int getal : mijnArray) {
    if (getal == zoekGetal) {
      gevonden = true;
      hoeveel++;
    }

  }
      println("Het Nummer " + zoekGetal +" zit " + hoeveel + " Keer in de array");
}
