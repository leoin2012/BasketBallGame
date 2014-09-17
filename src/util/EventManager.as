package util
{
	import flash.events.EventDispatcher;
	
	/**
	 * 事件管理器（全局事件派发器）
	 * @author face2wind
	 */
	public class EventManager extends EventDispatcher
	{
		public function EventManager()
		{
			
		}
		
		private static var _instance:EventManager = null;
		public static function getInstance():EventManager
		{
			if(null == _instance)
				_instance = new EventManager();
			return _instance;
		}
	}
}