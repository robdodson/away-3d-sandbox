package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	[SWF(width="900", height="600", frameRate="60")]
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
			
			// Draw a plane that registers the mouse
			// position when it is clicked. Translate
			// the uv coords to the underlying movieclip
			// and tell it to draw a circle in the
			// corresponding x, y position
			//addChild(new MouseInteractionPlane());
			
			// Draw a BitmapMaterial with some text
			// This example works off of an already
			// made Flash layout in snippet.fla
			//addChild(new BitmapTextPlane());
			
			// Create a BitmapPlane that is a portion of
			// its max size. When clicked on expand it
			// to it's max size.
			//addChild(new ZoomablePlane());
			
			addChild(new SimpleGestures());
			
			//addChild(new GestureCamera());
		}
	}
}