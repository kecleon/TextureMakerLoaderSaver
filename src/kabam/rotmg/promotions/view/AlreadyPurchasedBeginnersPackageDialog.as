package kabam.rotmg.promotions.view {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import kabam.lib.resizing.view.Resizable;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.FlushPopupStartupQueueSignal;

	public class AlreadyPurchasedBeginnersPackageDialog extends Sprite implements Resizable {

		public static var hifiBeginnerOfferAlreadyPurchasedEmbed:Class = AlreadyPurchasedBeginnersPackageDialog_hifiBeginnerOfferAlreadyPurchasedEmbed;


		private var closeBtn:Sprite;

		public function AlreadyPurchasedBeginnersPackageDialog() {
			super();
			this.addBackground();
			this.makeCloseButton();
		}

		private function addBackground():void {
			addChild(new hifiBeginnerOfferAlreadyPurchasedEmbed());
		}

		private function makeCloseButton():void {
			this.closeBtn = new Sprite();
			this.closeBtn.graphics.beginFill(16711680, 0);
			this.closeBtn.graphics.drawRect(0, 0, 30, 30);
			this.closeBtn.graphics.endFill();
			this.closeBtn.buttonMode = true;
			this.closeBtn.x = 550;
			this.closeBtn.y = 30;
			addEventListener(MouseEvent.CLICK, this.onClose);
			addChild(this.closeBtn);
		}

		private function onClose(param1:MouseEvent):void {
			removeEventListener(MouseEvent.CLICK, this.onClose);
			var loc2:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
			loc2.dispatch();
			var loc3:FlushPopupStartupQueueSignal = StaticInjectorContext.getInjector().getInstance(FlushPopupStartupQueueSignal);
			loc3.dispatch();
		}

		public function resize(param1:Rectangle):void {
			x = (param1.width - width) / 2;
			y = (param1.height - height) / 2;
		}
	}
}
