package
{
	import away3d.materials.BitmapMaterial;
	
	import com.inchworm.lists.LinkedList;
	
	import flash.display.Sprite;
	
	[SWF(width="900", height="600", backgroundColor="#333333", frameRate="60")]
	public class Main extends Sprite
	{
		public function Main()
		{
			// Basic example of setting up
			// the stage in Away3D. Good
			// starting point for a sketch.
			//addChild(new SimpleView3D());
			
			// Basic example of loading a 
			// 3D model asset into Away3D
			// and displaying it on stage
			//addChild(new SimpleLoader3D());
			
			// Barebones setup for Away3D.
			// Adds a light, some primatives and
			// and a HoverCamera controller
			//addChild(new BasicPrimativesAndLights());
			
			// Toss a bunch of spheres on stage and
			// animate them with noise.
			//addChild(new SpherePulse());
			
			// Draw a simple plane in 3D space
			// with a hover camera
			//addChild(new SimplePlane());
			
			// Draw an animating movieclip
			// onto a bitmap material and
			// render it on a plane.
			//addChild(new BitmapPlane());
			
			// Draw several planes all running
			// off of the same MovieClip texture
			//addChild(new LotsOfBitmapPlanes());
			
			// Draw 100 random motion clips, with 100
			// unique bitmap draw calls, to 100 bitmapMaterials
			// added to 100 planes. Performance killer
			//addChild(new LotsOfMovieClipTextures());
			
			// Draw tons of transparent planes on
			// screen to test GPU performance. Doesn't
			// work on my MacBook Air
			//addChild(new LotsOfTransparentBitmaps());
			
			
			// Draw a BitmapMaterial with some text
			// This example works off of an already
			// made Flash layout in snippet.fla
			//addChild(new BitmapTextPlane());
			
			// Draw a plane that registers the mouse
			// position when it is clicked. Translate
			// the uv coords to the underlying movieclip
			// and tell it to draw a circle in the
			// corresponding x, y position
			//addChild(new MouseInteractionPlane());
			
			// Create a BitmapPlane that is a portion of
			// its max size. When clicked on expand it
			// to it's max size.
			//addChild(new ExpandingPlane());
			
			// Continuation of the previous example.
			// This time use the new InteractiveMaterial
			// to do interactions within the material
			//addChild(new SubMouseInteractionPlane());
			
			// Demonstrates the use of Gesture3D events
			// to manipulate some planes
			//addChild(new SimpleGestures());
			
			// Basic line drawing using segments
			//addChild(new ThrowingLine);
			
			// Use TimelineCells to create a date range of sorts
			//addChild(new BasicTimelineLayout());
			
			// Demonstrates the use of the DLinkedList library. Doesn't
			// really pertain to Away3D but it's used in the DraggableTimeline
			// sketch
			//addChild(new LinkedListIteration());
			
			// Same example as the previous screen but now you can
			// drag the cells around. When a cell goes off screen
			// a new cell comes on to replace it
			//addChild(new DraggableTimeline());
			
			// Camera movements
			//addChild(new CameraMovements());
			
			// Masonry InteractiveSpritePlanes
			//addChild(new MasonryInteractiveSpritePlanes());
			
			// Object destruction
			//addChild(new ObjectDestruction());
			
			// Pooling demos
			//addChild(new Pooling1());
			
			// Simplified MasonryLayout example
			//addChild(new MasonryLayoutDemo2());
			
			// BitmapMaterial Performane Profile
			//addChild(new BitmapMaterialPerformanceProfile());
			
			// Evenly divide the space within a container
			// and populate it with primitives
			//addChild(new EvenlyDividedSpace());
			
			// Practice expanding/contracting a layout
			//addChild(new ExpandingTimelineLayout());
			
			// Practice expanding/contracting a layout in one direction
			// instead of centered
			//addChild(new OneWayExpandingTimelineLayout());
			
			// Expand from the center cell while the peripheral cells change shape
			// but stay anchored to the center.
			addChild(new ExpandingIrregularTimelineLayout());
		}
	}
}
