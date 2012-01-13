package away3d.primitives
{
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.InteractiveMaterial;
	import away3d.materials.MaterialBase;
	import away3d.primitives.Plane;
	
	import com.inchworm.SubInteractionClip;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	
	public class InteractiveSpritePlane extends Plane
	{
		public var sourceClip:Sprite;
		public var sourceClipContainer:Sprite;
		public var sourceClipContainerContainer:Sprite;
		
		public var bitmapMaterial:BitmapMaterial;
		public var interactiveMaterial:InteractiveMaterial;
		public var materialBounds:uint;
		
		public var clipWidth:Number;
		public var clipHeight:Number;
		
		
		public var interactive:Boolean;
		public var transparent:Boolean;
		public var animated:Boolean;
		
		
		public var isInvalid:Boolean;
		
		private var bmd:BitmapData;
		private var eraser:BitmapData;
		
		private static var MIN_BOUNDS:uint = 128;
		
		public function InteractiveSpritePlane(material:MaterialBase=null, width:Number=100, height:Number=100, segmentsW:Number=1, segmentsH:Number=1, yUp:Boolean=true)
		{
			super(material,width,height,segmentsW,segmentsH,false);
			interactive = false;
			transparent = false;
			animated = false;
			
		}
		
		
		public function init(_sourceClip:Sprite, _interactive:Boolean=false, _transparent:Boolean=false, _animated:Boolean=false):void{
			sourceClip = _sourceClip;
			interactive = _interactive;
			transparent = _transparent;
			animated = _animated;
			
			clipWidth = sourceClip.width;
			clipHeight = sourceClip.height;
			
			sourceClipContainer = new Sprite();
			sourceClipContainer.addChild(sourceClip);
			
			sourceClipContainerContainer = new Sprite();
			sourceClipContainerContainer.addChild(sourceClipContainer);
			
			
			var maxDimension:uint = Math.max(sourceClip.width, sourceClip.height);
			materialBounds = MIN_BOUNDS;
			while (maxDimension > materialBounds){
				materialBounds = materialBounds * 2;
			}
			sourceClipContainer.width = sourceClipContainer.height = materialBounds;
			bmd = new BitmapData(sourceClipContainerContainer.width, sourceClipContainerContainer.height, true, 0x00000000);
			bmd.draw(sourceClipContainerContainer, null, null, null, null, true);
			
			if (animated){
				eraser = new BitmapData(sourceClipContainerContainer.width, sourceClipContainerContainer.height, true, 0x00000000);
			}
			
			if (interactive){
				
				interactiveMaterial = new InteractiveMaterial(this,sourceClip as SubInteractionClip);
				interactiveMaterial.alphaBlending = transparent;
				interactiveMaterial.smooth = true;
				interactiveMaterial.mipmap = false;
				this.material = interactiveMaterial;
				
			} else {
			
				bitmapMaterial = new BitmapMaterial(bmd, true);
				bitmapMaterial.alphaBlending = transparent;
				bitmapMaterial.smooth = true;
				bitmapMaterial.mipmap = false;
				this.material = bitmapMaterial;
			
			}
			
			width = clipWidth;
			height = clipHeight;
			
			//plane.rotationX = -90;
		}
		

		public function render():void{
			if (animated){
				bmd.copyPixels(eraser, eraser.rect, new Point(0,0), eraser);
				bmd.draw(sourceClip, null, null, null, null, true);
				if (interactive){
					interactiveMaterial.updateTexture();
				} else {
					bitmapMaterial.updateTexture();
				}
			}
		}
		
		
		// *** to do - getter/setters for transparent, interactive, animated; right now they must be set when instantiated
		
		
		
		public function validate():void
		{
			isInvalid = false;
		}
		
		public function invalidate(xPos:Number=0, yPos:Number=0):void
		{
			isInvalid = true;
		}
		
	}
}