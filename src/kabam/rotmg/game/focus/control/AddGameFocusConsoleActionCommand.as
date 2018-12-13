package kabam.rotmg.game.focus.control {
	import kabam.lib.console.signals.RegisterConsoleActionSignal;
	import kabam.lib.console.vo.ConsoleAction;

	public class AddGameFocusConsoleActionCommand {


		[Inject]
		public var register:RegisterConsoleActionSignal;

		[Inject]
		public var setFocus:SetGameFocusSignal;

		public function AddGameFocusConsoleActionCommand() {
			super();
		}

		public function execute():void {
			var loc1:ConsoleAction = null;
			loc1 = new ConsoleAction();
			loc1.name = "follow";
			loc1.description = "follow a game object (by name)";
			this.register.dispatch(loc1, this.setFocus);
		}
	}
}
