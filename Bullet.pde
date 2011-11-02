int BULLET_SIZE = 15;
int BULLET_SPEED = 3;

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
    rect(x-(BULLET_SIZE/2), y-(BULLET_SIZE/2), BULLET_SIZE, BULLET_SIZE);
  }
  
  void move() {
    x += speed;
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

