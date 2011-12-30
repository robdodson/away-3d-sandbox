package
{
	import away3d.containers.View3D;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class SimpleLoader3D extends Sprite
	{
		private var _view:View3D;
		private var _loader:Loader3D;
		
		public function SimpleLoader3D()
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
			
			Parsers.enableAllBundled();
			
			_loader = new Loader3D();
			_loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader.addEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_loader.load( new URLRequest('assets/models/vase.awd') );
		}
		
		private function onResourceComplete(e:LoaderEvent):void
		{
			_loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_view.scene.addChild(_loader);
		}
		
		private function onLoadError(e:LoaderEvent):void
		{
			trace('Could not find', e.url);
			_loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_loader = null;
		}
		
		private function onEnterFrame(e:Event):void
		{
			_loader.rotationY = stage.mouseX - stage.stageWidth/2;
			_view.camera.y = 3 * (stage.mouseY - stage.stageHeight/2);
			_view.camera.lookAt(_loader.position);
			_view.render();
		}
	}
}