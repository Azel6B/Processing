/* LORE:
 You are Pixel, the last of the Martians, a lone alien defender.
 Your planet is under siege, attacked from all sides by relentless alien invaders and the cold, mechanical armies of humanity's robots.
 The fate of Mars rests on your shoulders.
 */



// ================================================================================
// GLOBAL GAME VARIABLES
// ================================================================================

// Player Bullet
ArrayList<PlayerBullet> playerBullets;
float playerBulletDamage = 1; // Base damage for my bullet
float playerFireRate = 500; // Milliseconds between shots (lower is faster)
long lastPlayerShotTime = 0;

// Images and Fonts
PImage playerImg;
PImage enemyW1Img;
PImage enemyW2Img;
PImage enemyW3Img;
PImage EnemyTankImg;
PImage enemyBossImg;
PImage spaceImg;
PImage healthPowerUpImg;
PFont font;

// Game Logic
int Score = 0;
int highScore = 0;
int Coins = 0;
int playerMaxHealth = 5; // Base max health
int playerHealth = playerMaxHealth;
ArrayList<EnemiesW1> enemies;
ArrayList<EnemyProjectile> enemyProjectiles; // List for enemy projectiles
ArrayList<PowerUp> powerUps; // List for power-ups

float playerX;
float playerSpeed = 5; // Base player speed
boolean leftPressed = false;
boolean rightPressed = false;

// Wave System
int currentWave = 1; // Start at wave 1
int enemiesPerWave = 0; // Will be set by startWave()
int enemiesDefeatedInWave = 0;
int totalWaves = 15;

// Off-screen damage cooldown
long lastOffScreenDamageTime = 0;
long offScreenDamageCooldown = 1000; // 1 second cooldown (in milliseconds)

// Game States
boolean isPlaying = true;
boolean isGameOver = false;
boolean isWinScreen = false;

// Upgrade System
int upgrade_PlayerMaxHealth = 0;
int upgrade_PlayerSpeed = 0;
int upgrade_BulletDamage = 0;
int upgrade_FireRate = 0;
int upgrade_CoinsDrops = 0;

// Upgrade costs
final int HEALTH_UPGRADE_COST = 50;
final int SPEED_UPGRADE_COST = 75;
final int DAMAGE_UPGRADE_COST = 100;
final int FIRERATE_UPGRADE_COST = 120;
final int COINSDROPS_UPGRADE_COST = 200;

// Max upgrade levels
final int MAX_HEALTH_LEVEL = 5;
final int MAX_SPEED_LEVEL = 8;
final int MAX_DAMAGE_LEVEL = 4;
final int MAX_FIRERATE_LEVEL = 3;
final int MAX_COINSDROPS_LEVEL = 3;

// Coins Upgrade Multiplier
float currentCoinMultiplier = 1.0;

//Shader
//PShader retroShader;

// ================================================================================
// SETUP
// ================================================================================

void setup() {
  frameRate(60);
  size(600, 750); //size (600, 750);

  loadGame();

  //Retro Shader
  //retroShader = loadShader("retro_shader.glsl");
  //retroShader.set("resolution", (float)width, (float)height);

  // Load Images
  playerImg = loadImage("player.png");
  playerImg.resize(60, 60);
  enemyW1Img = loadImage("enemyW1.png");
  enemyW1Img.resize(100, 100);
  enemyW2Img = loadImage("enemyW2.png");
  enemyW2Img.resize(75, 75);
  enemyW3Img = loadImage("enemyW3.png");
  enemyW3Img.resize(100, 100);
  EnemyTankImg = loadImage("TankEnemy.png");
  EnemyTankImg.resize(200, 200);
  enemyBossImg = loadImage("bossEnemy.png");
  enemyBossImg.resize(200, 200); // Bigger Boss
  spaceImg = loadImage("space.png");
  healthPowerUpImg = loadImage("health_powerup.png");

  // Initialize Lists
  enemies = new ArrayList<EnemiesW1>();
  enemyProjectiles = new ArrayList<EnemyProjectile>();
  powerUps = new ArrayList<PowerUp>();
  playerBullets = new ArrayList<PlayerBullet>();

  // Font and Cursor
  noCursor();
  font = createFont("PixelFont.ttf", 32);
  textFont(font);

  playerX = width / 2 - playerImg.width / 2;

  // Apply initial upgrades
  applyAllUpgrades();

  // Start the first wave
  startWave();
}

