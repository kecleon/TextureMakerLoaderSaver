 
package kabam.rotmg.characters.reskin.control {
	import kabam.lib.console.signals.RegisterConsoleActionSignal;
	import kabam.lib.console.vo.ConsoleAction;
	
	public class AddReskinConsoleActionCommand {
		 
		
		[Inject]
		public var register:RegisterConsoleActionSignal;
		
		[Inject]
		public var openReskinDialogSignal:OpenReskinDialogSignal;
		
		public function AddReskinConsoleActionCommand() {
			super();
		}
		
		public function execute() : void {
			var loc1:ConsoleAction = null;
			loc1 = new ConsoleAction();
			loc1.name = "reskin";
			loc1.description = "opens the reskin UI";
			this.register.dispatch(loc1,this.openReskinDialogSignal);
		}
	}
}
