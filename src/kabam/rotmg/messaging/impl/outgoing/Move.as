package kabam.rotmg.messaging.impl.outgoing {
	import flash.utils.IDataOutput;

	import kabam.rotmg.messaging.impl.data.MoveRecord;
	import kabam.rotmg.messaging.impl.data.WorldPosData;

	public class Move extends OutgoingMessage {


		public var tickId_:int;

		public var time_:int;

		public var newPosition_:WorldPosData;

		public var records_:Vector.<MoveRecord>;

		public function Move(param1:uint, param2:Function) {
			this.newPosition_ = new WorldPosData();
			this.records_ = new Vector.<MoveRecord>();
			super(param1, param2);
		}

		override public function writeToOutput(param1:IDataOutput):void {
			param1.writeInt(this.tickId_);
			param1.writeInt(this.time_);
			this.newPosition_.writeToOutput(param1);
			param1.writeShort(this.records_.length);
			var loc2:int = 0;
			while (loc2 < this.records_.length) {
				this.records_[loc2].writeToOutput(param1);
				loc2++;
			}
		}

		override public function toString():String {
			return formatToString("MOVE", "tickId_", "time_", "newPosition_", "records_");
		}
	}
}
