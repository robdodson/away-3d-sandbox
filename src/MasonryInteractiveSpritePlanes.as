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
	import away3d.primitives.InteractiveSpritePlane;
	import away3d.primitives.Plane;
	import away3d.tools.utils.Bounds;
	
	import com.app.MasonryLayout;
	import com.app.Tile145x145;
	import com.app.Tile300x145;
	import com.app.Tile300x300; 
	import com.app.Tile128x128;
	import com.app.Tile256x128;
	import com.app.Tile256x256;

	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MasonryInteractiveSpritePlanes extends Sprite
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
		
		private var spritePlanes:Vector.<InteractiveSpritePlane>;		// an array of value objects that contain an array of InteractiveSpritePlanes;
		private const numBigPlanes:uint = 5;
		private const numMedPlanes:uint = 48;
		private const numSmallPlanes:uint = 35;
		private const spritePlaneCount:uint = numBigPlanes + numMedPlanes + numSmallPlanes;
		
		private var cells:Array;			// an array of laid-out cells in an ObjectContainer3D
		private var cellIndex:uint = 0;
		private var lastX:Number = 0;
		
		// Layout
		private var cols:int = 30;
		private var colPad:int = 50;
		private var rowPad:int = 50;
		
		private var layout:MasonryLayout;
		
		// --------------------------------------------------------------------------------------------------------------
		
		public function MasonryInteractiveSpritePlanes()
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
			lens = new PerspectiveLens(lensFieldOfView);
			camera.lens = lens;
			camera.lens.far = cameraViewDistance;
			camera.lens.near = cameraNear;
			
			
			trace("near: "+camera.lens.near);
			
			
			// Setup view
			view = new View3D();
			view.scene = scene;
			view.camera = camera;
			view.antiAlias = antiAlias;
			view.backgroundColor = 0x333333;
			addChild(view);
			
			// Setup a HoverController (aka HoverCamera3D in older versions of Away3D)
			cameraController = new HoverController(camera, null, 150, 10, cameraDistance);
			
			
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
			
			
		}
		
		private function setupPrimitivesAndModels():void
		{
			container = new ObjectContainer3D();
			
			spritePlanes = new Vector.<InteractiveSpritePlane>();
			cells = new Array();
			cellIndex = 0;
			lastX = 0;
			
			// Instantiate layout - can be reused if we're sticking with the same dimensions each time.
			// args: numCols, numRows, cellWidth, cellHeight, paddingX, paddingY
			layout = new MasonryLayout(14,8,128,128,0,0);
			
			cells.push(new ObjectContainer3D());
			container.addChild(cells[cellIndex]);
			
			var i:int=0;
			// instantiate spritePlanes
			
			/*
			// sorted order
			for (i = 0; i < numBigPlanes; i++){
				var plane:InteractiveSpritePlane = new InteractiveSpritePlane();
				
				plane.init(new Tile300x300(), false, true, false);
				plane.rotationX = -90;
				
				spritePlanes.push(plane);
			}
			
			for (i = 0; i < numMedPlanes; i++){
				plane = new InteractiveSpritePlane();
				
				plane.init(new Tile300x145(), false, true, false);
				plane.rotationX = -90;
				
				spritePlanes.push(plane);
			}
			for (i = 0; i < numSmallPlanes; i++){
				plane = new InteractiveSpritePlane();
				
				plane.init(new Tile145x145(), false, true, false);
				plane.rotationX = -90;
				
				spritePlanes.push(plane);
			}
			*/
			
			// make sure the first one is big
			var plane:InteractiveSpritePlane = new InteractiveSpritePlane();
			
			plane.init(new Tile256x256(), false, true, false);
			plane.rotationX = -90;
			
			spritePlanes.push(plane);
			
			// the others are random
			for (i=0; i < spritePlaneCount - 1; i++){
				plane = new InteractiveSpritePlane();
				
				var r:Number = Math.random();
				
				if (r < 0.2){
					plane.init(new Tile256x256(), false, true, false);
				} else if (r >= 0.2 && r < 0.6){
					plane.init(new Tile256x128(), false, true, false);
				} else {
					plane.init(new Tile128x128(), false, true, false);
				}
				plane.rotationX = -90;
				
				spritePlanes.push(plane);
			}
			
			// tile planes into masonry (if we run out of room, create a new cell)
			do {
				var d:Date = new Date();
				trace("** STARTING LAYOUT "+cellIndex+" -- ms: "+d.milliseconds);
				
				layout.clearGrid();
				
				// will return the index in your array where you ran out of room.
				// feel free to change that to a vector if you like...
				var amountSuccessfullyPlacedThisCell:uint = layout.placeItems(spritePlanes, true);
				
				
				
				d = new Date();
				trace("** ENDING LAYOUT "+cellIndex+" -- ms: "+d.milliseconds);
				
				trace("amountSuccessfullyPlacedThisCell: "+amountSuccessfullyPlacedThisCell);
				
				for (i=0; i < amountSuccessfullyPlacedThisCell; i++){
					cells[cellIndex].addChild(spritePlanes[i]);
				}
				spritePlanes.splice(0,amountSuccessfullyPlacedThisCell);
				
				
				Bounds.getObjectContainerBounds(cells[cellIndex]);
				trace("bounds: "+Bounds);
				var width:Number = Bounds.width;
				var depth:Number = Bounds.depth;
				var height:Number = Bounds.height;
				
				trace("cells["+cellIndex+"] w/h/d: "+width+", "+height+", "+depth);
				
				cells[cellIndex].x = lastX;
				cells[cellIndex].y = 0;
				trace("lastX: "+lastX);
				lastX = lastX + width + 300;
				//cells[cellIndex].y = (height / 2);
				
				if (spritePlanes.length > 0){
					cells[++cellIndex] = new ObjectContainer3D();
				}
				container.addChild(cells[cellIndex]);
				
				
				
			} while (spritePlanes.length > 0);
			
			
			
			Bounds.getObjectContainerBounds(container);
			width = Bounds.width;
			depth = Bounds.depth;
			height = Bounds.height;
			//container.x = -(lastX / 2);
			//container.y = -(height); //(height / 2);
			
			trace("container x/y: "+container.x+", "+container.y);
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