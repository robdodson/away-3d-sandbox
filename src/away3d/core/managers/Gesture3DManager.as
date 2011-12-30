package away3d.core.managers
{
	import away3d.arcane;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.IRenderable;
	import away3d.core.base.Object3D;
	import away3d.core.render.HitTestRenderer;
	import away3d.core.traverse.EntityCollector;
	import away3d.entities.Entity;
	import away3d.events.GestureEvent3D;
	import away3d.events.MouseEvent3D;
	
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Vector3D;
	
	use namespace arcane;
	
	/**
	 * Mouse3DManager provides a manager class for detecting 3D mouse hits and sending out mouse events.
	 *
	 * todo: first check if within view bounds
	 */
	public class Gesture3DManager
	{
		private var _previousActiveObject : Object3D;
		private var _previousActiveRenderable : IRenderable;
		private var _activeObject : Entity;
		private var _activeRenderable : IRenderable;
		private var _oldLocalX : Number;
		private var _oldLocalY : Number;
		private var _oldLocalZ : Number;
		
		private var _hitTestRenderer : HitTestRenderer;
		private var _view : View3D;
		
		private static var _gesturePan : GestureEvent3D = new GestureEvent3D(GestureEvent3D.GESTURE_PAN);
		private static var _gestureRotate : GestureEvent3D = new GestureEvent3D(GestureEvent3D.GESTURE_ROTATE);
		private static var _gestureSwipe : GestureEvent3D = new GestureEvent3D(GestureEvent3D.GESTURE_SWIPE);
		private static var _gestureZoom : GestureEvent3D = new GestureEvent3D(GestureEvent3D.GESTURE_ZOOM);
		
		private var _queuedEvents : Vector.<GestureEvent3D> = new Vector.<GestureEvent3D>();
		
		/**
		 * Creates a Gesture3DManager object.
		 * @param view The View3D object for which the mouse will be detected.
		 * @param hitTestRenderer The hitTestRenderer that will perform hit-test rendering.
		 */
		public function Gesture3DManager(view : View3D)
		{
			_view = view;
			_hitTestRenderer = new HitTestRenderer(view);
			
			_view.addEventListener(TransformGestureEvent.GESTURE_PAN, onGesturePan);
			_view.addEventListener(TransformGestureEvent.GESTURE_ROTATE, onGestureRotate);
			_view.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onGestureSwipe);
			_view.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onGestureZoom);
		}
		
		arcane function get stage3DProxy() : Stage3DProxy
		{
			return _hitTestRenderer.stage3DProxy;
		}
		
		arcane function set stage3DProxy(value : Stage3DProxy) : void
		{
			_hitTestRenderer.stage3DProxy = value;
		}
		
		/**
		 * Clear all resources and listeners used by this Mouse3DManager.
		 */
		public function dispose() : void
		{
			_hitTestRenderer.dispose();
			_view.removeEventListener(TransformGestureEvent.GESTURE_PAN, onGesturePan);
			_view.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, onGestureRotate);
			_view.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onGestureSwipe);
			_view.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, onGestureZoom);
		}
		
		private function mouseInView() : Boolean
		{
			var mx : Number = _view.mouseX;
			var my : Number = _view.mouseY;
			
			return mx >= 0 && my >= 0 && mx < _view.width && my < _view.height;
		}
		
		/**
		 * Called when the user pans(?) an object
		 */
		private function onGesturePan(event : TransformGestureEvent) : void
		{
			if (mouseInView())
				queueDispatch(_gesturePan, event);
		}
		
		/**
		 * Called when the user rotates an object
		 */
		private function onGestureRotate(event : TransformGestureEvent) : void
		{
			if (mouseInView())
				queueDispatch(_gestureRotate, event);
		}
		
		/**
		 * Called when the user swipes(?) an object
		 */
		private function onGestureSwipe(event : TransformGestureEvent) : void
		{
			if (mouseInView())
				queueDispatch(_gestureSwipe, event);
		}
		
		/**
		 * Called when the user pinches/unpinches the stage
		 */
		private function onGestureZoom(event : TransformGestureEvent) : void
		{
			if (mouseInView())
				queueDispatch(_gestureZoom, event);
		}
		
		public function updateHitData() : void
		{
			if (mouseInView())
				getObjectHitData();
			else
				_activeRenderable = null;
		}
		
		/**
		 * Get the object hit information at the mouse position.
		 */
		private function getObjectHitData() : void
		{
			if (_queuedEvents.length == 0)
				return;
			
			_previousActiveObject = _activeObject;
			_previousActiveRenderable = _activeRenderable;
			
			
			var collector : EntityCollector = _view.entityCollector;
			
			// todo: would it be faster to run a custom ray-intersect collector instead of using entity collector's data?
			// todo: shouldn't render it every time, only when invalidated (on move or view render)
			if (collector.numMouseEnableds > 0) {
				_hitTestRenderer.update(_view.mouseX / _view.width, _view.mouseY / _view.height, collector);
				_activeRenderable = _hitTestRenderer.hitRenderable;
				_activeObject = (_activeRenderable && _activeRenderable.mouseEnabled) ? _activeRenderable.sourceEntity : null;
			}
			else {
				_activeObject = null;
				_activeRenderable = null;
			}
		}
		
		/**
		 * Sends out a GestureEvent3D based on the TransformGestureEvent that triggered it on the Stage.
		 * @param event3D The GestureEvent3D that will be dispatched.
		 * @param sourceEvent The MouseEvent that triggered the dispatch.
		 * @param renderable The IRenderable object that is the subject of the MouseEvent3D.
		 */
		private function dispatch(event3D : GestureEvent3D) : void
		{
			var renderable : IRenderable;
			var local : Vector3D = _hitTestRenderer.localHitPosition;
			
			// assign default renderable if it wasn't provide on queue time
			if (!(renderable = (event3D.renderable ||= _activeRenderable))) return;
			
			event3D.material = renderable.material;
			event3D.object = renderable.sourceEntity;
			
			if (renderable.mouseDetails && local) {
				event3D.uv = _hitTestRenderer.hitUV;
				event3D.localX = local.x;
				event3D.localY = local.y;
				event3D.localZ = local.z;
			}
			else {
				event3D.uv = null;
				event3D.localX = -1;
				event3D.localY = -1;
				event3D.localZ = -1;
			}
			
			// only dispatch from first implicitly enabled object (one that is not a child of a mouseChildren=false hierarchy)
			var dispatcher : ObjectContainer3D = renderable.sourceEntity;
			
			while (dispatcher && !dispatcher._implicitMouseEnabled) dispatcher = dispatcher.parent;
			dispatcher.dispatchEvent(event3D);
		}
		
		private function queueDispatch(event : GestureEvent3D, sourceEvent : TransformGestureEvent, renderable : IRenderable = null) : void
		{
			event.ctrlKey = sourceEvent.ctrlKey;
			event.altKey = sourceEvent.altKey;
			event.shiftKey = sourceEvent.shiftKey;
			event.scaleX = sourceEvent.scaleX;
			event.scaleY = sourceEvent.scaleY;
			event.offsetX = sourceEvent.offsetX;
			event.offsetY = sourceEvent.offsetY;
			event.rotation = sourceEvent.rotation;
			event.phase = sourceEvent.phase;
			event.renderable = renderable;
			event.screenX = _view.stage.mouseX;
			event.screenY = _view.stage.mouseY;
			
			_queuedEvents.push(event);
		}
		
		public function fireGestureEvents() : void
		{
			var len : uint = _queuedEvents.length;
			for (var i : uint = 0; i < len; ++i)
				dispatch(_queuedEvents[i]);
			
			_queuedEvents.length = 0;
		}
	}
}