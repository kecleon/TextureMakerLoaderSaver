package kabam.rotmg.language {
	import flash.text.TextField;

	import kabam.rotmg.language.model.DebugStringMap;
	import kabam.rotmg.language.model.StringMap;
	import kabam.rotmg.text.model.TextAndMapProvider;
	import kabam.rotmg.text.view.DebugTextField;

	public class DebugTextAndMapProvider implements TextAndMapProvider {


		[Inject]
		public var debugStringMap:DebugStringMap;

		public function DebugTextAndMapProvider() {
			super();
		}

		public function getTextField():TextField {
			var loc1:DebugTextField = new DebugTextField();
			loc1.debugStringMap = this.debugStringMap;
			return loc1;
		}

		public function getStringMap():StringMap {
			return this.debugStringMap;
		}
	}
}
