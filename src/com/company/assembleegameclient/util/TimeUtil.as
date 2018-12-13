 
package com.company.assembleegameclient.util {
	public class TimeUtil {
		
		public static const DAY_IN_MS:int = 86400000;
		
		public static const DAY_IN_S:int = 86400;
		
		public static const HOUR_IN_S:int = 3600;
		
		public static const MIN_IN_S:int = 60;
		 
		
		public function TimeUtil() {
			super();
		}
		
		public static function secondsToDays(param1:Number) : Number {
			return param1 / DAY_IN_S;
		}
		
		public static function secondsToHours(param1:Number) : Number {
			return param1 / HOUR_IN_S;
		}
		
		public static function secondsToMins(param1:Number) : Number {
			return param1 / MIN_IN_S;
		}
		
		public static function parseUTCDate(param1:String) : Date {
			var loc2:Array = param1.match(/(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)/);
			var loc3:Date = new Date();
			loc3.setUTCFullYear(int(loc2[1]),int(loc2[2]) - 1,int(loc2[3]));
			loc3.setUTCHours(int(loc2[4]),int(loc2[5]),int(loc2[6]),0);
			return loc3;
		}
		
		public static function humanReadableTime(param1:int) : String {
			var loc2:String = null;
			var loc3:int = 0;
			var loc4:int = 0;
			var loc5:int = 0;
			var loc6:int = 0;
			loc6 = param1 >= 0?int(param1):0;
			loc3 = loc6 / DAY_IN_S;
			loc6 = loc6 % DAY_IN_S;
			loc4 = loc6 / HOUR_IN_S;
			loc6 = loc6 % HOUR_IN_S;
			loc5 = loc6 / MIN_IN_S;
			loc2 = _getReadableTime(param1,loc3,loc4,loc5);
			return loc2;
		}
		
		private static function _getReadableTime(param1:int, param2:int, param3:int, param4:int) : String {
			var loc5:String = null;
			if(param1 >= DAY_IN_S) {
				if(param3 == 0 && param4 == 0) {
					loc5 = param2.toString() + (param2 > 1?"days":"day");
					return loc5;
				}
				if(param4 == 0) {
					loc5 = param2.toString() + (param2 > 1?" days":" day");
					loc5 = loc5 + (", " + param3.toString() + (param3 > 1?" hours":" hour"));
					return loc5;
				}
				loc5 = param2.toString() + (param2 > 1?" days":" day");
				loc5 = loc5 + (", " + param3.toString() + (param3 > 1?" hours":" hour"));
				loc5 = loc5 + (" and " + param4.toString() + (param4 > 1?" minutes":" minute"));
				return loc5;
			}
			if(param1 >= HOUR_IN_S) {
				if(param4 == 0) {
					loc5 = param3.toString() + (param3 > 1?" hours":" hour");
					return loc5;
				}
				loc5 = param3.toString() + (param3 > 1?" hours":" hour");
				loc5 = loc5 + (" and " + param4.toString() + (param4 > 1?" minutes":" minute"));
				return loc5;
			}
			loc5 = param4.toString() + (param4 > 1?" minutes":" minute");
			return loc5;
		}
	}
}
