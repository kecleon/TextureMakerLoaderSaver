package kabam.rotmg.startup.control {
	import kabam.lib.tasks.BaseTask;
	import kabam.lib.tasks.Task;
	import kabam.rotmg.startup.model.api.StartupDelegate;
	import kabam.rotmg.startup.model.impl.SignalTaskDelegate;
	import kabam.rotmg.startup.model.impl.TaskDelegate;

	import org.swiftsuspenders.Injector;

	import robotlegs.bender.framework.api.ILogger;

	public class StartupSequence extends BaseTask {

		public static const LAST:int = int.MAX_VALUE;


		[Inject]
		public var injector:Injector;

		[Inject]
		public var logger:ILogger;

		private const list:Vector.<StartupDelegate> = new Vector.<StartupDelegate>(0);

		private var index:int = 0;

		public function StartupSequence() {
			super();
		}

		public function addSignal(param1:Class, param2:int = 0):void {
			var loc3:SignalTaskDelegate = new SignalTaskDelegate();
			loc3.injector = this.injector;
			loc3.signalClass = param1;
			loc3.priority = param2;
			this.list.push(loc3);
		}

		public function addTask(param1:Class, param2:int = 0):void {
			var loc3:TaskDelegate = new TaskDelegate();
			loc3.injector = this.injector;
			loc3.taskClass = param1;
			loc3.priority = param2;
			this.list.push(loc3);
		}

		override protected function startTask():void {
			this.list.sort(this.priorityComparison);
			this.index = 0;
			this.doNextTaskOrComplete();
		}

		private function priorityComparison(param1:StartupDelegate, param2:StartupDelegate):int {
			return param1.getPriority() - param2.getPriority();
		}

		private function doNextTaskOrComplete():void {
			if (this.isAnotherTask()) {
				this.doNextTask();
			} else {
				completeTask(true);
			}
		}

		private function isAnotherTask():Boolean {
			return this.index < this.list.length;
		}

		private function doNextTask():void {
			var loc1:Task = this.list[this.index++].make();
			loc1.lastly.addOnce(this.onTaskFinished);
			this.logger.info("StartupSequence start:{0}", [loc1]);
			loc1.start();
		}

		private function onTaskFinished(param1:Task, param2:Boolean, param3:String):void {
			this.logger.info("StartupSequence finish:{0} (isOK: {1})", [param1, param2]);
			if (param2) {
				this.doNextTaskOrComplete();
			} else {
				completeTask(false, param3);
			}
		}
	}
}
