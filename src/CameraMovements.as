package
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	
	import com.inchworm.TimelineView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import uk.co.soulwire.gui.SimpleGUI;
	
	public class CameraMovements extends Sprite
	{
		//-----------------------------------------------------------------
		// Away3D4 Vars
		public var scene:Scene3D;
		public var camera:Camera3D;
		public var view:View3D;
		public var cameraController:HoverController;
		
		// Away3D Config
		private var cameraViewDistance:Number = 100000;
		private var antiAlias:Number = 2;
		
		// Primitives etc
		private var timeline:TimelineView;
		
		// Velocity
		private var vx					:Number = 0;
		private var oldX				:Number = 0;
		private var friction			:Number = 0.9;
		
		// Mouse Controls
		private var isDragging			:Boolean;
		
		// -----------------------------------------------------------------
		
		private var _gui:SimpleGUI;
		public var obj:Object;
		
		public function CameraMovements()
		{
			super();

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
			setupPrimitivesAndModels();
			setupEventListeners();
			setupGUI();
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
			cameraController = new HoverController(camera, null, -220, 0.1, 100);
		}
		
		private function setupPrimitivesAndModels():void
		{
			timeline = new TimelineView();
			scene.addChild(timeline);
		}
		
		private function setupEventListeners():void
		{
			// Setup event listeners
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			// Setup resize handler
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler(); // Good to run the resizeHandler to ensure everything is in its place
			
			// Setup render enter frame event listener
			stage.addEventListener(Event.ENTER_FRAME,renderHandler);
		}
		
		private function renderHandler(e:Event):void // TODO: Break this into separate handlers
		{
			if (isDragging)
			{
				var gesturePositionX:Number = 180 * (stage.mouseX / stage.stageWidth) - 90; // TODO need to nail down this ratio of camera viewing angle to stage width
				vx = gesturePositionX - oldX;
				oldX = gesturePositionX;
			}
			else
			{
				vx *= friction;
			}
			
			timeline.moveCells(vx);
			
			view.render();
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			oldX = 180 * (stage.mouseX / stage.stageWidth) - 90;
			isDragging = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			isDragging = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onStageMouseLeave(e:Event):void
		{
			isDragging = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function resizeHandler(e:Event=null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
		
		private function setupGUI():void
		{
			_gui = new SimpleGUI(this, "Camera Controls", "c");
			_gui.addGroup("Camera");
			_gui.addStepper("camera.x", -5000, 5000);
			_gui.addStepper("camera.y", -5000, 5000);
			_gui.addStepper("camera.z", -5000, 5000);
			_gui.addColumn("Camera Controller");
			_gui.addStepper("cameraController.distance", 0, 5000, {label: "Distance"});
			_gui.addStepper("cameraController.panAngle", -360, 360, {label: "Pan Angle"});
			_gui.addStepper("cameraController.tiltAngle", -360, 360, {label: "Tilt Angle"});
		}
	}
}