package kabam.rotmg.ui.view {
	import flash.display.Sprite;

	import kabam.rotmg.ui.view.components.PotionSlotView;

	public class PotionInventoryView extends Sprite {

		private static const LEFT_BUTTON_CUTS:Array = [1, 0, 0, 1];

		private static const RIGHT_BUTTON_CUTS:Array = [0, 1, 1, 0];

		private static const BUTTON_SPACE:int = 4;


		private const cuts:Array = [LEFT_BUTTON_CUTS, RIGHT_BUTTON_CUTS];

		public function PotionInventoryView() {
			var loc2:PotionSlotView = null;
			super();
			var loc1:int = 0;
			while (loc1 < 2) {
				loc2 = new PotionSlotView(this.cuts[loc1], loc1);
				loc2.x = loc1 * (PotionSlotView.BUTTON_WIDTH + BUTTON_SPACE);
				addChild(loc2);
				loc1++;
			}
		}
	}
}
