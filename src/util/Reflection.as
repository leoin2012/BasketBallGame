package util
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	/**
	 * 反射工厂
	 *@author Leo
	 */
	public class Reflection
	{
		public function Reflection()
		{
		}
		
		/**
		 * 获取一个MovieClip实例，如果出错会使用一个空的MC替代
		 * @param fullClassName
		 * @param applicationDomain
		 * @return
		 *
		 */
		public static function createMovieClipInstance(fullClassName:String, applicationDomain:ApplicationDomain = null):MovieClip
		{
			var mc:MovieClip;
			try
			{
				mc = createInstance(fullClassName, applicationDomain);
			}
			catch (e:*)
			{
				mc = new MovieClip();
			}
			if (null == mc)
			{
				mc = new MovieClip();
			}
			return mc;
		}
		
		/**
		 * 获取一个SimpleButton实例，如果出错会使用一个空的SimpleButton替代
		 * @param fullClassName
		 * @param applicationDomain
		 * @return
		 *
		 */
		public static function createSimpleButtonInstance(fullClassName:String, applicationDomain:ApplicationDomain = null):SimpleButton
		{
			var button:SimpleButton;
			try
			{
				button = createInstance(fullClassName, applicationDomain);
			}
			catch (e:*)
			{
				button = new SimpleButton();
			}
			if (null == button)
			{
				button = new SimpleButton();
			}
			return button;
		}
		
		/**
		 * 获取一个Sprite实例，如果出错会使用一个空的Sprite替代
		 * @param fullClassName
		 * @param applicationDomain
		 * @return
		 *
		 */
		public static function createSpriteInstance(fullClassName:String, applicationDomain:ApplicationDomain = null):Sprite
		{
			var button:Sprite;
			try
			{
				button = createInstance(fullClassName, applicationDomain);
			}
			catch (e:*)
			{
				button = new Sprite();
			}
			if (null == button)
			{
				button = new Sprite();
			}
			return button;
		}
		
		
		/**
		 * 获取一个BitmapData实例，如果出错会使用一个空的BitmapData替代
		 * @param fullClassName
		 * @param width
		 * @param height
		 * @param applicationDomain
		 * @return
		 *
		 */
		public static function createBitmapDataInstance(fullClassName:String, width:int = 0, height:int = 0, applicationDomain:ApplicationDomain = null):*
		{
			var assetClass:Class;
			var data:BitmapData;
			try
			{
				assetClass = getClass(fullClassName, applicationDomain);
				if (assetClass != null)
				{
					data = new assetClass(width, height);
				}
			}
			catch (e:*)
			{
				data = new BitmapData(width > 0 ? width : 1, height > 0 ? height : 1);
			}
			if (null == data)
			{
				data = new BitmapData(width > 0 ? width : 1, height > 0 ? height : 1);
			}
			return data;
		}
		
		/**
		 * 创建实例
		 * @param fullClassName
		 * @param applicationDomain
		 * @return 
		 */		
		public static function createInstance(fullClassName:String, applicationDomain:ApplicationDomain = null):*
		{
			try
			{
				var assetClass:Class = getClass(fullClassName, applicationDomain);
				if(null != assetClass)
				{
					return new assetClass();
				}
			} 
			catch(error:Error) 
			{
				trace(error);
			}
			return null;
		}
		
		/**
		 * 根据字符串获取相应Class 
		 * @param fullClassName
		 * @param applicationDomain
		 * @return 
		 * 
		 */		
		public static function getClass(fullClassName:String, applicationDomain:ApplicationDomain = null):Class
		{
			if(null == applicationDomain)
			{
				applicationDomain = ApplicationDomain.currentDomain;
			}
			var assetClass:Class;
			try
			{
				assetClass = applicationDomain.getDefinition(fullClassName) as Class;
			} 
			catch(error:Error) 
			{
				
			}
			return assetClass;
		}
		
		
		/**
		 * 获取对象的完整类描述
		 * @param o
		 * @return
		 *
		 */
		public static function getFullClassName(o:*):String
		{
			return getQualifiedClassName(o);
		}
		
		/**
		 * 获取对象的类描述
		 * @param o
		 * @return
		 *
		 */
		public static function getClassName(o:*):String
		{
			var name:String = getFullClassName(o);
			var lastI:int = name.lastIndexOf(".");
			if (lastI >= 0)
			{
				name = name.substr(lastI + 1);
			}
			return name;
		}
		
		/**
		 * 获取对象的包描述
		 * @param o
		 * @return
		 *
		 */
		public static function getPackageName(o:*):String
		{
			var name:String = getFullClassName(o);
			var lastI:int = name.lastIndexOf(".");
			if (lastI >= 0)
			{
				return name.substring(0, lastI);
			}
			else
			{
				return "";
			}
		}
		
		
		
		
	}
}