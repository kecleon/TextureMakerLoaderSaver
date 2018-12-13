 
package com.company.assembleegameclient.util {
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	public class BloodComposition {
		
		private static var idDict_:Dictionary = new Dictionary();
		
		private static var imageDict_:Dictionary = new Dictionary();
		 
		
		public function BloodComposition() {
			super();
		}
		
		public static function getBloodComposition(param1:int, param2:BitmapData, param3:Number, param4:uint) : Vector.<uint> {
			var loc5:Vector.<uint> = idDict_[param1];
			if(loc5 != null) {
				return loc5;
			}
			loc5 = new Vector.<uint>();
			var loc6:Vector.<uint> = getColors(param2);
			var loc7:int = 0;
			while(loc7 < loc6.length) {
				if(Math.random() < param3) {
					loc5.push(param4);
				} else {
					loc5.push(loc6[int(loc6.length * Math.random())]);
				}
				loc7++;
			}
			return loc5;
		}
		
		public static function getColors(param1:BitmapData) : Vector.<uint> {
			var loc2:Vector.<uint> = imageDict_[param1];
			if(loc2 == null) {
				loc2 = buildColors(param1);
				imageDict_[param1] = loc2;
			}
			return loc2;
		}
		
		private static function buildColors(param1:BitmapData) : Vector.<uint> {
			var loc4:int = 0;
			var loc5:uint = 0;
			var loc2:Vector.<uint> = new Vector.<uint>();
			var loc3:int = 0;
			while(loc3 < param1.width) {
				loc4 = 0;
				while(loc4 < param1.height) {
					loc5 = param1.getPixel32(loc3,loc4);
					if((loc5 & 4278190080) != 0) {
						loc2.push(loc5);
					}
					loc4++;
				}
				loc3++;
			}
			return loc2;
		}
	}
}
