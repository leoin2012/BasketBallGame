package util
{
	/**
	 * 颜色常量
	 *@author Leo
	 */
	public class Color
	{
		public function Color()
		{
		}
		
		/*** 0 白色	 */	
		public static const WHITE:uint = 0xffffff;
		/*** 1 绿色	 */	
		public static const GREEN:uint = 0x3fff56;
		/*** 2 蓝色	 */	
		public static const BLUE:uint = 0x008ffe;
		/*** 3 紫色	 */	
		public static const PURPLE:uint = 0xe300fe;
		/*** 4 黄色	 */	
		public static const YELLOW:uint = 0xffe00f;
		/*** 5 红色	 */	
		public static const RED:uint = 0xfe3122;
		/*** 6 灰色	 */		
		public static const GRAY:uint = 0x676868;
		/*** 7 青色     */		
		public static const CYAN:uint = 0x31fcf6;
		/** 黑色 */
		public static const BLACK:uint = 0x000000;
		
		/**
		 * 转换整数颜色值为字符串（0xffffff -> "#ffffff"）
		 * @param color
		 * @return
		 *
		 */		
		public static function toStr(color:uint):String
		{
			var strColor:String = "#";
			strColor += color.toString(16);
			return strColor;
		}
		
		/**
		 * 转换整数字符串为颜色值（"#ffffff" -> 0xffffff）
		 * @param color
		 * @return
		 *
		 */		
		public static function toInt(color:String):uint
		{
			color = color.substr(1);
			return parseInt(color,16);
		}
	}
}