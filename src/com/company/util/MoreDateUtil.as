package com.company.util {
	public class MoreDateUtil {


		public function MoreDateUtil() {
			super();
		}

		public static function getDayStringInPT():String {
			var loc1:Date = new Date();
			var loc2:Number = loc1.getTime();
			loc2 = loc2 + (loc1.timezoneOffset - 420) * 60 * 1000;
			loc1.setTime(loc2);
			var loc3:DateFormatterReplacement = new DateFormatterReplacement();
			loc3.formatString = "MMMM D, YYYY";
			return loc3.format(loc1);
		}
	}
}
