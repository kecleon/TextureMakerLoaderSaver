 
package kabam.rotmg.account.web.commands {
	import kabam.lib.tasks.BranchingTask;
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.Task;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.lib.tasks.TaskSequence;
	import kabam.rotmg.account.core.services.ChangePasswordTask;
	import kabam.rotmg.account.web.view.WebAccountDetailDialog;
	import kabam.rotmg.core.service.TrackingData;
	import kabam.rotmg.core.signals.TaskErrorSignal;
	import kabam.rotmg.core.signals.TrackEventSignal;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	
	public class WebChangePasswordCommand {
		 
		
		[Inject]
		public var task:ChangePasswordTask;
		
		[Inject]
		public var monitor:TaskMonitor;
		
		[Inject]
		public var close:CloseDialogsSignal;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var loginError:TaskErrorSignal;
		
		[Inject]
		public var track:TrackEventSignal;
		
		public function WebChangePasswordCommand() {
			super();
		}
		
		public function execute() : void {
			var loc1:BranchingTask = new BranchingTask(this.task,this.makeSuccess(),this.makeFailure());
			this.monitor.add(loc1);
			loc1.start();
		}
		
		private function makeSuccess() : Task {
			var loc1:TaskSequence = new TaskSequence();
			loc1.add(new DispatchSignalTask(this.openDialog,new WebAccountDetailDialog()));
			return loc1;
		}
		
		private function makeFailure() : Task {
			return new DispatchSignalTask(this.loginError,this.task);
		}
		
		private function makeTrackingData() : TrackingData {
			var loc1:TrackingData = new TrackingData();
			loc1.category = "account";
			loc1.action = "passwordChanged";
			return loc1;
		}
	}
}
