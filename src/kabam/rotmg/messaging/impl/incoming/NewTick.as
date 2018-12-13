package kabam.rotmg.messaging.impl.incoming {
	import com.company.assembleegameclient.util.FreeList;

	import flash.utils.IDataInput;

	import kabam.rotmg.messaging.impl.data.ObjectStatusData;

	public class NewTick extends IncomingMessage {


		public var tickId_:int;

		public var tickTime_:int;

		public var statuses_:Vector.<ObjectStatusData>;

		public function NewTick(param1:uint, param2:Function) {
			this.statuses_ = new Vector.<ObjectStatusData>();
			super(param1, param2);
		}

		override public function parseFromInput(param1:IDataInput):void {
			var loc3:int = 0;
			this.tickId_ = param1.readInt();
			this.tickTime_ = param1.readInt();
			var loc2:int = param1.readShort();
			loc3 = loc2;
			while (loc3 < this.statuses_.length) {
				FreeList.deleteObject(this.statuses_[loc3]);
				loc3++;
			}
			this.statuses_.length = Math.min(loc2, this.statuses_.length);
			while (this.statuses_.length < loc2) {
				this.statuses_.push(FreeList.newObject(ObjectStatusData) as ObjectStatusData);
			}
			loc3 = 0;
			while (loc3 < loc2) {
				this.statuses_[loc3].parseFromInput(param1);
				loc3++;
			}
		}

		override public function toString():String {
			return formatToString("NEW_TICK", "tickId_", "tickTime_", "statuses_");
		}
	}
}
