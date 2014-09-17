package
{
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import util.Color;
	import util.CustomTextfield;
	import util.GlobalContext;
	import util.TimerManager;

	/** 信息提示框 */
	public class Alert extends Sprite
	{
		private var _message:CustomTextfield;
		
		private var _btnOK:Button;
		
		private var _callBack:Function;
		
		private var _panel:Sprite;
		
		private var _drawLayer:Sprite;
		
		public function Alert()
		{
			if(instance)
				throw new Error("Alert is singleton class and allready exists!");
			instance = this;
			
			configUI();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		/** 单例*/
		private static var instance:Alert;
		/** 获取单例*/
		public static function getInstance():Alert
		{
			if(!instance)
				instance = new Alert();
			
			return instance;
		}
		
		private function configUI():void
		{
			addChild(_drawLayer = new Sprite());
			
			addChild(_panel = new Sprite());
			_panel.x = 250;
			_panel.y = 200;
			
			initText();
			
			_btnOK = new Button();
			_btnOK.label = "确定";
			_panel.addChild(_btnOK);
			_btnOK.x = 100;
			_btnOK.y = 100;
		}
		
		/** 初始化调试信息文本 */
		private function initText():void
		{
			_message = new CustomTextfield();
			_message.multiline = true;
			_message.wordWrap = true;
			_message.align = TextFormatAlign.CENTER;
			_message.width = 300;
			_message.height = 80;
			_message.x = 0;
			_message.y = 0;
			_message.color = Color.RED;
			_message.visible = true;
			_message.mouseEnabled = false;
			_panel.addChild(_message);
		}
		
		public static function show(str:String, callBack:Function = null):void
		{
			getInstance().show(str, callBack);
		}
		
		public static function tempShow(str:String):void
		{
			getInstance().tempShow(str);
		}
		
		private function tempShow(str:String):void
		{
			if(!this.parent)
			{
				_drawLayer.graphics.clear();
				GlobalContext.gameLayers.msgLayer.addChild(this);
			}
			_message.htmlText = str;
			_btnOK.visible = false;
			
			TimerManager.getInstance().addItem(1500, close);
		}
		
		private function close():void
		{
			TimerManager.getInstance().removeItem(close);
			_btnOK.visible = true;
			if(this.parent)
				this.parent.removeChild(this);
		}
		
		private function show(str:String, callback:Function = null):void
		{
			if(!this.parent)
			{
				_drawLayer.graphics.beginFill(Color.WHITE, 0.5);
				_drawLayer.graphics.drawRect(0, 0, GlobalContext.stageWidth, GlobalContext.stageHeight);
				_drawLayer.graphics.endFill();
				GlobalContext.gameLayers.msgLayer.addChild(this);
			}
			
			_message.htmlText = str;
			_callBack = callback;
		}
		
		private function onClickOK(evt:MouseEvent):void
		{
			if(_callBack != null)
				_callBack.apply();
			
			if(this.parent)
			{
				_drawLayer.graphics.clear();
				this.parent.removeChild(this);
			}
		}
		
		/** 当对象被addChild到舞台时触发 */
		private function onAddToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			//TODO
			_btnOK.addEventListener(MouseEvent.CLICK, onClickOK);
		}
		/** 当对象被removeChild时触发*/
		private function onRemoveFromStage(evt:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			//TODO
			_btnOK.removeEventListener(MouseEvent.CLICK, onClickOK);
		}
		
	}
}