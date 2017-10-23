import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
  size(1028, 768, OPENGL);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser();
  kinect.setMirror(true);
  fill(255, 0, 0);
}

void draw() {
  kinect.update();
  background(255);

  translate(width / 2, height / 2, 0);
  rotateX(radians(180));

  // make User list
  IntVector userList = new IntVector();
  // 検出されたユーザーのリストをVectorへ書き込む
  kinect.getUsers(userList);

  if (userList.size() > 0) {
    int userId = userList.get(0);

    if (kinect.isTrackingSkeleton(userId)) {
      PVector position = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, position);

      PMatrix3D orientation = new PMatrix3D();
      float confidence = kinect.getJointOrientationSkeleton(userId, SimpleOpenNI.SKEL_TORSO, orientation);

      println(confidence);
      drawSkeleton(userId);

      pushMatrix();

      // TORSOの場所へ移動
      translate(position.x, position.y, position.z);

      applyMatrix(orientation);

      // axis x
      stroke(255, 0, 0);
      strokeWeight(3);
      line(0, 0, 0, 150, 0, 0);
      // axis y
      stroke(0, 255, 0);
      line(0, 0, 0, 0, 150, 0);
      // axis z
      stroke(0, 0, 255);
      line(0, 0, 0, 0, 0, 150);

      popMatrix();
    }
  }
}

void drawSkeleton(int userId) {
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
}

void drawLimb(int userId, int jointType1, int jointType2) {
    PVector jointPos1 = new PVector();
    PVector jointPos2 = new PVector();
    float confidence;

    confidence = kinect.getJointPositionSkeleton(userId, jointType1, jointPos1);
    confidence += kinect.getJointPositionSkeleton(userId, jointType2, jointPos2);

    stroke(100);
    strokeWeight(5);
    if(confidence > 1) {
      line(jointPos1.x, jointPos1.y, jointPos1.z, jointPos2.x, jointPos2.y, jointPos2.z);
    }
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}
