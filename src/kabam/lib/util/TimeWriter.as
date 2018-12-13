 
package kabam.lib.util {
	public class TimeWriter {
		 
		
		private var timeStringStarted:Boolean = false;
		
		private var seconds:int;
		
		private var minutes:int;
		
		private var hours:int;
		
		private var days:int;
		
		private var textValues:Array;
		
		public function TimeWriter() {
			super();
		}
		
		public function parseTime(param1:Number) : String {
			this.seconds = Math.floor(param1 / 1000);
			this.minutes = Math.floor(this.seconds / 60);
			this.hours = Math.floor(this.minutes / 60);
			this.days = Math.floor(this.hours / 24);
			this.seconds = this.seconds % 60;
			this.minutes = this.minutes % 60;
			this.hours = this.hours % 24;
			this.timeStringStarted = false;
			this.textValues = [];
			this.formatUnit(this.days,"d");
			this.formatUnit(this.hours,"h");
			this.formatUnit(this.minutes,"m",2);
			this.formatUnit(this.seconds,"s",2);
			this.timeStringStarted = false;
			return this.textValues.join(" ");
		}
		
		private function formatUnit(param1:int, param2:String, param3:int = -1) : void {
			if(param1 == 0 && !this.timeStringStarted) {
				return;
			}
			this.timeStringStarted = true;
			var loc4:String = param1.toString();
			if(param3 == -1) {
				param3 = loc4.length;
			}
			var loc5:* = "";
			var loc6:int = loc4.length;
			while(loc6 < param3) {
				loc5 = loc5 + "0";
				loc6++;
			}
			loc4 = loc5 + loc4 + param2;
			this.textValues.push(loc4);
		}
	}
}
