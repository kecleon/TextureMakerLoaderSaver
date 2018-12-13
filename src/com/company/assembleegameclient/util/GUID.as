package com.company.assembleegameclient.util {
	import flash.system.Capabilities;

	public class GUID {

		private static var counter:Number = 0;


		public function GUID() {
			super();
		}

		public static function create():String {
			var loc1:Date = new Date();
			var loc2:Number = loc1.getTime();
			var loc3:Number = Math.random() * Number.MAX_VALUE;
			var loc4:String = Capabilities.serverString;
			return calculate(loc2 + loc4 + loc3 + counter++).toUpperCase();
		}

		private static function calculate(param1:String):String {
			return hex_sha1(param1);
		}

		private static function hex_sha1(param1:String):String {
			return binb2hex(core_sha1(str2binb(param1), param1.length * 8));
		}

		private static function core_sha1(param1:Array, param2:Number):Array {
			var loc10:Number = NaN;
			var loc11:Number = NaN;
			var loc12:Number = NaN;
			var loc13:Number = NaN;
			var loc14:Number = NaN;
			var loc15:Number = NaN;
			var loc16:Number = NaN;
			param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
			param1[(param2 + 64 >> 9 << 4) + 15] = param2;
			var loc3:Array = new Array(80);
			var loc4:Number = 1732584193;
			var loc5:Number = -271733879;
			var loc6:Number = -1732584194;
			var loc7:Number = 271733878;
			var loc8:Number = -1009589776;
			var loc9:Number = 0;
			while (loc9 < param1.length) {
				loc10 = loc4;
				loc11 = loc5;
				loc12 = loc6;
				loc13 = loc7;
				loc14 = loc8;
				loc15 = 0;
				while (loc15 < 80) {
					if (loc15 < 16) {
						loc3[loc15] = param1[loc9 + loc15];
					} else {
						loc3[loc15] = rol(loc3[loc15 - 3] ^ loc3[loc15 - 8] ^ loc3[loc15 - 14] ^ loc3[loc15 - 16], 1);
					}
					loc16 = safe_add(safe_add(rol(loc4, 5), sha1_ft(loc15, loc5, loc6, loc7)), safe_add(safe_add(loc8, loc3[loc15]), sha1_kt(loc15)));
					loc8 = loc7;
					loc7 = loc6;
					loc6 = rol(loc5, 30);
					loc5 = loc4;
					loc4 = loc16;
					loc15++;
				}
				loc4 = safe_add(loc4, loc10);
				loc5 = safe_add(loc5, loc11);
				loc6 = safe_add(loc6, loc12);
				loc7 = safe_add(loc7, loc13);
				loc8 = safe_add(loc8, loc14);
				loc9 = loc9 + 16;
			}
			return new Array(loc4, loc5, loc6, loc7, loc8);
		}

		private static function sha1_ft(param1:Number, param2:Number, param3:Number, param4:Number):Number {
			if (param1 < 20) {
				return param2 & param3 | ~param2 & param4;
			}
			if (param1 < 40) {
				return param2 ^ param3 ^ param4;
			}
			if (param1 < 60) {
				return param2 & param3 | param2 & param4 | param3 & param4;
			}
			return param2 ^ param3 ^ param4;
		}

		private static function sha1_kt(param1:Number):Number {
			return param1 < 20 ? Number(1518500249) : param1 < 40 ? Number(1859775393) : param1 < 60 ? Number(-1894007588) : Number(-899497514);
		}

		private static function safe_add(param1:Number, param2:Number):Number {
			var loc3:Number = (param1 & 65535) + (param2 & 65535);
			var loc4:Number = (param1 >> 16) + (param2 >> 16) + (loc3 >> 16);
			return loc4 << 16 | loc3 & 65535;
		}

		private static function rol(param1:Number, param2:Number):Number {
			return param1 << param2 | param1 >>> 32 - param2;
		}

		private static function str2binb(param1:String):Array {
			var loc2:Array = new Array();
			var loc3:Number = 1 << 8 - 1;
			var loc4:Number = 0;
			while (loc4 < param1.length * 8) {
				loc2[loc4 >> 5] = loc2[loc4 >> 5] | (param1.charCodeAt(loc4 / 8) & loc3) << 24 - loc4 % 32;
				loc4 = loc4 + 8;
			}
			return loc2;
		}

		private static function binb2hex(param1:Array):String {
			var loc2:String = new String("");
			var loc3:String = new String("0123456789abcdef");
			var loc4:Number = 0;
			while (loc4 < param1.length * 4) {
				loc2 = loc2 + (loc3.charAt(param1[loc4 >> 2] >> (3 - loc4 % 4) * 8 + 4 & 15) + loc3.charAt(param1[loc4 >> 2] >> (3 - loc4 % 4) * 8 & 15));
				loc4++;
			}
			return loc2;
		}
	}
}
