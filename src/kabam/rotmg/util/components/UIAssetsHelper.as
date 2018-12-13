 
package kabam.rotmg.util.components {
	import com.company.util.AssetLibrary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class UIAssetsHelper {
		
		public static const LEFT_NEVIGATOR:String = "left";
		
		public static const RIGHT_NEVIGATOR:String = "right";
		 
		
		public function UIAssetsHelper() {
			super();
		}
		
		public static function createLeftNevigatorIcon(param1:String = "left", param2:int = 4, param3:Number = 0) : Sprite {
			var loc4:BitmapData = null;
			if(param1 == LEFT_NEVIGATOR) {
				loc4 = AssetLibrary.getImageFromSet("lofiInterface",55);
			} else {
				loc4 = AssetLibrary.getImageFromSet("lofiInterface",54);
			}
			var loc5:Bitmap = new Bitmap(loc4);
			loc5.scaleX = param2;
			loc5.scaleY = param2;
			loc5.rotation = param3;
			var loc6:Sprite = new Sprite();
			loc6.addChild(loc5);
			return loc6;
		}
	}
}
