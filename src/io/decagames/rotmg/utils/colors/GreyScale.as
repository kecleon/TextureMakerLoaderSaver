package io.decagames.rotmg.utils.colors {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GreyScale {


		public function GreyScale() {
			super();
		}

		public static function setGreyScale(param1:BitmapData):BitmapData {
			var loc2:Number = 0.2225;
			var loc3:Number = 0.7169;
			var loc4:Number = 0.0606;
			var loc5:Array = [loc2, loc3, loc4, 0, 0, loc2, loc3, loc4, 0, 0, loc2, loc3, loc4, 0, 0, 0, 0, 0, 1, 0];
			var loc6:ColorMatrixFilter = new ColorMatrixFilter(loc5);
			param1.applyFilter(param1, new Rectangle(0, 0, param1.width, param1.height), new Point(0, 0), loc6);
			return param1;
		}

		public static function greyScaleToDisplayObject(param1:DisplayObject, param2:Boolean):void {
			var loc3:Number = 0.2225;
			var loc4:Number = 0.7169;
			var loc5:Number = 0.0606;
			var loc6:Array = [loc3, loc4, loc5, 0, 0, loc3, loc4, loc5, 0, 0, loc3, loc4, loc5, 0, 0, 0, 0, 0, 1, 0];
			var loc7:ColorMatrixFilter = new ColorMatrixFilter(loc6);
			if (param2) {
				param1.filters = [loc7];
			} else {
				param1.filters = [];
			}
		}
	}
}
