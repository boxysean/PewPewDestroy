class Player {
  int id;
  String name;
  int colour;
  int hp = HP_MAX;
  LinkedList bullets = new LinkedList();
  boolean sideLeft;
  float y;

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
      rect(HP_BAR_WIDTH + BAR_BUFFER, y - (PADDLE_HEIGHT/2), PADDLE_WIDTH, PADDLE_HEIGHT);
    } 
    else {
      rect(width - HP_BAR_WIDTH - PADDLE_WIDTH - BAR_BUFFER, y - (PADDLE_HEIGHT/2), PADDLE_WIDTH, PADDLE_HEIGHT);
    }
  }

  void drawHP() {
    noStroke();
    fill(#00FF00);

    float y = map(hp, 0, HP_MAX, height, 0);

    if (sideLeft) {
      rect(0, y, HP_BAR_WIDTH, height);
    } 
    else {
      rect(width - HP_BAR_WIDTH, y, width, height);
    }
  }

  void shootBullet() {
    int x = 0;
    int speed = BULLET_SPEED;

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

    //    // collision detect bullets, destroy if collided
    //    Iterator ii = game.players[1-id].bullets.descendingIterator();
    //    
    //    ArrayList destroy = new ArrayList();
    //    
    //    while (ii.hasNext()) {
    //      Bullet bullet = (Bullet) ii.next();
    //      
    //      float bx[] = new float[2];
    //      float by[] = new float[2];
    //      float px[] = new float[2];
    //      float py[] = new float[2];
    //      
    //      bx[0] = bullet.x - (BULLET_SIZE / 2.0f);
    //      by[0] = bullet.y - (BULLET_SIZE / 2.0f);
    //      bx[1] = bullet.x + (BULLET_SIZE / 2.0f);
    //      by[1] = bullet.y + (BULLET_SIZE / 2.0f);
    //      
    //      if (sideLeft) {
    //        px[0] = HP_BAR_WIDTH + BAR_BUFFER; 
    //        px[1] = HP_BAR_WIDTH + BAR_BUFFER + PADDLE_WIDTH; 
    //      } else {
    //        px[0] = width - (HP_BAR_WIDTH + BAR_BUFFER + PADDLE_WIDTH); 
    //        px[1] = width - (HP_BAR_WIDTH + BAR_BUFFER);
    //      }
    //      
    //      py[0] = y - (PADDLE_HEIGHT / 2.0);
    //      py[1] = y + (PADDLE_HEIGHT / 2.0);
    //      
    //      // bx[0], by[0]
    //      // bx[0], by[1]
    //      // bx[1], by[0]
    //      // bx[1], by[1]
    //      
    ////      for (int i = 0; i < 2; i++) {
    ////        for (int j = 0; j < 2; j++) {
    ////          if ((px[0] <= bx[i] && bx[i] <= px[1]) && (py[0] <= by[j] && by[j] <= py[1])) {
    ////            // collides, destroy bullet
    ////            destroy.add(bullet);
    ////          }
    ////        }
    ////      }
    //    }
    //    
    ////    for (int i = 0; i < destroy.size(); i++) {
    ////      bullets.remove(destroy.get(i));
    ////    }
  }

  void hit() {
    hp--;

    link.output(1, "hit"); // ** added for MaxLink
    link.output(2, id); // ** added for MaxLink
    link.output(3, hp); // ** added for MaxLink
    link.output(4, HP_MAX); // ** added for MaxLink
  }
}

