package kabam.rotmg.arena.component {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class LeaderboardWeeklyResetTimer extends Sprite {


		private const MONDAY:Number = 1;

		private const UTC_COUNTOFF_HOUR:Number = 7;

		private var differenceMilliseconds:Number;

		private var updateTimer:Timer;

		private var resetClock:StaticTextDisplay;

		private var resetClockStringBuilder:LineBuilder;

		public function LeaderboardWeeklyResetTimer() {
			this.differenceMilliseconds = this.makeDifferenceMilliseconds();
			this.resetClock = this.makeResetClockDisplay();
			this.resetClockStringBuilder = new LineBuilder();
			super();
			addChild(this.resetClock);
			this.resetClock.setStringBuilder(this.resetClockStringBuilder.setParams(TextKey.ARENA_WEEKLY_RESET_LABEL, {"time": this.getDateString()}));
			this.updateTimer = new Timer(1000);
			this.updateTimer.addEventListener(TimerEvent.TIMER, this.onUpdateTime);
			this.updateTimer.start();
		}

		private function onUpdateTime(param1:TimerEvent):void {
			this.differenceMilliseconds = this.differenceMilliseconds - 1000;
			this.resetClock.setStringBuilder(this.resetClockStringBuilder.setParams(TextKey.ARENA_WEEKLY_RESET_LABEL, {"time": this.getDateString()}));
		}

		private function getDateString():String {
			var loc1:int = this.differenceMilliseconds;
			var loc2:int = Math.floor(loc1 / 86400000);
			loc1 = loc1 % 86400000;
			var loc3:int = Math.floor(loc1 / 3600000);
			loc1 = loc1 % 3600000;
			var loc4:int = Math.floor(loc1 / 60000);
			loc1 = loc1 % 60000;
			var loc5:int = Math.floor(loc1 / 1000);
			var loc6:* = "";
			if (loc2 > 0) {
				loc6 = loc2 + " days, " + loc3 + " hours, " + loc4 + " minutes";
			} else {
				loc6 = loc3 + " hours, " + loc4 + " minutes, " + loc5 + " seconds";
			}
			return loc6;
		}

		private function makeDifferenceMilliseconds():Number {
			var loc1:Date = new Date();
			var loc2:Date = this.makeResetDate();
			return loc2.getTime() - loc1.getTime();
		}

		private function makeResetDate():Date {
			var loc1:Date = new Date();
			if (loc1.dayUTC == this.MONDAY && loc1.hoursUTC < this.UTC_COUNTOFF_HOUR) {
				loc1.setUTCHours(this.UTC_COUNTOFF_HOUR - loc1.hoursUTC);
				return loc1;
			}
			loc1.setUTCHours(7);
			loc1.setUTCMinutes(0);
			loc1.setUTCSeconds(0);
			loc1.setUTCMilliseconds(0);
			loc1.setUTCDate(loc1.dateUTC + 1);
			while (loc1.dayUTC != this.MONDAY) {
				loc1.setUTCDate(loc1.dateUTC + 1);
			}
			return loc1;
		}

		private function makeResetClockDisplay():StaticTextDisplay {
			var loc1:StaticTextDisplay = new StaticTextDisplay();
			loc1.setSize(14).setColor(16567065).setBold(true);
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			return loc1;
		}
	}
}
