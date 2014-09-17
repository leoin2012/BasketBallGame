package
{
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import util.EventManager;
	import util.GlobalContext;
	
	/** 菜单 */
	public class Menu extends Sprite
	{
		/** 开始游戏 */
		private var _startBtn:Button;
		
		private var _panel:Sprite;
		
		public function Menu()
		{
			if(instance)
				throw new Error("Menu is singleton class and allready exists!");
			instance = this;
			
			configUI();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		/** 单例*/
		private static var instance:Menu;
		/** 获取单例*/
		public static function getInstance():Menu
		{
			if(!instance)
				instance = new Menu();
			
			return instance;
		}
		
		private function configUI():void
		{
			addChild(_panel = new Sprite());
			_panel.x = 350;
			_panel.y = 250;
			
			_startBtn = new Button();
			_startBtn.label = "开始游戏";
			_panel.addChild(_startBtn);
		}
		
		public function show(b:Boolean):void
		{
			if(b)
				GlobalContext.gameLayers.menuLayer.addChild(this);
			else
				if(this.parent && this.parent)
					this.parent.removeChild(this);
		}
		
		private function startGame(evt:MouseEvent):void
		{
			EventManager.getInstance().dispatchEvent(new Event(EventName.GAME_START));
		}
		
		private function startPractice(evt:MouseEvent):void
		{
			EventManager.getInstance().dispatchEvent(new Event(EventName.PRACTICE));
		}
		
		/** 当对象被addChild到舞台时触发 */
		private function onAddToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			//TODO
			_startBtn.addEventListener(MouseEvent.CLICK, startGame);
		}
		/** 当对象被removeChild时触发*/
		private function onRemoveFromStage(evt:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			//TODO
			_startBtn.removeEventListener(MouseEvent.CLICK, startGame);
		}
	}
}