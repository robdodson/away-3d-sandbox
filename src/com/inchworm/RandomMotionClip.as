package com.inchworm
{
	import com.inchworm.shapes.Ball;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class RandomMotionClip extends Sprite
	{
		private var ball:Ball;
		private var angle:Number;
		private var centerY:Number;
		private var range:Number;
		private var speed:Number;
		
		public function RandomMotionClip()
		{
			super();
			_init();
		}
		
		private function _init():void
		{
			this.graphics.beginFill(0x00FFFFFF, 0);
			this.graphics.drawRect(0, 0, 256, 256);
			this.graphics.endFill();
			
			angle = 0.0;
			centerY = 128;
			range = 100;
			speed = 0.1;
			
			ball = new Ball(50);
			ball.x = 128;
			ball.y = 128;
			ball.rotation = Math.random() * 360;
			addChild(ball);
			
			this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(e:Event):void
		{
			ball.y = centerY + Math.sin(angle) * range;
			angle += speed;
		}
	}
}