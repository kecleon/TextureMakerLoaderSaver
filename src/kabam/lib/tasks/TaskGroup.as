package kabam.lib.tasks {
	public class TaskGroup extends BaseTask {


		private var tasks:Vector.<BaseTask>;

		private var pending:int;

		public function TaskGroup() {
			super();
			this.tasks = new Vector.<BaseTask>();
		}

		public function add(param1:BaseTask):void {
			this.tasks.push(param1);
		}

		override protected function startTask():void {
			this.pending = this.tasks.length;
			if (this.pending > 0) {
				this.startAllTasks();
			} else {
				completeTask(true);
			}
		}

		override protected function onReset():void {
			var loc1:BaseTask = null;
			for each(loc1 in this.tasks) {
				loc1.reset();
			}
		}

		private function startAllTasks():void {
			var loc1:int = this.pending;
			while (loc1--) {
				this.tasks[loc1].lastly.addOnce(this.onTaskFinished);
				this.tasks[loc1].start();
			}
		}

		private function onTaskFinished(param1:BaseTask, param2:Boolean, param3:String):void {
			if (param2) {
				if (--this.pending == 0) {
					completeTask(true);
				}
			} else {
				completeTask(false, param3);
			}
		}

		public function toString():String {
			return "[TaskGroup(" + this.tasks.join(",") + ")]";
		}
	}
}