// ================================================================================
// DRAW
// ================================================================================

void draw() {
  //shader(retroShader);

  image(spaceImg, 0, 0, width, height); // Draw background first

  if (isPlaying) {
    drawGamePlaying();
  } else if (isGameOver) {
    drawGameOverScreen();
  } else if (isWinScreen) {
    drawWinScreen();
  }
  //resetShader();
}

void drawGamePlaying() {  //-------Both Display() and Draw()----
  drawCurrentWave();
  updatePlayerMovement();
  updateEnemies();
  updateEnemyProjectiles();
  updatePowerUps();

  // Wave Progression Check
  if (enemiesDefeatedInWave >= enemiesPerWave) {
    currentWave++;
    if (currentWave <= totalWaves) {
      startWave();
    } else {
      println("All waves defeated! Good Job Soldier!");
      isPlaying = false;     // Game is no longer playing
      isWinScreen = true;    // Player has won
    }
  }
  //Collision Calls

  checkPlayerBulletCollisions(); // Enemy hit collision
  checkEnemyProjectileCollisions(); // Player Hit collision
  checkPowerUpCollisions();         // Power-up collision

  Score_Coins();
  drawPlayerHealth();
  drawUpgradeStatus(); // Draw current upgrade levels

  updatePlayerBullets();
  fill(255);
  image(playerImg, playerX, 690); // Draw player
}

// ================================================================================
// GAME FUNCTIONS
// ================================================================================

void drawEnergyBall(float x, float floatY) {
  // Glowing effect
  for (int r = 30; r > 0; r--) {
    fill(0, 150, 255, 255 - r * 8); // Blue glow that fades out
    noStroke();
    ellipse(x, floatY, r, r);
  }
  // Ball center
  fill(255, 255, 255);
  ellipse(x, floatY, 8, 8);
  // VFX
  fill(100, 200, 255, 150);
  ellipse(x, floatY, 15, 15);
}

void updateEnemies() {
  for (int i = enemies.size() - 1; i >= 0; i--) {
    EnemiesW1 enemy = enemies.get(i);
    enemy.update();
    enemy.display();

    if (enemy.isOffScreen()) {
      takeDamage(enemy.damageDealt); // Take enemy specific damage
      enemy.reset(random(10, width - enemy.size - 10), -random(50, 200));
    }
  }
}

// Update and display enemy projectiles
void updateEnemyProjectiles() {
  for (int i = enemyProjectiles.size() - 1; i >= 0; i--) {
    EnemyProjectile ep = enemyProjectiles.get(i);
    ep.update();
    ep.display();
    if (!ep.active) {
      enemyProjectiles.remove(i);
    }
  }
}

// Update and display power-ups
void updatePowerUps() {
  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp pu = powerUps.get(i);
    pu.update();
    pu.display();
    if (!pu.active) {
      powerUps.remove(i);
    }
  }
}

void updatePlayerBullets() {
  for (int i = playerBullets.size() - 1; i >= 0; i--) {
    PlayerBullet pb = playerBullets.get(i);
    pb.update();
    pb.display();
    if (!pb.active) {
      playerBullets.remove(i);
    }
  }
}


void Score_Coins() {
  textAlign(LEFT, TOP);
  fill(0, 255, 0);
  textSize(24);
  text("Score: " + Score, 30, 50);
  text("Coins: " + Coins, 30, 80);
}

void drawPlayerHealth() {
  textAlign(LEFT, TOP);
  fill(255, 0, 0); // Red
  textSize(24);
  text("Health: " + playerHealth, width - 150, 50); //top rifght health
}

void drawCurrentWave() {
  textAlign(TOP, TOP);
  fill(255);
  textSize(24);
  text("Wave: " + currentWave + " / " + totalWaves, width / 2 - 90, 50);
}

