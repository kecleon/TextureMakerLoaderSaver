package kabam.rotmg.arena.view {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;

	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	public class ArenaTimer extends Sprite {


		private const timerText:StaticTextDisplay = this.makeTimerText();

		private const timerStringBuilder:StaticStringBuilder = new StaticStringBuilder();

		private var secs:Number = 0;

		private const timer:Timer = new Timer(1000);

		public function ArenaTimer() {
			super();
		}

		public function start():void {
			this.updateTimer(null);
			this.timer.addEventListener(TimerEvent.TIMER, this.updateTimer);
			this.timer.start();
		}

		public function stop():void {
			this.timer.removeEventListener(TimerEvent.TIMER, this.updateTimer);
			this.timer.stop();
		}

		private function updateTimer(param1:TimerEvent):void {
			var loc2:int = this.secs / 60;
			var loc3:int = this.secs % 60;
			var loc4:String = loc2 < 10 ? "0" : "";
			loc4 = loc4 + (loc2 + ":");
			loc4 = loc4 + (loc3 < 10 ? "0" : "");
			loc4 = loc4 + loc3;
			this.timerText.setStringBuilder(this.timerStringBuilder.setString(loc4));
			this.secs++;
		}

		private function makeTimerText():StaticTextDisplay {
			var loc1:StaticTextDisplay = new StaticTextDisplay();
			loc1.setSize(24).setBold(true).setColor(16777215);
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
			addChild(loc1);
			return loc1;
		}
	}
}
