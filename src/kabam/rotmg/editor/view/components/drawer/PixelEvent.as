package kabam.rotmg.editor.view.components.drawer {
	import com.company.color.HSV;

	import flash.events.Event;

	public class PixelEvent extends Event {

		public static const PIXEL_EVENT:String = "PIXEL_EVENT";

		public static const TEMP_PIXEL_EVENT:String = "TEMP_PIXEL_EVENT";

		public static const UNDO_TEMP_EVENT:String = "UNDO_TEMP_EVENT";


		public var pixel_:Pixel;

		public var prevHSV_:HSV;

		public function PixelEvent(param1:String, param2:Pixel) {
			super(param1, true);
			this.pixel_ = param2;
			this.prevHSV_ = this.pixel_.hsv_;
		}
	}
}
