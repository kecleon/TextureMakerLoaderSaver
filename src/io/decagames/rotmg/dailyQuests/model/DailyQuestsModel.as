package io.decagames.rotmg.dailyQuests.model {
	import io.decagames.rotmg.dailyQuests.view.info.DailyQuestInfo;
	import io.decagames.rotmg.dailyQuests.view.slot.DailyQuestItemSlot;

	import kabam.rotmg.constants.GeneralConstants;
	import kabam.rotmg.ui.model.HUDModel;

	public class DailyQuestsModel {


		private var _questsList:Vector.<DailyQuest>;

		private var slots:Vector.<DailyQuestItemSlot>;

		public var currentQuest:DailyQuest;

		public var isPopupOpened:Boolean;

		public var categoriesWeight:Array;

		public var selectedItem:int = -1;

		[Inject]
		public var hud:HUDModel;

		public function DailyQuestsModel() {
			this._questsList = new Vector.<DailyQuest>();
			this.slots = new Vector.<DailyQuestItemSlot>();
			this.categoriesWeight = [1, 0, 2, 3, 4];
			super();
		}

		public function registerSelectableSlot(param1:DailyQuestItemSlot):void {
			this.slots.push(param1);
		}

		public function unregisterSelectableSlot(param1:DailyQuestItemSlot):void {
			var loc2:int = this.slots.indexOf(param1);
			if (loc2 != -1) {
				this.slots.splice(loc2, 1);
			}
		}

		public function unselectAllSlots(param1:int):void {
			var loc2:DailyQuestItemSlot = null;
			for each(loc2 in this.slots) {
				if (loc2.itemID != param1) {
					loc2.selected = false;
				}
			}
		}

		public function clear():void {
			this._questsList = new Vector.<DailyQuest>();
		}

		public function addQuest(param1:DailyQuest):void {
			this._questsList.push(param1);
		}

		public function markAsCompleted(param1:String):void {
			var loc2:DailyQuest = null;
			for each(loc2 in this._questsList) {
				if (loc2.id == param1 && !loc2.repeatable) {
					loc2.completed = true;
				}
			}
		}

		public function get playerItemsFromInventory():Vector.<int> {
			return !!this.hud.gameSprite.map.player_ ? this.hud.gameSprite.map.player_.equipment_.slice(GeneralConstants.NUM_EQUIPMENT_SLOTS - 1, GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS * 2) : new Vector.<int>();
		}

		public function hasQuests():Boolean {
			return this._questsList.length > 0;
		}

		public function get numberOfActiveQuests():int {
			return this._questsList.length;
		}

		public function get numberOfCompletedQuests():int {
			var loc2:DailyQuest = null;
			var loc1:int = 0;
			for each(loc2 in this._questsList) {
				if (loc2.completed) {
					loc1++;
				}
			}
			return loc1;
		}

		public function get questsList():Vector.<DailyQuest> {
			var loc1:Vector.<DailyQuest> = this._questsList.concat();
			return loc1.sort(this.questsCompleteSort);
		}

		private function questsNameSort(param1:DailyQuest, param2:DailyQuest):int {
			if (param1.name > param2.name) {
				return 1;
			}
			return -1;
		}

		private function sortByCategory(param1:DailyQuest, param2:DailyQuest):int {
			if (this.categoriesWeight[param1.category] < this.categoriesWeight[param2.category]) {
				return -1;
			}
			if (this.categoriesWeight[param1.category] > this.categoriesWeight[param2.category]) {
				return 1;
			}
			return this.questsNameSort(param1, param2);
		}

		private function questsReadySort(param1:DailyQuest, param2:DailyQuest):int {
			var loc3:Boolean = DailyQuestInfo.hasAllItems(param1.requirements, this.playerItemsFromInventory);
			var loc4:Boolean = DailyQuestInfo.hasAllItems(param2.requirements, this.playerItemsFromInventory);
			if (loc3 && !loc4) {
				return -1;
			}
			if (loc3 && loc4) {
				return this.questsNameSort(param1, param2);
			}
			return 1;
		}

		private function questsCompleteSort(param1:DailyQuest, param2:DailyQuest):int {
			if (param1.completed && !param2.completed) {
				return 1;
			}
			if (param1.completed && param2.completed) {
				return this.sortByCategory(param1, param2);
			}
			if (!param1.completed && !param2.completed) {
				return this.sortByCategory(param1, param2);
			}
			return -1;
		}

		public function getQuestById(param1:String):DailyQuest {
			var loc2:DailyQuest = null;
			for each(loc2 in this._questsList) {
				if (loc2.id == param1) {
					return loc2;
				}
			}
			return null;
		}

		public function get first():DailyQuest {
			if (this._questsList.length > 0) {
				return this.questsList[0];
			}
			return null;
		}
	}
}
