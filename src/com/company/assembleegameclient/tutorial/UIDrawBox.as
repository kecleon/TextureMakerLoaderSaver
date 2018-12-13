package com.company.assembleegameclient.tutorial {
	import com.company.util.ConversionUtil;

	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class UIDrawBox {


		public var rect_:Rectangle;

		public var color_:uint;

		public const ANIMATION_MS:int = 500;

		public const ORIGIN:Point = new Point(250, 200);

		public function UIDrawBox(param1:XML) {
			super();
			this.rect_ = ConversionUtil.toRectangle(param1);
			this.color_ = uint(param1.@color);
		}

		public function draw(param1:int, param2:Graphics, param3:int):void {
			var loc4:Number = NaN;
			var loc5:Number = NaN;
			var loc6:Number = this.rect_.width - param1;
			var loc7:Number = this.rect_.height - param1;
			if (param3 < this.ANIMATION_MS) {
				loc4 = this.ORIGIN.x + (this.rect_.x - this.ORIGIN.x) * param3 / this.ANIMATION_MS;
				loc5 = this.ORIGIN.y + (this.rect_.y - this.ORIGIN.y) * param3 / this.ANIMATION_MS;
				loc6 = loc6 * (param3 / this.ANIMATION_MS);
				loc7 = loc7 * (param3 / this.ANIMATION_MS);
			} else {
				loc4 = this.rect_.x + param1 / 2;
				loc5 = this.rect_.y + param1 / 2;
			}
			param2.lineStyle(param1, this.color_);
			param2.drawRect(loc4, loc5, loc6, loc7);
		}
	}
}
