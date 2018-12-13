package kabam.rotmg.dailyLogin.model {
	public class DailyLoginModel {

		public static const DAY_IN_MILLISECONDS:Number = 24 * 60 * 60 * 1000;


		public var shouldDisplayCalendarAtStartup:Boolean;

		public var currentDisplayedCaledar:String;

		private var serverTimestamp:Number;

		private var serverMeasureTime:Number;

		private var daysConfig:Object;

		private var userDayConfig:Object;

		private var currentDayConfig:Object;

		private var maxDayConfig:Object;

		private var _initialized:Boolean;

		private var _currentDay:int = -1;

		private var sortAsc:Function;

		public function DailyLoginModel() {
			this.daysConfig = {};
			this.userDayConfig = {};
			this.currentDayConfig = {};
			this.maxDayConfig = {};
			this.sortAsc = function (param1:CalendarDayModel, param2:CalendarDayModel):Number {
				if (param1.dayNumber < param2.dayNumber) {
					return -1;
				}
				if (param1.dayNumber > param2.dayNumber) {
					return 1;
				}
				return 0;
			};
			super();
			this.clear();
		}

		public function setServerTime(param1:Number):void {
			this.serverTimestamp = param1;
			this.serverMeasureTime = new Date().getTime();
		}

		public function hasCalendar(param1:String):Boolean {
			return this.daysConfig[param1].length > 0;
		}

		public function getServerUTCTime():Date {
			var loc1:Date = new Date();
			loc1.setUTCMilliseconds(this.serverTimestamp);
			return loc1;
		}

		public function getServerTime():Date {
			var loc1:Date = new Date();
			loc1.setTime(this.serverTimestamp + (loc1.getTime() - this.serverMeasureTime));
			return loc1;
		}

		public function getTimestampDay():int {
			return Math.floor(this.getServerTime().getTime() / DailyLoginModel.DAY_IN_MILLISECONDS);
		}

		private function getDayCount(param1:int, param2:int):int {
			var loc3:Date = new Date(param1, param2, 0);
			return loc3.getDate();
		}

		public function get daysLeftToCalendarEnd():int {
			var loc1:Date = this.getServerTime();
			var loc2:int = loc1.getDate();
			var loc3:int = this.getDayCount(loc1.fullYear, loc1.month + 1);
			return loc3 - loc2;
		}

		public function addDay(param1:CalendarDayModel, param2:String):void {
			this._initialized = true;
			this.daysConfig[param2].push(param1);
		}

		public function setUserDay(param1:int, param2:String):void {
			this.userDayConfig[param2] = param1;
		}

		public function calculateCalendar(param1:String):void {
			var loc6:CalendarDayModel = null;
			var loc2:Vector.<CalendarDayModel> = this.sortCalendar(this.daysConfig[param1]);
			var loc3:int = loc2.length;
			this.daysConfig[param1] = loc2;
			this.maxDayConfig[param1] = loc2[loc3 - 1].dayNumber;
			var loc4:Vector.<CalendarDayModel> = new Vector.<CalendarDayModel>();
			var loc5:int = 1;
			while (loc5 <= this.maxDayConfig[param1]) {
				loc6 = this.getDayByNumber(param1, loc5);
				if (loc5 == this.userDayConfig[param1]) {
					loc6.isCurrent = true;
				}
				loc4.push(loc6);
				loc5++;
			}
			this.daysConfig[param1] = loc4;
		}

		private function getDayByNumber(param1:String, param2:int):CalendarDayModel {
			var loc3:CalendarDayModel = null;
			for each(loc3 in this.daysConfig[param1]) {
				if (loc3.dayNumber == param2) {
					return loc3;
				}
			}
			return new CalendarDayModel(param2, -1, 0, 0, false, param1);
		}

		public function getDaysConfig(param1:String):Vector.<CalendarDayModel> {
			return this.daysConfig[param1];
		}

		public function getMaxDays(param1:String):int {
			return this.maxDayConfig[param1];
		}

		public function get overallMaxDays():int {
			var loc2:int = 0;
			var loc1:int = 0;
			for each(loc2 in this.maxDayConfig) {
				if (loc2 > loc1) {
					loc1 = loc2;
				}
			}
			return loc1;
		}

		public function markAsClaimed(param1:int, param2:String):void {
			this.daysConfig[param2][param1 - 1].isClaimed = true;
		}

		private function sortCalendar(param1:Vector.<CalendarDayModel>):Vector.<CalendarDayModel> {
			return param1.sort(this.sortAsc);
		}

		public function get initialized():Boolean {
			return this._initialized;
		}

		public function clear():void {
			this.daysConfig[CalendarTypes.CONSECUTIVE] = new Vector.<CalendarDayModel>();
			this.daysConfig[CalendarTypes.NON_CONSECUTIVE] = new Vector.<CalendarDayModel>();
			this.daysConfig[CalendarTypes.UNLOCK] = new Vector.<CalendarDayModel>();
			this.shouldDisplayCalendarAtStartup = false;
		}

		public function getCurrentDay(param1:String):int {
			return this.currentDayConfig[param1];
		}

		public function setCurrentDay(param1:String, param2:int):void {
			this.currentDayConfig[param1] = param2;
		}
	}
}
