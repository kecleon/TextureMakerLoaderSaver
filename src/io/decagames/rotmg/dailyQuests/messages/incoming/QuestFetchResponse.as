 
package io.decagames.rotmg.dailyQuests.messages.incoming {
	import flash.utils.IDataInput;
	import io.decagames.rotmg.dailyQuests.messages.data.QuestData;
	import kabam.rotmg.messaging.impl.incoming.IncomingMessage;
	
	public class QuestFetchResponse extends IncomingMessage {
		 
		
		public var quests:Vector.<QuestData>;
		
		public function QuestFetchResponse(param1:uint, param2:Function) {
			this.quests = new Vector.<QuestData>();
			super(param1,param2);
		}
		
		override public function parseFromInput(param1:IDataInput) : void {
			var loc2:int = param1.readShort();
			var loc3:int = 0;
			while(loc3 < loc2) {
				this.quests[loc3] = new QuestData();
				this.quests[loc3].parseFromInput(param1);
				loc3++;
			}
		}
		
		override public function toString() : String {
			return formatToString("QUESTFETCHRESPONSE");
		}
	}
}
