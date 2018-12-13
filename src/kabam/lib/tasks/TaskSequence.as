package kabam.lib.tasks {
	public class TaskSequence extends BaseTask {


		private var tasks:Vector.<Task>;

		private var index:int;

		private var continueOnFail:Boolean;

		public function TaskSequence() {
			super();
			this.tasks = new Vector.<Task>();
		}

		public function getContinueOnFail():Boolean {
			return this.continueOnFail;
		}

		public function setContinueOnFail(param1:Boolean):void {
			this.continueOnFail = param1;
		}

		public function add(param1:Task):void {
			this.tasks.push(param1);
		}

		override protected function startTask():void {
			this.index = 0;
			this.doNextTaskOrComplete();
		}

		override protected function onReset():void {
			var loc1:Task = null;
			for each(loc1 in this.tasks) {
				loc1.reset();
			}
		}

		private function doNextTaskOrComplete():void {
			if (this.isAnotherTask()) {
				this.doNextTask();
			} else {
				completeTask(true);
			}
		}

		private function isAnotherTask():Boolean {
			return this.index < this.tasks.length;
		}

		private function doNextTask():void {
			var loc1:Task = this.tasks[this.index++];
			loc1.lastly.addOnce(this.onTaskFinished);
			loc1.start();
		}

		private function onTaskFinished(param1:Task, param2:Boolean, param3:String):void {
			if (param2 || this.continueOnFail) {
				this.doNextTaskOrComplete();
			} else {
				completeTask(false, param3);
			}
		}
	}
}
