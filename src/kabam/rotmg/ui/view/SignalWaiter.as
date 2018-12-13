 
package kabam.rotmg.ui.view {
	import com.adobe.utils.DictionaryUtil;
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	
	public class SignalWaiter {
		 
		
		public var complete:Signal;
		
		private var texts:Dictionary;
		
		public function SignalWaiter() {
			this.complete = new Signal();
			this.texts = new Dictionary();
			super();
		}
		
		public function push(param1:Signal) : SignalWaiter {
			this.texts[param1] = true;
			this.listenTo(param1);
			return this;
		}
		
		public function pushArgs(... rest) : SignalWaiter {
			var loc2:Signal = null;
			for each(loc2 in rest) {
				this.push(loc2);
			}
			return this;
		}
		
		private function listenTo(param1:Signal) : void {
			var onTextChanged:Function = null;
			var value:Signal = param1;
			onTextChanged = function():void {
				delete texts[value];
				checkEmpty();
			};
			value.addOnce(onTextChanged);
		}
		
		private function checkEmpty() : void {
			if(this.isEmpty()) {
				this.complete.dispatch();
			}
		}
		
		public function isEmpty() : Boolean {
			return DictionaryUtil.getKeys(this.texts).length == 0;
		}
	}
}
