package away3d.events
{
	import away3d.containers.View3D;
	import away3d.core.base.IRenderable;
	import away3d.core.base.Object3D;
	import away3d.materials.MaterialBase;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * A GestureEvent3D is dispatched when a TransformGestureEvent occurs over a mouseEnabled object in View3D.
	 */
	public class GestureEvent3D extends Event
	{
		/**
		 * Defines the value of the type property of a gesturePan3d event object.
		 */		
		public static const GESTURE_PAN : String = "gesturePan3d";
		
		/**
		 * Defines the value of the type property of a gestureRotate3d event object.
		 */
		public static const GESTURE_ROTATE : String = "gestureRotate3d";
		
		/**
		 * Defines the value of the type property of a gestureSwipe3d event object.
		 */		
		public static const GESTURE_SWIPE : String = "gestureSwipe3d";
		
		/**
		 * Defines the value of the type property of a gestureZoom3d event object.
		 */
		public static const GESTURE_ZOOM : String = "gestureZoom3d";
		
		/**
		 * The horizontal coordinate at which the event occurred in view coordinates.
		 */
		public var screenX : Number;
		
		/**
		 * The vertical coordinate at which the event occurred in view coordinates.
		 */
		public var screenY : Number;
		
		/**
		 * The view object inside which the event took place.
		 */
		public var view : View3D;
		
		/**
		 * The 3d object inside which the event took place.
		 */
		public var object : Object3D;
		
		/**
		 * The renderable inside which the event took place.
		 */
		public var renderable : IRenderable;
		
		/**
		 * The material of the 3d element inside which the event took place.
		 */
		public var material : MaterialBase;
		
		/**
		 * The uv coordinate inside the draw primitive where the event took place.
		 */
		public var uv : Point;
		
		/**
		 * The x-coordinate in object space where the event took place
		 */
		public var localX : Number;
		
		/**
		 * The y-coordinate in object space where the event took place
		 */
		public var localY : Number;
		
		/**
		 * The z-coordinate in object space where the event took place
		 */
		public var localZ : Number;
		
		/**
		 * Indicates whether the Control key is active (true) or inactive (false).
		 */
		public var ctrlKey : Boolean;
		
		/**
		 * Indicates whether the Alt key is active (true) or inactive (false).
		 */
		public var altKey : Boolean;
		
		/**
		 * Indicates whether the Shift key is active (true) or inactive (false).
		 */
		public var shiftKey : Boolean;
		
		/**
		 * The horizontal scale of the display object, since the previous gesture event. 
		 */		
		public var scaleX : Number;
		
		/**
		 * The vertical scale of the display object, since the previous gesture event. 
		 */		
		public var scaleY : Number;
		
		/**
		 * The horizontal translation of the display object, since the previous gesture event. 
		 */		
		public var offsetX : Number;
		
		/**
		 * The vertical translation of the display object, since the previous gesture event. 
		 */		
		public var offsetY : Number;
		
		/**
		 * The current rotation angle, in degrees, of the display object along the z-axis, since the previous gesture event. 
		 */		
		public var rotation : Number;
		
		/**
		 * A value from the GesturePhase class indicating the progress of the touch gesture.
		 * For most gestures, the value is begin, update, or end. For the swipe and two-finger
		 * tap gestures, the phase value is always all once the event is dispatched. Use this
		 * value to determine when an event handler responds to a complex user interaction, or
		 * responds in different ways depending on the current phase of a multi-touch gesture
		 * (such as expanding, moving, and "dropping" as a user touches and drags a visual object
		 * across a screen). 
		 */		
		public var phase : String;
		
		
		/**
		 * Create a new GestureEvent3D object.
		 * @param type The type of the MouseEvent3D.
		 */
		public function GestureEvent3D(type : String)
		{
			super(type, true, true);
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
			result.scaleX = scaleX;
			result.scaleY = scaleY;
			result.offsetX = offsetX;
			result.offsetY = offsetY;
			result.rotation = rotation;
			result.phase = phase;
			
			return result;
		}
	}
}