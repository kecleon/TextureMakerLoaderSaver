 
package com.company.assembleegameclient.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import kabam.rotmg.constants.ItemConstants;
	
	public class EquipmentUtil {
		
		public static const NUM_SLOTS:uint = 4;
		 
		
		public function EquipmentUtil() {
			super();
		}
		
		public static function getEquipmentBackground(param1:int, param2:Number = 1.0) : Bitmap {
			var loc3:Bitmap = null;
			var loc4:BitmapData = ItemConstants.itemTypeToBaseSprite(param1);
			if(loc4 != null) {
				loc3 = new Bitmap(loc4);
				loc3.scaleX = param2;
				loc3.scaleY = param2;
			}
			return loc3;
		}
	}
}
