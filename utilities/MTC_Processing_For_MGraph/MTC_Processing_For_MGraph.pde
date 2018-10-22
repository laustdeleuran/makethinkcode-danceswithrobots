PVector position, velocity;
float my_size = 25;
float friction = .99;
float elasticity =.9;
void  setup() {
  size(800, 800);
  background(255);
  //frameRate(5);
  position = new PVector(0, 0);
  velocity = new PVector(15, 0);
}

void draw() {
  background(0);
  update();
  check_borders();
  render();
}


void render() {
  stroke(255);
  fill(2555);
  ellipse(position.x, position.y, my_size, my_size);
  
  line(position.x,position.y,position.x+velocity.x*10,position.y+velocity.y*10);
}


void update() {
  PVector mouse = new PVector(mouseX, mouseY);
  mouse.sub(position);
  mouse.mult(.001);
  mouse.y += .1;
  velocity.add(mouse);
  
  velocity.mult(friction);
  position.add(velocity);
}

void check_borders() {
  if (position.x > width) {
    position.x = width;
    velocity.x *= -1;
    velocity.x *= elasticity;
  }
  if (position.x < 0) {
    position.x = 0;
    velocity.x *= -1;
    velocity.x *= elasticity;
  }
  if (position.y > height) {
    position.y = height;
    velocity.y *= -1;
    velocity.y *= elasticity;
  }
  if (position.y < 0) {
    position.y =0;
    velocity.y *= -1;
    velocity.y *= elasticity;
  }
}