package kabam.rotmg.editor.view.components {
	import com.company.color.HSV;
	import com.company.util.MoreColorUtil;

	import flash.display.Sprite;

	public class PaletteBox extends Sprite {


		public var size_:int;

		public var hsv_:HSV;

		public var readOnly_:Boolean = false;

		public function PaletteBox(param1:int, param2:HSV, param3:Boolean) {
			super();
			this.size_ = param1;
			this.hsv_ = new HSV();
			this.setColor(param2);
			this.readOnly_ = param3;
		}

		public function setColor(param1:HSV):void {
			if (this.readOnly_) {
				return;
			}
			this.hsv_.h_ = param1.h_;
			this.hsv_.s_ = param1.s_;
			this.hsv_.v_ = param1.v_;
			var loc2:uint = MoreColorUtil.hsvToRgb(this.hsv_.h_, this.hsv_.s_, this.hsv_.v_);
			graphics.beginFill(loc2);
			graphics.drawRect(0, 0, this.size_, this.size_);
			graphics.endFill();
		}
	}
}
