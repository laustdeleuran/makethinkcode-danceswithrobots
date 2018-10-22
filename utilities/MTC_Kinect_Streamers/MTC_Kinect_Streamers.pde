///use skeleton tracking, create arraylist of PVectors where hand has traveled
///streamer class - update skeleton joint, keep track, render
///make older points thinner or less opaque
///figure out how to position camera

import KinectPV2.KJoint;
import KinectPV2.*;
float PARTICLE_LIMIT = 150;
float MAX_STROKEWEIGHT  = 15;
KinectPV2 kinect;
Streamer myStreamerLeft;
Streamer myStreamerRight;
Streamer footLeft;
Streamer footRight;

void setup() {
  fullScreen(P3D);
  background(0);
  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);

  kinect.enableSkeletonColorMap(true);
  kinect.init();

  myStreamerRight = new Streamer(KinectPV2.JointType_HandRight, 0, 0, 0);
  myStreamerLeft = new Streamer(KinectPV2.JointType_HandLeft, 0, 0, 0);
  footLeft = new Streamer(KinectPV2.JointType_AnkleLeft, 0, 0, 0);
  footRight = new Streamer(KinectPV2.JointType_AnkleRight, 0, 0, 0);
}


void draw() {
  background(0);

  image(kinect.getColorImage(), 0, 0, 320, 240);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  if (skeletonArray.size()>0) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(0);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      myStreamerLeft.run(joints);
      myStreamerRight.run(joints);
      footLeft.run(joints);
      footRight.run(joints);
    }
  }
}

class Streamer {
  PVector position;
  ArrayList<PVector> prevpos; 
  int index;
  //arraylist, set a limit, PVectors of past positions, current pos PVector, index
  Streamer(int _index, float x, float y, float z) {
    prevpos = new ArrayList();
    position = new PVector(x, y, z);
    prevpos.add(position);
    index = _index;
    //example index on construction KinectPV2.JointType_HandTipLeft
  }
  void run(KJoint[] joints) {
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

    noFill();
    beginShape();
    for (int i=0; i<prevpos.size()-1; i++) {

      PVector prev1 = prevpos.get(i);
      PVector prev2 = prevpos.get(i+1);
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


    //pushMatrix();
    //translate(position.x, position.y, position.z);
    //println(position);
    //fill(255, 0, 0);
    //ellipse(0, 0, 25, 25);
    //popMatrix();
  }
}