// Display current upgrade levels and costs
void drawUpgradeStatus() {
  textAlign(LEFT, TOP);
  fill(255, 200, 0); // Orange
  textSize(18);
  text("HP Lv: " + upgrade_PlayerMaxHealth + " (1) Cost: " + HEALTH_UPGRADE_COST, 30, 110);
  text("Spd Lv: " + upgrade_PlayerSpeed + " (2) Cost: " + SPEED_UPGRADE_COST, 30, 130);
  text("Dmg Lv: " + upgrade_BulletDamage + " (3) Cost: " + DAMAGE_UPGRADE_COST, 30, 150);
  text("FR Lv: " + upgrade_FireRate + " (4) Cost: " + FIRERATE_UPGRADE_COST, 30, 170);
  text("COIN Lv: " + upgrade_CoinsDrops + " (5) Cost: " + COINSDROPS_UPGRADE_COST, 30, 190);
}


// Player bullet to enemy collision
void checkPlayerBulletCollisions() {
  for (int i = playerBullets.size() - 1; i >= 0; i--) {
    PlayerBullet pb = playerBullets.get(i);

    if (!pb.active) continue; // Skip inactive bullets

    float bulletCenterX = pb.x;
    float bulletCenterY = pb.y;

    for (int j = enemies.size() - 1; j >= 0; j--) {
      EnemiesW1 enemy = enemies.get(j);

      if (enemy.active) {
        float enemyCenterX = enemy.x + (enemy.img.width / 2);
        float enemyCenterY = enemy.y + (enemy.img.height / 2);
        float distance = dist(bulletCenterX, bulletCenterY, enemyCenterX, enemyCenterY);

        if (distance < 40) { // Collision radius
          println("HIT!");
          pb.active = false; // Bullet disappears on hit
          playerBullets.remove(i); // Remove bullet from list

          enemy.healthValue -= playerBulletDamage;

          if (enemy.healthValue <= 0) { // Enemy defeated
            Score += enemy.scoreValue;
            Coins += (int)(enemy.coinValue * currentCoinMultiplier);
            enemiesDefeatedInWave++;

            // Chance to drop power-up
            if (random(1) < 0.05) {
              if (healthPowerUpImg != null) {
                powerUps.add(new PowerUp(enemy.x + enemy.img.width / 2, enemy.y + enemy.img.height / 2, 2, 60, "HEALTH_UP", healthPowerUpImg));
              }
            }
            enemies.remove(j);
          }
          break; // Exit enemy loop after hit
        }
      }
    }
  }
}


// Check enemy projectile collision with player
void checkEnemyProjectileCollisions() {
  float playerTopY = 690;
  float playerLeftX = playerX;
  float playerWidth = playerImg.width;
  float playerHeight = playerImg.height;

  for (int i = enemyProjectiles.size() - 1; i >= 0; i--) {
    EnemyProjectile ep = enemyProjectiles.get(i);
    if (ep.active && ep.collidesWithPlayer(playerLeftX, playerTopY, playerWidth, playerHeight)) {
      println("Player HIT by enemy projectile!");
      takeDamage(ep.damageDealt); // Use the projectile's specific damage
      ep.active = false; // Deactivate the projectile after hit
      enemyProjectiles.remove(i); // Remove it from the list
    }
  }
}

// Check power-up collision with player
void checkPowerUpCollisions() {
  float playerTopY = 690;
  float playerLeftX = playerX;
  float playerWidth = playerImg.width;
  float playerHeight = playerImg.height;

  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp pu = powerUps.get(i);
    if (pu.active && pu.collidesWithPlayer(playerLeftX, playerTopY, playerWidth, playerHeight)) {
      println("Player picked up " + pu.type + " power-up!");
      applyPowerUpEffect(pu.type); // Apply the effect
      pu.active = false; // Deactivate
      powerUps.remove(i); // Remove from list
    }
  }
}

void applyPowerUpEffect(String type) {
  if (type.equals("HEALTH_UP")) {
    Heal(1); // Heal 1 health point
  }
  // add more powerups here if i want to, maybe for a later game
}


void takeDamage(int damageAmount) {
  playerHealth -= damageAmount;
  if (playerHealth <= 0) {
    playerHealth = 0; // Health not negative
    isPlaying = false;   // Turn playing screen off
    isGameOver = true;   // Swicth to game over screen
  }
}

void Heal(int healAmount) {
  playerHealth += healAmount;
  if (playerHealth > playerMaxHealth) {
    playerHealth = playerMaxHealth;
  }
}

