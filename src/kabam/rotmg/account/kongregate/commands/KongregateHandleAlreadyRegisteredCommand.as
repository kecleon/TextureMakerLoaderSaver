package kabam.rotmg.account.kongregate.commands {
	import kabam.lib.tasks.BranchingTask;
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.rotmg.account.core.services.LoginTask;
	import kabam.rotmg.ui.signals.RefreshScreenAfterLoginSignal;

	public class KongregateHandleAlreadyRegisteredCommand {


		[Inject]
		public var login:LoginTask;

		[Inject]
		public var monitor:TaskMonitor;

		[Inject]
		public var refresh:RefreshScreenAfterLoginSignal;

		public function KongregateHandleAlreadyRegisteredCommand() {
			super();
		}

		public function execute():void {
			var loc1:BranchingTask = new BranchingTask(this.login);
			loc1.addSuccessTask(new DispatchSignalTask(this.refresh));
			this.monitor.add(loc1);
			loc1.start();
		}
	}
}
