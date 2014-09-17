package
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import util.Color;
	import util.GlobalContext;
	import util.HitTest;
	import util.Reflection;
	import util.TimerManager;
	
	/**
	 * 游戏主场景
	 * @author Leo
	 */
	[SWF(width=800,height=600,frameRate= 60)]
	public class BasketBallGame extends Sprite
	{
		//---------------------------------- 游戏常量 ---------------------------------------
		/** 球半径 */
		private var BALL_RADIUS:Number = 25;
		/** 速度因子 */
		private static var SPEED_FACTOR:Number = 5;
		/** 重力系数 */
		private static var G:int = 1500;
		/** 碰撞系数 */
		private static var RESTITUTION:Number = 0.7;
		/** 篮网摩擦系数 */
		private static var NET_FRICTION:Number = 0.99;
		/** 状态提升1阶 */
		public static const HOT_BALL_NUM:int = 3;
		/** 状态提升2阶 */
		public static const HOT_BALL_NUM2:int = 10;
		
		/** 初始生命值 */
		public static const MAX_LIFE:int = 10;
		/** 正常模式 */
		public static const MODE_NORMAL:int = 0;
		
		//---------------------------------- ui  ---------------------------------------
		/** 背景 */
		private var _bg:Sprite;
		/** 篮球 */
		private var _ball:Sprite;
		/** 篮板 */
		private var _board:Board;
		/** 篮网 */
		private var _net:Net;
		/** 轨迹绘制层 */
		private var _drawLayer:Sprite;
		/** 蒙眼效果层 */
		private var _blindLayer:Sprite;
		
		/** 调试信息文本 */
		private var _message:TextField;
		
		//----------------------------------  ---------------------------------------
		/** 拖拽点 */
		private var _dragP:Point;
		/** 释放点 */
		private var _releaseP:Point;
		/** 鼠标动态移动点 */
		private var _moveP:Point;
		/** 水平速度 */
		private var _vx:Number = 0;
		/** 垂直速度 */
		private var _vy:Number = 0;
		
		/** 是否在拖拽小球中 */
		private var _draging:Boolean;
		
		/** 每次update开始记录时间戳 */
		private var _startTime:int;
		/** 每次update结束记录时间戳 */
		private var _endTime:int;
		/** 上次update的篮球x坐标 */
		private var oldX:Number;
		/** 上次update的篮球y坐标 */
		private var oldY:Number;
		
		/** 每次投篮，篮球碰墙记数 */
		private var _hitWallTimes:int;
		/** 每次投篮，篮球碰地面记数 */
		private var _hitGroundTimes:int;
		/** 每次投篮碰框和篮板次数，用于判断是否为穿心球 */
		private var _hitRimAndBoradTimes:int;
		/** 每次投篮离开屏幕次数 */
		private var _outScreenTimes:int;
		
		/** 当前进球总数 */
		private var _scoreNum:int;
		/** 投篮总数 */
		private var _shootNum:int = -1;
		/** 投篮命中率 */
		private var _scoreRatio:int;
		
		/** 当前连续进球数 */
		private var _curContinuousGoal:int = 0;
		/** 最高连续进球数 */
		private var _maxContinuousGoal:int = 0;
		
		/** 生命值 */
		private var _life:int;
		/** 当前关卡 */
		private var _round:int;
		/** 瞄准变长次数 */
		private var _hotShotNum:int;
		
		/** 游戏模式 */
		private var _mode:int;
		/** 设置游戏模式 */
		public function get mode():int
		{
			return _mode;
		}
		public function set mode(value:int):void
		{
			_mode = value;
			if(_mode == 0)
			{
				_life = MAX_LIFE;
				_shootNum = 0;
				_scoreNum = 0;
				_hitGroundTimes = 0;
				_hitRimAndBoradTimes = 0;
				_hitWallTimes = 0;
				_outScreenTimes = 0;
				_hotShotNum = 0;
				_round = 1;
			}
			else if(_mode == 1)
			{
			
			}
				
		}
		
		/** 开始游戏 */
		public function startGame(type:int):void
		{
			this.show(true);
			this.mode = type;
			_ball.alpha = 1;
			resetBallPosition();
			_vx = _vy = 0;
			_isScore = false;
			_ball.mouseEnabled = true;
			_shootingOver = false;
		}

		
		public function BasketBallGame()
		{
			if(instance)
				throw new Error("BasketBallGame is singleton class and allready exists!");
			instance = this;
			
			init();
			initText();
			onAddToStage();
			startGame(0);
		}
		/** 单例*/
		private static var instance:BasketBallGame;
		/** 获取单例*/
		public static function getInstance():BasketBallGame
		{
			if(!instance)
				instance = new BasketBallGame();
			
			return instance;
		}
		
		public function show(b:Boolean):void
		{
			if(b)
				GlobalContext.gameLayers.sceneLayer.addChild(this);
			else
				if(this.parent && this.parent)
					this.parent.removeChild(this);
		}
		
		/** 初始化场景 */
		private function init():void
		{
			
			addChild(_bg = Reflection.createInstance("backGround"));
			_bg.name = "BackGround";
			
			addChild(_drawLayer = new Sprite());
			
			addChild(_ball = Reflection.createInstance("ball"));
			_ball.name = "Ball";
			resetBallPosition();
			_ball.scaleX = 2;
			_ball.scaleY = 2;
			
			addChild(_net = new Net());
			_net.x = 615;
			_net.y = 210;
			
			addChild(_board = new Board());
			_board.x = 700;
			_board.y = 100;
			
			addChild(_blindLayer = new Sprite());
			_blindLayer.mouseEnabled = false;
			_blindLayer.graphics.beginFill(Color.BLACK, 1);
			_blindLayer.graphics.drawRect(0, 0 , GlobalContext.stageWidth, GlobalContext.stageHeight);
			_blindLayer.graphics.endFill();
			_blindLayer.alpha = 0;
		}
		
		/** 按下鼠标 */
		private function onMouseDown(evt:MouseEvent):void
		{
			switch(evt.target.name)
			{
				case "Ball":
				{
					startDragBall();
					break;
				}
			}
			
		}
		/** 鼠标移动 */
		private function onMouseMove(evt:MouseEvent):void
		{
			if(!_draging)return;
			
			_moveP = _moveP || new Point();
			_moveP.x = evt.stageX;
			_moveP.y = evt.stageY;
			
			drawPredictPath();
			
		}
		/** 绘制预测轨迹 */
		private function drawPredictPath():void
		{
			_drawLayer.graphics.clear();
			_drawLayer.graphics.lineStyle(3, Color.BLUE);
			
			var vx:Number = (_moveP.x - _dragP.x) * SPEED_FACTOR;
			var vy:Number = (_moveP.y - _dragP.y) * SPEED_FACTOR;
			var ballX:Number = _ball.x;
			var ballY:Number = _ball.y;
			
			var pointNum:int = 5;
			
			if(_hotShotNum > 0)
			{
				pointNum = 8;
			}
			
			for (var i:int = 0; i < pointNum; i++) 
			{
				ballX += vx * 0.1;
				ballY += vy * 0.1;
				vy += G * 0.1;
				_drawLayer.graphics.drawCircle(ballX, ballY, 2);
			}
			_drawLayer.graphics.endFill();
			
		}
		
		private function onMouseUp(evt:MouseEvent):void
		{
			_drawLayer.graphics.clear();
			stopDragBall();
		}
		
		private function startDragBall():void
		{
			_draging = true;
			
			_hitWallTimes = 0;
			
			_dragP = _dragP || new Point();
			_dragP.x = _ball.x;
			_dragP.y = _ball.y;
		}
		/** 投射篮球 */
		private function stopDragBall():void
		{
			if(!_draging)return;
			_draging = false;
			
			_releaseP = _releaseP || new Point();
			_releaseP.x = GlobalContext.stage.mouseX;
			_releaseP.y = GlobalContext.stage.mouseY;
			
			_vx = (_releaseP.x - _dragP.x) * SPEED_FACTOR;
			_vy = (_releaseP.y - _dragP.y) * SPEED_FACTOR;
			
			TimerManager.getInstance().removeItem(changeV);
			TimerManager.getInstance().addItem(100, changeV);
			
			_hotShotNum--;
		}
		
		/** 当篮球投射出去后，每隔0.1s改变速度 */
		private function changeV():void
		{
			if((_vx || _vy) && !_draging)
			{
				_vy += G * 0.1;
			}
		}
		
		/** 每秒触发60次 */
		private function update(evt:Event = null):void
		{
			
			_startTime = getTimer();
			debug("update时间间隔：" + ((_startTime - _endTime)) + "ms \n");
			
			checkMouseXY();
			
			if((_vx || _vy) && !_draging)
			{
				_ball.mouseEnabled = false;
				
				oldX = _ball.x;
				oldY = _ball.y;
				_ball.x += _vx * (_startTime - _endTime)/1000;
				_ball.y += _vy * (_startTime - _endTime)/1000;
				
				hitTestWall();
				hitTestNet();
				hitTestBoard();
				
				hitRewardPoint();
				
				
				if(_vx > 0)
					_ball.rotation += 5;
				else if(_vx < 0)
					_ball.rotation -= 5;
				
				checkScore();
				checkShootOver();
			}
			
			_endTime = getTimer();
			showDebugMessage();
		}
		
		/** 检测是否鼠标是否离开舞台，是则触发自动MouseUp事件 */
		private function checkMouseXY():void
		{
			if(GlobalContext.stage.mouseX > GlobalContext.stageWidth || GlobalContext.stage.mouseX < 0
				|| GlobalContext.stage.mouseY > GlobalContext.stageWidth || GlobalContext.stage.mouseY < 0)
			{
				this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			}
		}
		
		/** 显示debug信息 */
		private function showDebugMessage():void
		{
			debug("update用时：" + ((_endTime - _startTime)) + "ms");
			debug("球的坐标：" +　_ball.x + "," + _ball.y, true);
			debug("球的宽高：" +　_ball.width + "," + _ball.height, true);
			debug("球的速度：" + int(_vx) + "," + int(_vy), true);
			debug("舞台宽高：" + GlobalContext.stageWidth + "," + GlobalContext.stageHeight, true);
			debug("进球数：" + _scoreNum, true);
			debug("投篮命中率:" + _scoreRatio + "%", true);
			debug("目前连续进球数：" + _curContinuousGoal, true);
			debug("最高连续进球数：" + _maxContinuousGoal, true);
			debug("当前生命值:" + _life, true);
			debug("当前关卡:" + _round, true);
		}
		
		private var _isScore:Boolean;
		/** 检查是否进球 */
		private function checkScore():void
		{
			if((HitTest.complexHitTestObject(_ball, _net.scorePoints[0]) 
			|| HitTest.complexHitTestObject(_ball, _net.scorePoints[1])) && _vy > 0)
			{
				//该次投篮进球分数+1
				if(!_isScore)
				{
					_scoreNum++;
				}
				_isScore = true;
			}
		}
		
		private function hitTestNet():void
		{
			for each (var p:Point in _net.netPoints) 
			{
				if(_ball.hitTestPoint(_net.x + p.x, _net.y + p.y, true))
				{
					_net.gotoAndPlay("n4");
					_vx *= NET_FRICTION;
					_vy *= NET_FRICTION;
				}
			}
			
			if(HitTest.complexHitTestObject(_ball, _net.frontRimPoint))
			{
				_hitRimAndBoradTimes++;
				
				_ball.x = oldX;
				_ball.y = oldY;
				getComplexHitV(_ball.x, _ball.y, _net.x+_net.frontRimPoint.x, _net.y+_net.frontRimPoint.y);
			}
			if(HitTest.complexHitTestObject(_ball, _net.backRimPoint))
			{
				_hitRimAndBoradTimes++;
				
				_ball.x = oldX;
				_ball.y = oldY;
				getComplexHitV(_ball.x, _ball.y, _net.x+_net.backRimPoint.x, _net.y+_net.backRimPoint.y);
			}
		}
		
		/** 恢复球撞击前一刻的位置 */
		private function restoreBeforeHit(x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			// 计算N的长度
			var lengthN:Number = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
			
			var v:Number =  Math.sqrt(_vx * _vx + _vy * _vy);
			var t:Number;
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			var offset:Number = 0;
			
			//如果两点距离小于球半径（理想距离）,修正x1，y1使得两点距离刚好为小球半径
			if(lengthN < BALL_RADIUS)
			{
				offsetX = _vx * 0.0001;
				offsetY = _vy * 0.0001;
//				offset = Math.sqrt(BALL_RADIUS * BALL_RADIUS - lengthN * lengthN);
//				offsetX = offset * _vx / v;
//				offsetY = offset * _vy / v;
				x1 = x1 - offsetX;
				y1 = y1 - offsetY;
				_ball.x = x1;
				_ball.y = y1;
				restoreBeforeHit(_ball.x, _ball.y, x2, y2);
			}
		}
		
		/** 计算发生复杂碰撞后的篮球速度 */
		public function getComplexHitV(x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			// 计算N的长度
			var lengthN:Number = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
			
			var v:Number =  Math.sqrt(_vx * _vx + _vy * _vy);
			var t:Number;
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			var offset:Number = 0;
			
			//如果两点距离小于球半径（理想距离）,修正x1，y1使得两点距离刚好为小球半径
//			if(lengthN < BALL_RADIUS)
//			{
//				offset = Math.sqrt(BALL_RADIUS * BALL_RADIUS - lengthN * lengthN);
//				offsetX = offset * _vx / v;
//				offsetY = offset * _vy / v;
//				x1 = x1 - offsetX;
//				y1 = y1 - offsetY;
//				_ball.x = x1;
//				_ball.y = y1;
//			}
//			
//			lengthN = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
			
			// 归一化N为n'
			var n0x:Number = (x1 - x2) / lengthN;// n0x就是n'的x分量
			var n0y:Number = (y1 - y2) / lengthN;// n0y就是n'的y分量
			// 计算n，就是S在N方向上的投影向量
			// 根据b'= (-b.a1').a1'，有n = (-S.n').n'
			var nx:Number = -(_vx*n0x + _vy*n0y)*n0x;
			var ny:Number = -(_vx*n0x + _vy*n0y)*n0y;
			// 计算T
			// T = S + n
			var Tx:Number = _vx + nx ; // T的x分量
			var Ty:Number = _vy + ny ; // T的y分量
			// 有了T，有了F = 2*T - S，好了，你现在拥有一切了
			// 计算F
			var Fx:Number = 2*Tx - _vx ; // F的x分量
			var Fy:Number = 2*Ty - _vy ; // F的y分量
			//F便为反弹后的速度向量
			_vx = Fx * RESTITUTION;
			_vy = Fy * RESTITUTION;
		}
		
		
		private function hitTestWall():Boolean
		{
			if(_ball.x + BALL_RADIUS > GlobalContext.stageWidth)
			{
				_ball.x = GlobalContext.stageWidth - BALL_RADIUS;
				_vx *= -1 * RESTITUTION;
				_hitWallTimes++;
				return true;
			}
			if(_ball.x - BALL_RADIUS < 0)
			{
				_ball.x = BALL_RADIUS;
				_vx *= -1 * RESTITUTION;
				_hitWallTimes++;
				return true;
			}
			if(_ball.y + BALL_RADIUS > GlobalContext.stageHeight)
			{
				_vy *= -1 * RESTITUTION;
				_ball.y = GlobalContext.stageHeight - BALL_RADIUS;
				_hitGroundTimes++;
				return true;
			}
			if(_ball.y + BALL_RADIUS < 0)
			{
				_outScreenTimes++;
			}
			return false;
		}
		
		/** 篮板碰撞检测 */
		private function hitTestBoard():Boolean
		{
			var isHitLU:Boolean = HitTest.complexHitTestObject(_ball, _board.pointLU);
			var isHitLD:Boolean = HitTest.complexHitTestObject(_ball, _board.pointLD);
			var isHitRU:Boolean = HitTest.complexHitTestObject(_ball, _board.pointRU);
			var isHitRD:Boolean = HitTest.complexHitTestObject(_ball, _board.pointRD);
			var isHitUp:Boolean;
			var isHitDown:Boolean;
			var isHitLeft:Boolean;
			var isHitRight:Boolean;
			
			//是否碰到四个角
			var isHitTestPoint:Boolean = isHitLU || isHitLD || isHitRU || isHitRD;
			
			//检测篮球是否碰到篮板四个角，是用getComplexHitV精确计算反弹速度和方向，否则说明是碰到篮板其他地方，简单判断反弹方向
			if(isHitTestPoint)
			{
				if(isHitLU)
				{
					if(oldY < _board.y)
					{
						_hitRimAndBoradTimes++;
						
						getComplexHitV(oldX, oldY, _board.x+_board.pointLU.x, _board.y+_board.pointLU.x);
						_ball.x = oldX;
						_ball.y = oldY;
						return true;
					}
				}
				else if(isHitLD)
				{
					if(oldY > _board.y + Board.DOWN)
					{
						_hitRimAndBoradTimes++;
						
						getComplexHitV(oldX, oldY, _board.x+_board.pointLD.x, _board.y+_board.pointLD.x);
						_ball.x = oldX;
						_ball.y = oldY;
						return true;
					}
				}
				else if(isHitRU)
				{
					if(oldY < _board.y)
					{
						_hitRimAndBoradTimes++;
						
						getComplexHitV(oldX, oldY, _board.x+_board.pointRU.x, _board.y+_board.pointRU.x);
						_ball.x = oldX;
						_ball.y = oldY;
						return true;
					}
				}
				else if(isHitRD)
				{
					if(oldY > _board.y + Board.DOWN)
					{
						_hitRimAndBoradTimes++;
						
						getComplexHitV(oldX, oldY, _board.x+_board.pointRD.x, _board.y+_board.pointRD.x);
						_ball.x = oldX;
						_ball.y = oldY;
						return true;
					}
				}
			}
			if(HitTest.complexHitTestObject(_ball, _board))
			{
				//撞篮板上沿
				if(oldY + BALL_RADIUS <=  _board.y + Board.UP && _ball.y + BALL_RADIUS > _board.y + Board.UP)
				{
					_ball.y = _board.y + Board.UP - BALL_RADIUS;
					_vy *= -1 * RESTITUTION;
				}
				//撞篮板下沿
				else if(oldY - BALL_RADIUS >= _board.y + Board.DOWN && oldY - BALL_RADIUS < _board.y + Board.DOWN)
				{
					_ball.y = _board.y + Board.DOWN + BALL_RADIUS;
					_vy *= -1 * RESTITUTION;
				}
				
				if(_ball.x + BALL_RADIUS > _board.x + Board.LEFT && _ball.x - BALL_RADIUS < _board.x + Board.RIGHT )
				{
					if(_vx > 0)
					{
						_ball.x = _board.x + Board.LEFT - BALL_RADIUS;
					}
					else if(_vx < 0)
					{
						_ball.x = _board.x + Board.RIGHT + BALL_RADIUS;
					}
					_vx *= -1 * RESTITUTION;
				}
				
				_hitRimAndBoradTimes++;
				return true;
			}
			return false;
		}
		
		private function hitRewardPoint():Boolean
		{
			if(HitTest.complexHitTestObject(_ball, RewardPoint.getInstance()))
			{
				RewardPoint.show(false);
				_hotShotNum = 1;
				Alert.tempShow("获得奖励：下次投篮准度提高");
				return true;
			}
			return false;
		}
		
		/** 该次投篮是否已结束 */
		private var _shootingOver:Boolean;
		/** 判断该次投篮是否结束 */
		private function checkShootOver():void
		{
			//投篮结束
			if(_hitGroundTimes >= 3 && !_shootingOver)
			{
				_shootingOver = true;
				TweenLite.to(_ball,0.5,{alpha:0});
//				TimerManager.getInstance().removeItem(restart);
				TimerManager.getInstance().addItem(600, restart);
			}
		}
		/** 开始下一次投篮 */
		private function restart():void
		{
			TimerManager.getInstance().removeItem(restart);
			
			//投篮数统计
			_shootNum++;
			//计算投篮命中率
			_scoreRatio = _scoreNum / _shootNum * 100;
			
			// 当前回合是否得分 
			if(_isScore)
			{
				_round++;
				_curContinuousGoal += 1;
				if(_curContinuousGoal > _maxContinuousGoal)
					_maxContinuousGoal = _curContinuousGoal;
			}
			else
			{
				_life--;
				_curContinuousGoal = 0;
			}
			
			RewardPoint.show(false);
			
			if(_life <= 0)
			{
				gameOver();
			}
			else
			{
				_hitRimAndBoradTimes = 0;
				_hitWallTimes = 0;
				_hitGroundTimes = 0;
				_outScreenTimes = 0;
				
				_ball.alpha = 1;
				resetBallPosition();
				_vx = _vy = 0;
				
				setRandomReward();
				
				_isScore = false;
				_ball.mouseEnabled = true;
				_shootingOver = false;
			}
			
		}
		
		/** 游戏结束 */
		private function gameOver():void
		{
			Alert.show("游戏结束\n最高纪录：" + _round + "关\n命中率:" + _scoreRatio + "%", toMenu);
			
			function toMenu():void
			{
				show(false);
				Menu.getInstance().show(true);
			}
		}
		
		private function setRandomReward():void
		{
			if(Math.random() < 0.25)
			{
				RewardPoint.show(true, 540 + 140 * Math.random(), 20 + 140 * Math.random());
			}
		}
		
		/** 重设篮球位置 */
		private function resetBallPosition():void
		{
			//内线区域
			if(_curContinuousGoal < 2)
			{
				_ball.x = 300 + 200 * Math.random();
				_ball.y = 100 + 200 * Math.random();
			}
			//中距离投篮
			else if(_curContinuousGoal < 5)
			{
				_ball.x = 150 + 400 * Math.random();
				_ball.y = 100 + 300 * Math.random();
			}
			//三分投篮
			else
			{
				_ball.x = 20 + 400 * Math.random();
				_ball.y = 100 + 400 * Math.random();
			}
		}
		
		/** 初始化调试信息文本 */
		private function initText():void
		{
			_message = new TextField();
			_message.multiline = true;
			_message.wordWrap = true;
			_message.width = 300;
			_message.height = 300;
			_message.x = 100;
			_message.y = 100;
			_message.textColor = Color.RED;
			_message.visible = true;
			_message.mouseEnabled = false;
			addChild(_message);
		}
		
		private function debug(str:String, isAppend:Boolean = false):void
		{
//			_message.visible = true;
			if(isAppend)
			{
				_message.appendText("" + str + "\n");
			}
			else
			{
				_message.text = str;
			}
		}
		
		/** 当对象被addChild到舞台时触发 */
		private function onAddToStage(evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			//TODO
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		/** 当对象被removeChild时触发*/
		private function onRemoveFromStage(evt:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			//TODO
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
	}
}