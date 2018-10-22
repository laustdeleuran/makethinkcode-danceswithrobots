/** 
 * @overview
 * use skeleton tracking, create arraylist of PVectors where hand has traveled
 * streamer class - update skeleton joint, keep track, render
 * make older points thinner or less opaque
 * figure out how to position camera
 */

/** 
 * Set up globals
 */
import KinectPV2.KJoint;
import KinectPV2.*;
float PARTICLE_LIMIT = 150;
float MAX_STROKEWEIGHT  = 15;
KinectPV2 kinect;
Streamer myStreamerLeft;
Streamer myStreamerRight;
Streamer footLeft;
Streamer footRight;



/**
 * @setup
 * Is run once before animation. Perfect for setting up class instances and settings. 
 */
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



/**
 * @draw
 */
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