void drawGameOverScreen() {
  saveGame();
  highScore();
  fill(0, 0, 0, 200); // Semi-transparent black background
  rect(0, 0, width, height);

  fill(255, 0, 0); // Red text
  textSize(48);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width / 2, height / 2 - 100);

  textSize(32);
  fill(255); // White text
  text("Score: " + Score, width / 2, height / 2 + 0);
  text("Coins: " + Coins, width / 2, height / 2 + 40);
  text("High Score: " + highScore, width / 2, height / 2 + 80);

  fill(0, 200, 255); // Blue text
  textSize(24);
  text("Press 'R' to Restart", width / 2, height / 2 + 150);
}

void drawWinScreen() {
  saveGame();
  highScore();
  fill(0, 0, 0, 200); // Semi-transparent black background
  rect(0, 0, width, height);

  fill(255, 255, 0); // Yellow text
  textSize(48);
  textAlign(CENTER, CENTER);
  text("VICTORY!", width / 2, height / 2 - 100);

  textSize(32);
  fill(255); // White text
  text("Final Score: " + Score, width / 2, height / 2 + 0);
  text("Coins Earned: " + Coins, width / 2, height / 2 + 40);
  text("High Score: " + highScore, width / 2, height / 2 + 80);

  fill(0, 200, 255); // Blue text
  textSize(24);
  text("Press 'R' to Play Again", width / 2, height / 2 + 150);
}


void highScore() {
  if (Score >= highScore) {
    highScore = Score;
  }
}

void resetGame() {
  // Reset player stats based on current upgrades
  applyAllUpgrades(); // Reapply upgrades to reset stats correctly

  Score = 0;

  // Reset wave system
  currentWave = 1;
  enemiesDefeatedInWave = 0;

  // Clear all entities
  enemies.clear();
  enemyProjectiles.clear();
  powerUps.clear();
  playerBullets.clear();

  lastOffScreenDamageTime = 0;
  lastPlayerShotTime = 0; // Reset player shooting timer

  println("Game has been reset!");
  isPlaying = true;      // Start playing again
  isGameOver = false;    // Not game over
  isWinScreen = false;   // Not win screen
  startWave(); // Start a new game
}
//----On LOSS or DEATH reapply all bought upgrades----
void applyAllUpgrades() {
  playerMaxHealth = 5 + upgrade_PlayerMaxHealth;
  playerHealth = playerMaxHealth; // Heal to new max health
  playerSpeed = 5 + (upgrade_PlayerSpeed * 1.5); // Increase speed by 1.5 per level
  playerBulletDamage = 1 + upgrade_BulletDamage;
  playerFireRate = max(100, 500 - upgrade_FireRate * 50); // Faster fire rate
  currentCoinMultiplier = 1.0 + (upgrade_CoinsDrops * 0.5); // Increase coin multiplier by 0.5 per level
}

// Function to spawn enemy projectiles (called by EnemyW3 and Boss)
void spawnEnemyProjectile(float x, float y, float speed, float size, int damage) {
  enemyProjectiles.add(new EnemyProjectile(x, y, speed, size, damage));
}

// ================================================================================
// WAVE SYSTEM
// ================================================================================

