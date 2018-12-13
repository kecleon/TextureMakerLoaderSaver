package kabam.rotmg.messaging.impl.data {
	import com.company.assembleegameclient.util.FreeList;

	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public class ObjectStatusData {


		public var objectId_:int;

		public var pos_:WorldPosData;

		public var stats_:Vector.<StatData>;

		public function ObjectStatusData() {
			this.pos_ = new WorldPosData();
			this.stats_ = new Vector.<StatData>();
			super();
		}

		public function parseFromInput(param1:IDataInput):void {
			var loc3:int = 0;
			this.objectId_ = param1.readInt();
			this.pos_.parseFromInput(param1);
			var loc2:int = param1.readShort();
			loc3 = loc2;
			while (loc3 < this.stats_.length) {
				FreeList.deleteObject(this.stats_[loc3]);
				loc3++;
			}
			this.stats_.length = Math.min(loc2, this.stats_.length);
			while (this.stats_.length < loc2) {
				this.stats_.push(FreeList.newObject(StatData) as StatData);
			}
			loc3 = 0;
			while (loc3 < loc2) {
				this.stats_[loc3].parseFromInput(param1);
				loc3++;
			}
		}

		public function writeToOutput(param1:IDataOutput):void {
			param1.writeInt(this.objectId_);
			this.pos_.writeToOutput(param1);
			param1.writeShort(this.stats_.length);
			var loc2:int = 0;
			while (loc2 < this.stats_.length) {
				this.stats_[loc2].writeToOutput(param1);
				loc2++;
			}
		}

		public function toString():String {
			return "objectId_: " + this.objectId_ + " pos_: " + this.pos_ + " stats_: " + this.stats_;
		}
	}
}
