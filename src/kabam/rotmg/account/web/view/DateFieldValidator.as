 
package kabam.rotmg.account.web.view {
	import kabam.rotmg.account.ui.components.DateField;
	
	public class DateFieldValidator {
		 
		
		public function DateFieldValidator() {
			super();
		}
		
		public static function getPlayerAge(param1:DateField) : uint {
			var loc2:Date = new Date(getBirthDate(param1));
			var loc3:Date = new Date();
			var loc4:uint = Number(loc3.fullYear) - Number(loc2.fullYear);
			if(loc2.month > loc3.month || loc2.month == loc3.month && loc2.date > loc3.date) {
				loc4--;
			}
			return loc4;
		}
		
		public static function getBirthDate(param1:DateField) : Number {
			var loc2:String = param1.months.text + "/" + param1.days.text + "/" + param1.years.text;
			return Date.parse(loc2);
		}
	}
}