void startWave() {
  enemies.clear();
  enemyProjectiles.clear(); // Clear any lingering enemy projectiles
  //powerUps.clear();         // Clear any lingering power-ups// off for now
  enemiesDefeatedInWave = 0;

  // Adjust enemiesPerWave based on currentWave
  if (currentWave <= 4) {
    enemiesPerWave = 5;
  } else if (currentWave <= 9) {
    enemiesPerWave = 7;
  } else if (currentWave <= 14) {
    enemiesPerWave = 10;
  } else if (currentWave == 15) { //Boss wave
    enemiesPerWave = 1;
  }

  println("Starting Wave " + currentWave + " with " + enemiesPerWave + " enemies!");

  if (currentWave <= 4) {
    for (int i = 0; i < enemiesPerWave; i++) {
      // EnemyW1: (startX, startY, speed, image, size, SCORE, COINS, DAMAGE, HEALTH)
      enemies.add(new EnemiesW1(random(10, width - 110), -random(50, 500), random(1, 3), enemyW1Img, 100, 100, 2, 1, 1));
    }
  } else if (currentWave <= 9) {
    // Mix of EnemyW1 and EnemyW2
    for (int i = 0; i < enemiesPerWave; i++) {
      if (random(1) < 0.6) { // 60% chance for EnemyW1
        enemies.add(new EnemiesW1(random(10, width - 110), -random(50, 500), random(1, 3), enemyW1Img, 100, 100, 2, 1, 1));
      } else { // 40% chance for EnemyW2
        // EnemyW2: (startX, startY, speed, image, size, SCORE, COINS, DAMAGE, HEALTH)
        enemies.add(new EnemiesW1(random(10, width - 110), -random(50, 500), random(2, 4), enemyW2Img, 75, 200, 5, 2, 2));
      }
    }
  } else if (currentWave <= 14) {
    // Mix of EnemyW2 and EnemyW3
    for (int i = 0; i < enemiesPerWave; i++) {
      float spawnChance = random(1);
      if (spawnChance < 0.4) { // 40% chance for EnemyW2
        enemies.add(new EnemiesW1(random(10, width - 110), -random(50, 500), random(2, 4), enemyW2Img, 75, 200, 5, 2, 2));
      } else if (spawnChance < 0.7) { // 30% chance for EnemyW3
        enemies.add(new EnemyW3(random(10, width - 110), -random(50, 500), random(3, 5), enemyW3Img, 100, 300, 10, 3, 3));
      } else { // 30% chance for Tanks
        enemies.add(new EnemyTank(random(10, width - 110), -random(50, 500), EnemyTankImg));
      }
    }
  }else if (currentWave == 15) { // Boss Wave
  // Boss: (startX, startY, speed, image, size, SCORE, COINS, DAMAGE, HEALTH)
  enemies.add(new BossEnemy(width / 2 - (enemyBossImg.width / 2), -300, 0.5, enemyBossImg, 200, 5000, 100, 5, 20)); // High health boss
  println("BOSS WAVE! Prepare for battle!");
}
}


// ================================================================================
// PLAYER INPUT
// ================================================================================

void keyPressed() {
  if (isPlaying) { // Only process these inputs if the game is playing
    if (key == 'a' || key == 'A') {
      leftPressed = true;
    } else if (key == 'd' || key == 'D') {
      rightPressed = true;
    } else if (key == ' ') { // Player shooting
      if (millis() - lastPlayerShotTime > playerFireRate) {
        // Create new bullet at player position
        float bulletX = playerX + playerImg.width / 2;
        float bulletY = 690;
        playerBullets.add(new PlayerBullet(bulletX, bulletY, -20));
        lastPlayerShotTime = millis();
      }
    }

    // Upgrade logic for keys '1', '2', '3', '4', '5' - these are now part of the 'isPlaying' block
    else if (key == '1') { // Upgrade Health
      if (upgrade_PlayerMaxHealth < MAX_HEALTH_LEVEL && Coins >= HEALTH_UPGRADE_COST) {
        Coins -= HEALTH_UPGRADE_COST;
        upgrade_PlayerMaxHealth++;
        applyAllUpgrades(); // Reapply all upgrades to update stats
        Heal(1); // Give a little health boost too
        println("Health Upgraded! Level: " + upgrade_PlayerMaxHealth);
      } else if (upgrade_PlayerMaxHealth >= MAX_HEALTH_LEVEL) {
        println("Health is already max level!");
      } else {
        println("Not enough coins for Health upgrade! Need " + HEALTH_UPGRADE_COST + " coins.");
      }
    } else if (key == '2') { // Upgrade Speed
      if (upgrade_PlayerSpeed < MAX_SPEED_LEVEL && Coins >= SPEED_UPGRADE_COST) {
        Coins -= SPEED_UPGRADE_COST;
        upgrade_PlayerSpeed++;
        applyAllUpgrades();
        println("Speed Upgraded! Level: " + upgrade_PlayerSpeed);
      } else if (upgrade_PlayerSpeed >= MAX_SPEED_LEVEL) {
        println("Speed is already max level!");
      } else {
        println("Not enough coins for Speed upgrade! Need " + SPEED_UPGRADE_COST + " coins.");
      }
    } else if (key == '3') { // Upgrade Damage
      if (upgrade_BulletDamage < MAX_DAMAGE_LEVEL && Coins >= DAMAGE_UPGRADE_COST) {
        Coins -= DAMAGE_UPGRADE_COST;
        upgrade_BulletDamage++;
        applyAllUpgrades();
        println("Damage Upgraded! Level: " + upgrade_BulletDamage);
      } else if (upgrade_BulletDamage >= MAX_DAMAGE_LEVEL) {
        println("Damage is already max level!");
      } else {
        println("Not enough coins for Damage upgrade! Need " + DAMAGE_UPGRADE_COST + " coins.");
      }
    } else if (key == '4') { // Upgrade Fire Rate
      if (upgrade_FireRate < MAX_FIRERATE_LEVEL && Coins >= FIRERATE_UPGRADE_COST) {
        Coins -= FIRERATE_UPGRADE_COST;
        upgrade_FireRate++;
        applyAllUpgrades();
        println("Fire Rate Upgraded! Level: " + upgrade_FireRate);
      } else if (upgrade_FireRate >= MAX_FIRERATE_LEVEL) {
        println("Fire Rate is already max level!");
      } else {
        println("Not enough coins for Fire Rate upgrade! Need " + FIRERATE_UPGRADE_COST + " coins.");
      }
    } else if (key == '5') { // Upgrade Coin Multiplier
      if (upgrade_CoinsDrops < MAX_COINSDROPS_LEVEL && Coins >= COINSDROPS_UPGRADE_COST) {
        Coins -= COINSDROPS_UPGRADE_COST;
        upgrade_CoinsDrops++;
        applyAllUpgrades(); // Reapply all upgrades to update the coin multiplier
        println("Coin Multiplier Upgraded! Level: " + upgrade_CoinsDrops);
      } else if (upgrade_CoinsDrops >= MAX_COINSDROPS_LEVEL) {
        println("Coin Multiplier is already max level!");
      } else {
        println("Not enough coins for Coin Multiplier upgrade! Need " + COINSDROPS_UPGRADE_COST + " coins.");
      }
    } else if (key == 's' || key == 'S') {
      saveGame();
      println("Game Saved!");
    }
  } else if (isGameOver || isWinScreen) { // If game is over or won, only 'R' works
    if (key == 'r' || key == 'R') {
      resetGame();
    }
  }
}


