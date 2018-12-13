package kabam.lib.console.controller {
	import kabam.lib.console.model.Console;
	import kabam.lib.console.signals.ConsoleLogSignal;

	public final class ListActionsCommand {


		[Inject]
		public var console:Console;

		[Inject]
		public var log:ConsoleLogSignal;

		public function ListActionsCommand() {
			super();
		}

		public function execute():void {
			var loc1:String = "  " + this.console.getNames().join("\r  ");
			this.log.dispatch(loc1);
		}
	}
}
