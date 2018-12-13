package kabam.rotmg.messaging.impl {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

	import kabam.rotmg.text.model.TextKey;
	import kabam.rotmg.text.view.TextFieldDisplayConcrete;
	import kabam.rotmg.text.view.stringBuilder.LineBuilder;

	public class JitterWatcher extends Sprite {

		private static const lineBuilder:LineBuilder = new LineBuilder();


		private var text_:TextFieldDisplayConcrete = null;

		private var lastRecord_:int = -1;

		private var ticks_:Vector.<int>;

		private var sum_:int;

		public function JitterWatcher() {
			this.ticks_ = new Vector.<int>();
			super();
			this.text_ = new TextFieldDisplayConcrete().setSize(14).setColor(16777215);
			this.text_.setAutoSize(TextFieldAutoSize.LEFT);
			this.text_.filters = [new DropShadowFilter(0, 0, 0)];
			addChild(this.text_);
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
		}

		public function record():void {
			var loc3:int = 0;
			var loc1:int = getTimer();
			if (this.lastRecord_ == -1) {
				this.lastRecord_ = loc1;
				return;
			}
			var loc2:int = loc1 - this.lastRecord_;
			this.ticks_.push(loc2);
			this.sum_ = this.sum_ + loc2;
			if (this.ticks_.length > 50) {
				loc3 = this.ticks_.shift();
				this.sum_ = this.sum_ - loc3;
			}
			this.lastRecord_ = loc1;
		}

		private function onAddedToStage(param1:Event):void {
			stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

		private function onRemovedFromStage(param1:Event):void {
			stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

		private function onEnterFrame(param1:Event):void {
			this.text_.setStringBuilder(lineBuilder.setParams(TextKey.JITTERWATCHER_DESC, {"jitter": this.jitter()}));
		}

		private function jitter():Number {
			var loc4:int = 0;
			var loc1:int = this.ticks_.length;
			if (loc1 == 0) {
				return 0;
			}
			var loc2:Number = this.sum_ / loc1;
			var loc3:Number = 0;
			for each(loc4 in this.ticks_) {
				loc3 = loc3 + (loc4 - loc2) * (loc4 - loc2);
			}
			return Math.sqrt(loc3 / loc1);
		}
	}
}
