 
package com.company.assembleegameclient.util {
	import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
	import com.company.util.AssetLibrary;
	import com.company.util.PointUtil;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class TextureRedrawer {
		
		public static const magic:int = 12;
		
		public static const minSize:int = 2 * magic;
		
		private static const BORDER:int = 4;
		
		public static const OUTLINE_FILTER:GlowFilter = new GlowFilter(0,0.8,1.4,1.4,255,BitmapFilterQuality.LOW,false,false);
		
		private static var cache_:Dictionary = new Dictionary();
		
		private static var faceCache_:Dictionary = new Dictionary();
		
		private static var redrawCaches:Dictionary = new Dictionary();
		
		public static var sharedTexture_:BitmapData = null;
		
		private static var textureShaderEmbed_:Class = TextureRedrawer_textureShaderEmbed_;
		
		private static var textureShaderData_:ByteArray = new textureShaderEmbed_() as ByteArray;
		
		private static var colorTexture1:BitmapData = new BitmapDataSpy(1,1,false);
		
		private static var colorTexture2:BitmapData = new BitmapDataSpy(1,1,false);
		 
		
		public function TextureRedrawer() {
			super();
		}
		
		public static function redraw(param1:BitmapData, param2:int, param3:Boolean, param4:uint, param5:Boolean = true, param6:Number = 5, param7:int = 0) : BitmapData {
			var loc8:String = getHash(param2,param3,param4,param6,param7);
			if(param5 && isCached(param1,loc8)) {
				return redrawCaches[param1][loc8];
			}
			var loc9:BitmapData = resize(param1,null,param2,param3,0,0,param6);
			loc9 = GlowRedrawer.outlineGlow(loc9,param4,1.4,param5,param7);
			if(param5) {
				cache(param1,loc8,loc9);
			}
			return loc9;
		}
		
		private static function getHash(param1:int, param2:Boolean, param3:uint, param4:Number, param5:int) : String {
			return param1.toString() + "," + param3.toString() + "," + param2 + "," + param4 + "," + param5;
		}
		
		private static function cache(param1:BitmapData, param2:String, param3:BitmapData) : void {
			if(!(param1 in redrawCaches)) {
				redrawCaches[param1] = {};
			}
			redrawCaches[param1][param2] = param3;
		}
		
		private static function isCached(param1:BitmapData, param2:String) : Boolean {
			if(param1 in redrawCaches) {
				if(param2 in redrawCaches[param1]) {
					return true;
				}
			}
			return false;
		}
		
		public static function resize(param1:BitmapData, param2:BitmapData, param3:int, param4:Boolean, param5:int, param6:int, param7:Number = 5) : BitmapData {
			if(param2 != null && (param5 != 0 || param6 != 0)) {
				param1 = retexture(param1,param2,param5,param6);
				param3 = param3 / 5;
			}
			var loc8:int = param7 * (param3 / 100) * param1.width;
			var loc9:int = param7 * (param3 / 100) * param1.height;
			var loc10:Matrix = new Matrix();
			loc10.scale(loc8 / param1.width,loc9 / param1.height);
			loc10.translate(magic,magic);
			var loc11:BitmapData = new BitmapDataSpy(loc8 + minSize,loc9 + (!!param4?magic:1) + magic,true,0);
			loc11.draw(param1,loc10);
			return loc11;
		}
		
		public static function redrawSolidSquare(param1:uint, param2:int) : BitmapData {
			var loc3:Dictionary = cache_[param2];
			if(loc3 == null) {
				loc3 = new Dictionary();
				cache_[param2] = loc3;
			}
			var loc4:BitmapData = loc3[param1];
			if(loc4 != null) {
				return loc4;
			}
			loc4 = new BitmapDataSpy(param2 + 4 + 4,param2 + 4 + 4,true,0);
			loc4.fillRect(new Rectangle(4,4,param2,param2),4278190080 | param1);
			loc4.applyFilter(loc4,loc4.rect,PointUtil.ORIGIN,OUTLINE_FILTER);
			loc3[param1] = loc4;
			return loc4;
		}
		
		public static function clearCache() : void {
			var loc1:BitmapData = null;
			var loc2:Dictionary = null;
			var loc3:Dictionary = null;
			for each(loc2 in cache_) {
				for each(loc1 in loc2) {
					loc1.dispose();
				}
			}
			cache_ = new Dictionary();
			for each(loc3 in faceCache_) {
				for each(loc1 in loc3) {
					loc1.dispose();
				}
			}
			faceCache_ = new Dictionary();
		}
		
		public static function redrawFace(param1:BitmapData, param2:Number) : BitmapData {
			if(param2 == 1) {
				return param1;
			}
			var loc3:Dictionary = faceCache_[param2];
			if(loc3 == null) {
				loc3 = new Dictionary();
				faceCache_[param2] = loc3;
			}
			var loc4:BitmapData = loc3[param1];
			if(loc4 != null) {
				return loc4;
			}
			loc4 = param1.clone();
			loc4.colorTransform(loc4.rect,new ColorTransform(param2,param2,param2));
			loc3[param1] = loc4;
			return loc4;
		}
		
		private static function getTexture(param1:int, param2:BitmapData) : BitmapData {
			var loc3:BitmapData = null;
			var loc4:* = param1 >> 24 & 255;
			var loc5:* = param1 & 16777215;
			switch(loc4) {
				case 0:
					loc3 = param2;
					break;
				case 1:
					param2.setPixel(0,0,loc5);
					loc3 = param2;
					break;
				case 4:
					loc3 = AssetLibrary.getImageFromSet("textile4x4",loc5);
					break;
				case 5:
					loc3 = AssetLibrary.getImageFromSet("textile5x5",loc5);
					break;
				case 9:
					loc3 = AssetLibrary.getImageFromSet("textile9x9",loc5);
					break;
				case 10:
					loc3 = AssetLibrary.getImageFromSet("textile10x10",loc5);
					break;
				case 255:
					loc3 = sharedTexture_;
					break;
				default:
					loc3 = param2;
			}
			return loc3;
		}
		
		private static function retexture(param1:BitmapData, param2:BitmapData, param3:int, param4:int) : BitmapData {
			var loc5:Matrix = new Matrix();
			loc5.scale(5,5);
			var loc6:BitmapData = new BitmapDataSpy(param1.width * 5,param1.height * 5,true,0);
			loc6.draw(param1,loc5);
			var loc7:BitmapData = getTexture(param3 >= 0?int(param3):0,colorTexture1);
			var loc8:BitmapData = getTexture(param4 >= 0?int(param4):0,colorTexture2);
			var loc9:Shader = new Shader(textureShaderData_);
			loc9.data.src.input = loc6;
			loc9.data.mask.input = param2;
			loc9.data.texture1.input = loc7;
			loc9.data.texture2.input = loc8;
			loc9.data.texture1Size.value = [param3 == 0?0:loc7.width];
			loc9.data.texture2Size.value = [param4 == 0?0:loc8.width];
			loc6.applyFilter(loc6,loc6.rect,PointUtil.ORIGIN,new ShaderFilter(loc9));
			return loc6;
		}
		
		private static function getDrawMatrix() : Matrix {
			var loc1:Matrix = new Matrix();
			loc1.scale(8,8);
			loc1.translate(BORDER,BORDER);
			return loc1;
		}
	}
}