void keyReleased() {
  if (isPlaying) { // Only works if the game is playing
    if (key == 'a' || key == 'A') {
      leftPressed = false;
    } else if (key == 'd' || key == 'D') {
      rightPressed = false;
    }
  }
}

void updatePlayerMovement() {
  if (leftPressed) {
    playerX -= playerSpeed;
  }
  if (rightPressed) {
    playerX += playerSpeed;
  }
  playerX = constrain(playerX, 0, width - playerImg.width);
}


// ================================================================================
// CLASSES
// ================================================================================

// Base Enemy Class
class EnemiesW1 {
  float x;
  float y;
  float speed;
  PImage img;
  boolean active;
  float size; // This parameter is for general sizing, actual image size is from PImage
  int scoreValue;
  int coinValue;
  int damageDealt; // Damage dealt to player
  int healthValue; // Enemy's own health

  //Constructor
  EnemiesW1(float startX, float startY, float enemySpeed, PImage enemyImage, float enemySize, int score, int coins, int damage, int health) {
    x = startX;
    y = startY;
    speed = enemySpeed;
    img = enemyImage;
    active = true;
    size = enemySize;
    scoreValue = score;
    coinValue = coins;
    damageDealt = damage;
    healthValue = health;
  }


  void update() {
    if (active) {
      y += speed;
    }
  }

  void display() {
    if (active) {
      // Draws image at its current loaded/resized dimensions
      image(img, x, y);
    }
  }

  boolean isOffScreen() {
    return y > height;
  }

  void reset(float newX, float newY) {
    x = newX;
    y = newY;
    active = true;
    if (img == enemyW1Img) healthValue = 1;
    else if (img == enemyW2Img) healthValue = 2;
    else if (img == enemyW3Img) healthValue = 3;
  }
}

// EnemyW3 Class (Extends EnemiesW1 for shootig and different movement)
class EnemyW3 extends EnemiesW1 {
  long lastShotTime;
  long shootCooldown = 1500; // 1.5 seconds cooldown

  EnemyW3(float startX, float startY, float enemySpeed, PImage enemyImage, float enemySize, int score, int coins, int damage, int health) {
    super(startX, startY, enemySpeed, enemyImage, enemySize, score, coins, damage, health);
    lastShotTime = millis();
  }

