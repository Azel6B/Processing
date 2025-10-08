int telHoeVaakGetalVoorkomt(int zoekGetal, int[] array) {
    int hoeveel = 0;
    for (int getal : array) {
        if (getal == zoekGetal) {
            hoeveel++;
        }
    }
    return hoeveel;
}

void setup() {
    int[] mijnArray = {0,1,2,4,4,4,6,7,8,9};
    int zoekGetal = 4;
    
    int resultaat = telHoeVaakGetalVoorkomt(zoekGetal, mijnArray);
    println("Het getal" + zoekGetal + " zit " + resultaat + " keer in de array");
}
