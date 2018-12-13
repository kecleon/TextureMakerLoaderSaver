package com.company.util {
	public class Trig {

		public static const toDegrees:Number = 180 / Math.PI;

		public static const toRadians:Number = Math.PI / 180;


		public function Trig(param1:StaticEnforcer) {
			super();
		}

		public static function slerp(param1:Number, param2:Number, param3:Number):Number {
			var loc4:Number = Number.MAX_VALUE;
			if (param1 > param2) {
				if (param1 - param2 > Math.PI) {
					loc4 = param1 * (1 - param3) + (param2 + 2 * Math.PI) * param3;
				} else {
					loc4 = param1 * (1 - param3) + param2 * param3;
				}
			} else if (param2 - param1 > Math.PI) {
				loc4 = (param1 + 2 * Math.PI) * (1 - param3) + param2 * param3;
			} else {
				loc4 = param1 * (1 - param3) + param2 * param3;
			}
			if (loc4 < -Math.PI || loc4 > Math.PI) {
				loc4 = boundToPI(loc4);
			}
			return loc4;
		}

		public static function angleDiff(param1:Number, param2:Number):Number {
			if (param1 > param2) {
				if (param1 - param2 > Math.PI) {
					return param2 + 2 * Math.PI - param1;
				}
				return param1 - param2;
			}
			if (param2 - param1 > Math.PI) {
				return param1 + 2 * Math.PI - param2;
			}
			return param2 - param1;
		}

		public static function sin(param1:Number):Number {
			var loc2:Number = NaN;
			if (param1 < -Math.PI || param1 > Math.PI) {
				param1 = boundToPI(param1);
			}
			if (param1 < 0) {
				loc2 = 1.27323954 * param1 + 0.405284735 * param1 * param1;
				if (loc2 < 0) {
					loc2 = 0.225 * (loc2 * -loc2 - loc2) + loc2;
				} else {
					loc2 = 0.225 * (loc2 * loc2 - loc2) + loc2;
				}
			} else {
				loc2 = 1.27323954 * param1 - 0.405284735 * param1 * param1;
				if (loc2 < 0) {
					loc2 = 0.225 * (loc2 * -loc2 - loc2) + loc2;
				} else {
					loc2 = 0.225 * (loc2 * loc2 - loc2) + loc2;
				}
			}
			return loc2;
		}

		public static function cos(param1:Number):Number {
			return sin(param1 + Math.PI / 2);
		}

		public static function atan2(param1:Number, param2:Number):Number {
			var loc3:Number = NaN;
			if (param2 == 0) {
				if (param1 < 0) {
					return -Math.PI / 2;
				}
				if (param1 > 0) {
					return Math.PI / 2;
				}
				return undefined;
			}
			if (param1 == 0) {
				if (param2 < 0) {
					return Math.PI;
				}
				return 0;
			}
			if ((param2 > 0 ? param2 : -param2) > (param1 > 0 ? param1 : -param1)) {
				loc3 = (param2 < 0 ? -Math.PI : 0) + atan2Helper(param1, param2);
			} else {
				loc3 = (param1 > 0 ? Math.PI / 2 : -Math.PI / 2) - atan2Helper(param2, param1);
			}
			if (loc3 < -Math.PI || loc3 > Math.PI) {
				loc3 = boundToPI(loc3);
			}
			return loc3;
		}

		public static function atan2Helper(param1:Number, param2:Number):Number {
			var loc3:Number = param1 / param2;
			var loc4:Number = loc3;
			var loc5:Number = loc3;
			var loc6:Number = 1;
			var loc7:int = 1;
			do {
				loc6 = loc6 + 2;
				loc7 = loc7 > 0 ? -1 : 1;
				loc5 = loc5 * loc3 * loc3;
				loc4 = loc4 + loc7 * loc5 / loc6;
			}
			while ((loc5 > 0.01 || loc5 < -0.01) && loc6 <= 11);

			return loc4;
		}

		public static function boundToPI(param1:Number):Number {
			var loc2:int = 0;
			if (param1 < -Math.PI) {
				loc2 = (int(param1 / -Math.PI) + 1) / 2;
				param1 = param1 + loc2 * 2 * Math.PI;
			} else if (param1 > Math.PI) {
				loc2 = (int(param1 / Math.PI) + 1) / 2;
				param1 = param1 - loc2 * 2 * Math.PI;
			}
			return param1;
		}

		public static function boundTo180(param1:Number):Number {
			var loc2:int = 0;
			if (param1 < -180) {
				loc2 = (int(param1 / -180) + 1) / 2;
				param1 = param1 + loc2 * 360;
			} else if (param1 > 180) {
				loc2 = (int(param1 / 180) + 1) / 2;
				param1 = param1 - loc2 * 360;
			}
			return param1;
		}

		public static function unitTest():Boolean {
			trace("STARTING UNITTEST: Trig");
			var loc1:Boolean = testFunc1(Math.sin, sin) && testFunc1(Math.cos, cos) && testFunc2(Math.atan2, atan2);
			if (!loc1) {
				trace("Trig Unit Test FAILED!");
			}
			trace("FINISHED UNITTEST: Trig");
			return loc1;
		}

		public static function testFunc1(param1:Function, param2:Function):Boolean {
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			var loc3:Random = new Random();
			var loc4:int = 0;
			while (loc4 < 1000) {
				loc5 = loc3.nextInt() % 2000 - 1000 + loc3.nextDouble();
				loc6 = Math.abs(param1(loc5) - param2(loc5));
				if (loc6 > 0.1) {
					return false;
				}
				loc4++;
			}
			return true;
		}

		public static function testFunc2(param1:Function, param2:Function):Boolean {
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			var loc3:Random = new Random();
			var loc4:int = 0;
			while (loc4 < 1000) {
				loc5 = loc3.nextInt() % 2000 - 1000 + loc3.nextDouble();
				loc6 = loc3.nextInt() % 2000 - 1000 + loc3.nextDouble();
				loc7 = Math.abs(param1(loc5, loc6) - param2(loc5, loc6));
				if (loc7 > 0.1) {
					return false;
				}
				loc4++;
			}
			return true;
		}
	}
}

class StaticEnforcer {


	function StaticEnforcer() {
		super();
	}
}
