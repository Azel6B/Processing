String zoekNaam = "Jan";
boolean gevonden = false;
String[] namen = {"Piet","Joey","Jorn","Simon","Rick","Jan"};

void setup(){
  for(int i = 0; i < namen.length; i++){
    if(zoekNaam == namen[i]){
      gevonden = true;
    }
  }
  
  if(gevonden){
    println("ja de naam " + zoekNaam + " bestaat!");
  }else{
    println("De naam " + zoekNaam + " staat er niet in");
  }
}
