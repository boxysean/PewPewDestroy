int HP_BAR_WIDTH = 50;
int HP_MAX = 10;
int BAR_BUFFER = 10;
int PADDLE_WIDTH = 20;
int PADDLE_HEIGHT = 60;
int PADDLE_SPEED = 5;
int SHOOT_INTERVAL = 2000; // ms

class Game {
  Player players[] = new Player[2];
  
  int nextShootTime;
  
  void setup() {
    players[0] = new Player(0, "A", #FF0000, true);
    players[1] = new Player(1, "B", #0000FF, false);
    
    int ms = millis();
    
    players[0].nextShootTime = ms;
    players[1].nextShootTime = ms + (SHOOT_INTERVAL / 2);
  }
  
  void draw() {
    int ms = millis();
    
    // if it's time, shoot a new object from player 1/2
    for (int i = 0; i < 2; i++) {
      if (ms >= players[i].nextShootTime) {
        players[i].nextShootTime += SHOOT_INTERVAL;
        players[i].shootBullet();
      }
    }
  
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
    
    // draw player 1 HP
    // draw player 2 HP
    for (int i = 0; i < 2; i++) {
      players[i].drawHP();
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
}
