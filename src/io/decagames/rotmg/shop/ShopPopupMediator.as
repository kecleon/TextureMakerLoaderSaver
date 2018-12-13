 
package io.decagames.rotmg.shop {
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import com.greensock.TweenMax;
	import flash.events.TimerEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import io.decagames.rotmg.shop.genericBox.GenericBoxTile;
	import io.decagames.rotmg.shop.genericBox.data.GenericBoxInfo;
	import io.decagames.rotmg.shop.mysteryBox.MysteryBoxTile;
	import io.decagames.rotmg.shop.packages.PackageBoxTile;
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.supportCampaign.tab.SupporterShopTabView;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
	import io.decagames.rotmg.ui.gird.UIGrid;
	import io.decagames.rotmg.ui.labels.UILabel;
	import io.decagames.rotmg.ui.popups.header.PopupHeader;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.tabs.TabButton;
	import io.decagames.rotmg.ui.tabs.UITab;
	import io.decagames.rotmg.ui.tabs.UITabs;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import kabam.rotmg.account.core.signals.OpenMoneyWindowSignal;
	import kabam.rotmg.application.DynamicSettings;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
	import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
	import kabam.rotmg.mysterybox.services.MysteryBoxModel;
	import kabam.rotmg.packages.model.PackageInfo;
	import kabam.rotmg.packages.services.GetPackagesTask;
	import kabam.rotmg.packages.services.PackageModel;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class ShopPopupMediator extends Mediator {
		 
		
		[Inject]
		public var view:ShopPopupView;
		
		[Inject]
		public var mysteryBoxModel:MysteryBoxModel;
		
		[Inject]
		public var packageBoxModel:PackageModel;
		
		[Inject]
		public var gameModel:GameModel;
		
		[Inject]
		public var openMoneyWindow:OpenMoneyWindowSignal;
		
		[Inject]
		public var closePopupSignal:ClosePopupSignal;
		
		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;
		
		[Inject]
		public var hideTooltipSignal:HideTooltipsSignal;
		
		[Inject]
		public var supporterModel:SupporterCampaignModel;
		
		[Inject]
		public var getMysteryBoxesTask:GetMysteryBoxesTask;
		
		[Inject]
		public var getPackagesTask:GetPackagesTask;
		
		private var closeButton:SliceScalingButton;
		
		private var addButton:SliceScalingButton;
		
		private var mysteryBoxesGrid:UIGrid;
		
		private var packageBoxesGrid:UIGrid;
		
		private var toolTip:TextToolTip = null;
		
		private var hoverTooltipDelegate:HoverTooltipDelegate;
		
		private var tabs:UITabs;
		
		private var packageTab:TabButton;
		
		private var updateLabel:UILabel;
		
		private var updateTimer:Timer;
		
		public function ShopPopupMediator() {
			super();
		}
		
		private function createPackageBoxTab() : UITab {
			var loc1:UITab = null;
			loc1 = new UITab("Packages");
			this.packageBoxesGrid = new UIGrid(550,2,6,384,3,loc1);
			this.packageBoxesGrid.x = 10;
			this.packageBoxesGrid.decorBitmap = "tabs_tile_decor";
			this.updatePackages();
			loc1.addContent(this.packageBoxesGrid);
			return loc1;
		}
		
		private function createMysteryBoxTab() : UITab {
			var loc1:UITab = new UITab("Mystery Boxes",true);
			this.mysteryBoxesGrid = new UIGrid(550,3,6,384,3,loc1);
			this.mysteryBoxesGrid.decorBitmap = "tabs_tile_decor";
			this.mysteryBoxesGrid.x = 10;
			this.updateMysteryBoxes();
			loc1.addContent(this.mysteryBoxesGrid);
			return loc1;
		}
		
		private function updateMysteryBoxes() : void {
			var loc2:MysteryBoxInfo = null;
			this.mysteryBoxesGrid.clearGrid();
			var loc1:Vector.<MysteryBoxInfo> = this.mysteryBoxModel.getBoxesForGrid();
			for each(loc2 in loc1) {
				if(loc2 != null && (!loc2.endTime || loc2.getSecondsToEnd() > 0)) {
					this.mysteryBoxesGrid.addGridElement(this.createBoxTile(loc2,MysteryBoxTile));
				}
			}
		}
		
		private function updatePackages() : void {
			var loc2:PackageInfo = null;
			this.packageBoxesGrid.clearGrid();
			var loc1:Vector.<PackageInfo> = this.packageBoxModel.getBoxesForGrid();
			for each(loc2 in loc1) {
				if(loc2 != null && (!loc2.endTime || loc2.getSecondsToEnd() > 0)) {
					this.packageBoxesGrid.addGridElement(this.createBoxTile(loc2,PackageBoxTile));
				}
			}
		}
		
		private function createBoxTile(param1:GenericBoxInfo, param2:Class) : GenericBoxTile {
			return new param2(param1);
		}
		
		override public function initialize() : void {
			var loc4:PackageInfo = null;
			this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","close_button"));
			this.addButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","add_button"));
			this.tabs = new UITabs(590);
			if(this.supporterModel.hasValidData) {
				this.tabs.addTab(new SupporterShopTabView(),true);
			}
			this.tabs.addTab(this.createMysteryBoxTab(),!this.supporterModel.hasValidData);
			this.tabs.addTab(this.createPackageBoxTab());
			this.tabs.y = 115;
			this.tabs.x = 3;
			this.view.header.setTitle("Shop",319,DefaultLabelFormat.defaultPopupTitle);
			this.view.header.showCoins(132).coinsAmount = this.gameModel.player.credits_;
			this.view.header.showFame(132).fameAmount = this.gameModel.player.fame_;
			this.closeButton.clickSignal.addOnce(this.onClose);
			this.view.header.addButton(this.closeButton,PopupHeader.RIGHT_BUTTON);
			this.addButton.clickSignal.add(this.onAdd);
			this.view.header.addButton(this.addButton,PopupHeader.LEFT_BUTTON);
			this.view.addChild(this.tabs);
			this.updateLabel = new UILabel();
			this.updateLabel.defaultTextFormat = DefaultLabelFormat.createTextFormat(12,16773120,TextFormatAlign.LEFT,true);
			this.updateLabel.text = "Updating shop...";
			this.updateLabel.x = 15;
			this.updateLabel.y = 582;
			this.updateLabel.alpha = 0;
			this.view.addChild(this.updateLabel);
			var loc1:Vector.<PackageInfo> = this.packageBoxModel.getBoxesForGrid();
			var loc2:Date = new Date();
			loc2.setTime(Parameters.data_["packages_indicator"]);
			var loc3:Boolean = false;
			for each(loc4 in loc1) {
				if(loc4 != null && (!loc4.endTime || loc4.getSecondsToEnd() > 0)) {
					if(loc4.isNew() && (loc4.startTime.getTime() > loc2.getTime() || !Parameters.data_["packages_indicator"])) {
						loc3 = true;
					}
				}
			}
			this.packageTab = this.tabs.getTabButtonByLabel("Packages");
			if(this.packageTab) {
				this.packageTab.showIndicator = loc3;
				this.packageTab.clickSignal.add(this.onPackageClick);
			}
			this.gameModel.player.creditsWereChanged.add(this.refreshCoins);
			this.gameModel.player.fameWasChanged.add(this.refreshFame);
			this.toolTip = new TextToolTip(3552822,10197915,"Buy Gold","Click to buy more Realm Gold!",200);
			this.hoverTooltipDelegate = new HoverTooltipDelegate();
			this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
			this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
			this.hoverTooltipDelegate.setDisplayObject(this.addButton);
			this.hoverTooltipDelegate.tooltip = this.toolTip;
			this.updateTimer = new Timer(this.updateInterval);
			this.updateTimer.addEventListener(TimerEvent.TIMER,this.updateShop);
			this.updateTimer.start();
			this.tabs.tabSelectedSignal.add(this.onTabChange);
			if(!this.supporterModel.hasValidData) {
				this.updateShop(null);
			}
		}
		
		private function onTabChange(param1:String) : void {
			if(this.updateTimer) {
				this.updateTimer.reset();
				this.updateTimer.start();
			}
			if(param1 != "Campaign") {
				this.updateShop(null);
			} else {
				TweenMax.killTweensOf(this.updateLabel);
				this.updateLabel.alpha = 0;
			}
		}
		
		private function get updateInterval() : int {
			if(DynamicSettings.settingExists("MysteryBoxRefresh")) {
				return DynamicSettings.getSettingValue("MysteryBoxRefresh") * 1000;
			}
			return ShopConfiguration.DEFAULT_SHOP_REFRESH_COOLDOWN * 1000;
		}
		
		private function updateShop(param1:TimerEvent) : void {
			switch(this.tabs.currentTabLabel) {
				case "Mystery Boxes":
					this.tryUpdateMysteryBoxes();
					break;
				case "Packages":
					this.tryUpdatePackages();
			}
		}
		
		private function tryUpdateMysteryBoxes() : void {
			TweenMax.killTweensOf(this.updateLabel);
			this.updateLabel.alpha = 1;
			this.mysteryBoxModel.updateSignal.add(this.onBoxUpdate);
			this.getMysteryBoxesTask.start();
			TweenMax.to(this.updateLabel,0.6,{
				"alpha":0,
				"yoyo":true,
				"repeat":-1
			});
		}
		
		private function tryUpdatePackages() : void {
			TweenMax.killTweensOf(this.updateLabel);
			this.updateLabel.alpha = 1;
			this.packageBoxModel.updateSignal.add(this.onPackageUpdate);
			this.getPackagesTask.start();
			TweenMax.to(this.updateLabel,0.6,{
				"alpha":0,
				"yoyo":true,
				"repeat":-1
			});
		}
		
		private function onBoxUpdate() : void {
			this.mysteryBoxModel.updateSignal.remove(this.onBoxUpdate);
			this.updateMysteryBoxes();
			TweenMax.killTweensOf(this.updateLabel);
			this.updateLabel.alpha = 0;
		}
		
		private function onPackageUpdate() : void {
			this.packageBoxModel.updateSignal.remove(this.onPackageUpdate);
			this.updatePackages();
			TweenMax.killTweensOf(this.updateLabel);
			this.updateLabel.alpha = 0;
		}
		
		private function onPackageClick(param1:BaseButton) : void {
			if(TabButton(param1).hasIndicator) {
				Parameters.data_["packages_indicator"] = new Date().getTime();
				TabButton(param1).showIndicator = false;
			}
		}
		
		override public function destroy() : void {
			this.updateTimer.stop();
			this.updateTimer.removeEventListener(TimerEvent.TIMER,this.tryUpdateMysteryBoxes);
			this.mysteryBoxModel.updateSignal.remove(this.onBoxUpdate);
			this.packageBoxModel.updateSignal.remove(this.onPackageUpdate);
			this.view.dispose();
			this.closeButton.dispose();
			this.addButton.dispose();
			this.gameModel.player.creditsWereChanged.remove(this.refreshCoins);
			this.gameModel.player.fameWasChanged.remove(this.refreshFame);
			this.tabs.dispose();
			this.mysteryBoxesGrid.dispose();
			this.packageBoxesGrid.dispose();
			this.toolTip = null;
			this.hoverTooltipDelegate.removeDisplayObject();
			this.hoverTooltipDelegate = null;
			if(this.packageTab) {
				this.packageTab.clickSignal.remove(this.onPackageClick);
			}
		}
		
		private function refreshCoins() : void {
			this.view.header.showCoins(132).coinsAmount = this.gameModel.player.credits_;
		}
		
		private function refreshFame() : void {
			this.view.header.showFame(132).fameAmount = this.gameModel.player.fame_;
		}
		
		private function onAdd(param1:BaseButton) : void {
			this.openMoneyWindow.dispatch();
		}
		
		private function onClose(param1:BaseButton) : void {
			this.closePopupSignal.dispatch(this.view);
		}
	}
}
