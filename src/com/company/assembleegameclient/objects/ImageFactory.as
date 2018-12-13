 
package com.company.assembleegameclient.objects {
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;
	import flash.display.BitmapData;
	
	public class ImageFactory {
		 
		
		public function ImageFactory() {
			super();
		}
		
		public function getImageFromSet(param1:String, param2:int) : BitmapData {
			return AssetLibrary.getImageFromSet(param1,param2);
		}
		
		public function getTexture(param1:int, param2:int) : BitmapData {
			var loc4:Number = NaN;
			var loc5:BitmapData = null;
			var loc3:BitmapData = ObjectLibrary.getBitmapData(param1);
			if(loc3) {
				loc4 = (param2 - TextureRedrawer.minSize) / loc3.width;
				loc5 = ObjectLibrary.getRedrawnTextureFromType(param1,100,true,false,loc4);
				return loc5;
			}
			return new BitmapDataSpy(param2,param2);
		}
	}
}
