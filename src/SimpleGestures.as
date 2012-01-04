package 
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.base.Object3D;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.events.GestureEvent3D;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Plane;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SimpleGestures extends Sprite
	{
		//-----------------------------------------------------------------
		// Away3D4 Vars
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:HoverController;
		
		// Away3D4 Camera handling variables (Hover Camera)
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		// Away3D Helpers
		private var stats:AwayStats;
		private var trident:Trident;
		
		// Away3D Config
		private var cameraViewDistance:Number = 100000;
		private var antiAlias:Number = 2;
		
		// Materials
		
		// Primitives etc
		private var plane1:Plane;
		private var plane2:Plane;
		
		// --------------------------------------------------------------------------------------------------------------
		
		public function SimpleGestures()
		{
			// Listen for this to be added to the stage to ensure we have access to the stage
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			// We have been added to the stage and now need to clean up that event listener
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			// Setup the stage
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Init
			init();
		}
		
		private function init():void
		{
			// Lets get busy
			setupAway3D4();
			setupMaterials();
			setupPrimitivesAndModels();
			setupEventListeners();
		}
		
		private function setupAway3D4():void
		{
			// Setup scene
			scene = new Scene3D();
			
			// Setup camera
			camera = new Camera3D();
			camera.lens.far = cameraViewDistance;
			
			// Setup view
			view = new View3D();
			view.scene = scene;
			view.camera = camera;
			view.antiAlias = antiAlias;
			addChild(view);
			
			// Setup a HoverController (aka HoverCamera3D in older versions of Away3D)
			cameraController = new HoverController(camera, null, 150, 10, 2000);
			
			// Show Away3D stats
			stats = new AwayStats(view,true);
			stats.x = 5;
			stats.y = 5;
			//this.addChild(stats);
			
			// Show a Trident
			trident = new Trident();
			trident.scale(1);
			scene.addChild(trident);
		}
		
		private function setupMaterials():void
		{
			// Setup any materials
		}
		
		private function setupPrimitivesAndModels():void
		{
			// Setup the planes
			plane1 = new Plane(new ColorMaterial(Math.random() * 0xFFFFFF), 500, 500);
			plane1.yUp = false;
			plane1.mouseEnabled = true;
			plane1.mouseDetails = true;
			scene.addChild(plane1);
			
			plane2 = new Plane(new ColorMaterial(Math.random() * 0xFFFFFF), 500, 500);
			plane2.yUp = false;
			plane2.mouseEnabled = true;
			plane2.mouseDetails = true;
			plane2.x = 1000;
			plane2.y = 500;
			plane2.z = 10;
			scene.addChild(plane2);
		}
		
		private function setupEventListeners():void
		{
			// Setup mesh handlers
			plane1.addEventListener(MouseEvent3D.CLICK, onClick);
			plane1.addEventListener(GestureEvent3D.GESTURE_PAN, onGesturePan);
			plane1.addEventListener(GestureEvent3D.GESTURE_ROTATE, onGestureRotate);
			plane1.addEventListener(GestureEvent3D.GESTURE_SWIPE, onGestureSwipe);
			plane1.addEventListener(GestureEvent3D.GESTURE_ZOOM, onGestureZoom);

			plane2.addEventListener(MouseEvent3D.CLICK, onClick);
			plane2.addEventListener(GestureEvent3D.GESTURE_PAN, onGesturePan);
			plane2.addEventListener(GestureEvent3D.GESTURE_ROTATE, onGestureRotate);
			plane2.addEventListener(GestureEvent3D.GESTURE_SWIPE, onGestureSwipe);
			plane2.addEventListener(GestureEvent3D.GESTURE_ZOOM, onGestureZoom);
			
			// Setup camera handlers
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			// Setup resize handler
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(); // Good to run the resizeHandler to ensure everything is in its place
			
			// Setup render enter frame event listener
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onClick(event:MouseEvent3D):void
		{
			trace(this, "click!!!");
		}
		
		private function onGesturePan(event:GestureEvent3D):void
		{
			var target:Object3D = event.object;
			target.x += event.offsetX * 5; // rd: not sure if this is how you're supposed to use panning gestures
			target.y -= event.offsetY * 5;
		}
		
		private function onGestureRotate(event:GestureEvent3D):void
		{
			var target:Object3D = event.object;
			target.rotationZ -= event.rotation;
		}
		
		private function onGestureSwipe(event:GestureEvent3D):void
		{
			trace(this, "swipped!");
			var target:Object3D = event.object;
		}
		
		private function onGestureZoom(event:GestureEvent3D):void
		{
			trace(this, event.scaleX);
			var target:Object3D = event.object;
			target.scaleX *= event.scaleX;
			target.scaleY = target.scaleX;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onStageMouseLeave(e:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (move) {
				cameraController.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			
			view.render();
		}
		
		private function onResize(e:Event=null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
	}
}