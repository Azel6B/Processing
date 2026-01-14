//STORY
//
//Youre spending the summer at your grandparents farm, and today is the day
//your grandma bakes her famous apple pie for the town fair.
//She needs you to collect as many apples as you can before they hit the ground and bruise.
//As the wind picks up adn the apples begin falling faster, do you think you can keep up?
//
PImage bg, basketImg, appleImg;
float basketX;
float[] appleX = new float[5];
float[] appleY = new float[5];
float appleSpeed = 3;
int score = 0;
int lives = 3;
boolean gameOver = false;

void setup() {
  size(800, 600);
  
  // load img
  bg = loadImage("achtergrond.jpg");
  basketImg = loadImage("mand.png");
  appleImg = loadImage("appel.png");
  
  // Resize img
  basketImg.resize(100, 100);
  appleImg.resize(40, 40);
  
  basketX = width / 2;
  
  // spawn appels random hoogte
  for (int i = 0; i < appleX.length; i++) {
    resetApple(i);
    appleY[i] = random(-500, 0); // Spawn buiten beelds
  }
}

void draw() {
  image(bg, 0, 0, width, height);
  
  if (!gameOver) {
    playGame();
  } else {
    showGameOver();
  }
}

void playGame() {
  textAlign(LEFT);
  // Mand bewegen (A/D)
  if (keyPressed) {
    if (key == 'a' || key == 'A') basketX -= 8;
    if (key == 'd' || key == 'D') basketX += 8;
  }
  basketX = constrain(basketX, 0, width - 100);
  image(basketImg, basketX, height - 80);

  //Appels laten vallen en checken
  for (int i = 0; i < appleX.length; i++) {
    appleY[i] += appleSpeed;
    image(appleImg, appleX[i], appleY[i]);

    //Collision
    if (appleY[i] + 40 > height - 80 && appleX[i] + 40 > basketX && appleX[i] < basketX + 100) {
      score++;
      appleSpeed += 0.1; //harder hoe langer het spel door gaat
      resetApple(i);
    }

    // Check of de appel de grond raakt (Gemist)
    if (appleY[i] > height) {
      lives--;
      resetApple(i);
      if (lives <= 0) {
        gameOver = true;
      }
    }
  }

  //UI
  fill(0,0,0);
  rect(0,0,120,90);
  fill(255);
  textSize(25);
  text("Score: " + score, 20, 40);
  fill(255, 0, 0);
  text("Lives: " + lives, 20, 70);
}

void resetApple(int i) {
  appleX[i] = random(0, width - 40);
  appleY[i] = random(-200, -50);
}

void showGameOver() {
  textAlign(CENTER);
  fill(0, 150);
  rect(0, 0, width, height);
  
  fill(255);
  textSize(50);
  text("GAME OVER", width/2, height/2 - 20);
  textSize(25);
  text("Score: " + score, width/2, height/2 + 30);
  text("press R to restart", width/2, height/2 + 70);
}

void keyPressed() {
  if (gameOver && (key == 'r' || key == 'R')) {
    score = 0;
    lives = 3;
    appleSpeed = 3;
    gameOver = false;
    for (int i = 0; i < appleX.length; i++) {
      resetApple(i);
    }
  }
}
