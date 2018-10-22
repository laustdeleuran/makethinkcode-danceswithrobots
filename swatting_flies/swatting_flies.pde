
/**
 * Instantiate globals
 */
import SimpleOpenNI.*;
SimpleOpenNI kinect;


class Particle {
  float r;
  PVector p, v;
  color clr;
  float previous_reading;
  color excited = color(#4BEEFF);
  
  Particle(float _x, float _y, float _r, color _clr) {
    r = _r;

    p = new PVector(_x, _y);
    v = PVector.random2D();
    clr = _clr;
  }

  void run(PImage map) {
    float current_reading = getDepth(map, p.x, p.y);
    float diff = abs(previous_reading - current_reading);
    if(diff > 150){
      v.setMag(10);
    }
    
    move();
    render();
    previous_reading = current_reading;
  }
  
  void render() {
    float mag = v.mag();
    float radius = r;
    color nc = clr;
    
    if (mag > 2) {
      radius *= mag * 0.5;
      nc = lerpColor(clr, excited, map(mag, 0, 10, 0, 1));
    }
    
    ellipse(p.x, p.y, radius, radius);
    noStroke();
    fill(nc);
  }

  void move() {
    p.add(v);
    PVector rv = PVector.random2D();
    rv.mult(random(1));

    v.add(rv);
    v.mult(.85);
  }
}


/**
 * @setup
 */
ArrayList<Particle> particles;

void setup() {
  size(1280, 720);

  kinect = new SimpleOpenNI(this);
  if (kinect.isInit() == false) {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!");
    exit();
    return;
  }

  // Mirror kinect
  kinect.setMirror(true);

  // enable depthMap generation
  kinect.enableDepth();

  // enable skeleton generation for all joints
  kinect.enableUser();

  // Set up anti-aliasing on all geometry
  smooth();
  particles = new ArrayList();
  for (int p = 0; p < 1000; p++) {
    particles.add(new Particle(random(0, width), random(0, height), random(1, 5), color(255, 255, 255)));
  }
}

/**
 * Get depth
 */
float getDepth(PImage map, float x, float y) {
  float mx, my;
  mx = map(x, 0, width, 0, map.width);
  my = map(y, 0, height, 0, map.height);
  int index = floor(mx);
  index += floor(my) * map.width;
  index = constrain(index, 0, map.pixels.length - 1);
  return brightness(map.pixels[index]);
}




/**
 * @draw
 */
void draw () {
  //background(0);
  noStroke();
  fill( 0x00, 0x00, 0x00, 30);
  rect(0, 0, width, height);

  // Update the camera
  kinect.update();
  PImage map = kinect.depthImage();

  //image(kinect.depthImage(), 0, 0);
  //image(kinect.userImage(), 0, 0);
  //image(kinect.depthImage(), 0, 0, width, height);
  text(getDepth(map, mouseX, mouseY), mouseX, mouseY);

  for (int p = 0; p < particles.size(); p++) {
    Particle particle = particles.get(p);
    particle.run(map);
  }
  //for(int w = 0; w < width; w += 20) {
  //  for(int h = 0; h < width; h += 20) {
  //    float r = map(brightness(getDepth(map, w, h)), 0, 255, 1, 25);
  //    ellipse(w, h, r, r);
  //    fill(255);
  //  }
  //}
}
