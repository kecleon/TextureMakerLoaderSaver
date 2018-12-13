package kabam.rotmg.account.web.commands {
	import kabam.lib.tasks.BranchingTask;
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.TaskGroup;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.rotmg.account.core.services.SendPasswordReminderTask;
	import kabam.rotmg.account.web.view.WebLoginDialog;
	import kabam.rotmg.core.signals.TaskErrorSignal;
	import kabam.rotmg.dialogs.control.OpenDialogSignal;

	public class WebSendPasswordReminderCommand {


		[Inject]
		public var email:String;

		[Inject]
		public var task:SendPasswordReminderTask;

		[Inject]
		public var monitor:TaskMonitor;

		[Inject]
		public var taskError:TaskErrorSignal;

		[Inject]
		public var openDialog:OpenDialogSignal;

		public function WebSendPasswordReminderCommand() {
			super();
		}

		public function execute():void {
			var loc1:TaskGroup = new TaskGroup();
			loc1.add(new DispatchSignalTask(this.openDialog, new WebLoginDialog()));
			var loc2:TaskGroup = new TaskGroup();
			loc2.add(new DispatchSignalTask(this.taskError, this.task));
			var loc3:BranchingTask = new BranchingTask(this.task, loc1, loc2);
			this.monitor.add(loc3);
			loc3.start();
		}
	}
}
