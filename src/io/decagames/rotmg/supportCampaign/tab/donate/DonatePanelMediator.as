package io.decagames.rotmg.supportCampaign.tab.donate {
	import com.company.assembleegameclient.ui.tooltip.ToolTip;

	import flash.events.Event;

	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.supportCampaign.tab.donate.popup.DonateConfirmationPopup;
	import io.decagames.rotmg.supportCampaign.tooltips.SupportTooltip;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class DonatePanelMediator extends Mediator {


		[Inject]
		public var view:DonatePanel;

		[Inject]
		public var showPopupSignal:ShowPopupSignal;

		[Inject]
		public var model:SupporterCampaignModel;

		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;

		[Inject]
		public var hideTooltipSignal:HideTooltipsSignal;

		private var supportToolTip:ToolTip;

		private var supportTooltipDelegate:HoverTooltipDelegate;

		public function DonatePanelMediator() {
			super();
		}

		override public function initialize():void {
			this.view.upArrow.clickSignal.add(this.upClickHandler);
			this.view.downArrow.clickSignal.add(this.downClickHandler);
			this.view.donateButton.clickSignal.add(this.donateClickHandler);
			this.view.amountTextfield.addEventListener(Event.CHANGE, this.onAmountChange);
			if (this.view.donateButton) {
				this.supportToolTip = new SupportTooltip();
				this.supportTooltipDelegate = new HoverTooltipDelegate();
				this.supportTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
				this.supportTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
				this.supportTooltipDelegate.setDisplayObject(this.view.donateButton);
				this.supportTooltipDelegate.tooltip = this.supportToolTip;
			}
		}

		override public function destroy():void {
			this.view.upArrow.clickSignal.remove(this.upClickHandler);
			this.view.downArrow.clickSignal.remove(this.downClickHandler);
			this.view.donateButton.clickSignal.remove(this.donateClickHandler);
			this.view.amountTextfield.removeEventListener(Event.CHANGE, this.onAmountChange);
		}

		private function onAmountChange(param1:Event):void {
			this.view.updateDonateAmount();
		}

		private function upClickHandler(param1:BaseButton):void {
			this.view.addDonateAmount(SupporterCampaignModel.DEFAULT_DONATE_SPINNER_STEP);
		}

		private function downClickHandler(param1:BaseButton):void {
			this.view.addDonateAmount(-SupporterCampaignModel.DEFAULT_DONATE_SPINNER_STEP);
		}

		private function donateClickHandler(param1:BaseButton):void {
			this.showPopupSignal.dispatch(new DonateConfirmationPopup(this.view.gold, this.view.gold * this.model.donatePointsRatio));
		}
	}
}
