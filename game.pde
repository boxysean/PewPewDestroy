int HP_BAR_WIDTH = 50;
int HP_MAX = 10;
int BAR_BUFFER = 10;
int PADDLE_WIDTH = 20;
int PADDLE_HEIGHT = 60;
int PADDLE_SPEED = 5;
int SHOOT_INTERVAL = 1000; // ms

class Game {
  Player players[] = new Player[2];
  
  int nextShootTime;
  
  void setup() {
    players[0] = new Player(0, "A", #FF0000, true);
    players[1] = new Player(1, "B", #0000FF, false);
    
    players[0].y = height/2;
    players[1].y = height/2;
    
    nextShootTime = millis() + SHOOT_INTERVAL;
  }
  
  void draw() {
//    background(#000000);
    
    // if it's time, shoot a new object from player 1/2
    if (millis() >= nextShootTime) {
      nextShootTime += SHOOT_INTERVAL;
      for (int i = 0; i < 2; i++) {
        players[i].shootBullet();
      }
    }
  
    // draw player 1 block
    // draw player 2 block
    // draw player 1 HP
    // draw player 2 HP
    for (int i = 0; i < 2; i++) {
      players[i].drawPaddle();
      players[i].drawHP();
      
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
        players[i].bullets.remove(bullet);
      }
    }
    
    // time to generate powerup
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
