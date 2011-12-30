package 
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Plane;
	import away3d.tools.utils.Bounds;
	
	import com.inchworm.RandomMotionClip;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class LotsOfTransparentBitmaps extends Sprite
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
		
		// Sources
		private var sourceClip:Sprite;
		private var bmd:BitmapData;
		private var eraser:BitmapData;
		
		// Materials
		private var planeMaterial:BitmapMaterial;
		
		// Primitives etc
		private var container:ObjectContainer3D;
		private var planes:Vector.<Plane>;
		private var planeCount:int = 1000;
		
		// Layout
		private var cols:int = 30;
		private var colPad:int = 50;
		private var rowPad:int = 50;
		
		// --------------------------------------------------------------------------------------------------------------
		
		public function LotsOfTransparentBitmaps()
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
			view.backgroundColor = 0x333333;
			addChild(view);
			
			// Setup a HoverController (aka HoverCamera3D in older versions of Away3D)
			cameraController = new HoverController(camera, null, 150, 10, 2000);
			
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
		
		private function setupMaterials():void
		{
			// Setup the sprite that we'll source from
			sourceClip = new RandomMotionClip();
			bmd = new BitmapData(sourceClip.width, sourceClip.height, true, 0x00000000);
			bmd.draw(sourceClip, null, null, null, null, true);
			eraser = new BitmapData(sourceClip.width, sourceClip.height, true, 0x00000000);
			
			// Setup bitmap material
			planeMaterial = new BitmapMaterial(bmd, true);
			planeMaterial.alphaBlending = true;
		}
		
		private function setupPrimitivesAndModels():void
		{
			container = new ObjectContainer3D();
			planes = new Vector.<Plane>();
			
			// Layout the planes in a grid
			for (var i:int = 0; i < planeCount; i++) 
			{
				var plane:Plane = new Plane(planeMaterial, 256, 256, 1, 1);
				plane.x = plane.width * (i % cols) + ((i % cols) * colPad); 
				plane.y = plane.width * int(i / cols) + (int(i / cols) * rowPad);
				plane.rotationX = -90;
				container.addChild(plane);
				planes.push(plane);
			}
			
			Bounds.getObjectContainerBounds(container);
			var width:Number = Bounds.width;
			var depth:Number = Bounds.depth;
			var height:Number = Bounds.height;
			container.x = -(width / 2);
			container.y = -(height / 2);
			
			scene.addChild(container);
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
			if (move)
			{
				cameraController.panAngle = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			
			bmd.copyPixels(eraser, eraser.rect, new Point(0,0), eraser);
			bmd.draw(sourceClip, null, null, null, null, true);
			planeMaterial.updateTexture();
			view.render();
		}
		
		private function mouseDownHandler(e:MouseEvent):void
		{
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onStageMouseLeave(e:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function resizeHandler(e:Event=null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
	}
}