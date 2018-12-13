package kabam.rotmg.arena.view {
	import com.company.assembleegameclient.util.Currency;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	import kabam.rotmg.editor.view.StaticTextButton;
	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
	import kabam.rotmg.util.components.DialogBackground;
	import kabam.rotmg.util.components.LegacyBuyButton;

	import org.osflash.signals.Signal;

	public class ContinueOrQuitDialog extends Sprite {


		public const quit:Signal = new Signal();

		public const buyContinue:Signal = new Signal(int, int);

		private const WIDTH:int = 350;

		private const HEIGHT:int = 150;

		private var cost:int;

		private const background:DialogBackground = this.makeBackground();

		private const title:StaticTextDisplay = this.makeTitle();

		private const quitSubtitle:StaticTextDisplay = this.makeSubtitle();

		private const quitButton:StaticTextButton = this.makeQuitButton();

		private const continueButton:LegacyBuyButton = this.makeContinueButton();

		private const restartSubtitle:StaticTextDisplay = this.makeSubtitle();

		private const processingText:StaticTextDisplay = this.makeSubtitle();

		public function ContinueOrQuitDialog(param1:int, param2:Boolean) {
			super();
			this.cost = param1;
			this.continueButton.setPrice(param1, Currency.GOLD);
			this.setProcessing(param2);
		}

		public function init(param1:int, param2:int):void {
			this.positionThis();
			this.quitButton.addEventListener(MouseEvent.CLICK, this.onQuit);
			this.continueButton.addEventListener(MouseEvent.CLICK, this.onBuyContinue);
			this.quitSubtitle.setStringBuilder(new LineBuilder().setParams(TextKey.CONTINUE_OR_QUIT_QUIT_SUBTITLE));
			this.restartSubtitle.setStringBuilder(new LineBuilder().setParams(TextKey.CONTINUE_OR_QUIT_CONTINUE_SUBTITLE, {"waveNumber": param1.toString()}));
			this.processingText.setStringBuilder(new StaticStringBuilder("Processing"));
			this.processingText.visible = false;
			this.align();
			this.makeHorizontalLine();
			this.makeVerticalLine();
		}

		public function setProcessing(param1:Boolean):void {
			this.processingText.visible = param1;
			this.continueButton.visible = !param1;
		}

		public function destroy():void {
			this.quitButton.removeEventListener(MouseEvent.CLICK, this.onQuit);
			this.continueButton.removeEventListener(MouseEvent.CLICK, this.onBuyContinue);
		}

		private function onQuit(param1:MouseEvent):void {
			this.quit.dispatch();
		}

		private function onBuyContinue(param1:MouseEvent):void {
			this.buyContinue.dispatch(Currency.GOLD, this.cost);
		}

		private function align():void {
			this.quitSubtitle.x = 70 - this.quitSubtitle.width / 2;
			this.quitSubtitle.y = 85;
			this.quitButton.x = 70 - this.quitButton.width / 2;
			this.quitButton.y = 110;
			this.restartSubtitle.x = 105 - this.restartSubtitle.width / 2 + 140;
			this.restartSubtitle.y = 85;
			this.continueButton.x = 105 - this.continueButton.width / 2 + 140;
			this.continueButton.y = 110;
			this.processingText.x = 105 - this.processingText.width / 2 + 140;
			this.processingText.y = 110;
		}

		private function positionThis():void {
			x = (stage.stageWidth - this.WIDTH) * 0.5;
			y = (stage.stageHeight - this.HEIGHT) * 0.5;
		}

		private function makeBackground():DialogBackground {
			var loc1:DialogBackground = new DialogBackground();
			loc1.draw(this.WIDTH, this.HEIGHT);
			addChild(loc1);
			return loc1;
		}

		private function makeTitle():StaticTextDisplay {
			var loc1:StaticTextDisplay = null;
			loc1 = new StaticTextDisplay();
			loc1.setSize(20).setBold(true).setColor(11776947);
			loc1.setStringBuilder(new LineBuilder().setParams(TextKey.CONTINUE_OR_QUIT_TITLE));
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			loc1.x = (this.WIDTH - loc1.width) * 0.5;
			loc1.y = 25;
			addChild(loc1);
			return loc1;
		}

		private function makeHorizontalLine():void {
			this.background.graphics.lineStyle();
			this.background.graphics.beginFill(6710886, 1);
			this.background.graphics.drawRect(1, 70, this.background.width - 2, 2);
			this.background.graphics.endFill();
		}

		private function makeVerticalLine():void {
			this.background.graphics.lineStyle();
			this.background.graphics.beginFill(6710886, 1);
			this.background.graphics.drawRect(140, 70, 2, this.HEIGHT - 66);
			this.background.graphics.endFill();
		}

		private function makeQuitButton():StaticTextButton {
			var loc1:StaticTextButton = new StaticTextButton(15, TextKey.CONTINUE_OR_QUIT_EXIT);
			addChild(loc1);
			return loc1;
		}

		private function makeContinueButton():LegacyBuyButton {
			var loc1:LegacyBuyButton = new LegacyBuyButton("", 15, this.cost, Currency.GOLD);
			loc1.readyForPlacement.addOnce(this.align);
			addChild(loc1);
			return loc1;
		}

		private function makeSubtitle():StaticTextDisplay {
			var loc1:StaticTextDisplay = new StaticTextDisplay();
			loc1.setSize(15).setColor(16777215).setBold(true);
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			addChild(loc1);
			return loc1;
		}
	}
}
