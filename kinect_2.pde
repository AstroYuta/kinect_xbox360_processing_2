import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
  size(640, 480);

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();

  kinect.enableUser();
}

void draw() {
  kinect.update();
  PImage depth = kinect.depthImage();
  image(depth, 0, 0);

  // make User list
  IntVector userList = new IntVector();

  // 検出されたユーザーのリストをVectorへ書き込む
  kinect.getUsers(userList);

  if (userList.size() > 0) {
    int userId = userList.get(0);

    if (kinect.isTrackingSkeleton(userId)) {
      PVector rightHand = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, rightHand);

      PVector convertedRightHand = new PVector();
      kinect.convertRealWorldToProjective(rightHand, convertedRightHand);

      // 表示
      float ellipseSize = map(convertedRightHand.z, 700, 2500, 50, 1);
      float confidence = kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, rightHand);
      if(confidence > 0.5) {
      ellipse(convertedRightHand.x ,convertedRightHand.y, ellipseSize, ellipseSize);
      }
    }
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
