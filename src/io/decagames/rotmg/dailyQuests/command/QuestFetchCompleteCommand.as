 
package io.decagames.rotmg.dailyQuests.command {
	import io.decagames.rotmg.dailyQuests.messages.data.QuestData;
	import io.decagames.rotmg.dailyQuests.messages.incoming.QuestFetchResponse;
	import io.decagames.rotmg.dailyQuests.model.DailyQuest;
	import io.decagames.rotmg.dailyQuests.model.DailyQuestsModel;
	import robotlegs.bender.bundles.mvcs.Command;
	
	public class QuestFetchCompleteCommand extends Command {
		 
		
		[Inject]
		public var response:QuestFetchResponse;
		
		[Inject]
		public var model:DailyQuestsModel;
		
		public function QuestFetchCompleteCommand() {
			super();
		}
		
		override public function execute() : void {
			var loc1:QuestData = null;
			var loc2:DailyQuest = null;
			this.model.clear();
			for each(loc1 in this.response.quests) {
				loc2 = new DailyQuest();
				loc2.id = loc1.id;
				loc2.name = loc1.name;
				loc2.description = loc1.description;
				loc2.requirements = loc1.requirements;
				loc2.rewards = loc1.rewards;
				loc2.completed = loc1.completed;
				loc2.category = loc1.category;
				loc2.itemOfChoice = loc1.itemOfChoice;
				loc2.repeatable = loc1.repeatable;
				this.model.addQuest(loc2);
			}
		}
	}
}
