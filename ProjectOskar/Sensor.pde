import KinectPV2.KJoint;
import KinectPV2.*;

class Sensor {
	KinectPV2 kinect;
	PVector user;
	PVector calculatedPosition;
	int pointToTrack;
	float zVal;
	float rotX;
	float front, back, left, right;
	float stageWidth, stageDepth;

	public Sensor {
		kinect = new KinectPV2(this);
		kinect.enableColorImg(true);
		kinect.enableSkeleton3DMap(true);
		kinect.init();
		setup();
		calculatePosition();
	}

	void setup() {
		user = new PVector(0.35673147, -0.3516358, 1.5335494);
		calculatedPosition = new PVector(0, 0, 0);
		pointToTrack = KinectPV2.JointType_Neck;
		zVal = 300;
		rotX = PI;
		front = 1.4171512;
		back = 4.0312815;
		left = -1.0130917;
		right = 1.1453663;
		stageWidth = 255;
		stageDepth = 255;
	}

	void trackUser() {
		ArrayList<KSkeleton> skeletonArray = kinect.getSkeleton3d();
		for(int i = 0; i < skeletonArray.size(); i++) {
			KSkeleton skeleton = (KSkeleton)skeletonArray.get(i);
			if(skeleton.isTracked()) {
				KJoint[] joints = skeleton.getJoints();
				user = new PVector(joints[pointToTrack].getX(), joints[pointToTrack].getY(), joints[pointToTrack].getZ());
				calculatePosition();
			}
		}
	}

	void calculatePosition() {
		float x = map(user.x, left, right, 0, stageWidth);
		float y = map(user.z, front, back, 0, stageDepth);
		float z = 0;
		calculatedPosition = new PVector(x, y, z);
	}

	PVector getPosition() {
		return calculatedPosition;
	}
}