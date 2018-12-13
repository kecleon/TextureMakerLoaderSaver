package kabam.rotmg.messaging.impl {
	import flash.utils.IDataOutput;

	import kabam.rotmg.messaging.impl.data.SlotObjectData;
	import kabam.rotmg.messaging.impl.outgoing.OutgoingMessage;

	public class PetUpgradeRequest extends OutgoingMessage {

		public static const GOLD_PAYMENT_TYPE:int = 0;

		public static const FAME_PAYMENT_TYPE:int = 1;


		public var petTransType:int;

		public var PIDOne:int;

		public var PIDTwo:int;

		public var objectId:int;

		public var slotsObject:Vector.<SlotObjectData>;

		public var paymentTransType:int;

		public function PetUpgradeRequest(param1:uint, param2:Function) {
			this.slotsObject = new Vector.<SlotObjectData>();
			super(param1, param2);
		}

		override public function writeToOutput(param1:IDataOutput):void {
			var loc2:SlotObjectData = null;
			param1.writeByte(this.petTransType);
			param1.writeInt(this.PIDOne);
			param1.writeInt(this.PIDTwo);
			param1.writeInt(this.objectId);
			param1.writeByte(this.paymentTransType);
			param1.writeShort(this.slotsObject.length);
			for each(loc2 in this.slotsObject) {
				loc2.writeToOutput(param1);
			}
		}
	}
}
