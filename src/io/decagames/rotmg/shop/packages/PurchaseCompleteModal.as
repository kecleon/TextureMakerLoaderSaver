package io.decagames.rotmg.shop.packages {
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.modal.TextModal;
	import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;

	import kabam.rotmg.packages.model.PackageInfo;

	public class PurchaseCompleteModal extends TextModal {


		public function PurchaseCompleteModal(param1:String) {
			var loc2:Vector.<BaseButton> = new Vector.<BaseButton>();
			loc2.push(new ClosePopupButton("OK"));
			var loc3:String = "";
			switch (param1) {
				case PackageInfo.PURCHASE_TYPE_SLOTS_ONLY:
					loc3 = "Your purchase has been validated!";
					break;
				case PackageInfo.PURCHASE_TYPE_CONTENTS_ONLY:
					loc3 = "Your items have been sent to the Gift Chest!";
					break;
				case PackageInfo.PURCHASE_TYPE_MIXED:
					loc3 = "Your purchase has been validated! You will find your items in the Gift Chest.";
			}
			super(300, "Package Purchased", loc3, loc2);
		}
	}
}
