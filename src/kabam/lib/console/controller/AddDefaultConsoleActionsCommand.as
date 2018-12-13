package kabam.lib.console.controller {
	import kabam.lib.console.signals.ClearConsoleSignal;
	import kabam.lib.console.signals.CopyConsoleTextSignal;
	import kabam.lib.console.signals.ListActionsSignal;
	import kabam.lib.console.signals.RegisterConsoleActionSignal;
	import kabam.lib.console.signals.RemoveConsoleSignal;
	import kabam.lib.console.vo.ConsoleAction;

	public class AddDefaultConsoleActionsCommand {


		[Inject]
		public var register:RegisterConsoleActionSignal;

		[Inject]
		public var listActions:ListActionsSignal;

		[Inject]
		public var clearConsole:ClearConsoleSignal;

		[Inject]
		public var removeConsole:RemoveConsoleSignal;

		[Inject]
		public var copyConsoleText:CopyConsoleTextSignal;

		public function AddDefaultConsoleActionsCommand() {
			super();
		}

		public function execute():void {
			var loc1:ConsoleAction = null;
			loc1 = new ConsoleAction();
			loc1.name = "list";
			loc1.description = "lists available console commands";
			var loc2:ConsoleAction = new ConsoleAction();
			loc2.name = "clear";
			loc2.description = "clears the console";
			var loc3:ConsoleAction = new ConsoleAction();
			loc3.name = "exit";
			loc3.description = "closes the console";
			var loc4:ConsoleAction = new ConsoleAction();
			loc4.name = "copy";
			loc4.description = "copies the contents of the console to the clipboard";
			this.register.dispatch(loc1, this.listActions);
			this.register.dispatch(loc2, this.clearConsole);
			this.register.dispatch(loc3, this.removeConsole);
			this.register.dispatch(loc4, this.copyConsoleText);
		}
	}
}
