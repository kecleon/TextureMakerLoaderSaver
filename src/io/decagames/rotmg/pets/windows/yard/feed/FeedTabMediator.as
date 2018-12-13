package io.decagames.rotmg.pets.windows.yard.feed {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
	import com.company.assembleegameclient.util.Currency;

	import io.decagames.rotmg.pets.data.PetsModel;
	import io.decagames.rotmg.pets.data.vo.PetVO;
	import io.decagames.rotmg.pets.data.vo.requests.FeedPetRequestVO;
	import io.decagames.rotmg.pets.signals.SelectFeedItemSignal;
	import io.decagames.rotmg.pets.signals.SelectPetSignal;
	import io.decagames.rotmg.pets.signals.SimulateFeedSignal;
	import io.decagames.rotmg.pets.signals.UpgradePetSignal;
	import io.decagames.rotmg.pets.utils.FeedFuseCostModel;
	import io.decagames.rotmg.pets.windows.yard.feed.items.FeedItem;
	import io.decagames.rotmg.shop.NotEnoughResources;
	import io.decagames.rotmg.ui.buttons.BaseButton;
	import io.decagames.rotmg.ui.popups.modal.error.ErrorModal;
	import io.decagames.rotmg.ui.popups.signals.RemoveLockFade;
	import io.decagames.rotmg.ui.popups.signals.ShowLockFade;
	import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.game.model.GameModel;
	import kabam.rotmg.game.view.components.InventoryTabContent;
	import kabam.rotmg.messaging.impl.PetUpgradeRequest;
	import kabam.rotmg.messaging.impl.data.SlotObjectData;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.ui.model.HUDModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class FeedTabMediator extends Mediator {


		[Inject]
		public var view:FeedTab;

		[Inject]
		public var hud:HUDModel;

		[Inject]
		public var model:PetsModel;

		[Inject]
		public var selectFeedItemSignal:SelectFeedItemSignal;

		[Inject]
		public var selectPetSignal:SelectPetSignal;

		[Inject]
		public var gameModel:GameModel;

		[Inject]
		public var playerModel:PlayerModel;

		[Inject]
		public var showPopup:ShowPopupSignal;

		[Inject]
		public var upgradePet:UpgradePetSignal;

		[Inject]
		public var showFade:ShowLockFade;

		[Inject]
		public var removeFade:RemoveLockFade;

		[Inject]
		public var simulateFeed:SimulateFeedSignal;

		private var currentPet:PetVO;

		private var items:Vector.<FeedItem>;

		public function FeedTabMediator() {
			super();
		}

		override public function initialize():void {
			this.currentPet = !!this.model.activeUIVO ? this.model.activeUIVO : this.model.getActivePet();
			this.selectPetSignal.add(this.onPetSelected);
			this.items = new Vector.<FeedItem>();
			this.selectFeedItemSignal.add(this.refreshFeedPower);
			this.view.feedGoldButton.clickSignal.add(this.purchaseGold);
			this.view.feedFameButton.clickSignal.add(this.purchaseFame);
			this.view.displaySignal.add(this.showHideSignal);
			this.renderItems();
			this.refreshFeedPower();
		}

		override public function destroy():void {
			this.items = new Vector.<FeedItem>();
			this.selectFeedItemSignal.remove(this.refreshFeedPower);
			this.selectPetSignal.remove(this.onPetSelected);
			this.view.feedGoldButton.clickSignal.remove(this.purchaseGold);
			this.view.feedFameButton.clickSignal.remove(this.purchaseFame);
			this.view.displaySignal.remove(this.showHideSignal);
		}

		private function showHideSignal(param1:Boolean):void {
			var loc2:FeedItem = null;
			if (!param1) {
				for each(loc2 in this.items) {
					loc2.selected = false;
				}
				this.refreshFeedPower();
			}
		}

		private function renderItems():void {
			var loc3:InventoryTile = null;
			var loc4:int = 0;
			var loc5:FeedItem = null;
			this.view.clearGrid();
			this.items = new Vector.<FeedItem>();
			var loc1:InventoryTabContent = this.hud.gameSprite.hudView.tabStrip.getTabView(InventoryTabContent);
			var loc2:Vector.<InventoryTile> = new Vector.<InventoryTile>();
			if (loc1) {
				loc2 = loc2.concat(loc1.storage.tiles);
			}
			for each(loc3 in loc2) {
				loc4 = loc3.getItemId();
				if (loc4 != -1 && this.hasFeedPower(loc4)) {
					loc5 = new FeedItem(loc3);
					this.items.push(loc5);
					this.view.addItem(loc5);
				}
			}
		}

		private function refreshFeedPower():void {
			var loc3:FeedItem = null;
			var loc1:int = 0;
			var loc2:int = 0;
			for each(loc3 in this.items) {
				if (loc3.selected) {
					loc1 = loc1 + loc3.feedPower;
					loc2++;
				}
			}
			if (this.currentPet) {
				this.view.feedGoldButton.price = FeedFuseCostModel.getFeedGoldCost(this.currentPet.rarity) * loc2;
				this.view.feedFameButton.price = FeedFuseCostModel.getFeedFameCost(this.currentPet.rarity) * loc2;
				this.view.updateFeedPower(loc1, this.currentPet.maxedAvailableAbilities());
			} else {
				this.view.feedGoldButton.price = 0;
				this.view.feedFameButton.price = 0;
				this.view.updateFeedPower(0, false);
			}
			this.simulateFeed.dispatch(loc1);
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

		private function get currentFame():int {
			var loc1:Player = this.gameModel.player;
			if (loc1 != null) {
				return loc1.fame_;
			}
			if (this.playerModel != null) {
				return this.playerModel.getFame();
			}
			return 0;
		}

		private function hasFeedPower(param1:int):Boolean {
			var loc2:XML = ObjectLibrary.xmlLibrary_[param1];
			return loc2.hasOwnProperty("feedPower");
		}

		private function purchaseFame(param1:BaseButton):void {
			this.purchase(PetUpgradeRequest.FAME_PAYMENT_TYPE, this.view.feedFameButton.price);
		}

		private function purchaseGold(param1:BaseButton):void {
			this.purchase(PetUpgradeRequest.GOLD_PAYMENT_TYPE, this.view.feedGoldButton.price);
		}

		private function purchase(param1:int, param2:int):void {
			var loc4:FeedItem = null;
			var loc5:FeedPetRequestVO = null;
			var loc6:SlotObjectData = null;
			if (!this.checkYardType()) {
				return;
			}
			if (param1 == PetUpgradeRequest.GOLD_PAYMENT_TYPE && this.currentGold < param2) {
				this.showPopup.dispatch(new NotEnoughResources(300, Currency.GOLD));
				return;
			}
			if (param1 == PetUpgradeRequest.FAME_PAYMENT_TYPE && this.currentFame < param2) {
				this.showPopup.dispatch(new NotEnoughResources(300, Currency.FAME));
				return;
			}
			var loc3:Vector.<SlotObjectData> = new Vector.<SlotObjectData>();
			for each(loc4 in this.items) {
				if (loc4.selected) {
					loc6 = new SlotObjectData();
					loc6.objectId_ = loc4.item.ownerGrid.owner.objectId_;
					loc6.objectType_ = loc4.item.getItemId();
					loc6.slotId_ = loc4.item.tileId;
					loc3.push(loc6);
				}
			}
			this.currentPet.abilityUpdated.addOnce(this.abilityUpdated);
			this.showFade.dispatch();
			loc5 = new FeedPetRequestVO(this.currentPet.getID(), loc3, param1);
			this.upgradePet.dispatch(loc5);
		}

		private function abilityUpdated():void {
			var loc1:FeedItem = null;
			this.removeFade.dispatch();
			this.renderItems();
			for each(loc1 in this.items) {
				loc1.selected = false;
			}
			this.refreshFeedPower();
		}

		private function onPetSelected(param1:PetVO):void {
			var loc2:FeedItem = null;
			this.currentPet = param1;
			for each(loc2 in this.items) {
				loc2.selected = false;
			}
			this.refreshFeedPower();
		}

		private function checkYardType():Boolean {
			if (this.currentPet.rarity.ordinal >= this.model.getPetYardType()) {
				this.showPopup.dispatch(new ErrorModal(350, "Feed Pets", LineBuilder.getLocalizedStringFromKey("server.upgrade_petyard_first")));
				return false;
			}
			return true;
		}
	}
}
