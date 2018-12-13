package kabam.rotmg.promotions.commands {
	import kabam.lib.tasks.BranchingTask;
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.Task;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.lib.tasks.TaskSequence;
	import kabam.rotmg.account.core.Account;
	import kabam.rotmg.account.core.services.GetOffersTask;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.promotions.model.BeginnersPackageModel;
	import kabam.rotmg.promotions.service.GetPackageStatusTask;
	import kabam.rotmg.promotions.view.AlreadyPurchasedBeginnersPackageDialog;
	import kabam.rotmg.promotions.view.BeginnersPackageOfferDialog;

	public class ShowBeginnersPackageCommand {


		[Inject]
		public var account:Account;

		[Inject]
		public var model:BeginnersPackageModel;

		[Inject]
		public var openDialog:OpenDialogSignal;

		[Inject]
		public var getPackageStatusTask:GetPackageStatusTask;

		[Inject]
		public var getOffers:GetOffersTask;

		[Inject]
		public var monitor:TaskMonitor;

		public function ShowBeginnersPackageCommand() {
			super();
		}

		public function execute():void {
			var loc1:BranchingTask = new BranchingTask(this.getPackageStatusTask, this.makeSuccessTask(), this.makeFailureTask());
			this.monitor.add(loc1);
			loc1.start();
		}

		private function makeSuccessTask():Task {
			var loc1:TaskSequence = new TaskSequence();
			this.account.isRegistered() && loc1.add(this.getOffers);
			loc1.add(new DispatchSignalTask(this.openDialog, new BeginnersPackageOfferDialog()));
			return loc1;
		}

		private function makeFailureTask():Task {
			var loc1:TaskSequence = new TaskSequence();
			loc1.add(new DispatchSignalTask(this.openDialog, new AlreadyPurchasedBeginnersPackageDialog()));
			return loc1;
		}
	}
}
