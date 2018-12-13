package com.company.assembleegameclient.ui.panels.mediators {
	import com.company.assembleegameclient.map.Map;
	import com.company.assembleegameclient.objects.Container;
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.assembleegameclient.objects.OneWayContainer;
	import com.company.assembleegameclient.objects.Player;
	import com.company.assembleegameclient.parameters.Parameters;
	import com.company.assembleegameclient.sound.SoundEffectLibrary;
	import com.company.assembleegameclient.ui.panels.itemgrids.ContainerGrid;
	import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;
	import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTileEvent;
	import com.company.assembleegameclient.ui.tooltip.ToolTip;
	import com.company.assembleegameclient.util.DisplayHierarchy;

	import flash.utils.getTimer;

	import io.decagames.rotmg.pets.data.PetsModel;

	import kabam.rotmg.chat.model.ChatMessage;
	import kabam.rotmg.constants.ItemConstants;
	import kabam.rotmg.core.model.MapModel;
	import kabam.rotmg.core.model.PlayerModel;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.game.model.PotionInventoryModel;
	import kabam.rotmg.game.signals.AddTextLineSignal;
	import kabam.rotmg.game.view.components.TabStripView;
	import kabam.rotmg.messaging.impl.GameServerConnection;
	import kabam.rotmg.ui.model.HUDModel;
	import kabam.rotmg.ui.model.TabStripModel;

	import robotlegs.bender.bundles.mvcs.Mediator;

	public class ItemGridMediator extends Mediator {


		[Inject]
		public var view:ItemGrid;

		[Inject]
		public var mapModel:MapModel;

		[Inject]
		public var playerModel:PlayerModel;

		[Inject]
		public var potionInventoryModel:PotionInventoryModel;

		[Inject]
		public var hudModel:HUDModel;

		[Inject]
		public var tabStripModel:TabStripModel;

		[Inject]
		public var showToolTip:ShowTooltipSignal;

		[Inject]
		public var petsModel:PetsModel;

		[Inject]
		public var addTextLine:AddTextLineSignal;

		public function ItemGridMediator() {
			super();
		}

		override public function initialize():void {
			this.view.addEventListener(ItemTileEvent.ITEM_MOVE, this.onTileMove);
			this.view.addEventListener(ItemTileEvent.ITEM_SHIFT_CLICK, this.onShiftClick);
			this.view.addEventListener(ItemTileEvent.ITEM_DOUBLE_CLICK, this.onDoubleClick);
			this.view.addEventListener(ItemTileEvent.ITEM_CTRL_CLICK, this.onCtrlClick);
			this.view.addToolTip.add(this.onAddToolTip);
		}

		private function onAddToolTip(param1:ToolTip):void {
			this.showToolTip.dispatch(param1);
		}

		override public function destroy():void {
			super.destroy();
		}

		private function onTileMove(param1:ItemTileEvent):void {
			var loc4:InteractiveItemTile = null;
			var loc5:TabStripView = null;
			var loc6:int = 0;
			var loc2:InteractiveItemTile = param1.tile;
			if (this.swapTooSoon()) {
				loc2.resetItemPosition();
				return;
			}
			var loc3:* = DisplayHierarchy.getParentWithTypeArray(loc2.getDropTarget(), TabStripView, InteractiveItemTile, Map);
			if (loc2.getItemId() == PotionInventoryModel.HEALTH_POTION_ID || loc2.getItemId() == PotionInventoryModel.MAGIC_POTION_ID) {
				this.onPotionMove(param1);
				return;
			}
			if (loc3 is InteractiveItemTile) {
				loc4 = loc3 as InteractiveItemTile;
				if (this.view.curPlayer.lockedSlot[loc4.tileId] == 0) {
					if (this.canSwapItems(loc2, loc4)) {
						this.swapItemTiles(loc2, loc4);
					}
				} else {
					this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME, "You cannot put items into this slot right now."));
				}
			} else if (loc3 is TabStripView) {
				loc5 = loc3 as TabStripView;
				loc6 = loc2.ownerGrid.curPlayer.nextAvailableInventorySlot();
				if (loc6 != -1) {
					GameServerConnection.instance.invSwap(this.view.curPlayer, loc2.ownerGrid.owner, loc2.tileId, loc2.itemSprite.itemId, this.view.curPlayer, loc6, ItemConstants.NO_ITEM);
					loc2.setItem(ItemConstants.NO_ITEM);
					loc2.updateUseability(this.view.curPlayer);
				}
			} else if (loc3 is Map || this.hudModel.gameSprite.map.mouseX < 300) {
				this.dropItem(loc2);
			}
			loc2.resetItemPosition();
		}

		private function petFoodCancel(param1:InteractiveItemTile):Function {
			var itemSlot:InteractiveItemTile = param1;
			return function ():void {
				itemSlot.blockingItemUpdates = false;
			};
		}

		private function onPotionMove(param1:ItemTileEvent):void {
			var loc2:InteractiveItemTile = param1.tile;
			var loc3:* = DisplayHierarchy.getParentWithTypeArray(loc2.getDropTarget(), TabStripView, Map);
			if (loc3 is TabStripView) {
				this.addToPotionStack(loc2);
			} else if (loc3 is Map || this.hudModel.gameSprite.map.mouseX < 300) {
				this.dropItem(loc2);
			}
			loc2.resetItemPosition();
		}

		private function addToPotionStack(param1:InteractiveItemTile):void {
			if (!GameServerConnection.instance || !this.view.interactive || !param1 || this.potionInventoryModel.getPotionModel(param1.getItemId()).maxPotionCount <= this.hudModel.gameSprite.map.player_.getPotionCount(param1.getItemId())) {
				return;
			}
			GameServerConnection.instance.invSwapPotion(this.view.curPlayer, this.view.owner, param1.tileId, param1.itemSprite.itemId, this.view.curPlayer, PotionInventoryModel.getPotionSlot(param1.getItemId()), ItemConstants.NO_ITEM);
			param1.setItem(ItemConstants.NO_ITEM);
			param1.updateUseability(this.view.curPlayer);
		}

		private function canSwapItems(param1:InteractiveItemTile, param2:InteractiveItemTile):Boolean {
			if (!param1.canHoldItem(param2.getItemId())) {
				return false;
			}
			if (!param2.canHoldItem(param1.getItemId())) {
				return false;
			}
			if (ItemGrid(param2.parent).owner is OneWayContainer) {
				return false;
			}
			if (param1.blockingItemUpdates || param2.blockingItemUpdates) {
				return false;
			}
			return true;
		}

		private function dropItem(param1:InteractiveItemTile):void {
			var loc5:Container = null;
			var loc6:Vector.<int> = null;
			var loc7:int = 0;
			var loc8:int = 0;
			var loc2:Boolean = ObjectLibrary.isSoulbound(param1.itemSprite.itemId);
			var loc3:Boolean = ObjectLibrary.isDropTradable(param1.itemSprite.itemId);
			var loc4:Container = this.view.owner as Container;
			if (this.view.owner == this.view.curPlayer || loc4 && loc4.ownerId_ == this.view.curPlayer.accountId_ && !loc2) {
				loc5 = this.mapModel.currentInteractiveTarget as Container;
				if (loc5 && !(!loc5.canHaveSoulbound_ && !loc3 || loc5.canHaveSoulbound_ && loc5.isLoot_ && loc3)) {
					loc6 = loc5.equipment_;
					loc7 = loc6.length;
					loc8 = 0;
					while (loc8 < loc7) {
						if (loc6[loc8] < 0) {
							break;
						}
						loc8++;
					}
					if (loc8 < loc7) {
						this.dropWithoutDestTile(param1, loc5, loc8);
					} else {
						GameServerConnection.instance.invDrop(this.view.owner, param1.tileId, param1.getItemId());
					}
				} else {
					GameServerConnection.instance.invDrop(this.view.owner, param1.tileId, param1.getItemId());
				}
			} else if (loc4.canHaveSoulbound_ && loc4.isLoot_ && loc3) {
				GameServerConnection.instance.invDrop(this.view.owner, param1.tileId, param1.getItemId());
			}
			param1.setItem(-1);
		}

		private function swapItemTiles(param1:ItemTile, param2:ItemTile):Boolean {
			if (!GameServerConnection.instance || !this.view.interactive || !param1 || !param2) {
				return false;
			}
			GameServerConnection.instance.invSwap(this.view.curPlayer, this.view.owner, param1.tileId, param1.itemSprite.itemId, param2.ownerGrid.owner, param2.tileId, param2.itemSprite.itemId);
			var loc3:int = param1.getItemId();
			param1.setItem(param2.getItemId());
			param2.setItem(loc3);
			param1.updateUseability(this.view.curPlayer);
			param2.updateUseability(this.view.curPlayer);
			return true;
		}

		private function dropWithoutDestTile(param1:ItemTile, param2:Container, param3:int):void {
			if (!GameServerConnection.instance || !this.view.interactive || !param1 || !param2) {
				return;
			}
			GameServerConnection.instance.invSwap(this.view.curPlayer, this.view.owner, param1.tileId, param1.itemSprite.itemId, param2, param3, -1);
			param1.setItem(ItemConstants.NO_ITEM);
		}

		private function onShiftClick(param1:ItemTileEvent):void {
			var loc2:InteractiveItemTile = param1.tile;
			if (loc2.ownerGrid is InventoryGrid || loc2.ownerGrid is ContainerGrid) {
				GameServerConnection.instance.useItem_new(loc2.ownerGrid.owner, loc2.tileId);
			}
		}

		private function onCtrlClick(param1:ItemTileEvent):void {
			var loc2:InteractiveItemTile = null;
			var loc3:int = 0;
			if (this.swapTooSoon()) {
				return;
			}
			if (Parameters.data_.inventorySwap) {
				loc2 = param1.tile;
				if (loc2.ownerGrid is InventoryGrid) {
					loc3 = loc2.ownerGrid.curPlayer.swapInventoryIndex(this.tabStripModel.currentSelection);
					if (loc3 != -1) {
						GameServerConnection.instance.invSwap(this.view.curPlayer, loc2.ownerGrid.owner, loc2.tileId, loc2.itemSprite.itemId, this.view.curPlayer, loc3, ItemConstants.NO_ITEM);
						loc2.setItem(ItemConstants.NO_ITEM);
						loc2.updateUseability(this.view.curPlayer);
					}
				}
			}
		}

		private function onDoubleClick(param1:ItemTileEvent):void {
			if (this.swapTooSoon()) {
				return;
			}
			var loc2:InteractiveItemTile = param1.tile;
			if (this.isStackablePotion(loc2)) {
				this.addToPotionStack(loc2);
			} else if (loc2.ownerGrid is ContainerGrid) {
				this.equipOrUseContainer(loc2);
			} else {
				this.equipOrUseInventory(loc2);
			}
			this.view.refreshTooltip();
		}

		private function isStackablePotion(param1:InteractiveItemTile):Boolean {
			return param1.getItemId() == PotionInventoryModel.HEALTH_POTION_ID || param1.getItemId() == PotionInventoryModel.MAGIC_POTION_ID;
		}

		private function pickUpItem(param1:InteractiveItemTile):void {
			var loc2:int = this.view.curPlayer.nextAvailableInventorySlot();
			if (loc2 != -1) {
				GameServerConnection.instance.invSwap(this.view.curPlayer, this.view.owner, param1.tileId, param1.itemSprite.itemId, this.view.curPlayer, loc2, ItemConstants.NO_ITEM);
			}
		}

		private function equipOrUseContainer(param1:InteractiveItemTile):void {
			var loc2:GameObject = param1.ownerGrid.owner;
			var loc3:Player = this.view.curPlayer;
			var loc4:int = this.view.curPlayer.nextAvailableInventorySlot();
			if (loc4 != -1) {
				GameServerConnection.instance.invSwap(loc3, this.view.owner, param1.tileId, param1.itemSprite.itemId, this.view.curPlayer, loc4, ItemConstants.NO_ITEM);
			} else {
				GameServerConnection.instance.useItem_new(loc2, param1.tileId);
			}
		}

		private function equipOrUseInventory(param1:InteractiveItemTile):void {
			var loc2:GameObject = param1.ownerGrid.owner;
			var loc3:Player = this.view.curPlayer;
			var loc4:int = ObjectLibrary.getMatchingSlotIndex(param1.getItemId(), loc3);
			if (loc4 != -1) {
				GameServerConnection.instance.invSwap(loc3, loc2, param1.tileId, param1.getItemId(), loc3, loc4, loc3.equipment_[loc4]);
			} else {
				GameServerConnection.instance.useItem_new(loc2, param1.tileId);
			}
		}

		private function swapTooSoon():Boolean {
			var loc1:int = getTimer();
			if (this.view.curPlayer.lastSwap_ + 600 > loc1) {
				SoundEffectLibrary.play("error");
				return true;
			}
			this.view.curPlayer.lastSwap_ = loc1;
			return false;
		}
	}
}
