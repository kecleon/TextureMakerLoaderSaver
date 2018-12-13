 
package kabam.rotmg.packages.view {
	import com.company.assembleegameclient.util.TextureRedrawer;
	import com.company.util.AssetLibrary;
	import com.company.util.BitmapUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	
	public class BasePackageButton extends Sprite {
		
		public static const IMAGE_NAME:String = "redLootBag";
		
		public static const IMAGE_ID:int = 0;
		 
		
		public function BasePackageButton() {
			super();
		}
		
		protected static function makeIcon() : DisplayObject {
			var loc1:BitmapData = AssetLibrary.getImageFromSet(IMAGE_NAME,IMAGE_ID);
			loc1 = TextureRedrawer.redraw(loc1,40,true,0);
			loc1 = BitmapUtil.cropToBitmapData(loc1,10,10,loc1.width - 20,loc1.height - 20);
			var loc2:DisplayObject = new Bitmap(loc1);
			loc2.x = 3;
			loc2.y = 3;
			return loc2;
		}
		
		protected function positionText(param1:DisplayObject, param2:TextFieldDisplayConcrete) : void {
			var loc4:Number = NaN;
			var loc3:Rectangle = param1.getBounds(this);
			loc4 = loc3.top + loc3.height / 2;
			param2.x = loc3.right;
			param2.y = loc4 - param2.height / 2;
		}
	}
}
