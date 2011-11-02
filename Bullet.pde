int BULLET_SIZE = 15;
int BULLET_SPEED = 1;

class Bullet {
  float x;
  float y;
  float speed;
  int playerId;
  
  Bullet(float x, float y, float speed, int playerId) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.playerId = playerId;
  }
  
  void draw() {
    noStroke();
    fill(game.players[playerId].colour);
    rect(x-(BULLET_SIZE/2), y-(BULLET_SIZE/2), BULLET_SIZE, BULLET_SIZE);
  }
  
  void move() {
    x += speed;
  }
}

