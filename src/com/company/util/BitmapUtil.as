package com.company.util {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class BitmapUtil {


		public function BitmapUtil(param1:StaticEnforcer) {
			super();
		}

		public static function mirror(param1:BitmapData, param2:int = 0):BitmapData {
			var loc5:int = 0;
			if (param2 == 0) {
				param2 = param1.width;
			}
			var loc3:BitmapData = new BitmapData(param1.width, param1.height, true, 0);
			var loc4:int = 0;
			while (loc4 < param2) {
				loc5 = 0;
				while (loc5 < param1.height) {
					loc3.setPixel32(param2 - loc4 - 1, loc5, param1.getPixel32(loc4, loc5));
					loc5++;
				}
				loc4++;
			}
			return loc3;
		}

		public static function rotateBitmapData(param1:BitmapData, param2:int):BitmapData {
			var loc3:Matrix = new Matrix();
			loc3.translate(-param1.width / 2, -param1.height / 2);
			loc3.rotate(param2 * Math.PI / 2);
			loc3.translate(param1.height / 2, param1.width / 2);
			var loc4:BitmapData = new BitmapData(param1.height, param1.width, true, 0);
			loc4.draw(param1, loc3);
			return loc4;
		}

		public static function cropToBitmapData(param1:BitmapData, param2:int, param3:int, param4:int, param5:int):BitmapData {
			var loc6:BitmapData = new BitmapData(param4, param5);
			loc6.copyPixels(param1, new Rectangle(param2, param3, param4, param5), new Point(0, 0));
			return loc6;
		}

		public static function amountTransparent(param1:BitmapData):Number {
			var loc4:int = 0;
			var loc5:* = 0;
			var loc2:int = 0;
			var loc3:int = 0;
			while (loc3 < param1.width) {
				loc4 = 0;
				while (loc4 < param1.height) {
					loc5 = param1.getPixel32(loc3, loc4) & 4278190080;
					if (loc5 == 0) {
						loc2++;
					}
					loc4++;
				}
				loc3++;
			}
			return loc2 / (param1.width * param1.height);
		}

		public static function mostCommonColor(param1:BitmapData):uint {
			var loc3:uint = 0;
			var loc7:* = null;
			var loc8:int = 0;
			var loc9:int = 0;
			var loc2:Dictionary = new Dictionary();
			var loc4:int = 0;
			while (loc4 < param1.width) {
				loc8 = 0;
				while (loc8 < param1.width) {
					loc3 = param1.getPixel32(loc4, loc8);
					if ((loc3 & 4278190080) != 0) {
						if (!loc2.hasOwnProperty(loc3)) {
							loc2[loc3] = 1;
						} else {
							loc2[loc3]++;
						}
					}
					loc8++;
				}
				loc4++;
			}
			var loc5:uint = 0;
			var loc6:uint = 0;
			for (loc7 in loc2) {
				loc3 = uint(loc7);
				loc9 = loc2[loc7];
				if (loc9 > loc6 || loc9 == loc6 && loc3 > loc5) {
					loc5 = loc3;
					loc6 = loc9;
				}
			}
			return loc5;
		}

		public static function lineOfSight(param1:BitmapData, param2:IntPoint, param3:IntPoint):Boolean {
			var loc11:int = 0;
			var loc19:int = 0;
			var loc20:int = 0;
			var loc21:int = 0;
			var loc4:int = param1.width;
			var loc5:int = param1.height;
			var loc6:int = param2.x();
			var loc7:int = param2.y();
			var loc8:int = param3.x();
			var loc9:int = param3.y();
			var loc10:* = (loc7 > loc9 ? loc7 - loc9 : loc9 - loc7) > (loc6 > loc8 ? loc6 - loc8 : loc8 - loc6);
			if (loc10) {
				loc11 = loc6;
				loc6 = loc7;
				loc7 = loc11;
				loc11 = loc8;
				loc8 = loc9;
				loc9 = loc11;
				loc11 = loc4;
				loc4 = loc5;
				loc5 = loc11;
			}
			if (loc6 > loc8) {
				loc11 = loc6;
				loc6 = loc8;
				loc8 = loc11;
				loc11 = loc7;
				loc7 = loc9;
				loc9 = loc11;
			}
			var loc12:int = loc8 - loc6;
			var loc13:int = loc7 > loc9 ? int(loc7 - loc9) : int(loc9 - loc7);
			var loc14:int = -(loc12 + 1) / 2;
			var loc15:int = loc7 > loc9 ? -1 : 1;
			var loc16:int = loc8 > loc4 - 1 ? int(loc4 - 1) : int(loc8);
			var loc17:int = loc7;
			var loc18:int = loc6;
			if (loc18 < 0) {
				loc14 = loc14 + loc13 * -loc18;
				if (loc14 >= 0) {
					loc19 = loc14 / loc12 + 1;
					loc17 = loc17 + loc15 * loc19;
					loc14 = loc14 - loc19 * loc12;
				}
				loc18 = 0;
			}
			if (loc15 > 0 && loc17 < 0 || loc15 < 0 && loc17 >= loc5) {
				loc20 = loc15 > 0 ? int(-loc17 - 1) : int(loc17 - loc5);
				loc14 = loc14 - loc12 * loc20;
				loc21 = -loc14 / loc13;
				loc18 = loc18 + loc21;
				loc14 = loc14 + loc21 * loc13;
				loc17 = loc17 + loc20 * loc15;
			}
			while (loc18 <= loc16) {
				if (loc15 > 0 && loc17 >= loc5 || loc15 < 0 && loc17 < 0) {
					break;
				}
				if (loc10) {
					if (loc17 >= 0 && loc17 < loc5 && param1.getPixel(loc17, loc18) == 0) {
						return false;
					}
				} else if (loc17 >= 0 && loc17 < loc5 && param1.getPixel(loc18, loc17) == 0) {
					return false;
				}
				loc14 = loc14 + loc13;
				if (loc14 >= 0) {
					loc17 = loc17 + loc15;
					loc14 = loc14 - loc12;
				}
				loc18++;
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
