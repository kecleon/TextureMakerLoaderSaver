package com.company.util {
	import flash.geom.Point;

	public class LineSegmentUtil {


		public function LineSegmentUtil() {
			super();
		}

		public static function intersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number):Point {
			var loc9:Number = (param8 - param6) * (param3 - param1) - (param7 - param5) * (param4 - param2);
			if (loc9 == 0) {
				return null;
			}
			var loc10:Number = ((param7 - param5) * (param2 - param6) - (param8 - param6) * (param1 - param5)) / loc9;
			var loc11:Number = ((param3 - param1) * (param2 - param6) - (param4 - param2) * (param1 - param5)) / loc9;
			if (loc10 > 1 || loc10 < 0 || loc11 > 1 || loc11 < 0) {
				return null;
			}
			var loc12:Point = new Point(param1 + loc10 * (param3 - param1), param2 + loc10 * (param4 - param2));
			return loc12;
		}

		public static function pointDistance(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number):Number {
			var loc10:Number = NaN;
			var loc11:Number = NaN;
			var loc12:Number = NaN;
			var loc7:Number = param5 - param3;
			var loc8:Number = param6 - param4;
			var loc9:Number = loc7 * loc7 + loc8 * loc8;
			if (loc9 < 0.001) {
				loc10 = param3;
				loc11 = param4;
			} else {
				loc12 = ((param1 - param3) * loc7 + (param2 - param4) * loc8) / loc9;
				if (loc12 < 0) {
					loc10 = param3;
					loc11 = param4;
				} else if (loc12 > 1) {
					loc10 = param5;
					loc11 = param6;
				} else {
					loc10 = param3 + loc12 * loc7;
					loc11 = param4 + loc12 * loc8;
				}
			}
			loc7 = param1 - loc10;
			loc8 = param2 - loc11;
			return Math.sqrt(loc7 * loc7 + loc8 * loc8);
		}
	}
}
