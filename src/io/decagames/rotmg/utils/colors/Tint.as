 
package io.decagames.rotmg.utils.colors {
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	public class Tint {
		 
		
		public function Tint() {
			super();
		}
		
		public static function add(param1:DisplayObject, param2:uint, param3:Number) : void {
			var loc4:ColorTransform = param1.transform.colorTransform;
			loc4.color = param2;
			var loc5:Number = param3 / (1 - (loc4.redMultiplier + loc4.greenMultiplier + loc4.blueMultiplier) / 3);
			loc4.redOffset = loc4.redOffset * loc5;
			loc4.greenOffset = loc4.greenOffset * loc5;
			loc4.blueOffset = loc4.blueOffset * loc5;
			loc4.redMultiplier = loc4.greenMultiplier = loc4.blueMultiplier = 1 - param3;
			param1.transform.colorTransform = loc4;
		}
	}
}
