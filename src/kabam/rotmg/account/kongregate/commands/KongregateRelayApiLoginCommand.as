package kabam.rotmg.account.kongregate.commands {
	import kabam.lib.tasks.BranchingTask;
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.rotmg.account.core.services.RelayLoginTask;
	import kabam.rotmg.ui.signals.RefreshScreenAfterLoginSignal;

	public class KongregateRelayApiLoginCommand {


		[Inject]
		public var relay:RelayLoginTask;

		[Inject]
		public var monitor:TaskMonitor;

		[Inject]
		public var refresh:RefreshScreenAfterLoginSignal;

		public function KongregateRelayApiLoginCommand() {
			super();
		}

		public function execute():void {
			var loc1:BranchingTask = new BranchingTask(this.relay);
			loc1.addSuccessTask(new DispatchSignalTask(this.refresh));
			this.monitor.add(loc1);
			loc1.start();
		}
	}
}
