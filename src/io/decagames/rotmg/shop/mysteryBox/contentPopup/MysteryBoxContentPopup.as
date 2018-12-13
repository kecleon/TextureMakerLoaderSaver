 
package io.decagames.rotmg.shop.mysteryBox.contentPopup {
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.popups.modal.ModalPopup;
	import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
	
	public class MysteryBoxContentPopup extends ModalPopup {
		 
		
		private var _info:MysteryBoxInfo;
		
		public function MysteryBoxContentPopup(param1:MysteryBoxInfo) {
			var loc2:UILabel = null;
			this._info = param1;
			super(280,0,param1.title,DefaultLabelFormat.defaultSmallPopupTitle);
			loc2 = new UILabel();
			DefaultLabelFormat.mysteryBoxContentInfo(loc2);
			loc2.multiline = true;
			switch(param1.rolls) {
				case 1:
					loc2.text = "You will win one\nof the rewards listed below!";
					break;
				case 2:
					loc2.text = "You will win two\nof the rewards listed below!";
					break;
				case 3:
					loc2.text = "You will win three\nof the rewards listed below!";
			}
			loc2.x = (280 - loc2.textWidth) / 2;
			addChild(loc2);
		}
		
		public function get info() : MysteryBoxInfo {
			return this._info;
		}
	}
}
