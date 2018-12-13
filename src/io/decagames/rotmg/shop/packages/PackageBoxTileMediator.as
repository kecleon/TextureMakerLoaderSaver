package io.decagames.rotmg.shop.packages {
	import com.company.assembleegameclient.objects.Player;

	import flash.events.MouseEvent;

	import io.decagames.rotmg.shop.PurchaseInProgressModal;
	import io.decagames.rotmg.shop.genericBox.BoxUtils;
	import io.decagames.rotmg.shop.packages.contentPopup.PackageBoxContentPopup;
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.packages.model.PackageInfo;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class PackageBoxTileMediator extends Mediator {


		[Inject]
		public var view:PackageBoxTile;

		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var playerModel:PlayerModel;

		[Inject]
		public var showPopupSignal:ShowPopupSignal;

		[Inject]
		public var openDialogSignal:OpenDialogSignal;

		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var account:Account;

		[Inject]
		public var closePopupSignal:ClosePopupSignal;

		[Inject]
		public var supportCampaignModel:SupporterCampaignModel;

		private var inProgressModal:PurchaseInProgressModal;

		public function PackageBoxTileMediator() {
			super();
		}

		override public function initialize():void {
			this.view.spinner.valueWasChanged.add(this.changeAmountHandler);
			this.view.buyButton.clickSignal.add(this.onBuyHandler);
			if (this.view.infoButton) {
				this.view.infoButton.clickSignal.add(this.onInfoClick);
			}
			if (this.view.clickMask) {
				this.view.clickMask.addEventListener(MouseEvent.CLICK, this.onBoxClickHandler);
			}
		}

		private function onBoxClickHandler(param1:MouseEvent):void {
			this.onInfoClick(null);
		}

		private function changeAmountHandler(param1:int):void {
			if (this.view.boxInfo.isOnSale()) {
				this.view.buyButton.price = param1 * int(this.view.boxInfo.saleAmount);
			} else {
				this.view.buyButton.price = param1 * int(this.view.boxInfo.priceAmount);
			}
		}

		private function onBuyHandler(param1:BaseButton):void {
			var loc2:Boolean = BoxUtils.moneyCheckPass(this.view.boxInfo, this.view.spinner.value, this.gameModel, this.playerModel, this.showPopupSignal);
			if (loc2) {
				this.inProgressModal = new PurchaseInProgressModal();
				this.showPopupSignal.dispatch(this.inProgressModal);
				this.sendPurchaseRequest();
			}
		}

		private function sendPurchaseRequest():void {
			var loc1:Object = this.account.getCredentials();
			loc1.boxId = this.view.boxInfo.id;
			if (this.view.boxInfo.isOnSale()) {
				loc1.quantity = this.view.spinner.value;
				loc1.price = this.view.boxInfo.saleAmount;
				loc1.currency = this.view.boxInfo.saleCurrency;
			} else {
				loc1.quantity = this.view.spinner.value;
				loc1.price = this.view.boxInfo.priceAmount;
				loc1.currency = this.view.boxInfo.priceCurrency;
			}
			this.client.sendRequest("/account/purchasePackage", loc1);
			this.client.complete.addOnce(this.onRollRequestComplete);
		}

		private function onRollRequestComplete(param1:Boolean, param2:*):void {
			var loc3:XML = null;
			var loc4:Player = null;
			var loc5:String = null;
			var loc6:Array = null;
			var loc7:int = 0;
			var loc8:Array = null;
			var loc9:int = 0;
			var loc10:Array = null;
			if (param1) {
				loc3 = new XML(param2);
				if (loc3.hasOwnProperty("CampaignProgress")) {
					this.supportCampaignModel.parseUpdateData(loc3.CampaignProgress);
				}
				if (loc3.hasOwnProperty("Left") && this.view.boxInfo.unitsLeft != -1) {
					this.view.boxInfo.unitsLeft = int(loc3.Left);
				}
				loc4 = this.gameModel.player;
				if (loc4 != null) {
					if (loc3.hasOwnProperty("Gold")) {
						loc4.setCredits(int(loc3.Gold));
					} else if (loc3.hasOwnProperty("Fame")) {
						loc4.setFame(int(loc3.Fame));
					}
				} else if (this.playerModel != null) {
					if (loc3.hasOwnProperty("Gold")) {
						this.playerModel.setCredits(int(loc3.Gold));
					} else if (loc3.hasOwnProperty("Fame")) {
						this.playerModel.setFame(int(loc3.Fame));
					}
				}
				this.closePopupSignal.dispatch(this.inProgressModal);
				this.showPopupSignal.dispatch(new PurchaseCompleteModal(PackageInfo(this.view.boxInfo).purchaseType));
			} else {
				loc5 = "MysteryBoxRollModal.pleaseTryAgainString";
				if (LineBuilder.getLocalizedStringFromKey(param2) != "") {
					loc5 = param2;
				}
				if (param2.indexOf("MysteryBoxError.soldOut") >= 0) {
					loc6 = param2.split("|");
					if (loc6.length == 2) {
						loc7 = loc6[1];
						if (loc7 == 0) {
							loc5 = "MysteryBoxError.soldOutAll";
						} else {
							loc5 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutLeft", {
								"left": this.view.boxInfo.unitsLeft,
								"box": (this.view.boxInfo.unitsLeft == 1 ? LineBuilder.getLocalizedStringFromKey("MysteryBoxError.box") : LineBuilder.getLocalizedStringFromKey("MysteryBoxError.boxes"))
							});
						}
					}
				}
				if (param2.indexOf("MysteryBoxError.maxPurchase") >= 0) {
					loc8 = param2.split("|");
					if (loc8.length == 2) {
						loc9 = loc8[1];
						if (loc9 == 0) {
							loc5 = "MysteryBoxError.maxPurchase";
						} else {
							loc5 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.maxPurchaseLeft", {"left": loc9});
						}
					}
				}
				if (param2.indexOf("blockedForUser") >= 0) {
					loc10 = param2.split("|");
					if (loc10.length == 2) {
						loc5 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.blockedForUser", {"date": loc10[1]});
					}
				}
				this.showErrorMessage(loc5);
			}
		}

		private function showErrorMessage(param1:String):void {
			this.closePopupSignal.dispatch(this.inProgressModal);
			this.showPopupSignal.dispatch(new ErrorModal(300, LineBuilder.getLocalizedStringFromKey("MysteryBoxRollModal.purchaseFailedString", {}), LineBuilder.getLocalizedStringFromKey(param1, {}).replace("box", "package")));
		}

		private function onInfoClick(param1:BaseButton):void {
			this.showPopupSignal.dispatch(new PackageBoxContentPopup(PackageInfo(this.view.boxInfo)));
		}

		override public function destroy():void {
			this.view.spinner.valueWasChanged.remove(this.changeAmountHandler);
			this.view.buyButton.clickSignal.remove(this.onBuyHandler);
			if (this.view.infoButton) {
				this.view.infoButton.clickSignal.remove(this.onInfoClick);
			}
			if (this.view.clickMask) {
				this.view.clickMask.removeEventListener(MouseEvent.CLICK, this.onBoxClickHandler);
			}
		}
	}
}
