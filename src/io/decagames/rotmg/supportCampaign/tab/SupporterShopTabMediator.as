package io.decagames.rotmg.supportCampaign.tab {
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import com.company.assembleegameclient.util.Currency;

	import flash.events.Event;

	import io.decagames.rotmg.shop.NotEnoughResources;
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.supportCampaign.data.SupporterFeatures;
	import io.decagames.rotmg.supportCampaign.signals.TierSelectedSignal;
	import io.decagames.rotmg.supportCampaign.signals.UpdateCampaignProgress;
	import io.decagames.rotmg.supportCampaign.tooltips.SupportTooltip;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
	import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
	import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;
	import kabam.rotmg.ui.model.HUDModel;
	import kabam.rotmg.ui.signals.HUDModelInitialized;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class SupporterShopTabMediator extends Mediator {


		[Inject]
		public var view:SupporterShopTabView;

		[Inject]
		public var model:SupporterCampaignModel;

		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var playerModel:PlayerModel;

		[Inject]
		public var initHUDModelSignal:HUDModelInitialized;

		[Inject]
		public var hudModel:HUDModel;

		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;

		[Inject]
		public var hideTooltipSignal:HideTooltipsSignal;

		[Inject]
		public var showPopup:ShowPopupSignal;

		[Inject]
		public var showFade:ShowLockFade;

		[Inject]
		public var removeFade:RemoveLockFade;

		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var account:Account;

		[Inject]
		public var updatePointsSignal:UpdateCampaignProgress;

		[Inject]
		public var selectedSignal:TierSelectedSignal;

		private var infoToolTip:TextToolTip = null;

		private var supportToolTip:ToolTip;

		private var hoverTooltipDelegate:HoverTooltipDelegate;

		private var supportTooltipDelegate:HoverTooltipDelegate;

		public function SupporterShopTabMediator() {
			super();
		}

		override public function initialize():void {
			this.updatePointsSignal.add(this.onPointsUpdate);
			this.view.show(this.hudModel.getPlayerName(), this.model.isUnlocked, this.model.isStarted, this.model.unlockPrice, this.model.donatePointsRatio);
			if (!this.model.isStarted) {
				this.view.addEventListener(Event.ENTER_FRAME, this.updateStartCountdown);
			}
			if (this.model.isUnlocked) {
				this.updateCampaignInformation();
			}
			if (this.view.unlockButton) {
				this.view.unlockButton.clickSignal.add(this.unlockClick);
			}
			if (this.view.unlockButton) {
				this.supportToolTip = new SupportTooltip();
				this.supportTooltipDelegate = new HoverTooltipDelegate();
				this.supportTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
				this.supportTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
				this.supportTooltipDelegate.setDisplayObject(this.view.unlockButton);
				this.supportTooltipDelegate.tooltip = this.supportToolTip;
			}
		}

		private function updateCampaignInformation():void {
			this.view.updatePoints(this.model.points, this.model.rank);
			this.view.drawProgress(this.model.points, this.model.rankConfig, this.model.rank, this.model.claimed);
			this.updateInfoTooltip();
			this.view.showTier(this.model.nextClaimableTier, this.model.ranks, this.model.rank, this.model.claimed);
			this.view.updateTime(this.model.endDate.time - new Date().time);
		}

		private function updateStartCountdown(param1:Event):void {
			var loc2:String = this.model.getStartTimeString();
			if (loc2 == "") {
				this.view.removeEventListener(Event.ENTER_FRAME, this.updateStartCountdown);
				this.view.unlockButton.disabled = false;
			}
			this.view.updateStartCountdown(loc2);
		}

		override public function destroy():void {
			this.updatePointsSignal.remove(this.onPointsUpdate);
			if (this.view.unlockButton) {
				this.view.unlockButton.clickSignal.remove(this.unlockClick);
			}
			this.view.removeEventListener(Event.ENTER_FRAME, this.updateStartCountdown);
		}

		private function onPointsUpdate():void {
			this.view.updatePoints(this.model.points, this.model.rank);
			this.view.showTier(this.model.nextClaimableTier, this.model.ranks, this.model.rank, this.model.claimed);
			this.view.drawProgress(this.model.points, this.model.rankConfig, this.model.rank, this.model.claimed);
			this.updateInfoTooltip();
			this.selectedSignal.dispatch(this.model.nextClaimableTier);
			var loc1:Player = this.gameModel.player;
			if (loc1.hasSupporterFeature(SupporterFeatures.GLOW)) {
				loc1.supporterPoints = this.model.points;
				loc1.clearTextureCache();
			}
		}

		private function updateInfoTooltip():void {
			if (this.view.infoButton) {
				if (this.model.rank == 6) {
					this.infoToolTip = new TextToolTip(3552822, 15585539, (this.model.rank == 0 ? "No rank" : SupporterCampaignModel.RANKS_NAMES[this.model.rank - 1]) + " Supporter", "Thank you for your Support, " + this.hudModel.getPlayerName() + "!" + "\n\nYou have unlocked everything we had to offer, we are glad you are joining us on this journey <3 You can continue to Boost and further help shape the future of Realm of the Mad God." + "\n\nReach 100.000 points to unlock an exclusive character glow!", 220);
				} else {
					this.infoToolTip = new TextToolTip(3552822, 10197915, (this.model.rank == 0 ? "No rank" : SupporterCampaignModel.RANKS_NAMES[this.model.rank - 1]) + " Supporter", "Thank you for your Support, " + this.hudModel.getPlayerName() + "!" + "\n\nWe are bringing your favorite bullet-hell MMO to Unity!", 220);
				}
				this.hoverTooltipDelegate = new HoverTooltipDelegate();
				this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
				this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
				this.hoverTooltipDelegate.setDisplayObject(this.view.infoButton);
				this.hoverTooltipDelegate.tooltip = this.infoToolTip;
			}
		}

		private function unlockClick(param1:BaseButton):void {
			if (this.currentGold < this.model.unlockPrice) {
				this.showPopup.dispatch(new NotEnoughResources(300, Currency.GOLD));
				return;
			}
			this.showFade.dispatch();
			var loc2:Object = this.account.getCredentials();
			this.client.sendRequest("/supportCampaign/unlock", loc2);
			this.client.complete.addOnce(this.onUnlockComplete);
		}

		private function onUnlockComplete(param1:Boolean, param2:*):void {
			var xml:XML = null;
			var errorMessage:XML = null;
			var message:String = null;
			var isOK:Boolean = param1;
			var data:* = param2;
			this.removeFade.dispatch();
			if (isOK) {
				try {
					xml = new XML(data);
					if (xml.hasOwnProperty("Gold")) {
						this.updateUserGold(int(xml.Gold));
					}
					this.view.show(null, true, this.model.isStarted, this.model.unlockPrice, this.model.donatePointsRatio);
					this.model.parseUpdateData(xml);
					this.updateCampaignInformation();
				}
				catch (e:Error) {
					showPopup.dispatch(new ErrorModal(300, "Campaign Error", "General campaign error."));
					return;
				}
			} else {
				try {
					errorMessage = new XML(data);
					message = LineBuilder.getLocalizedStringFromKey(errorMessage.toString(), {});
					this.showPopup.dispatch(new ErrorModal(300, "Campaign Error", message == "" ? errorMessage.toString() : message));
					return;
				}
				catch (e:Error) {
					showPopup.dispatch(new ErrorModal(300, "Campaign Error", "General campaign error."));
					return;
				}
			}
		}

		private function updateUserGold(param1:int):void {
			var loc2:Player = this.gameModel.player;
			if (loc2 != null) {
				loc2.setCredits(param1);
			} else {
				this.playerModel.setCredits(param1);
			}
		}

		private function get currentGold():int {
			var loc1:Player = this.gameModel.player;
			if (loc1 != null) {
				return loc1.credits_;
			}
			if (this.playerModel != null) {
				return this.playerModel.getCredits();
			}
			return 0;
		}
	}
}
