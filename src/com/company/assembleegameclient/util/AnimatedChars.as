 
package com.company.assembleegameclient.util {
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	public class AnimatedChars {
		
		private static var nameMap_:Dictionary = new Dictionary();
		 
		
		public function AnimatedChars() {
			super();
		}
		
		public static function getAnimatedChar(param1:String, param2:int) : AnimatedChar {
			var loc3:Vector.<AnimatedChar> = nameMap_[param1];
			if(loc3 == null || param2 >= loc3.length) {
				return null;
			}
			return loc3[param2];
		}
		
		public static function add(param1:String, param2:BitmapData, param3:BitmapData, param4:int, param5:int, param6:int, param7:int, param8:int) : void {
			var loc11:MaskedImage = null;
			var loc9:Vector.<AnimatedChar> = new Vector.<AnimatedChar>();
			var loc10:MaskedImageSet = new MaskedImageSet();
			loc10.addFromBitmapData(param2,param3,param6,param7);
			for each(loc11 in loc10.images_) {
				loc9.push(new AnimatedChar(loc11,param4,param5,param8));
			}
			nameMap_[param1] = loc9;
		}
	}
}
