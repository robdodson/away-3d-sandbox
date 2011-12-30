package away3d.materials.methods
{
	import away3d.arcane;
	import away3d.core.managers.BitmapDataTextureCache;
	import away3d.core.managers.Stage3DProxy;
	import away3d.core.managers.Texture3DProxy;
	import away3d.materials.passes.MaterialPassBase;
	import away3d.materials.utils.ShaderRegisterCache;
	import away3d.materials.utils.ShaderRegisterElement;
	import away3d.materials.utils.ShaderRegisterElement;

	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;

	use namespace arcane;

	public class SimpleWaterNormalMethod extends BasicNormalMethod
	{
		private var _texture2 : Texture3DProxy;
		private var _normalTextureRegister2 : ShaderRegisterElement;
		private var _normalMapIndex2 : int;
		private var _data : Vector.<Number>;
		private var _dataRegIndex : int;

		public function SimpleWaterNormalMethod(waveMap1 : BitmapData, waveMap2 : BitmapData)
		{
			super();
			normalMap = waveMap1;
			secondaryNormalMap = waveMap2;
			_data = Vector.<Number>([.5, 0, 0, 1, 0, 0, 0, 0]);
		}

		public function get water1OffsetX() : Number
		{
			return _data[4];
		}

		public function set water1OffsetX(value : Number) : void
		{
			_data[4] = value;
		}

		public function get water1OffsetY() : Number
		{
			return _data[5];
		}

		public function set water1OffsetY(value : Number) : void
		{
			_data[5] = value;
		}

		public function get water2OffsetX() : Number
		{
			return _data[6];
		}

		public function set water2OffsetX(value : Number) : void
		{
			_data[6] = value;
		}

		public function get water2OffsetY() : Number
		{
			return _data[7];
		}

		public function set water2OffsetY(value : Number) : void
		{
			_data[7] = value;
		}


		override public function copyFrom(method : ShadingMethodBase) : void
		{
			normalMap = BasicNormalMethod(method).normalMap;
		}

		override public function set normalMap(value : BitmapData) : void
		{
			if (!value) return;
			super.normalMap = value;
		}

		public function get secondaryNormalMap() : BitmapData
		{
			return _texture2? _texture2.bitmapData : null;
		}

		public function set secondaryNormalMap(value : BitmapData) : void
		{
			if (value == normalMap) return;

			if (_texture2)
				BitmapDataTextureCache.getInstance().freeTexture(_texture2);

			_texture2 = BitmapDataTextureCache.getInstance().getTexture(value);
		}

		arcane override function cleanCompilationData() : void
		{
			super.cleanCompilationData();
			_normalTextureRegister2 = null;
		}

		arcane override function reset() : void
		{
			super.reset();
			_normalMapIndex2 = -1;
		}

		override public function dispose(deep : Boolean) : void
		{
			super.dispose(deep);
			if (_texture2) {
				BitmapDataTextureCache.getInstance().freeTexture(_texture2);
				_texture2 = null;
			}
		}

		arcane override function activate(stage3DProxy : Stage3DProxy) : void
		{
			super.activate(stage3DProxy)

			if (_normalMapIndex2 >= 0) {
				stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, _dataRegIndex, _data,  2);
				stage3DProxy.setTextureAt(_normalMapIndex2, _texture2.getTextureForStage3D(stage3DProxy));
			}
		}

		arcane override function getFragmentPostLightingCode(regCache : ShaderRegisterCache, targetReg : ShaderRegisterElement) : String
		{
			var temp : ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
			var dataReg : ShaderRegisterElement = regCache.getFreeFragmentConstant();
			var dataReg2 : ShaderRegisterElement = regCache.getFreeFragmentConstant();
			_normalTextureRegister = regCache.getFreeTextureReg();
			_normalTextureRegister2 = regCache.getFreeTextureReg();
			_normalMapIndex = _normalTextureRegister.index;
			_normalMapIndex2 = _normalTextureRegister2.index;

			_dataRegIndex = dataReg.index;
			return 	"add " + temp + ", " + _uvFragmentReg + ", " + dataReg2 + ".xyxy\n" +
					getTexSampleCode(targetReg, _normalTextureRegister, temp) +
					"add " + temp + ", " + _uvFragmentReg + ", " + dataReg2 + ".zwzw\n" +
					getTexSampleCode(temp, _normalTextureRegister2, temp) +
					"add "+targetReg+", "+targetReg+", "+temp +"		\n" +
					"mul "+targetReg+", "+targetReg+", "+dataReg+".x	\n";
		}
	}
}
