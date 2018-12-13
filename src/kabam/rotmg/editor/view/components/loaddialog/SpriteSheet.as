 
package kabam.rotmg.editor.view.components.loaddialog {
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	public class SpriteSheet {
		
		private static const WIDTH:int = 128;
		
		private static const HEIGHT:int = 256;
		 
		
		public var bitmapDatas_:Vector.<BitmapData>;
		
		public function SpriteSheet() {
			this.bitmapDatas_ = new Vector.<BitmapData>();
			super();
		}
		
		public function addBitmapData(param1:BitmapData) : void {
			this.bitmapDatas_.push(param1);
		}
		
		public function generatePNG() : ByteArray {
			var loc4:BitmapData = null;
			var loc1:BitmapData = new BitmapDataSpy(WIDTH,HEIGHT,true,0);
			var loc2:Point = new Point(0,0);
			var loc3:int = 0;
			for each(loc4 in this.bitmapDatas_) {
				if(loc2.x + loc4.width > WIDTH) {
					loc2.y = loc2.y + loc3;
					loc2.x = 0;
					loc3 = 0;
				}
				if(loc2.y + loc4.height > HEIGHT) {
					break;
				}
				loc1.copyPixels(loc4,loc4.rect,loc2);
				loc2.x = loc2.x + loc4.width;
				if(loc4.height > loc3) {
					loc3 = loc4.height;
				}
			}
			return PNGEncoder.encode(loc1);
		}
	}
}
