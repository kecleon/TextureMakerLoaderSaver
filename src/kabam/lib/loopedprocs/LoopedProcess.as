 
package kabam.lib.loopedprocs {
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class LoopedProcess {
		
		private static var maxId:uint;
		
		private static var loopProcs:Dictionary = new Dictionary();
		 
		
		public var id:uint;
		
		public var paused:Boolean;
		
		public var interval:uint;
		
		public var lastRun:int;
		
		public function LoopedProcess(param1:uint) {
			super();
			this.interval = param1;
		}
		
		public static function addProcess(param1:LoopedProcess) : uint {
			if(loopProcs[param1.id] == param1) {
				return param1.id;
			}
			var loc2:* = ++maxId;
			loopProcs[loc2] = param1;
			param1.lastRun = getTimer();
			return maxId;
		}
		
		public static function runProcesses(param1:int) : void {
			var loc2:LoopedProcess = null;
			var loc3:int = 0;
			for each(loc2 in loopProcs) {
				if(!loc2.paused) {
					loc3 = param1 - loc2.lastRun;
					if(loc3 >= loc2.interval) {
						loc2.lastRun = param1;
						loc2.run();
					}
				}
			}
		}
		
		public static function destroyProcess(param1:LoopedProcess) : void {
			delete loopProcs[param1.id];
			param1.onDestroyed();
		}
		
		public static function destroyAll() : void {
			var loc1:LoopedProcess = null;
			for each(loc1 in loopProcs) {
				loc1.destroy();
			}
			loopProcs = new Dictionary();
		}
		
		public final function add() : void {
			addProcess(this);
		}
		
		public final function destroy() : void {
			destroyProcess(this);
		}
		
		protected function run() : void {
		}
		
		protected function onDestroyed() : void {
		}
	}
}
