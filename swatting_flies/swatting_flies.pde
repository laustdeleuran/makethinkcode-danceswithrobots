/**
 * Instantiate globals
 */
import SimpleOpenNI.*;
SimpleOpenNI kinect;

ArrayList<Particle> particles;



/**
 * @setup
 * Is run once before animation. Perfect for setting up class instances and settings. 
 */
void setup() {
  // Set the size of our canvas. 
  size(1280, 720); 

  // Set up the connection to the kinect
  kinect = new SimpleOpenNI(this);
  if (kinect.isInit() == false) {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!");
    exit();
    return;
  }

  // Mirror kinect image, assuming that the kinect's position will be kinda like a selfie-camera's.  
  kinect.setMirror(true);

  // Enable depthMap generation
  kinect.enableDepth();

  // Enable skeleton generation for all joints
  // kinect.enableUser();

  // Set up anti-aliasing on all geometry
  smooth();
  
  // Generate particles with random start positions.
  particles = new ArrayList();
  for (int p = 0; p < 1000; p++) {
    particles.add(new Particle(random(0, width), random(0, height), random(1, 5), color(255, 255, 255), color(158, 229, 250));
  }
}



/**
 * @draw
 */
void draw () {
  // Clear canvas every frame - By adding a semi-transparent rectangular fill we get faint trails depending on the opacity
  // background(0);
  noStroke();
  fill( 0x00, 0x00, 0x00, 30);
  rect(0, 0, width, height);

  // Update the camera and get the depth map
  kinect.update();
  PImage map = kinect.depthImage();

  for (int p = 0; p < particles.size(); p++) {
    Particle particle = particles.get(p);
    particle.run(map);
  }
  
  // Debug helpers
  //image(kinect.userImage(), 0, 0, width, height); // Output the user tracking image
  //image(kinect.depthImage(), 0, 0, width, height); // Output the depth map image
  //text(getDepth(map, mouseX, mouseY), mouseX, mouseY); // Output the perceived depth of the pixel that the cursor is hovering
}
