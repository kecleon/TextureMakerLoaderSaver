 
package kabam.rotmg.editor.view.components.drawer {
	import com.company.color.HSV;
	import com.company.util.MoreColorUtil;
	import flash.display.Sprite;
	
	public class Pixel extends Sprite {
		 
		
		public var size_:int;
		
		public var hsv_:HSV = null;
		
		private var allowTrans_:Boolean;
		
		public function Pixel(param1:int, param2:Boolean) {
			super();
			this.size_ = param1;
			this.allowTrans_ = param2;
			this.redraw();
		}
		
		public function setHSV(param1:HSV) : void {
			this.hsv_ = param1 != null?this.hsv_ = param1.clone():null;
			this.redraw();
		}
		
		public function getColor() : uint {
			return this.hsv_ == null?uint(0):uint(MoreColorUtil.hsvToRgb(this.hsv_.h_,this.hsv_.s_,this.hsv_.v_));
		}
		
		public function redraw() : void {
			graphics.clear();
			if(this.hsv_ == null) {
				graphics.beginFill(0,!!this.allowTrans_?Number(0):Number(1));
			} else {
				graphics.beginFill(MoreColorUtil.hsvToRgb(this.hsv_.h_,this.hsv_.s_,this.hsv_.v_));
			}
			graphics.drawRect(0,0,this.size_,this.size_);
			graphics.endFill();
		}
	}
}
