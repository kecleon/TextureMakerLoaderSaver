package com.company.util {
	import flash.geom.ColorTransform;

	public class MoreColorUtil {

		public static const greyscaleFilterMatrix:Array = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];

		public static const redFilterMatrix:Array = [0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0];

		public static const identity:ColorTransform = new ColorTransform();

		public static const invisible:ColorTransform = new ColorTransform(1, 1, 1, 0, 0, 0, 0, 0);

		public static const transparentCT:ColorTransform = new ColorTransform(1, 1, 1, 0.3, 0, 0, 0, 0);

		public static const slightlyTransparentCT:ColorTransform = new ColorTransform(1, 1, 1, 0.7, 0, 0, 0, 0);

		public static const greenCT:ColorTransform = new ColorTransform(0.6, 1, 0.6, 1, 0, 0, 0, 0);

		public static const lightGreenCT:ColorTransform = new ColorTransform(0.8, 1, 0.8, 1, 0, 0, 0, 0);

		public static const veryGreenCT:ColorTransform = new ColorTransform(0.2, 1, 0.2, 1, 0, 100, 0, 0);

		public static const transparentGreenCT:ColorTransform = new ColorTransform(0.5, 1, 0.5, 0.3, 0, 0, 0, 0);

		public static const transparentVeryGreenCT:ColorTransform = new ColorTransform(0.3, 1, 0.3, 0.5, 0, 0, 0, 0);

		public static const redCT:ColorTransform = new ColorTransform(1, 0.5, 0.5, 1, 0, 0, 0, 0);

		public static const lightRedCT:ColorTransform = new ColorTransform(1, 0.7, 0.7, 1, 0, 0, 0, 0);

		public static const veryRedCT:ColorTransform = new ColorTransform(1, 0.2, 0.2, 1, 100, 0, 0, 0);

		public static const transparentRedCT:ColorTransform = new ColorTransform(1, 0.5, 0.5, 0.3, 0, 0, 0, 0);

		public static const transparentVeryRedCT:ColorTransform = new ColorTransform(1, 0.3, 0.3, 0.5, 0, 0, 0, 0);

		public static const blueCT:ColorTransform = new ColorTransform(0.5, 0.5, 1, 1, 0, 0, 0, 0);

		public static const lightBlueCT:ColorTransform = new ColorTransform(0.7, 0.7, 1, 1, 0, 0, 100, 0);

		public static const veryBlueCT:ColorTransform = new ColorTransform(0.3, 0.3, 1, 1, 0, 0, 100, 0);

		public static const transparentBlueCT:ColorTransform = new ColorTransform(0.5, 0.5, 1, 0.3, 0, 0, 0, 0);

		public static const transparentVeryBlueCT:ColorTransform = new ColorTransform(0.3, 0.3, 1, 0.5, 0, 0, 0, 0);

		public static const purpleCT:ColorTransform = new ColorTransform(1, 0.5, 1, 1, 0, 0, 0, 0);

		public static const veryPurpleCT:ColorTransform = new ColorTransform(1, 0.2, 1, 1, 100, 0, 100, 0);

		public static const darkCT:ColorTransform = new ColorTransform(0.6, 0.6, 0.6, 1, 0, 0, 0, 0);

		public static const veryDarkCT:ColorTransform = new ColorTransform(0.4, 0.4, 0.4, 1, 0, 0, 0, 0);

		public static const makeWhiteCT:ColorTransform = new ColorTransform(1, 1, 1, 1, 255, 255, 255, 0);


		public function MoreColorUtil(param1:StaticEnforcer) {
			super();
		}

		public static function hsvToRgb(param1:Number, param2:Number, param3:Number):int {
			var loc9:Number = NaN;
			var loc10:Number = NaN;
			var loc11:Number = NaN;
			var loc4:int = int(param1 / 60) % 6;
			var loc5:Number = param1 / 60 - Math.floor(param1 / 60);
			var loc6:Number = param3 * (1 - param2);
			var loc7:Number = param3 * (1 - loc5 * param2);
			var loc8:Number = param3 * (1 - (1 - loc5) * param2);
			switch (loc4) {
				case 0:
					loc9 = param3;
					loc10 = loc8;
					loc11 = loc6;
					break;
				case 1:
					loc9 = loc7;
					loc10 = param3;
					loc11 = loc6;
					break;
				case 2:
					loc9 = loc6;
					loc10 = param3;
					loc11 = loc8;
					break;
				case 3:
					loc9 = loc6;
					loc10 = loc7;
					loc11 = param3;
					break;
				case 4:
					loc9 = loc8;
					loc10 = loc6;
					loc11 = param3;
					break;
				case 5:
					loc9 = param3;
					loc10 = loc6;
					loc11 = loc7;
			}
			return int(Math.min(255, Math.floor(loc9 * 255))) << 16 | int(Math.min(255, Math.floor(loc10 * 255))) << 8 | int(Math.min(255, Math.floor(loc11 * 255)));
		}

		public static function randomColor():uint {
			return uint(16777215 * Math.random());
		}

		public static function randomColor32():uint {
			return uint(16777215 * Math.random()) | 4278190080;
		}

		public static function transformColor(param1:ColorTransform, param2:uint):uint {
			var loc3:int = ((param2 & 16711680) >> 16) * param1.redMultiplier + param1.redOffset;
			loc3 = loc3 < 0 ? 0 : loc3 > 255 ? 255 : int(loc3);
			var loc4:int = ((param2 & 65280) >> 8) * param1.greenMultiplier + param1.greenOffset;
			loc4 = loc4 < 0 ? 0 : loc4 > 255 ? 255 : int(loc4);
			var loc5:int = (param2 & 255) * param1.blueMultiplier + param1.blueOffset;
			loc5 = loc5 < 0 ? 0 : loc5 > 255 ? 255 : int(loc5);
			return loc3 << 16 | loc4 << 8 | loc5;
		}

		public static function copyColorTransform(param1:ColorTransform):ColorTransform {
			return new ColorTransform(param1.redMultiplier, param1.greenMultiplier, param1.blueMultiplier, param1.alphaMultiplier, param1.redOffset, param1.greenOffset, param1.blueOffset, param1.alphaOffset);
		}

		public static function lerpColorTransform(param1:ColorTransform, param2:ColorTransform, param3:Number):ColorTransform {
			if (param1 == null) {
				param1 = identity;
			}
			if (param2 == null) {
				param2 = identity;
			}
			var loc4:Number = 1 - param3;
			var loc5:ColorTransform = new ColorTransform(param1.redMultiplier * loc4 + param2.redMultiplier * param3, param1.greenMultiplier * loc4 + param2.greenMultiplier * param3, param1.blueMultiplier * loc4 + param2.blueMultiplier * param3, param1.alphaMultiplier * loc4 + param2.alphaMultiplier * param3, param1.redOffset * loc4 + param2.redOffset * param3, param1.greenOffset * loc4 + param2.greenOffset * param3, param1.blueOffset * loc4 + param2.blueOffset * param3, param1.alphaOffset * loc4 + param2.alphaOffset * param3);
			return loc5;
		}

		public static function lerpColor(param1:uint, param2:uint, param3:Number):uint {
			var loc4:Number = 1 - param3;
			var loc5:uint = param1 >> 24 & 255;
			var loc6:uint = param1 >> 16 & 255;
			var loc7:uint = param1 >> 8 & 255;
			var loc8:uint = param1 & 255;
			var loc9:uint = param2 >> 24 & 255;
			var loc10:uint = param2 >> 16 & 255;
			var loc11:uint = param2 >> 8 & 255;
			var loc12:uint = param2 & 255;
			var loc13:uint = loc5 * loc4 + loc9 * param3;
			var loc14:uint = loc6 * loc4 + loc10 * param3;
			var loc15:uint = loc7 * loc4 + loc11 * param3;
			var loc16:uint = loc8 * loc4 + loc12 * param3;
			var loc17:uint = loc13 << 24 | loc14 << 16 | loc15 << 8 | loc16;
			return loc17;
		}

		public static function transformAlpha(param1:ColorTransform, param2:Number):Number {
			var loc3:uint = param2 * 255;
			var loc4:uint = loc3 * param1.alphaMultiplier + param1.alphaOffset;
			loc4 = loc4 < 0 ? uint(0) : loc4 > 255 ? uint(255) : uint(loc4);
			return loc4 / 255;
		}

		public static function multiplyColor(param1:uint, param2:Number):uint {
			var loc3:int = ((param1 & 16711680) >> 16) * param2;
			loc3 = loc3 < 0 ? 0 : loc3 > 255 ? 255 : int(loc3);
			var loc4:int = ((param1 & 65280) >> 8) * param2;
			loc4 = loc4 < 0 ? 0 : loc4 > 255 ? 255 : int(loc4);
			var loc5:int = (param1 & 255) * param2;
			loc5 = loc5 < 0 ? 0 : loc5 > 255 ? 255 : int(loc5);
			return loc3 << 16 | loc4 << 8 | loc5;
		}

		public static function adjustBrightness(param1:uint, param2:Number):uint {
			var loc3:uint = param1 & 4278190080;
			var loc4:int = ((param1 & 16711680) >> 16) + param2 * 255;
			loc4 = loc4 < 0 ? 0 : loc4 > 255 ? 255 : int(loc4);
			var loc5:int = ((param1 & 65280) >> 8) + param2 * 255;
			loc5 = loc5 < 0 ? 0 : loc5 > 255 ? 255 : int(loc5);
			var loc6:int = (param1 & 255) + param2 * 255;
			loc6 = loc6 < 0 ? 0 : loc6 > 255 ? 255 : int(loc6);
			return loc3 | loc4 << 16 | loc5 << 8 | loc6;
		}

		public static function colorToShaderParameter(param1:uint):Array {
			var loc2:Number = (param1 >> 24 & 255) / 256;
			return [loc2 * ((param1 >> 16 & 255) / 256), loc2 * ((param1 >> 8 & 255) / 256), loc2 * ((param1 & 255) / 256), loc2];
		}

		public static function rgbToGreyscale(param1:uint):uint {
			var loc2:uint = ((param1 & 16711680) >> 16) * 0.3 + ((param1 & 65280) >> 8) * 0.59 + (param1 & 255) * 0.11;
			return (param1 && 4278190080) | loc2 << 16 | loc2 << 8 | loc2;
		}

		public static function singleColorFilterMatrix(param1:uint):Array {
			return [0, 0, 0, 0, (param1 & 16711680) >> 16, 0, 0, 0, 0, (param1 & 65280) >> 8, 0, 0, 0, 0, param1 & 255, 0, 0, 0, 1, 0];
		}
	}
}

class StaticEnforcer {


	function StaticEnforcer() {
		super();
	}
}
