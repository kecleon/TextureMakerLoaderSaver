package kabam.rotmg.editor.view.components {
	import com.company.util.IntPoint;

	public class ObjectSizeDropDown extends SizeDropDown {

		private static const SIZES:Vector.<IntPoint> = new <IntPoint>[new IntPoint(8, 8), new IntPoint(16, 8), new IntPoint(16, 16), new IntPoint(24, 24), new IntPoint(32, 32), new IntPoint(48, 48), new IntPoint(56, 56), new IntPoint(64, 64)];


		public function ObjectSizeDropDown() {
			super(SIZES);
		}
	}
}
