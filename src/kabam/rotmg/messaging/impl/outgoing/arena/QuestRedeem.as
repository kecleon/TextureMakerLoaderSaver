 
package kabam.rotmg.messaging.impl.outgoing.arena {
	import flash.utils.IDataOutput;
	import kabam.rotmg.messaging.impl.data.SlotObjectData;
	import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;
	
	public class QuestRedeem extends OutgoingMessage {
		 
		
		public var questID:String;
		
		public var slots:Vector.<SlotObjectData>;
		
		public var item:int;
		
		public function QuestRedeem(param1:uint, param2:Function) {
			super(param1,param2);
		}
		
		override public function writeToOutput(param1:IDataOutput) : void {
			var loc2:SlotObjectData = null;
			param1.writeUTF(this.questID);
			param1.writeInt(this.item);
			param1.writeShort(this.slots.length);
			for each(loc2 in this.slots) {
				loc2.writeToOutput(param1);
			}
		}
	}
}
