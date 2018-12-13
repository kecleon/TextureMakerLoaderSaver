package io.decagames.rotmg.shop.mysteryBox.rollModal {
	import com.company.assembleegameclient.objects.Player;

	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import io.decagames.rotmg.shop.genericBox.BoxUtils;
	import io.decagames.rotmg.supportCampaign.data.SupporterCampaignModel;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.buttons.SliceScalingButton;
	import io.decagames.rotmg.ui.popups.header.PopupHeader;
	import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
	import io.decagames.rotmg.ui.popups.signals.ClosePopupSignal;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
	import io.decagames.rotmg.ui.texture.TextureParser;
	import io.decagames.rotmg.utils.dictionary.DictionaryUtils;

	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.appengine.api.AppEngineClient;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class MysteryBoxRollModalMediator extends Mediator {


		[Inject]
		public var view:MysteryBoxRollModal;

		[Inject]
		public var client:AppEngineClient;

		[Inject]
		public var account:Account;

		[Inject]
		public var closePopupSignal:ClosePopupSignal;

		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var playerModel:PlayerModel;

		[Inject]
		public var showPopupSignal:ShowPopupSignal;

		[Inject]
		public var getMysteryBoxesTask:GetMysteryBoxesTask;

		[Inject]
		public var supportCampaignModel:SupporterCampaignModel;

		private var boxConfig:Array;

		private var swapImageTimer:Timer;

		private var totalRollDelay:int = 2000;

		private var nextRollDelay:int = 550;

		private var quantity:int = 1;

		private var requestComplete:Boolean;

		private var timerComplete:Boolean;

		private var rollNumber:int = 0;

		private var timeout:uint;

		private var rewardsList:Array;

		private var totalRewards:int = 0;

		private var closeButton:SliceScalingButton;

		private var totalRolls:int = 1;

		public function MysteryBoxRollModalMediator() {
			this.swapImageTimer = new Timer(80);
			this.rewardsList = [];
			super();
		}

		override public function initialize():void {
			this.configureRoll();
			this.swapImageTimer.addEventListener(TimerEvent.TIMER, this.swapItems);
			this.closeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
			this.closeButton.clickSignal.addOnce(this.onClose);
			this.view.header.addButton(this.closeButton, PopupHeader.RIGHT_BUTTON);
			this.boxConfig = this.parseBoxContents();
			this.quantity = this.view.quantity;
			this.playRollAnimation();
			this.sendRollRequest();
		}

		override public function destroy():void {
			this.closeButton.clickSignal.remove(this.onClose);
			this.closeButton.dispose();
			this.swapImageTimer.removeEventListener(TimerEvent.TIMER, this.swapItems);
			this.view.spinner.valueWasChanged.remove(this.changeAmountHandler);
			this.view.buyButton.clickSignal.remove(this.buyMore);
			this.view.finishedShowingResult.remove(this.onAnimationFinished);
			clearTimeout(this.timeout);
		}

		private function sendRollRequest():void {
			this.view.spinner.valueWasChanged.remove(this.changeAmountHandler);
			this.view.buyButton.clickSignal.remove(this.buyMore);
			this.closeButton.clickSignal.remove(this.onClose);
			this.requestComplete = false;
			this.timerComplete = false;
			var loc1:Object = this.account.getCredentials();
			loc1.boxId = this.view.info.id;
			if (this.view.info.isOnSale()) {
				loc1.quantity = this.quantity;
				loc1.price = this.view.info.saleAmount;
				loc1.currency = this.view.info.saleCurrency;
			} else {
				loc1.quantity = this.quantity;
				loc1.price = this.view.info.priceAmount;
				loc1.currency = this.view.info.priceCurrency;
			}
			this.client.sendRequest("/account/purchaseMysteryBox", loc1);
			this.client.complete.addOnce(this.onRollRequestComplete);
			this.timeout = setTimeout(this.showRewards, this.totalRollDelay);
		}

		private function showRewards():void {
			var loc1:Dictionary = null;
			this.timerComplete = true;
			clearTimeout(this.timeout);
			if (this.requestComplete) {
				this.view.finishedShowingResult.add(this.onAnimationFinished);
				this.view.bigSpinner.pause();
				this.view.littleSpinner.pause();
				this.swapImageTimer.stop();
				loc1 = this.rewardsList[this.rollNumber];
				if (this.rollNumber == 0) {
					this.view.prepareResultGrid(this.totalRewards);
				}
				this.view.displayResult([loc1]);
			}
		}

		private function onRollRequestComplete(param1:Boolean, param2:*):void {
			var loc3:XML = null;
			var loc4:XML = null;
			var loc5:Player = null;
			var loc6:Array = null;
			var loc7:Dictionary = null;
			var loc8:String = null;
			var loc9:Array = null;
			var loc10:int = 0;
			var loc11:Array = null;
			var loc12:int = 0;
			var loc13:Array = null;
			this.requestComplete = true;
			if (param1) {
				loc3 = new XML(param2);
				this.rewardsList = [];
				if (loc3.hasOwnProperty("CampaignProgress")) {
					this.supportCampaignModel.parseUpdateData(loc3.CampaignProgress);
				}
				for each(loc4 in loc3.elements("Awards")) {
					loc6 = loc4.toString().split(",");
					loc7 = this.convertItemsToAmountDictionary(loc6);
					this.totalRewards = this.totalRewards + DictionaryUtils.countKeys(loc7);
					this.rewardsList.push(loc7);
				}
				if (loc3.hasOwnProperty("Left") && this.view.info.unitsLeft != -1) {
					this.view.info.unitsLeft = int(loc3.Left);
					if (this.view.info.unitsLeft == 0) {
						this.view.buyButton.soldOut = true;
					}
				}
				loc5 = this.gameModel.player;
				if (loc5 != null) {
					if (loc3.hasOwnProperty("Gold")) {
						loc5.setCredits(int(loc3.Gold));
					} else if (loc3.hasOwnProperty("Fame")) {
						loc5.setFame(int(loc3.Fame));
					}
				} else if (this.playerModel != null) {
					if (loc3.hasOwnProperty("Gold")) {
						this.playerModel.setCredits(int(loc3.Gold));
					} else if (loc3.hasOwnProperty("Fame")) {
						this.playerModel.setFame(int(loc3.Fame));
					}
				}
				if (this.timerComplete) {
					this.showRewards();
				}
			} else {
				clearTimeout(this.timeout);
				loc8 = "MysteryBoxRollModal.pleaseTryAgainString";
				if (LineBuilder.getLocalizedStringFromKey(param2) != "") {
					loc8 = param2;
				}
				if (param2.indexOf("MysteryBoxError.soldOut") >= 0) {
					loc9 = param2.split("|");
					if (loc9.length == 2) {
						loc10 = loc9[1];
						this.view.info.unitsLeft = loc10;
						if (loc10 == 0) {
							loc8 = "MysteryBoxError.soldOutAll";
						} else {
							loc8 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.soldOutLeft", {
								"left": this.view.info.unitsLeft,
								"box": (this.view.info.unitsLeft == 1 ? LineBuilder.getLocalizedStringFromKey("MysteryBoxError.box") : LineBuilder.getLocalizedStringFromKey("MysteryBoxError.boxes"))
							});
						}
					}
				}
				if (param2.indexOf("MysteryBoxError.maxPurchase") >= 0) {
					loc11 = param2.split("|");
					if (loc11.length == 2) {
						loc12 = loc11[1];
						if (loc12 == 0) {
							loc8 = "MysteryBoxError.maxPurchase";
						} else {
							loc8 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.maxPurchaseLeft", {"left": loc12});
						}
					}
				}
				if (param2.indexOf("blockedForUser") >= 0) {
					loc13 = param2.split("|");
					if (loc13.length == 2) {
						loc8 = LineBuilder.getLocalizedStringFromKey("MysteryBoxError.blockedForUser", {"date": loc13[1]});
					}
				}
				this.showErrorMessage(loc8);
			}
		}

		private function showErrorMessage(param1:String):void {
			this.closePopupSignal.dispatch(this.view);
			this.showPopupSignal.dispatch(new ErrorModal(300, LineBuilder.getLocalizedStringFromKey("MysteryBoxRollModal.purchaseFailedString", {}), LineBuilder.getLocalizedStringFromKey(param1, {})));
			this.getMysteryBoxesTask.start();
		}

		private function configureRoll():void {
			if (this.view.info.quantity > 1) {
				this.totalRollDelay = 1000;
			}
		}

		private function convertItemsToAmountDictionary(param1:Array):Dictionary {
			var loc3:String = null;
			var loc2:Dictionary = new Dictionary();
			for each(loc3 in param1) {
				if (loc2[loc3]) {
					loc2[loc3]++;
				} else {
					loc2[loc3] = 1;
				}
			}
			return loc2;
		}

		private function parseBoxContents():Array {
			var loc4:String = null;
			var loc5:Array = null;
			var loc6:Array = null;
			var loc7:String = null;
			var loc1:Array = this.view.info.contents.split("|");
			var loc2:Array = [];
			var loc3:int = 0;
			for each(loc4 in loc1) {
				loc5 = [];
				loc6 = loc4.split(";");
				for each(loc7 in loc6) {
					loc5.push(this.convertItemsToAmountDictionary(loc7.split(",")));
				}
				loc2[loc3] = loc5;
				loc3++;
			}
			this.totalRolls = loc3;
			return loc2;
		}

		private function onAnimationFinished():void {
			this.rollNumber++;
			if (this.rollNumber < this.view.quantity) {
				this.playRollAnimation();
				this.timeout = setTimeout(this.showRewards, this.view.totalAnimationTime(this.totalRolls) + this.nextRollDelay);
			} else {
				this.closeButton.clickSignal.addOnce(this.onClose);
				this.view.spinner.valueWasChanged.add(this.changeAmountHandler);
				this.view.spinner.value = this.view.quantity;
				this.view.showBuyButton();
				this.view.buyButton.clickSignal.add(this.buyMore);
			}
		}

		private function changeAmountHandler(param1:int):void {
			if (this.view.info.isOnSale()) {
				this.view.buyButton.price = param1 * int(this.view.info.saleAmount);
			} else {
				this.view.buyButton.price = param1 * int(this.view.info.priceAmount);
			}
		}

		private function buyMore(param1:BaseButton):void {
			var loc2:Boolean = BoxUtils.moneyCheckPass(this.view.info, this.view.spinner.value, this.gameModel, this.playerModel, this.showPopupSignal);
			if (loc2) {
				this.rollNumber = 0;
				this.totalRewards = 0;
				this.view.buyMore(this.view.spinner.value);
				this.configureRoll();
				this.quantity = this.view.quantity;
				this.playRollAnimation();
				this.sendRollRequest();
			}
		}

		private function playRollAnimation():void {
			this.view.bigSpinner.resume();
			this.view.littleSpinner.resume();
			this.swapImageTimer.start();
			this.swapItems(null);
		}

		private function swapItems(param1:TimerEvent):void {
			var loc3:Array = null;
			var loc4:int = 0;
			var loc2:Array = [];
			for each(loc3 in this.boxConfig) {
				loc4 = Math.floor(Math.random() * loc3.length);
				loc2.push(loc3[loc4]);
			}
			this.view.displayItems(loc2);
		}

		private function onClose(param1:BaseButton):void {
			this.closePopupSignal.dispatch(this.view);
		}
	}
}
