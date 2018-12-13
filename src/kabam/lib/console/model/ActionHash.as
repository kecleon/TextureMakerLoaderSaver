 
package kabam.lib.console.model {
	import org.osflash.signals.Signal;
	
	final class ActionHash {
		 
		
		private var signalMap:Object;
		
		private var descriptionMap:Object;
		
		function ActionHash() {
			super();
			this.signalMap = {};
			this.descriptionMap = {};
		}
		
		public function register(param1:String, param2:String, param3:Signal) : void {
			this.signalMap[param1] = param3;
			this.descriptionMap[param1] = param2;
		}
		
		public function getNames() : Vector.<String> {
			var loc2:* = null;
			var loc1:Vector.<String> = new Vector.<String>(0);
			for(loc2 in this.signalMap) {
				loc1.push(loc2 + " - " + this.descriptionMap[loc2]);
			}
			return loc1;
		}
		
		public function execute(param1:String) : void {
			var loc2:Array = param1.split(" ");
			if(loc2.length == 0) {
				return;
			}
			var loc3:String = loc2.shift();
			var loc4:Signal = this.signalMap[loc3];
			if(!loc4) {
				return;
			}
			if(loc2.length > 0) {
				loc4.dispatch.apply(this,loc2.join(" ").split(","));
			} else {
				loc4.dispatch.apply(this);
			}
		}
		
		public function has(param1:String) : Boolean {
			var loc2:Array = param1.split(" ");
			return loc2.length > 0 && this.signalMap[loc2[0]] != null;
		}
	}
}
