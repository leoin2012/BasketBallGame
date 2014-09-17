package util
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * 定时统一触发器
	 *@author Leo
	 */
	public class TimerManager
	{
		public function TimerManager()
		{
			if(instance)
				throw new Error("TimerManager is singleton class and allready exists!");
			instance = this;
		}
		/**
		 * 单例
		 */
		private static var instance:TimerManager;
		/**
		 * 获取单例
		 */
		public static function getInstance():TimerManager
		{
			if(!instance)
				instance = new TimerManager();
			
			return instance;
		}
		/** 存储创建的timer，key为指定的delay */
		private var timerDic:Dictionary = new Dictionary();
		/** 存储创建的timer,key为指定的执行函数 */
		private var funcToTimerDic:Dictionary = new Dictionary();
		/** 存储执行函数的字典，相应delay对应相应执行函数 */
		private var funcListDic:Dictionary = new Dictionary();
		
		/**
		 * 添加Timer执行函数
		 * @param delay 执行频率
		 * @param func 执行函数
		 */		
		public function addItem(delay:int, func:Function):void
		{
			if(funcToTimerDic[func] != undefined)return;
			
			funcToTimerDic[func] = createTimer(delay);
			funcListDic[delay].push(func);
		}
		
		/**
		 * 是否已经注册了该函数
		 * @param func 执行函数
		 * @return 
		 */		
		private function hadItem(func:Function):Boolean
		{
			if(funcToTimerDic[func] != undefined)
				return true;
			return false;
		}
		
		/**
		 * 删除Timer执行函数
		 * @param func
		 */		
		public function removeItem(func:Function):void
		{
			if(funcToTimerDic[func] == undefined)
				return;
			var timer:Timer = funcToTimerDic[func];
			delete funcToTimerDic[func];
			var list:Array = funcListDic[timer.delay];
			if(!list)return;
			
			if(list.indexOf(func) > -1)
			{
				list.splice(list.indexOf(func), 1);
			}
			if(list.length == 0)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				delete funcListDic[timer.delay];
				delete timerDic[timer.delay];
			}
		}
		
		/**
		 * 根据给定延迟创建Timer
		 * @param delay
		 */		
		private function createTimer(delay:int):Timer
		{
			if(timerDic[delay] == undefined)
			{
				var timer:Timer = new Timer(delay);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
				timerDic[delay] = timer;
			}
			if(funcListDic[delay] == undefined)
			{
				funcListDic[delay] = new Array();
			}
			return timerDic[delay];
		}
		
		/** 统一执行触发函数 */
		private function timerHandler(e:TimerEvent):void
		{
			var list:Array = funcListDic[Timer(e.target).delay];
			for (var i:* in list) 
			{
				list[i]();	
			}
		}
		
	}
}