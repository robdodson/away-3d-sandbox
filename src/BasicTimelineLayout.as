package 
{
	import away3d.cameras.Camera3D;
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
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	public class BasicTimelineLayout extends Sprite
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
		private var numCells:int = 6;
		private var cells:Array;
		
		// Vectors
		private var datelineStart:Vector3D;
		private var datelineEnd:Vector3D;
		
		// Velocity
		private var vx:Number = 0;
		private var oldX:Number = 0;
		private var friction:Number = 0.9;
		
		// Mouse Controls
		private var isDragging:Boolean;
		
		// --------------------------------------------------------------------------------------------------------------
		
		public function BasicTimelineLayout()
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
			cameraController = new HoverController(camera, null, 180.3, 1.5, 100);
			
			// Show Away3D stats
			stats = new AwayStats(view,true);
			stats.x = 5;
			stats.y = 5;
			this.addChild(stats);
			
			// Show a Trident
			//trident = new Trident();
			//trident.scale(1);
			//scene.addChild(trident);
		}
		
		private function setupPrimitivesAndModels():void
		{
			// Setup the primitives
			cells = new Array();
			var firstCell:TimelineCellView = new TimelineCellView();
			firstCell.x = -100;
			cells.push(firstCell);
			scene.addChild(firstCell);
			
			for (var i:int = 1; i < numCells; i++) 
			{
				var cell:TimelineCellView = new TimelineCellView();
				var prevCell:TimelineCellView = cells[i - 1];
				cell.x = prevCell.x + prevCell.width; 
				cells.push(cell);
				scene.addChild(cell);
			}
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
		
		private function renderHandler(e:Event):void
		{
			/*
			if (isDragging)
			{
				datelineStart.x = datelineEnd.x = 180 * (stage.mouseX / stage.stageWidth) - 90; // TODO need to nail down this ratio of camera viewing angle to stage width
				vx = datelineStart.x - oldX;
				oldX = datelineStart.x;
			}
			else
			{
				if (datelineStart.x < -100)
				{
					datelineStart.x = 100;
				}
				
				if (datelineStart.x > 100)
				{
					datelineStart.x = -100;
				}
				
				vx *= friction;
				datelineStart.x += vx;
				datelineEnd.x = datelineStart.x;
			}
			
			datelineSegment.updateSegment(datelineStart, datelineEnd, new Vector3D(0, 0, 0), 0xFFFFFF, 0xFFFFFF, 2);
			*/
			view.render();
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			//oldX = datelineStart.x;
			//isDragging = true;
			//stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			//isDragging = false;
			//stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onStageMouseLeave(e:Event):void
		{
			//isDragging = false;
			//stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function resizeHandler(e:Event=null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
	}
}