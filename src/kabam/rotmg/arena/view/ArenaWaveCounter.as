package kabam.rotmg.arena.view {
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class ArenaWaveCounter extends Sprite {


		private const waveText:StaticTextDisplay = this.makeWaveText();

		private const waveStringBuilder:LineBuilder = new LineBuilder();

		public function ArenaWaveCounter() {
			super();
		}

		private function makeWaveText():StaticTextDisplay {
			var loc1:StaticTextDisplay = new StaticTextDisplay();
			loc1.setSize(24).setBold(true).setColor(16777215);
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			addChild(loc1);
			return loc1;
		}

		public function setWaveNumber(param1:int):void {
			this.waveText.setStringBuilder(this.waveStringBuilder.setParams(TextKey.ARENA_LEADERBOARD_LIST_ITEM_WAVENUMBER, {"waveNumber": param1}));
		}
	}
}
