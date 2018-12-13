 
package io.decagames.rotmg.supportCampaign.tab.tiers.button {
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import flash.events.MouseEvent;
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.supportCampaign.signals.TierSelectedSignal;
	import io.decagames.rotmg.supportCampaign.signals.UpdateCampaignProgress;
	import io.decagames.rotmg.supportCampaign.tab.tiers.button.status.TierButtonStatus;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class TierButtonMediator extends Mediator {
		 
		
		[Inject]
		public var view:TierButton;
		
		[Inject]
		public var model:SupporterCampaignModel;
		
		[Inject]
		public var updatePointsSignal:UpdateCampaignProgress;
		
		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;
		
		[Inject]
		public var hideTooltipSignal:HideTooltipsSignal;
		
		[Inject]
		public var selectedSignal:TierSelectedSignal;
		
		private var toolTip:TextToolTip = null;
		
		private var hoverTooltipDelegate:HoverTooltipDelegate;
		
		private var remainingPoints:int;
		
		private var rankName:String;
		
		public function TierButtonMediator() {
			super();
		}
		
		override public function initialize() : void {
			this.updatePointsSignal.add(this.onPointsUpdate);
			this.view.addEventListener(MouseEvent.CLICK,this.onClickHandler);
			this.selectedSignal.add(this.onTierSelected);
			this.updateTooltip();
		}
		
		override public function destroy() : void {
			this.updatePointsSignal.remove(this.onPointsUpdate);
			this.view.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
			this.selectedSignal.remove(this.onTierSelected);
		}
		
		private function onClickHandler(param1:MouseEvent) : void {
			if(!this.view.selected) {
				this.view.selected = true;
				this.selectedSignal.dispatch(this.view.tier);
			}
		}
		
		private function onPointsUpdate() : void {
			this.updateTooltip();
		}
		
		private function updateTooltip() : void {
			this.remainingPoints = this.model.ranks[this.view.tier - 1] - this.model.points;
			this.rankName = SupporterCampaignModel.RANKS_NAMES[this.view.tier - 1];
			if(this.view.label && TierButtonStatus.LOCKED || TierButtonStatus.UNLOCKED) {
				if(this.remainingPoints <= 0) {
					this.toolTip = new TextToolTip(3552822,4958208,this.rankName + " Supporter","Claim your Gifts!",180);
				} else {
					this.toolTip = new TextToolTip(3552822,10197915,this.rankName + " Supporter",this.remainingPoints.toString() + " remaining",180);
				}
				this.hoverTooltipDelegate = new HoverTooltipDelegate();
				this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
				this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
				this.hoverTooltipDelegate.setDisplayObject(this.view.label);
				this.hoverTooltipDelegate.tooltip = this.toolTip;
			}
		}
		
		private function onTierSelected(param1:int) : void {
			if(this.view.tier == param1 && !this.view.selected) {
				this.view.selected = true;
			}
			if(this.view.tier != param1 && this.view.selected) {
				this.view.selected = false;
			}
		}
	}
}
