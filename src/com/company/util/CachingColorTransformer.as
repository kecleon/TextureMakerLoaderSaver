 
package com.company.util {
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class CachingColorTransformer {
		
		private static var bds_:Dictionary = new Dictionary();
		 
		
		public function CachingColorTransformer() {
			super();
		}
		
		public static function transformBitmapData(param1:BitmapData, param2:ColorTransform) : BitmapData {
			var loc3:BitmapData = null;
			var loc4:Object = bds_[param1];
			if(loc4 != null) {
				loc3 = loc4[param2];
			} else {
				loc4 = new Object();
				bds_[param1] = loc4;
			}
			if(loc3 == null) {
				loc3 = param1.clone();
				loc3.colorTransform(loc3.rect,param2);
				loc4[param2] = loc3;
			}
			return loc3;
		}
		
		public static function filterBitmapData(param1:BitmapData, param2:BitmapFilter) : BitmapData {
			var loc3:BitmapData = null;
			var loc4:Object = bds_[param1];
			if(loc4 != null) {
				loc3 = loc4[param2];
			} else {
				loc4 = new Object();
				bds_[param1] = loc4;
			}
			if(loc3 == null) {
				loc3 = param1.clone();
				loc3.applyFilter(loc3,loc3.rect,new Point(),param2);
				loc4[param2] = loc3;
			}
			return loc3;
		}
		
		public static function alphaBitmapData(param1:BitmapData, param2:Number) : BitmapData {
			var loc3:int = int(param2 * 100);
			var loc4:ColorTransform = new ColorTransform(1,1,1,loc3 / 100);
			return transformBitmapData(param1,loc4);
		}
		
		public static function clear() : void {
			var loc1:Object = null;
			var loc2:BitmapData = null;
			for each(loc1 in bds_) {
				for each(loc2 in loc1) {
					loc2.dispose();
				}
			}
			bds_ = new Dictionary();
		}
	}
}
