 
package com.company.assembleegameclient.map {
	import com.company.assembleegameclient.objects.TextureDataConcrete;
	import com.company.util.BitmapUtil;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	public class GroundLibrary {
		
		public static const propsLibrary_:Dictionary = new Dictionary();
		
		public static const xmlLibrary_:Dictionary = new Dictionary();
		
		private static var tileTypeColorDict_:Dictionary = new Dictionary();
		
		public static const typeToTextureData_:Dictionary = new Dictionary();
		
		public static var idToType_:Dictionary = new Dictionary();
		
		public static var defaultProps_:GroundProperties;
		
		public static var GROUND_CATEGORY:String = "Ground";
		 
		
		public function GroundLibrary() {
			super();
		}
		
		public static function parseFromXML(param1:XML) : void {
			var loc2:XML = null;
			var loc3:int = 0;
			for each(loc2 in param1.Ground) {
				loc3 = int(loc2.@type);
				propsLibrary_[loc3] = new GroundProperties(loc2);
				xmlLibrary_[loc3] = loc2;
				typeToTextureData_[loc3] = new TextureDataConcrete(loc2);
				idToType_[String(loc2.@id)] = loc3;
			}
			defaultProps_ = propsLibrary_[255];
		}
		
		public static function getIdFromType(param1:int) : String {
			var loc2:GroundProperties = propsLibrary_[param1];
			if(loc2 == null) {
				return null;
			}
			return loc2.id_;
		}
		
		public static function getPropsFromId(param1:String) : GroundProperties {
			return propsLibrary_[idToType_[param1]];
		}
		
		public static function getBitmapData(param1:int, param2:int = 0) : BitmapData {
			return typeToTextureData_[param1].getTexture(param2);
		}
		
		public static function getColor(param1:int) : uint {
			var loc2:XML = null;
			var loc3:uint = 0;
			var loc4:BitmapData = null;
			if(!tileTypeColorDict_.hasOwnProperty(param1)) {
				loc2 = xmlLibrary_[param1];
				if(loc2.hasOwnProperty("Color")) {
					loc3 = uint(loc2.Color);
				} else {
					loc4 = getBitmapData(param1);
					loc3 = BitmapUtil.mostCommonColor(loc4);
				}
				tileTypeColorDict_[param1] = loc3;
			}
			return tileTypeColorDict_[param1];
		}
	}
}
