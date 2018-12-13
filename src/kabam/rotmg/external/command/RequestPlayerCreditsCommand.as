package kabam.rotmg.external.command {
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.lib.tasks.TaskSequence;
	import kabam.rotmg.external.service.RequestPlayerCreditsTask;

	import org.swiftsuspenders.Injector;

	import robotlegs.bender.bundles.mvcs.Command;

	public class RequestPlayerCreditsCommand extends Command {


		[Inject]
		public var taskMonitor:TaskMonitor;

		[Inject]
		public var injector:Injector;

		[Inject]
		public var requestPlayerCreditsComplete:RequestPlayerCreditsCompleteSignal;

		public function RequestPlayerCreditsCommand() {
			super();
		}

		override public function execute():void {
			var loc1:TaskSequence = new TaskSequence();
			loc1.add(this.injector.getInstance(RequestPlayerCreditsTask));
			loc1.add(new DispatchSignalTask(this.requestPlayerCreditsComplete));
			this.taskMonitor.add(loc1);
			loc1.start();
		}
	}
}
