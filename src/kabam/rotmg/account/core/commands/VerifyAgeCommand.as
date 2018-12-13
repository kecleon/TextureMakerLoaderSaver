package kabam.rotmg.account.core.commands {
	import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
	import com.company.assembleegameclient.ui.dialogs.ErrorDialog;

	import kabam.lib.tasks.BranchingTask;
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.Task;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.rotmg.account.core.services.VerifyAgeTask;
	import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;

	public class VerifyAgeCommand {


		private const UNABLE_TO_VERIFY:String = "Unable to verify age";

		[Inject]
		public var task:VerifyAgeTask;

		[Inject]
		public var monitor:TaskMonitor;

		[Inject]
		public var setScreen:SetScreenWithValidDataSignal;

		[Inject]
		public var openDialog:OpenDialogSignal;

		public function VerifyAgeCommand() {
			super();
		}

		public function execute():void {
			var loc1:BranchingTask = new BranchingTask(this.task);
			loc1.addSuccessTask(this.makeSuccessTask());
			loc1.addFailureTask(this.makeFailureTask());
			this.monitor.add(loc1);
			loc1.start();
		}

		private function makeSuccessTask():Task {
			return new DispatchSignalTask(this.setScreen, new CharacterSelectionAndNewsScreen());
		}

		private function makeFailureTask():Task {
			return new DispatchSignalTask(this.openDialog, new ErrorDialog(this.UNABLE_TO_VERIFY));
		}
	}
}
