 
package io.decagames.rotmg.pets.commands {
	import io.decagames.rotmg.pets.signals.OpenCaretakerQueryDialogSignal;
	import kabam.lib.console.signals.RegisterConsoleActionSignal;
	import kabam.lib.console.vo.ConsoleAction;
	
	public class AddPetsConsoleActionsCommand {
		 
		
		[Inject]
		public var register:RegisterConsoleActionSignal;
		
		[Inject]
		public var openCaretakerQuerySignal:OpenCaretakerQueryDialogSignal;
		
		public function AddPetsConsoleActionsCommand() {
			super();
		}
		
		public function execute() : void {
			var loc1:ConsoleAction = null;
			loc1 = new ConsoleAction();
			loc1.name = "caretaker";
			loc1.description = "opens the pets caretaker query UI";
			this.register.dispatch(loc1,this.openCaretakerQuerySignal);
		}
	}
}
