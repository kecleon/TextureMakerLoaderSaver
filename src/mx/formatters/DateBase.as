package mx.formatters {
	import flash.events.Event;

	import mx.core.mx_internal;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	use namespace mx_internal;

	public class DateBase {

		mx_internal static const VERSION:String = "4.6.0.23201";

		private static var initialized:Boolean = false;

		private static var _resourceManager:IResourceManager;

		private static var _dayNamesLong:Array;

		private static var dayNamesLongOverride:Array;

		private static var _dayNamesShort:Array;

		private static var dayNamesShortOverride:Array;

		private static var _monthNamesLong:Array;

		private static var monthNamesLongOverride:Array;

		private static var _monthNamesShort:Array;

		private static var monthNamesShortOverride:Array;

		private static var _timeOfDay:Array;

		private static var timeOfDayOverride:Array;


		public function DateBase() {
			super();
		}

		private static function get resourceManager():IResourceManager {
			if (!_resourceManager) {
				_resourceManager = ResourceManager.getInstance();
			}
			return _resourceManager;
		}

		public static function get dayNamesLong():Array {
			initialize();
			return _dayNamesLong;
		}

		public static function set dayNamesLong(param1:Array):void {
			dayNamesLongOverride = param1;
			_dayNamesLong = param1 != null ? param1 : resourceManager.getStringArray("SharedResources", "dayNames");
		}

		public static function get dayNamesShort():Array {
			initialize();
			return _dayNamesShort;
		}

		public static function set dayNamesShort(param1:Array):void {
			dayNamesShortOverride = param1;
			_dayNamesShort = param1 != null ? param1 : resourceManager.getStringArray("formatters", "dayNamesShort");
		}

		mx_internal static function get defaultStringKey():Array {
			initialize();
			return monthNamesLong.concat(timeOfDay);
		}

		public static function get monthNamesLong():Array {
			initialize();
			return _monthNamesLong;
		}

		public static function set monthNamesLong(param1:Array):void {
			var loc2:String = null;
			var loc3:int = 0;
			var loc4:int = 0;
			monthNamesLongOverride = param1;
			_monthNamesLong = param1 != null ? param1 : resourceManager.getStringArray("SharedResources", "monthNames");
			if (param1 == null) {
				loc2 = resourceManager.getString("SharedResources", "monthSymbol");
				if (loc2 != " ") {
					loc3 = !!_monthNamesLong ? int(_monthNamesLong.length) : 0;
					loc4 = 0;
					while (loc4 < loc3) {
						_monthNamesLong[loc4] = _monthNamesLong[loc4] + loc2;
						loc4++;
					}
				}
			}
		}

		public static function get monthNamesShort():Array {
			initialize();
			return _monthNamesShort;
		}

		public static function set monthNamesShort(param1:Array):void {
			var loc2:String = null;
			var loc3:int = 0;
			var loc4:int = 0;
			monthNamesShortOverride = param1;
			_monthNamesShort = param1 != null ? param1 : resourceManager.getStringArray("formatters", "monthNamesShort");
			if (param1 == null) {
				loc2 = resourceManager.getString("SharedResources", "monthSymbol");
				if (loc2 != " ") {
					loc3 = !!_monthNamesShort ? int(_monthNamesShort.length) : 0;
					loc4 = 0;
					while (loc4 < loc3) {
						_monthNamesShort[loc4] = _monthNamesShort[loc4] + loc2;
						loc4++;
					}
				}
			}
		}

		public static function get timeOfDay():Array {
			initialize();
			return _timeOfDay;
		}

		public static function set timeOfDay(param1:Array):void {
			timeOfDayOverride = param1;
			var loc2:String = resourceManager.getString("formatters", "am");
			var loc3:String = resourceManager.getString("formatters", "pm");
			_timeOfDay = param1 != null ? param1 : [loc2, loc3];
		}

		private static function initialize():void {
			if (!initialized) {
				resourceManager.addEventListener(Event.CHANGE, static_resourceManager_changeHandler, false, 0, true);
				static_resourcesChanged();
				initialized = true;
			}
		}

		private static function static_resourcesChanged():void {
			dayNamesLong = dayNamesLongOverride;
			dayNamesShort = dayNamesShortOverride;
			monthNamesLong = monthNamesLongOverride;
			monthNamesShort = monthNamesShortOverride;
			timeOfDay = timeOfDayOverride;
		}

		mx_internal static function extractTokenDate(param1:Date, param2:Object):String {
			var loc5:int = 0;
			var loc6:int = 0;
			var loc7:String = null;
			var loc8:int = 0;
			var loc9:int = 0;
			var loc10:int = 0;
			var loc11:int = 0;
			initialize();
			var loc3:String = "";
			var loc4:int = int(param2.end) - int(param2.begin);
			switch (param2.token) {
				case "Y":
					loc7 = param1.getFullYear().toString();
					if (loc4 < 3) {
						return loc7.substr(2);
					}
					if (loc4 > 4) {
						return setValue(Number(loc7), loc4);
					}
					return loc7;
				case "M":
					loc8 = int(param1.getMonth());
					if (loc4 < 3) {
						loc8++;
						loc3 = loc3 + setValue(loc8, loc4);
						return loc3;
					}
					if (loc4 == 3) {
						return monthNamesShort[loc8];
					}
					return monthNamesLong[loc8];
				case "D":
					loc5 = int(param1.getDate());
					loc3 = loc3 + setValue(loc5, loc4);
					return loc3;
				case "E":
					loc5 = int(param1.getDay());
					if (loc4 < 3) {
						loc3 = loc3 + setValue(loc5, loc4);
						return loc3;
					}
					if (loc4 == 3) {
						return dayNamesShort[loc5];
					}
					return dayNamesLong[loc5];
				case "A":
					loc6 = int(param1.getHours());
					if (loc6 < 12) {
						return timeOfDay[0];
					}
					return timeOfDay[1];
				case "H":
					loc6 = int(param1.getHours());
					if (loc6 == 0) {
						loc6 = 24;
					}
					loc3 = loc3 + setValue(loc6, loc4);
					return loc3;
				case "J":
					loc6 = int(param1.getHours());
					loc3 = loc3 + setValue(loc6, loc4);
					return loc3;
				case "K":
					loc6 = int(param1.getHours());
					if (loc6 >= 12) {
						loc6 = loc6 - 12;
					}
					loc3 = loc3 + setValue(loc6, loc4);
					return loc3;
				case "L":
					loc6 = int(param1.getHours());
					if (loc6 == 0) {
						loc6 = 12;
					} else if (loc6 > 12) {
						loc6 = loc6 - 12;
					}
					loc3 = loc3 + setValue(loc6, loc4);
					return loc3;
				case "N":
					loc9 = int(param1.getMinutes());
					loc3 = loc3 + setValue(loc9, loc4);
					return loc3;
				case "S":
					loc10 = int(param1.getSeconds());
					loc3 = loc3 + setValue(loc10, loc4);
					return loc3;
				case "Q":
					loc11 = int(param1.getMilliseconds());
					loc3 = loc3 + setValue(loc11, loc4);
					return loc3;
				default:
					return loc3;
			}
		}

		private static function setValue(param1:Object, param2:int):String {
			var loc5:int = 0;
			var loc6:int = 0;
			var loc3:* = "";
			var loc4:int = param1.toString().length;
			if (loc4 < param2) {
				loc5 = param2 - loc4;
				loc6 = 0;
				while (loc6 < loc5) {
					loc3 = loc3 + "0";
					loc6++;
				}
			}
			loc3 = loc3 + param1.toString();
			return loc3;
		}

		private static function static_resourceManager_changeHandler(param1:Event):void {
			static_resourcesChanged();
		}
	}
}
