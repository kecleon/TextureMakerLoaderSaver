 
package kabam.rotmg.stage3D.shaders {
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;
	
	public class FragmentShader {
		 
		
		private var vertexProgram:ByteArray;
		
		public function FragmentShader() {
			super();
			var loc1:AGALMiniAssembler = new AGALMiniAssembler();
			loc1.assemble(Context3DProgramType.FRAGMENT,"tex ft1, v0, fs0 <2d>\n" + "mul ft1.x, ft1.x, fc2.x\n" + "mul ft1.y, ft1.y, fc2.y\n" + "mul ft1.z, ft1.z, fc2.z\n" + "mul ft1.w, ft1.w, fc2.w\n" + "add ft1, ft1, fc3\n" + "mov oc, ft1");
			this.vertexProgram = loc1.agalcode;
		}
		
		public function getVertexProgram() : ByteArray {
			return this.vertexProgram;
		}
	}
}
