package kabam.rotmg.editor.view.components.drawer {
	import flash.events.Event;

	public class SetPixelsEvent extends Event {

		public static const SET_PIXELS_EVENT:String = "SET_PIXELS_EVENT";


		public var pixelColors_:Vector.<PixelColor>;

		public function SetPixelsEvent(param1:Vector.<PixelColor>) {
			super(SET_PIXELS_EVENT, true);
			this.pixelColors_ = param1;
		}
	}
}
