package com.company.assembleegameclient.util {
	public class MathUtil {

		public static const TO_DEG:Number = 180 / Math.PI;

		public static const TO_RAD:Number = Math.PI / 180;


		public function MathUtil() {
			super();
		}

		public static function round(param1:Number, param2:int = 0):Number {
			var loc3:int = Math.pow(10, param2);
			return Math.round(param1 * loc3) / loc3;
		}
	}
}
