 
package io.decagames.rotmg.utils.dictionary {
	import flash.utils.Dictionary;
	
	public class DictionaryUtils {
		 
		
		public function DictionaryUtils() {
			super();
		}
		
		public static function countKeys(param1:Dictionary) : int {
			var loc3:* = undefined;
			var loc2:int = 0;
			for(loc3 in param1) {
				loc2++;
			}
			return loc2;
		}
	}
}
