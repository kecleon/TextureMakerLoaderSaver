package io.decagames.rotmg.utils.colors {
	import flash.utils.Dictionary;

	public class RandomColorGenerator {


		private var colorDictionary:Dictionary;

		private var seed:int = -1;

		public function RandomColorGenerator(param1:int = -1) {
			super();
			this.seed = param1;
			this.colorDictionary = new Dictionary();
			this.loadColorBounds();
		}

		public function randomColor(param1:String = ""):Array {
			var loc2:int = this.pickHue();
			var loc3:int = this.pickSaturation(loc2, param1);
			var loc4:int = this.pickBrightness(loc2, loc3, param1);
			var loc5:Array = this.HSVtoRGB([loc2, loc3, loc4]);
			return loc5;
		}

		private function HSVtoRGB(param1:Array):Array {
			var loc2:Number = param1[0];
			if (loc2 === 0) {
				loc2 = 1;
			}
			if (loc2 === 360) {
				loc2 = 359;
			}
			loc2 = loc2 / 360;
			var loc3:Number = param1[1] / 100;
			var loc4:Number = param1[2] / 100;
			var loc5:Number = Math.floor(loc2 * 6);
			var loc6:Number = loc2 * 6 - loc5;
			var loc7:Number = loc4 * (1 - loc3);
			var loc8:Number = loc4 * (1 - loc6 * loc3);
			var loc9:Number = loc4 * (1 - (1 - loc6) * loc3);
			var loc10:Number = 256;
			var loc11:Number = 256;
			var loc12:Number = 256;
			switch (loc5) {
				case 0:
					loc10 = loc4;
					loc11 = loc9;
					loc12 = loc7;
					break;
				case 1:
					loc10 = loc8;
					loc11 = loc4;
					loc12 = loc7;
					break;
				case 2:
					loc10 = loc7;
					loc11 = loc4;
					loc12 = loc9;
					break;
				case 3:
					loc10 = loc7;
					loc11 = loc8;
					loc12 = loc4;
					break;
				case 4:
					loc10 = loc9;
					loc11 = loc7;
					loc12 = loc4;
					break;
				case 5:
					loc10 = loc4;
					loc11 = loc7;
					loc12 = loc8;
			}
			return [Math.floor(loc10 * 255), Math.floor(loc11 * 255), Math.floor(loc12 * 255)];
		}

		private function pickSaturation(param1:int, param2:String):int {
			var loc3:Array = this.getSaturationRange(param1);
			var loc4:int = loc3[0];
			var loc5:int = loc3[1];
			switch (param2) {
				case "bright":
					loc4 = 55;
					break;
				case "dark":
					loc4 = loc5 - 10;
					break;
				case "light":
					loc5 = 55;
			}
			return this.randomWithin([loc4, loc5]);
		}

		private function getColorInfo(param1:int):Object {
			var loc2:* = null;
			var loc3:Object = null;
			if (param1 >= 334 && param1 <= 360) {
				param1 = param1 - 360;
			}
			for (loc2 in this.colorDictionary) {
				loc3 = this.colorDictionary[loc2];
				if (loc3.hueRange && param1 >= loc3.hueRange[0] && param1 <= loc3.hueRange[1]) {
					return this.colorDictionary[loc2];
				}
			}
			return null;
		}

		private function getSaturationRange(param1:int):Array {
			return this.getColorInfo(param1).saturationRange;
		}

		private function pickBrightness(param1:int, param2:int, param3:String):int {
			var loc4:int = this.getMinimumBrightness(param1, param2);
			var loc5:int = 100;
			switch (param3) {
				case "dark":
					loc5 = loc4 + 20;
					break;
				case "light":
					loc4 = (loc5 + loc4) / 2;
					break;
				case "random":
					loc4 = 0;
					loc5 = 100;
			}
			return this.randomWithin([loc4, loc5]);
		}

		private function getMinimumBrightness(param1:int, param2:int):int {
			var loc5:int = 0;
			var loc6:int = 0;
			var loc7:int = 0;
			var loc8:int = 0;
			var loc9:Number = NaN;
			var loc10:Number = NaN;
			var loc3:Array = this.getColorInfo(param1).lowerBounds;
			var loc4:int = 0;
			while (loc4 < loc3.length - 1) {
				loc5 = loc3[loc4][0];
				loc6 = loc3[loc4][1];
				loc7 = loc3[loc4 + 1][0];
				loc8 = loc3[loc4 + 1][1];
				if (param2 >= loc5 && param2 <= loc7) {
					loc9 = (loc8 - loc6) / (loc7 - loc5);
					loc10 = loc6 - loc9 * loc5;
					return loc9 * param2 + loc10;
				}
				loc4++;
			}
			return 0;
		}

		private function randomWithin(param1:Array):int {
			var loc2:Number = NaN;
			var loc3:Number = NaN;
			var loc4:Number = NaN;
			if (this.seed == -1) {
				return Math.floor(param1[0] + Math.random() * (param1[1] + 1 - param1[0]));
			}
			loc2 = Number(param1[1]) || Number(1);
			loc3 = Number(param1[0]) || Number(0);
			this.seed = (this.seed * 9301 + 49297) % 233280;
			loc4 = this.seed / 233280;
			return Math.floor(loc3 + loc4 * (loc2 - loc3));
		}

		private function pickHue(param1:int = -1):int {
			var loc2:Array = this.getHueRange(param1);
			var loc3:int = this.randomWithin(loc2);
			if (loc3 < 0) {
				loc3 = 360 + loc3;
			}
			return loc3;
		}

		private function getHueRange(param1:int):Array {
			if (param1 < 360 && param1 > 0) {
				return [param1, param1];
			}
			return [0, 360];
		}

		private function defineColor(param1:String, param2:Array, param3:Array):void {
			var loc4:int = param3[0][0];
			var loc5:int = param3[param3.length - 1][0];
			var loc6:int = param3[param3.length - 1][1];
			var loc7:int = param3[0][1];
			this.colorDictionary[param1] = {
				"hueRange": param2,
				"lowerBounds": param3,
				"saturationRange": [loc4, loc5],
				"brightnessRange": [loc6, loc7]
			};
		}

		private function loadColorBounds():void {
			this.defineColor("monochrome", null, [[0, 0], [100, 0]]);
			this.defineColor("red", [-26, 18], [[20, 100], [30, 92], [40, 89], [50, 85], [60, 78], [70, 70], [80, 60], [90, 55], [100, 50]]);
			this.defineColor("orange", [19, 46], [[20, 100], [30, 93], [40, 88], [50, 86], [60, 85], [70, 70], [100, 70]]);
			this.defineColor("yellow", [47, 62], [[25, 100], [40, 94], [50, 89], [60, 86], [70, 84], [80, 82], [90, 80], [100, 75]]);
			this.defineColor("green", [63, 178], [[30, 100], [40, 90], [50, 85], [60, 81], [70, 74], [80, 64], [90, 50], [100, 40]]);
			this.defineColor("blue", [179, 257], [[20, 100], [30, 86], [40, 80], [50, 74], [60, 60], [70, 52], [80, 44], [90, 39], [100, 35]]);
			this.defineColor("purple", [258, 282], [[20, 100], [30, 87], [40, 79], [50, 70], [60, 65], [70, 59], [80, 52], [90, 45], [100, 42]]);
			this.defineColor("pink", [283, 334], [[20, 100], [30, 90], [40, 86], [60, 84], [80, 80], [90, 75], [100, 73]]);
		}
	}
}
