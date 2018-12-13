 
package com.company.color {
	import com.company.util.MoreColorUtil;
	
	public class HSV {
		 
		
		public var h_:Number;
		
		public var s_:Number;
		
		public var v_:Number;
		
		public function HSV(param1:Number = 0, param2:Number = 0, param3:Number = 0) {
			super();
			this.h_ = Math.max(0,Math.min(359,int(param1)));
			this.s_ = Math.max(0,Math.min(1,param2));
			this.v_ = Math.max(0,Math.min(1,param3));
		}
		
		public static function random() : HSV {
			var loc1:RGB = RGB.fromColor(MoreColorUtil.randomColor());
			return loc1.toHSV();
		}
		
		public function clone() : HSV {
			return new HSV(this.h_,this.s_,this.v_);
		}
		
		public function equals(param1:HSV) : Boolean {
			return param1 != null && this.h_ == param1.h_ && this.s_ == param1.s_ && this.v_ == param1.v_;
		}
		
		public function toRGB() : RGB {
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc1:int = int(this.h_ / 60) % 6;
			var loc2:Number = this.h_ / 60 - Math.floor(this.h_ / 60);
			var loc3:Number = this.v_ * (1 - this.s_);
			var loc4:Number = this.v_ * (1 - loc2 * this.s_);
			var loc5:Number = this.v_ * (1 - (1 - loc2) * this.s_);
			switch(loc1) {
				case 0:
					loc6 = this.v_;
					loc7 = loc5;
					loc8 = loc3;
					break;
				case 1:
					loc6 = loc4;
					loc7 = this.v_;
					loc8 = loc3;
					break;
				case 2:
					loc6 = loc3;
					loc7 = this.v_;
					loc8 = loc5;
					break;
				case 3:
					loc6 = loc3;
					loc7 = loc4;
					loc8 = this.v_;
					break;
				case 4:
					loc6 = loc5;
					loc7 = loc3;
					loc8 = this.v_;
					break;
				case 5:
					loc6 = this.v_;
					loc7 = loc3;
					loc8 = loc4;
			}
			return new RGB(loc6,loc7,loc8);
		}
		
		public function toString() : String {
			return "HSV(" + this.h_ + ", " + this.s_ + ", " + this.v_ + ")";
		}
	}
}
