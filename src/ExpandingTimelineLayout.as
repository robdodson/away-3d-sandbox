package 
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Plane;
	import away3d.tools.Merge;
	import away3d.tools.MeshHelper;
	import away3d.tools.utils.Bounds;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.inchworm.TimelineView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	
	public class ExpandingTimelineLayout extends Sprite
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
		private var planes				:Vector.<Plane>;
		private var timeline			:ObjectContainer3D;
		private var targetIndex			:int;
		
		// -----------------------------------------------------------------
		
		public function ExpandingTimelineLayout()
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
			cameraController = new HoverController(camera, null, -180.1, 0.1, 1000);
			
			// Show Away3D stats
			stats = new AwayStats(view,true);
			stats.x = 5;
			stats.y = 5;
			this.addChild(stats);
		}
		
		private function setupPrimitivesAndModels():void
		{
			timeline = new ObjectContainer3D();
			planes = new Vector.<Plane>();
			for (var i:int = 0; i < 10	; i++) 
			{
				var plane:Plane = new Plane(new ColorMaterial(0xFF0000), 100, 100, 1, 1, false);
				if (i > 0)
				{
					var prevPlane:Plane = planes[i - 1];
					plane.x = prevPlane.x + prevPlane.width + 10;
					var matrix:Matrix3D = new Matrix3D();
				}
				plane.mouseEnabled = true;
				plane.addEventListener(MouseEvent3D.CLICK, onClick);
				planes.push(plane);
				timeline.addChild(plane);
			}
			Bounds.getObjectContainerBounds(timeline);
			timeline.x = -(Bounds.width / 2) + plane.width / 2;
			scene.addChild(timeline);
		}
		
		private function setupEventListeners():void
		{
			// Setup render enter frame event listener
			stage.addEventListener(Event.ENTER_FRAME, renderHandler);
		}
		
		private function onClick(e:MouseEvent3D):void
		{
			for (var i:int = 0; i < planes.length; i++) 
			{
				if (e.target == planes[i])
				{
					targetIndex = i;
				}
			}
			
			if (planes[targetIndex].width < 300)
			{
				TweenLite.to(planes[targetIndex], 1.2, { width: 300, ease: Elastic.easeInOut, onUpdate: positionPlanes });
			}
			else
			{
				TweenLite.to(planes[targetIndex], 1.2, { width: 100, ease: Elastic.easeInOut, onUpdate: positionPlanes });
			}
		}
		
		private function positionPlanes():void
		{
			for (var i:int = 0; i < planes.length; i++) 
			{
				if (i < targetIndex)
				{
					// Point the loop the other direction so it counts down from the expanding point.
					// ex: If the targetIndex is 5 and we know it has already changed it's width then count
					// down from 4 and update in that direction. This makes the for loop bi-directional
					var k:int = targetIndex - 1 - i; 
					planes[k].x = planes[k + 1].x - planes[k + 1].width / 2 - planes[k].width / 2 - 10;
				}
				else if (i > targetIndex)
				{
					planes[i].x = planes[i - 1].x + planes[i - 1].width / 2 + planes[i].width / 2 + 10;
				}
			}
		}
		
		private function renderHandler(e:Event):void
		{
			view.render();
		}
	}
}