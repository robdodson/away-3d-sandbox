package
{
	import away3d.containers.View3D;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class SimpleView3D extends Sprite
	{
		private var _view:View3D;
		
		public function SimpleView3D()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			_view = new View3D();
			_view.backgroundColor = 0x666666; 
			_view.antiAlias = 4; 
			this.addChild(_view); 
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_view.render();
		}
	}
}