package kabam.rotmg.editor.commands {
	import kabam.lib.tasks.DispatchSignalTask;
	import kabam.lib.tasks.TaskMonitor;
	import kabam.lib.tasks.TaskSequence;
	import kabam.rotmg.dialogs.control.CloseDialogsSignal;
	import kabam.rotmg.editor.services.SaveTextureTask;

	public class SaveTextureCommand {


		[Inject]
		public var task:SaveTextureTask;

		[Inject]
		public var monitor:TaskMonitor;

		[Inject]
		public var closeDialog:CloseDialogsSignal;

		public function SaveTextureCommand() {
			super();
		}

		public function execute():void {
			var loc1:TaskSequence = new TaskSequence();
			loc1.add(this.task);
			loc1.add(new DispatchSignalTask(this.closeDialog));
			this.monitor.add(loc1);
			loc1.start();
		}
	}
}
