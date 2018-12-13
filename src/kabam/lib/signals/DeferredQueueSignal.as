package kabam.lib.signals {
	import org.osflash.signals.ISlot;
	import org.osflash.signals.Signal;

	public class DeferredQueueSignal extends Signal {


		private var data:Array;

		private var log:Boolean = true;

		public function DeferredQueueSignal(...rest) {
			this.data = [];
			super(rest);
		}

		override public function dispatch(...rest):void {
			if (this.log) {
				this.data.push(rest);
			}
			super.dispatch.apply(this, rest);
		}

		override public function add(param1:Function):ISlot {
			var loc2:ISlot = super.add(param1);
			while (this.data.length > 0) {
				param1.apply(this, this.data.shift());
			}
			this.log = false;
			return loc2;
		}

		override public function addOnce(param1:Function):ISlot {
			var loc2:ISlot = null;
			if (this.data.length > 0) {
				param1.apply(this, this.data.shift());
			} else {
				loc2 = super.addOnce(param1);
				this.log = false;
			}
			while (this.data.length > 0) {
				this.data.shift();
			}
			return loc2;
		}

		public function getNumData():int {
			return this.data.length;
		}
	}
}
