package io.decagames.rotmg.social.widgets {
	import flash.display.Sprite;

	import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
	import io.decagames.rotmg.ui.texture.TextureParser;

	public class BaseInfoItem extends Sprite {


		protected var _width:int;

		protected var _height:int;

		public function BaseInfoItem(param1:int, param2:int) {
			super();
			this._width = param1;
			this._height = param2;
			this.intit();
		}

		private function intit():void {
			this.createBackground();
		}

		private function createBackground():void {
			var loc1:SliceScalingBitmap = TextureParser.instance.getSliceScalingBitmap("UI", "listitem_content_background");
			loc1.height = this._height;
			loc1.width = this._width;
			addChild(loc1);
		}
	}
}
