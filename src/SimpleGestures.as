package 
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Plane;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class SimpleGestures extends Sprite
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
		
		// Materials
		private var planeMaterial:ColorMaterial;
		
		// Primitives etc
		private var plane:Plane;
		
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
			//stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
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
			this.addChild(stats);
			
			// Show a Trident
			trident = new Trident();
			trident.scale(1);
			scene.addChild(trident);
		}
		
		private function setupMaterials():void
		{
			// Setup the planes material
			planeMaterial = new ColorMaterial(0x00FFCC);
		}
		
		private function setupPrimitivesAndModels():void
		{
			// Setup the plane
			plane = new Plane(planeMaterial, 500, 500);
			plane.rotationX = -90;
			plane.mouseEnabled = true;
			plane.mouseDetails = true;
			scene.addChild(plane);
		}
		
		private function setupEventListeners():void
		{
			// Setup resize handler
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler(); // Good to run the resizeHandler to ensure everything is in its place
			
			// Setup render enter frame event listener
			stage.addEventListener(Event.ENTER_FRAME,renderHandler);
		}
		
		private function renderHandler(e:Event):void
		{			
			view.render();
		}
		
		private function resizeHandler(e:Event=null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
	}
}