  @Override
    void update() {
    // Unique zigzag(sinuosidal) movement for EnemyW3
    x += sin(frameCount * 0.08) * 3;
    y += speed;
    x = constrain(x, 0, width - img.width);

    // Shooting Logic for EnemyW3
    if (active && millis() - lastShotTime > shootCooldown) {
      // Shoot from bottom-center of W3
      spawnEnemyProjectile(x + img.width / 2, y + img.height, 3, 10, 1); // Speed 3, size 10, damage 1
      lastShotTime = millis();
    }
  }

  @Override
    void reset(float newX, float newY) {
    super.reset(newX, newY);
    healthValue = 3; // Ensure W3 health resets
    lastShotTime = millis(); // Reset shot timer when enemy resets
  }
}

// BossEnemy Class Zigzag and shooting
class BossEnemy extends EnemiesW1 {
  long lastBossAttackTime;
  long bossAttackCooldown = 1000; // 1 seconds between boss attacks
  int initialHealth; // Store initial health to reset

  BossEnemy(float startX, float startY, float enemySpeed, PImage enemyImage, float enemySize, int score, int coins, int damage, int health) {
    super(startX, startY, enemySpeed, enemyImage, enemySize, score, coins, damage, health);
    initialHealth = health
      ; // Save initial health for reset
    lastBossAttackTime = millis();
  }

  @Override
    void update() {
    if (y < height/4) { // Descend to a certain point
      y += 5;
    } else { // Then move side to side
      x += sin(frameCount * 0.03) * 2;
      x = constrain(x, 0, width - img.width);
    }

    // Boss Attack Logic
    if (active && millis() - lastBossAttackTime > bossAttackCooldown) {
      // Example: Boss shoots multiple projectiles
      spawnEnemyProjectile(x + img.width / 4, y + img.height, 7, 12, 2); // Left shot
      spawnEnemyProjectile(x + img.width / 2, y + img.height, 7, 12, 2); // Middle shot
      spawnEnemyProjectile(x + img.width * 3 / 4, y + img.height, 7, 12, 2); // Right shot
      lastBossAttackTime = millis();
    }
  }

  @Override
    void reset(float newX, float newY) {
    super.reset(newX, newY);
    healthValue = initialHealth; // Boss resets with full health
    lastBossAttackTime = millis();
  }
}
class EnemyTank extends EnemiesW1 {

  EnemyTank(float startX, float startY, PImage enemyImage) {
    super(startX, startY, 1, enemyImage, 100, 500, 20, 3, 10);
  }
}

// Enemy Projectile Class
class EnemyProjectile {
  float x;
  float y;
  float speed;
  float size;
  boolean active;
  int damageDealt;

  EnemyProjectile(float startX, float startY, float projectileSpeed, float projectileSize, int damage) {
    x = startX;
    y = startY;
    speed = projectileSpeed;
    size = projectileSize;
    active = true;
    damageDealt = damage;
  }

  void update() {
    if (active) {
      y += speed; // Enemy projectiles move downwards
      if (y > height) {
        active = false; // Deactivate if off screen
      }
    }
  }

  void display() {
    if (active) {
      fill(255, 0, 0); // Red bullets
      noStroke();
      ellipse(x, y, size, size);
    }
  }

  boolean collidesWithPlayer(float playerX, float playerY, float playerWidth, float playerHeight) {
    if (!active) return false;

    // Simple circular-rectangular collision
    float projectileRadius = size / 2;
    float closestX = constrain(x, playerX, playerX + playerWidth);
    float closestY = constrain(y, playerY, playerY + playerHeight);

    float distanceX = x - closestX;
    float distanceY = y - closestY;

    float distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
    return distanceSquared < (projectileRadius * projectileRadius);
  }
}

// PowerUp Class
class PowerUp {
  float x;
  float y;
  float speed;
  float size;
  boolean active;
  String type;
  PImage img;

  PowerUp(float startX, float startY, float powerUpSpeed, float powerUpSize, String powerUpType, PImage powerUpImage) {
    x = startX;
    y = startY;
    speed = powerUpSpeed;
    size = powerUpSize;
    active = true;
    type = powerUpType;
    img = powerUpImage;
    if (img != null) { // Check if img is not null before resizing
      img.resize((int)size, (int)size); // Resize power-up image to its size
    }
  }

  void update() { // for powerup class
    if (active) {
      y += speed; // Power-ups move downwards
      if (y > height) {
        active = false; // Deactivate if off screen
      }
    }
  }

