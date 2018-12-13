 
package mx.formatters {
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class StringFormatter {
		
		mx_internal static const VERSION:String = "4.6.0.23201";
		 
		
		private var extractToken:Function;
		
		private var reqFormat:String;
		
		private var patternInfo:Array;
		
		public function StringFormatter(param1:String, param2:String, param3:Function) {
			super();
			this.formatPattern(param1,param2);
			this.extractToken = param3;
		}
		
		public function formatValue(param1:Object) : String {
			var loc2:Object = this.patternInfo[0];
			var loc3:String = this.reqFormat.substring(0,loc2.begin) + this.extractToken(param1,loc2);
			var loc4:Object = loc2;
			var loc5:int = this.patternInfo.length;
			var loc6:int = 1;
			while(loc6 < loc5) {
				loc2 = this.patternInfo[loc6];
				loc3 = loc3 + (this.reqFormat.substring(loc4.end,loc2.begin) + this.extractToken(param1,loc2));
				loc4 = loc2;
				loc6++;
			}
			if(loc4.end > 0 && loc4.end != this.reqFormat.length) {
				loc3 = loc3 + this.reqFormat.substring(loc4.end);
			}
			return loc3;
		}
		
		private function formatPattern(param1:String, param2:String) : void {
			var loc3:int = 0;
			var loc4:int = 0;
			var loc5:int = 0;
			var loc6:Array = param2.split(",");
			this.reqFormat = param1;
			this.patternInfo = [];
			var loc7:int = loc6.length;
			var loc8:int = 0;
			while(loc8 < loc7) {
				loc3 = this.reqFormat.indexOf(loc6[loc8]);
				if(loc3 >= 0 && loc3 < this.reqFormat.length) {
					loc4 = this.reqFormat.lastIndexOf(loc6[loc8]);
					loc4 = loc4 >= 0?int(loc4 + 1):int(loc3 + 1);
					this.patternInfo.splice(loc5,0,{
						"token":loc6[loc8],
						"begin":loc3,
						"end":loc4
					});
					loc5++;
				}
				loc8++;
			}
			this.patternInfo.sort(this.compareValues);
		}
		
		private function compareValues(param1:Object, param2:Object) : int {
			if(param1.begin > param2.begin) {
				return 1;
			}
			if(param1.begin < param2.begin) {
				return -1;
			}
			return 0;
		}
	}
}
