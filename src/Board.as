package
{
	import flash.display.Sprite;
	
	import util.Reflection;

	/** 篮板 */
	public class Board extends Sprite
	{
		private var _mc:Sprite;
		/** 左上角 */
		public var pointLU:TestPoint1;
		/** 左下角 */
		public var pointLD:TestPoint1;
		/** 右上角 */
		public var pointRU:TestPoint1;
		/** 右下角 */
		public var pointRD:TestPoint1;
		
		public static var LEFT:int = 1;
		public static var RIGHT:int = 9;
		public static var UP:int = 1;
		public static var DOWN:int = 129;
		
		public function Board()
		{
			addChild(_mc = Reflection.createInstance("board"));
			
			addChild(pointLU = new TestPoint1());
			pointLU.x = LEFT;
			pointLU.y = UP;
			
			addChild(pointLD = new TestPoint1());
			pointLD.x = LEFT;
			pointLD.y = DOWN;
			
			addChild(pointRU = new TestPoint1());
			pointRU.x = RIGHT;
			pointRU.y = UP;
			
			addChild(pointRD = new TestPoint1());
			pointRD.x = RIGHT;
			pointRD.y = DOWN;
		}
	}
}