package kabam.rotmg.stage3D.graphic3D {
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import kabam.rotmg.stage3D.proxies.Context3DProxy;
	import kabam.rotmg.stage3D.proxies.TextureProxy;

	public class TextureFactory {

		private static var textures:Dictionary = new Dictionary();

		private static var flippedTextures:Dictionary = new Dictionary();

		private static var count:int = 0;


		[Inject]
		public var context3D:Context3DProxy;

		public function TextureFactory() {
			super();
		}

		public static function GetFlippedBitmapData(param1:BitmapData):BitmapData {
			var loc2:BitmapData = null;
			if (param1 in flippedTextures) {
				return flippedTextures[param1];
			}
			loc2 = flipBitmapData(param1, "y");
			flippedTextures[param1] = loc2;
			return loc2;
		}

		private static function flipBitmapData(param1:BitmapData, param2:String = "x"):BitmapData {
			var loc4:Matrix = null;
			var loc3:BitmapData = new BitmapData(param1.width, param1.height, true, 0);
			if (param2 == "x") {
				loc4 = new Matrix(-1, 0, 0, 1, param1.width, 0);
			} else {
				loc4 = new Matrix(1, 0, 0, -1, 0, param1.height);
			}
			loc3.draw(param1, loc4, null, null, null, true);
			return loc3;
		}

		private static function getNextPowerOf2(param1:int):Number {
			param1--;
			param1 = param1 | param1 >> 1;
			param1 = param1 | param1 >> 2;
			param1 = param1 | param1 >> 4;
			param1 = param1 | param1 >> 8;
			param1 = param1 | param1 >> 16;
			param1++;
			return param1;
		}

		public static function disposeTextures():void {
			var loc1:TextureProxy = null;
			var loc2:BitmapData = null;
			for each(loc1 in textures) {
				loc1.dispose();
			}
			textures = new Dictionary();
			for each(loc2 in flippedTextures) {
				loc2.dispose();
			}
			flippedTextures = new Dictionary();
			count = 0;
		}

		public static function disposeNormalTextures():void {
			var loc1:TextureProxy = null;
			for each(loc1 in textures) {
				loc1.dispose();
			}
			textures = new Dictionary();
		}

		public function make(param1:BitmapData):TextureProxy {
			var loc2:int = 0;
			var loc3:int = 0;
			var loc4:TextureProxy = null;
			var loc5:BitmapData = null;
			if (param1 == null) {
				return null;
			}
			if (param1 in textures) {
				return textures[param1];
			}
			loc2 = getNextPowerOf2(param1.width);
			loc3 = getNextPowerOf2(param1.height);
			loc4 = this.context3D.createTexture(loc2, loc3, Context3DTextureFormat.BGRA, false);
			loc5 = new BitmapData(loc2, loc3, true, 0);
			loc5.copyPixels(param1, param1.rect, new Point(0, 0));
			loc4.uploadFromBitmapData(loc5);
			if (count > 1000) {
				disposeNormalTextures();
				count = 0;
			}
			textures[param1] = loc4;
			count++;
			return loc4;
		}
	}
}
