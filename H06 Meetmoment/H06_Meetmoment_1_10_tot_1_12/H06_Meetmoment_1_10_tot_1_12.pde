//Opdracht 1.10
int x = 11;
int y = 11;
if (x > 10) {
  x = x - 5;
  if (x > 10 || y <= 10) {
    x++;
    y++;
  } else {
    println("Hier wil ik zijn");
  }
}

//Opdracht 1.11
int steen1 = 1;
int steen2 = 6;
int steen3 = 1;
String resultaat = "";

if (steen1 == 1 && steen2 == 1 && steen3 ==1) {
  resultaat = "CRITICAL MISS";
} else if (steen1 == 1 || steen2 == 1 || steen3 == 1) {
  resultaat = "MISS";
} else {
  int schade = (steen1 + steen2 + steen3) / 3;
  resultaat = schade + " HIT";
}
println(resultaat);

//Opdracht 1.12
float cijfer = 5.5;
int present = 16;
int total = 20;
String geslaagd = "";
int precensie = present * 100 / total;

if (precensie < 80 || cijfer < 5.5)
geslaagd = "gezakt";
if (precensie >= 80 && cijfer >=5.5)
geslaagd = "Geslaagd";
print(geslaagd);
