package
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import util.Reflection;

	public class Net extends MovieClip
	{
		private var _mc:MovieClip;
		
		public var netPoints:Array = [new Point(15,15), new Point(22, 15), new Point(30, 15), new Point(37, 15), new Point(45, 15), new Point(52, 15), new Point(60, 15),
									new Point(15,25), new Point(22, 25), new Point(30, 25), new Point(37, 25), new Point(45, 25), new Point(52, 25), new Point(60, 25),
									new Point(30, 35), new Point(45, 35),
									new Point(30, 45), new Point(45, 45),
									new Point(30, 55), new Point(45, 55),];
		
		public var frontRimPoint:TestPoint1 = new TestPoint1();
		
		public var backRimPoint:TestPoint1 = new TestPoint1();
		
		public var scorePoints:Array = [];
		
		public function Net()
		{
			addChild(_mc = Reflection.createInstance("net"));
			addChild(frontRimPoint);
			frontRimPoint.x = 1;
			frontRimPoint.y = 2;
			
			addChild(backRimPoint);
			backRimPoint.x = 75;
			backRimPoint.y = 2;
			
			var scorePoint1:TestPoint1 = new TestPoint1();
			addChild(scorePoint1);
			scorePoint1.x = 30;
			scorePoint1.y = 15;
			scorePoints[scorePoints.length] = scorePoint1;
			
			var scorePoint2:TestPoint1 = new TestPoint1();
			addChild(scorePoint2);
			scorePoint2.x = 50;
			scorePoint2.y = 15;
			scorePoints[scorePoints.length] = scorePoint2;
		}
		
		override public function gotoAndPlay(frame:Object, scene:String=null):void
		{
			_mc.gotoAndPlay(frame, scene);
		}

	}
}