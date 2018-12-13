package kabam.rotmg.account.core.commands {
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.lib.tasks.TaskSequence;
	import kabam.rotmg.account.core.services.PurchaseGoldTask;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;

	import robotlegs.bender.framework.api.ILogger;

	public class PurchaseGoldCommand {


		[Inject]
		public var purchaseGold:PurchaseGoldTask;

		[Inject]
		public var monitor:TaskMonitor;

		[Inject]
		public var closeDialog:CloseDialogsSignal;

		[Inject]
		public var logger:ILogger;

		public function PurchaseGoldCommand() {
			super();
		}

		public function execute():void {
			this.logger.debug("execute");
			var loc1:TaskSequence = new TaskSequence();
			loc1.add(this.purchaseGold);
			loc1.add(new DispatchSignalTask(this.closeDialog));
			this.monitor.add(loc1);
			loc1.start();
		}
	}
}
