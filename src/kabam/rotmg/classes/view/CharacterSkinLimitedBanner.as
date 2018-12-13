package kabam.rotmg.classes.view {
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	import org.osflash.signals.Signal;

	public class CharacterSkinLimitedBanner extends Sprite {


		private var LimitedBanner:Class;

		private const limitedText:TextFieldDisplayConcrete = this.makeText();

		private const limitedBanner = this.makeLimitedBanner();

		public const readyForPositioning:Signal = new Signal();

		public function CharacterSkinLimitedBanner() {
			this.LimitedBanner = CharacterSkinLimitedBanner_LimitedBanner;
			super();
		}

		private function makeText():TextFieldDisplayConcrete {
			var loc1:TextFieldDisplayConcrete = null;
			loc1 = new TextFieldDisplayConcrete().setSize(16).setColor(11776947).setBold(true);
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			loc1.setStringBuilder(new LineBuilder().setParams(TextKey.CHARACTER_SKIN_LIMITED));
			loc1.textChanged.addOnce(this.layout);
			addChild(loc1);
			return loc1;
		}

		private function makeLimitedBanner():* {
			var loc1:* = new this.LimitedBanner();
			addChild(loc1);
			return loc1;
		}

		public function layout():void {
			this.limitedText.y = height / 2 - this.limitedText.height / 2 + 1;
			this.limitedBanner.x = this.limitedText.x + this.limitedText.width;
			this.readyForPositioning.dispatch();
		}
	}
}
