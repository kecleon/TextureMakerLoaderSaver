package io.decagames.rotmg.supportCampaign.tab {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;

	import io.decagames.rotmg.shop.ShopBuyButton;
	import io.decagames.rotmg.supportCampaign.data.vo.RankVO;
	import io.decagames.rotmg.supportCampaign.tab.donate.DonatePanel;
	import io.decagames.rotmg.supportCampaign.tab.tiers.preview.TiersPreview;
	import io.decagames.rotmg.supportCampaign.tab.tiers.progressBar.TiersProgressBar;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.tabs.UITab;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import io.decagames.rotmg.utils.date.TimeSpan;

	public class SupporterShopTabView extends UITab {


		private var backgroundWidth:int = 561;

		private var background:SliceScalingBitmap;

		private var _unlockButton:ShopBuyButton;

		private var _countdown:UILabel;

		private var _campaignTimer:UILabel;

		private var unlockScreenContainer:Sprite;

		private var pointsInfo:UILabel;

		private var supportIcon:SliceScalingBitmap;

		private var _infoButton:SliceScalingButton;

		private var fieldBackground:SliceScalingBitmap;

		private var endDateInfo:UILabel;

		private var tiersPreview:TiersPreview;

		private var pointsBitmap:Bitmap;

		private var progressBar:TiersProgressBar;

		private var pName:String;

		public function SupporterShopTabView() {
			super("Campaign");
			this._countdown = new UILabel();
			this._campaignTimer = new UILabel();
		}

		public function show(param1:String, param2:Boolean, param3:Boolean, param4:int, param5:int):void {
			this.pName = param1;
			this.drawBackground(param2);
			if (param2) {
				if (this.unlockScreenContainer != null) {
					removeChild(this.unlockScreenContainer);
					this.unlockScreenContainer = null;
				}
				this.drawDonatePanel(param5);
			} else {
				this.showUnlockScreen(param3, param4, param5);
			}
		}

		public function updateStartCountdown(param1:String):void {
			this._countdown.text = param1;
			if (param1 == "") {
				this._campaignTimer.text = "";
			}
		}

		public function updatePoints(param1:int, param2:int):void {
			if (!this.pointsInfo) {
				this.fieldBackground = TextureParser.instance.getSliceScalingBitmap("UI", "bordered_field", 150);
				addChild(this.fieldBackground);
				this.pointsInfo = new UILabel();
				DefaultLabelFormat.createLabelFormat(this.pointsInfo, 18, 15585539, TextFormatAlign.CENTER, true);
				addChild(this.pointsInfo);
				this.supportIcon = TextureParser.instance.getSliceScalingBitmap("UI", "campaign_Points");
				addChild(this.supportIcon);
				this._infoButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "tier_info"));
				addChild(this._infoButton);
			}
			this.pointsInfo.text = param2 == 0 ? "No rank" : param1.toString();
			this.pointsInfo.x = this.background.width / 2 - this.pointsInfo.width / 2 + 8;
			this.pointsInfo.y = this.background.y - 8;
			this.fieldBackground.y = this.pointsInfo.y - 5;
			this.fieldBackground.x = this.background.width / 2 - this.fieldBackground.width / 2 + 13;
			this.supportIcon.y = this.pointsInfo.y + 1;
			this.supportIcon.x = this.pointsInfo.x + this.pointsInfo.width;
			this._infoButton.y = this.fieldBackground.y + 1;
			this._infoButton.x = this.fieldBackground.x + 3;
		}

		public function updateTime(param1:Number):void {
			var loc2:TimeSpan = new TimeSpan(param1);
			var loc3:String = "Supporter campaign will end in: ";
			if (loc2.totalDays == 0) {
				loc3 = loc3 + ((loc2.hours > 9 ? loc2.hours.toString() : "0" + loc2.hours.toString()) + "h " + (loc2.minutes > 9 ? loc2.minutes.toString() : "0" + loc2.minutes.toString()) + "m");
			} else {
				loc3 = loc3 + ((loc2.days > 9 ? loc2.days.toString() : "0" + loc2.days.toString()) + "d " + (loc2.hours > 9 ? loc2.hours.toString() : "0" + loc2.hours.toString()) + "h");
			}
			if (!this.endDateInfo) {
				this.endDateInfo = new UILabel();
				DefaultLabelFormat.createLabelFormat(this.endDateInfo, 14, 16684800, TextFormatAlign.CENTER, false);
				addChild(this.endDateInfo);
			}
			this.endDateInfo.text = loc3;
			this.endDateInfo.wordWrap = true;
			this.endDateInfo.width = this.background.width - 13;
			this.endDateInfo.x = this.background.x + 13;
			this.endDateInfo.y = this.background.y + this.background.height - 115;
		}

		public function showTier(param1:int, param2:Array, param3:int, param4:int):void {
			if (!this.tiersPreview) {
				this.tiersPreview = new TiersPreview(param1, param2, param3, param4, 530);
				this.tiersPreview.x = this.background.x + 15;
				this.tiersPreview.y = this.background.y + 20;
				addChild(this.tiersPreview);
			}
			this.tiersPreview.showTier(param1, param3, param4);
		}

		public function drawProgress(param1:int, param2:Vector.<RankVO>, param3:int, param4:int):void {
			if (!this.progressBar) {
				this.progressBar = new TiersProgressBar(param2, 530);
				this.progressBar.x = this.background.x + 15;
				this.progressBar.y = 285;
				addChild(this.progressBar);
			}
			this.progressBar.show(param1, param3, param4);
		}

		private function showUnlockScreen(param1:Boolean, param2:int, param3:int):void {
			var loc6:UILabel = null;
			this.unlockScreenContainer = new Sprite();
			this.unlockScreenContainer.x = 30;
			this.unlockScreenContainer.y = 10;
			var loc4:SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "support_campaign_unlock_screen");
			this.unlockScreenContainer.addChild(loc4);
			var loc5:UILabel = new UILabel();
			loc5.text = "Welcome to the Unity Support Campaign, " + this.pName + "!";
			DefaultLabelFormat.createLabelFormat(loc5, 18, 15395562, TextFormatAlign.LEFT, true);
			loc5.wordWrap = true;
			loc5.width = loc4.width - 20;
			loc5.y = 10;
			loc5.x = 10;
			this.unlockScreenContainer.addChild(loc5);
			loc6 = new UILabel();
			loc6.text = "We are bringing your favorite bullet-hell MMO to Unity and we need your support to make it happen! You can start right here. Join the cause, unlock the campaign and get your name displayed on the Wall of Fame upon release, alongside all our avid supporters from across the globe!\n" + "\n" + "After leaving your lasting mark in the game, you will be able to push onward and claim some unique gifts on top of our heartfelt gratitude. Our greatest supporters will also unlock an exclusive character glow.";
			DefaultLabelFormat.createLabelFormat(loc6, 14, 15395562, TextFormatAlign.JUSTIFY, false);
			loc6.wordWrap = true;
			loc6.width = loc4.width - 20;
			loc6.y = loc5.y + loc5.height;
			loc6.x = 10;
			this.unlockScreenContainer.addChild(loc6);
			var loc7:SliceScalingBitmap = new TextureParser().getSliceScalingBitmap("UI", "uniqueGifts", 500);
			this.unlockScreenContainer.addChild(loc7);
			loc7.y = loc6.y + loc6.height + 5;
			loc7.x = Math.round((loc4.width - loc7.width) / 2);
			var loc8:UILabel = new UILabel();
			loc8.text = "Add Your Name to the Wall of Fame";
			DefaultLabelFormat.createLabelFormat(loc8, 16, 15395562, TextFormatAlign.CENTER, true);
			loc8.wordWrap = true;
			loc8.width = loc4.width;
			loc8.y = loc6.y + loc6.height + 130;
			this.unlockScreenContainer.addChild(loc8);
			var loc9:SliceScalingBitmap = new TextureParser().getSliceScalingBitmap("UI", "main_button_decoration_dark", 150);
			this.unlockScreenContainer.addChild(loc9);
			this._unlockButton = new ShopBuyButton(param2);
			this._unlockButton.width = loc9.width - 48;
			this._unlockButton.disabled = !param1;
			this.unlockScreenContainer.addChild(this._unlockButton);
			loc9.y = loc8.y + loc8.height;
			loc9.x = Math.round((loc4.width - loc9.width) / 2);
			this._unlockButton.y = loc9.y + 6;
			this._unlockButton.x = loc9.x + 24;
			if (!param1) {
				this._campaignTimer.text = "Supporter campaign will start in:";
				DefaultLabelFormat.createLabelFormat(this._countdown, 18, 16684800, TextFormatAlign.CENTER, true);
				this._countdown.text = "";
				this._countdown.wordWrap = true;
				this._countdown.width = loc4.width;
				this._countdown.y = loc7.y + loc7.height + 20;
				this.unlockScreenContainer.addChild(this._countdown);
			}
			DefaultLabelFormat.createLabelFormat(this._campaignTimer, 14, 16684800, TextFormatAlign.CENTER, false);
			this._campaignTimer.wordWrap = true;
			this._campaignTimer.width = loc4.width;
			this._campaignTimer.y = loc7.y + loc7.height + 5;
			this.unlockScreenContainer.addChild(this._campaignTimer);
			addChild(this.unlockScreenContainer);
		}

		public function updateTimerPosition():void {
		}

		private function drawBackground(param1:Boolean):void {
			this.background = TextureParser.instance.getSliceScalingBitmap("UI", "shop_box_background", this.backgroundWidth);
			addChild(this.background);
			this.background.height = 375;
			this.background.x = 14;
			this.background.y = 0;
		}

		private function drawDonatePanel(param1:int):void {
			var loc2:DonatePanel = new DonatePanel(param1);
			addChild(loc2);
			loc2.x = this.background.x + Math.round((this.backgroundWidth - loc2.width) / 2);
			loc2.y = this.background.height - 55;
		}

		public function get unlockButton():ShopBuyButton {
			return this._unlockButton;
		}

		public function get infoButton():SliceScalingButton {
			return this._infoButton;
		}
	}
}
