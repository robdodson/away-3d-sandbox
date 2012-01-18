package
{
	import com.greensock.TweenLite;
	import com.gskinner.utils.PerformanceTest;
	import com.inchworm.pools.BitmapDataPool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class BitmapMaterialPerformanceProfile extends Sprite
	{
		//-----------------------------------------------------------------
		// Clips
		private var _facebookView						:FacebookView;
		private var _facebookTemplateView				:FacebookTemplateView;
		private var _facebookTemplateContent			:FacebookTemplateContent;
		
		// BitmapData
		private var _bmdTemplate						:BitmapData;
		
		// Pools
		private var _bmdPool							:BitmapDataPool;
		
		//-----------------------------------------------------------------
		
		public function BitmapMaterialPerformanceProfile()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			_facebookView = new FacebookView();
			_facebookTemplateView = new FacebookTemplateView();
			_facebookTemplateContent = new FacebookTemplateContent();
		}
		
		protected function _onAddedToStage(e:Event):void
		{
			_setup();
		}
		
		private function _setup():void
		{
			// SETUP DEPENDENCIES
			_bmdPool = new BitmapDataPool(1100);
			_bmdTemplate = new BitmapData(266, 266, true, 0x00000000);
			_bmdTemplate.draw(_facebookTemplateView, null, null, null, null, true);

			// RUN TESTS
			TweenLite.to(this, 0, { delay: 2, onComplete: _runTests });
		}
		
		private function _runTests():void
		{
			// SETUP TESTS
			var performanceTest:PerformanceTest = PerformanceTest.getInstance();
			performanceTest.testFunction(_onlyDrawBitmapData, 500, "onlyDrawBitmapData");
			performanceTest.testFunction(_compositeBitmapData, 500, "compositeBitmapData");
		}
		
		protected function _onlyDrawBitmapData():void
		{
			var bmd:BitmapData = _bmdPool.checkOut();
			bmd.draw(_facebookView, null, null, null, null, true);
		}
		
		protected function _compositeBitmapData():void
		{
			var bmd:BitmapData = _bmdPool.checkOut();
			bmd.copyPixels(_bmdTemplate, _bmdTemplate.rect, new Point(0, 0));
			bmd.draw(_facebookTemplateContent, null, null, null, null, true);
		}
	}
}