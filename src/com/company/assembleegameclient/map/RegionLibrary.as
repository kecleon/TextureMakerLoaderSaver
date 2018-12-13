 
package com.company.assembleegameclient.map {
	import flash.utils.Dictionary;
	
	public class RegionLibrary {
		
		public static const xmlLibrary_:Dictionary = new Dictionary();
		
		public static var idToType_:Dictionary = new Dictionary();
		
		public static const ENTRY_REGION_TYPE:uint = 1;
		
		public static const EXIT_REGION_TYPE:uint = 48;
		 
		
		public function RegionLibrary() {
			super();
		}
		
		public static function parseFromXML(param1:XML) : void {
			var loc2:XML = null;
			var loc3:int = 0;
			for each(loc2 in param1.Region) {
				loc3 = int(loc2.@type);
				xmlLibrary_[loc3] = loc2;
				idToType_[String(loc2.@id)] = loc3;
			}
		}
		
		public static function getIdFromType(param1:int) : String {
			var loc2:XML = xmlLibrary_[param1];
			if(loc2 == null) {
				return null;
			}
			return String(loc2.@id);
		}
		
		public static function getColor(param1:int) : uint {
			var loc2:XML = xmlLibrary_[param1];
			if(loc2 == null) {
				return 0;
			}
			return uint(loc2.Color);
		}
	}
}
