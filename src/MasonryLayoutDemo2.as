package 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.math.PlaneClassification;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.InteractiveSpritePlane;
	import away3d.primitives.Plane;
	import away3d.tools.utils.Bounds;
	
	import com.app.MasonryLayout;
	import com.app.Tile145x145;
	import com.app.Tile300x145;
	import com.app.Tile300x300;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MasonryLayoutDemo2 extends Sprite
	{
		//-----------------------------------------------------------------
		// Away3D4 Vars
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var lens:PerspectiveLens;
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
		private const antiAlias:Number = 2;
		private const cameraNear:Number = 20; // 20 is default
		private const cameraViewDistance:Number = 20000;
		private const lensFieldOfView:Number = 60; // 60 is default
		private const cameraDistance:Number = 2100;
		
		// Primitives etc
		private var container:ObjectContainer3D;
		private var canvas:ObjectContainer3D;
		private var spritePlanes:Array;		// an array of value objects that contain an array of InteractiveSpritePlanes;
		private const numBigPlanes:uint = 5;
		private const numMedPlanes:uint = 48;
		private const numSmallPlanes:uint = 35;
		private const spritePlaneCount:uint = numBigPlanes + numMedPlanes + numSmallPlanes;
		private var planes:Vector.<InteractiveSpritePlane>;
		
		private var cells:Array;			// an array of laid-out cells in an ObjectContainer3D
		private var cellIndex:uint = 0;
		private var lastX:Number = 0;
		
		// Layout
		private var isCentered:Boolean;
		private var cols:int = 30;
		private var colPad:int = 50;
		private var rowPad:int = 50;
		private var indexOfWhereWeRanOutOfRoom:uint;
		
		private var layout:MasonryLayout;
		
		// --------------------------------------------------------------------------------------------------------------
		
		public function MasonryLayoutDemo2()
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
			trace("init")
			
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
			lens = new PerspectiveLens(lensFieldOfView);
			camera.lens = lens;
			camera.lens.far = cameraViewDistance;
			camera.lens.near = cameraNear;
			
			// Setup view
			view = new View3D();
			view.scene = scene;
			view.camera = camera;
			view.antiAlias = antiAlias;
			view.backgroundColor = 0x333333;
			addChild(view);
			
			// Setup a HoverController (aka HoverCamera3D in older versions of Away3D)
			cameraController = new HoverController(camera, null, 180.1, 0.1, cameraDistance);
			
			
			// Show Away3D stats
			stats = new AwayStats(view,true);
			stats.x = 5;
			stats.y = 5;
			this.addChild(stats);
			
			// Show a Trident
			trident = new Trident();
			trident.scale(1);
			scene.addChild(trident);
		}
		
		private function setupPrimitivesAndModels():void
		{
			// create your first plane, ensuring that it's big
			planes = new Vector.<InteractiveSpritePlane>();
			var plane:InteractiveSpritePlane = new InteractiveSpritePlane();
			plane.init(new Tile300x300(), false, true, false);
			planes.push(plane);
			
			// the others are random
			for (var i:int = 0; i < 40; i++)
			{
				plane = new InteractiveSpritePlane();
				var r:Number = Math.random();
				if (r < 0.2)
				{
					plane.init(new Tile300x300(), false, true, false);
				} 
				else if (r >= 0.2 && r < 0.6)
				{
					plane.init(new Tile300x145(), false, true, false);
				} 
				else 
				{
					plane.init(new Tile145x145(), false, true, false);
				}
				planes.push(plane);
			}
			
			
			// give the planes a layout
			// Rob: you'll probably want to make the layout wider than it is tall since that sort of reflects Stella's design
			layout = new MasonryLayout(6, 4, 145, 145, 10, 10);
			indexOfWhereWeRanOutOfRoom = layout.placeItems(planes, "justifiedtopleft");
			
			
			// create a container for everything and give it a background so we
			// can make sure we're properly centered
			container = new ObjectContainer3D();
			var background:Plane = new Plane(new ColorMaterial(0xFF0000, .3), 1000, 745, 1, 1, false);
			background.z = 10;
			container.addChild(background);
			scene.addChild(container);
			
			// create a canvas and add all the layed out content to it.
			// then add the canvas to the container
			canvas = new ObjectContainer3D();
			//planes.splice(indexOfWhereWeRanOutOfRoom, (planes.length - indexOfWhereWeRanOutOfRoom));
			for (var j:int = 0; j < indexOfWhereWeRanOutOfRoom; j++) 
			{
				canvas.addChild(planes[j]);	
			}
			container.addChild(canvas);
			
			
			
			// figure out the size of the canvas
			Bounds.getObjectContainerBounds(canvas);
			var canvasBackground:Plane = new Plane(new ColorMaterial(0x0000FF, .5), Bounds.width, Bounds.height, 1, 1, false);
			canvasBackground.z = 10;
			canvasBackground.x = Bounds.width / 2;
			canvasBackground.y = -(Bounds.height / 2);
			canvas.addChild(canvasBackground);
			isCentered = true;
			canvas.x -= Bounds.width / 2;
			canvas.y += Bounds.height / 2;
		}
		
		private function setupEventListeners():void
		{
			// Setup event listeners
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			// Setup render enter frame event listener
			stage.addEventListener(Event.ENTER_FRAME,renderHandler);
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			/*
			if (!isCentered)
			{
				isCentered = true;
				canvas.x -= Bounds.width / 2;
				canvas.y += Bounds.height / 2;
			}
			else
			{
				isCentered = false;
				canvas.x += Bounds.width / 2;
				canvas.y -= Bounds.height / 2;
			}
			*/
			for(var j:int=0; j < indexOfWhereWeRanOutOfRoom; j++){
				canvas.removeChild(planes[j]);
			}
			
			layout.clearGrid();
			indexOfWhereWeRanOutOfRoom = layout.placeItems(planes, "justifiedtopleft");
			
			for (var j:int = 0; j < indexOfWhereWeRanOutOfRoom; j++) 
			{
				canvas.addChild(planes[j]);	
			}
		}
		
		private function renderHandler(e:Event):void
		{			
			if (move)
			{
				cameraController.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			
			
			view.render();
		}
	}
}