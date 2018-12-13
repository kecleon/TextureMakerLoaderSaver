 
package com.company.assembleegameclient.map {
	import com.company.assembleegameclient.objects.GameObject;
	import flash.utils.getTimer;
	
	public class Quest {
		 
		
		public var map_:Map;
		
		public var objectId_:int = -1;
		
		private var questAvailableAt_:int = 0;
		
		private var questOldAt_:int = 0;
		
		public function Quest(param1:Map) {
			super();
			this.map_ = param1;
		}
		
		public function setObject(param1:int) : void {
			if(this.objectId_ == -1 && param1 != -1) {
				this.questAvailableAt_ = getTimer() + 200;
				this.questOldAt_ = this.questAvailableAt_;
			}
			this.objectId_ = param1;
		}
		
		public function completed() : void {
			this.questAvailableAt_ = getTimer() + 200;
			this.questOldAt_ = this.questAvailableAt_;
		}
		
		public function getObject(param1:int) : GameObject {
			if(param1 < this.questAvailableAt_) {
				return null;
			}
			return this.map_.goDict_[this.objectId_];
		}
		
		public function isNew(param1:int) : Boolean {
			return param1 < this.questOldAt_;
		}
	}
}
