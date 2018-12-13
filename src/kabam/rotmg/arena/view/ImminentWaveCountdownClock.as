package kabam.rotmg.arena.view {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.StaticTextDisplay;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;
	import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

	import org.osflash.signals.Signal;

	public class ImminentWaveCountdownClock extends Sprite {


		private var WaveAsset:Class;

		public const close:Signal = new Signal();

		private const countDownContainer:Sprite = new Sprite();

		private var count:int = 5;

		private const nextWaveText:StaticTextDisplay = this.makeNextWaveText();

		private const countdownStringBuilder:StaticStringBuilder = new StaticStringBuilder();

		private const countdownText:StaticTextDisplay = this.makeCountdownText();

		private const waveTimer:Timer = new Timer(1000);

		private const waveStartContainer:Sprite = new Sprite();

		private var waveNumber:int = -1;

		private const waveAsset = this.makeWaveAsset();

		private const waveText:StaticTextDisplay = this.makeWaveText();

		private const waveNumberText:StaticTextDisplay = this.makeWaveNumberText();

		private const startText:StaticTextDisplay = this.makeStartText();

		private const waveStartTimer:Timer = new Timer(1500, 1);

		public function ImminentWaveCountdownClock() {
			this.WaveAsset = ImminentWaveCountdownClock_WaveAsset;
			super();
		}

		public function init():void {
			mouseChildren = false;
			mouseEnabled = false;
			this.waveTimer.addEventListener(TimerEvent.TIMER, this.updateCountdownClock);
			this.waveTimer.start();
		}

		public function destroy():void {
			this.waveTimer.stop();
			this.waveTimer.removeEventListener(TimerEvent.TIMER, this.updateCountdownClock);
			this.waveStartTimer.stop();
			this.waveStartTimer.removeEventListener(TimerEvent.TIMER, this.cleanup);
		}

		public function show():void {
			addChild(this.countDownContainer);
			this.center();
		}

		public function setWaveNumber(param1:int):void {
			this.waveNumber = param1;
			this.waveNumberText.setStringBuilder(new StaticStringBuilder(this.waveNumber.toString()));
			this.waveNumberText.x = this.waveAsset.width / 2 - this.waveNumberText.width / 2;
		}

		private function center():void {
			x = 300 - width / 2;
			y = !!contains(this.countDownContainer) ? Number(138) : Number(87.5);
		}

		private function updateCountdownClock(param1:TimerEvent):void {
			if (this.count > 1) {
				this.count--;
				this.countdownText.setStringBuilder(this.countdownStringBuilder.setString(this.count.toString()));
				this.countdownText.x = this.nextWaveText.width / 2 - this.countdownText.width / 2;
			} else {
				removeChild(this.countDownContainer);
				addChild(this.waveStartContainer);
				this.waveTimer.removeEventListener(TimerEvent.TIMER, this.updateCountdownClock);
				this.waveStartTimer.addEventListener(TimerEvent.TIMER, this.cleanup);
				this.waveStartTimer.start();
				this.center();
			}
		}

		private function cleanup(param1:TimerEvent):void {
			this.waveStartTimer.removeEventListener(TimerEvent.TIMER, this.cleanup);
			this.close.dispatch();
		}

		private function makeNextWaveText():StaticTextDisplay {
			var loc1:StaticTextDisplay = new StaticTextDisplay();
			loc1.setSize(20).setBold(true).setColor(13421772);
			loc1.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_COUNTDOWN_CLOCK_NEXT_WAVE));
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
			this.countDownContainer.addChild(loc1);
			return loc1;
		}

		private function makeCountdownText():StaticTextDisplay {
			var loc1:StaticTextDisplay = null;
			loc1 = new StaticTextDisplay();
			loc1.setSize(42).setBold(true).setColor(13421772);
			loc1.setStringBuilder(this.countdownStringBuilder.setString(this.count.toString()));
			loc1.y = this.nextWaveText.height;
			loc1.x = this.nextWaveText.width / 2 - loc1.width / 2;
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
			this.countDownContainer.addChild(loc1);
			return loc1;
		}

		private function makeWaveText():StaticTextDisplay {
			var loc1:StaticTextDisplay = null;
			loc1 = new StaticTextDisplay();
			loc1.setSize(18).setBold(true).setColor(16567065);
			loc1.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_COUNTDOWN_CLOCK_WAVE));
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
			loc1.x = this.waveAsset.width / 2 - loc1.width / 2;
			loc1.y = this.waveAsset.height / 2 - loc1.height / 2 - 15;
			this.waveStartContainer.addChild(loc1);
			return loc1;
		}

		private function makeWaveNumberText():StaticTextDisplay {
			var loc1:StaticTextDisplay = new StaticTextDisplay();
			loc1.setSize(40).setBold(true).setColor(16567065);
			loc1.y = this.waveText.y + this.waveText.height - 5;
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
			this.waveStartContainer.addChild(loc1);
			return loc1;
		}

		private function makeWaveAsset():* {
			var loc1:* = new this.WaveAsset();
			this.waveStartContainer.addChild(loc1);
			return loc1;
		}

		private function makeStartText():StaticTextDisplay {
			var loc1:StaticTextDisplay = new StaticTextDisplay();
			loc1.setSize(32).setBold(true).setColor(11776947);
			loc1.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_COUNTDOWN_CLOCK_START));
			loc1.y = this.waveAsset.y + this.waveAsset.height - 5;
			loc1.x = this.waveAsset.width / 2 - loc1.width / 2;
			loc1.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
			this.waveStartContainer.addChild(loc1);
			return loc1;
		}
	}
}
