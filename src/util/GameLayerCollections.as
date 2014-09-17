package util
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 *@author Leo
	 */
	public class GameLayerCollections
	{
		private var _bottomLayer:Sprite;
		private var _sceneLayer:Sprite;
		private var _uiLayer:Sprite;
		private var _effectLayer:Sprite;
		private var _menuLayer:Sprite;
		private var _loadingLayer:Sprite;
		private var _msgLayer:Sprite;
		private var _topLayer:Sprite;
		
		public function GameLayerCollections(display:DisplayObjectContainer)
		{
			_bottomLayer = new Sprite();
			_bottomLayer.mouseEnabled = false;
			display.addChild(_bottomLayer);
			
			_sceneLayer = new Sprite();
			_sceneLayer.mouseEnabled = false;
			display.addChild(_sceneLayer);
			
			_uiLayer = new Sprite();
			_uiLayer.mouseEnabled = false;
			display.addChild(_uiLayer);
			
			_effectLayer = new Sprite();
			_effectLayer.mouseEnabled = false;
			_effectLayer.mouseChildren = false;
			display.addChild(_effectLayer);
			
			_menuLayer = new Sprite();
			_menuLayer.mouseEnabled = false;
			display.addChild(_menuLayer);
			
			_loadingLayer = new Sprite();
			_loadingLayer.mouseEnabled = false;
			display.addChild(_loadingLayer);
			
			_msgLayer = new Sprite();
			_msgLayer.mouseEnabled = false;
			display.addChild(_msgLayer);
			
			_topLayer = new Sprite();
			_topLayer.mouseEnabled = false;
			display.addChild(_topLayer);
		}
		
		/** 最底层 */
		public function get bottomLayer():Sprite
		{
			return _bottomLayer;
		}
		/** 场景层 */
		public function get sceneLayer():Sprite
		{
			return _sceneLayer;
		}
		/** ui层 */
		public function get uiLayer():Sprite
		{
			return _uiLayer;
		}
		/** 特效层 */
		public function get effectLayer():Sprite
		{
			return _effectLayer;
		}
		/** 主菜单 */
		public function get menuLayer():Sprite
		{
			return _menuLayer;
		}
		/** 加载层 */
		public function get loadingLayer():Sprite
		{
			return _loadingLayer;
		}
		/** 提示信息层 */
		public function get msgLayer():Sprite
		{
			return _msgLayer;
		}
		public function get topLayer():Sprite
		{
			return _topLayer;
		}
		
	}
}