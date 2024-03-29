class Player {
  int id;
  String name;
  int colour;
  int hp = HP_MAX;
  LinkedList bullets = new LinkedList();
  boolean sideLeft;
  float y = height/2;
  int nextShootTime;

  Player(int id, String name, int colour, boolean sideLeft) {
    this.id = id;
    this.name = name;
    this.colour = colour;
    this.sideLeft = sideLeft;
  }

  void drawPaddle() {
    noStroke();
    fill(colour);

    if (sideLeft) {
      image(playerImage[id], HP_BAR_WIDTH + BAR_BUFFER, y - (PADDLE_HEIGHT/2));
//      rect(HP_BAR_WIDTH + BAR_BUFFER, y - (PADDLE_HEIGHT/2), PADDLE_WIDTH, PADDLE_HEIGHT);
    } 
    else {
      image(playerImage[id], width - HP_BAR_WIDTH - PADDLE_WIDTH - BAR_BUFFER, y - (PADDLE_HEIGHT/2));
//      rect(width - HP_BAR_WIDTH - PADDLE_WIDTH - BAR_BUFFER, y - (PADDLE_HEIGHT/2), PADDLE_WIDTH, PADDLE_HEIGHT);
    }
  }

  void drawHP() {
    noStroke();
    fill(#00FF00);

    float y = map(hp, 0, HP_MAX, glassHP[id].height, 0);

    if (sideLeft) {
      image(barHP, -1, y+10, barHP.width, height-bottomHP[id].height - 10-y);
      image(bottomHP[id], -1, height-bottomHP[id].height - 10);
      image(glassHP[id], 0, 0);
      
//      rect(0, y, HP_BAR_WIDTH, height);
    } 
    else {
//      image(barHP, 0, 0);
//      image(barHP, width-bottomHP[id].width+1, 50);
//      image(barHP, width-bottomHP[id].width+1, height-bottomHP[id].height - y, barHP.width, y);
      
      image(barHP, width-bottomHP[id].width+1, y+10, barHP.width, height-bottomHP[id].height - 10-y);

      image(bottomHP[id], width-bottomHP[id].width+1, height-bottomHP[id].height - 10);
      image(glassHP[id], width-glassHP[id].width, 0);
//      rect(width - HP_BAR_WIDTH, y, width, height);
    }
  }

  void shootBullet() {
    int x = 0;
    int speed = game.BULLET_SPEED;

    if (sideLeft) {
      x = HP_BAR_WIDTH + BAR_BUFFER + PADDLE_WIDTH;
    } 
    else {
      x = width - (HP_BAR_WIDTH + BAR_BUFFER + PADDLE_WIDTH);
      speed *= -1;
    }

    Bullet bullet = new Bullet(x, y, speed, id);

    bullets.add(bullet);
  }

  void up() {
    y = max(y-PADDLE_SPEED, 0);
  }

  void down() {
    y = min(y+PADDLE_SPEED, height);
  }

  void moveTo(float y) {
    // update y
    this.y = y;
    
    // collision detect bullets, destroy if collided
    ListIterator ii = game.players[1-id].bullets.listIterator();
    
    ArrayList destroy = new ArrayList();
    
    int zz = 0;
    
    while (ii.hasNext()) {
      Bullet bullet = (Bullet) ii.next();
      
      float bx[] = new float[2];
      float by[] = new float[2];
      float px[] = new float[2];
      float py[] = new float[2];
      
      bx[0] = bullet.x - (BULLET_WIDTH / 2.0f);
      by[0] = bullet.y - (BULLET_HEIGHT / 2.0f);
      bx[1] = bullet.x + (BULLET_WIDTH / 2.0f);
      by[1] = bullet.y + (BULLET_HEIGHT / 2.0f);
      
      if (sideLeft) {
        px[0] = HP_BAR_WIDTH + BAR_BUFFER; 
        px[1] = HP_BAR_WIDTH + BAR_BUFFER + PADDLE_WIDTH; 
      } else {
        px[0] = width - (HP_BAR_WIDTH + BAR_BUFFER + PADDLE_WIDTH); 
        px[1] = width - (HP_BAR_WIDTH + BAR_BUFFER);
      }
      
      py[0] = this.y - (PADDLE_HEIGHT / 2.0);
      py[1] = this.y + (PADDLE_HEIGHT / 2.0);
      
      // bx[0], by[0]
      // bx[0], by[1]
      // bx[1], by[0]
      // bx[1], by[1]
      
      all: for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
          if ((px[0] <= bx[i] && bx[i] <= px[1]) && (py[0] <= by[j] && by[j] <= py[1])) {
            // collides, destroy bullet
            destroy.add(bullet);
            break all;
          }
        }
      }
    }
    
   
    for (int i = 0; i < destroy.size(); i++) {
      Bullet bullet = (Bullet) destroy.get(i);
      boolean done = game.players[1-id].bullets.remove(bullet);
      
      link.output(7, "block");
    }
  }

  void hit() {
    hp--;

    link.output(1, "hit");
    link.output(2, id);
    link.output(3, hp);
    
    if (hp <= 0) {
      game.gameOver();
      game.winnerId = 1-id;
    }
  }
}

