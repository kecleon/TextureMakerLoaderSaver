package com.company.util {
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class RectangleUtil {


		public function RectangleUtil() {
			super();
		}

		public static function pointDist(param1:Rectangle, param2:Number, param3:Number):Number {
			var loc4:Number = param2;
			var loc5:Number = param3;
			if (loc4 < param1.x) {
				loc4 = param1.x;
			} else if (loc4 > param1.right) {
				loc4 = param1.right;
			}
			if (loc5 < param1.y) {
				loc5 = param1.y;
			} else if (loc5 > param1.bottom) {
				loc5 = param1.bottom;
			}
			if (loc4 == param2 && loc5 == param3) {
				return 0;
			}
			return PointUtil.distanceXY(loc4, loc5, param2, param3);
		}

		public static function closestPoint(param1:Rectangle, param2:Number, param3:Number):Point {
			var loc4:Number = param2;
			var loc5:Number = param3;
			if (loc4 < param1.x) {
				loc4 = param1.x;
			} else if (loc4 > param1.right) {
				loc4 = param1.right;
			}
			if (loc5 < param1.y) {
				loc5 = param1.y;
			} else if (loc5 > param1.bottom) {
				loc5 = param1.bottom;
			}
			return new Point(loc4, loc5);
		}

		public static function lineSegmentIntersectsXY(param1:Rectangle, param2:Number, param3:Number, param4:Number, param5:Number):Boolean {
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			var loc10:Number = NaN;
			var loc11:Number = NaN;
			if (param1.left > param2 && param1.left > param4 || param1.right < param2 && param1.right < param4 || param1.top > param3 && param1.top > param5 || param1.bottom < param3 && param1.bottom < param5) {
				return false;
			}
			if (param1.left < param2 && param2 < param1.right && param1.top < param3 && param3 < param1.bottom || param1.left < param4 && param4 < param1.right && param1.top < param5 && param5 < param1.bottom) {
				return true;
			}
			var loc6:Number = (param5 - param3) / (param4 - param2);
			var loc7:Number = param3 - loc6 * param2;
			if (loc6 > 0) {
				loc8 = loc6 * param1.left + loc7;
				loc9 = loc6 * param1.right + loc7;
			} else {
				loc8 = loc6 * param1.right + loc7;
				loc9 = loc6 * param1.left + loc7;
			}
			if (param3 < param5) {
				loc11 = param3;
				loc10 = param5;
			} else {
				loc11 = param5;
				loc10 = param3;
			}
			var loc12:Number = loc8 > loc11 ? Number(loc8) : Number(loc11);
			var loc13:Number = loc9 < loc10 ? Number(loc9) : Number(loc10);
			return loc12 < loc13 && !(loc13 < param1.top || loc12 > param1.bottom);
		}

		public static function lineSegmentIntersectXY(param1:Rectangle, param2:Number, param3:Number, param4:Number, param5:Number, param6:Point):Boolean {
			var loc7:Number = NaN;
			var loc8:Number = NaN;
			var loc9:Number = NaN;
			var loc10:Number = NaN;
			if (param4 <= param1.x) {
				loc7 = (param5 - param3) / (param4 - param2);
				loc8 = param3 - param2 * loc7;
				loc9 = loc7 * param1.x + loc8;
				if (loc9 >= param1.y && loc9 <= param1.y + param1.height) {
					param6.x = param1.x;
					param6.y = loc9;
					return true;
				}
			} else if (param4 >= param1.x + param1.width) {
				loc7 = (param5 - param3) / (param4 - param2);
				loc8 = param3 - param2 * loc7;
				loc9 = loc7 * (param1.x + param1.width) + loc8;
				if (loc9 >= param1.y && loc9 <= param1.y + param1.height) {
					param6.x = param1.x + param1.width;
					param6.y = loc9;
					return true;
				}
			}
			if (param5 <= param1.y) {
				loc7 = (param4 - param2) / (param5 - param3);
				loc8 = param2 - param3 * loc7;
				loc10 = loc7 * param1.y + loc8;
				if (loc10 >= param1.x && loc10 <= param1.x + param1.width) {
					param6.x = loc10;
					param6.y = param1.y;
					return true;
				}
			} else if (param5 >= param1.y + param1.height) {
				loc7 = (param4 - param2) / (param5 - param3);
				loc8 = param2 - param3 * loc7;
				loc10 = loc7 * (param1.y + param1.height) + loc8;
				if (loc10 >= param1.x && loc10 <= param1.x + param1.width) {
					param6.x = loc10;
					param6.y = param1.y + param1.height;
					return true;
				}
			}
			return false;
		}

		public static function lineSegmentIntersect(param1:Rectangle, param2:IntPoint, param3:IntPoint):Point {
			var loc4:Number = NaN;
			var loc5:Number = NaN;
			var loc6:Number = NaN;
			var loc7:Number = NaN;
			if (param3.x() <= param1.x) {
				loc4 = (param3.y() - param2.y()) / (param3.x() - param2.x());
				loc5 = param2.y() - param2.x() * loc4;
				loc6 = loc4 * param1.x + loc5;
				if (loc6 >= param1.y && loc6 <= param1.y + param1.height) {
					return new Point(param1.x, loc6);
				}
			} else if (param3.x() >= param1.x + param1.width) {
				loc4 = (param3.y() - param2.y()) / (param3.x() - param2.x());
				loc5 = param2.y() - param2.x() * loc4;
				loc6 = loc4 * (param1.x + param1.width) + loc5;
				if (loc6 >= param1.y && loc6 <= param1.y + param1.height) {
					return new Point(param1.x + param1.width, loc6);
				}
			}
			if (param3.y() <= param1.y) {
				loc4 = (param3.x() - param2.x()) / (param3.y() - param2.y());
				loc5 = param2.x() - param2.y() * loc4;
				loc7 = loc4 * param1.y + loc5;
				if (loc7 >= param1.x && loc7 <= param1.x + param1.width) {
					return new Point(loc7, param1.y);
				}
			} else if (param3.y() >= param1.y + param1.height) {
				loc4 = (param3.x() - param2.x()) / (param3.y() - param2.y());
				loc5 = param2.x() - param2.y() * loc4;
				loc7 = loc4 * (param1.y + param1.height) + loc5;
				if (loc7 >= param1.x && loc7 <= param1.x + param1.width) {
					return new Point(loc7, param1.y + param1.height);
				}
			}
			return null;
		}

		public static function getRotatedRectExtents2D(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number):Extents2D {
			var loc9:Point = null;
			var loc11:int = 0;
			var loc6:Matrix = new Matrix();
			loc6.translate(-param4 / 2, -param5 / 2);
			loc6.rotate(param3);
			loc6.translate(param1, param2);
			var loc7:Extents2D = new Extents2D();
			var loc8:Point = new Point();
			var loc10:int = 0;
			while (loc10 <= 1) {
				loc11 = 0;
				while (loc11 <= 1) {
					loc8.x = loc10 * param4;
					loc8.y = loc11 * param5;
					loc9 = loc6.transformPoint(loc8);
					loc7.add(loc9.x, loc9.y);
					loc11++;
				}
				loc10++;
			}
			return loc7;
		}
	}
}
