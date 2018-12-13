package com.company.assembleegameclient.util {
	import com.company.assembleegameclient.objects.ObjectLibrary;
	import com.company.rotmg.graphics.StarGraphic;
	import com.company.util.AssetLibrary;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;

	public class FameUtil {

		public static const MAX_STARS:int = 75;

		public static const STARS:Vector.<int> = new <int>[20, 150, 400, 800, 2000];

		private static const lightBlueCT:ColorTransform = new ColorTransform(138 / 255, 152 / 255, 222 / 255);

		private static const darkBlueCT:ColorTransform = new ColorTransform(49 / 255, 77 / 255, 219 / 255);

		private static const redCT:ColorTransform = new ColorTransform(193 / 255, 39 / 255, 45 / 255);

		private static const orangeCT:ColorTransform = new ColorTransform(247 / 255, 147 / 255, 30 / 255);

		private static const yellowCT:ColorTransform = new ColorTransform(255 / 255, 255 / 255, 0 / 255);

		public static const COLORS:Vector.<ColorTransform> = new <ColorTransform>[lightBlueCT, darkBlueCT, redCT, orangeCT, yellowCT];


		public function FameUtil() {
			super();
		}

		public static function maxStars():int {
			return ObjectLibrary.playerChars_.length * STARS.length;
		}

		public static function numStars(param1:int):int {
			var loc2:int = 0;
			while (loc2 < STARS.length && param1 >= STARS[loc2]) {
				loc2++;
			}
			return loc2;
		}

		public static function nextStarFame(param1:int, param2:int):int {
			var loc3:int = Math.max(param1, param2);
			var loc4:int = 0;
			while (loc4 < STARS.length) {
				if (STARS[loc4] > loc3) {
					return STARS[loc4];
				}
				loc4++;
			}
			return -1;
		}

		public static function numAllTimeStars(param1:int, param2:int, param3:XML):int {
			var loc6:XML = null;
			var loc4:int = 0;
			var loc5:int = 0;
			for each(loc6 in param3.ClassStats) {
				if (param1 == int(loc6.@objectType)) {
					loc5 = int(loc6.BestFame);
				} else {
					loc4 = loc4 + FameUtil.numStars(loc6.BestFame);
				}
			}
			loc4 = loc4 + FameUtil.numStars(Math.max(loc5, param2));
			return loc4;
		}

		public static function numStarsToBigImage(param1:int):Sprite {
			var loc2:Sprite = numStarsToImage(param1);
			loc2.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
			loc2.scaleX = 1.4;
			loc2.scaleY = 1.4;
			return loc2;
		}

		public static function numStarsToImage(param1:int):Sprite {
			var loc2:Sprite = new StarGraphic();
			if (param1 < ObjectLibrary.playerChars_.length) {
				loc2.transform.colorTransform = lightBlueCT;
			} else if (param1 < ObjectLibrary.playerChars_.length * 2) {
				loc2.transform.colorTransform = darkBlueCT;
			} else if (param1 < ObjectLibrary.playerChars_.length * 3) {
				loc2.transform.colorTransform = redCT;
			} else if (param1 < ObjectLibrary.playerChars_.length * 4) {
				loc2.transform.colorTransform = orangeCT;
			} else if (param1 < ObjectLibrary.playerChars_.length * 5) {
				loc2.transform.colorTransform = yellowCT;
			}
			return loc2;
		}

		public static function numStarsToIcon(param1:int):Sprite {
			var loc2:Sprite = null;
			var loc3:Sprite = null;
			loc2 = numStarsToImage(param1);
			loc3 = new Sprite();
			loc3.graphics.beginFill(0, 0.4);
			var loc4:int = loc2.width / 2 + 2;
			var loc5:int = loc2.height / 2 + 2;
			loc3.graphics.drawCircle(loc4, loc5, loc4);
			loc2.x = 2;
			loc2.y = 1;
			loc3.addChild(loc2);
			loc3.filters = [new DropShadowFilter(0, 0, 0, 0.5, 6, 6, 1)];
			return loc3;
		}

		public static function getFameIcon():BitmapData {
			var loc1:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 224);
			return TextureRedrawer.redraw(loc1, 40, true, 0);
		}
	}
}
