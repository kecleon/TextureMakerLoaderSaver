package com.company.assembleegameclient.ui.tooltip {
	import com.company.assembleegameclient.objects.GameObject;
	import com.company.util.BitmapUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class PortraitToolTip extends ToolTip {


		private var portrait_:Bitmap;

		public function PortraitToolTip(param1:GameObject) {
			super(6036765, 1, 16549442, 1, false);
			this.portrait_ = new Bitmap();
			this.portrait_.x = 0;
			this.portrait_.y = 0;
			var loc2:BitmapData = param1.getPortrait();
			loc2 = BitmapUtil.cropToBitmapData(loc2, 10, 10, loc2.width - 20, loc2.height - 20);
			this.portrait_.bitmapData = loc2;
			addChild(this.portrait_);
			filters = [];
		}
	}
}
