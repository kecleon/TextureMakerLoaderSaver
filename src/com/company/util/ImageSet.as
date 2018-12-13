package com.company.util {
	import flash.display.BitmapData;

	public class ImageSet {


		public var images_:Vector.<BitmapData>;

		public function ImageSet() {
			super();
			this.images_ = new Vector.<BitmapData>();
		}

		public function add(param1:BitmapData):void {
			this.images_.push(param1);
		}

		public function random():BitmapData {
			return this.images_[int(Math.random() * this.images_.length)];
		}

		public function addFromBitmapData(param1:BitmapData, param2:int, param3:int):void {
			var loc7:int = 0;
			var loc4:int = param1.width / param2;
			var loc5:int = param1.height / param3;
			var loc6:int = 0;
			while (loc6 < loc5) {
				loc7 = 0;
				while (loc7 < loc4) {
					this.images_.push(BitmapUtil.cropToBitmapData(param1, loc7 * param2, loc6 * param3, param2, param3));
					loc7++;
				}
				loc6++;
			}
		}
	}
}
