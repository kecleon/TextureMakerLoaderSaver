package kabam.rotmg.promotions.view {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import kabam.rotmg.promotions.view.components.TransparentButton;

	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;

	public class BeginnersPackageOfferDialog extends Sprite {

		public static var hifiBeginnerOfferEmbed:Class = BeginnersPackageOfferDialog_hifiBeginnerOfferEmbed;


		public var close:Signal;

		public var buy:Signal;

		public function BeginnersPackageOfferDialog() {
			super();
			this.makeBackground();
			this.makeCloseButton();
			this.makeBuyButton();
		}

		public function centerOnScreen():void {
			x = (stage.stageWidth - width) * 0.5;
			y = (stage.stageHeight - height) * 0.5;
		}

		private function makeBackground():void {
			addChild(new hifiBeginnerOfferEmbed());
		}

		private function makeBuyButton():void {
			var loc1:Sprite = this.makeTransparentTargetButton(270, 400, 150, 40);
			this.buy = new NativeMappedSignal(loc1, MouseEvent.CLICK);
		}

		private function makeCloseButton():void {
			var loc1:Sprite = this.makeTransparentTargetButton(550, 30, 30, 30);
			this.close = new NativeMappedSignal(loc1, MouseEvent.CLICK);
		}

		private function makeTransparentTargetButton(param1:int, param2:int, param3:int, param4:int):Sprite {
			var loc5:TransparentButton = new TransparentButton(param1, param2, param3, param4);
			addChild(loc5);
			return loc5;
		}
	}
}
