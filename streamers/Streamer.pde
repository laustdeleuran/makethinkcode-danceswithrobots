
/**
 * @class
 * Streamer – creates a streamer at a given start position in 3D space. 
 */
 
class Streamer {
  // arraylist, set a limit, PVectors of past positions, current pos PVector, index
  PVector position;
  ArrayList<PVector> prevpos; 
  int index;
  
  // Constructor
  Streamer(int _index, float x, float y, float z) {
    prevpos = new ArrayList();
    position = new PVector(x, y, z);
    prevpos.add(position);
    index = _index; // example index on construction KinectPV2.JointType_HandTipLeft
  }
  
  // Run
  void run(KJoint[] joints) {
    move(joints);
    draw();
  }
  
  // Draw streamer line
  void draw() {
    noFill();
    beginShape();
    for (int i=0; i<prevpos.size()-1; i++) {
      PVector prev1 = prevpos.get(i);
      //PVector prev2 = prevpos.get(i+1);
      float a = map(i, 0, 15, 0, 1);
      a = constrain(a, 0, 1);
      strokeWeight(MAX_STROKEWEIGHT*a);
      colorMode(HSB);
      float RH = noise(frameCount*.05, i*.05);
      stroke(255*RH,255,180, 255*a);
      //line(prev1.x, prev1.y, prev1.z,prev2.x, prev2.y, prev2.z);
      curveVertex(prev1.x, prev1.y, prev1.z);
    }
    endShape();
  }
  
  // Add position onto our position list based on given joint
  void move(KJoint[] joints) {
    KJoint joint = joints[index];
    PVector jointPosition = new PVector(joint.getX(), joint.getY(), joint.getZ());
    //jointPosition.mult(100);
    PVector diff = jointPosition.copy();
    diff.sub(position);
    diff.mult(.2);
    position.add(diff);

    /* previous position adds new position & display all previous*/
    prevpos.add(position.copy());
    while (prevpos.size() > PARTICLE_LIMIT) {
      prevpos.remove(0);
    }
  }
}
