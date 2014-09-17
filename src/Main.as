package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import util.EventManager;
	import util.GlobalContext;

	[SWF(width=800,height=600,frameRate= 60)]
	public class Main extends Sprite
	{
		public function Main()
		{
			var fileURL:String;
			var loader:Loader;
			var loaderContext:LoaderContext;
			fileURL = "assets/main.swf";	
			loader = new Loader();
			loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loader.load(new URLRequest(fileURL), loaderContext);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		/** 资源加载完毕 */
		private function onLoadComplete(evt:Event):void
		{
			GlobalContext.init(this);
			Menu.getInstance().show(true);
			
			onAddToStage();
		}
		
		private function toGameScene(evt:Event):void
		{
			Menu.getInstance().show(false);
			BasketBallGame.getInstance().startGame(0);
		}
		
		private function toPractice(evt:Event):void
		{
			Menu.getInstance().show(false);
			BasketBallGame.getInstance().startGame(1);
		}
		
		
		/** 当对象被addChild到舞台时触发 */
		private function onAddToStage(evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			//TODO
			EventManager.getInstance().addEventListener(EventName.GAME_START, toGameScene);
			EventManager.getInstance().addEventListener(EventName.PRACTICE, toPractice);
		}
		/** 当对象被removeChild时触发*/
		private function onRemoveFromStage(evt:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			//TODO
		}
		
		
	}
}