  void display() { // for PowerUp class
    if (active) {
      if (img != null) { // Only draw image if it's not null
        image(img, x - size/2, y - size/2, size, size); // Draw image centered
      } else {
        // Fallback: draw a circle if image is missing
        fill(255, 255, 0, 150); // Yellow translucent circle
        ellipse(x, y, size, size);
      }
    }
  }

  boolean collidesWithPlayer(float playerX, float playerY, float playerWidth, float playerHeight) {
    if (!active) return false;

    // Simple circular-rectangular collision for power-up
    float powerUpRadius = size / 2;
    float closestX = constrain(x, playerX, playerX + playerWidth);
    float closestY = constrain(y, playerY, playerY + playerHeight);

    float distanceX = x - closestX;
    float distanceY = y - closestY;

    float distanceSquared = (distanceX * distanceX) + (distanceY * distanceY);
    return distanceSquared < (powerUpRadius * powerUpRadius);
  }
}
class PlayerBullet {
  float x;
  float y;
  float speed;
  boolean active;

  PlayerBullet(float startX, float startY, float bulletSpeed) {
    x = startX;
    y = startY;
    speed = bulletSpeed;
    active = true;
  }
  void update() {
    if (active) {
      y += speed;
      if (y < 0) {
        active = false;
      }
    }
  }
  void display() {
    if (active) {
      drawEnergyBall(x, y);
    }
  }
}

// ================================================================================
// SAVE/LOAD FUNCTIONS
// ================================================================================

void saveGame() {
  JSONObject saveFile = new JSONObject();
  //saveFile.setInt("highScore", highScore);
  saveFile.setInt("Coins", Coins);
  saveFile.setInt("upgrade_PlayerMaxHealth", upgrade_PlayerMaxHealth);
  saveFile.setInt("upgrade_PlayerSpeed", upgrade_PlayerSpeed);
  saveFile.setInt("upgrade_BulletDamage", upgrade_BulletDamage);
  saveFile.setInt("upgrade_FireRate", upgrade_FireRate);
  saveFile.setInt("upgrade_CoinsDrops", upgrade_CoinsDrops);

  saveJSONObject(saveFile, "data/savegame.json");
  println("Game Saved!");

  //Only highscore
  JSONObject highscoreData = new JSONObject();
  highscoreData.setInt("highScore", highScore);
  saveJSONObject(highscoreData, "data/highscore.json");
  println("HighScore saved too");
}

void loadGame() {
  File saveFile = new File(sketchPath("data/savegame.json"));
  if (saveFile.exists()) {
    JSONObject loadedData = loadJSONObject("data/savegame.json");
    if (loadedData != null) {
      //highScore = loadedData.getInt("highScore", 0); // 0 is default if not found
      Coins = loadedData.getInt("Coins", 0);
      upgrade_PlayerMaxHealth = loadedData.getInt("upgrade_PlayerMaxHealth", 0);
      upgrade_PlayerSpeed = loadedData.getInt("upgrade_PlayerSpeed", 0);
      upgrade_BulletDamage = loadedData.getInt("upgrade_BulletDamage", 0);
      upgrade_FireRate = loadedData.getInt("upgrade_FireRate", 0);
      upgrade_CoinsDrops = loadedData.getInt("upgrade_CoinsDrops", 0);

      println("Game loaded successfully!");
    } else {
      println("Error: Could not find savegame.json. Starting new game.");
    }
  } else {
    println("No save game found. Starting new game.");
  }
  File highscoreSaveFile = new File(sketchPath("data/highscore.json"));
  if (highscoreSaveFile.exists()) {
    JSONObject loadedHighscoreData = loadJSONObject("data/highscore.json");
    if (loadedHighscoreData != null) {
      highScore = loadedHighscoreData.getInt("highScore", 0); // 0 is default if not found
      println("High score loaded successfully!");
    } else {
      println("Error: Could not read highscore.json. High score set to 0.");
      highScore = 0; // Reset high score if file is corrupted
    }
  } else {
    println("No high score save found. High score set to 0.");
    highScore = 0; // If no high score file exists, start with 0
  }

  // Always apply upgrades after loading all relevant data
  applyAllUpgrades(); // Crucial: Reapply upgrades to update player stats based on loaded levels
}

//---------FINAL YAY---------
//Tried my best with shaders but didnt work
