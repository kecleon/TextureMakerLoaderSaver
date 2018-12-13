 
package io.decagames.rotmg.dailyQuests.messages.data {
	import flash.utils.IDataInput;
	
	public class QuestData {
		 
		
		public var id:String;
		
		public var name:String;
		
		public var description:String;
		
		public var requirements:Vector.<int>;
		
		public var rewards:Vector.<int>;
		
		public var completed:Boolean;
		
		public var itemOfChoice:Boolean;
		
		public var repeatable:Boolean;
		
		public var category:int;
		
		public function QuestData() {
			this.requirements = new Vector.<int>();
			this.rewards = new Vector.<int>();
			super();
		}
		
		public function parseFromInput(param1:IDataInput) : void {
			this.id = param1.readUTF();
			this.name = param1.readUTF();
			this.description = param1.readUTF();
			this.category = param1.readInt();
			var loc2:int = param1.readShort();
			var loc3:int = 0;
			while(loc3 < loc2) {
				this.requirements.push(param1.readInt());
				loc3++;
			}
			loc2 = param1.readShort();
			loc3 = 0;
			while(loc3 < loc2) {
				this.rewards.push(param1.readInt());
				loc3++;
			}
			this.completed = param1.readBoolean();
			this.itemOfChoice = param1.readBoolean();
			this.repeatable = param1.readBoolean();
		}
	}
}
