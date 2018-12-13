package com.company.util {
	import flash.geom.Point;

	public class PointUtil {

		public static const ORIGIN:Point = new Point(0, 0);


		public function PointUtil(param1:StaticEnforcer) {
			super();
		}

		public static function roundPoint(param1:Point):Point {
			var loc2:Point = param1.clone();
			loc2.x = Math.round(loc2.x);
			loc2.y = Math.round(loc2.y);
			return loc2;
		}

		public static function distanceSquared(param1:Point, param2:Point):Number {
			return distanceSquaredXY(param1.x, param1.y, param2.x, param2.y);
		}

		public static function distanceSquaredXY(param1:Number, param2:Number, param3:Number, param4:Number):Number {
			var loc5:Number = param3 - param1;
			var loc6:Number = param4 - param2;
			return loc5 * loc5 + loc6 * loc6;
		}

		public static function distanceXY(param1:Number, param2:Number, param3:Number, param4:Number):Number {
			var loc5:Number = param3 - param1;
			var loc6:Number = param4 - param2;
			return Math.sqrt(loc5 * loc5 + loc6 * loc6);
		}

		public static function lerpXY(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number):Point {
			return new Point(param1 + (param3 - param1) * param5, param2 + (param4 - param2) * param5);
		}

		public static function angleTo(param1:Point, param2:Point):Number {
			return Math.atan2(param2.y - param1.y, param2.x - param1.x);
		}

		public static function pointAt(param1:Point, param2:Number, param3:Number):Point {
			var loc4:Point = new Point();
			loc4.x = param1.x + param3 * Math.cos(param2);
			loc4.y = param1.y + param3 * Math.sin(param2);
			return loc4;
		}
	}
}

class StaticEnforcer {


	function StaticEnforcer() {
		super();
	}
}
