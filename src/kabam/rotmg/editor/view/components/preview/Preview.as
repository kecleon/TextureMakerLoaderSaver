package kabam.rotmg.editor.view.components.preview {
	import com.company.ui.BaseSimpleText;
	import com.company.util.MoreColorUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	public class Preview extends Sprite {

		private static var zoominiconEmbed_:Class = Preview_zoominiconEmbed_;

		private static var zoomouticonEmbed_:Class = Preview_zoomouticonEmbed_;

		private static const MAX_ZOOM:int = 300;

		private static const MIN_ZOOM:int = 40;

		protected static const GREY_MATRIX:Array = MoreColorUtil.singleColorFilterMatrix(5197647);


		protected var w_:int;

		protected var h_:int;

		protected var size_:int;

		protected var origBitmapData_:BitmapData;

		private var sizeText_:BaseSimpleText;

		private var zoomInIcon_:Sprite;

		private var zoomOutIcon_:Sprite;

		public var bitmap_:Bitmap;

		public function Preview(param1:int, param2:int) {
			super();
			this.w_ = param1;
			this.h_ = param2;
			this.size_ = 100;
			graphics.lineStyle(1, 16777215);
			graphics.beginFill(8355711, 1);
			graphics.drawRect(0, 0, this.w_, this.h_);
			graphics.lineStyle();
			graphics.endFill();
			this.bitmap_ = new Bitmap();
			addChild(this.bitmap_);
			this.sizeText_ = new BaseSimpleText(16, 16777215, false, 0, 0);
			this.sizeText_.setBold(true);
			this.sizeText_.text = this.size_ + "%";
			this.sizeText_.updateMetrics();
			this.sizeText_.x = 2;
			addChild(this.sizeText_);
			this.zoomInIcon_ = this.createIcon(new zoominiconEmbed_(), this.onZoomIn);
			this.zoomInIcon_.x = this.w_ - this.zoomInIcon_.width - 5;
			this.zoomInIcon_.y = 5;
			this.zoomOutIcon_ = this.createIcon(new zoomouticonEmbed_(), this.onZoomOut);
			this.zoomOutIcon_.x = this.zoomInIcon_.x - this.zoomOutIcon_.width - 5;
			this.zoomOutIcon_.y = 5;
		}

		protected function createIcon(param1:Bitmap, param2:Function):Sprite {
			var loc3:Sprite = new Sprite();
			loc3.addChild(param1);
			var loc4:IconCallback = new IconCallback(this, param2);
			loc3.addEventListener(MouseEvent.MOUSE_DOWN, loc4.handler);
			addChild(loc3);
			return loc3;
		}

		public function setBitmapData(param1:BitmapData):void {
			this.origBitmapData_ = param1;
			this.redraw();
			this.position();
		}

		private function onZoomIn():void {
			if (this.size_ == MAX_ZOOM) {
				return;
			}
			this.size_ = this.size_ + 20;
		}

		private function onZoomOut():void {
			if (this.size_ == MIN_ZOOM) {
				return;
			}
			this.size_ = this.size_ - 20;
		}

		public function redraw():void {
			this.sizeText_.text = this.size_ + "%";
			this.sizeText_.updateMetrics();
			this.zoomInIcon_.filters = this.size_ == MAX_ZOOM ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
			this.zoomOutIcon_.filters = this.size_ == MIN_ZOOM ? [new ColorMatrixFilter(GREY_MATRIX)] : [];
		}

		public function position():void {
			this.bitmap_.x = this.w_ / 2 - this.bitmap_.width / 2;
			this.bitmap_.y = this.h_ / 2 - this.bitmap_.height / 2;
		}
	}
}

import flash.events.Event;

import kabam.rotmg.editor.view.components.preview.Preview;

class IconCallback {


	public var preview_:Preview;

	public var callback_:Function;

	function IconCallback(param1:Preview, param2:Function) {
		super();
		this.preview_ = param1;
		this.callback_ = param2;
	}

	public function handler(param1:Event):void {
		this.callback_();
		this.preview_.redraw();
		this.preview_.position();
	}
}
