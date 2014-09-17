package
{
	import flash.display.Sprite;
	
	import util.Color;
	import util.GlobalContext;

	public class RewardPoint extends Sprite
	{
		public var type:int;
		
		public function RewardPoint()
		{
			if(instance)
				throw new Error("RewardPoint is singleton class and allready exists!");
			instance = this;
			
			this.graphics.beginFill(Color.PURPLE);
			this.graphics.drawCircle(0, 0, 10);
			this.graphics.endFill();
		}
		/** 单例*/
		private static var instance:RewardPoint;
		/** 获取单例*/
		public static function getInstance():RewardPoint
		{
			if(!instance)
				instance = new RewardPoint();
			
			return instance;
		}	
		
		public static function show(b:Boolean, x:Number = 0, y:Number = 0):void
		{
			getInstance().show(b, x, y);
		}
		
		private function show(b:Boolean, x:Number = 0, y:Number = 0):void
		{
			if(b)
			{
				if(!this.parent)
				{
					GlobalContext.gameLayers.sceneLayer.addChild(this);
					this.x = x;
					this.y = y;
					type = Math.random() * 2;
				}
			}
			else
			{
				if(this.parent)
					this.parent.removeChild(this);
			}
		}
		
	}
}