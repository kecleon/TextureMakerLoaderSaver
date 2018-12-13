 
package kabam.lib.ui.impl {
	import flash.display.DisplayObject;
	import kabam.lib.ui.api.Layout;
	
	public class VerticalLayout implements Layout {
		 
		
		private var padding:int = 0;
		
		public function VerticalLayout() {
			super();
		}
		
		public function getPadding() : int {
			return this.padding;
		}
		
		public function setPadding(param1:int) : void {
			this.padding = param1;
		}
		
		public function layout(param1:Vector.<DisplayObject>, param2:int = 0) : void {
			var loc6:DisplayObject = null;
			var loc3:int = param2;
			var loc4:int = param1.length;
			var loc5:int = 0;
			while(loc5 < loc4) {
				loc6 = param1[loc5];
				loc6.y = loc3;
				loc3 = loc3 + (loc6.height + this.padding);
				loc5++;
			}
		}
	}
}
