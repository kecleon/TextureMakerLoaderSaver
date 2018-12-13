 
package kabam.rotmg.news.view {
	import com.company.assembleegameclient.game.events.DisplayAreaChangedSignal;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.text.model.FontModel;
	
	public class NewsTicker extends Sprite {
		
		private static var pendingScrollText:String = "";
		 
		
		private const WIDTH:int = 280;
		
		private const HEIGHT:int = 25;
		
		private const MAX_REPEATS:int = 2;
		
		public var scrollText:TextField;
		
		private var timer:Timer;
		
		private const SCROLL_PREPEND:String = "                                                                               ";
		
		private const SCROLL_APPEND:String = "                                                                                ";
		
		private var currentRepeat:uint = 0;
		
		private var scrollOffset:int = 0;
		
		public function NewsTicker() {
			super();
			this.scrollText = this.createScrollText();
			this.timer = new Timer(0.17,0);
			this.drawBackground();
			this.align();
			this.visible = false;
			if(NewsTicker.pendingScrollText != "") {
				this.activateNewScrollText(NewsTicker.pendingScrollText);
				NewsTicker.pendingScrollText = "";
			}
		}
		
		public static function setPendingScrollText(param1:String) : void {
			NewsTicker.pendingScrollText = param1;
		}
		
		public function activateNewScrollText(param1:String) : void {
			if(this.visible == false) {
				this.visible = true;
				StaticInjectorContext.getInjector().getInstance(DisplayAreaChangedSignal).dispatch();
				this.scrollText.text = this.SCROLL_PREPEND + param1 + this.SCROLL_APPEND;
				this.timer.addEventListener(TimerEvent.TIMER,this.scrollAnimation);
				this.currentRepeat = 1;
				this.timer.start();
				return;
			}
		}
		
		private function scrollAnimation(param1:TimerEvent) : void {
			this.timer.stop();
			if(this.scrollText.scrollH < this.scrollText.maxScrollH) {
				this.scrollOffset++;
				this.scrollText.scrollH = this.scrollOffset;
				this.timer.start();
			} else if(this.currentRepeat >= 1 && this.currentRepeat < this.MAX_REPEATS) {
				this.currentRepeat++;
				this.scrollOffset = 0;
				this.scrollText.scrollH = 0;
				this.timer.start();
			} else {
				this.currentRepeat = 0;
				this.scrollOffset = 0;
				this.scrollText.scrollH = 0;
				this.timer.removeEventListener(TimerEvent.TIMER,this.scrollAnimation);
				this.visible = false;
				StaticInjectorContext.getInjector().getInstance(DisplayAreaChangedSignal).dispatch();
			}
		}
		
		private function align() : void {
			this.scrollText.x = 5;
			this.scrollText.y = 2;
		}
		
		private function drawBackground() : void {
			graphics.beginFill(0,0.4);
			graphics.drawRoundRect(0,0,this.WIDTH,this.HEIGHT,12,12);
			graphics.endFill();
		}
		
		private function createScrollText() : TextField {
			var loc1:TextField = null;
			loc1 = new TextField();
			var loc2:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
			loc2.apply(loc1,16,16777215,false);
			loc1.selectable = false;
			loc1.doubleClickEnabled = false;
			loc1.mouseEnabled = false;
			loc1.mouseWheelEnabled = false;
			loc1.text = "";
			loc1.wordWrap = false;
			loc1.multiline = false;
			loc1.selectable = false;
			loc1.width = this.WIDTH - 10;
			loc1.height = 25;
			addChild(loc1);
			return loc1;
		}
	}
}
