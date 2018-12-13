 
package io.decagames.rotmg.utils.date {
	public class TimeLeft {
		 
		
		public function TimeLeft() {
			super();
		}
		
		public static function parse(param1:int, param2:String) : String {
			var loc3:int = 0;
			var loc4:int = 0;
			var loc5:int = 0;
			if(param2.indexOf("%d") >= 0) {
				loc3 = Math.floor(param1 / 86400);
				param1 = param1 - loc3 * 86400;
				param2 = param2.replace("%d",loc3);
			}
			if(param2.indexOf("%h") >= 0) {
				loc4 = Math.floor(param1 / 3600);
				param1 = param1 - loc4 * 3600;
				param2 = param2.replace("%h",loc4);
			}
			if(param2.indexOf("%m") >= 0) {
				loc5 = Math.floor(param1 / 60);
				param1 = param1 - loc5 * 60;
				param2 = param2.replace("%m",loc5);
			}
			param2 = param2.replace("%s",param1);
			return param2;
		}
	}
}
