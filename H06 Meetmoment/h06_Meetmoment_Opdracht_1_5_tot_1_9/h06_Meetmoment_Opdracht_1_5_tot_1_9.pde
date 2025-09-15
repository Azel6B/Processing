//Opdracht 1.5
println(3==3);
println(4<=5);
int a = 5;
println(3 > a);
println(a!=4);
println(2>1);

//Opdracht 1.6
int b = 5;
println(b > 4 && false);
println(b >= 5 && b > 1);
println(b == 5 && 3 == 3);
println(b != 5 || 3 == 3);
println(5-1+3 == 3 || b == b);

//Opdracht 1.7
//A en B zijn true

//Opdracht 1.8
int TempCelsius = 18;
if (TempCelsius >= 30){
println("Heet");
} else if (TempCelsius > 25 && TempCelsius < 30){
  println("Warm");
} else if (TempCelsius < 25){
  println(TempCelsius);
}

// Opdracht 1.9
int speler1score = 30;
int speler2score = 30;

if(speler1score > speler2score)
  println("Speler 1 Heeft Gewonnen!");
if (speler2score > speler1score)
  println("Speler 2 Heeft Gewonnen!");
if (speler1score == speler2score)
  println("Het is gelijkspel");
