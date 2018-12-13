 
package io.decagames.rotmg.supportCampaign.tab.tiers.preview {
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import io.decagames.rotmg.shop.PurchaseInProgressModal;
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.supportCampaign.signals.TierSelectedSignal;
	import io.decagames.rotmg.supportCampaign.tab.tiers.popups.ClaimCompleteModal;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class TiersPreviewMediator extends Mediator {
		 
		
		[Inject]
		public var view:TiersPreview;
		
		[Inject]
		public var selectedSignal:TierSelectedSignal;
		
		[Inject]
		public var model:SupporterCampaignModel;
		
		[Inject]
		public var showPopupSignal:ShowPopupSignal;
		
		[Inject]
		public var account:Account;
		
		[Inject]
		public var client:AppEngineClient;
		
		[Inject]
		public var closePopupSignal:ClosePopupSignal;
		
		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;
		
		[Inject]
		public var hideTooltipSignal:HideTooltipsSignal;
		
		private var displayedTier:int;
		
		private var inProgressModal:PurchaseInProgressModal;
		
		private var toolTip:ToolTip = null;
		
		private var hoverTooltipDelegate:HoverTooltipDelegate;
		
		public function TiersPreviewMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.toolTip = new TextToolTip(3552822,1,"","You must claim previous Tiers rewards first!",200);
			this.hoverTooltipDelegate = new HoverTooltipDelegate();
			this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
			this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
			this.hoverTooltipDelegate.tooltip = this.toolTip;
			this.onTierSelected(this.view.startTier);
			this.view.leftArrow.clickSignal.add(this.onLeftClick);
			this.view.rightArrow.clickSignal.add(this.onRightClick);
			this.selectedSignal.add(this.onTierSelected);
			this.view.claimButton.clickSignal.add(this.onClaimClick);
			this.checkClaimedTiers();
		}
		
		override public function destroy() : void {
			this.view.leftArrow.clickSignal.remove(this.onLeftClick);
			this.view.rightArrow.clickSignal.remove(this.onRightClick);
			this.selectedSignal.remove(this.onTierSelected);
		}
		
		private function onClaimClick(param1:BaseButton) : void {
			if(this.model.claimed < this.model.rank) {
				this.inProgressModal = new PurchaseInProgressModal();
				this.showPopupSignal.dispatch(this.inProgressModal);
				this.sendClaimRequest();
			}
		}
		
		private function sendClaimRequest() : void {
			var loc1:Object = this.account.getCredentials();
			this.client.sendRequest("/supportCampaign/claim",loc1);
			this.client.complete.addOnce(this.onClaimRequestComplete);
		}
		
		private function onClaimRequestComplete(param1:Boolean, param2:*) : void {
			var xml:XML = null;
			var errorMessage:XML = null;
			var message:String = null;
			var isOK:Boolean = param1;
			var data:* = param2;
			this.closePopupSignal.dispatch(this.inProgressModal);
			if(isOK) {
				try {
					xml = new XML(data);
					this.model.parseUpdateData(xml);
				}
				catch(e:Error) {
					showPopupSignal.dispatch(new ErrorModal(300,"Campaign Error","General campaign error."));
					return;
				}
				this.showPopupSignal.dispatch(new ClaimCompleteModal());
			} else {
				try {
					errorMessage = new XML(data);
					message = LineBuilder.getLocalizedStringFromKey(errorMessage.toString(),{});
					this.showPopupSignal.dispatch(new ErrorModal(300,"Campaign Error",message == ""?errorMessage.toString():message));
					return;
				}
				catch(e:Error) {
					showPopupSignal.dispatch(new ErrorModal(300,"Campaign Error","General campaign error."));
					return;
				}
			}
		}
		
		private function onTierSelected(param1:int) : void {
			this.displayedTier = param1;
			this.view.rightArrow.disabled = false;
			this.view.rightArrow.alpha = 1;
			this.view.leftArrow.disabled = false;
			this.view.leftArrow.alpha = 1;
			if(this.displayedTier == 1) {
				this.view.leftArrow.disabled = true;
				this.view.leftArrow.alpha = 0.2;
			}
			if(this.displayedTier == this.model.ranks.length) {
				this.view.rightArrow.disabled = true;
				this.view.rightArrow.alpha = 0.2;
			}
			this.view.showTier(param1,this.model.rank,this.model.claimed);
			this.view.selectAnimation();
			this.checkClaimedTiers();
		}
		
		private function onLeftClick(param1:BaseButton) : void {
			this.displayedTier--;
			this.view.rightArrow.disabled = false;
			this.view.rightArrow.alpha = 1;
			if(this.displayedTier <= 1) {
				this.displayedTier = 1;
			}
			if(this.displayedTier == 1) {
				this.view.leftArrow.disabled = true;
				this.view.leftArrow.alpha = 0.2;
			}
			this.view.showTier(this.displayedTier,this.model.rank,this.model.claimed);
			this.view.selectAnimation();
			this.checkClaimedTiers();
			this.selectedSignal.dispatch(this.displayedTier);
		}
		
		private function onRightClick(param1:BaseButton) : void {
			this.displayedTier++;
			this.view.leftArrow.disabled = false;
			this.view.leftArrow.alpha = 1;
			if(this.displayedTier > this.model.ranks.length) {
				this.displayedTier = this.model.ranks.length;
			}
			if(this.displayedTier == this.model.ranks.length) {
				this.view.rightArrow.disabled = true;
				this.view.rightArrow.alpha = 0.2;
			}
			this.view.showTier(this.displayedTier,this.model.rank,this.model.claimed);
			this.view.selectAnimation();
			this.checkClaimedTiers();
			this.selectedSignal.dispatch(this.displayedTier);
		}
		
		private function checkClaimedTiers() : void {
			if(this.displayedTier - this.model.claimed > 1) {
				this.view.claimButton.disabled = true;
				this.hoverTooltipDelegate.setDisplayObject(this.view.claimButton);
			} else {
				this.view.claimButton.disabled = false;
				this.hoverTooltipDelegate.removeDisplayObject();
			}
		}
	}
}
