Ball myBall;
void setup() {
  size(400, 400);
  background(0);
  myBall = new Ball(width/2, height/2);
}

void draw() {
  myBall.run();
}

class Ball {
  float x, y, vx, vy, mySize;
  Ball(float _x, float _y) {
    x = _x;
    y = _y;
    vx = random(-5, 5);
    vy = random(-5, 5);
    mySize = random(15, 50);
  }

  void run() {
    update();
    wiggle();
    borders();
    render();
  }
  void wiggle() {
    vx += random(-.1,.1);
    vy += random(-.1,.1);
  }


  void update() {
    x += vx;
    y += vy;
  }

  void borders() {
    if (x > width) {
      vx = -vx;
      x = width;
    }
    if (x < 0) {
      vx = -vx;
      x = 0;
    }
    if (y > height) {
      vy = -vy;
      y = height;
    }
    if (y < 0) {
      vy = -vy;
      y = 0;
    }
  }

  void render() {
    ellipse(x, y, mySize, mySize);
  }
}