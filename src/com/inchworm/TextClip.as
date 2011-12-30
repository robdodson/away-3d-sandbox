package com.inchworm
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TextClip extends Sprite
	{
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		public function TextClip()
		{
			super();
			
			graphics.beginFill(0x8AB947);
			graphics.drawRect(0, 0, 1024, 1024);
			graphics.endFill();
			
			textFormat = new TextFormat();
			textFormat.size = 60;
			
			textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.defaultTextFormat = textFormat;
			textField.text = "HELLO WORLD!\nLorem Ipsum dolor set amet\nBLAH BLAH BLAH";
			textField.x = 512 - textField.width / 2;
			textField.y = 512 - textField.height / 2;
			addChild(textField);
		}
	}
}