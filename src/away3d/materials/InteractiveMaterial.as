package away3d.materials
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.events.MouseEvent3D;
	
	import com.inchworm.SubInteractionClip;
	import com.inchworm.events.InvalidationEvent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class InteractiveMaterial extends BitmapMaterial
	{
		//-----------------------------------------------------------------
		// CLASS MEMBERS
		private var bitmapDataFromClip					:BitmapData;
		private var sourceMovieClip						:SubInteractionClip;
		private var sourceMesh							:Object3D;
		private var previousTarget						:DisplayObject;
		private var activeTarget						:DisplayObject;
		
		//-----------------------------------------------------------------
		
		public function InteractiveMaterial(mesh:ObjectContainer3D, clip:SubInteractionClip) // rd: TODO clip needs to implement an invalidation interface
		{
			sourceMovieClip = clip;
			sourceMovieClip.addEventListener(InvalidationEvent.INVALIDATED, onInvalidated, false, 0, true);
			bitmapDataFromClip = new BitmapData(sourceMovieClip.width, sourceMovieClip.height, true, 0);
			bitmapDataFromClip.draw(sourceMovieClip);
			
			super(bitmapDataFromClip, true, false, true); // rd: TODO figure out use case of mipmap

			sourceMesh = mesh;
			sourceMesh.addEventListener(MouseEvent3D.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(e:MouseEvent3D):void
		{
			sourceMesh.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove);
			sourceMesh.addEventListener(MouseEvent3D.MOUSE_OUT, onMouseOut);
			sourceMesh.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			sourceMesh.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown, false, 0);
			sourceMesh.addEventListener(MouseEvent3D.CLICK, onMouseClick);
			sourceMesh.addEventListener(MouseEvent3D.DOUBLE_CLICK, onMouseDoubleClick);
			sourceMesh.addEventListener(MouseEvent3D.MOUSE_WHEEL, onMouseWheel);
		}
		
		// If we currently have an activeTarget force it to dispatch its ROLL_OUT
		// event
		protected function onMouseOut(e:MouseEvent3D):void
		{
			if (activeTarget != null)
			{
				activeTarget.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT)); // rd: TODO verify events don't need more arguments
			}
			
			activeTarget = null;
			previousTarget = null;
		}
		
		protected function onMouseMove(e:MouseEvent3D):void
		{
			// Determine the mouse's position on the sourceClip. We'll use UVs to convert
			// the coordinates to the sourceClip's local coordinate space
			var pt:Point = new Point(e.uv.x * sourceMovieClip.width, e.uv.y * sourceMovieClip.height);
			sourceMovieClip.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, false, false, pt.x, pt.y));
			
			// Set the previousTarget to the activeTarget
			// so we can create a new activeTarget and see if
			// they're the same DisplayObject
			previousTarget = activeTarget;
			
			// rd: TODO this looks at the children and not the clip itself which might be problematic..
			// should we add everything to an array and dispatch events for all the displayObjects?
			for (var i:int = 0; i < sourceMovieClip.numChildren; i++)  
			{
				var child:DisplayObject = sourceMovieClip.getChildAt(i);
				if (pt.x > child.x && pt.x < child.x + child.width && pt.y > child.y && pt.y < child.y + child.height)
				{
					activeTarget = child;
					//activeTarget.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
				}
				else
				{
					activeTarget = null;
				}
			}
			
			// If the previous target doesn't match the active target
			// then dispatch a ROLL_OUT for the previous target and 
			// a ROLL_OVER for the active target
			if (previousTarget != activeTarget)
			{
				if (previousTarget != null)
				{
					previousTarget.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
				}
				
				if (activeTarget != null)
				{
					activeTarget.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
				}
			}
		}
		
		protected function onMouseUp(e:MouseEvent3D):void
		{
			if (activeTarget != null)
			{
				activeTarget.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			}
		}
		
		protected function onMouseDown(e:MouseEvent3D):void
		{
			if (activeTarget != null)
			{
				activeTarget.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			}
		}
		
		protected function onMouseClick(e:MouseEvent3D):void
		{
			if (activeTarget != null)
			{
				activeTarget.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		protected function onMouseDoubleClick(e:MouseEvent3D):void
		{
			if (activeTarget != null)
			{
				activeTarget.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
			}
		}
		
		protected function onMouseWheel(e:MouseEvent3D):void
		{
			if (activeTarget != null)
			{
				activeTarget.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL));
			}
		}
		
		protected function onInvalidated(e:InvalidationEvent):void
		{
			sourceMovieClip.removeEventListener(InvalidationEvent.INVALIDATED, onInvalidated);
			sourceMovieClip.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			sourceMovieClip.addEventListener(InvalidationEvent.VALIDATED, onValidated, false, 0, true);
		}
		
		protected function onValidated(e:Event):void
		{
			sourceMovieClip.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			sourceMovieClip.addEventListener(InvalidationEvent.INVALIDATED, onInvalidated, false, 0, true);
		}
		
		protected function onEnterFrame(e:Event):void
		{
			bitmapDataFromClip.draw(sourceMovieClip);
			updateTexture();			
		}
	}
}