package com.company.util {
	import flash.utils.ByteArray;

	public class MoreStringUtil {


		public function MoreStringUtil() {
			super();
		}

		public static function hexStringToByteArray(param1:String):ByteArray {
			var loc2:ByteArray = new ByteArray();
			var loc3:int = 0;
			while (loc3 < param1.length) {
				loc2.writeByte(parseInt(param1.substr(loc3, 2), 16));
				loc3 = loc3 + 2;
			}
			return loc2;
		}

		public static function cmp(param1:String, param2:String):Number {
			return param1.localeCompare(param2);
		}
	}
}
