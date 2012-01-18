package com.inchworm.pools
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class BitmapDataPool
	{
		//-----------------------------------------------------------------
		// Properties
		public var minPoolSize				:int;
		public var poolSize					:int = 0;
		private var list					:Array = [];
		public var listLength				:int = 0;
		private var disposed				:Boolean = false;
		
		// Eraser
		protected var _eraser				:BitmapData;
		protected var _eraserPoint			:Point;
		
		//-----------------------------------------------------------------
		
		public function BitmapDataPool(minSize:int = 0)
		{
			this.minPoolSize = minSize;
			
			_eraser = new BitmapData(266, 266, true, 0x00000000);
			_eraserPoint = new Point(0, 0);
			
			var i:int = 0;
			for(i; i < minSize; i++)
			{
				add();
			}
		}
		
		//-----------------------------------------------------------------
		//
		// API
		//
		//-----------------------------------------------------------------
		
		public function add():void
		{
			list[listLength++] = create();
			poolSize++;
		}
		
		public function checkOut():BitmapData
		{
			if(listLength == 0)
			{
				poolSize++;
				return create();
			}
			
			return list[--listLength];
		}
		
		public function checkIn(bmd:BitmapData):void
		{
			if (clean != null)
			{
				clean(bmd);
			}
			
			list[listLength++] = bmd;
		}
		
		public function dispose():void
		{
			if(disposed) return;
			disposed = true;
			list = null;
		}
		
		//-----------------------------------------------------------------
		//
		// PRIVATE
		//
		//-----------------------------------------------------------------
		protected function create():BitmapData
		{
			return new BitmapData(266, 266, true, 0x00000000);
		}
		
		protected function clean(bmd:BitmapData):void
		{
			bmd.copyPixels(_eraser, _eraser.rect, _eraserPoint, _eraser);
		}
	}
}