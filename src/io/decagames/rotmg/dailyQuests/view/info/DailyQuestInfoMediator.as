 
package io.decagames.rotmg.dailyQuests.view.info {
	import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
	import com.company.assembleegameclient.ui.tooltip.TextToolTip;
	import flash.events.MouseEvent;
	import io.decagames.rotmg.dailyQuests.model.DailyQuest;
	import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
	import io.decagames.rotmg.dailyQuests.signal.LockQuestScreenSignal;
	import io.decagames.rotmg.dailyQuests.signal.QuestRedeemCompleteSignal;
	import io.decagames.rotmg.dailyQuests.signal.SelectedItemSlotsSignal;
	import io.decagames.rotmg.dailyQuests.signal.ShowQuestInfoSignal;
	import kabam.rotmg.core.signals.HideTooltipsSignal;
	import kabam.rotmg.core.signals.ShowTooltipSignal;
	import kabam.rotmg.game.view.components.BackpackTabContent;
	import kabam.rotmg.game.view.components.InventoryTabContent;
	import kabam.rotmg.messaging.impl.data.SlotObjectData;
	import kabam.rotmg.tooltips.HoverTooltipDelegate;
	import kabam.rotmg.ui.model.HUDModel;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class DailyQuestInfoMediator extends Mediator {
		 
		
		[Inject]
		public var showInfoSignal:ShowQuestInfoSignal;
		
		[Inject]
		public var view:DailyQuestInfo;
		
		[Inject]
		public var model:DailyQuestsModel;
		
		[Inject]
		public var hud:HUDModel;
		
		[Inject]
		public var redeemCompleteSignal:QuestRedeemCompleteSignal;
		
		[Inject]
		public var lockScreen:LockQuestScreenSignal;
		
		[Inject]
		public var selectedItemSlotsSignal:SelectedItemSlotsSignal;
		
		[Inject]
		public var showTooltipSignal:ShowTooltipSignal;
		
		[Inject]
		public var hideTooltipsSignal:HideTooltipsSignal;
		
		private var tooltip:TextToolTip;
		
		private var hoverTooltipDelegate:HoverTooltipDelegate;
		
		public function DailyQuestInfoMediator() {
			this.hoverTooltipDelegate = new HoverTooltipDelegate();
			super();
		}
		
		override public function initialize() : void {
			this.showInfoSignal.add(this.showQuestInfo);
			var loc1:DailyQuest = this.model.first;
			if(loc1) {
				this.showQuestInfo(loc1.id);
			}
			this.tooltip = new TextToolTip(3552822,10197915,"","You must select a reward first!",190,null);
			this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipsSignal);
			this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
			this.hoverTooltipDelegate.tooltip = this.tooltip;
			this.view.completeButton.addEventListener(MouseEvent.CLICK,this.onCompleteButtonClickHandler);
			this.selectedItemSlotsSignal.add(this.itemSelectedHandler);
		}
		
		private function itemSelectedHandler(param1:int) : void {
			this.view.completeButton.disabled = !!this.model.currentQuest.completed?true:this.model.selectedItem == -1?true:!DailyQuestInfo.hasAllItems(this.model.currentQuest.requirements,this.model.playerItemsFromInventory);
			if(this.model.selectedItem == -1) {
				this.hoverTooltipDelegate.setDisplayObject(this.view.completeButton);
			} else {
				this.hoverTooltipDelegate.removeDisplayObject();
			}
		}
		
		override public function destroy() : void {
			this.view.completeButton.removeEventListener(MouseEvent.CLICK,this.onCompleteButtonClickHandler);
			this.showInfoSignal.remove(this.showQuestInfo);
			this.selectedItemSlotsSignal.remove(this.itemSelectedHandler);
		}
		
		private function showQuestInfo(param1:String) : void {
			this.model.selectedItem = -1;
			this.view.clear();
			this.model.currentQuest = this.model.getQuestById(param1);
			this.view.show(this.model.currentQuest,this.model.playerItemsFromInventory);
			if(!this.view.completeButton.completed && this.model.currentQuest.itemOfChoice) {
				this.view.completeButton.disabled = true;
				this.hoverTooltipDelegate.setDisplayObject(this.view.completeButton);
			}
		}
		
		private function tileToSlot(param1:InventoryTile) : SlotObjectData {
			var loc2:SlotObjectData = new SlotObjectData();
			loc2.objectId_ = param1.ownerGrid.owner.objectId_;
			loc2.objectType_ = param1.getItemId();
			loc2.slotId_ = param1.tileId;
			return loc2;
		}
		
		private function onCompleteButtonClickHandler(param1:MouseEvent) : void {
			var loc2:Vector.<SlotObjectData> = null;
			var loc3:BackpackTabContent = null;
			var loc4:InventoryTabContent = null;
			var loc5:Vector.<int> = null;
			var loc6:Vector.<InventoryTile> = null;
			var loc7:int = 0;
			var loc8:InventoryTile = null;
			if(!this.view.completeButton.disabled && !this.view.completeButton.completed) {
				loc2 = new Vector.<SlotObjectData>();
				loc3 = this.hud.gameSprite.hudView.tabStrip.getTabView(BackpackTabContent);
				loc4 = this.hud.gameSprite.hudView.tabStrip.getTabView(InventoryTabContent);
				loc5 = this.model.currentQuest.requirements.concat();
				loc6 = new Vector.<InventoryTile>();
				if(loc3) {
					loc6 = loc6.concat(loc3.backpack.tiles);
				}
				if(loc4) {
					loc6 = loc6.concat(loc4.storage.tiles);
				}
				for each(loc7 in loc5) {
					for each(loc8 in loc6) {
						if(loc8.getItemId() == loc7) {
							loc6.splice(loc6.indexOf(loc8),1);
							loc2.push(this.tileToSlot(loc8));
							break;
						}
					}
				}
				this.lockScreen.dispatch();
				this.hud.gameSprite.gsc_.questRedeem(this.model.currentQuest.id,loc2,this.model.selectedItem);
				if(!this.model.currentQuest.repeatable) {
					this.model.currentQuest.completed = true;
				}
				this.view.completeButton.completed = true;
				this.view.completeButton.disabled = true;
			}
		}
	}
}
