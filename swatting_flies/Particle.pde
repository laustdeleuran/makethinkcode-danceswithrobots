
/** 
 * Basic particle 
 * A particle has a position and a velocity as well as a base radius and color. 
 */
class Particle {
  float r;
  PVector p, v;
  color clr;
  float previous_depth;
  color excited_clr;
  
  // Constructor. Takes settings and assings them to this instance.
  Particle(float _x, float _y, float _r, color _clr, color _excited_clr) {
    r = _r;
    p = new PVector(_x, _y);
    v = PVector.random2D(); // Set a random vector as the start velocity
    clr = _clr;
    excited_clr = _excited_clr;
  }

  // Run. Utility level function that helps us just run one function from our 
  // draw() instance. 
  void run(PImage map) {
    check_excitement(map);
    move();
    render();
  }
  
  // Check excitement. Check if the particle's center went through a  big change 
  // from the last depth it encountered
  void check_excitement(PImage map) {
    float current_depth = getDepth(map, p.x, p.y);
    if(abs(previous_depth - current_depth) > 150){
      v.setMag(10);
    }
    previous_depth = current_depth;
  }
  
  // Draws the particle. If the particle is moving fast, we linearly 
  // interpolate between the particles base color and its excited color 
  // based on how fast it's moving.
  void render() {
    float mag = v.mag();
    float radius = r;
    color _clr = clr;
    
    // LERP color if we're moving fast
    if (mag > 2) {
      radius *= mag * 0.5;
      _clr = lerpColor(clr, excited_clr, map(mag, 0, 10, 0, 1));
    }
    
    // Draw the particle
    ellipse(p.x, p.y, radius, radius);
    noStroke();
    fill(_clr);
  }

  // Move the particles center by adding the velocity. Velocity decays by a set 
  // percentage over time and we add a little bit of random movement.
  void move() {
    // Add current velocity to position 
    p.add(v);
    
    // Add random movement
    PVector rv = PVector.random2D();
    rv.mult(random(1));
    v.add(rv);
    
    // Decay velocity
    v.mult(.85);
  }
}
