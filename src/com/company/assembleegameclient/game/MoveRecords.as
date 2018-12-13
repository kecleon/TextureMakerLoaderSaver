 
package com.company.assembleegameclient.game {
	import kabam.rotmg.messaging.impl.data.MoveRecord;
	
	public class MoveRecords {
		 
		
		public var lastClearTime_:int = -1;
		
		public var records_:Vector.<MoveRecord>;
		
		public function MoveRecords() {
			this.records_ = new Vector.<MoveRecord>();
			super();
		}
		
		public function addRecord(param1:int, param2:Number, param3:Number) : void {
			if(this.lastClearTime_ < 0) {
				return;
			}
			var loc4:int = this.getId(param1);
			if(loc4 < 1 || loc4 > 10) {
				return;
			}
			if(this.records_.length == 0) {
				this.records_.push(new MoveRecord(param1,param2,param3));
				return;
			}
			var loc5:MoveRecord = this.records_[this.records_.length - 1];
			var loc6:int = this.getId(loc5.time_);
			if(loc4 != loc6) {
				this.records_.push(new MoveRecord(param1,param2,param3));
				return;
			}
			var loc7:int = this.getScore(loc4,param1);
			var loc8:int = this.getScore(loc4,loc5.time_);
			if(loc7 < loc8) {
				loc5.time_ = param1;
				loc5.x_ = param2;
				loc5.y_ = param3;
				return;
			}
		}
		
		private function getId(param1:int) : int {
			return (param1 - this.lastClearTime_ + 50) / 100;
		}
		
		private function getScore(param1:int, param2:int) : int {
			return Math.abs(param2 - this.lastClearTime_ - param1 * 100);
		}
		
		public function clear(param1:int) : void {
			this.records_.length = 0;
			this.lastClearTime_ = param1;
		}
	}
}
