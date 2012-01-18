package
{
	import com.app.Tile300x300;
	import com.greensock.TweenLite;
	import com.gskinner.utils.PerformanceTest;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BitmapMaterialPerformanceProfile extends Sprite
	{
		//-----------------------------------------------------------------
		// Clips
		private var _sourceClip					:Tile300x300;
		
		//-----------------------------------------------------------------
		
		public function BitmapMaterialPerformanceProfile()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_sourceClip = new Tile300x300();
		}
		
		protected function _onAddedToStage(e:Event):void
		{
			TweenLite.to(this, 0, { delay: 2, onComplete: setupTests });
		}
		
		protected function setupTests():void
		{
			var performanceTest:PerformanceTest = PerformanceTest.getInstance();
			performanceTest.testFunction(createOpaqueBitmapData, 1000, "createOpaqueBitmapData");
			performanceTest.testFunction(createTransparentBitmapData, 1000, "createTransparentBitmapData");
			performanceTest.testFunction(drawOpaqueBitmapData, 1000, "drawOpaqueBitmapData");
			performanceTest.testFunction(drawTransparentBitmapData, 1000, "drawTransparentBitmapData");
		}
		
		protected function createOpaqueBitmapData():void
		{
			var bitmapData:BitmapData = new BitmapData(300, 300, false, 0);
		}

		protected function createTransparentBitmapData():void
		{
			var bitmapData:BitmapData = new BitmapData(300, 300, true, 0);
		}

		protected function drawOpaqueBitmapData():void
		{
			var bitmapData:BitmapData = new BitmapData(300, 300, false, 0);
			bitmapData.draw(_sourceClip);
		}

		protected function drawTransparentBitmapData():void
		{
			var bitmapData:BitmapData = new BitmapData(300, 300, true, 0);
			bitmapData.draw(_sourceClip);
		}
	}
}