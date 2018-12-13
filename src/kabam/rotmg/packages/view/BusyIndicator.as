 
package kabam.rotmg.packages.view {
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class BusyIndicator extends Sprite {
		 
		
		private const pinwheel:Sprite = this.makePinWheel();
		
		private const innerCircleMask:Sprite = this.makeInner();
		
		private const quarterCircleMask:Sprite = this.makeQuarter();
		
		private const timer:Timer = new Timer(25);
		
		private const radius:int = 22;
		
		private const color:uint = 16777215;
		
		public function BusyIndicator() {
			super();
			x = y = this.radius;
			this.addChildren();
			addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
		}
		
		private function makePinWheel() : Sprite {
			var loc1:Sprite = null;
			loc1 = new Sprite();
			loc1.blendMode = BlendMode.LAYER;
			loc1.graphics.beginFill(this.color);
			loc1.graphics.drawCircle(0,0,this.radius);
			loc1.graphics.endFill();
			return loc1;
		}
		
		private function makeInner() : Sprite {
			var loc1:Sprite = new Sprite();
			loc1.blendMode = BlendMode.ERASE;
			loc1.graphics.beginFill(16777215 * 0.6);
			loc1.graphics.drawCircle(0,0,this.radius / 2);
			loc1.graphics.endFill();
			return loc1;
		}
		
		private function makeQuarter() : Sprite {
			var loc1:Sprite = new Sprite();
			loc1.graphics.beginFill(16777215);
			loc1.graphics.drawRect(0,0,this.radius,this.radius);
			loc1.graphics.endFill();
			return loc1;
		}
		
		private function addChildren() : void {
			this.pinwheel.addChild(this.innerCircleMask);
			this.pinwheel.addChild(this.quarterCircleMask);
			this.pinwheel.mask = this.quarterCircleMask;
			addChild(this.pinwheel);
		}
		
		private function onAdded(param1:Event) : void {
			this.timer.addEventListener(TimerEvent.TIMER,this.updatePinwheel);
			this.timer.start();
		}
		
		private function onRemoved(param1:Event) : void {
			this.timer.stop();
			this.timer.removeEventListener(TimerEvent.TIMER,this.updatePinwheel);
		}
		
		private function updatePinwheel(param1:TimerEvent) : void {
			this.quarterCircleMask.rotation = this.quarterCircleMask.rotation + 20;
		}
	}
}
