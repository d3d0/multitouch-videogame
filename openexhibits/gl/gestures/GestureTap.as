package gl.gestures
{

public class GestureTap extends Gesture_N_Finger_N_Tap
{
	
	override protected function initialize():void
	{
		super.initialize();
		
		pointCount = 1;
		pointExistences = 1;
	}
	
}

}