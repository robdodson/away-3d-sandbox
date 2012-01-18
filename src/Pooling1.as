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
	
	import com.inchworm.pools.PlanePool;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
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

		// Collections
		private var planes						:Array = [];
		private var length						:int = 0;
		
		// Pools
		private var planePool					:PlanePool;
		
		// Logging
		private var log							:TextField;
		
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
		}
		
		private function setupPrimitivesAndModels():void
		{
			var format:TextFormat = new TextFormat();
			format.color = 0xFFFFFF;
			format.size = 20;
			log = new TextField();
			log.defaultTextFormat = format;
			log.autoSize = TextFieldAutoSize.LEFT;
			log.x = 20;
			addChild(log);
			
			planePool = new PlanePool(1000);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function setupEventListeners():void
		{
			// Setup render enter frame event listener
			stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var plane:Plane;
			
			for (var i:int = 0; i < 2; i++)
			{
				plane = planePool.checkOut();
				plane.x = Math.random() * stage.stageWidth;
				plane.y = Math.random() * stage.stageHeight;
				scene.addChild(plane);
				planes.push(plane);
				length++;
			}
			
			for (i = length - 1; i > -1; i--) 
			{
				plane = planes[i];
				ColorMaterial(plane.material).alpha -= 0.01;
				if (ColorMaterial(plane.material).alpha <= 0)
				{
					scene.removeChild(plane);
					planes.splice(i, 1);
					length--;
					planePool.checkIn(plane);
				}
			}
			
			log.text = "Planes on screen: " + length + "\nPool size: " + planePool.poolSize;
			
			view.render();
		}
	}
}