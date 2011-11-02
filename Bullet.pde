int BULLET_WIDTH = 41;
int BULLET_HEIGHT = 10;

int BULLET_NEXT_ID = 0;

class Bullet {  
  float x;
  float y;
  float speed;
  int playerId;
  
  int id;
  
  Bullet(float x, float y, float speed, int playerId) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.playerId = playerId;
    
    this.id = BULLET_NEXT_ID++;
  }
  
  void draw() {
    noStroke();
    fill(game.players[playerId].colour);
//    rect(x-(BULLET_WIDTH/2), y-(BULLET_HEIGHT/2), BULLET_WIDTH, BULLET_HEIGHT);
    image(bulletImage[playerId], x-(BULLET_WIDTH/2), y-(BULLET_HEIGHT/2));
  }
  
  void move() {
    if (playerId == 0) {
      x += game.BULLET_SPEED;
    } else {
      x -= game.BULLET_SPEED;
    }
  }
  
  boolean equals(Object o) {
    try {
      Bullet b = (Bullet) o;
      return b.id == id;
    } catch (Exception e) {
      return false;
    }
  }
}

