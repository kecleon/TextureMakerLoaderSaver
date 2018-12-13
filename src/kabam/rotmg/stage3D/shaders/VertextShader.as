package kabam.rotmg.stage3D.shaders {
	import com.adobe.utils.AGALMiniAssembler;

	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;

	public class VertextShader extends AGALMiniAssembler {


		private var vertexProgram:ByteArray;

		public function VertextShader() {
			super();
			var loc1:AGALMiniAssembler = new AGALMiniAssembler();
			loc1.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0\n" + "add vt1, va1, vc4\n" + "mov v0, vt1");
			this.vertexProgram = loc1.agalcode;
		}

		public function getVertexProgram():ByteArray {
			return this.vertexProgram;
		}
	}
}
