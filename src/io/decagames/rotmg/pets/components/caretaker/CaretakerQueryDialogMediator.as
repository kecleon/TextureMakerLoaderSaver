package io.decagames.rotmg.pets.components.caretaker {
	import flash.display.BitmapData;

	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.utils.PetsViewAssetFactory;

	import kabam.rotmg.dialogs.control.CloseDialogsSignal;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class CaretakerQueryDialogMediator extends Mediator {


		[Inject]
		public var view:CaretakerQueryDialog;

		[Inject]
		public var model:PetsModel;

		[Inject]
		public var closeDialogs:CloseDialogsSignal;

		public function CaretakerQueryDialogMediator() {
			super();
		}

		override public function initialize():void {
			this.view.closed.addOnce(this.onClosed);
			this.view.setCaretakerIcon(this.makeCaretakerIcon());
		}

		private function makeCaretakerIcon():BitmapData {
			var loc1:int = this.model.getPetYardObjectID();
			return PetsViewAssetFactory.returnCaretakerBitmap(loc1).bitmapData;
		}

		override public function destroy():void {
			this.view.closed.removeAll();
		}

		private function onClosed():void {
			this.closeDialogs.dispatch();
		}
	}
}
