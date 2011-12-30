package away3d.filters.tasks
{
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;

	import flash.display3D.Context3DProgramType;

	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;

	public class Filter3DBloomCompositeTask extends Filter3DTaskBase
	{
		private var _data : Vector.<Number>;
		private var _overlayTexture : TextureBase;

		public function Filter3DBloomCompositeTask(exposure : Number)
		{
			super();
			_data = Vector.<Number>([ exposure, 0, 0, 0 ]);
		}

		public function get overlayTexture() : TextureBase
		{
			return _overlayTexture;
		}

		public function set overlayTexture(value : TextureBase) : void
		{
			_overlayTexture = value;
		}

		public function get exposure() : Number
		{
			return _data[0];
		}

		public function set exposure(value : Number) : void
		{
			_data[0] = value;
		}


		override protected function getFragmentCode() : String
		{
			return	"tex ft0, v0, fs0 <2d,linear,clamp>	\n" +
					"tex ft1, v0, fs1 <2d,linear,clamp>	\n" +
					"mul ft1, ft1, fc0.x				\n" +
					"add oc, ft0, ft1					\n";
		}

		override public function activate(stage3DProxy : Stage3DProxy, camera3D : Camera3D, depthTexture : Texture) : void
		{
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data, 1);
			stage3DProxy.setTextureAt(1, _overlayTexture);
		}

		override public function deactivate(stage3DProxy : Stage3DProxy) : void
		{
			stage3DProxy.setTextureAt(1, null);
		}
	}
}
