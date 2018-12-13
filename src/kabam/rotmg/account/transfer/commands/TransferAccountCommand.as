 
package kabam.rotmg.account.transfer.commands {
	import com.company.assembleegameclient.ui.dialogs.DebugDialog;
	import com.company.util.HTMLUtil;
	import kabam.lib.tasks.BranchingTask;
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.Task;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.lib.tasks.TaskSequence;
	import kabam.rotmg.account.core.services.MigrateAccountTask;
	import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
	import kabam.rotmg.account.transfer.model.TransferAccountData;
	import kabam.rotmg.application.model.PlatformModel;
	import kabam.rotmg.core.StaticInjectorContext;
	import kabam.rotmg.core.signals.TaskErrorSignal;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	
	public class TransferAccountCommand {
		 
		
		[Inject]
		public var task:MigrateAccountTask;
		
		[Inject]
		public var updateAccount:UpdateAccountInfoSignal;
		
		[Inject]
		public var taskError:TaskErrorSignal;
		
		[Inject]
		public var monitor:TaskMonitor;
		
		[Inject]
		public var close:CloseDialogsSignal;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var loginError:TaskErrorSignal;
		
		[Inject]
		public var data:TransferAccountData;
		
		public function TransferAccountCommand() {
			super();
		}
		
		public function execute() : void {
			var loc1:BranchingTask = new BranchingTask(this.task,this.makeSuccess(),this.makeFailure());
			this.monitor.add(loc1);
			loc1.start();
		}
		
		private function makeSuccess() : Task {
			var loc1:TaskSequence = new TaskSequence();
			var loc2:PlatformModel = StaticInjectorContext.getInjector().getInstance(PlatformModel);
			loc1.add(new DispatchSignalTask(this.updateAccount));
			loc1.add(new DispatchSignalTask(this.openDialog,new DebugDialog(this.data.newEmail + " please check your inbox.","Email Verification Sent!",HTMLUtil.refreshPageNoParams)));
			return loc1;
		}
		
		private function makeFailure() : Task {
			return new DispatchSignalTask(this.loginError,this.task);
		}
	}
}
