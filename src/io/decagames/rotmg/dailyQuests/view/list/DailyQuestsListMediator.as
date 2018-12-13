 
package io.decagames.rotmg.dailyQuests.view.list {
	import io.decagames.rotmg.dailyQuests.model.DailyQuest;
	import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
	import io.decagames.rotmg.dailyQuests.view.info.DailyQuestInfo;
	import kabam.rotmg.constants.GeneralConstants;
	import kabam.rotmg.ui.model.HUDModel;
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	public class DailyQuestsListMediator extends Mediator {
		 
		
		[Inject]
		public var view:DailyQuestsList;
		
		[Inject]
		public var model:DailyQuestsModel;
		
		[Inject]
		public var hud:HUDModel;
		
		private var hasEvent:Boolean;
		
		public function DailyQuestsListMediator() {
			super();
		}
		
		override public function initialize() : void {
			var loc4:DailyQuest = null;
			var loc5:DailyQuestListElement = null;
			var loc1:Vector.<DailyQuest> = this.model.questsList;
			var loc2:Boolean = true;
			this.view.tabs.buttonsRenderedSignal.addOnce(this.onAddedHandler);
			var loc3:Vector.<int> = !!this.hud.gameSprite.map.player_?this.hud.gameSprite.map.player_.equipment_.slice(GeneralConstants.NUM_EQUIPMENT_SLOTS - 1,GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS * 2):new Vector.<int>();
			for each(loc4 in loc1) {
				loc5 = new DailyQuestListElement(loc4.id,loc4.name,loc4.completed,DailyQuestInfo.hasAllItems(loc4.requirements,loc3),loc4.category);
				if(loc2) {
					loc5.isSelected = true;
				}
				loc2 = false;
				if(loc4.category == 3) {
					this.hasEvent = true;
					this.view.addEventToList(loc5);
				} else {
					this.view.addQuestToList(loc5);
				}
			}
		}
		
		private function onAddedHandler() : void {
			if(this.hasEvent) {
				this.view.addIndicator(this.hasEvent);
			}
		}
		
		override public function destroy() : void {
			this.view.tabs.buttonsRenderedSignal.remove(this.onAddedHandler);
		}
	}
}
