package com.company.color {
	public class RGB {


		public var r_:Number;

		public var g_:Number;

		public var b_:Number;

		public function RGB(param1:Number, param2:Number, param3:Number) {
			super();
			this.r_ = Math.max(0, Math.min(1, param1));
			this.g_ = Math.max(0, Math.min(1, param2));
			this.b_ = Math.max(0, Math.min(1, param3));
		}

		public static function fromColor(param1:uint):RGB {
			return new RGB((param1 >> 16 & 255) / 255, (param1 >> 8 & 255) / 255, (param1 & 255) / 255);
		}

		public function toHSV():HSV {
			var loc6:Number = NaN;
			var loc1:Number = Math.min(this.r_, this.g_, this.b_);
			var loc2:Number = Math.max(this.r_, this.g_, this.b_);
			var loc3:Number = loc2;
			var loc4:Number = loc2 - loc1;
			if (loc2 == 0) {
				return new HSV(0, 0, 0);
			}
			var loc5:Number = loc4 / loc2;
			if (this.r_ == loc2) {
				loc6 = (this.g_ - this.b_) / loc4;
			} else if (this.g_ == loc2) {
				loc6 = 2 + (this.b_ - this.r_) / loc4;
			} else {
				loc6 = 4 + (this.r_ - this.g_) / loc4;
			}
			loc6 = loc6 * 60;
			if (loc6 < 0) {
				loc6 = loc6 + 360;
			}
			return new HSV(loc6, loc5, loc3);
		}

		public function toColor():uint {
			return int(Math.min(255, Math.floor(this.r_ * 255))) << 16 | int(Math.min(255, Math.floor(this.g_ * 255))) << 8 | int(Math.min(255, Math.floor(this.b_ * 255)));
		}

		public function toString():String {
			var loc1:int = int(Math.min(255, Math.floor(this.r_ * 255)));
			var loc2:int = int(Math.min(255, Math.floor(this.g_ * 255)));
			var loc3:int = int(Math.min(255, Math.floor(this.b_ * 255)));
			return (loc1 <= 15 ? "0" + loc1.toString(16) : loc1.toString(16)) + (loc2 <= 15 ? "0" + loc2.toString(16) : loc2.toString(16)) + (loc3 <= 15 ? "0" + loc3.toString(16) : loc3.toString(16));
		}
	}
}
