 
package com.company.assembleegameclient.util {
	public class ColorUtil {
		 
		
		public function ColorUtil() {
			super();
		}
		
		public static function rangeRandomSmart(param1:uint, param2:uint) : Number {
			var loc3:uint = param1 >> 16 & 255;
			var loc4:uint = param1 >> 8 & 255;
			var loc5:uint = param1 & 255;
			var loc6:uint = param2 >> 16 & 255;
			var loc7:uint = param2 >> 8 & 255;
			var loc8:uint = param2 & 255;
			var loc9:uint = loc6 + Math.random() * (loc3 - loc6);
			var loc10:uint = loc7 + Math.random() * (loc4 - loc7);
			var loc11:uint = loc8 + Math.random() * (loc5 - loc8);
			return loc9 << 16 | loc10 << 8 | loc11;
		}
		
		public static function randomSmart(param1:uint) : Number {
			var loc2:uint = param1 >> 16 & 255;
			var loc3:uint = param1 >> 8 & 255;
			var loc4:uint = param1 & 255;
			var loc5:uint = Math.max(0,Math.min(255,loc2 + RandomUtil.plusMinus(loc2 * 0.05)));
			var loc6:uint = Math.max(0,Math.min(255,loc3 + RandomUtil.plusMinus(loc3 * 0.05)));
			var loc7:uint = Math.max(0,Math.min(255,loc4 + RandomUtil.plusMinus(loc4 * 0.05)));
			return loc5 << 16 | loc6 << 8 | loc7;
		}
		
		public static function rangeRandomMix(param1:uint, param2:uint) : Number {
			var loc3:uint = param1 >> 16 & 255;
			var loc4:uint = param1 >> 8 & 255;
			var loc5:uint = param1 & 255;
			var loc6:uint = param2 >> 16 & 255;
			var loc7:uint = param2 >> 8 & 255;
			var loc8:uint = param2 & 255;
			var loc9:Number = Math.random();
			var loc10:uint = loc6 + loc9 * (loc3 - loc6);
			var loc11:uint = loc7 + loc9 * (loc4 - loc7);
			var loc12:uint = loc8 + loc9 * (loc5 - loc8);
			return loc10 << 16 | loc11 << 8 | loc12;
		}
		
		public static function rangeRandom(param1:uint, param2:uint) : Number {
			return param2 + Math.random() * (param1 - param2);
		}
	}
}
