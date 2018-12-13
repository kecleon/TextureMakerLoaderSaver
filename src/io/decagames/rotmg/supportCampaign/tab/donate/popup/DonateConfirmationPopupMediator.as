package io.decagames.rotmg.supportCampaign.tab.donate.popup {
	import com.company.assembleegameclient.objects.Player;

	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.popups.header.PopupHeader;
	import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
	import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import io.decagames.rotmg.ui.texture.TextureParser;

	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class DonateConfirmationPopupMediator extends Mediator {


		[Inject]
		public var view:DonateConfirmationPopup;

		[Inject]
		public var showFade:ShowLockFade;

		[Inject]
		public var removeFade:RemoveLockFade;

		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var account:Account;

		[Inject]
		public var closePopupSignal:ClosePopupSignal;

		[Inject]
		public var model:SupporterCampaignModel;

		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var playerModel:PlayerModel;

		[Inject]
		public var showPopupSignal:ShowPopupSignal;

		private var closeButton:SliceScalingButton;

		public function DonateConfirmationPopupMediator() {
			super();
		}

		override public function initialize():void {
			this.view.donateButton.clickSignal.add(this.donateClick);
			this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
			this.closeButton.clickSignal.addOnce(this.onClose);
			this.view.header.addButton(this.closeButton, PopupHeader.RIGHT_BUTTON);
		}

		private function onClose(param1:BaseButton):void {
			this.closePopupSignal.dispatch(this.view);
		}

		override public function destroy():void {
			this.view.donateButton.clickSignal.remove(this.donateClick);
			this.closeButton.clickSignal.remove(this.onClose);
		}

		private function donateClick(param1:BaseButton):void {
			this.showFade.dispatch();
			var loc2:Object = this.account.getCredentials();
			loc2.amount = this.view.gold;
			this.client.sendRequest("/supportCampaign/donate", loc2);
			this.client.complete.addOnce(this.onDonateComplete);
		}

		private function onDonateComplete(param1:Boolean, param2:*):void {
			var xml:XML = null;
			var errorMessage:XML = null;
			var message:String = null;
			var isOK:Boolean = param1;
			var data:* = param2;
			this.removeFade.dispatch();
			this.closePopupSignal.dispatch(this.view);
			if (isOK) {
				try {
					xml = new XML(data);
					if (xml.hasOwnProperty("Gold")) {
						this.updateUserGold(int(xml.Gold));
					}
					this.model.parseUpdateData(xml);
				}
				catch (e:Error) {
					showPopupSignal.dispatch(new ErrorModal(300, "Campaign Error", "General campaign error."));
				}
			} else {
				try {
					errorMessage = new XML(data);
					message = LineBuilder.getLocalizedStringFromKey(errorMessage.toString(), {});
					this.showPopupSignal.dispatch(new ErrorModal(300, "Campaign Error", message == "" ? errorMessage.toString() : message));
					return;
				}
				catch (e:Error) {
					showPopupSignal.dispatch(new ErrorModal(300, "Campaign Error", "General campaign error."));
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
	}
}
