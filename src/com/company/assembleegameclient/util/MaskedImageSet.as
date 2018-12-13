package com.company.assembleegameclient.util {
	import com.company.util.ImageSet;

	import flash.display.BitmapData;

	public class MaskedImageSet {


		public var images_:Vector.<MaskedImage>;

		public function MaskedImageSet() {
			this.images_ = new Vector.<MaskedImage>();
			super();
		}

		public function addFromBitmapData(param1:BitmapData, param2:BitmapData, param3:int, param4:int):void {
			var loc5:ImageSet = new ImageSet();
			loc5.addFromBitmapData(param1, param3, param4);
			var loc6:ImageSet = null;
			if (param2 != null) {
				loc6 = new ImageSet();
				loc6.addFromBitmapData(param2, param3, param4);
				if (loc5.images_.length > loc6.images_.length) {
				}
			}
			var loc7:int = 0;
			while (loc7 < loc5.images_.length) {
				this.images_.push(new MaskedImage(loc5.images_[loc7], loc6 == null ? null : loc7 >= loc6.images_.length ? null : loc6.images_[loc7]));
				loc7++;
			}
		}

		public function addFromMaskedImage(param1:MaskedImage, param2:int, param3:int):void {
			this.addFromBitmapData(param1.image_, param1.mask_, param2, param3);
		}
	}
}
