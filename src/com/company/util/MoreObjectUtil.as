package com.company.util {
	public class MoreObjectUtil {


		public function MoreObjectUtil() {
			super();
		}

		public static function addToObject(param1:Object, param2:Object):void {
			var loc3:* = null;
			for (loc3 in param2) {
				param1[loc3] = param2[loc3];
			}
		}
	}
}
