 
package kabam.lib.util {
	public class VectorAS3Util {
		 
		
		public function VectorAS3Util() {
			super();
		}
		
		public static function toArray(param1:Object) : Array {
			var loc3:Object = null;
			var loc2:Array = [];
			for each(loc3 in param1) {
				loc2.push(loc3);
			}
			return loc2;
		}
	}
}
