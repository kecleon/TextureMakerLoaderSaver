 
package kabam.rotmg.editor.view.components {
	import com.company.assembleegameclient.ui.dropdown.DropDown;
	import com.company.util.IntPoint;
	
	public class SizeDropDown extends DropDown {
		 
		
		protected var sizes_:Vector.<IntPoint>;
		
		public function SizeDropDown(param1:Vector.<IntPoint>) {
			var loc3:IntPoint = null;
			this.sizes_ = param1;
			var loc2:Vector.<String> = new Vector.<String>();
			for each(loc3 in this.sizes_) {
				loc2.push("" + loc3.x_ + " x " + loc3.y_);
			}
			super(loc2,120,26,"Size");
		}
		
		public function setSize(param1:int, param2:int) : void {
			var loc3:int = 0;
			while(loc3 < this.sizes_.length) {
				if(this.sizes_[loc3].x_ == param1 && this.sizes_[loc3].y_ == param2) {
					setIndex(loc3);
					return;
				}
				loc3++;
			}
		}
		
		public function getSize() : IntPoint {
			return this.sizes_[getIndex()];
		}
	}
}
