int HP_BAR_WIDTH = 30;
int HP_MAX = 10;
int BAR_BUFFER = 20;
int PADDLE_WIDTH = 30;
int PADDLE_HEIGHT = 82;
int PADDLE_SPEED = 5;

class Game {
  Player players[] = new Player[2];
  
  int BULLET_SPEED = 5;
  int SHOOT_INTERVAL = 2000; // ms
  
  int nextShootTime;
  
//  int winCount = 0;
//  int winnerId = 1;

  int winMs = -1;
  int winnerId;
  
  int startMs;
  
  void setup() {
    players[0] = new Player(0, "A", #FF0000, true);
    players[1] = new Player(1, "B", #0000FF, false);
    
    startMs = millis();
    link.output(4, "start");
    link.output(6, 1);
  }
  
  void draw() {
    int ms = millis();
    
    if (winMs >= 0) {
      int msElapsed = ms - winMs;
      if (msElapsed >= 5000) {
        gameOn = false;
        setup();
      } else {
        image(winnerImage[winnerId], 0, 0);
      }
      
      return;
    }
    
    int msElapsed = ms - startMs;
    
    if (msElapsed > 30000) {
      BULLET_SPEED = 20;
      SHOOT_INTERVAL = 500;
      link.output(6, 4);
    } else if (msElapsed > 20000) {
      BULLET_SPEED = 15;
      SHOOT_INTERVAL = 1000;
      link.output(6, 3);
    } else if (msElapsed > 10000) {
      BULLET_SPEED = 10;
      SHOOT_INTERVAL = 1500;
      link.output(6, 2);
    }
    
println("speed " + BULLET_SPEED + " interval " + SHOOT_INTERVAL);
    
    if (!gameOn) {
      if (players[0].y < 50 && players[1].y < 50) {
        gameOn = true;
        players[0].nextShootTime = ms;
        players[1].nextShootTime = ms + (SHOOT_INTERVAL / 2);
      }
    }
    
    if (!gameOn) {
      imageMode(CENTER);
      image(title, 400, 300, 350, 171);
      imageMode(CORNER);
      image(subtitle, 0, height-45);
    }
    
    if (gameOn) {
      // if it's time, shoot a new object from player 1/2
      for (int i = 0; i < 2; i++) {
        if (ms >= players[i].nextShootTime) {
          players[i].nextShootTime += SHOOT_INTERVAL;
          players[i].shootBullet();
        }
      }
    }
  
    if (gameOn) {
      // draw bullets
      for (int i = 0; i < 2; i++) {      
        ArrayList destroy = new ArrayList();
        
        for (int j = 0; j < players[i].bullets.size(); j++) {
          Bullet bullet = (Bullet) players[i].bullets.get(j);
          
          // increment bullets
          bullet.move();
          
          if ((bullet.speed > 0 && bullet.x >= width - HP_BAR_WIDTH) || (bullet.speed < 0 && bullet.x <= HP_BAR_WIDTH)) {
            // it hits the HP bar
            players[1-i].hit();
            destroy.add(bullet);
          } else {
            // draw bullets
            bullet.draw();
          }
        }
        
        for (int j = 0; j < destroy.size(); j++) {
          Bullet bullet = (Bullet) destroy.get(j);
          boolean done = players[i].bullets.remove(bullet);
        }
      }
    }
    
    
    // draw player 1 HP
    // draw player 2 HP
    if (gameOn) {
      for (int i = 0; i < 2; i++) {
        players[i].drawHP();
      }
    }

    // draw player 1 block
    // draw player 2 block
    for (int i = 0; i < 2; i++) {
      players[i].drawPaddle();
    }
  }
  
  void keyPressed() {
    switch (key) {
    case 'q':
    case 'Q':
      players[0].up();
      break;
      
    case 'a':
    case 'A':
      players[0].down();
      break;
      
    case 'o':
    case 'O':
      players[1].up();
      break;
      
    case 'l':
    case 'L':
      players[1].down();
      break;
    }
  }
  
  void gameOver() {
    winMs = millis();
    link.output(5, "victory");
  }
}
