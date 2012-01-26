package 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.entities.SegmentSet;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.LineSegment;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	import away3d.primitives.WireframeAxesGrid;
	
	import com.inchworm.TimelineCellView;
	import com.inchworm.TimelineView;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	public class DraggableTimeline extends Sprite
	{
		//-----------------------------------------------------------------
		// Away3D4 Vars
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:HoverController;
		
		// Away3D Helpers
		private var stats:AwayStats;
		private var trident:Trident;
		
		// Away3D Config
		private var cameraViewDistance:Number = 100000;
		private var antiAlias:Number = 2;
		
		// Primitives etc
		private var plane:Plane;
		private var timeline:TimelineView;
		
		// Frustum
		private var maxWidth			:Number;
		private var maxHeight			:Number;
		
		// Velocity
		private var vx					:Number = 0;
		private var oldX				:Number = 0;
		private var friction			:Number = 0.9;
		
		// Mouse Controls
		private var isDragging			:Boolean;
		
		// -----------------------------------------------------------------
		
		public function DraggableTimeline()
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
			setupPrimitivesAndModels();
			setupEventListeners();
			calculateFrustum();
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
			cameraController = new HoverController(camera, null, -180.1, 0.1, 750);
			
			// Show Away3D stats
			stats = new AwayStats(view,true);
			stats.x = 5;
			stats.y = 5;
			this.addChild(stats);
		}
		
		private function setupPrimitivesAndModels():void
		{
			timeline = new TimelineView();
			scene.addChild(timeline);
			
//			plane = new Plane(new ColorMaterial(0xFF0000), 100, 100, 1, 1, false);
//			plane.x = 200;
//			scene.addChild(plane);
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
		
		private function calculateFrustum():void
		{
			// dist is the distance from the camera
			// so if you want the size of the frustum with the default camera 0,0,-1000 and set dist =1000
			//Then maxheight,maxwidth gives the height,width of the frustum at z=0
			// At dist = 1500 and camera.distance at 1000 would give you height of the frustum at z=500
			// http://away3d.com/forum/viewthread/1662/
			// http://away3d.com/forum/viewthread/797/ (scroll down for diagram)
			var dist:Number = cameraController.distance;
			maxHeight = Math.tan((PerspectiveLens(view.camera.lens).fieldOfView * 0.5) * Math.PI / 180) * dist * 2;
			maxWidth = maxHeight * (view.width / view.height);
			// remember the maxWidth applies in both the positive AND NEGATIVE direction.
			
			//eg
			//plane.x = (.5 * maxWidth) - maxWidth / 2; // put a plane in the center of the screen
		}
		
		private function renderHandler(e:Event):void
		{
			if (isDragging)
			{
				var gesturePercent:Number = stage.mouseX / stage.stageWidth;
				var gesturePositionX:Number = (gesturePercent * maxWidth) - maxWidth / 2; 
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
			var gesturePercent:Number = stage.mouseX / stage.stageWidth;
			var gesturePositionX:Number = (gesturePercent * maxWidth) - maxWidth / 2;
			oldX = gesturePositionX;
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
	}
}