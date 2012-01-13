package com.inchworm.pools
{
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Plane;
	
	import com.inchworm.shapes.Ball;
	
	public class PlanePool
	{
		//-----------------------------------------------------------------
		// CLASS MEMBERS
		public var minPoolSize				:int;
		public var poolSize					:int = 0;
		private var list					:Array = [];
		public var listLength				:int = 0;
		private var disposed				:Boolean = false;
		
		//-----------------------------------------------------------------
		
		public function PlanePool(minSize:int = 0)
		{
			this.minPoolSize = minSize;
			
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
		
		public function checkOut():Plane
		{
			if(listLength == 0)
			{
				poolSize++;
				return create();
			}
			
			return list[--listLength];
		}
		
		public function checkIn(plane:Plane):void
		{
			if (clean != null)
			{
				clean(plane);
			}
			
			list[listLength++] = plane;
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
		private function create():Plane
		{
			var material:ColorMaterial = new ColorMaterial(Math.random() * 0xFFFFFF);
			var plane:Plane = new Plane(material, 100, 100, 1, 1, false);
			return plane;
		}
		
		private function clean(plane:Plane):void
		{
			ColorMaterial(plane.material).alpha = 1;
		}
	}
}