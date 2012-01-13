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
	import flash.events.MouseEvent;
	
	public class Pooling1 extends Sprite
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
		private var colorMaterial:ColorMaterial;
		
		// Fountain properties
		private var count:int = 1000;
		private var gravity:Number = -0.5;
		private var planes:Array = [];
		
		// --------------------------------------------------------------------------------------------------------------
		
		public function Pooling1()
		{
			// Listen for this to be added to the stage to ensure we have access to the stage
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			// We have been added to the stage and now need to clean up that event listener
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			// Setup the stage
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
			cameraController = new HoverController(camera, null, 180.1, 0.1, 2000);
			
			// Show Away3D stats
			stats = new AwayStats(view,true);
			stats.x = 5;
			stats.y = 5;
			addChild(stats);
		}
		
		private function setupMaterials():void
		{
			// Setup any materials
			colorMaterial = new ColorMaterial(0x0000FF);
		}
		
		private function setupPrimitivesAndModels():void
		{
			for (var i:int = 0; i < count; i++) 
			{
				var plane:Plane = new Plane(colorMaterial, 100, 100, 1, 1, false);
				plane.extra = {};
				plane.extra.vx = Math.random() * 50 - 25;
				plane.extra.vy = Math.random() * -10 - 10; // random value between -10 and -20
				scene.addChild(plane);
				planes.push(plane);
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function setupEventListeners():void
		{
			// Setup render enter frame event listener
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			// If the plane has flown off the screen then
			// set it back to the base of the fountain
			// and reinitialize it's velocity
			var len:int = planes.length;
			for (var i:int = 0; i < len; i++) 
			{
				var plane:Plane = Plane(planes[i]);
				plane.extra.vy += gravity;
				plane.x += plane.extra.vx;
				plane.y += plane.extra.vy;
				if (plane.y < -3000)
				{
					plane.x = 0;
					plane.y = 0;
					plane.extra.vx = Math.random() * 50 - 25;
					plane.extra.vy = Math.random() * -10 - 10;
				}
			}
			
			view.render();
		}
	}
}