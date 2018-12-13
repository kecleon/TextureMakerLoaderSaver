 
package io.decagames.rotmg.ui.texture {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import io.decagames.rotmg.ui.assets.UIAssets;
	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import kabam.lib.json.JsonParser;
	import kabam.rotmg.core.StaticInjectorContext;
	
	public class TextureParser {
		
		private static var _instance:TextureParser;
		 
		
		private var textures:Dictionary;
		
		private var json:JsonParser;
		
		public function TextureParser() {
			super();
			this.textures = new Dictionary();
			this.json = StaticInjectorContext.getInjector().getInstance(JsonParser);
			this.registerTexture(new UIAssets.UI(),new UIAssets.UI_CONFIG(),new UIAssets.UI_SLICE_CONFIG(),"UI");
		}
		
		public static function get instance() : TextureParser {
			if(_instance == null) {
				_instance = new TextureParser();
			}
			return _instance;
		}
		
		public function registerTexture(param1:Bitmap, param2:String, param3:String, param4:String) : void {
			this.textures[param4] = {
				"texture":param1,
				"configuration":this.json.parse(param2),
				"sliceRectangles":this.json.parse(param3)
			};
		}
		
		private function getConfiguration(param1:String, param2:String) : Object {
			if(!this.textures[param1]) {
				throw new Error("Can\'t find set name " + param1);
			}
			if(!this.textures[param1].configuration.frames[param2 + ".png"]) {
				throw new Error("Can\'t find config for " + param2);
			}
			return this.textures[param1].configuration.frames[param2 + ".png"];
		}
		
		private function getBitmapUsingConfig(param1:String, param2:Object) : Bitmap {
			var loc3:Bitmap = this.textures[param1].texture;
			var loc4:ByteArray = loc3.bitmapData.getPixels(new Rectangle(param2.frame.x,param2.frame.y,param2.frame.w,param2.frame.h));
			loc4.position = 0;
			var loc5:BitmapData = new BitmapData(param2.frame.w,param2.frame.h);
			loc5.setPixels(new Rectangle(0,0,param2.frame.w,param2.frame.h),loc4);
			return new Bitmap(loc5);
		}
		
		public function getTexture(param1:String, param2:String) : Bitmap {
			var loc3:Object = this.getConfiguration(param1,param2);
			return this.getBitmapUsingConfig(param1,loc3);
		}
		
		public function getSliceScalingBitmap(param1:String, param2:String, param3:int = 0) : SliceScalingBitmap {
			var loc4:Bitmap = this.getTexture(param1,param2);
			var loc5:Object = this.textures[param1].sliceRectangles.slices[param2 + ".png"];
			var loc6:Rectangle = null;
			var loc7:String = SliceScalingBitmap.SCALE_TYPE_NONE;
			if(loc5) {
				loc6 = new Rectangle(loc5.rectangle.x,loc5.rectangle.y,loc5.rectangle.w,loc5.rectangle.h);
				loc7 = loc5.type;
			}
			var loc8:SliceScalingBitmap = new SliceScalingBitmap(loc4.bitmapData,loc7,loc6);
			loc8.sourceBitmapName = param2;
			if(param3 != 0) {
				loc8.width = param3;
			}
			return loc8;
		}
	}
}
