 
package kabam.rotmg.ui.model {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	public class PotionModel {
		 
		
		public var objectId:uint;
		
		private var _costs:Array;
		
		private var _priceCooldownMillis:uint;
		
		public var _purchaseCooldownMillis:uint;
		
		public var maxPotionCount:int;
		
		public var position:int;
		
		public var available:Boolean;
		
		private var costIndex:int;
		
		private var costCoolDownTimer:Timer;
		
		private var costTimerSignal:NativeSignal;
		
		private var purchaseCoolDownTimer:Timer;
		
		private var purchaseTimerSignal:NativeSignal;
		
		public var update:Signal;
		
		public function PotionModel() {
			super();
			this.update = new Signal(int);
			this.available = true;
		}
		
		public function set costs(param1:Array) : void {
			this._costs = param1;
			if(param1 != null && param1.length > 0) {
				this.costIndex = 0;
			}
		}
		
		public function get costs() : Array {
			return this._costs;
		}
		
		public function set priceCooldownMillis(param1:uint) : void {
			this._priceCooldownMillis = param1;
			this.costCoolDownTimer = new Timer(param1,0);
			this.costTimerSignal = new NativeSignal(this.costCoolDownTimer,TimerEvent.TIMER,TimerEvent);
			this.costTimerSignal.add(this.coolDownPrice);
		}
		
		public function set purchaseCooldownMillis(param1:uint) : void {
			this._purchaseCooldownMillis = param1;
			this.purchaseCoolDownTimer = new Timer(param1,0);
			this.purchaseTimerSignal = new NativeSignal(this.purchaseCoolDownTimer,TimerEvent.TIMER,TimerEvent);
			this.purchaseTimerSignal.add(this.coolDownPurchase);
		}
		
		public function purchasedPot() : void {
			if(this.available) {
				this.costCoolDownTimer.reset();
				this.costCoolDownTimer.start();
				this.purchaseCoolDownTimer.reset();
				this.purchaseCoolDownTimer.start();
				this.available = false;
				if(this.costIndex < this.costs.length - 1) {
					this.costIndex++;
				}
				this.update.dispatch(this.position);
			}
		}
		
		private function coolDownPurchase(param1:TimerEvent) : void {
			if(this.costIndex == 0) {
				this.purchaseCoolDownTimer.stop();
			}
			this.available = true;
			this.update.dispatch(this.position);
		}
		
		private function coolDownPrice(param1:TimerEvent) : void {
			this.costIndex--;
			if(this.costIndex == 0) {
				this.costCoolDownTimer.stop();
			}
			this.update.dispatch(this.position);
		}
		
		public function currentCost(param1:int) : int {
			var loc2:int = 0;
			if(param1 <= 0) {
				loc2 = this.costs[this.costIndex];
			}
			return loc2;
		}
	}
}
