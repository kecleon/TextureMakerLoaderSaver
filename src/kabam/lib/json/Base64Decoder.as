package kabam.lib.json {
	import com.hurlant.util.Base64;

	public class Base64Decoder {


		public function Base64Decoder() {
			super();
		}

		public function decode(param1:String):String {
			var loc2:RegExp = /-/g;
			var loc3:RegExp = /_/g;
			var loc4:int = 4 - param1.length % 4;
			while (loc4--) {
				param1 = param1 + "=";
			}
			param1 = param1.replace(loc2, "+").replace(loc3, "/");
			return Base64.decode(param1);
		}
	}
}
