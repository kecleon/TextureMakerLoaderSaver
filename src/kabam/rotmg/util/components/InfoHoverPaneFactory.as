package kabam.rotmg.util.components {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import kabam.rotmg.pets.view.components.PopupWindowBackground;

	public class InfoHoverPaneFactory extends Sprite {


		public function InfoHoverPaneFactory() {
			super();
		}

		public static function make(param1:DisplayObject):Sprite {
			var loc2:Sprite = null;
			var loc4:PopupWindowBackground = null;
			if (param1 == null) {
				return null;
			}
			loc2 = new Sprite();
			var loc3:int = 8;
			param1.width = 291 - loc3;
			param1.height = 598 - loc3 * 2 - 2;
			loc2.addChild(param1);
			loc4 = new PopupWindowBackground();
			loc4.draw(param1.width, param1.height + 2, PopupWindowBackground.TYPE_TRANSPARENT_WITHOUT_HEADER);
			loc4.x = param1.x;
			loc4.y = param1.y - 1;
			loc2.addChild(loc4);
			return loc2;
		}
	}
}
