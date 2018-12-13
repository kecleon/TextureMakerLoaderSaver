package kabam.rotmg.editor.view.components.drawer {
	import com.company.color.HSV;
	import com.company.color.RGB;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ObjectDrawer extends PixelDrawer {

		private static var transbackgroundEmbed_:Class = ObjectDrawer_transbackgroundEmbed_;

		private static var transbackgroundBD_:BitmapData = new transbackgroundEmbed_().bitmapData;


		private var w_:int;

		private var h_:int;

		private var pW_:int;

		private var pH_:int;

		private var allowTrans_:Boolean;

		private var pixels_:Vector.<Vector.<Pixel>>;

		private var gridLines_:Shape;

		public function ObjectDrawer(param1:int, param2:int, param3:int, param4:int, param5:Boolean) {
			var loc6:int = 0;
			var loc7:int = 0;
			var loc8:Pixel = null;
			var loc9:int = 0;
			this.pixels_ = new Vector.<Vector.<Pixel>>();
			super();
			this.w_ = param1;
			this.h_ = param2;
			this.pW_ = param3;
			this.pH_ = param4;
			this.allowTrans_ = param5;
			loc9 = Math.min(this.w_ / this.pW_, this.h_ / this.pH_);
			var loc10:int = this.w_ / 2 - loc9 * this.pW_ / 2;
			var loc11:int = this.h_ / 2 - loc9 * this.pH_ / 2;
			this.pixels_.length = this.pW_;
			loc6 = 0;
			while (loc6 < this.pW_) {
				if (this.pixels_[loc6] == null) {
					this.pixels_[loc6] = new Vector.<Pixel>();
				}
				this.pixels_[loc6].length = this.pH_;
				loc7 = 0;
				while (loc7 < this.pH_) {
					loc8 = new Pixel(loc9, this.allowTrans_);
					this.pixels_[loc6][loc7] = loc8;
					loc8.x = loc10 + loc6 * loc9;
					loc8.y = loc11 + loc7 * loc9;
					loc8.addEventListener(MouseEvent.MOUSE_DOWN, this.onPixelMouseDown);
					loc8.addEventListener(MouseEvent.MOUSE_OVER, this.onPixelMouseOver);
					loc8.addEventListener(MouseEvent.MOUSE_OUT, this.onPixelMouseOut);
					addChild(loc8);
					loc7++;
				}
				loc6++;
			}
			graphics.clear();
			graphics.beginBitmapFill(transbackgroundBD_, null);
			graphics.drawRect(loc10, loc11, loc9 * param3, loc9 * param4);
			graphics.endFill();
			this.gridLines_ = new Shape();
			var loc12:Graphics = this.gridLines_.graphics;
			loc12.lineStyle(1, 16777215, 0.5);
			loc6 = 0;
			while (loc6 <= this.pW_) {
				loc12.moveTo(loc10 + loc6 * loc9, loc11);
				loc12.lineTo(loc10 + loc6 * loc9, loc11 + this.pH_ * loc9);
				loc6++;
			}
			loc7 = 0;
			while (loc7 <= this.pH_) {
				loc12.moveTo(loc10, loc11 + loc7 * loc9);
				loc12.lineTo(loc10 + this.pW_ * loc9, loc11 + loc7 * loc9);
				loc7++;
			}
			loc12.lineStyle();
			addChild(this.gridLines_);
		}

		override public function getBitmapData():BitmapData {
			var loc3:int = 0;
			var loc4:Pixel = null;
			var loc1:BitmapData = new BitmapDataSpy(this.pW_, this.pH_, true, 0);
			var loc2:int = 0;
			while (loc2 < this.pixels_.length) {
				loc3 = 0;
				while (loc3 < this.pixels_[loc2].length) {
					loc4 = this.pixels_[loc2][loc3];
					if (loc4.hsv_ != null || !this.allowTrans_) {
						loc1.setPixel32(loc2, loc3, 4278190080 | loc4.getColor());
					}
					loc3++;
				}
				loc2++;
			}
			return loc1;
		}

		override public function loadBitmapData(param1:BitmapData):void {
			var loc3:int = 0;
			var loc4:Pixel = null;
			var loc5:uint = 0;
			var loc6:HSV = null;
			var loc2:int = 0;
			while (loc2 < pW_) {
				loc3 = 0;
				while (loc3 < pH_) {
					loc4 = this.pixels_[loc2][loc3];
					loc5 = param1.getPixel32(loc2, loc3);
					loc6 = null;
					if ((loc5 & 4278190080) != 0) {
						loc6 = RGB.fromColor(loc5 & 16777215).toHSV();
					}
					loc4.setHSV(loc6);
					loc3++;
				}
				loc2++;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function empty():Boolean {
			var loc1:Vector.<Pixel> = null;
			var loc2:Pixel = null;
			for each(loc1 in this.pixels_) {
				for each(loc2 in loc1) {
					if (loc2.hsv_ != null) {
						return false;
					}
				}
			}
			return true;
		}

		override public function clear():void {
			var loc2:Vector.<Pixel> = null;
			var loc3:Pixel = null;
			var loc1:Vector.<PixelColor> = new Vector.<PixelColor>();
			for each(loc2 in this.pixels_) {
				for each(loc3 in loc2) {
					if (loc3.hsv_ != null) {
						loc1.push(new PixelColor(loc3, null));
					}
				}
			}
			dispatchEvent(new SetPixelsEvent(loc1));
		}

		private function onPixelMouseDown(param1:MouseEvent):void {
			var loc2:Pixel = param1.target as Pixel;
			dispatchEvent(new PixelEvent(PixelEvent.UNDO_TEMP_EVENT, loc2));
			dispatchEvent(new PixelEvent(PixelEvent.PIXEL_EVENT, loc2));
		}

		private function onPixelMouseOver(param1:MouseEvent):void {
			var loc2:Pixel = param1.target as Pixel;
			if (param1.buttonDown) {
				dispatchEvent(new PixelEvent(PixelEvent.PIXEL_EVENT, loc2));
			} else {
				dispatchEvent(new PixelEvent(PixelEvent.TEMP_PIXEL_EVENT, loc2));
			}
		}

		private function onPixelMouseOut(param1:MouseEvent):void {
			var loc2:Pixel = param1.target as Pixel;
			dispatchEvent(new PixelEvent(PixelEvent.UNDO_TEMP_EVENT, loc2));
		}
	}
}
