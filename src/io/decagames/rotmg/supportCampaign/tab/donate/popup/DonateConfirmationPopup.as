package io.decagames.rotmg.supportCampaign.tab.donate.popup {
	import flash.text.TextFormatAlign;

	import io.decagames.rotmg.shop.ShopBuyButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.popups.modal.ModalPopup;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;

	public class DonateConfirmationPopup extends ModalPopup {


		private var _donateButton:ShopBuyButton;

		private var supportIcon:SliceScalingBitmap;

		private var _gold:int;

		public function DonateConfirmationPopup(param1:int, param2:int) {
			var loc4:UILabel = null;
			var loc6:SliceScalingBitmap = null;
			super(240, 130, "Boost");
			this._gold = param1;
			var loc3:UILabel = new UILabel();
			loc3.text = "You will receive:";
			DefaultLabelFormat.createLabelFormat(loc3, 14, 10066329, TextFormatAlign.CENTER, false);
			loc3.wordWrap = true;
			loc3.width = _contentWidth;
			loc3.y = 5;
			addChild(loc3);
			this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI", "campaign_Points");
			addChild(this.supportIcon);
			loc4 = new UILabel();
			loc4.text = param2.toString();
			DefaultLabelFormat.createLabelFormat(loc4, 22, 15585539, TextFormatAlign.CENTER, true);
			loc4.x = _contentWidth / 2 - loc4.width / 2 - 10;
			loc4.y = 25;
			addChild(loc4);
			this.supportIcon.y = loc4.y + 3;
			this.supportIcon.x = loc4.x + loc4.width;
			var loc5:UILabel = new UILabel();
			loc5.text = "Supporter Points";
			DefaultLabelFormat.createLabelFormat(loc5, 14, 10066329, TextFormatAlign.CENTER, false);
			loc5.wordWrap = true;
			loc5.width = _contentWidth;
			loc5.y = 50;
			addChild(loc5);
			loc6 = new TextureParser().getSliceScalingBitmap("UI", "main_button_decoration", 148);
			addChild(loc6);
			this._donateButton = new ShopBuyButton(param1);
			this._donateButton.width = loc6.width - 45;
			addChild(this._donateButton);
			loc6.y = _contentHeight - 50;
			loc6.x = Math.round((_contentWidth - loc6.width) / 2);
			this._donateButton.y = loc6.y + 6;
			this._donateButton.x = loc6.x + 22;
		}

		public function get donateButton():ShopBuyButton {
			return this._donateButton;
		}

		public function get gold():int {
			return this._gold;
		}
	}
}
