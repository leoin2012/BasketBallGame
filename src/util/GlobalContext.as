package util
{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	/**
	 * 游戏全局变量
	 *@author Leo
	 */
	public class GlobalContext
	{
		/** 根显示对象 */
		private var _root:Sprite;
		/** 舞台 */
		private var _stage:Stage;
		/** 上下文 */
		private var _context:LoaderContext;
		private var _gameLayers:GameLayerCollections;
		
		/**
		 * 存储舞台大小变化响应函数列表 
		 */		
		private static var resizeFuncDic:Dictionary;
		
		public function GlobalContext(root:Sprite)
		{
			if(instance)
				throw new Error("GlobalContext is singleton class and allready exists!");
			instance = this;
			
			_root = root;
			config();
		}
		/** 单例*/
		private static var instance:GlobalContext;
		/** 获取单例*/
		private static function getInstance():GlobalContext
		{
			if(!instance)return null;
			return instance;
		}
		
		/**
		 * 初始化全局上下文，一旦该上下文被初始化后再次调用new或init都会无效化
		 * @param GlobalContextBase Base
		 */
		public static function init(root:Sprite):void {
			if (null == instance)
				instance = new GlobalContext(root);
		}
		
		/** 配置 */
		private function config():void
		{
			_stage = _root.stage;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			
			_context = new LoaderContext(false, ApplicationDomain.currentDomain);
			
			_gameLayers = new GameLayerCollections(_root);
		}
		
		private function onStageResize(e:Event):void {
			var w:Number = stageWidth;
			var h:Number = stageHeight;
			for each (var func:Function in resizeFuncDic) 
			{
				func.apply(null, [w , h]);
			}
		}
		
		//---------------------------------- 公有方法 ---------------------------------------
		/**
		 * 获取全局stage对象
		 * @return Stage
		 */
		public static function get stage():Stage
		{
			return getInstance().stage;
		}
		/**
		 * 获取全局Stage的宽度
		 * @return Number
		 */
		public static function get stageWidth():Number
		{
			return getInstance().stage.stageWidth;
		}
		/**
		 * 获取全局Stage的高度
		 * @return Number
		 */
		public static function get stageHeight():Number {
			return getInstance().stage.stageHeight;
		}
		/**
		 * 获取全局加载上下文
		 * @return LoaderContext
		 * @see LoaderContext
		 */
		public static function get loaderContext():LoaderContext
		{
			return getInstance().loaderContext;
		}
		
		/** 游戏层集合 */
		public static function get gameLayers():GameLayerCollections
		{
			return getInstance().gameLayers;
		}
		
		/**
		 * 增加一个响应函数，舞台大小变化时触发  
		 * @param func
		 * @param runNow 是否立刻执行一次
		 * 
		 */
		public static function addStageResizeFunc(func:Function , runNow:Boolean = false):void
		{
			if(null == func)
				return;
			resizeFuncDic[func] = func;
			if(runNow)
				func.apply(null, [stageWidth , stageHeight]);
		}
		
		/**
		 *删除一个响应函数
		 * @param func
		 * 
		 */		
		public static function removeStageResizeFunc(func:Function):void
		{
			if(undefined != resizeFuncDic[func])
				delete resizeFuncDic[func];
		}
		
		//---------------------------------- 私有方法 ---------------------------------------
		
		/**
		 * 获取全局stage对象
		 * @return Stage
		 */
		private function get stage():Stage
		{
			return _stage == null ? _root.stage : _stage;
		}
		
		private function get loaderContext():LoaderContext  {
			return _context;
		}

		/** 游戏层集合 */
		public function get gameLayers():GameLayerCollections
		{
			return _gameLayers;
		}

		
	}
}