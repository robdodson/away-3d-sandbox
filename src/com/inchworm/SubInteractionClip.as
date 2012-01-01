package com.inchworm
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.inchworm.events.InvalidationEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SubInteractionClip extends MovieClip
	{
		//-----------------------------------------------------------------
		// CLASS MEMBERS
		public var dummyButton					:Sprite;
		public var isInvalid					:Boolean;
		
		//-----------------------------------------------------------------
		
		public function SubInteractionClip()
		{
			super();
			
			// Draw our background
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, 1024, 1024);
			this.graphics.endFill();
			
			// Draw our button
			dummyButton = new Sprite();
			dummyButton.graphics.beginFill(0x00FF00);
			dummyButton.graphics.drawRect(0, 0, 100, 100);
			dummyButton.graphics.endFill();
			dummyButton.x = 100;
			dummyButton.y = 100;
			dummyButton.addEventListener(MouseEvent.ROLL_OVER, onDummyOver);
			dummyButton.addEventListener(MouseEvent.ROLL_OUT, onDummyOut);
			dummyButton.addEventListener(MouseEvent.MOUSE_UP, onDummyUp);
			dummyButton.addEventListener(MouseEvent.MOUSE_DOWN, onDummyDown);
			dummyButton.addEventListener(MouseEvent.CLICK, onDummyClick);
			dummyButton.addEventListener(MouseEvent.DOUBLE_CLICK, onDummyDoubleClick);
			dummyButton.addEventListener(MouseEvent.MOUSE_WHEEL, onDummyWheel);
			addChild(dummyButton);
		}
		
		protected function onDummyOver(e:MouseEvent):void
		{
			trace(this, "onDummyOver!!!");
		}
		
		protected function onDummyOut(e:MouseEvent):void
		{
			trace(this, "onDummyOut!!!");
			validate();
		}

		protected function onDummyUp(e:MouseEvent):void
		{
			trace(this, "onDummyUp!!!");
			validate();
		}

		protected function onDummyDown(e:MouseEvent):void
		{
			trace(this, "onDummyDown!!!");
			invalidate();
		}
		
		protected function onDummyClick(e:MouseEvent):void
		{
			trace(this, "onDummyClick!");
		}

		protected function onDummyDoubleClick(e:MouseEvent):void
		{
			trace(this, "onDummyDoubleClick!");
		}

		protected function onDummyWheel(e:MouseEvent):void
		{
			trace(this, "onDummyWheel!");
		}
		
		public function invalidate():void
		{
			isInvalid = true;
			dispatchEvent(new InvalidationEvent(InvalidationEvent.INVALIDATED));
		}
		
		public function validate():void
		{
			isInvalid = false;
			dispatchEvent(new InvalidationEvent(InvalidationEvent.VALIDATED));
		}
	}
}