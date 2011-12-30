package com.inchworm
{
	import com.inchworm.shapes.Ball;
	
	import flash.display.Sprite;
	
	public class InteractionClip extends Sprite
	{
		private var ball:Ball;
		public var isInvalid:Boolean;
		
		public function InteractionClip()
		{
			super();
			
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, 1024, 1024);
		}
		
		public function validate():void
		{
			isInvalid = false;
		}
		
		public function invalidate(xPos:Number, yPos:Number):void
		{
			graphics.beginFill(0xFF0000);
			graphics.drawCircle(xPos, yPos, 50);
			graphics.endFill();
			isInvalid = true;
		}
	}
}