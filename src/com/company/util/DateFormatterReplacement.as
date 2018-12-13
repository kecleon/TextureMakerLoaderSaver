package com.company.util {
	public class DateFormatterReplacement {


		public var formatString:String;

		private const months:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

		public function DateFormatterReplacement() {
			super();
		}

		public function format(param1:Date):String {
			var loc2:String = this.formatString;
			loc2 = loc2.replace("D", param1.date);
			loc2 = loc2.replace("YYYY", param1.fullYear);
			loc2 = loc2.replace("MMMM", this.months[param1.month]);
			return loc2;
		}
	}
}
