 
package com.company.assembleegameclient.mapeditor {
	public class METile {
		 
		
		public var types_:Vector.<int>;
		
		public var objName_:String = null;
		
		public var layerNumber:int;
		
		public function METile() {
			this.types_ = new <int>[-1,-1,-1];
			super();
			this.layerNumber = 0;
		}
		
		public function clone() : METile {
			var loc1:METile = new METile();
			loc1.types_ = this.types_.concat();
			loc1.objName_ = this.objName_;
			return loc1;
		}
		
		public function isEmpty() : Boolean {
			var loc1:int = 0;
			while(loc1 < Layer.NUM_LAYERS) {
				if(this.types_[loc1] != -1) {
					return false;
				}
				loc1++;
			}
			return true;
		}
	}
}
