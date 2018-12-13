package io.decagames.rotmg.supportCampaign.tab.donate {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;

	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;

	import kabam.rotmg.assets.services.IconFactory;

	public class DonatePanel extends Sprite {


		private var _downArrow:SliceScalingButton;

		private var _upArrow:SliceScalingButton;

		private var _donateButton:SliceScalingButton;

		private var _amountTextfield:UILabel;

		private var pointAmountTextfield:UILabel;

		private var pointsBitmap:Bitmap;

		private var supportIcon:SliceScalingBitmap;

		private var leftPanel:SliceScalingBitmap;

		private var rightPanel:SliceScalingBitmap;

		private var ratio:int;

		public function DonatePanel(param1:int) {
			var loc2:SliceScalingBitmap = null;
			super();
			this.ratio = param1;
			this.leftPanel = TextureParser.instance.getSliceScalingBitmap("UI", "black_field_background", 130);
			this.leftPanel.height = 30;
			this.leftPanel.y = 6;
			addChild(this.leftPanel);
			loc2 = TextureParser.instance.getSliceScalingBitmap("UI", "spinner_up_arrow");
			this._upArrow = new SliceScalingButton(loc2.clone());
			this._upArrow.x = this.leftPanel.width - 40;
			this._upArrow.y = this.leftPanel.y + 2;
			addChild(this._upArrow);
			this._downArrow = new SliceScalingButton(loc2.clone());
			this._downArrow.rotation = 180;
			this._downArrow.x = this._upArrow.x + this._downArrow.width;
			this._downArrow.y = this.leftPanel.y + 28;
			addChild(this._downArrow);
			var loc3:BitmapData = IconFactory.makeCoin();
			var loc4:Bitmap = new Bitmap(loc3);
			loc4.y = this.leftPanel.y + 6;
			loc4.x = this.leftPanel.width - 64;
			addChild(loc4);
			this._amountTextfield = new UILabel();
			this._amountTextfield.type = TextFieldType.INPUT;
			this._amountTextfield.restrict = "0-9";
			this._amountTextfield.maxChars = SupporterCampaignModel.DONATE_MAX_INPUT_CHARS;
			this._amountTextfield.selectable = true;
			DefaultLabelFormat.donateAmountLabel(this._amountTextfield);
			this._amountTextfield.wordWrap = true;
			this._amountTextfield.width = 52;
			this._amountTextfield.text = SupporterCampaignModel.DEFAULT_DONATE_AMOUNT.toString();
			this._amountTextfield.y = this.leftPanel.y + 6;
			this._amountTextfield.x = 10;
			addChild(this._amountTextfield);
			this.rightPanel = TextureParser.instance.getSliceScalingBitmap("UI", "black_field_background", 130);
			this.rightPanel.height = 30;
			this.rightPanel.x = 214;
			this.rightPanel.y = 6;
			addChild(this.rightPanel);
			this.pointAmountTextfield = new UILabel();
			DefaultLabelFormat.createLabelFormat(this.pointAmountTextfield, 18, 15585539, TextFormatAlign.CENTER, true);
			this.pointAmountTextfield.y = this._amountTextfield.y;
			this.pointAmountTextfield.x = this.rightPanel.width / 2 - this.pointAmountTextfield.width / 2 + 9;
			addChild(this.pointAmountTextfield);
			this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI", "campaign_Points");
			addChild(this.supportIcon);
			this.supportIcon.y = this.pointAmountTextfield.y + 1;
			this.supportIcon.x = this.pointAmountTextfield.x + this.pointAmountTextfield.width;
			this.updatePoints(SupporterCampaignModel.DEFAULT_DONATE_AMOUNT * this.ratio);
			var loc5:SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "buy_button_background", 119);
			loc5.x = 112;
			addChild(loc5);
			this._donateButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
			this._donateButton.setLabel("Boost", DefaultLabelFormat.defaultButtonLabel);
			this._donateButton.width = loc5.width - 14;
			this._donateButton.y = loc5.y + 4;
			this._donateButton.x = loc5.x + 7;
			addChild(this._donateButton);
		}

		public function updateDonateAmount():void {
			this.updatePoints(int(this._amountTextfield.text) * this.ratio);
		}

		public function addDonateAmount(param1:int):void {
			var loc2:int = int(this._amountTextfield.text) + param1;
			if (loc2.toString().length > SupporterCampaignModel.DONATE_MAX_INPUT_CHARS || loc2 <= 0) {
				return;
			}
			this._amountTextfield.text = loc2.toString();
			this.updatePoints(loc2 * this.ratio);
		}

		private function updatePoints(param1:int):void {
			this.pointAmountTextfield.text = param1.toString();
			var loc2:int = 4;
			var loc3:int = this.pointAmountTextfield.width + this.supportIcon.width + loc2;
			this.pointAmountTextfield.x = this.rightPanel.x + Math.round((this.rightPanel.width - this.pointAmountTextfield.width) / 2) - 8;
			this.supportIcon.x = this.pointAmountTextfield.x + this.pointAmountTextfield.width;
		}

		public function get downArrow():SliceScalingButton {
			return this._downArrow;
		}

		public function get upArrow():SliceScalingButton {
			return this._upArrow;
		}

		public function get donateButton():SliceScalingButton {
			return this._donateButton;
		}

		public function get gold():int {
			return int(this._amountTextfield.text);
		}

		public function get amountTextfield():UILabel {
			return this._amountTextfield;
		}
	}
}
