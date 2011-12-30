package away3d.events
{
	import away3d.containers.View3D;
	import away3d.core.base.IRenderable;
	import away3d.core.base.Object3D;
	import away3d.materials.MaterialBase;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class GestureEvent3D extends MouseEvent3D
	{
		/**
		 * Defines the value of the type property of a mouseOver3d event object.
		 */
		public static const GESTURE_ZOOM : String = "gestureZoom3d";
		
		/**
		 * Create a new MouseEvent3D object.
		 * @param type The type of the MouseEvent3D.
		 */
		public function GestureEvent3D(type : String)
		{
			super(type);
		}
		
		/**
		 * Creates a copy of the MouseEvent3D object and sets the value of each property to match that of the original.
		 */
		public override function clone() : Event
		{
			var result : GestureEvent3D = new GestureEvent3D(type);
			
			if (isDefaultPrevented())
				result.preventDefault();
			
			result.screenX = screenX;
			result.screenY = screenY;
			
			result.view = view;
			result.object = object;
			result.renderable = renderable;
			result.material = material;
			result.uv = uv;
			result.localX = localX;
			result.localY = localY;
			result.localZ = localZ;
			
			result.ctrlKey = ctrlKey;
			result.shiftKey = shiftKey;
			
			return result;
		}
	}
}