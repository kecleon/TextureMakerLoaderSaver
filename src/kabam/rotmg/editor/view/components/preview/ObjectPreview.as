package kabam.rotmg.editor.view.components.preview {
	import com.company.assembleegameclient.util.TextureRedrawer;

	import flash.display.BitmapData;

	public class ObjectPreview extends Preview {


		public function ObjectPreview(param1:int, param2:int) {
			super(param1, param2);
		}

		override public function redraw():void {
			super.redraw();
			if (origBitmapData_ == null) {
				return;
			}
			var loc1:BitmapData = TextureRedrawer.redraw(origBitmapData_, size_, true, 0, false);
			bitmap_.bitmapData = loc1;
		}
	}
}
