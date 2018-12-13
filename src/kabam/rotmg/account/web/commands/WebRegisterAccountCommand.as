 
package kabam.rotmg.account.web.commands {
	import kabam.lib.tasks.BranchingTask;
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.Task;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.lib.tasks.TaskSequence;
	import kabam.rotmg.account.core.services.RegisterAccountTask;
	import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
	import kabam.rotmg.account.web.view.WebAccountDetailDialog;
	import kabam.rotmg.core.service.TrackingData;
	import kabam.rotmg.core.signals.TaskErrorSignal;
	import kabam.rotmg.core.signals.TrackEventSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;
	import kabam.rotmg.ui.signals.EnterGameSignal;
	
	public class WebRegisterAccountCommand {
		 
		
		[Inject]
		public var task:RegisterAccountTask;
		
		[Inject]
		public var monitor:TaskMonitor;
		
		[Inject]
		public var taskError:TaskErrorSignal;
		
		[Inject]
		public var updateAccount:UpdateAccountInfoSignal;
		
		[Inject]
		public var openDialog:OpenDialogSignal;
		
		[Inject]
		public var track:TrackEventSignal;
		
		[Inject]
		public var enterGame:EnterGameSignal;
		
		public function WebRegisterAccountCommand() {
			super();
		}
		
		public function execute() : void {
			var loc1:BranchingTask = new BranchingTask(this.task,this.makeSuccess(),this.makeFailure());
			this.monitor.add(loc1);
			loc1.start();
		}
		
		private function makeSuccess() : Task {
			var loc1:TaskSequence = new TaskSequence();
			loc1.add(new DispatchSignalTask(this.updateAccount));
			loc1.add(new DispatchSignalTask(this.openDialog,new WebAccountDetailDialog()));
			loc1.add(new DispatchSignalTask(this.enterGame));
			return loc1;
		}
		
		private function makeFailure() : DispatchSignalTask {
			return new DispatchSignalTask(this.taskError,this.task);
		}
		
		private function getTrackingData() : TrackingData {
			var loc1:TrackingData = new TrackingData();
			loc1.category = "account";
			loc1.action = "accountRegistered";
			return loc1;
		}
	}
}
