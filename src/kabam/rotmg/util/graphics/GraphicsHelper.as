 
package kabam.rotmg.util.graphics {
	import flash.display.Graphics;
	
	public class GraphicsHelper {
		 
		
		public function GraphicsHelper() {
			super();
		}
		
		public function drawBevelRect(param1:int, param2:int, param3:BevelRect, param4:Graphics) : void {
			var loc5:int = param1 + param3.width;
			var loc6:int = param2 + param3.height;
			var loc7:int = param3.bevel;
			if(param3.topLeftBevel) {
				param4.moveTo(param1,param2 + loc7);
				param4.lineTo(param1 + loc7,param2);
			} else {
				param4.moveTo(param1,param2);
			}
			if(param3.topRightBevel) {
				param4.lineTo(loc5 - loc7,param2);
				param4.lineTo(loc5,param2 + loc7);
			} else {
				param4.lineTo(loc5,param2);
			}
			if(param3.bottomRightBevel) {
				param4.lineTo(loc5,loc6 - loc7);
				param4.lineTo(loc5 - loc7,loc6);
			} else {
				param4.lineTo(loc5,loc6);
			}
			if(param3.bottomLeftBevel) {
				param4.lineTo(param1 + loc7,loc6);
				param4.lineTo(param1,loc6 - loc7);
			} else {
				param4.lineTo(param1,loc6);
			}
		}
	}
}
