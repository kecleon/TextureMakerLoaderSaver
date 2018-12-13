package kabam.rotmg.arena.view {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.arena.component.BattleSummaryText;
	import kabam.rotmg.editor.view.StaticTextButton;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.util.components.DialogBackground;

	import org.osflash.signals.Signal;

	public class BattleSummaryDialog extends Sprite {


		private var BattleSummarySplash:Class;

		public const close:Signal = new Signal();

		private const WIDTH:int = 264;

		private const HEIGHT:int = 302;

		private const background:DialogBackground = this.makeBackground();

		private const splashArt = this.makeSplashArt();

		private var leftSummary:BattleSummaryText;

		private var rightSummary:BattleSummaryText;

		private var titleText:StaticTextDisplay;

		private var closeButton:StaticTextButton;

		public function BattleSummaryDialog() {
			this.BattleSummarySplash = BattleSummaryDialog_BattleSummarySplash;
			this.titleText = this.makeTitle();
			this.closeButton = this.makeButton();
			super();
			this.drawHorizontalDivide(25);
			this.drawHorizontalDivide(132);
			this.drawHorizontalDivide(252);
			this.makeVerticalDivide();
		}

		private function makeBackground():DialogBackground {
			var loc1:DialogBackground = new DialogBackground();
			loc1.draw(this.WIDTH, this.HEIGHT);
			addChild(loc1);
			return loc1;
		}

		public function positionThis():void {
			x = (stage.stageWidth - this.WIDTH) * 0.5;
			y = (stage.stageHeight - this.HEIGHT) * 0.5;
		}

		public function setCurrentRun(param1:int, param2:int):void {
			if (this.leftSummary) {
				removeChild(this.leftSummary);
			}
			this.leftSummary = new BattleSummaryText(TextKey.BATTLE_SUMMARY_CURRENT_SUBTITLE, param1, param2);
			this.leftSummary.y = 60 - this.leftSummary.height / 2 + 132;
			this.leftSummary.x = this.WIDTH / 4 - this.leftSummary.width / 2;
			addChild(this.leftSummary);
		}

		public function setBestRun(param1:int, param2:int):void {
			if (this.rightSummary) {
				removeChild(this.rightSummary);
			}
			this.rightSummary = new BattleSummaryText(TextKey.BATTLE_SUMMARY_BEST_SUBTITLE, param1, param2);
			this.rightSummary.y = 60 - this.rightSummary.height / 2 + 132;
			this.rightSummary.x = this.WIDTH / 4 - this.rightSummary.width / 2 + this.WIDTH / 2;
			addChild(this.rightSummary);
		}

		private function closeClicked(param1:MouseEvent):void {
			this.closeButton.removeEventListener(MouseEvent.CLICK, this.closeClicked);
			this.close.dispatch();
		}

		private function makeVerticalDivide():void {
			this.background.graphics.lineStyle();
			this.background.graphics.beginFill(6710886, 1);
			this.background.graphics.drawRect(this.WIDTH / 2, 132, 2, 120);
			this.background.graphics.endFill();
		}

		private function drawHorizontalDivide(param1:int):void {
			this.background.graphics.lineStyle();
			this.background.graphics.beginFill(6710886, 1);
			this.background.graphics.drawRect(1, param1, this.background.width - 2, 2);
			this.background.graphics.endFill();
		}

		private function makeSplashArt():* {
			var loc1:* = new this.BattleSummarySplash();
			loc1.y = 27;
			loc1.x = 2;
			addChild(loc1);
			return loc1;
		}

		private function makeTitle():StaticTextDisplay {
			var loc1:StaticTextDisplay = null;
			loc1 = new StaticTextDisplay();
			loc1.setSize(18).setBold(true).setColor(11776947);
			loc1.setStringBuilder(new LineBuilder().setParams(TextKey.BATTLE_SUMMARY_TITLE));
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			loc1.x = (this.WIDTH - loc1.width) * 0.5;
			loc1.y = 3;
			addChild(loc1);
			return loc1;
		}

		private function makeButton():StaticTextButton {
			var loc1:StaticTextButton = null;
			loc1 = new StaticTextButton(16, TextKey.BATTLE_SUMMARY_CLOSE, 100);
			loc1.addEventListener(MouseEvent.CLICK, this.closeClicked);
			loc1.y = this.HEIGHT - loc1.height - 10;
			loc1.x = this.WIDTH / 2 - loc1.width / 2;
			addChild(loc1);
			return loc1;
		}
	}
}
