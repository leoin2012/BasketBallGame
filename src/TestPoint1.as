package
{
	import flash.display.Sprite;
	
	import util.Color;

	public class TestPoint1 extends Sprite
	{
		public function TestPoint1()
		{
			this.graphics.lineStyle(1,Color.RED, 0);
			this.graphics.drawCircle(0,0,1);
			this.graphics.endFill();
		}
	}
}